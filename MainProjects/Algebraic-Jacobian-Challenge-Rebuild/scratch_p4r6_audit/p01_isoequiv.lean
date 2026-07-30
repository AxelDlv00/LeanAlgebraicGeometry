import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry

#check @pic0SigmaSheaf
#check @chartSheafHom
#check @chartIso_of_seam
#check @seam_of_chartIso
#check @isSheaf_yoneda_obj
#check @Sheaf.isLocallyBijective_iff_isIso
#check @MorphismProperty.of_isIso
#check @IsDominant

universe u
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

-- Is the sheaf-level IsIso EQUIVALENT to the presheaf-level IsIso?
example {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) :
    IsIso (chartSheafHom C f) ↔ IsIso f := by
  constructor
  · intro h
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  · intro h
    exact (sheafToPresheaf Scheme.zariskiTopology (Type u)).isIso_of_isIso_map
      (chartSheafHom C f) h

end AlgebraicGeometry
