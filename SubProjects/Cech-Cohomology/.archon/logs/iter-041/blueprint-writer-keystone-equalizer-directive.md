# Directive: blueprint-writer — re-route + decompose the Route B keystone to the sheaf-axiom equalizer

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (edit ONLY this chapter).

## Why
The keystone `lem:qcoh_section_isLocalizedModule` proof is currently UNSOUND (circular): it claims to
descend `IsLocalizedModule (powers f) ρ_f` over `{gⱼ}` via `lem:isLocalizedModule_of_span_cover`, but
that lemma's per-`gⱼ` hypothesis is about the ABSTRACT `LocalizedModule (powers gⱼ) Γ(X,F)`, and
bridging it to the tile lemma's sheaf-section output requires `Γ(D(gⱼ),F) ≅ Γ(X,F)_{gⱼ}` — which is
the keystone at `gⱼ`, the same statement. The blueprint-reviewer flagged this as a HARD-GATE must-fix.
A read-only mathlib-analogist consult (`analogies/keystone-descent.md`, iter-041) confirmed the
circularity and identified the correct non-circular route. **Your job: replace the keystone proof with
that route and decompose it into a `\uses`-linked chain of sub-lemmas.** Read
`analogies/keystone-descent.md` in full first — it is your source of truth for the route.

## The correct route (sheaf-axiom equalizer localized at f — Stacks 01HV(4)/01I8)
For qcoh `F` on `X = Spec R`, finite standard cover `X = ⋃ⱼ D(gⱼ)` with `span{gⱼ}=⊤` (from B1):
1. **Sheaf-axiom equalizer for F (degree 0/1).** F is a sheaf, so
   `0 → Γ(X,F) → ∏ⱼ Γ(D(gⱼ),F) → ∏_{j,k} Γ(D(gⱼgₖ),F)` is exact (a `Function.Exact` / equalizer). The
   same for the induced cover `{D(gⱼf)}` of `D(f)`:
   `0 → Γ(D(f),F) → ∏ⱼ Γ(D(gⱼf),F) → ∏_{j,k} Γ(D(gⱼgₖf),F)`.
2. **Localize the X-equalizer at f.** Localization at `powers f` is exact, so applying it to the
   X-equalizer keeps it exact: `0 → Γ(X,F)_f → ∏ⱼ Γ(D(gⱼ),F)_f → ∏_{j,k} Γ(D(gⱼgₖ),F)_f`. (Mathlib
   `IsLocalizedModule.map_exact` / localization-is-exact; mark this as a `\mathlibok` anchor.)
3. **Per-tile localizations (REUSE the DONE pieces).** For each cover element `gⱼ` and overlap `gⱼgₖ`,
   the tile `F_{(gⱼ)}` (resp. `F_{(gⱼgₖ)}`) is globally presented (B4
   `lem:presentation_modulesRestrictBasicOpen`), hence the DONE tile lemma
   `lem:section_isLocalizedModule_of_presentation` (read through `lem:restrict_obj_mathlib`, rfl) gives
   `Γ(D(gⱼ),F)_f ≅ Γ(D(gⱼf),F)` and `Γ(D(gⱼgₖ),F)_f ≅ Γ(D(gⱼgₖf),F)`. These are localizations on the
   TILES (where F is tilde), never on the global object — this is exactly why the route is non-circular.
4. **Kernel comparison.** Intertwine the localized X-equalizer (step 2) with the D(f)-cover equalizer
   (step 1, second sequence) via the per-tile isos of step 3 (the ∏ terms match; commutativity is
   naturality of restriction-vs-localization, the analogue of the project's
   `qcohRestriction_eq_comparison`). The induced map on kernels gives `Γ(X,F)_f ≅ Γ(D(f),F)`,
   compatible with `ρ_f`, i.e. `IsLocalizedModule (powers f) ρ_f` — the keystone.

DO NOT use `lem:isLocalizedModule_of_span_cover` as the glue (it is the wrong tool here; it remains a
correct algebra lemma, just not for this assembly). The project's P3 section-Čech bridge
(`CechAcyclic.lean`: `sectionCech_objD_apply`, `qcohRestriction_eq_comparison`, the `phi`/`phiL` ladder)
is the TEMPLATE for steps 1+4, but it is currently wired for the global tilde sheaf `~M` and the full
positive-degree complex — the keystone needs only DEGREE 0/1 of a general qcoh `F` whose tiles are
tilde. Describe a degree-0/1 specialization, NOT a full reuse.

## Concrete deliverables
Rewrite the `lem:qcoh_section_isLocalizedModule` PROOF to the route above, and introduce a
`\uses`-linked chain of NEW sub-lemma blocks (each: `\begin{lemma}`/`\begin{definition}`, `\label`,
`\lean{AlgebraicGeometry.<intendedName>}` naming the decl a prover will build, accurate `\uses`, and a
rigorous informal proof). Suggested decomposition (adapt names/granularity as the math dictates):
- `lem:qcoh_section_equalizer` — the degree-0/1 sheaf-axiom equalizer for qcoh `F` on a standard cover
  (`Function.Exact` form). `\uses` the sheaf condition of `(Spec R).Modules`.
- `lem:localized_module_map_exact_mathlib` — **`\mathlibok` Mathlib anchor**: localization at a
  submonoid sends an exact sequence to an exact sequence (`\lean{}` the real Mathlib name —
  `IsLocalizedModule.map_exact` or the `LocalizedModule.Exact` form; the prover will confirm the exact
  name, you state the result in project notation and mark `\mathlibok`).
- `lem:tile_section_localization` — per cover/overlap element, `Γ(D(gⱼ…),F)_f ≅ Γ(D(gⱼ…f),F)` from
  `lem:section_isLocalizedModule_of_presentation` + B4 + `lem:restrict_obj_mathlib`.
- `lem:qcoh_section_kernel_comparison` — the kernel-comparison step assembling the keystone iso.
Then set the keystone `lem:qcoh_section_isLocalizedModule` `\uses{}` to this new chain (plus the DONE
`lem:qcoh_finite_presentation_cover` for the finite cover) and DELETE the now-wrong dependence on
`lem:isLocalizedModule_of_span_cover` from the keystone's `\uses` (the span-cover lemma keeps its own
block as a general algebra lemma; just stop the keystone from `\uses`-ing it).

## Citations
The keystone block already carries the Stacks 01HV(4) `% SOURCE`/`% SOURCE QUOTE`/`% SOURCE QUOTE PROOF`
(read from `references/stacks-schemes.tex`). Keep them. If a sub-lemma needs a fresh quote and you lack
the local source, you are authorized to spawn a reference-retriever (your `references/**` write-domain).
The project-bespoke sub-lemmas (equalizer specialization, kernel comparison) may stand on their informal
proof alone (no external citation needed), but the Stacks-derived overall statement keeps its quote.

## Out of scope / constraints
- Do NOT add or remove `\leanok` (the deterministic sync phase owns it). You MAY mark `\mathlibok` ONLY
  on the genuine Mathlib anchor `lem:localized_module_map_exact_mathlib`.
- Do NOT touch the DONE B0–B4 blocks except to repoint a `\uses` if genuinely required.
- Do NOT touch other chapters.
- Keep prose mathematical (no Lean tactic strings).
