import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry

noncomputable abbrev Xq : Scheme.{0} := (Spec (.of ℚ)) ⨿ (Spec (.of ℚ))

instance instAffXq : IsAffine Xq :=
  IsAffine.of_isIso (coprodSpec ℚ ℚ)

instance : Xq.IsSeparated := inferInstance

instance instRedXq : IsReduced Xq := by
  haveI hR : IsReduced (Spec (CommRingCat.of (ℚ × ℚ))) := inferInstance
  -- transport backwards along the iso coprodSpec : Xq ≅ Spec (ℚ × ℚ)
  refine (IsReduced.of_openCover (X := Xq)
    (Scheme.OpenCover.mk ?_ ?_ ?_ ?_ ?_ ?_)) <;> sorry

end AlgebraicGeometry
