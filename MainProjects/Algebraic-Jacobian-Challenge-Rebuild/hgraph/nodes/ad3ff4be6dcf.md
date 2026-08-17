---
author: sync
content_type: definition
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.finiteStageTensorPushoutScalarExtension_named
docstring: 'Scalar extension of a named finite-stage tensor pushout, expressed with
  the named

  source and target rings and the scalar extensions of the original algebra maps.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageTensorPushoutUniversal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finiteStageTensorPushoutScalarExtension_named
type: lean
updated: '2026-08-17T13:21:30'
---
noncomputable def finiteStageTensorPushoutScalarExtension_named
    {R K A B₁ B₂ : Type u}
    [CommRing R] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra R K] [Algebra R A] [Algebra R B₁] [Algebra R B₂]
    (f₁ : A →ₐ[R] B₁) (f₂ : A →ₐ[R] B₂) :
    let kf₁ := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := R) (K := K) f₁
    let kf₂ := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := R) (K := K) f₂
    (K ⊗[R] Pic0FiniteStageTensorPushoutRing f₁ f₂) ≃ₐ[K]
      Pic0FiniteStageTensorPushoutRing kf₁ kf₂ :=
  finiteStageTensorPushoutScalarExtension (K := K) f₁ f₂