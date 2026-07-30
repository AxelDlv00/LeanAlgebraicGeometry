import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
universe u
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

theorem sheafiso_iff_presheafiso {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) :
    IsIso (chartSheafHom C f) ↔ IsIso f := by
  constructor
  · intro h
    haveI := h
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  · intro h
    haveI : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)) := h
    exact isIso_of_reflects_iso (chartSheafHom C f)
      (sheafToPresheaf Scheme.zariskiTopology (Type u))

end AlgebraicGeometry
