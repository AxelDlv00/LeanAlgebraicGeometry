# Lean Audit Report

## Slug
iter015

## Iteration
015

## Scope
- files audited: 5
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **L184–247** (`/-! ## Project-local Mathlib supplement — affine tilde dictionary`): A 64-line `STATUS (iter-234)` / `UPDATE (iter-236)` wall is embedded in the module docstring. Those iter numbers belong to the parent "Algebraic-Jacobian-Challenge" project, not the current Quot-Foundations project (which is on iter-015). The described "route (b)" is indeed what the code below implements, so the commentary is not factually wrong; but it conflates development journal with source documentation and makes it hard to read the actual module interface. Stale cross-project iteration numbers.
  - **L975** (`set_option maxHeartbeats 4000000 in`): 10× default heartbeat bump for `base_change_mate_unit_value`. The inline comment names the cause ("conjugate-unit calculus chains several `erw` / `simp` calls") but does not isolate which tactic(s) dominate. Not masking a logical error, but bumping by 10× without a profiling note or a targeted simplification attempt is a smell; if the step regresses, the budget will be exceeded again.
  - **L1197**: `sorry` in `base_change_mate_fstar_reindex` — honestly labelled "PARTIAL (iter-015)" with a detailed description of the remaining crux. Not an excuse-comment.
  - **L1242**: `sorry` in `base_change_mate_gstar_transpose` — same honest pattern.
  - **L1415**: `sorry` in `affineBaseChange_pushforward_iso` — the comment references "See `informal/affineBaseChange_pushforward_iso.md`". No `informal/` directory exists in the project tree (git status shows only `analogies/`). Broken reference.
  - **L1437**: `sorry` in `flatBaseChange_pushforward_isIso` — openly documented, no misrepresentation.
  - **L7** (`import AlgebraicJacobian.Cohomology.RegroupHelper`): This import brings in `RegroupHelper.lean` whose stated purpose is to enable `FlatBaseChange.lean` to close `base_change_mate_regroupEquiv`'s `map_smul'` with a one-liner. However, `base_change_mate_regroupEquiv` (L852–959) proves `map_smul'` entirely in-file via a full `TensorProduct.induction_on` argument and never calls `base_change_regroup_linearEquiv`. The import is effectively dead: the module's declared purpose was not fulfilled.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **L1015–1018**: Two `set_option` bumps precede `gf_torsion_reindex`:
    ```
    set_option synthInstance.maxHeartbeats 1000000 in   -- 2.5× default
    set_option maxHeartbeats 4000000 in                  -- 10× default
    ```
    Both are documented (deep doubly-indexed localisation instance search; heavy elaboration of the `Module.Finite` chain). However, the directive notes that a **cold `lake env lean <file>` tripped a heartbeat timeout near L1146** — which is inside `gf_torsion_reindex`. This means `maxHeartbeats 4000000` is not sufficient for non-incremental compilation. The bump documents honest necessity but is undersized for the cold path: a future `lake build --fresh` or a new contributor's first build may fail silently.
  - **File header / L1521+**: Comments reference "iter-177+" timelines from the parent project. These are cross-project iter numbers, not Quot-Foundations numbering. Low-impact but potentially confusing.
  - **L1430**: The call `exists_free_localizationAway_of_shortExact ... hf0 hf0 hM'_free hTf_free` passes the **same** element `f` for both `f'` and `f''` witness arguments, so the existential witness returned is `f * f = f²` rather than `f`. This is mathematically correct (the existential is satisfied, and `Localization.Away f ≅ Localization.Away (f²)` as rings/modules), but it is subtly non-obvious. Since `lake build` passes, this is not a compiler error, but a future reader will be confused by the redundant `hf0` arguments.
  - All sorry bodies (`exists_localizationAway_finite_mvPolynomial` L516, `free_localizationAway_of_away_tower` L1306, inner sorry in `exists_free_localizationAway_polynomial` L1417, `genericFlatnessAlgebraic` L1497, `genericFlatness` L1564) are honestly described with "genuine Mathlib-absent residue" / "OreLocalization diamond" / "geometric content" language. None are excuse-comments.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 3 flagged
