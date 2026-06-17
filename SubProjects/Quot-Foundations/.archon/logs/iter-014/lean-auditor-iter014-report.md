# Lean Audit Report

## Slug
iter014

## Iteration
014

## Scope
- files audited: 7
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Import-only entrypoint. No declarations. Clean.

---

### AlgebraicJacobian/Cohomology/RegroupHelper.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `base_change_regroup_linearEquiv` is fully proved (no sorry). The `TensorProduct.induction_on` decomposition and the `smul_tmul'` + `tmul_mul_tmul` route for `map_smul'` are mathematically sound.
  - `set_option autoImplicit false` is a project standard; acceptable.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: 2 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none (see note on `maxHeartbeats`)
- **excuse-comments**: none
- **notes**:
  - **[Known/tracked — Major]** Lines 184–247: legacy STATUS comments referencing `iter-234`, `iter-236`, `iter-240`, `iter-241`. These are stale orphans from the pre-extraction source project. Already tracked per directive.
  - **[Known/tracked — minor]** Line 637: inline "KEY INSIGHT (iter-241)" reference — same category of stale legacy note.
  - **[Minor]** Line 975: `set_option maxHeartbeats 4000000 in` on `base_change_mate_unit_value`. Accompanied by an honest comment (lines 971–974) explaining the cause: "several `erw` defeq-unifications and a `simp` closure over the `restrictScalars`/tilde–Γ round trips." The explanation is specific and accurate; this is not a masked fragile proof. The bump is high but justified by the nature of the `conjugateIsoEquiv`/`erw` chain. Not a red flag.
  - **The new `base_change_mate_unit_value` proof (lines 999–1089):** The six-move structure (`hunitL`, `hunitR`, `hpullinv`, `huce`, `hClaimA`/`hgPTI`, final assembly) is internally consistent. Each `have` discharges an honest sub-goal. The `erw [β.hom.naturality_assoc]` + `erw [reassoc_of% huce]` combo is the non-trivial step and requires the `maxHeartbeats` bump; it is legitimate.
  - **4 open `sorry`s** (lines 1170, 1215, 1388, 1410): openly-disclosed scaffolding for `base_change_mate_fstar_reindex`, `base_change_mate_gstar_transpose`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`. Each has a detailed comment explaining what remains. Not re-classified as surprises per directive.
  - **No** `#check`, `#eval`, or `section ScratchCheck` left behind.

---

