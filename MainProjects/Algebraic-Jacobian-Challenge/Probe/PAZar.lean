import Mathlib
import AlgebraicJacobian.Picard.PicEtSubcanonical

open CategoryTheory AlgebraicGeometry

universe u

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]

example {X : Over (Spec (CommRingCat.of k))}
    (rep : (Scheme.PicScheme.picSharp C).RepresentableBy X) :
    Presieve.IsSheaf (Scheme.zariskiTopology.over (Spec (CommRingCat.of k)))
      (Scheme.PicScheme.picSharp C) := by
  haveI : (Scheme.PicScheme.picSharp C).IsRepresentable := ⟨X, ⟨rep⟩⟩
  exact GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable _
