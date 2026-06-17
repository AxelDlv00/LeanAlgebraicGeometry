# Blueprint-writer report — Picard_GrassmannianCells.tex coverage debt

## Outcome
Added six terse coverage blocks to `blueprint/src/chapters/Picard_GrassmannianCells.tex`, one per
DAG-unmatched prover-created helper. Each carries `\label`, exact `\lean{...}`, an accurate `\uses{}`
read off the Lean proof, and a 1–2 line statement/proof. No `\leanok` added; no existing block's math
modified; no other chapter touched.

## Labels created (Lean decl → label, placement)

1. `AlgebraicGeometry.Grassmannian.rotMid` → `lem:gr_rotMid`
   — placed just before `lem:gr_cocycle_phi_id` (the cocyclePhiId block it feeds).
   `\uses`: def:gr_cocycle_theta_ij, def:gr_cocycle_theta_jk, def:gr_away_mul_comm_equiv,
   lem:gr_awayMulCommEquiv_comp_algebraMap, lem:gr_awayMulCommEquiv_comp_awayInclLeft.

2. `AlgebraicGeometry.Grassmannian.transitionInvImageMatrix` → `lem:gr_transitionInvImageMatrix`
   — same cocycle cluster. The matrix `(W_K)⁻¹W` collapse over `S_I`.
   `\uses`: def:gr_image_matrix, def:gr_cocycle_theta_ik, def:gr_away_incl_left,
   def:gr_away_incl_right, def:gr_universal_matrix, def:gr_universalMinorInv, def:gr_universal_minor,
   lem:gr_awayInclLeft_comp_algebraMap, lem:gr_awayInclRight_comp_algebraMap,
   lem:gr_isUnit_algebraMap_away_right, lem:gr_minorDet_unit, lem:gr_map_map_eq_of_comp,
   lem:gr_map_nonsing_inv, lem:gr_mul_submatrix_col, lem:gr_universalMatrix_map_transitionPreMap,
   lem:gr_imageMatrix_map_eq, lem:gr_universalMatrix_submatrix_self.

3. `AlgebraicGeometry.Grassmannian.transitionInvPair` → `lem:gr_transitionInvPair`
   — same cluster; the residual inverse pair `Θ_{I,J,K} ∘ Θ_{K,I,J} ∘ swap_I = id`.
   `\uses`: lem:gr_transitionInvImageMatrix (its key feeder), def:gr_cocycle_theta_ik,
   def:gr_cocycle_theta_ij, def:gr_away_mul_comm_equiv, def:gr_away_incl_left, def:gr_transition_pre,
   def:gr_universal_matrix, lem:gr_awayMulCommEquiv_comp_algebraMap.

4. `AlgebraicGeometry.Grassmannian.det_one_updateCol` → `lem:gr_det_one_updateCol`
   — placed just before `lem:gr_free_entry_eq_signed_minor` (E3 cofactor block whose proof inlines it).
   No `\uses` (pure Mathlib: `Matrix.cramer_apply` + `Matrix.mulVec_cramer`, no project deps).

5. `AlgebraicGeometry.Grassmannian.liftToBaseOfMemRange` → `def:gr_liftToBaseOfMemRange`
   — placed right after `lem:gr_existence_factor_through_valuation_ring` (the E5 `g'` assembly).
   No `\uses` (built from `IsFractionRing`/`rangeRestrict`, no project deps).

6. `AlgebraicGeometry.Grassmannian.algebraMap_comp_liftToBaseOfMemRange`
   → `lem:gr_algebraMap_comp_liftToBaseOfMemRange`
   — immediately after (5). `\uses`: def:gr_liftToBaseOfMemRange.

## Verification
- All six `\label` defs appear exactly once; `\lean{...}` names match the Lean signatures verbatim.
- Every `\uses` target resolves to an existing `\label` in the chapter (spot-checked the cross-chapter
  and newly-introduced references).
- Did not add `\uses` edges into the existing proved blocks (cocyclePhiId, free_entry,
  factor_through_valuation_ring); per directive each new helper block carries its own dependency edges.

## Notes
- `awayMulCommEquiv_comp_awayInclLeft` (used by `rotMid`) was already blueprinted as
  `lem:gr_awayMulCommEquiv_comp_awayInclLeft`, so `rotMid` wires to it rather than duplicating.
- `transitionInvPair → transitionInvImageMatrix` is the one new intra-cluster edge; both sit
  immediately before the `cocyclePhiId` block they support.
