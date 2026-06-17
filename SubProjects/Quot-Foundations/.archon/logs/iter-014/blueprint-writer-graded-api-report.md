# Blueprint Writer Report

## Slug
graded-api

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### New subsection `subsec:gradedModuleApi` — "The graded-module wrapper for the Stacks~00K1 inductive step"
Inserted after `thm:hilbertPoly_of_sectionModule` (end of the "Graded Hilbert
polynomial" section), parallel to the existing `subsec:isRatHilb` toolkit. Opens
with a setting paragraph (graded ring `R = ⨁ Rₙ`, `R₀ = κ` field, degree-1
generated; f.g. graded `M = ⨁ Mₙ`, fin-dim `Mₙ`; `x ∈ R₁`; `K = ker(x⋆)`,
`C = M/xM`) and a build-order note (`G1 → G2 → G5 → G3 → G4 → assembly`, D5
independent).

**Block 1 — six Mathlib dependency anchors** (`\mathlibok`, each `\lean{}` verified
against local Mathlib source at the pinned commit):
- **`lem:submodule_isHomogeneous_mathlib`** — `\lean{Submodule.IsHomogeneous}`
  (`Mathlib.RingTheory.GradedAlgebra.Homogeneous.Submodule`).
- **`lem:quotSMulTop_mathlib`** — `\lean{QuotSMulTop}` (`Mathlib.RingTheory.QuotSMulTop`).
- **`lem:ideal_homogeneous_span_mathlib`** — `\lean{Ideal.homogeneous_span}`
  (`Mathlib.RingTheory.GradedAlgebra.Homogeneous.Ideal`).
- **`lem:finrank_range_add_finrank_ker_mathlib`** —
  `\lean{LinearMap.finrank_range_add_finrank_ker}`
  (`Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`).
- **`lem:fg_restrictScalars_of_surjective_mathlib`** —
  `\lean{Submodule.FG.restrictScalars_of_surjective}` (`Mathlib.RingTheory.Finiteness.Basic`).
- **`lem:isHomogeneousElem_graded_smul_mathlib`** —
  `\lean{SetLike.IsHomogeneousElem.graded_smul}` (`Mathlib.Algebra.GradedMulAction`).

  Note: the directive also listed `Submodule.finrank_quotient_add_finrank` as an
  anchor, but it is **already present** in the chapter as
  `lem:finrank_ses_additive_mathlib` (`\mathlibok`). I reused that existing anchor
  (D5 `\uses{}` it) rather than duplicating it.

**Blocks G1–G5 + D5** (project-bespoke; no external source quote — per directive,
the existing `% SOURCE QUOTE PROOF` on `lem:gradedHilbertSerre_rational` covers the
assembly). Each has a precise forward-pin and a formalizable informal proof:
- **G1 `lem:graded_homogeneousSubmodule_decomposition`** —
  `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_decomposition}`.
  `DirectSum.Decomposition` + `SetLike.GradedSMul` on `n ↦ p ⊓ Mₙ` for homogeneous
  `p`; specialised to `K` (with `Kₙ = ker(x : Mₙ → Mₙ₊₁)`).
  `\uses{}` submodule + graded_smul anchors. Proof sketch: Y.
- **G2 `lem:graded_quotient_decomposition`** —
  `\lean{AlgebraicGeometry.GradedModule.quotient_decomposition}`. Decomposition on
  `M/p` with components `(Mₙ).map p.mkQ`; specialised to `C = QuotSMulTop x M`.
  `\uses{G1, quotSMulTop, graded_smul}`. Proof sketch: Y.
- **G3 `lem:graded_quotientRing_gradedRing`** —
  `\lean{AlgebraicGeometry.GradedModule.quotientRing_gradedRing}`. `GradedRing` on
  `R/(x)` with components `(Rₙ).map (Quotient.mk (x))` (heaviest block).
  `\uses{homogeneous_span, G2, graded_smul}`. Proof sketch: Y.
- **G4 `lem:graded_regrade_over_quotient`** —
  `\lean{AlgebraicGeometry.GradedModule.regrade_over_quotient}`. `SetLike.GradedSMul`
  for the `R/(x)`-action on the G1/G2 families (`C`, `K` annihilated by `x`).
  `\uses{G1, G2, G3}`. Proof sketch: Y.
- **G5 `lem:graded_finite_transfer`** —
  `\lean{AlgebraicGeometry.GradedModule.finite_over_quotient}`. `C`, `K` f.g. graded
  `R/(x)`-modules via `restrictScalars_of_surjective` along `R ↠ R/(x)`.
  `\uses{G4, fg_restrictScalars anchor}`. Proof sketch: Y.
- **D5 `lem:graded_degreewise_finrank_diff`** —
  `\lean{AlgebraicGeometry.GradedModule.degreewise_finrank_diff}`. Pure
  rank–nullity: `dim W − dim V = dim(W/range φ) − dim(ker φ)`, applied degreewise
  to `x : Mₙ → Mₙ₊₁` to give `dim Mₙ₊₁ − dim Mₙ = dim Cₙ₊₁ − dim Kₙ` (the `hdiff`
  input). `\uses{rank-nullity anchor, finrank_ses_additive_mathlib}`. Proof sketch: Y.

### Revised `lem:gradedHilbertSerre_rational` proof body (and its `\uses{}`)
- Proof `\uses{}` extended with G1–G5 + D5.
- Inductive step rewritten to **explicitly manufacture** `K`, `C` as f.g. graded
  `R/(x)`-modules via G1→G2→G4→G5 (and `R/(x)` graded via G3), build the `hdiff`
  difference identity via D5, raise to a common order with `lem:ratHilb_bump`, and
  feed `IsRatHilb(h_C, d)`, `IsRatHilb(h_K, d)` + the identity into
  `lem:ratHilb_ofDiffEq` to conclude `IsRatHilb(h_M, d+1)`.
- The existing Stacks 00K1 `% SOURCE QUOTE PROOF` block above the proof is
  **unchanged**.
- Added a `% NOTE:` at the reduction-to-degree-1 step flagging that "finitely many
  degree-one generators" is expected to follow from the standing hypotheses (f.g.
  κ-algebra + degree-1-generated), so **no new hypothesis** on
  `gradedModule_hilbertSeries_rational` is anticipated — to be confirmed at
  G-assembly.

