import Mathlib
import AlgebraicJacobian.Picard.FGAPicRepresentability

open CategoryTheory AlgebraicGeometry

universe u

instance etSub : Scheme.etaleTopology.{u}.Subcanonical :=
  GrothendieckTopology.Subcanonical.of_le Scheme.etaleTopology_le_proetaleTopology

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]

-- Step: picSharp representable => picSharp is an etale sheaf of types
example (X : Over (Spec (CommRingCat.of k)))
    (rep : (Scheme.PicScheme.picSharp C).RepresentableBy X) :
    Presieve.IsSheaf (Scheme.etaleTopologyOver k) (Scheme.PicScheme.picSharp C) := by
  haveI : (Scheme.PicScheme.picSharp C).IsRepresentable := ⟨X, ⟨rep⟩⟩
  exact GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable _

-- Step: forget-sheaf => relPresheaf sheaf.  Does isSheaf_iff_isSheaf_forget apply?
example (h : Presieve.IsSheaf (Scheme.etaleTopologyOver k) (Scheme.PicScheme.picSharp C)) :
    Presheaf.IsSheaf (Scheme.etaleTopologyOver k) (Scheme.PicSharp.relPresheaf C) := by
  rw [CategoryTheory.isSheaf_iff_isSheaf_forget (s := CategoryTheory.forget AddCommGrpCat.{u+1}),
    CategoryTheory.isSheaf_iff_isSheaf_of_type]
  exact h