### AlgebraicJacobian/Cohomology/RegroupHelper.lean *(already covered above)*

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: 2 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **[Major]** Lines 1322–1323: the comment inside `exists_free_localizationAway_polynomial` says "The remaining residue, to be assembled once `gf_torsion_reindex` (L5b, still `sorry`) lands" — but `gf_torsion_reindex` *was* closed this very iteration. The comment was written before the closure and not updated; it now misleads readers into believing the missing piece is `gf_torsion_reindex` when that declaration is in fact proved. The `sorry` at line 1337 legitimately remains for the other assembly steps (steps 1, 3, 4, 5 in the comment's own list), but the stated blocking reason is no longer accurate.
  - **[Known/tracked — Major]** Lines 1427–1429 (and similarly `genericFlatness` declaration): the `iter-177+` reference in the `genericFlatness` docstring is a known stale legacy cross-project reference. Already tracked per directive.
  - **[Minor]** Lines 1015–1018: stacked `set_option synthInstance.maxHeartbeats 1000000 in` + `set_option maxHeartbeats 4000000 in` on `gf_torsion_reindex`. Both options are accompanied by honest one-line explanations ("unusually deep instance search" / "Elaboration of the verified `Module.Finite Qf Tg'` localisation chain plus the `A_g`-linearity transport"). The explanations are specific and accurate. Not a red flag, but two simultaneous bumps on the same declaration is notable.
  - **[Minor — design note]** `pullbackModuleAddEquiv` is marked `@[reducible]` (line 911). The attribute is intentional (needed so `isDefEq` can unfold it for the downstream instance matching in `gf_torsion_reindex`); the comment at line 1108 ("avoiding `isDefEq` blow-ups from stacked instances") corroborates this. However, reducible defs are unfolded everywhere by the kernel and can silently slow down elaboration in other files that import this module. Worth monitoring.
  - **Five new helper declarations review:**
    - `pullbackModuleAddEquiv` (line 911): semantically correct; the seven module axioms are individually verified.
    - `finite_of_pullbackModuleAddEquiv` (line 929): correct; uses `Module.Finite.equiv` with the `e`-linear equivalence.
    - `pullback_isScalarTower` (line 944): correct; the tower identity `(a • b) • e.symm x = a • e.symm (e (b • e.symm x))` reduces by `AddEquiv.symm_apply_apply` + `smul_assoc`.
    - `finite_of_quotientRingEquiv` (line 961): correct; `Module.Finite.trans` via `AlgEquiv.ofRingEquiv`.
    - `isLocalizedModule_restrictScalars` (line 979): correct; the three `IsLocalizedModule` obligations are discharged by unpacking `S.map (algebraMap R' R)` membership and applying `IsScalarTower.algebraMap_smul`.
  - **`gf_torsion_reindex` proof (lines 1040–1252):** The 212-line assembly is structurally sound. The key insight (working with the `P`-localisation `LocalizedModule MC T` to inherit the full `P_g`-module API, then transporting to the goal's `A`-localisation via the `A_g`-linear equivalence `eAgL`) is implemented correctly. The `isLocalizedModule_restrictScalars` call at line 1184 correctly descends the localization from `MC` to `powers g`.
  - **4 open `sorry`s** (lines 516, 1337, 1404, 1471): known scaffolding for L4, L5, `genericFlatnessAlgebraic` (finite-type residue), and `genericFlatness`. Not re-classified per directive.
  - **No** `#check`, `#eval`, or `section ScratchCheck` left behind.

---

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: 4 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[Known/tracked — Major]** `iter-177+` references in the docstrings of `hilbertPolynomial` (line 119), `QuotFunctor` (line 161), `Grassmannian` (line 195), `Grassmannian.representable` (line 219). All are known stale legacy cross-project references from the pre-extraction source. Already tracked per directive.
  - **4 open `sorry`s** (lines 126, 165, 201, 227): the sorry bodies of `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`. These are openly-disclosed scaffolding. Not re-classified per directive.
  - **Proved declarations:** `annihilator`, `annihilator_ideal_le`, `schematicSupport`, `schematicSupportι`, `HasProperSupport`, `annihilator_isLocalizedModule_eq_map`, and the full Hilbert–Serre rationality toolkit (`rationalHilbert_antidiff`, `IsRatHilb` closure lemmas, `IsRatHilb.ofDiffEq`) are all complete. The `annihilator_isLocalizedModule_eq_map` proof is notably thorough: the `⊆` direction clears a common denominator over the finite generating set; the `⊇` direction uses the algebraic `map ≤ comap` transfer.

---

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All five declared items (`QcohAlgebra`, `RelativeSpec`, `structureMorphism`, `UniversalProperty`, `affine_base_iff`) are complete proofs. No sorry.
  - `RelativeSpec` and `structureMorphism` correctly delegate to the Mathlib `relativeGluingData` gluing; this is the Block-A upgrade documented in the module docstring.
  - `UniversalProperty` proof uses `isAffineHom_of_forall_exists_isAffineOpen` + `d.toBase_preimage_eq_opensRange_ι` — the Mathlib handle is non-trivial and the proof is correct.
  - Docstring history notes ("iter-173 Lane B", "iter-174 Lane G", "iter-176", "iter-178", "iter-179 Block A") are descriptive provenance, not stale in a harmful sense.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations are complete (no sorry). The file is new this iter.
  - The `universalMatrix`, `minorDet`, `universalMinor`, `universalMinorInv`, `imageMatrix`, `transitionPreMap` chain is a correct implementation of the affine Grassmannian chart algebra.
  - `isUnit_det_universalMinor` correctly uses `RingHom.map_det + IsLocalization.Away.algebraMap_isUnit`.
  - `universalMatrix_submatrix_self` and `imageMatrix_submatrix_self` / `imageMatrix_submatrix_I` are proved cleanly via the order-iso and `mul_submatrix_col` helper.
  - The triple-overlap rings (`cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK`) and the cocycle proof use `IsLocalization.ringHom_ext` + `MvPolynomial.ringHom_ext` with the matrix identity `cocycle_imageMatrix_eq` as the core. The matrix algebra (`imageMatrix_map_eq`, `inv_mul_inv_mul_cancel`, `map_nonsing_inv`) is verified correctly.
  - `transitionMap_self` proof correctly shows the identity ring hom by unfolding `universalMinor = 1` → `universalMinorInv = 1` → `imageMatrix = X^I base-changed` → pre-hom is the structure map → away-lift is `id`.
  - The "Planner note" at lines 32–44 is blueprint documentation; not a code issue.
  - **No** `#check`, `#eval`, or `section ScratchCheck` left behind.

---

## Must-fix-this-iter

None found. No excuse-comments, no weakened-wrong definitions, no parallel APIs, no unauthorized `axiom`s.

---

## Major

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1322–1323` — Comment says "once `gf_torsion_reindex` (L5b, still `sorry`) lands" but `gf_torsion_reindex` was closed this iteration. Future readers will incorrectly conclude the remaining dependency is `gf_torsion_reindex` when it is already proved. The `sorry` at line 1337 remains legitimately for the other assembly steps, but the stated reason is stale.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:184–247` — [Known/tracked] Legacy STATUS comments referencing iter-234/236/240/241.
- `AlgebraicJacobian/Picard/QuotScheme.lean` (lines 119, 161, 195, 219) — [Known/tracked] Legacy `iter-177+` references in docstrings of the four scaffolded declarations.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1429` — [Known/tracked] Legacy `iter-177+` reference in `genericFlatness` docstring.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:637` — [Known/tracked] Inline `iter-241` annotation; same category as the lines 184–247 STATUS comments.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:975` — `set_option maxHeartbeats 4000000 in` on `base_change_mate_unit_value`. Honest explanatory comment present. High but justified budget.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1015–1018` — Stacked `set_option synthInstance.maxHeartbeats 1000000 in` + `set_option maxHeartbeats 4000000 in` on `gf_torsion_reindex`. Both bumps are explained; two simultaneous option overrides on a single decl is notable and should be revisited once the proof is stable.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:911` — `@[reducible]` on `pullbackModuleAddEquiv` is intentional (needed for `isDefEq` in `gf_torsion_reindex`) but will slow down any file importing this module that happens to trigger unification over types carrying this module structure. Monitor for downstream elaboration regressions.

---

## Excuse-comments (always called out separately)

None found. No declaration carries a comment admitting the code is wrong, placeholder, or will be replaced.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4 (1 new + 3 known/tracked)
- **minor**: 4 (3 known/tracked + 1 new)
- **excuse-comments**: 0

Overall verdict: Code is in good shape for the iter; the single new major issue is a stale intra-file comment that incorrectly names `gf_torsion_reindex` as the remaining dependency for `exists_free_localizationAway_polynomial` when that theorem is now proved. All sorries are openly-disclosed scaffolding; no weakened definitions or unauthorized axioms detected across all 7 files.
