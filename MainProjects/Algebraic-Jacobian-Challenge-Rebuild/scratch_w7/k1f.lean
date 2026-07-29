import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

set_option autoImplicit false
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- THE ATOM. `hom_ext` on the pullback `(baseChange k k).obj C ⊗ overSpec k B`. -/
example (B : Type u) [CommRing B] [Algebra k B] :
    (((baseChange.idIso k).app C).inv ▷ overSpec k B).left
      = (crossBaseAffineIso k k C B).inv := by
  refine (Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext ?_ ?_
  · -- fst leg
    sorry
  · -- snd leg: both give (snd C (overSpec k B)).left
    refine Eq.trans ?_ (crossBaseAffineIso_inv_snd k k C B).symm
    exact congrArg Over.Hom.left
      (whiskerRight_snd (((baseChange.idIso k).app C).inv) (overSpec k B))

end AlgebraicGeometry
