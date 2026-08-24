---
author: sync
content_type: definition
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.tensorPushoutAlgEquivCongr
docstring: 'Tensor-product pushouts are invariant under compatible equivalences of
  their base

  and two factors.  The result is an equivalence over the common ground ring.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageTripleModelComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tensorPushoutAlgEquivCongr
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def tensorPushoutAlgEquivCongr
    {R A1 A2 B1 B2 D1 D2 : Type u}
    [CommRing R] [CommRing A1] [CommRing A2]
    [CommRing B1] [CommRing B2] [CommRing D1] [CommRing D2]
    [Algebra R A1] [Algebra R A2]
    [Algebra R B1] [Algebra R B2] [Algebra R D1] [Algebra R D2]
    (f1 : A1 →ₐ[R] B1) (g1 : A1 →ₐ[R] D1)
    (f2 : A2 →ₐ[R] B2) (g2 : A2 →ₐ[R] D2)
    (eA : A1 ≃ₐ[R] A2) (eB : B1 ≃ₐ[R] B2) (eD : D1 ≃ₐ[R] D2)
    (hf : eB.toAlgHom.comp f1 = f2.comp eA.toAlgHom)
    (hg : eD.toAlgHom.comp g1 = g2.comp eA.toAlgHom) :
    letI : Algebra A1 B1 := f1.toRingHom.toAlgebra
    letI : Algebra A1 D1 := g1.toRingHom.toAlgebra
    letI : Algebra A2 B2 := f2.toRingHom.toAlgebra
    letI : Algebra A2 D2 := g2.toRingHom.toAlgebra
    letI : IsScalarTower R A1 B1 :=
      IsScalarTower.of_algebraMap_eq (fun x => (f1.commutes x).symm)
    letI : IsScalarTower R A2 B2 :=
      IsScalarTower.of_algebraMap_eq (fun x => (f2.commutes x).symm)
    B1 ⊗[A1] D1 ≃ₐ[R] B2 ⊗[A2] D2 := by
  letI : Algebra A1 B1 := f1.toRingHom.toAlgebra
  letI : Algebra A1 D1 := g1.toRingHom.toAlgebra
  letI : Algebra A2 B2 := f2.toRingHom.toAlgebra
  letI : Algebra A2 D2 := g2.toRingHom.toAlgebra
  letI : IsScalarTower R A1 B1 :=
    IsScalarTower.of_algebraMap_eq (fun x => (f1.commutes x).symm)
  letI : IsScalarTower R A2 B2 :=
    IsScalarTower.of_algebraMap_eq (fun x => (f2.commutes x).symm)
  let P1 := B1 ⊗[A1] D1
  let P2 := B2 ⊗[A2] D2
  let jB : B1 →+* P2 :=
    Algebra.TensorProduct.includeLeftRingHom.comp eB.toRingEquiv.toRingHom
  let jD : D1 →+* P2 :=
    Algebra.TensorProduct.includeRight.toRingHom.comp eD.toRingEquiv.toRingHom
  have ht : IsPushout
      (CommRingCat.ofHom f1.toRingHom) (CommRingCat.ofHom g1.toRingHom)
      (CommRingCat.ofHom jB) (CommRingCat.ofHom jD) := by
    apply (CommRingCat.isPushout_tensorProduct A2 B2 D2).of_iso'
      eA.toRingEquiv.toCommRingCatIso eB.toRingEquiv.toCommRingCatIso
      eD.toRingEquiv.toCommRingCatIso (Iso.refl (CommRingCat.of P2))
    · ext x
      exact DFunLike.congr_fun hf.symm x
    · ext x
      exact DFunLike.congr_fun hg.symm x
    · rfl
    · rfl
  have hs : IsPushout
      (CommRingCat.ofHom f1.toRingHom) (CommRingCat.ofHom g1.toRingHom)
      (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
        (R := A1) (A := B1) (B := D1)))
      (CommRingCat.ofHom (Algebra.TensorProduct.includeRight
        (R := A1) (A := B1) (B := D1)).toRingHom) :=
    CommRingCat.isPushout_tensorProduct A1 B1 D1
  let ie : CommRingCat.of P1 ≅ CommRingCat.of P2 :=
    hs.isoIsPushout (CommRingCat.of B1) (CommRingCat.of D1) ht
  have left_formula (b : B1) :
      ie.hom.hom (b ⊗ₜ[A1] (1 : D1)) = eB b ⊗ₜ[A2] (1 : D2) := by
    have hleft := hs.inl_isoIsPushout_hom
      (CommRingCat.of B1) (CommRingCat.of D1) ht
    have hx := congrArg
      (fun q : CommRingCat.of B1 ⟶ CommRingCat.of P2 => q.hom b) hleft
    change ie.hom.hom (b ⊗ₜ[A1] (1 : D1)) = jB b at hx
    exact hx
  let re : P1 ≃+* P2 := ie.commRingCatIsoToRingEquiv
  refine AlgEquiv.ofRingEquiv (f := re) fun x => ?_
  change ie.hom.hom (((algebraMap R B1) x) ⊗ₜ[A1] (1 : D1)) =
    ((algebraMap R B2) x) ⊗ₜ[A2] (1 : D2)
  rw [left_formula, eB.commutes]