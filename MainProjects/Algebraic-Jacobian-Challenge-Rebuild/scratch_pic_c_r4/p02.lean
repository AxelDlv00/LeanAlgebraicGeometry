import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite
import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC2

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

-- how does one get IsIso of a presheaf map from bijectivity of every app?
example {F G : Scheme.{u}ᵒᵖ ⥤ Type u} (f : F ⟶ G)
    (h : ∀ T, Function.Bijective (f.app T)) : IsIso f := by
  exact?

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC2
end AlgebraicGeometry
