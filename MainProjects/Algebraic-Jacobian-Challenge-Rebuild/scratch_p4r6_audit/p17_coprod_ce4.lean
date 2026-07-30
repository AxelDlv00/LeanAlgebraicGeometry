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

/-- V2.ι IS SPLIT MONO, with NO density / IsDominant hypothesis anywhere. -/
theorem retract2 : (V2 R).ι ≫ r2 R = 𝟙 _ := by
  rw [← cancel_epi ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange).hom]
  simp only [r2, Scheme.Hom.isoOpensRange_hom_ι_assoc, coprod.inl_desc, Category.comp_id]

/-- AND V2 ≠ ⊤ whenever Spec R has a point. -/
theorem V2_ne_top (p : (Spec R : Scheme.{u})) : (V2 R) ≠ ⊤ := by
  intro h
  have hmem : (coprod.inr : Spec R ⟶ X2 R).base p ∈ (V2 R) := h ▸ trivial
  obtain ⟨q, hq⟩ := hmem
  exact inl_ne_inr (Spec R) (Spec R) q p hq

/-- SO: `eq_top_of_retraction_of_isDominant` WITHOUT `[IsDominant V.ι]` IS FALSE.
    The `IsDominant` binder is genuinely load-bearing in the STATEMENT, not just the proof. -/
theorem isDominant_free_version_is_FALSE (p : (Spec R : Scheme.{u}))
    (bad : ∀ {X : Scheme.{u}} [IsReduced X] [X.IsSeparated] (V : X.Opens)
      (r : X ⟶ (V : Scheme.{u})), V.ι ≫ r = 𝟙 _ → V = ⊤)
    [IsReduced (X2 R)] [(X2 R).IsSeparated] :
    False :=
  V2_ne_top R p (bad (V2 R) (r2 R) (retract2 R))

end AlgebraicGeometry
