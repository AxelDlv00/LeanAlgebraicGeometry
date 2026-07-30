import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry

noncomputable abbrev Xq : Scheme.{0} := (Spec (.of ℚ)) ⨿ (Spec (.of ℚ))

instance instAffXq : IsAffine Xq := IsAffine.of_isIso (coprodSpec ℚ ℚ)
instance instSepXq : Xq.IsSeparated := inferInstance
instance instRedXq : IsReduced Xq := isReduced_of_isOpenImmersion (coprodSpec ℚ ℚ)

#print axioms instAffXq
#print axioms instSepXq
#print axioms instRedXq

end AlgebraicGeometry
