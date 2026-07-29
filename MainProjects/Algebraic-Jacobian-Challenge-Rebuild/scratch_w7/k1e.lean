import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

set_option autoImplicit false
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

-- What IS the fst leg on each side?  Print the goal by failing deliberately.
example (B : Type u) [CommRing B] [Algebra k B] :
    (crossBaseAffineIso k k C B).inv
      = (((baseChange.idIso k).app C).inv ▷ overSpec k B).left := by
  refine (Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext ?_ ?_
  · exact test_sorry_marker
  · refine Eq.symm (Eq.trans rfl (congrArg Over.Hom.left
      (whiskerRight_snd (((baseChange.idIso k).app C).inv) (overSpec k B))))

end AlgebraicGeometry
