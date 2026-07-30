---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CechPic.mk_mul_mk
file: AlgebraicJacobian/Picard/Pic.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.CechPic.mk_mul_mk
type: lean
updated: '2026-07-30T15:28:04'
---
lemma mk_mul_mk (𝒰 : X.PointedCover) (a b : X.unitsH1 𝒰) :
    mk 𝒰 a * mk 𝒰 b = mk 𝒰 (a * b) := by
  rw [mk_mul_mk_inf]
  refine mk_eq_mk_iff.mpr ⟨𝒰 ⊓ 𝒰, le_rfl, inf_le_left, ?_⟩
  simp only [map_mul, unitsRes_rfl]

@[simp]