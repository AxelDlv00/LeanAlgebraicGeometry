import Mathlib
import AlgebraicJacobian.Picard.FGAPicRepresentability

open CategoryTheory AlgebraicGeometry

universe u

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]

-- B2: sheaf property of relPresheaf => picEtComparison is iso, NO section used
example (h : Presheaf.IsSheaf (Scheme.etaleTopologyOver k) (Scheme.PicSharp.relPresheaf C)) :
    IsIso (Scheme.PicScheme.picEtComparison C) := by
  haveI : IsIso (Scheme.PicSharp.toEtaleSheaf C) := isIso_toSheafify _ h
  exact Functor.isIso_whiskerRight _ _
