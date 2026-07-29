import AlgebraicJacobian.Picard.Pic0ChartLocusH0One

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

-- PROBE C: is `h⁰(𝒪(0)) = 1` derivable here?  This is what an `E := 0` discharge
-- of the payoff's uniqueness clause would require.
example {L : Type u} [Field L] [Algebra k L]
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))] :
    Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L
      (0 : ((C ⊗ overSpec k L).left).CurveDivisor)) = 1 := by
  exact?

end

end AlgebraicGeometry
