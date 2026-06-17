# Blueprint Review: iter-061
**Iter:** 061

## Top-level summaries

- **Gaps**: `lem:snap_ztensor_whisker_localIso` (SectionGradedRing) — no `\lean{}` pin; impact=0; parent `lem:isIso_sheafification_whiskerRight_unit` already `\leanok`. Non-blocking.
- **Deps/Isolated**: `lem:gr_bundleCocycle_mul` (C2) is `\leanok` in blueprint but its proof `\uses{lem:gr_bundleCocycle_transport, lem:gr_bundleCocycle_matrix, lem:gr_matrixToFreeIso_mul}` — all three in `unmatched_lean` (don't exist in Lean code yet). State drift: C2 is currently proved inline; L1–L3 need BUILD then C2 proof must be refactored. Note for prover.
- **Isolated blueprint nodes (5)**:
  - 3× `lem:mat…` in FlatteningStratification — unproved, 0 deps, 0 impact — likely obsolete mathlib anchors (candidates: `lem:mathlib_flat_of_free/localization_preserves/localization_flat`). Disposition: **wire-up** (check which GF-geo lemmas still need them) or **remove** if GF-geo proved without them.
  - `lem:isL…` in FlatteningStratification — proved, isolated — likely `lem:isLocalization_away_mul_of_associated`. Disposition: **keep** (Mathlib anchor, used in GrassmannianCells historically; orphaned by route change).
  - `lem:gr_…` in GrassmannianQuot — proved, isolated — unable to pin exact label from truncated output. Disposition: **keep** pending exact identification.
- **leandag summary**: 577 blueprint nodes; 443 proved; 12 with-sorry; 102 mathlib_ok; 16 isolated (11 lean_aux + 5 blueprint); 0 unknown_uses; 0 conflicts.
- **blueprint-doctor**: CLEAN — no malformed_refs, no broken_refs, no orphan chapters, no axiom_decls, no covers_problems.

---

## HARD GATE verdicts

### Gate 1: `Picard/SectionGradedRing.lean` → `Picard_SectionGradedRing.tex`
**Target**: `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`)

**3-step sketch assessment**: Complete.
- Step 1 (objectwise): `lem:relativeTensor_objectwise_coequalizer` (`\leanok`) gives each `P(U) ⊗_{O(U)} Q(U)` as coequalizer of aL/aR. ✓
- Step 2 (promotion): `lem:evaluationJointlyReflectsColimits_mathlib` (`\mathlibok`) lifts objectwise colimit to functor-category colimit; cofork assembled from `def:relTensorActL/ActR/Proj` (all `\leanok`). ✓
- Step 3 (apex ID): `lem:presheaf_tensorObj_obj_mathlib` (`\mathlibok`) identifies the apex presheaf with `P ⊗_p Q`. ✓

**`\uses{}` deps check**:
- `lem:relativeTensor_objectwise_coequalizer` — `\leanok` ✓
- `def:relTensorActL` — `\leanok` ✓
- `def:relTensorActR` — `\leanok` ✓
- `def:relTensorProj` — `\leanok` ✓
- `lem:evaluationJointlyReflectsColimits_mathlib` — `\mathlibok` ✓
- `lem:presheaf_tensorObj_obj_mathlib` — `\mathlibok` ✓
- `lem:presheafModule_monoidal_mathlib` — `\mathlibok` ✓

**`\lean{}` target**: `AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso` — in `unmatched_lean` (sorry stub exists but declaration absent); correct — prover must BUILD+PROVE.

**Gap node concern**: `lem:snap_ztensor_whisker_localIso` (no `\lean{}`) is in the `\uses{}` of `lem:isIso_sheafification_whiskerRight_unit`'s PROOF block only, not of `lem:relativeTensor_as_coequalizer`. Non-blocking.

**Complete**: true | **Correct**: true | **Must-fix**: none  
**VERDICT: GATE PASS ✓**

---

### Gate 2: `Picard/GrassmannianQuot.lean` → `Picard_GrassmannianQuot.tex`
**Target**: C2 chain L1–L3 + `lem:gr_bundleCocycle_mul`

