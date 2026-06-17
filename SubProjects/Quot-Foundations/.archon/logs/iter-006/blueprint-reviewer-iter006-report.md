# Blueprint Review Report

## Slug
iter006

## Iteration
006

## Per-chapter

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - HARD GATE: CLEARS. All 30 declaration blocks present; all active FBC-A/B blocks carry `\leanok`. leandag: 0 `unknown_uses`, 0 isolated.
  - **iter-006 edit confirmed**: `lem:base_change_mate_regroupEquiv` now `\uses{lem:cancelBaseChange_mathlib, lem:base_change_regroup_linearEquiv}` (both declaration and proof blocks updated). The cross-chapter dep to `Cohomology_RegroupHelper.tex` is present and resolves correctly in the DAG.
  - `lem:base_change_regroup_linearEquiv` is **not** in `unmatched_lean` — the Lean declaration is in the project tree. The iter-005 coverage debt is confirmed resolved.
  - Proof of `lem:base_change_mate_regroupEquiv` correctly describes the `LinearEquiv.toModuleIso` route and names the separate compilation unit; this is consistent with the RegroupHelper refactor rationale.
  - Three `\mathlibok` anchors (`lem:pullbackSpecIso_mathlib`, `lem:cancelBaseChange_mathlib`, `lem:flat_preserves_equalizer_mathlib`) all faithful: declared Mathlib names match prior-verified Mathlib declarations; forms match the stated blueprint statements.

### blueprint/src/chapters/Cohomology_RegroupHelper.tex
- **complete**: true
- **correct**: true
- **notes**:
  - New chapter (iter-006). Single block `lem:base_change_regroup_linearEquiv` — all required elements present.
  - **Statement**: R'-linear iso `(A ⊗_R R') ⊗_A M → R' ⊗_R M`; on generators `(a ⊗ r') ⊗ m ↦ r' ⊗ (a · m)`; no flatness hypothesis. Mathematically correct.
  - **`\lean{}`**: `AlgebraicGeometry.base_change_regroup_linearEquiv` — present in Lean tree (not in `unmatched_lean`). Hint is well-formulated.
  - **`\uses{lem:cancelBaseChange_mathlib}`**: valid label, resolves to the `\mathlibok` anchor in FlatBaseChange. 0 `unknown_uses`.
  - **Informal proof**: `comm ≪≫ cancelBaseChange ≪≫ comm` three-factor composition; R'-linearity argument spelled out via `rightAlgebra` action and `cancelBaseChange_tmul`; adequate for a prover.
  - **Citation discipline**: `% SOURCE:` present with `(read from references/stacks-coherent.tex, L933–938)` — file confirmed on disk. `% SOURCE QUOTE:` is verbatim English text from Stacks (correct: Stacks is in English). Visible `\textit{Source: ...}` prose line present; matches `% SOURCE:` pointer exactly. No drift.
  - **Missing `\leanok`**: expected — sync_leanok has not run for this new chapter; the declaration IS in the Lean tree. No action needed from blueprint side.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - HARD GATE: CLEARS. All GF-alg declaration blocks present; active blocks carry `\leanok`. leandag: 0 `unknown_uses`, 0 isolated for this chapter.
  - **iter-006 signature fix confirmed**: `lem:gf_noether_clear_denominators` (L4) `% LEAN SIGNATURE` block now carries the `(_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))` existential binder as the 3rd existential (after `(_ : g ≠ 0)`, before `φ`), matching the landed Lean decl `exists_localizationAway_finite_mvPolynomial`. The iter-005 checker's one major finding is fully resolved.
  - Three `\mathlibok` anchors (`lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`) faithful: all verified against STRATEGY.md's "Mathlib keys confirmed" list and cited Lean names are standard Mathlib declarations.

