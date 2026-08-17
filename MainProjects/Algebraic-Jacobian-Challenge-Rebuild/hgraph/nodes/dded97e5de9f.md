---
author: sync
content_type: definition
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.pic0FiniteStageModelBaseChangeEquiv
docstring: 'Cancel the intermediate finite subextension in a finite-presentation model
  and then

  apply its chosen exact-ring comparison.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageTripleModelComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageModelBaseChangeEquiv
type: lean
updated: '2026-08-17T13:21:30'
---
def pic0FiniteStageModelBaseChangeEquiv
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (e : forall j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :=
  (Algebra.TensorProduct.cancelBaseChange L.1 M.1 k k
    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))).trans (e j)

set_option synthInstance.maxHeartbeats 200000 in
-- The source and target quotient algebras depend on the finite ring tag.
set_option maxHeartbeats 1600000 in
-- Cancellation naturality and conjugation elaborate through both dependent models.