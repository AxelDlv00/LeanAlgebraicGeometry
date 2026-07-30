import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite

namespace AlgebraicGeometry
namespace ProbeC9

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

example {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (h : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : PUnit.{u+1} => f)) := by
  haveI := h
  exact Presheaf.isLocallySurjective_of_isLocallySurjective_fac
    (J := Scheme.zariskiTopology)
    (f₁ := Sigma.ι (fun _ : PUnit.{u+1} => yoneda.obj X) PUnit.unit)
    (f₂ := Sigma.desc (fun _ : PUnit.{u+1} => f))
    (Sigma.ι_desc (fun _ : PUnit.{u+1} => f) PUnit.unit)

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC9
end AlgebraicGeometry
