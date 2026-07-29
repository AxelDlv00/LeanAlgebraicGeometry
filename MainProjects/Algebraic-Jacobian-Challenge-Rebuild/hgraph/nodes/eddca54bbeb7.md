---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.ker_pointEv_le_sup
docstring: 'The point-evaluation kernel is contained in the sum of the point-generator
  ideal and

  the principal ideal of the pushed lift (mirror of `ker_lmul''_le_sup`).'
file: AlgebraicJacobian/Algebra/PointFiberIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.Diagonal.ker_pointEv_le_sup
type: lean
updated: '2026-07-29T15:31:34'
---
lemma ker_pointEv_le_sup :
    RingHom.ker (pointEv c)
      ≤ Ideal.span {pointGen k B F} ⊔ Ideal.span {mapRight c elift} := by
  intro x hx
  rw [RingHom.mem_ker] at hx
  have hπx : pointBaseChange B F x ∈ RingHom.ker (pointEvTwo c) := by
    rw [RingHom.mem_ker, pointEvTwo_pointBaseChange, hx]
  rw [ker_pointEvTwo c hgen, Ideal.mem_span_singleton] at hπx
  obtain ⟨d, hd⟩ := hπx
  obtain ⟨w, rfl⟩ := pointBaseChange_surjective d
  have hkey : x - mapRight c elift * w ∈ Ideal.span {pointGen k B F} := by
    rw [← ker_pointBaseChange, RingHom.mem_ker, map_sub, map_mul, hd,
      pointBaseChange_mapRight]
    ring
  have hx' : x = (x - mapRight c elift * w) + mapRight c elift * w := by ring
  rw [hx']
  exact add_mem (Ideal.mem_sup_left hkey)
    (Ideal.mem_sup_right (Ideal.mul_mem_right _ _ (Ideal.subset_span rfl)))

variable (L : Type*) [CommRing L] [Algebra (B ⊗[k] F) L]
  [IsLocalization.Away (1 - mapRight c elift) L]

include hidem hgen in