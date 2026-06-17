# Blueprint Writer Report

## Slug
keystone-equalizer

## Status
COMPLETE — the keystone proof is re-routed to the sheaf-axiom equalizer and decomposed into a
`\uses`-linked chain of four new sub-lemmas; the circular dependence on
`lem:isLocalizedModule_of_span_cover` is removed from the keystone (and from the route-decomposition
remark).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### New sub-lemma chain (inserted immediately before the keystone block)
- **Added lemma** `\label{lem:qcoh_section_equalizer}` / `\lean{AlgebraicGeometry.qcoh_section_equalizer}`
  — the degree-0/1 sheaf-axiom equalizer
  `0 → Γ(W,F) → ∏ⱼ Γ(W∩D(gⱼ),F) → ∏_{j,k} Γ(W∩D(gⱼgₖ),F)` (`Function.Exact` + injectivity), stated for a
  general open `W` and a finite family covering `W` so it serves both the `W=X` and `W=D(f)` instances.
  Proof: the sheaf condition of the sheaf of modules read off in degrees 0/1. No external citation
  (project-bespoke specialization, as the directive authorizes).
  - Proof sketch added: Y (sheaf axiom → injectivity + matching-family gluing).
- **Added Mathlib anchor** `\label{lem:localized_module_map_exact_mathlib}` /
  `\lean{IsLocalizedModule.map_exact}` `\mathlibok` — localisation at a submonoid sends an exact sequence
  to an exact sequence (exactness of localisation; commutes with kernels). Verified the real Mathlib name
  via loogle: `IsLocalizedModule.map_exact` in `Mathlib.Algebra.Module.LocalizedModule.Exact`, signature
  `(ex : Function.Exact g h) : Function.Exact (map S f₀ f₁ g) (map S f₁ f₂ h)`. This is the ONLY
  `\mathlibok` I added.
- **Added lemma** `\label{lem:tile_section_localization}` /
  `\lean{AlgebraicGeometry.tile_section_localization}` — per cover/overlap element `g` (= `gⱼ` or
  `gⱼgₖ`), `Γ(D(g),F)_f ≅ Γ(D(gf),F)`, i.e. `IsLocalizedModule (powers f)` of the section restriction.
  `\uses{lem:qcoh_finite_presentation_cover, lem:presentation_modulesRestrictBasicOpen,
  lem:section_isLocalizedModule_of_presentation, lem:restrict_obj_mathlib}`. Proof: B4 presents the tile
  globally → `section_isLocalizedModule_of_presentation` localises on the tile → `restrict_obj` (rfl)
  transports the section comparison. Emphasises the localisation is on the TILE (tilde), never the global
  object — the non-circularity hinge.
  - Proof sketch added: Y.
