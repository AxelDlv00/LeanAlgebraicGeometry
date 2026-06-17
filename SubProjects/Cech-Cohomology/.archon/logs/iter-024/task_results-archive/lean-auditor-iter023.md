# Lean Audit Report

## Slug
iter023

## Iteration
023

## Scope
- files audited: 2 (per directive scope)
- files skipped (per directive): all other project `.lean` files — directive limited scope to the two modified files

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged
- **excuse-comments**: none
- **notes**:
  - **Line 14–16 / 21–22 (module docstring)**: The file header states "this file owns the two free-complex declarations" and names `AlgebraicGeometry.cechFreeComplex_quasiIso` as one of them. The declaration does **not exist** in the file. The parenthetical "(not yet built — ...)" at lines 23–25 is an honest mitigating annotation, but the framing of "owns" a declaration that is absent is stale. The docstring should say "this file builds toward" rather than "owns". Severity: **major**.
  - **Lines 1117–1129 (cechFreeEvalEngine_comm)**: The positive branch of the `by_cases hσ` proof uses 7 consecutive `erw` calls (`← Functor.map_comp`, `Functor.map_sum`, `Preadditive.sum_comp`, `Preadditive.comp_zsmul`, `Functor.map_zsmul`, `Preadditive.zsmul_comp`, then two more). The `erw` cascade is navigating definitional equality gaps arising from `cechFreeEvalEngine_X` being a triple-composite iso (`cechFreeEval_X ≪≫ cechFreeEvalDropZeros ≪≫ whiskerEquiv.symm`). Since the file is reported axiom-clean this is not a correctness red flag, but the proof is fragile to refactoring of `cechFreeEvalEngine_X` and masks the precise defeq structure being exploited. Severity: **minor**.
  - **Line 818 (cechEngineX)**: Declared `noncomputable abbrev` rather than `def`. Using `abbrev` makes the definition transparent to the elaborator, which can introduce costly typeclass search and unexpected unfoldings. Here it is intentional (allows later `rfl`-level defeq in `cechFreeEvalEngine_comm`), but should be documented. Severity: **minor**.
  - **Line 1210 (cechEngineD_comp_aug)**: Single `erw [cechEngineAug0_ι, cechEngineAug0_ι]` needed because after `Fin.sum_univ_two` expansion the types are only definitionally (not syntactically) equal for `rw`. Acceptable given context; noted for completeness. Severity: **minor**.
  - No `sorry`, no `admit`, no excuse-comments, no weakened-wrong definitions, no parallel Mathlib APIs.

---

### AlgebraicJacobian/Cohomology/CechBridge.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none (new declarations only; pre-existing `erw`-heavy proofs in `homCechSectionCosimplicialIso` and `homCechComplex_d_eq` are out of iter-023 scope)
- **excuse-comments**: none
- **notes**:
  - **Lines 54, 58–64 (planned declarations)**: `injective_cech_acyclic`, `ses_cech_h1`, `cech_eq_cohomology_of_basis`, `affine_serre_vanishing` are described as "(planned, gated on ...)" — these are accurate future-goal notes, not excuse-comments. No action needed.
  - **sectionCech_objD_exact_of_isZero_homology (lines 456–477)**: Clean proof. Correctly extracts `Function.Exact` from `IsZero` on homology via `exactAt_iff_isZero_homology` → `exactAt_iff'` → `ShortComplex.ab_exact_iff_function_exact`. The `hf`/`hg` rewrites to unfold `objD` at the end are correct.
  - **sectionCech_one_coboundary_of_isZero_homology (lines 495–522)**: Clean 28-line proof. Correct application of `sectionCech_objD_exact_of_isZero_homology` for `q = 0`, working in product coordinates via `sectionCechProductEquiv`. No `erw`. No suspect tactics.
  - No `sorry`, no excuse-comments, no suspect bodies.

---

## Must-fix-this-iter

*(none)*

No finding meets the must-fix bar: there are no `sorry` on load-bearing claims, no excuse-comments, no weakened-wrong definitions, no parallel-Mathlib APIs, and no axiom uses on non-trivial claims.

---

## Major

- `FreePresheafComplex.lean:14–22` — Module docstring states the file "owns the two free-complex declarations" including `cechFreeComplex_quasiIso`, which does not exist in the file. The "(not yet built — ...)" parenthetical mitigates misleading the reader, but "owns" overstates the current state. The docstring should be revised to reflect that the file builds prerequisites toward `cechFreeComplex_quasiIso`, not that it owns it.

---

## Minor

- `FreePresheafComplex.lean:1117–1129` — `cechFreeEvalEngine_comm`: 7 consecutive `erw` calls in the positive case of `by_cases hσ`. Correct but fragile; any restructuring of `cechFreeEvalEngine_X` will silently break this proof. Consider extracting the rewrite chain into a named lemma or using `conv` + explicit coercion to make the defeq explicit.
- `FreePresheafComplex.lean:818` — `cechEngineX` declared as `noncomputable abbrev` rather than `noncomputable def`. Add a one-line comment explaining why transparency is needed (to allow `rfl`-level defeq in subsequent proofs).
- `FreePresheafComplex.lean:1210` — `cechEngineD_comp_aug`: `erw [cechEngineAug0_ι, cechEngineAug0_ι]` could be replaced with `simp [cechEngineAug0_ι]` if `simp` handles the two instances; worth checking.

---

## Excuse-comments (always called out separately)

*(none found in either file)*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (stale "owns" claim in FreePresheafComplex.lean module docstring)
- **minor**: 3 (erw-heavy proof, undocumented abbrev, single erw in aug lemma)
- **excuse-comments**: 0

Overall verdict: Both files are axiom-clean with no sorry, no excuse-comments, and no suspect definitions; the sole elevated finding is the stale "owns" wording in the FreePresheafComplex module docstring, which should be updated to reflect that `cechFreeComplex_quasiIso` is a goal not yet achieved rather than a declaration the file owns.
