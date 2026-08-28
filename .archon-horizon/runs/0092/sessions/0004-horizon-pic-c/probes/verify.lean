import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

/-- A: the collapse is now UNCONDITIONAL at n = 0, at pic-g's own chart. -/
theorem probe_uncond [IsIntegral (C ⊗ overSpec k k).left]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (0 : ℕ))
    (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChartZero (pi := pi) m Z hdeg).app T) :=
  injective_abelSigmaChart_of_subsingleton _ m Z hdeg
    (divFunctorObjSubsingleton_zero (C := C) (pi := pi)) T

/-- B: is the representing object's space really a SINGLE POINT, i.e. is the
"V-interval collapses to two opens" claim (which I retracted, and which pic-g's docstrings
now assert) actually TRUE at their carrier?  Their D.left is (Over.mk (id)).left = Spec k.
Probe: is every open of Spec k either bot or top? -/
example (V : (Spec (CommRingCat.of k)).Opens) : V = ⊥ ∨ V = ⊤ := by
  exact?

end AlgebraicGeometry
