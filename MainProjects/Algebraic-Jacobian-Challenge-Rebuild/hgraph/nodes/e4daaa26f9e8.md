---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CechPic.extPairs_of_notMem_left
file: AlgebraicJacobian/Picard/CechPicClopenGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CechPic.extPairs_of_notMem_left
type: lean
updated: '2026-07-31T20:15:20'
---
lemma extPairs_of_notMem_left {y y' : Y} (hy : y ∉ w.opensRange) :
    extPairs w Ω' 𝒰₀ γ₀ y y' = 1 := by
  unfold extPairs
  rw [dif_neg hy]