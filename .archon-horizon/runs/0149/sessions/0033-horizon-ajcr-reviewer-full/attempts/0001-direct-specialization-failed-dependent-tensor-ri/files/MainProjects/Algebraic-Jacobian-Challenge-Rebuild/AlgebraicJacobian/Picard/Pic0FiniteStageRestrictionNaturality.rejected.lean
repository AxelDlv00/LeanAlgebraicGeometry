/- Rejected draft preserved from run 0149/session 0033. -/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionBaseChange

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

noncomputable local instance chartBaseChangeCommRing
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    CommRing (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U) :=
  TensorProduct.instCommRing

noncomputable local instance overlapBaseChangeCommRing
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    CommRing (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V) :=
  TensorProduct.instCommRing

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
theorem restrictionFinalBaseChangeEquiv_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
        (show
          k ⊗[P.N.1]
              Pic0FiniteStageChartBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U →ₐ[k]
            k ⊗[P.N.1]
              Pic0FiniteStageOverlapBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U V
          from AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := P.N.1) (K := k) (restrictionBaseChangeAlgHom C P U V)) =
      (exactRestrictionAlgHom C U V).comp
        (chartFinalBaseChangeEquiv C P U).toAlgHom := by
  exact pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inl (Sum.inl (U, V)))

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
