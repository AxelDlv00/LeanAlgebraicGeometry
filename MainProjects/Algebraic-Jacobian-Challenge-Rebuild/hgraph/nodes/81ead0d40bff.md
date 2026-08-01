---
author: sync
content_type: theorem
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.overlapCoordinateDistrib_tmul_apply
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTripleProductBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.overlapCoordinateDistrib_tmul_apply
type: lean
updated: '2026-08-02T07:12:52'
---
theorem overlapCoordinateDistrib_tmul_apply
    (p : D.index × D.index) (b : A.chartProd)
    (x : A.ThetaOverlapQuotient (π := π) a p.1 p.2) (l : D.index) :
    A.overlapCoordinateDistrib (π := π) a p
        (b ⊗ₜ[gluedSubalgebra A] x) l =
      b l ⊗ₜ[gluedSubalgebra A] x := by
  change A.overlapCoordinateDistribBase (π := π) a p
      (b ⊗ₜ[gluedSubalgebra A] x) l = _
  exact A.overlapCoordinateDistribBase_tmul_apply (π := π) a p b x l

set_option synthInstance.maxHeartbeats 500000 in
-- The nested dependent products combine the chart, overlap, and triple module towers.