#### L1: `lem:gr_bundleCocycle_matrix`
- `lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_matrix}` in `unmatched_lean` — needs BUILD ✓
- Statement: matrix identity `(X^J_K)^{-1}(X^I_J)^{-1} = (X^I_K)^{-1}` over triple-overlap ring. Clear.
- Proof sketch: uses `gr_cocycle_imageMatrix_eq`, column-submatrix-commutes-with-left-mul, Cramer-inverse chain. Complete.
- `\uses{}` deps: `def:gr_universalMinorInv`, `lem:gr_cocycle_imageMatrix_eq`, `lem:gr_universalMinorInv_identities`, `lem:gr_mul_submatrix_col`, `lem:gr_inv_mul_inv_mul_cancel`, `lem:gr_cocycle` — all in blueprint. ✓

#### L2: `lem:gr_matrixToFreeIso_mul`
- `lean{AlgebraicGeometry.Grassmannian.matrixToFreeIso_mul}` in `unmatched_lean` — needs BUILD ✓
- Statement: composition of matrix automorphisms = matrix product (reversed order). Clear.
- Proof sketch: 2 lines from `lem:gr_matrixToFreeIso_hom` + `lem:gr_matrixEnd_comp`. Complete.
- `\uses{}` deps: `def:gr_matrixToFreeIso`, `lem:gr_matrixToFreeIso_hom`, `lem:gr_matrixEnd_comp` — all `\leanok`. ✓

#### L3: `lem:gr_bundleCocycle_transport`
- `lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport}` in `unmatched_lean` — needs BUILD ✓
- **Mathematical content complete** (addresses lvb-checker concern): sketch explicitly identifies every ingredient — bundleTransition = matrixToFreeIso conjugated by pullbackFreeIso; transport via pullbackBaseChangeTransport reassociates via pullbackComp; endpoint bridges (src/mid/tgt) pin all three transitions to single free sheaf O^d_{V_{IJK}}; pullbackFreeIso comparisons cancel → each transport becomes matrixEnd of corresponding Cramer inverse; matrix identity (L1) + linkage (L2) give composite = target. The "~50-100 LOC reassociation" flagged by lvb-checker is **Lean term-mode bookkeeping, not missing mathematics**. Blueprint is adequate.
- `\uses{}` deps: `def:gr_bundleTransition`, `lem:gr_bundleCocycle_matrix`, `lem:gr_matrixToFreeIso_mul`, `lem:modules_pullback_basechange_transport`, `lem:gr_glueData_bridges`, `def:modules_pullbackComp`, `lem:gr_pullbackFreeIso` — all in blueprint. ✓

#### C2: `lem:gr_bundleCocycle_mul`
- Currently `\leanok` in blueprint (existing Lean proof is inline, not using L1-L3 as named lemmas).
- **Action for prover**: BUILD L1-L3, then refactor C2 to use them. C2 proof block explicitly `\uses{lem:gr_bundleCocycle_transport, lem:gr_bundleCocycle_matrix, lem:gr_matrixToFreeIso_mul}` — the post-refactor proof is clearly sketched (3 independent steps). ✓

#### Five coverage-debt blocks:
1. `lem:gr_pullbackFreeIso_eqToHom` (`lean{pullbackFreeIso_eqToHom}`) — pure math (substitution collapses eqToHom to id), `\uses{lem:gr_pullbackFreeIso}`. ✓
2. `lem:gr_pullbackFreeIso_trans_symm_eqToIso` (`lean{pullbackFreeIso_trans_symm_eqToIso}`) — pure math (iso-level cancellation), `\uses{lem:gr_pullbackFreeIso}`. ✓
3. `lem:gr_scalarEnd_sum` (`lean{scalarEnd_sum}`) — pure math (finite induction), `\uses{def:gr_scalarEnd, lem:gr_scalarEnd_zero, lem:gr_scalarEnd_add}`. ✓
4. `lem:gr_universalMinorInv_self` (`lean{universalMinorInv_self}`) — pure math (X^I_I = 1 → 1^{-1} = 1), `\uses{def:gr_universalMinorInv, lem:gr_universalMatrix_submatrix_self}`. ✓
5. `def:gr_bundleTransitionData` (`lean{bundleTransitionData}`) — pure packaging def, `\uses{def:gr_bundleTransition, def:scheme_modules_glue}`. ✓
All five: no Lean tactic leakage, correctly `\uses{}`-linked, faithful to `\lean{}` targets. Not in `unmatched_lean` (sorry stubs exist). ✓

