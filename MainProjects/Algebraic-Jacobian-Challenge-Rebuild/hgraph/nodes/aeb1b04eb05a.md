---
author: sync
content_type: theorem
created: '2026-08-16T20:15:44'
decl: AlgebraicGeometry.DatG0.tensorProduct_algHom_comp_eq_of_baseChange
docstring: 'A composition identity descends once all three maps commute with base
  change.  This is

  the equation step needed after spreading transition maps: inverse and cocycle identities
  can

  be checked over the ambient algebraic extension and then reflected to the finite
  stage.'
file: AlgebraicJacobian/Picard/FinitePresentationAlgebraMapFiniteStage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.tensorProduct_algHom_comp_eq_of_baseChange
type: lean
updated: '2026-08-18T20:51:03'
---
theorem tensorProduct_algHom_comp_eq_of_baseChange
    {F K A B D : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K]
    [CommRing A] [Algebra F A] [CommRing B] [Algebra F B]
    [CommRing D] [Algebra F D] (L : FinSubext F K)
    (phiL : L.1 ⊗[F] A →ₐ[L.1] L.1 ⊗[F] B)
    (psiL : L.1 ⊗[F] B →ₐ[L.1] L.1 ⊗[F] D)
    (chiL : L.1 ⊗[F] A →ₐ[L.1] L.1 ⊗[F] D)
    (phiK : K ⊗[F] A →ₐ[K] K ⊗[F] B)
    (psiK : K ⊗[F] B →ₐ[K] K ⊗[F] D)
    (chiK : K ⊗[F] A →ₐ[K] K ⊗[F] D)
    (hphi :
      (Algebra.TensorProduct.map L.1.val (AlgHom.id F B)).comp
          (phiL.restrictScalars F) =
        (phiK.restrictScalars F).comp
          (Algebra.TensorProduct.map L.1.val (AlgHom.id F A)))
    (hpsi :
      (Algebra.TensorProduct.map L.1.val (AlgHom.id F D)).comp
          (psiL.restrictScalars F) =
        (psiK.restrictScalars F).comp
          (Algebra.TensorProduct.map L.1.val (AlgHom.id F B)))
    (hchi :
      (Algebra.TensorProduct.map L.1.val (AlgHom.id F D)).comp
          (chiL.restrictScalars F) =
        (chiK.restrictScalars F).comp
          (Algebra.TensorProduct.map L.1.val (AlgHom.id F A)))
    (hK : psiK.comp phiK = chiK) :
    psiL.comp phiL = chiL := by
  apply DFunLike.ext _ _
  intro x
  apply tensorProduct_map_finSubext_injective L
  calc
    (Algebra.TensorProduct.map L.1.val (AlgHom.id F D))
        ((psiL.comp phiL) x) =
      psiK ((Algebra.TensorProduct.map L.1.val (AlgHom.id F B)) (phiL x)) := by
        exact DFunLike.congr_fun hpsi (phiL x)
    _ = psiK (phiK
        ((Algebra.TensorProduct.map L.1.val (AlgHom.id F A)) x)) := by
      exact congrArg psiK (DFunLike.congr_fun hphi x)
    _ = chiK ((Algebra.TensorProduct.map L.1.val (AlgHom.id F A)) x) := by
      exact DFunLike.congr_fun hK
        ((Algebra.TensorProduct.map L.1.val (AlgHom.id F A)) x)
    _ = (Algebra.TensorProduct.map L.1.val (AlgHom.id F D)) (chiL x) := by
      exact (DFunLike.congr_fun hchi x).symm

set_option synthInstance.maxHeartbeats 200000 in
-- The dependent finite family creates one tensor-product algebra instance per member.