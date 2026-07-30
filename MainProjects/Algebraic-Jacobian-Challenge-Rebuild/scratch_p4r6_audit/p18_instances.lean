import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
universe u

-- Take R = ℚ (a field, hence Spec R reduced and a point).
noncomputable abbrev Xq : Scheme.{0} := (Spec (.of ℚ)) ⨿ (Spec (.of ℚ))

-- The coproduct is Spec (ℚ × ℚ) up to iso, so it is AFFINE, hence SEPARATED.
example : IsIso (coprodSpec (CommRingCat.of ℚ) (CommRingCat.of ℚ)) := inferInstance

noncomputable def isoSpecProd :
    (Spec (.of (ℚ × ℚ)) : Scheme.{0}) ≅ Xq :=
  asIso (coprodSpec (CommRingCat.of ℚ) (CommRingCat.of ℚ)) |>.symm ≪≫> Iso.refl _

#check @coprodSpec

instance : IsAffine Xq :=
  isAffine_of_isIso (coprodSpec (CommRingCat.of ℚ) (CommRingCat.of ℚ)).symm.hom

instance : Xq.IsSeparated := inferInstance

instance : IsReduced Xq := by
  haveI : IsReduced (Spec (CommRingCat.of (ℚ × ℚ))) := by
    rw [isReduced_Spec_iff]; infer_instance
  exact isReduced_of_isIso (coprodSpec (CommRingCat.of ℚ) (CommRingCat.of ℚ))

end AlgebraicGeometry