**Complete**: true | **Correct**: true | **Must-fix**: none (C2 `\leanok`/L1–L3 drift is a Lean state note, not a blueprint deficiency)  
**VERDICT: GATE PASS ✓**

---

## Per-chapter

### `Cohomology_FlatBaseChange.tex`
- **Complete**: partial (FBC-A2 ACTIVE, FBC-B gated on A1; chapter covers FlatBaseChange.lean + FlatBaseChangeGlobal.lean)
- **Correct**: true (no leandag issues; blueprint-doctor clean; file too large to fully read — first 100 lines verified)
- **Notes**: FBC-A1 PARKED (keystone `_legs_conj` off critical path). Multiple `unmatched_lean` FBC nodes in leandag (expected — FBC-A1 residual). No must-fix this iter; FBC-A2 is the active lane.

### `Cohomology_RegroupHelper.tex`
- **Complete**: true | **Correct**: true
- 1 declaration `lem:base_change_regroup_linearEquiv` — `\leanok`. ✓

### `Picard_FlatteningStratification.tex`
- **Complete**: true (GF-geo has `thm:generic_flatness` lane; algebraic core `\leanok`)
- **Correct**: true
- **Notes**: 4 isolated blueprint nodes (see Top-level summaries). 3 unproved mathlib anchors with 0 impact need triage by plan agent. `lem:isLocalization_away_mul_of_associated` (`\leanok`) isolated — possibly used by GrassmannianCells in older iter.

### `Picard_GrassmannianCells.tex`
- **Complete**: true | **Correct**: true
- All cells, cocycle, glue, separated, proper DONE (memory confirms axiom-clean). ✓

### `Picard_GrassmannianQuot.tex`
- **Complete**: true | **Correct**: true (see Gate 2 above)

### `Picard_QuotScheme.tex`
- **Complete**: partial (209 `\leanok`/`\mathlibok` markers; `def:sectionGradedRing` + `def:sectionGradedModule` NOT `\leanok` — forward decls pending SectionGradedRing work)
- **Correct**: true
- **Notes**: `def:hilbert_polynomial` IS `\leanok`. The two non-`\leanok` graded defs depend on `SectionGradedRing.lean` infrastructure being provided first. Active QUOT-consumers lane unblocked.

### `Picard_RelativeSpec.tex`
- **Complete**: partial (RelativeSpec.lean in progress; `def:qc_sheaf_of_algebras` `\leanok`)
- **Correct**: true
- **Notes**: Not in active prover gate this iter. QUOT-repr is BLOCKED.

### `Picard_SectionGradedRing.tex`
- **Complete**: true | **Correct**: true (see Gate 1 above)
- **Notes**: 1 gap node `lem:snap_ztensor_whisker_localIso` — add `\lean{}` pin when implementation lands; otherwise non-blocking.

---

## Severity summary

- **gate-pass**: Both `Picard_SectionGradedRing.tex` and `Picard_GrassmannianQuot.tex` clear the hard gate. Provers may proceed.
- **soon**: `lem:snap_ztensor_whisker_localIso` — add `\lean{}` after implementation (one-line writer fix; not blocking).
- **informational**: C2 `\leanok` / L1–L3 unmatched drift — expected; prover BUILD+refactor step will resolve.
- **informational**: 3 isolated unproved mathlib anchors in FlatteningStratification — wire-up or remove; no live-lane impact.
- **informational**: 1 unidentified isolated proved node in GrassmannianQuot — keep pending exact label identification via `leandag show --node` or manual search.

## Unstarted-phase proposals

None. All strategy phases have adequate blueprint coverage.
