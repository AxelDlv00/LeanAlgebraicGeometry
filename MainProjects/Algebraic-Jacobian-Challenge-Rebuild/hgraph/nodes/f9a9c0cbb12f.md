---
author: sync
content_type: theorem
created: '2026-07-30T00:56:04'
decl: AlgebraicGeometry.confined_monotone
file: scratch_review_ajcr/ProbeCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.confined_monotone
type: lean
updated: '2026-07-30T00:56:04'
---
theorem confined_monotone {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) {Vc Vf : ∀ i, (X i).Opens}
    (hle : ∀ i, Vc i ≤ Vf i) (h : Confined C f Vc) : Confined C f Vf := by
  intro T s t
  obtain ⟨W, htW, i, x, hx, hrange⟩ := h T s t
  refine ⟨W, htW, i, x, hx, hrange.trans ?_⟩
  have he : (Vc i).ι = (X i).homOfLE (hle i) ≫ (Vf i).ι := (Scheme.homOfLE_ι _ _).symm
  rw [he]
  intro z hz
  obtain ⟨w, rfl⟩ := hz
  exact ⟨((X i).homOfLE (hle i)).base w, rfl⟩

/-! ## The collapse: the two-open assembly is EQUIVALENT to the one-open one -/