- **dead-end proofs**: 1 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 4 flagged
- **notes**:
  - **L123** (`hilbertPolynomial := sorry`): The docstring says "iter-177+: the body unfolds to the graded-Euler-characteristic construction once χ ... is in scope. **For the iter-176 file-skeleton the body is a typed `sorry`.**" — explicit excuse-comment. The definition returns an arbitrary `Polynomial ℚ`, not the Hilbert polynomial of `F`.
  - **L161** (`QuotFunctor := sorry`): Docstring says "**For the iter-176 file-skeleton the body is a typed `sorry`.**" — explicit excuse-comment. Returns an arbitrary functor.
  - **L198** (`Grassmannian := sorry`): Docstring says "iter-177+: the body re-exports `QuotFunctor (𝟙 S) …` ... **For the iter-176 file-skeleton the body is a typed `sorry`.**" — explicit excuse-comment. The cited re-export `QuotFunctor (𝟙 S)` is itself sorry-bodied; this stacks one placeholder on another.
  - **L225** (`Grassmannian.representable := by sorry`): Docstring says "iter-177+: the body follows Nitsure §1 … **For the iter-176 file-skeleton the body is a typed `sorry`.**" — explicit excuse-comment on the sole representability theorem.
  - **Downstream effect**: `annihilator_ideal_le` (L305), `annihilator` (L298), `schematicSupport` (L312), and `HasProperSupport` (L328) are all sorry-free and correctly defined. These form the only non-sorry content in the file and are load-bearing for the `Quot`/`Grass` pipeline once the skeletons are filled.
  - **L435 (QuotScheme.lean section boundary)**: The `Module.annihilator_isLocalizedModule_eq_map` proof (L362–422) is complete and looks sound; no issues.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **L31–44**: A `/-  Planner note: Blueprint def:gr_affine_chart ... The prover should build `affineChart` as AlgebraicGeometry.Spec of that CommRingCat ... -/` comment precedes the `affineChart` definition. But `affineChart` is already built (L56: `AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial ...))`), exactly as described. This scaffold comment is now stale and should be removed.
  - All other declarations in the file (`universalMatrix`, `minorDet`, `universalMinor`, `isUnit_det_universalMinor`, `universalMinorInv`, `universalMinorInv_mul_cancel`, `imageMatrix`, `transitionPreMap`, `universalMatrix_submatrix_self`, `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I`, `universalMatrix_map_transitionPreMap`, `isUnit_transitionPreMap_minorDet`, `transitionMap`, `transitionMap_self`, `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK`, `cocycleCondition`) are fully proved with no sorry. The proofs look structurally sound for an affine-chart construction; in particular the cocycle identity is closed via a clean matrix computation.

---

