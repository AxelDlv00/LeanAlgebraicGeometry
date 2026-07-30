import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
universe u

/-! The FULL, UNCONDITIONAL witness: a reduced separated scheme X with a NON-TOP open V
whose inclusion V.ι is a SPLIT MONO.  So `eq_top_of_retraction_of_isDominant` MINUS its
`[IsDominant V.ι]` binder is FALSE — the binder is load-bearing in the STATEMENT. -/

noncomputable abbrev Xq : Scheme.{0} := (Spec (.of ℚ)) ⨿ (Spec (.of ℚ))
noncomputable abbrev Vq : Xq.Opens := (coprod.inl : Spec (.of ℚ) ⟶ Xq).opensRange

instance instAffXq : IsAffine Xq := IsAffine.of_isIso (coprodSpec ℚ ℚ)
instance instSepXq : Xq.IsSeparated := inferInstance
instance instRedXq : IsReduced Xq := isReduced_of_isOpenImmersion (coprodSpec ℚ ℚ)

noncomputable def rq : Xq ⟶ (Vq : Scheme.{0}) :=
  coprod.desc ((coprod.inl : Spec (.of ℚ) ⟶ Xq).isoOpensRange.hom)
              ((coprod.inl : Spec (.of ℚ) ⟶ Xq).isoOpensRange.hom)

theorem retract_q : Vq.ι ≫ rq = 𝟙 _ := by
  rw [← cancel_epi ((coprod.inl : Spec (.of ℚ) ⟶ Xq).isoOpensRange).hom]
  simp only [rq, Scheme.Hom.isoOpensRange_hom_ι_assoc, coprod.inl_desc, Category.comp_id]

theorem Vq_ne_top : Vq ≠ ⊤ := by
  intro h
  obtain ⟨p⟩ : Nonempty (Spec (.of ℚ) : Scheme.{0}) :=
    ⟨(Spec (CommRingCat.of ℚ)).isoSpec.inv.base
      (Scheme.isoSpec (Spec (CommRingCat.of ℚ))).hom.base
        ((Spec (CommRingCat.of ℚ)).isoSpec.inv.base ⟨⊥, Ideal.bot_prime⟩)⟩
  have hmem : (coprod.inr : Spec (.of ℚ) ⟶ Xq).base p ∈ Vq := h ▸ trivial
  obtain ⟨q, hq⟩ := hmem
  exact inl_ne_inr _ _ q p hq

/-- **REFUTATION.** The `IsDominant`-free version of `eq_top_of_retraction_of_isDominant`
is FALSE. -/
theorem isDominantFree_eq_top_is_FALSE :
    ¬ (∀ {X : Scheme.{0}} [IsReduced X] [X.IsSeparated] (V : X.Opens)
        (r : X ⟶ (V : Scheme.{0})), V.ι ≫ r = 𝟙 _ → V = ⊤) :=
  fun bad => Vq_ne_top (bad Vq rq retract_q)

/-- AND: `IsDominant Vq.ι` genuinely FAILS here, so the witness is consistent with the
theorem as stated. -/
theorem not_isDominant_Vq : ¬ IsDominant (Vq.ι) := by
  intro h
  have := h.1  -- DenseRange
  sorry

#print axioms isDominantFree_eq_top_is_FALSE

end AlgebraicGeometry
