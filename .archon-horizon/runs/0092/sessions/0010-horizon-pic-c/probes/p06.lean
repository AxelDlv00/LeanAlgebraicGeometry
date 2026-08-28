import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite
import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC6

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
variable [IsIntegral (C ⊗ overSpec k k).left]

example (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (hvan : ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S))
    (T : Scheme.{u}ᵒᵖ) :
    Function.Surjective ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app T) := by
  rintro ⟨a, xi⟩
  refine ⟨a, ?_⟩
  refine Over.sigmaExtension_ext (pic0TypeFunctor C) (show a ≫ 𝟙 _ = a from Category.comp_id a) ?_
  exact (hvan _).allEq _ _

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC6
end AlgebraicGeometry
