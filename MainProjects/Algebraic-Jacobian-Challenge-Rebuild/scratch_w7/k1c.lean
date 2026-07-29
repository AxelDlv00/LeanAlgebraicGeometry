import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

set_option autoImplicit false
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- THE ATOM, exactly as the K-1 file's plan states it. -/
example (B : Type u) [CommRing B] [Algebra k B] :
    (crossBaseAffineIso k k C B).inv
      = (((baseChange.idIso k).app C).inv ▷ overSpec k B).left := by
  refine (Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext ?_ ?_
  · sorry
  · rw [crossBaseAffineIso_inv_snd]
    rw [← Over.comp_left, whiskerRight_snd]
    sorry

/-- Is the fst-leg of the whiskerRight side what the plan says? -/
example (B : Type u) [CommRing B] [Algebra k B] :
    (((baseChange.idIso k).app C).inv ▷ overSpec k B)
        ≫ fst ((baseChange k k).obj C) (overSpec k B)
      = fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)
          ≫ ((baseChange.idIso k).app C).inv := by
  rw [whiskerRight_fst]

end AlgebraicGeometry
