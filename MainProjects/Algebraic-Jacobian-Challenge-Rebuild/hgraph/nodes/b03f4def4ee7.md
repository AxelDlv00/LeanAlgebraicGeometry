---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.glued_corr_collapse
docstring: '**The glued corrected unit collapses onto the cocycle value on the diagonal**

  (ζ2·ii, the G6 component identity).  Along a common section `δ` of `r₁, r₂` on which
  the

  witness is `1`, the pullback of the glued corrected unit for the pair `(a, b)` is
  the

  restriction of `γZ(a, b)` — the Zariski cover cocycle value.'
file: AlgebraicJacobian/Picard/WitnessCorrection.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.glued_corr_collapse
type: lean
updated: '2026-07-30T15:28:02'
---
theorem glued_corr_collapse (δ : Z ⟶ Y)
    (hδ₁ : δ ≫ r₁ = 𝟙 Z) (hδ₂ : δ ≫ r₂ = 𝟙 Z)
    (hθdiag : ∀ (v : Z) {O : Z.Opens} (hO : O ≤ δ ⁻¹ᵁ 𝒞.opens (δ.base v)),
      δ.unitsAppLE (𝒞.opens (δ.base v)) O hO (c (δ.base v)) = 1)
    (a b : Z) (D : Y.Opens)
    (hDa : D ≤ r₁ ⁻¹ᵁ 𝒩.opens a) (hDb : D ≤ r₂ ⁻¹ᵁ 𝒩.opens b)
    {u : Γ(Y, D)ˣ}
    (hu : ∀ y : Y, Y.unitsRestrict (inf_le_right : 𝒞.opens y ⊓ D ≤ D) u
      = unitsCorrCochain r₁ r₂ 𝒞 𝒩 c γZ h𝒞₁ h𝒞₂ a b D hDa hDb y)
    {E : Z.Opens} (hE : E ≤ δ ⁻¹ᵁ D) (hEa : E ≤ 𝒩.opens a) (hEb : E ≤ 𝒩.opens b) :
    δ.unitsAppLE D E hE u
      = Z.unitsRestrict (le_inf hEa hEb) (Scheme.unitsEvInf γZ a b) := by
  -- separation over the cover `{δ ⁻¹ᵁ 𝒞 (δ v) ⊓ E}` of `E`
  apply Scheme.unitsRestrict_eq_of_locally_eq
    (W := fun v : Z => δ ⁻¹ᵁ 𝒞.opens (δ.base v) ⊓ E)
    (fun _ => inf_le_right)
    (fun d hd => Opens.mem_iSup.mpr ⟨d, ⟨𝒞.mem_opens (δ.base d), hd⟩⟩)
  intro v
  -- `δ ⁻¹ᵁ 𝒞 (δ v) ⊓ E` sits inside the member `𝒩 v` (through `δ ≫ r₁ = 𝟙`)
  have hOv : δ ⁻¹ᵁ 𝒞.opens (δ.base v) ⊓ E ≤ 𝒩.opens v := by
    have h : δ ⁻¹ᵁ 𝒞.opens (δ.base v) ⊓ E
        ≤ (δ ≫ r₁) ⁻¹ᵁ 𝒩.opens ((δ ≫ r₁).base v) :=
      inf_le_left.trans (δ.preimage_mono (h𝒞₁ (δ.base v)))
    rw [hδ₁] at h
    exact h
  -- expand the glued unit at the point `δ v`
  rw [Scheme.Hom.unitsAppLE_map,
    Scheme.Hom.unitsAppLE_glued_corr r₁ r₂ 𝒞 𝒩 c γZ h𝒞₁ h𝒞₂ a b D hDa hDb δ hu v
      inf_le_left (inf_le_right.trans hE),
    -- the two composites are the identity
    Scheme.Hom.unitsAppLE_section_congr_hom hδ₁
      (fun z' => 𝒩.opens a ⊓ 𝒩.opens z') (fun z' => Scheme.unitsEvInf γZ a z') v,
    Scheme.Hom.unitsAppLE_section_congr_hom hδ₂
      (fun z' => 𝒩.opens z' ⊓ 𝒩.opens b) (fun z' => Scheme.unitsEvInf γZ z' b) v,
    Scheme.id_unitsAppLE, Scheme.id_unitsAppLE,
    -- the witness term is `1`
    hθdiag v inf_le_left, inv_one, mul_one,
    Scheme.unitsRestrict_unitsRestrict]
  -- the two correction factors telescope through the cocycle identity at `(a, v, b)`
  have t := congrArg
    (Z.unitsRestrict (le_inf (le_inf (inf_le_right.trans hEa) hOv)
      (inf_le_right.trans hEb) :
        δ ⁻¹ᵁ 𝒞.opens (δ.base v) ⊓ E ≤ 𝒩.opens a ⊓ 𝒩.opens v ⊓ 𝒩.opens b))
    (Scheme.unitsEvInf_trans γZ a v b)
  simp only [map_mul, Scheme.unitsRestrict_unitsRestrict] at t
  exact t