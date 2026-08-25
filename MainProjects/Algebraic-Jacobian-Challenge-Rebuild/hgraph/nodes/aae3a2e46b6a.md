---
author: sync
content_type: definition
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0FiniteStageModelAmbientAlgebra
file: AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageModelAmbientAlgebra
type: lean
updated: '2026-08-25T10:27:23'
---
@[reducible] noncomputable def pic0FiniteStageModelAmbientAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra L.1
      (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n j) (m j) (relation j)) :=
  @Algebra.TensorProduct.instAlgebra L.1 k
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
    (inferInstance : CommSemiring L.1)
    (inferInstance : Semiring k)
    (inferInstance : Algebra L.1 k)
    (inferInstance : Semiring
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))
    (inferInstance : Algebra L.1
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))

attribute [local instance] pic0FiniteStageModelAmbientAlgebra