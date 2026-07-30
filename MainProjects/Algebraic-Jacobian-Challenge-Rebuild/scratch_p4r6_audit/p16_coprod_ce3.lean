import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
universe u

variable (R : CommRingCat.{u})

noncomputable abbrev X2 : Scheme.{u} := (Spec R) ⨿ (Spec R)
noncomputable abbrev V2 : (X2 R).Opens := (coprod.inl : Spec R ⟶ X2 R).opensRange

noncomputable def r2 : X2 R ⟶ (V2 R : Scheme.{u}) :=
  coprod.desc ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange.hom)
              ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange.hom)

/-- SPLIT MONO with NO density hypothesis. -/
theorem retract2 : (V2 R).ι ≫ r2 R = 𝟙 _ := by
  rw [← cancel_epi ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange).hom]
  simp only [r2, Scheme.Hom.isoOpensRange_hom_ι_assoc, coprod.inl_desc, Category.comp_id]

/-- AND V2 ≠ ⊤ when Spec R is nonempty. -/
theorem V2_ne_top (p : (Spec R : Scheme.{u})) : (V2 R) ≠ ⊤ := by
  intro h
  have hmem : (coprod.inr : Spec R ⟶ X2 R).base p ∈ (V2 R) := h ▸ trivial
  obtain ⟨q, hq⟩ := hmem
  exact coprod_inl_base_ne_coprod_inr_base (Spec R) (Spec R) q p hq

end AlgebraicGeometry
