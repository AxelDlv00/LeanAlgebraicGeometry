---
author: sync
content_type: theorem
created: '2026-08-01T14:45:38'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.projective_intrinsicThetaGlued
docstring: The underlying intrinsic theta module is projective over the test ring.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaEffective.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.projective_intrinsicThetaGlued
type: lean
updated: '2026-08-02T07:12:51'
---
theorem IsCertified.projective_intrinsicThetaGlued {g : ℕ}
    (hc : A.IsCertified g) :
    Module.Projective R (A.IntrinsicThetaGlued (π := π) a) := by
  let AD := gluedSubalgebra A
  let M := A.IntrinsicThetaGluedOver (π := π) a
  letI : Module R M := Module.compHom M (algebraMap R AD)
  letI : Module.Projective R M :=
    hc.projective_intrinsicThetaGluedOver_base (π := π) A a
  exact Module.Projective.of_equiv
    (A.intrinsicThetaGluedOverEquivIntrinsic (π := π) a)