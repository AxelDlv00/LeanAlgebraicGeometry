---
author: sync
content_type: theorem
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.thetaDescentCoaction_coassoc
docstring: The intrinsic theta coaction satisfies the coassociativity law of module
  descent.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCoassoc.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.thetaDescentCoaction_coassoc
type: lean
updated: '2026-08-01T13:31:19'
---
theorem IsCertified.thetaDescentCoaction_coassoc {n : ℕ}
    (hc : A.IsCertified n) (s : A.ThetaPieceProd (π := π) a) :
    ((A.thetaDescentCoaction (π := π) a hc).restrictScalars
        (gluedSubalgebra A)).baseChange A.chartProd
        (A.thetaDescentCoaction (π := π) a hc s) =
      (TensorProduct.mk (gluedSubalgebra A) A.chartProd
        (A.ThetaPieceProd (π := π) a) 1).baseChange A.chartProd
        (A.thetaDescentCoaction (π := π) a hc s) := by
  exact (A.thetaDescentCoaction_coassoc_iff_baseChange_faces
    (π := π) a hc s).2
      (hc.thetaIntrinsic_baseChange_faces_coaction A a s)

set_option synthInstance.maxHeartbeats 500000 in
-- Packaging retains the dependent product module and scalar-tower instances.