### AlgebraicJacobian/Cohomology/RegroupHelper.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **L15–22 (module docstring)**: Claims the file's purpose is "enabling `FlatBaseChange.lean` to close its `base_change_mate_regroupEquiv` `map_smul'` with the one-liner `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`." This is **false**: `FlatBaseChange.lean` never calls `base_change_regroup_linearEquiv`; `base_change_mate_regroupEquiv` closes its own `map_smul'` via a full in-file `TensorProduct.induction_on` argument (L913–959). The stated purpose was not fulfilled. The file's main declaration is unused by its declared consumer.
  - The proof of `base_change_regroup_linearEquiv` itself is complete and axiom-clean (the `comm ≫ cancelBaseChange ≫ comm` route with `rightAlgebra` smul verification). The logic is correct; the issue is only the stale docstring.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/QuotScheme.lean:123` — `hilbertPolynomial := sorry` with explicit excuse-comment "For the iter-176 file-skeleton the body is a typed sorry". Returns arbitrary `Polynomial ℚ` rather than the actual Hilbert polynomial. Why must-fix: weakened definition with documented-as-placeholder body; any downstream proof relying on `hilbertPolynomial`'s actual values is vacuous.

- `AlgebraicJacobian/Picard/QuotScheme.lean:161` — `QuotFunctor := sorry` with explicit excuse-comment "For the iter-176 file-skeleton the body is a typed sorry". Returns arbitrary functor. Why must-fix: same — admitted placeholder on a top-level blueprint-pinned declaration; the functor has no real content.

- `AlgebraicJacobian/Picard/QuotScheme.lean:198` — `Grassmannian := sorry` with explicit excuse-comment "For the iter-176 file-skeleton the body is a typed sorry". Additionally, the docstring claims the real body "re-exports `QuotFunctor (𝟙 S) …`" which is itself sorry-bodied — stacking one unproven definition on another. Why must-fix: compound placeholder; the Grassmannian definition is the anchor for `Grassmannian.representable`.

- `AlgebraicJacobian/Picard/QuotScheme.lean:225` — `Grassmannian.representable := by sorry` with explicit excuse-comment "For the iter-176 file-skeleton the body is a typed sorry". Why must-fix: sole representability theorem; sorry on a load-bearing theorem with a filed disclaimer.

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:7` — dead import of `RegroupHelper`. The module's stated purpose ("enable `base_change_mate_regroupEquiv map_smul'` with a one-liner") was not realised; `base_change_regroup_linearEquiv` is never called in `FlatBaseChange.lean`. The import pulls in a full compilation unit for no effect, and it silently hides that the `base_change_mate_regroupEquiv` proof takes a different (larger) route.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:184` — 64-line `STATUS (iter-234)` / `UPDATE (iter-236)` block in the module docstring references parent-project (Algebraic-Jacobian-Challenge) iteration numbers. The current project is on iter-015. These cross-project iter numbers are misleading to any reader who takes the numbers at face value and confuse the source file's documentation with development history from a different repo.

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1015` — `maxHeartbeats 4000000` (10× default) is documented as necessary, but the directive reports a **cold `lake env lean <file>` timeout near L1146**, inside `gf_torsion_reindex`. The current limit is therefore insufficient for cold or clean-build compilation paths. This is not simply a masking-a-problem situation; the elaboration is genuinely expensive. But the mismatch between incremental-build success and cold-build failure is a reliability hazard that must be addressed (either by raising the limit further, by restructuring the proof to reduce instance-search depth, or by explicitly documenting that cold lean invocations are unsupported for this file).

- `AlgebraicJacobian/Picard/GrassmannianCells.lean:31` — stale planner/scaffold comment describing how `affineChart` "should be built" — but it is already built correctly in the lines that follow. The comment is now dead guidance and should be removed.

- `AlgebraicJacobian/Cohomology/RegroupHelper.lean:15` — module docstring claims the file enables a specific one-liner in `FlatBaseChange.lean` that is never used. The stale and inaccurate docstring misrepresents both the file's actual value and the state of `FlatBaseChange.lean`. (The proof in `RegroupHelper.lean` is correct; only the stated purpose is wrong.)

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:975` — `maxHeartbeats 4000000` for `base_change_mate_unit_value` is a 10× default bump. The comment identifies the cause ("several `erw` defeq-unifications and a `simp` closure") but does not isolate which tactic dominates. A `lean_profile_proof` run would identify the hot spot and allow a targeted fix (e.g., replacing a slow `simp` with a direct lemma). Not critical while the theorem compiles, but worth profiling before the budget is needed elsewhere.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1415` — `affineBaseChange_pushforward_iso`'s sorry comment references "See `informal/affineBaseChange_pushforward_iso.md`." No `informal/` directory exists in the project (the analogies directory is `analogies/`). Broken file reference.

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1430` — In `exists_free_localizationAway_polynomial`, the same witness `hf0 : f ≠ 0` is passed as both `hf'` and `hf''` to `exists_free_localizationAway_of_shortExact`, giving freeness at `f * f = f²`. The result is mathematically correct (the existential is satisfied) but subtly non-obvious: a future reader would expect different witnesses for the two short-exact-sequence ends.

---

## Excuse-comments (always called out separately)

- `QuotScheme.lean:119`: "For the iter-176 file-skeleton the body is a typed `sorry`" (attached to `hilbertPolynomial`, the blueprint-pinned Hilbert-polynomial definition). Severity: **critical** — load-bearing def returns arbitrary `Polynomial ℚ`.

- `QuotScheme.lean:157`: "For the iter-176 file-skeleton the body is a typed `sorry`" (attached to `QuotFunctor`). Severity: **critical** — load-bearing functor definition.

- `QuotScheme.lean:194`: "For the iter-176 file-skeleton the body is a typed `sorry`" + "iter-177+: the body re-exports `QuotFunctor (𝟙 S) …`" (attached to `Grassmannian`, which stacks on the sorry-bodied `QuotFunctor`). Severity: **critical**.

- `QuotScheme.lean:219`: "For the iter-176 file-skeleton the body is a typed `sorry`" (attached to `Grassmannian.representable`, the sole representability theorem). Severity: **critical**.

---

## Severity summary

- **must-fix-this-iter**: 4 — these block downstream work in `QuotScheme.lean` until addressed; no meaningful property of `hilbertPolynomial`, `QuotFunctor`, or `Grassmannian` can be proved until the sorry bodies are replaced.
- **major**: 5 — dead import + cross-project iter numbers + cold-build heartbeat insufficiency + stale scaffold comment + inaccurate RegroupHelper docstring.
- **minor**: 3 — unprofiled 10× maxHeartbeats bump, broken informal/ path reference, identical f² witness subtlety.
- **excuse-comments**: 4 (all four counted under must-fix-this-iter above; called out separately because they document the project lying to itself about its own definitions).

Overall verdict: `QuotScheme.lean` carries four blueprint-pinned declarations that are explicitly labelled placeholder-sorry stubs and must be addressed this iteration; `GrassmannianCells.lean` and `RegroupHelper.lean` are otherwise clean, and the rest of the sorry bodies in `FlatBaseChange.lean` and `FlatteningStratification.lean` are honestly documented partial proofs.
