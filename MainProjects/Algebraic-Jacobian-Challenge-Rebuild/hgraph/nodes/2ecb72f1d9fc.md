---
author: sync
content_type: theorem
created: '2026-08-03T20:05:08'
decl: AlgebraicGeometry.classDeg_twistedClass_eq
docstring: 'The honest twisted class has the chart parameter as its degree after every
  field-valued

  base change of the affine test.'
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveTarget.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.classDeg_twistedClass_eq
type: lean
updated: '2026-08-03T20:05:08'
---
theorem classDeg_twistedClass_eq
    {T : Over (Spec (.of k))} (lam : pic0Subgroup C T)
    {B : Type u} [CommRing B] [Algebra k B]
    (g : overSpec k B ⟶ T)
    (c : (relCurve C B).CechPic)
    (hpic : picEtMap C g (lam : picEt C T) =
      relPicToPicEt C (overSpec k B) (relPicMk C (overSpec k B) c))
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z =
      (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (K : Type u) [Field K] [Algebra k K] [Algebra B K]
    [IsScalarTower k B K] :
    classDeg K (Scheme.CechPic.map (relCurveMap C B K)
      (c * Scheme.CechPic.map (relCurveMap C k B)
        (chartTwistClass C m Z))) = (n : ℤ) := by
  let t : overSpec k K ⟶ overSpec k B :=
    Over.overSpecMap (IsScalarTower.toAlgHom k B K)
  have h := congrArg
    (fun mu : picEt C (overSpec k B) => degAt mu t)
    (relPicToPicEt_twistedClass_eq_chartTwist lam g c hpic m Z)
  rw [degAt_relPicToPicEt, relPicMap_mk, relPicDeg_relPicMk,
    degAt_chartTwist m Z (pic0Map C g lam).2 t] at h
  have ht : (C ◁ t).left = relCurveMap C B K := by
    refine congrArg (fun q : overSpec k K ⟶ overSpec k B => (C ◁ q).left) ?_
    exact Over.OverMorphism.ext rfl
  rw [ht] at h
  calc
    _ = (m : ℤ) * classDeg k (thetaCechClass C) -
        Scheme.CurveDivisor.deg k Z := h
    _ = (n : ℤ) := by rw [hdeg]; ring