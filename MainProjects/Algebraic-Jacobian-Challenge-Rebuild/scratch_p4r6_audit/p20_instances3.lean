import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry

noncomputable abbrev Xq : Scheme.{0} := (Spec (.of ℚ)) ⨿ (Spec (.of ℚ))

instance instAffXq : IsAffine Xq := IsAffine.of_isIso (coprodSpec ℚ ℚ)
instance : Xq.IsSeparated := inferInstance

-- IsReduced transports along an iso: reduce to Spec (ℚ × ℚ) which is reduced.
instance instRedXq : IsReduced Xq := by
  have h := (asIso (coprodSpec ℚ ℚ))
  have : IsReduced (Spec (CommRingCat.of (ℚ × ℚ))) := inferInstance
  constructor
  intro U
  have := ((asIso (coprodSpec ℚ ℚ)).symm.hom).base
  -- use the open-cover route with the two summands instead
  sorry

-- Alternative: reduced is local, and the two inclusions cover.
example : True := trivial
#check @IsReduced.of_openCover
#check @Scheme.IsLocallyDirected
#check @AlgebraicGeometry.Scheme.coprodOpenCover
end AlgebraicGeometry
