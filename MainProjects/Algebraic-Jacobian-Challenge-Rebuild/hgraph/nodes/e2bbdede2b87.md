---
author: sync
content_type: instance
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.Pic0FiniteStageGluePackage.pic0FiniteStageOverlapBaseChangeRingAlgebra
file: AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Pic0FiniteStageGluePackage.pic0FiniteStageOverlapBaseChangeRingAlgebra
type: lean
updated: '2026-08-25T11:44:32'
---
noncomputable instance pic0FiniteStageOverlapBaseChangeRingAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (U V : Pic0FiniteStageChartIndex C) :
    Algebra N.1 (Pic0FiniteStageOverlapBaseChangeRing C L n m relation M N U V) := by
  letI : Algebra M.1 (Pic0FiniteStageOverlapModelRing C L n m relation M U V) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1
        (n (Sum.inr (U, V))) (m (Sum.inr (U, V)))
        (relation (Sum.inr (U, V))))
  dsimp only [Pic0FiniteStageOverlapBaseChangeRing]
  exact Algebra.TensorProduct.leftAlgebra
    (R := M.1) (S := N.1) (A := N.1)
    (B := Pic0FiniteStageOverlapModelRing C L n m relation M U V)

set_option maxHeartbeats 25600000 in
-- The package projections retain the dependent tensor-product instances of the constructor.