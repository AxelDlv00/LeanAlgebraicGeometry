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

/-- V2.ι IS SPLIT MONO: a retraction exists, with NO density/dominance hypothesis. -/
theorem retract2 : (V2 R).ι ≫ r2 R = 𝟙 _ := by
  rw [← cancel_epi ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange).hom]
  simp only [r2, Scheme.Hom.isoOpensRange_hom_ι_assoc, coprod.inl_desc, Category.comp_id]

/-- And V2 ≠ ⊤ whenever Spec R is nonempty (i.e. R nontrivial):
    a point of the right summand is not in V2. -/
theorem V2_ne_top [Nontrivial R] : (V2 R) ≠ ⊤ := by
  intro h
  -- the right-summand point lies in V2 = range of inl, contradicting disjointness
  obtain ⟨p⟩ : Nonempty (Spec R) := ⟨(Spec R).isoSpec.inv.base
    ⟨(Ideal.exists_maximal R).choose, (Ideal.exists_maximal R).choose_spec.isPrime⟩⟩
  have hmem : (coprod.inr : Spec R ⟶ X2 R).base p ∈ (V2 R) := h ▸ trivial
  obtain ⟨q, hq⟩ := hmem
  have := (AlgebraicGeometry.isCompl_range_inl_range_inr (Spec R) (Spec R)).disjoint
  exact Set.disjoint_left.mp this ⟨q, hq⟩ ⟨p, rfl⟩

end AlgebraicGeometry
