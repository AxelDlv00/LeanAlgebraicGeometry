---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.Vq_ne_top
file: scratch_p4r6_audit/p22_FULL_REFUTATION.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Vq_ne_top
type: lean
updated: '2026-07-30T15:46:08'
---
theorem Vq_ne_top : Vq ≠ ⊤ := by
  intro h
  obtain ⟨p⟩ : Nonempty (Spec (.of ℚ) : Scheme.{0}) :=
    ⟨(Spec (CommRingCat.of ℚ)).isoSpec.inv.base
      (Scheme.isoSpec (Spec (CommRingCat.of ℚ))).hom.base
        ((Spec (CommRingCat.of ℚ)).isoSpec.inv.base ⟨⊥, Ideal.bot_prime⟩)⟩
  have hmem : (coprod.inr : Spec (.of ℚ) ⟶ Xq).base p ∈ Vq := h ▸ trivial
  obtain ⟨q, hq⟩ := hmem
  exact inl_ne_inr _ _ q p hq