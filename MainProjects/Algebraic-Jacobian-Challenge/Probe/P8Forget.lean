import Mathlib
import AlgebraicJacobian.Picard.FGAPicRepresentability

open CategoryTheory AlgebraicGeometry

universe u

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]

example (h : Presieve.IsSheaf (Scheme.etaleTopologyOver k) (Scheme.PicScheme.picSharp C)) :
    Presheaf.IsSheaf (Scheme.etaleTopologyOver k) (Scheme.PicSharp.relPresheaf C) := by
  rw [Presheaf.isSheaf_iff_isSheaf_forget (s := CategoryTheory.forget AddCommGrpCat.{u+1}),
    CategoryTheory.isSheaf_iff_isSheaf_of_type]
  exact h
