---
author: sync
content_type: definition
created: '2026-08-01T10:43:32'
decl: AlgebraicGeometry.AffAdaptation.thetaDescentCoaction
docstring: "The left Cech arrow is linear over the product piece algebra: both the\
  \ source and the\noverlap target use the first piece coordinate. -/\nnoncomputable\
  \ def thetaIntrinsicDeltaLeftCP :\n    A.ThetaPieceProd (π := π) a →ₗ[A.chartProd]\n\
  \      A.ThetaOverlapProd (π := π) a where\n  toFun := A.thetaIntrinsicDeltaLeftGlued\
  \ (π := π) a\n  map_add' := (A.thetaIntrinsicDeltaLeftGlued (π := π) a).map_add\n\
  \  map_smul' := by\n    intro b s\n    funext p\n    change A.thetaToOverlapLeft\
  \ (π := π) a p.1 p.2 (b p.1 • s p.1) =\n      A.toOvlLeft p.1 p.2 (b p.1) •\n  \
  \      A.thetaToOverlapLeft (π := π) a p.1 p.2 (s p.1)\n    exact A.thetaToOverlapLeft_smul\
  \ (π := π) a p.1 p.2 (b p.1) (s p.1)\n\n@[simp]\ntheorem thetaIntrinsicDeltaLeftCP_apply\n\
  \    (s : A.ThetaPieceProd (π := π) a) (p : D.index × D.index) :\n    A.thetaIntrinsicDeltaLeftCP\
  \ (π := π) a s p =\n      A.thetaToOverlapLeft (π := π) a p.1 p.2 (s p.1) := by\n\
  \  rfl\n\n/- The left face transported through the right tensor comparison is the\
  \ candidate descent\ncoaction on the product of local theta lines."
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCoaction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaDescentCoaction
type: lean
updated: '2026-08-01T10:43:32'
---
noncomputable def thetaDescentCoaction {n : ℕ} (hc : A.IsCertified n) :
    A.ThetaPieceProd (π := π) a →ₗ[A.chartProd]
      A.chartProd ⊗[↥(gluedSubalgebra A)] A.ThetaPieceProd (π := π) a :=
  (A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc).symm.toLinearMap.comp
    (A.thetaIntrinsicDeltaLeftCP (π := π) a)

@[simp]