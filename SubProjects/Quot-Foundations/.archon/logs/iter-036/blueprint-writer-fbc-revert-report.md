# Blueprint Writer Report

## Slug
fbc-revert

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

- **Removed** the explicit-inverse subsection and its three blocks (directive item 1):
  `\subsection{The section-level isomorphism via an explicit inverse}` /
  `\label{subsec:section_explicit_inverse}`, plus
  `def:base_change_mate_section_inverse`, `lem:base_change_mate_section_map_inverse_id`,
  `lem:base_change_mate_section_inverse_map_id`. Deleted as one contiguous block (header +
  intro prose + the three declarations) — no dangling `\begin`/`\end`. Verified against the
  live Lean: these labels name **no** Lean declarations (`grep` over `AlgebraicJacobian/`
  returns none), so the blocks were blueprint-only orphans on a documented-dead route.

- **Reverted** `lem:pushforward_base_change_mate_cancelBaseChange` to the conjugate route
  (directive item 2), re-aligning with the live Lean body (`FlatBaseChange.lean:2221`, which
  routes `haveI hconj := base_change_mate_generator_trace …`):
  - statement `\uses` and proof `\uses` now route through
    `lem:base_change_mate_generator_trace`, `lem:base_change_mate_section_identity`,
    `lem:base_change_mate_gstar_transpose`; dropped `def:base_change_mate_section_inverse`,
    `lem:base_change_mate_section_map_inverse_id`, `lem:base_change_mate_section_inverse_map_id`.
  - proof prose restored to the adjoint-mate / generator-trace derivation: `IsIso θ` from
    `generator_trace` ⟹ `Γ(α)` iso by conjugating back
    (`Γ(α) = Θ_src ≫ θ ≫ Θ_tgt⁻¹`), no flatness. Statement value (`= cancelBaseChange`)
    and the 02KH source quote kept intact. NOTE comments rewritten to the conjugation route.

- **Removed the "superseded" framing** (directive item 3):
  - deleted the `\begin{remark}[The conjugate-side leg-reindex chain is superseded]` block
    (the "inert scaffolding" remark naming conj-1a/1b, conj-2b/2c/2d, conj-2a,
    `conjPullbackFactor`, `gstar_transpose`, `section_identity`, `generator_trace`).
  - replaced the `% NOTE: SUPERSEDED` comment on `lem:base_change_mate_gstar_transpose` with a
    NOTE describing it as the live residual crux (the base-change map is *defined* as the
    transpose; `huce` is landed/compiling).
  - rewrote the `\subsection{The section-level base-change identity}` head prose: now describes
    the conjugate-counit calculus (transpose → `Adjunction.homEquiv_counit` → counit
    factorization → dictionary conjugation), names the live dependency chain
    `cancelBaseChange → generator_trace → section_identity → gstar_transpose`, and records that
    per-generator/element evaluation is a dead end.

- **Sharpened** `lem:base_change_mate_gstar_transpose`'s proof block to the concrete `huce`
  remainder (directive item 4):
  - proof prose now states the **master counit-transport identity** (the
    `conjugateEquiv_counit_symm` instantiation at `adjL`/`adjR` with `α = β.hom`, dictionary
    via the conjugate of `β.hom` = `Π_ψ⁻¹`), then the three telescoping steps:
    **(a)** inner reindex `Γ_R(θ_in) = ρ`, reproven *inline* from
    `…_legs_unitExpand` + `…_legs_gammaDistribute` + `gammaMap_pushforwardComp_{hom,inv}_eq_id`
    + Seam-1 `unit_value` + `pullbackPushforward_unit_comp` (explicitly NOT via the sorry-backed
    `…_fstar_reindex_legs` / `inner_value_eq`); **(b)** one-generator close
    `ext_ψ(ρ) ≫ ε^alg = regroup⁻¹` on `r'⊗m ↦ (1⊗r')⊗m`, a one-generator `ext` against
    `regroupEquiv`; **(c)** dictionary cancellation matching `huce`'s `pullback_spec_tilde_iso` /
    tilde-counit factors against `Θ_src`/`Θ_tgt`.
  - proof `\uses` set to exactly:
    `lem:base_change_mate_fstar_reindex_legs_unitExpand`,
    `lem:base_change_mate_fstar_reindex_legs_gammaDistribute`,
    `lem:base_change_mate_unit_value`, `lem:pullbackPushforward_unit_comp`,
    `lem:base_change_mate_regroupEquiv`, `lem:conjugateEquiv_counit_symm_mathlib`,
    `lem:pullback_spec_tilde_iso`, `lem:gammaMap_pushforwardComp_hom_eq_id`,
    `lem:gammaMap_pushforwardComp_inv_eq_id`. Did NOT `\uses`
    `lem:base_change_mate_fstar_reindex_legs` / conj-2a (deliberately bypassed).
  - statement `\uses` updated to the statement-level objects + `huce` anchor:
    `domain_read`, `codomain_read`, `regroupEquiv`, `pullback_spec_tilde_iso`,
    `base_change_mate_unit_value`, `conjugateEquiv_counit_symm_mathlib` (dropped the
    sorry-routed `inner_value_eq` / `fstar_reindex_legs` / Seam wrappers from the statement edge).
  - the `% NOTE (mechanism)` comment updated: inner value reproven inline, not via the
    sorry-backed wrapper. No `\leanok` added or touched.

