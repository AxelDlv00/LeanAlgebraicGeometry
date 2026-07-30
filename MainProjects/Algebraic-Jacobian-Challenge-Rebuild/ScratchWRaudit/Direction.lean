import AlgebraicJacobian.Cohomology.Finiteness
import AlgebraicJacobian.Curve.P1H1Vanishing

open AlgebraicGeometry CategoryTheory
universe u

-- Does `genus C = 0` give back the Subsingleton at an ARBITRARY curve of this tree?
example {k : Type u} [Field k] (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (h : genus C = 0) :
    letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
    Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) := by
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  rw [genus] at h
  exact (Module.finrank_zero_iff (R := k)).mp h
