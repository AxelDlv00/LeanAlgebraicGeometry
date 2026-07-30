import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite
import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC8

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

-- Q1: from bijective apps to IsIso of a presheaf morphism
example {F G : Scheme.{u}ᵒᵖ ⥤ Type u} (f : F ⟶ G)
    (h : ∀ T, Function.Bijective (f.app T)) : IsIso f := by
  haveI : ∀ T, IsIso (f.app T) := fun T => (isIso_iff_bijective (f.app T)).mpr (h T)
  exact NatIso.isIso_of_isIso_app f

-- Q2: an iso is locally surjective; and so is Sigma.desc of a PUnit family
example {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) [IsIso f] :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : PUnit.{u+1} => f)) := by
  haveI : IsIso (Sigma.desc (fun _ : PUnit.{u+1} => f)) := by
    exact?
  infer_instance

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC8
end AlgebraicGeometry
