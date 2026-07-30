---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.exists_comparison_unit
docstring: '**Steps E–F: the comparison cochain glues and descends to the correcting
  unit (P1 +

  P2b).** For a witness `θ₀` downstairs (`hdown`) and a witness `α` upstairs (`hup`,
  against

  the lift `lam` of the class `L`), the comparison cochain is Čech-compatible

  (`comparisonCochain_compat`), so it glues to a global unit of the curve product,
  which

  descends through the projection `p₂` to a global unit `χ` of `Spec (B ⊗[A] B)`.'
file: AlgebraicJacobian/Picard/CoherentWitnessCochains.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.exists_comparison_unit
type: lean
updated: '2026-07-30T15:27:58'
---
theorem exists_comparison_unit
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (𝒩 : ((overSpec k B).left).PointedCover)
    (γ : ((overSpec k B).left).unitsCocycle 𝒩)
    (𝒲 : (Sq).PointedCover)
    (hW₁ : ∀ x, 𝒲.opens x ≤ (q₁) ⁻¹ᵁ 𝒩.opens ((q₁).base x))
    (hW₂ : ∀ x, 𝒲.opens x ≤ (q₂) ⁻¹ᵁ 𝒩.opens ((q₂).base x))
    (θ₀ : ∀ x : Sq, Γ(Sq, 𝒲.opens x)ˣ)
    (hdown : ∀ x y : Sq,
      (Sq).unitsRestrict (inf_le_left : 𝒲.opens x ⊓ 𝒲.opens y ≤ 𝒲.opens x) (θ₀ x)
          * (q₁).unitsAppLE (𝒩.opens ((q₁).base x) ⊓ 𝒩.opens ((q₁).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((q₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
                (inf_le_right.trans (hW₁ y)))
              (Scheme.unitsEvInf γ ((q₁).base x) ((q₁).base y))
        = (q₂).unitsAppLE (𝒩.opens ((q₂).base x) ⊓ 𝒩.opens ((q₂).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((q₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
                (inf_le_right.trans (hW₂ y)))
              (Scheme.unitsEvInf γ ((q₂).base x) ((q₂).base y))
          * (Sq).unitsRestrict inf_le_right (θ₀ y))
    (ℒ : ((C ⊗ overSpec k A).left).PointedCover)
    (lam : ((C ⊗ overSpec k A).left).unitsCocycle ℒ)
    (𝒜 : (XB).PointedCover)
    (hA₁ : ∀ v, 𝒜.opens v ≤ (pB) ⁻¹ᵁ 𝒩.opens ((pB).base v))
    (hA₂ : ∀ v, 𝒜.opens v ≤ (cg) ⁻¹ᵁ ℒ.opens ((cg).base v))
    (α : ∀ v : XB, Γ(XB, 𝒜.opens v)ˣ)
    (hup : ∀ v w : XB,
      (XB).unitsRestrict (inf_le_left : 𝒜.opens v ⊓ 𝒜.opens w ≤ 𝒜.opens v) (α v)
          * (pB).unitsAppLE (𝒩.opens ((pB).base v) ⊓ 𝒩.opens ((pB).base w))
              (𝒜.opens v ⊓ 𝒜.opens w)
              ((pB).le_preimage_inf (inf_le_left.trans (hA₁ v))
                (inf_le_right.trans (hA₁ w)))
              (Scheme.unitsEvInf γ ((pB).base v) ((pB).base w))
        = (cg).unitsAppLE (ℒ.opens ((cg).base v) ⊓ ℒ.opens ((cg).base w))
              (𝒜.opens v ⊓ 𝒜.opens w)
              ((cg).le_preimage_inf (inf_le_left.trans (hA₂ v))
                (inf_le_right.trans (hA₂ w)))
              (Scheme.unitsEvInf lam ((cg).base v) ((cg).base w))
          * (XB).unitsRestrict inf_le_right (α w)) :
    ∃ χ : Γ(Sq, ⊤)ˣ, ∀ s : Xq,
      (Xq).unitsRestrict le_top (Units.map (p₂).appTop.hom.toMonoidHom χ)
        = comparisonCochain C 𝒲 θ₀ 𝒜 α s := by
  obtain ⟨ψ, hψ⟩ := Scheme.exists_global_unit_of_compatible
    (𝒰 := comparisonCover C 𝒲 𝒜) (comparisonCochain C 𝒲 θ₀ 𝒜 α)
    (comparisonCochain_compat C 𝒩 γ 𝒲 hW₁ hW₂ θ₀ hdown ℒ lam 𝒜 hA₁ hA₂ α hup)
  refine ⟨(Over.unitsSndTopEquiv C (B ⊗[A] B)).symm ψ, fun s ↦ ?_⟩
  have hχ : Units.map (p₂).appTop.hom.toMonoidHom
      ((Over.unitsSndTopEquiv C (B ⊗[A] B)).symm ψ) = ψ := by
    rw [← Over.unitsSndTopEquiv_apply]
    exact (Over.unitsSndTopEquiv C (B ⊗[A] B)).apply_symm_apply ψ
  rw [hχ]
  exact hψ s