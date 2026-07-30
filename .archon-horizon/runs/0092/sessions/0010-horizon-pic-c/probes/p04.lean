import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite
import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC4

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
variable [IsIntegral (C ⊗ overSpec k k).left]

/-- INJECTIVITY OF THE TERMINAL CHART IS FREE: the Sigma component IS the point. -/
example (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app T) := by
  intro v₁ v₂ h
  have h1 : ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app T v₁).1
      = ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app T v₂).1 := by rw [h]
  change v₁ ≫ 𝟙 _ = v₂ ≫ 𝟙 _ at h1
  simpa using h1

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC4
end AlgebraicGeometry
