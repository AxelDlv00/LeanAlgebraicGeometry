---
author: sync
content_type: theorem
created: '2026-07-28T23:30:58'
decl: AlgebraicGeometry.Scheme.topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq
file: scratch_pic0dim.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq
type: lean
updated: '2026-07-28T23:30:58'
---
theorem topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq
    (X : Scheme.{u}) [Nonempty X] (d : WithBot ℕ∞)
    (h : ∀ z : X, ringKrullDim (X.presheaf.stalk z) = d) :
    topologicalKrullDim X = d := by
  rw [topologicalKrullDim_eq_iSup_ringKrullDim_stalk X]
  simp [h]