- **Added lemma** `\label{lem:qcoh_section_kernel_comparison}` /
  `\lean{AlgebraicGeometry.qcoh_section_kernel_comparison}` — the canonical lift
  `Γ(X,F)_f → Γ(D(f),F)` of `ρ_f` is an isomorphism. `\uses{lem:qcoh_finite_presentation_cover,
  lem:qcoh_section_equalizer, lem:localized_module_map_exact_mathlib, lem:tile_section_localization}`.
  Proof: write both equalizers (X-cover and D(f)-cover) via `lem:qcoh_section_equalizer`; localise the
  X-equalizer at `f` (`lem:localized_module_map_exact_mathlib`, + localisation commutes with finite
  products); match the two term-by-term via the per-tile isos (`lem:tile_section_localization`); the
  intertwining squares (naturality of restriction-vs-localisation, the degree-0/1 analogue of the
  project's `qcohRestriction_eq_comparison`) make the kernels isomorphic, and the first square identifies
  the induced kernel iso with the `ρ_f`-lift.
  - Proof sketch added: Y.

### Keystone re-route
- **Revised** `lem:qcoh_section_isLocalizedModule` — statement-block `\uses{}` changed to
  `{lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer,
  lem:localized_module_map_exact_mathlib, lem:tile_section_localization,
  lem:qcoh_section_kernel_comparison, lem:section_isLocalizedModule_of_presentation}`; **deleted** the
  circular `lem:isLocalizedModule_of_span_cover` (and the now-irrelevant
  `lem:exists_finite_basicOpen_subcover`, `lem:presentation_modulesRestrictBasicOpen` direct edges, which
  are now reached transitively through the new chain). The `% NOTE` route comment rewritten to describe
  the sheaf-axiom equalizer route instead of the old B1–B6/span-cover chain. **Statement prose and all
  `% SOURCE`/`% SOURCE QUOTE`/`% SOURCE QUOTE PROOF` (Stacks 01HV(4)) lines kept verbatim.**
- **Revised** keystone `\begin{proof}` — fully rewritten to the kernel-comparison route: B1 cover →
  `ρ_f` is `IsLocalizedModule` iff its localisation lift is iso → that lift is iso by
  `lem:qcoh_section_kernel_comparison` (with its three inputs spelled out) → conclude. Retained and
  sharpened the non-circularity paragraph (the only "sections-localise" inputs are the per-tile
  localisations; the global statement is recovered by the sheaf axiom + exactness of localisation, never
  by an abstract-localized-module identification of `Γ(X,F)`).

### Consistency fix (route-decomposition remark)
- **Revised** `rem:o1i8_decomposition` — its `\uses{}` had the now-wrong
  `lem:isLocalizedModule_of_span_cover` and `lem:cech_acyclic_affine` for the keystone; replaced with the
  new chain labels (`lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer,
  lem:localized_module_map_exact_mathlib, lem:tile_section_localization,
  lem:qcoh_section_kernel_comparison`). Rewrote the P1 (Keystone) bullet to describe the equalizer route.
  This is a remark in the same chapter, not a DONE B0–B4 block.

## Cross-references introduced
- `lem:qcoh_section_equalizer`, `lem:localized_module_map_exact_mathlib`,
  `lem:tile_section_localization`, `lem:qcoh_section_kernel_comparison` — all new, all in THIS chapter.
- New `\uses` edges from the keystone proof and `rem:o1i8_decomposition` to the four new labels — all
  resolve (verified with leandag, see below).
- `lem:tile_section_localization` `\uses` the DONE pieces `lem:qcoh_finite_presentation_cover`,
  `lem:presentation_modulesRestrictBasicOpen`, `lem:section_isLocalizedModule_of_presentation`,
  `lem:restrict_obj_mathlib` (all pre-existing in this chapter).

## leandag verification
- `leandag build --json`: `unknown_uses: []` (no broken `\uses`).
- `leandag query --isolated --chapter Cohomology_CechHigherDirectImage`: 0 results — none of the four new
  blocks (nor any other) is isolated.
- Confirmed `lem:isLocalizedModule_of_span_cover` and `lem:cech_acyclic_affine` remain referenced
  elsewhere (`lem:qcoh_localized_sections` still `\uses` the former; the Čech apparatus still `\uses` the
  latter), so neither was orphaned by the removals.
- `\begin`/`\end` balance for lemma/proof/definition/remark environments: 220/220.
- Markers added by me: exactly one `\mathlibok` (on `lem:localized_module_map_exact_mathlib`); zero
  `\leanok`.

## References consulted
- `analogies/keystone-descent.md` (iter-041) — source of truth for the non-circular route (D1/D2/D3,
  the four-step equalizer recommendation); drove the entire decomposition.
- No `references/**` files opened for new citations: the four new sub-lemmas are project-bespoke and
  stand on their informal proofs (directive-authorized); the keystone keeps its already-present Stacks
  01HV(4) verbatim quote untouched. No reference-retriever dispatched (none needed).

## Macros needed (if any)
- None. Only `\Spec` (already in `macros/common.tex`) and standard operators/`\operatorname{...}` are
  used; `\operatorname{Function.Exact}` matches existing chapter usage.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **`lem:qcoh_localized_sections` (around L5012) looks circular by the same mechanism the keystone just
  shed.** Its proof refines to a finite cover, asserts `F|_{D(sⱼ)} ≅ M̃ⱼ` "by the affine structure
  theorem" (= 01I8, the very theorem the keystone feeds), then descends via
  `lem:isLocalizedModule_of_span_cover`. If this lemma is on any live path to 01I8 it is unsound for the
  same reason flagged for the keystone; if it is only a Route-A dormant asset it is harmless. It was OUT
  OF SCOPE for this directive (not the keystone), so I left it untouched — recommend a follow-up
  blueprint-writer/​reviewer pass to either re-route it through the new
  `lem:qcoh_section_kernel_comparison`/equalizer chain or confirm it is off the critical path.
- **The sheaf condition of `(Spec R).Modules` is invoked in the equalizer proof as a structural property
  in prose, not as a separate `\uses` node.** I deliberately did NOT create a second Mathlib anchor for
  it, because the directive restricts `\mathlibok` to `lem:localized_module_map_exact_mathlib` only. If
  the reviewer prefers an explicit node, a `\mathlibok` anchor on the underlying-sheaf condition of a
  `SheafOfModules` (e.g. `SheafOfModules`'s `.isSheaf` / `Presheaf.IsSheaf` equalizer form) would give
  `lem:qcoh_section_equalizer` a clean outgoing edge; it is currently non-isolated via its incoming edges
  from the keystone and kernel-comparison.
- The prover building `AlgebraicGeometry.qcoh_section_kernel_comparison` should confirm the precise
  Mathlib spelling of "localisation commutes with finite products" (used implicitly in step 2); it is
  standard but I did not pin a `\lean{}` for it (kept inside the one anchor + prose).

## Strategy-modifying findings
- None. The re-route is internal to the chapter and matches the strategy recorded in
  `analogies/keystone-descent.md`; it removes an unsound proof rather than changing any downstream
  consequence. (The `lem:qcoh_localized_sections` concern above is a possible *chapter-cleanup* item, not
  a strategy change — the keystone route itself is now sound.)
