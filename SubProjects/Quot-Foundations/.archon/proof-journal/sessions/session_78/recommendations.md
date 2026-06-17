# Recommendations — for the iter-079 plan agent

## HIGH — closest-to-completion, dispatch next

1. **GlueDescent `glueOverlapFactor_transpose` (L1679)** — the single highest-value pick. The
   keystone `isIso_glueRestrictionHom` and 5 downstream decls (`glueOverlapFactor_mate`,
   `glueRestriction_overlap_compat`, `glueRestrictionHom_glueChartComponent`,
   `isIso_glueRestrictionHom`, `glueRestrictionIso`) all sit in a 5-deep transitive sorry chain
   off THIS one sorry (auditor major #2). It is `≤60 lines, NO new math`: `hRHS`, `h_a`, `n₁–n₃`
   already proven in-body; remaining = whisker-assembly + `ext V x` + `glueOverlapBaseChangeIso_hom_app_app`
   + `Subsingleton` restriction-cycle fold (exactly the `glueChartComponent_self_counit` ending).
   Closing it cascades 5 decls to sorry-free and unblocks lane-2 epi (item 3).

2. **GlueDescent `glueChartFamily_equalizes` (L1431)** — the one genuinely-new GlueDescent piece.
   Route fully scoped in-code at the sorry: componentwise via `piComparison`, transpose along the
   triple-overlap immersion exactly like `glueOverlapFactor_mate`, needing (a) a triple-overlap
   opens identity (analogue of `glueData_preimage_image_eq`), (b) a triple β (same 4-factor recipe
   + `appIso_compat`), (c) the transposed component IS `hC2 i p q`. Strictly easier AFTER item 1
   lands (every needed pattern then has a worked in-file template). Session-scale.

3. **GrassmannianQuot `tautologicalQuotient_epi` (L2469)** — STILL BLOCKED, do NOT reassign until
   item 1/2 land a `Mono(glueRestrictionHom i)` (or full `isIso_glueRestrictionHom`) sorry-free in
   GlueDescent. Then ~30 lines: `pullback_map_jointly_faithful` (proven this iter) + cancel against
   the iso. Trigger documented in `task_results/…GrassmannianQuot.lean.md`.

4. **GrassmannianQuot `grPointOfRankQuotient` overlap (L3217)** — matrix heart DONE
   (`presentedMatrix_changeOfBasis`, `isUnit_of_isIso_matrixEndRect`). Remaining is mechanical
   Γ–Spec/localization plumbing (steps 1,4,5: `Scheme.toSpecΓ_naturality`, `IsLocalization.Away.lift`
   through `chartIncl`, `universalMatrix_map_transitionPreMap` comparison, `glue_condition`). Several
   hundred lines of GrassmannianCells API archaeology — large but unblocked, route-mapped in-code.
   `represents.left_inv`/`right_inv` ride on this; do not assign them before the overlap closes.

## MEDIUM — blueprint adequacy (blueprint-writer / planner, gate-relevant)

5. **chartLocus_isOpenCover ROUTE MISMATCH (must-fix from grquot checker, confirmed).** Blueprint
   prose describes stalkwise-Nakayama; the Lean formalized affine projective-splitting. `% NOTE`
   added to the proof block this iter. Dispatch a **blueprint-writer** on `Picard_GrassmannianQuot.tex`
   to rewrite the `lem:chartLocus_isOpenCover` proof to the affine-splitting route, naming
   `exists_section_of_epi_free_spec` / `exists_rightInverse_of_epi_matrixEndRect` /
   `exists_isUnit_submatrix` / minor-det basic open. Also fix the two stale Lean docstrings
   (a refactor/prover task — review can't edit `.lean`).

6. **1-to-1 coverage debt (≈30 new substantive decls lack blueprint blocks).** When there is Lean
   there must be tex. The planner should author blocks (chapters `Picard_GlueDescent.tex`,
   `Picard_GrassmannianQuot.tex`). Lists with `Uses:` are in the prover task_results; key ones:
   - *GlueDescent* (14, per glue checker): `appLE_congr_mor`, `glueData_overlap_appIso_compat`,
     `glueOverlapFactorIso`, `glueChartComponent`, `glueChartFamily`, `glueRestrictionInv`,
     `glueRestrict_proj_compat`, `glueRestrictionInv_pullback_map_glueProj`, `glueRestrict_hom_ext`,
     `glueChartComponent_self_counit`, `glueRestrictionHom_glueChartComponent`, `glueOverlapFactor_mate`,
     `glueRestriction_overlap_compat`, `pullback_map_jointly_faithful` (consider re-pointing
     `lem:gr_modules_glue_unique` here), `glueOverlapBaseChangeIso_{inv,hom}_app_app`,
     `restrictAdjunction_unit_app_iso`, `restrictFunctorIsoPullback_hom_app_counit`.
   - *GrassmannianQuot* (≈15, per grquot checker): `chartComposite`, `chartMatrixHom`, `chartMatrix`,
     `chartMorphism` (Nitsure §1 chain), `presentedMatrix`, `presentedMatrix_changeOfBasis`,
     `isUnit_of_isIso_matrixEndRect`, `exists_section_of_epi_free_spec`,
     `exists_rightInverse_of_epi_matrixEndRect`, `chartMatrix_minor`/`freeMap_chartMatrixHom`,
     `tautologicalRankQuotient`, `grPointOfRankQuotient_rel`, `chartMorphism_rel`, `matrixEndRect_comp_rect`.
   - *SectionGradedRing*: 2 private whisker helpers (`tensorObjWhiskerRightIso/LeftIso`) — planner's
     call whether to blueprint or leave as proof-internal steps of `lem:sheafTensorPow_add`.
   - NOTE: the grquot checker's "3 broken `\lean{}` pins" were FALSE POSITIVES (decls relocated,
     all exist at L386/L878/L271) — do NOT "fix" those pins.

## MEDIUM — code health (refactor subagent)

7. **7 replicated GrassmannianCells private lemmas** (auditor major #1):
   `mul_submatrix_col'`, `map_nonsing_inv'`, `map_map_eq_of_comp'`, `isUnit_algebraMap_away_left'`,
   `inv_mul_inv_mul_cancel'`, `imageMatrix_map_eq'`, `cocycle_imageMatrix_eq'` (GrassmannianQuot.lean
   L503–706) are literal copies of `private` originals in GrassmannianCells.lean. Make originals
   non-private (or move to a shared module) and delete the copies — silent-drift maintenance risk.

## Reusable proof patterns discovered (this iter)
- **X.Modules / SheafOfModules diamond:** `rw`/`simp` with comp-node lemmas (`Functor.map_comp`,
  `Category.assoc`, reassoc) fail silently even when the goal prints the pattern. Use `erw` (single
  closed-head, watch whnf-timeout), term-mode `whisker_eq`/`eq_whisker`/`Category.assoc` chains, or
  generic `have`s closed by `simp` then applied by unification (pin the category CONCRETELY — `Type _`
  leaks universe mvars → bogus `Trans Eq Eq ?m` calc errors).
- **asIso in long `≪≫` chains:** pass `IsIso` explicitly `@asIso _ _ _ _ f h`; never rely on synthesis.
- **`whiskerRightIso` with an iso arg typed in `X.PresheafOfModules`** breaks `(C := MonoidalPresheaf X)`
  unification; use morphism-level `whiskerRight` + `Iso.mk`. `whiskerLeftIso` is fine (object arg).
- **Epi→split on affines (no Mathlib SheafOfModules stalk theory):** conjugate through `tildeFinsupp`,
  `tilde.functor` reflects epi to ModuleCat, `Module.projective_lifting_property` splits. `CommRingCat.of ↥R = R` is `rfl`.
- **Cross-RingCat/forget₂ equalities:** elementwise `congr($(h) x)`, never `rw`.
- `include` must precede the docstring, not sit between docstring and `lemma`.

## Do-NOT-retry
- `tautologicalQuotient_epi` while GlueDescent keystone is sorried (rests on lane-1 sorries).
- `rw`/positional rewrites of comp-nodes under the Modules diamond (see patterns above).
- `whiskerRightIso` with iso-valued arg in the PresheafOfModules spelling.