### blueprint/src/chapters/Picard_GrassmannianCells.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All 6 declaration blocks have complete statements, adequate proof sketches, and SOURCE citations from `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`. No `\leanok` markers — correct (no Lean file for this chapter yet; all 6 nodes are in `unmatched_lean` as expected).
  - **QUOT-defs scaffold readiness — `def:gr_affine_chart`**: definition of the `Spec Z[x^I_{ij}]` affine chart (I-th maximal minor = identity) is complete and correct. `\lean{AlgebraicGeometry.Grassmannian.affineChart}` is a well-formulated hint. No `\uses{}` to other unimplemented project nodes (standalone definition). Ready to scaffold next iter without prerequisite work.
  - `def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` are similarly complete and correct; all are in `unmatched_lean` (expected).
  - GR-quot (tautological quotient) is explicitly deferred in an "Out of scope" note, consistent with QUOT-repr being BLOCKED in STRATEGY.md. No gap within this chapter's stated scope.
  - `\mathlibok` anchor `lem:isProper_mathlib` → `AlgebraicGeometry.IsProper` — faithful.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **QUOT-defs scaffold readiness — three frontier definitions**:
    - `def:modules_annihilator` (`\lean{AlgebraicGeometry.Scheme.Modules.annihilator}`): Archon-original primitive — no `% SOURCE:` required (correctly omitted); definition is `Ann_{O_X(U)}(F(U))` for affine opens U. Mathematically unambiguous, standalone. Ready to scaffold.
    - `def:is_locally_free_of_rank` (`\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}`): SOURCE → Nitsure §1 Ex.(2), verbatim English quote, `\textit{Source:}` line present. Locally trivialised by `O_U^d`. Standalone. Ready to scaffold.
    - `def:sectionGradedRing` (`\lean{AlgebraicGeometry.sectionGradedRing}`): SOURCE → Nitsure §1, verbatim quote, `\textit{Source:}` line present. Graded ring `⊕_{m≥0} Γ(X_s, L_s^⊗m)`. No `\uses{}` (Mathlib infrastructure only). Ready to scaffold.
  - All four frontier nodes (`def:modules_annihilator`, `def:is_locally_free_of_rank`, `def:sectionGradedRing`, `def:gr_affine_chart`) are standalone definitions with no cross-dependencies on other unimplemented project nodes. A QUOT-defs scaffold lane is feasible to open next iter.
  - `thm:grassmannian_representable` (`\leanok`, with_sorry): proof sketch present and mathematically sound; `% NOTE` documents that the `RepresentableBy`-based proof path is blocked by the weaker `IsAffineHom` encoding of `thm:relative_spec_univ`. This is an acknowledged open strategic question tracked in STRATEGY.md (option A: strengthen RelativeSpec; option B: RepresentableBy-free argument). Not a blueprint error.
  - 9 nodes in `unmatched_lean` for this chapter — all expected (future-phase QUOT/SNAP declarations not yet in Lean tree).
  - `\mathlibok` anchors `lem:hilbertPoly_exists_mathlib` and `lem:functor_is_representable_mathlib` — faithful.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

## Cross-chapter notes

- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ` — the current Lean encoding uses `IsAffineHom (structureMorphism A)` / `IsAffine`, which is weaker than the blueprint's `RepresentableBy` statement. This directly blocks the `RepresentableBy`-based proof path in `Picard_QuotScheme.tex` / `thm:grassmannian_representable` (the `% NOTE` in that block refers to this gap). Both chapters document the gap in-chapter; STRATEGY.md tracks the two strategic alternatives. No writer action is needed until QUOT-repr is unblocked — at that point, one alternative must be chosen and the chosen chapter updated.

## Severity summary

HARD GATE: CLEARS — both active prover chapters (`Cohomology_FlatBaseChange.tex`, `Picard_FlatteningStratification.tex`) are `complete: true, correct: true` with zero must-fix findings.

**informational**:
- `Picard_QuotScheme.tex` / `thm:grassmannian_representable`: `RepresentableBy` proof path blocked on `thm:relative_spec_univ` encoding gap. No action until QUOT-repr is unblocked; strategic choice (strengthen RelativeSpec vs. alternative construction) is tracked in STRATEGY.md.
- 24 `unmatched_lean` entries: 9 are `\mathlibok` nodes (Mathlib declarations, not in project tree — expected by design), 15 are future-phase project nodes (QuotScheme QUOT/SNAP chain + GrassmannianCells). No action needed.
- `Cohomology_RegroupHelper.tex` / `lem:base_change_regroup_linearEquiv`: `\leanok` absent — sync_leanok will apply it once the sorry body is closed; Lean declaration confirmed present in tree.

## Overall verdict

HARD GATE CLEARS for both active lanes (FBC-A and GF-alg); iter-005 `base_change_regroup_linearEquiv` coverage debt and L4-signature correction are both confirmed resolved; all four QUOT-defs frontier nodes (`def:modules_annihilator`, `def:is_locally_free_of_rank`, `def:sectionGradedRing`, `def:gr_affine_chart`) are complete + correct in the blueprint, feasible to scaffold next iter.
