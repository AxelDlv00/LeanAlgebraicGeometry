import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

set_option autoImplicit false
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

-- The fst leg of the pullback square is `fst ≫ pullback.fst C.hom σ` composed AFTER
-- the two candidate maps.  What does each side give?  Expose by a deliberate type error.
example (B : Type u) [CommRing B] [Algebra k B] :
    (((baseChange.idIso k).app C).inv ▷ overSpec k B).left
      = (crossBaseAffineIso k k C B).inv := by
  refine (Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext ?_ ?_
  · exact (0 : Nat)
  · refine Eq.trans ?_ (crossBaseAffineIso_inv_snd k k C B).symm
    exact congrArg Over.Hom.left
      (whiskerRight_snd (((baseChange.idIso k).app C).inv) (overSpec k B))

end AlgebraicGeometry
