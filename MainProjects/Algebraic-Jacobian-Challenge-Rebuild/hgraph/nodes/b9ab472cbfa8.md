---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.classDeg_cechPicMap_picClass_single
docstring: 'The single-point case of EV-main: pulling back the class of a one-point
  divisor

  multiplies its degree by `n = [K(X) : K(Y)]`.'
file: AlgebraicJacobian/RiemannRoch/DegreePullback.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.classDeg_cechPicMap_picClass_single
type: lean
updated: '2026-07-31T15:13:17'
---
private theorem classDeg_cechPicMap_picClass_single (f : X ⟶ Y) [IsFinite f]
    (hcomp : f ≫ (Y ↘ Spec (CommRingCat.of K)) = X ↘ Spec (CommRingCat.of K))
    (hf : f.base (genericPoint X) = genericPoint Y)
    {x' : Y} (hx' : x' ≠ genericPoint Y) :
    letI := f.functionFieldAlgebra hf
    classDeg K (Scheme.CechPic.map f
        (Scheme.CurveDivisor.picClass K (Scheme.CurveDivisor.single hx' 1)))
      = (Module.finrank Y.functionField X.functionField : ℤ)
        * classDeg K (Scheme.CurveDivisor.picClass K
            (Scheme.CurveDivisor.single hx' 1)) := by
  letI := f.functionFieldAlgebra hf
  have h1 : Scheme.CechPic.map f
      (Scheme.CurveDivisor.picClass K (Scheme.CurveDivisor.single hx' 1))
      = (pointPullbackEquations K f hf hx').picClass := by
    rw [Scheme.CurveDivisor.picClass_single K hx']
    exact (Scheme.LocalEquations.picClass_pullback _ _ _).symm
  have h2 : (pointPullbackEquations K f hf hx').picClass
      = Scheme.CurveDivisor.picClass K (Scheme.presentationDivisor K
          (pointPullbackEquations K f hf hx').presentation) := by
    rw [Scheme.CurveDivisor.picClass_presentationDivisor,
      Scheme.LocalEquations.presentation_picClass]
  rw [h1, h2, classDeg_picClass, classDeg_picClass,
    deg_presentationDivisor_pointPullback K f hcomp hf hx',
    Scheme.CurveDivisor.deg_single' K hx' 1]
  ring