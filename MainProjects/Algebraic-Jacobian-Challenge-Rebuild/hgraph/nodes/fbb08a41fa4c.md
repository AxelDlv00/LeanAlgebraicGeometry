---
author: sync
content_type: definition
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0FiniteStageModelRingBaseAlgebra
file: AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange_probe.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageModelRingBaseAlgebra
type: lean
updated: '2026-08-25T10:27:55'
---
@[reducible] noncomputable def pic0FiniteStageModelRingBaseAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra L.1 (Pic0FiniteStageModelRing C L n m relation M j) := by
  exact @Algebra.TensorProduct.instAlgebra L.1 M.1
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
    (inferInstance : CommSemiring L.1)
    (inferInstance : Semiring M.1)
    (inferInstance : Algebra L.1 M.1)
    (inferInstance : Semiring
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))
    (inferInstance : Algebra L.1
      (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j)))

-- attribute [local instance] pic0FiniteStageModelRingBaseAlgebra

set_option synthInstance.maxHeartbeats 400000 in
-- Tensor-product action instances require a larger deterministic search budget.
set_option maxHeartbeats 6400000 in