- **Added Mathlib dependency anchor** `lem:conjugateEquiv_counit_symm_mathlib`
  (`\lean{CategoryTheory.conjugateEquiv_counit_symm}`, `\mathlibok`) — the `huce` source. Placed
  immediately after the existing unit anchor `lem:unit_conjugateEquiv_symm_mathlib`, mirroring its
  statement style; the counit dual. Verified the Lean name is the one the live source consumes
  (`FlatBaseChange.lean:2079`, `CategoryTheory.conjugateEquiv_counit_symm adjL adjR β.hom W`,
  already compiling), so `\mathlibok` is faithful.

## Kept unchanged (route-independent fixes, per directive)
- `lem:base_change_mate_codomain_read_legs` (pullbackComp variable-legs form) — untouched.
- The 4 coverage-debt blocks: `def:base_change_mate_codomain_read_legs_param`,
  `lem:base_change_mate_codomain_read_legs_eq_param`, `def:conjPullbackFactor`,
  `lem:conjPullbackFactor_eq_pullbackComp` — untouched.
- `lem:gammaMap_pushforwardCongr_hom` (eqToHom form) — untouched.
- The three Seam-helper lemmas `lem:base_change_mate_gstar_counit_transport`,
  `lem:base_change_mate_inner_value_eq`, `lem:base_change_mate_gstar_generator_close` are left in
  place (their Lean decls are live); dropping `gstar_transpose`'s incoming edge to them does NOT
  isolate them — each carries outgoing `\uses` of its own (confirmed by leandag: 0 isolated in
  this chapter).

## Cross-references introduced
- `\uses{lem:conjugateEquiv_counit_symm_mathlib}` (new anchor, this chapter) — added in
  `gstar_transpose` statement + proof. Resolves (leandag `unknown_uses` empty).
- `\uses{lem:base_change_mate_generator_trace, lem:base_change_mate_section_identity,
  lem:base_change_mate_gstar_transpose}` — added in `cancelBaseChange` statement + proof; all
  three exist in this chapter.

## Verification
- `leandag build --json`: no conflicts; `unknown_uses` empty; `isolated` = 10 project-wide but
  `leandag query --isolated --chapter Cohomology_FlatBaseChange` → 0 results (all 10 are one
  Quot-scheme lemma + 9 unmapped `lean_aux` nodes, none mine).
- No dangling references to the four removed labels (`grep` clean).
- LaTeX environments balanced: lemma 87/87, proof 70/70, definition 13/13, remark 1/1.
- No `\leanok` added or removed.

## References consulted
- `references/summary.md` — confirmed the 02KH affine-base-change source for the existing
  `cancelBaseChange` quote (unchanged; no new citation blocks authored). No new verbatim source
  quotes written this pass (the `huce` remainder is project-bespoke per the directive).

## Notes for Plan Agent
- The three Seam-helper lemmas (`gstar_counit_transport`, `inner_value_eq`,
  `gstar_generator_close`) are now off the `gstar_transpose` critical path (the proof reproves
  their content inline per the directive's (a)/(b)/(c) inline route). They remain valid blocks
  with live Lean decls and outgoing edges, so they are not isolated, but nothing in the chapter
  now consumes them. If a future pass confirms the inline route is the permanent one, these could
  be candidates for review-flagged removal — out of scope here (directive only authorized removing
  the three explicit-inverse blocks).
- `lem:base_change_mate_inner_value_eq` still `\uses` the sorry-backed
  `lem:base_change_mate_fstar_reindex` / `_legs`; that subgraph is untouched and remains the
  Seam-2 debt described elsewhere in the chapter. The iter-036 `gstar_transpose` target now
  bypasses it via the proved standalone `unitExpand`/`gammaDistribute` lemmas.

## Strategy-modifying findings
None.
