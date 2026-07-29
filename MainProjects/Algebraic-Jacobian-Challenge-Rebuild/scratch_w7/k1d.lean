import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

set_option autoImplicit false
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- THE ATOM, whole, term-mode on both legs. -/
example (B : Type u) [CommRing B] [Algebra k B] :
    (crossBaseAffineIso k k C B).inv
      = (((baseChange.idIso k).app C).inv ▷ overSpec k B).left := by
  refine (Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext ?_ ?_
  · sorry
  · refine (crossBaseAffineIso_inv_snd k k C B).trans ?_
    refine Eq.symm (Eq.trans ?_ (congrArg Over.Hom.left
      (whiskerRight_snd (((baseChange.idIso k).app C).inv) (overSpec k B))))
    exact rfl

end AlgebraicGeometry
