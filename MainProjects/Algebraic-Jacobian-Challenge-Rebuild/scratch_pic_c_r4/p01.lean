import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite
import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC1

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

-- Q1: is Over.mk T.hom = T?
example (T : Over (Spec (CommRingCat.of k))) : Over.mk T.hom = T := rfl

-- Q2: the Sigma component of abelSigmaChartZero is the point itself
example [IsIntegral (C ⊗ overSpec k k).left]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (T : Scheme.{u}) (v : T ⟶ (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left) :
    ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app (op T) v).1 = v := by
  change v ≫ 𝟙 _ = v
  rw [Category.comp_id]

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC1
end AlgebraicGeometry
