---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.cgqPreimage_le_inr
docstring: The double piece is bounded by the second-coprojection preimage of the
  piece.
file: AlgebraicJacobian/Picard/EffectivityComparisonUnit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.cgqPreimage_le_inr
type: lean
updated: '2026-07-16T21:33:28'
---
lemma cgqPreimage_le_inr (V : (XA).Opens) :
    (cgq) ⁻¹ᵁ V ≤ (u₂) ⁻¹ᵁ ((cg) ⁻¹ᵁ V) :=
  le_of_eq (by rw [← Scheme.Hom.comp_preimage, whiskerLeft_inr_comp_cover])

/-! ## Piece trivializations -/

/-- **A piece trivialization** of a representing cocycle `γ` on a piece `V` of the base
curve: a trivializing `0`-cochain of `γ` on the `cg⁻¹ V`-trimmed opens of its cover —
the cochain witness that the class `CechPic.mk 𝒩 γ.class` of the (C2) setting is
trivial on the cover piece `cg⁻¹ V`.  The (C2) per-piece descent (bricks E2/E3) runs on
pieces equipped with such a datum; producing a covering family of them is the
piece-selection brick consumed by the final splice. -/
structure PieceTrivialization (𝒩 : (XB).PointedCover) (γ : (XB).unitsCocycle 𝒩)
    (V : (XA).Opens) : Type u where
  /-- The trivializing `0`-cochain on the trimmed opens `𝒩.opens b ⊓ cg⁻¹ V`. -/
  triv : ∀ b : XB, Γ(XB, 𝒩.opens b ⊓ (cg) ⁻¹ᵁ V)ˣ
  /-- `triv` trivializes `γ` on the piece: `t b ⋅ γ(b,b') = t b'` on the trimmed
  pairwise overlaps. -/
  triv_rel : ∀ b b' : XB,
    (XB).unitsRestrict (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
        (𝒩.opens b ⊓ 𝒩.opens b') ⊓ (cg) ⁻¹ᵁ V ≤ 𝒩.opens b ⊓ (cg) ⁻¹ᵁ V) (triv b)
        * (XB).unitsRestrict (inf_le_left :
            (𝒩.opens b ⊓ 𝒩.opens b') ⊓ (cg) ⁻¹ᵁ V ≤ 𝒩.opens b ⊓ 𝒩.opens b')
            (Scheme.unitsEvInf γ b b')
      = (XB).unitsRestrict (le_inf (inf_le_left.trans inf_le_right) inf_le_right)
          (triv b')

/-! ## The per-piece comparison unit -/

variable (σ : overSpec k A ⟶ C)