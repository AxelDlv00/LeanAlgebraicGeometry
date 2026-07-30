import Mathlib
example (R : Type) [CommRing R] :
    Algebra.IsStandardSmoothOfRelativeDimension 1 R (Polynomial R) := by
  infer_instance
example (R : Type) [CommRing R] :
    Algebra.IsStandardSmoothOfRelativeDimension 1 R (MvPolynomial (Fin 1) R) := by
  infer_instance
