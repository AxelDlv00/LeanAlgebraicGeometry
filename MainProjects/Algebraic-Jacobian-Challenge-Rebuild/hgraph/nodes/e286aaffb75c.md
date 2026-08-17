---
author: sync
content_type: theorem
created: '2026-08-16T20:15:43'
decl: AlgebraicGeometry.isOpenImmersion_of_tensorProduct
docstring: Open immersions of affine spectra descend after extending scalars to a
  field.
file: AlgebraicJacobian/Descent/OpenImmersionFieldDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isOpenImmersion_of_tensorProduct
type: lean
updated: '2026-08-16T20:15:43'
---
theorem isOpenImmersion_of_tensorProduct {L K A B : Type u}
    [Field L] [Field K] [Algebra L K]
    [CommRing A] [CommRing B] [Algebra L A] [Algebra L B]
    (phi : A →ₐ[L] B)
    (hK : IsOpenImmersion (Spec.map (CommRingCat.ofHom
      (Algebra.TensorProduct.map phi (AlgHom.id L K)).toRingHom))) :
    IsOpenImmersion (Spec.map (CommRingCat.ofHom phi.toRingHom)) := by
  letI : Algebra A B := phi.toRingHom.toAlgebra
  haveI : IsScalarTower L A B :=
    IsScalarTower.of_algebraMap_eq fun x => (phi.commutes x).symm
  let psi := Algebra.TensorProduct.map phi (AlgHom.id L K)
  letI : Algebra (A ⊗[L] K) (B ⊗[L] K) := psi.toRingHom.toAlgebra
  have hphi : algebraMap A B = phi.toRingHom := by rfl
  have hpsi : algebraMap (A ⊗[L] K) (B ⊗[L] K) = psi.toRingHom := by rfl
  haveI : IsScalarTower A (A ⊗[L] K) (B ⊗[L] K) :=
    IsScalarTower.of_algebraMap_eq' <| by
      ext a
      change phi a ⊗ₜ[L] 1 = psi (a ⊗ₜ[L] 1)
      simp [psi]
  have hright :
      (algebraMap (A ⊗[L] K) (B ⊗[L] K)).comp
        Algebra.TensorProduct.includeRight.toRingHom =
      Algebra.TensorProduct.includeRight.toRingHom := by
    ext k
    change psi (1 ⊗ₜ[L] k) = 1 ⊗ₜ[L] k
    simp [psi]
  letI : Algebra.IsPushout A B (A ⊗[L] K) (B ⊗[L] K) :=
    Algebra.IsPushout.tensorProduct_tensorProduct L K A B hright
  have hsq : IsPushout
      (CommRingCat.ofHom (algebraMap A (A ⊗[L] K)))
      (CommRingCat.ofHom phi.toRingHom)
      (CommRingCat.ofHom psi.toRingHom)
      (CommRingCat.ofHom (algebraMap B (B ⊗[L] K))) := by
    simpa [hphi, hpsi] using
      (CommRingCat.isPushout_of_isPushout A B (A ⊗[L] K) (B ⊗[L] K)).flip
  apply isOpenImmersion_of_fpqc_pushout
    (algebraMap A (A ⊗[L] K)) phi.toRingHom psi.toRingHom
      (algebraMap B (B ⊗[L] K)) hsq
  · rw [RingHom.faithfullyFlat_algebraMap_iff]
    infer_instance
  · simpa [psi] using hK