## Cross-references introduced
All resolved (leandag: `unknown_uses: []`, `conflicts: []`, `isolated: 0`):
- G1 → `lem:submodule_isHomogeneous_mathlib`, `lem:isHomogeneousElem_graded_smul_mathlib`
- G2 → `lem:graded_homogeneousSubmodule_decomposition`, `lem:quotSMulTop_mathlib`, graded_smul anchor
- G3 → `lem:ideal_homogeneous_span_mathlib`, `lem:graded_quotient_decomposition`, graded_smul anchor
- G4 → G1, G2, `lem:graded_quotientRing_gradedRing`
- G5 → `lem:graded_regrade_over_quotient`, `lem:fg_restrictScalars_of_surjective_mathlib`
- D5 → `lem:finrank_range_add_finrank_ker_mathlib`, `lem:finrank_ses_additive_mathlib`
- `lem:gradedHilbertSerre_rational` proof → all of G1–G5 + D5

## References consulted
- `references/summary.md` — index; confirmed `hilbert-serre-algebra.tex` (Stacks
  00K1) is the existing source for `lem:gradedHilbertSerre_rational`.
- `references/hilbert-serre-algebra.tex` (L13893–13948) — re-read the 00K1
  proposition + inductive-step proof to confirm the new prose matches the existing
  `% SOURCE QUOTE PROOF`. No new source quote authored (G1–G5/D5 are
  project-bespoke building blocks; existing 00K1 quote covers the assembly).
- `analogies/quot-graded-module-api.md` — the authoritative api-alignment plan
  (G1–G5/D5 decomposition, Mathlib present/absent inventory, build order).

Mathlib `\lean{}` anchor targets were verified by grep against the local Mathlib
source at the pinned commit (`.lake/packages/mathlib/...`): all six declarations
(`QuotSMulTop`, `Submodule.FG.restrictScalars_of_surjective`,
`SetLike.IsHomogeneousElem.graded_smul`, `Submodule.IsHomogeneous`,
`Ideal.homogeneous_span`, `LinearMap.finrank_range_add_finrank_ker`) exist with the
stated names.

## Macros needed (if any)
None. The subsection uses only existing macros and `\operatorname{}`/`\mathrm{}`.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Next-iter `mathlib-build` prover lane is now blueprinted.** Build order to hand
  the prover: G1 → G2 → G5 → G3 → G4 → assembly (re-point of
  `gradedModule_hilbertSeries_rational`). D5 is pure linear algebra and lands
  independently.
- **Forward-pin namespace.** I used `AlgebraicGeometry.GradedModule.*` for the six
  new Lean targets (consistent with the chapter's `AlgebraicGeometry.*`
  convention). The scaffolder should create that namespace; the names are
  suggestions and can be adjusted, but the blueprint `\lean{}` hints must then be
  kept in sync (`\lean{...}` correction is the review agent's domain).
- **Two Lean instances per G-block.** G1/G2/G4 each describe a
  `DirectSum.Decomposition` *and* a `SetLike.GradedSMul` instance; G3 a full
  `GradedRing`. Each blueprint block forward-pins one primary `\lean{}` name (the
  decomposition / GradedRing); the companion `GradedSMul` instance is described in
  prose. If the prover splits these into separately-named Lean declarations, those
  helper instances should get their own thin blueprint entries (1-to-1
  correspondence) — flagging now so the scaffolder can decide granularity.
- **G3 hypothesis to confirm at assembly** (recorded as a `% NOTE:` in the proof):
  the induction is on the number of degree-one generators; its finiteness should
  follow from "f.g. κ-algebra + degree-1-generated" with no new hypothesis on
  `gradedModule_hilbertSeries_rational`. Confirm when formalizing G-assembly.
- D3b (graded-subalgebra route avoiding the quotient ring) from the analogy was
  **not** blueprinted — the directive selected D3a (quotient ring via G3), matching
  the existing Stacks 00K1 prose. Left as a fallback only.

## Strategy-modifying findings
None. The graded-module wrapper realises the existing Stacks 00K1 strategy without
altering the statement of `lem:gradedHilbertSerre_rational` or its consumers
(`thm:hilbertPoly_of_sectionModule`).
