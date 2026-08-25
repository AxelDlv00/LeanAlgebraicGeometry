---
author: sync
content_type: definition
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0FiniteStageScalarExtensionMapOver
file: AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageScalarExtensionMapOver
type: lean
updated: '2026-08-25T10:27:23'
---
noncomputable def pic0FiniteStageScalarExtensionMapOver
    {F : Type u} [Field F] [Algebra F k]
    {K : Type u} [CommRing K]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k) [Algebra M.1 K]
    (j1 j2 : Pic0FiniteStageRingIndex C)
    (f : @AlgHom M.1
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring M.1)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)) :
    @AlgHom K
      (K ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j1)
      (K ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommSemiring K)
      (@Algebra.TensorProduct.instSemiring M.1 K
        (Pic0FiniteStageModelRing C L n m relation M j1)
        (inferInstance : CommSemiring M.1)
        (inferInstance : Semiring K)
        (inferInstance : Algebra M.1 K)
        (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
        (pic0FiniteStageModelRingAlgebra C L n m relation M j1))
      (@Algebra.TensorProduct.instSemiring M.1 K
        (Pic0FiniteStageModelRing C L n m relation M j2)
        (inferInstance : CommSemiring M.1)
        (inferInstance : Semiring K)
        (inferInstance : Algebra M.1 K)
        (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
        (pic0FiniteStageModelRingAlgebra C L n m relation M j2))
      (@Algebra.TensorProduct.leftAlgebra M.1 K K
        (Pic0FiniteStageModelRing C L n m relation M j1)
        (inferInstance : CommSemiring M.1)
        (inferInstance : Semiring K)
        (inferInstance : Algebra M.1 K)
        (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
        (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
        (inferInstance : CommSemiring K)
        (inferInstance : Algebra K K)
        (inferInstance : SMulCommClass M.1 K K))
      (@Algebra.TensorProduct.leftAlgebra M.1 K K
        (Pic0FiniteStageModelRing C L n m relation M j2)
        (inferInstance : CommSemiring M.1)
        (inferInstance : Semiring K)
        (inferInstance : Algebra M.1 K)
        (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
        (pic0FiniteStageModelRingAlgebra C L n m relation M j2)
        (inferInstance : CommSemiring K)
        (inferInstance : Algebra K K)
        (inferInstance : SMulCommClass M.1 K K)) := by
  letI : Semiring (Pic0FiniteStageModelRing C L n m relation M j1) :=
    (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
  letI : Semiring (Pic0FiniteStageModelRing C L n m relation M j2) :=
    (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j1) :=
    pic0FiniteStageModelRingAlgebra C L n m relation M j1
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j2) :=
    pic0FiniteStageModelRingAlgebra C L n m relation M j2
  exact @AlgebraicJacobian.scalarExtensionMapOfAlgHom
    M.1 K
      (Pic0FiniteStageModelRing C L n m relation M j1)
      (Pic0FiniteStageModelRing C L n m relation M j2)
      (inferInstance : CommRing M.1)
      (inferInstance : CommRing K)
      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring
      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring
      (inferInstance : Algebra M.1 K)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)
      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)
      f