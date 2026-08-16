---
author: sync
content_type: instance
created: '2026-08-16T18:12:52'
decl: AlgebraicGeometry.DatG0.finitePresentation_finiteRelationAlgebra
file: AlgebraicJacobian/Picard/FinitePresentationAlgebraFiniteStage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.finitePresentation_finiteRelationAlgebra
type: lean
updated: '2026-08-16T18:12:52'
---
instance finitePresentation_finiteRelationAlgebra
    (R : Type u) [CommRing R] (n m : ℕ)
    (relation : Fin m → MvPolynomial (Fin n) R) :
    Algebra.FinitePresentation R (FiniteRelationAlgebra R n m relation) := by
  classical
  exact .quotient ⟨Finset.image relation Finset.univ, by simp⟩

set_option synthInstance.maxHeartbeats 100000 in
-- Elaborating the dependent quotient inside the tensor product requires a larger typeclass budget.