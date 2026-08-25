---
author: sync
content_type: instance
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0FiniteStageFinalModelRingAlgebra
file: AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange_probe.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageFinalModelRingAlgebra
type: lean
updated: '2026-08-25T10:27:55'
---
@[reducible] noncomputable instance pic0FiniteStageFinalModelRingAlgebra
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Algebra N.1 (Pic0FiniteStageFinalModelRing C L n m relation M N j) := by
  dsimp only [Pic0FiniteStageFinalModelRing]
  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))
  exact Algebra.TensorProduct.leftAlgebra
    (R := M.1) (S := N.1) (A := N.1)
    (B := Pic0FiniteStageModelRing C L n m relation M j)

attribute [instance 2000] pic0FiniteStageModelRingAlgebra
  pic0FiniteStageFinalModelRingAlgebra