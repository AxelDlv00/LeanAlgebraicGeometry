---
author: sync
content_type: theorem
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.mem_pic0Subgroup_iff_of_degAt_pushFieldPoint_eq
docstring: '**The degree-zero restriction engine for θ** (the B-4a → B-4b handshake):
  if a class

  `lam` of the `k`-curve on the pushed-forward test and a class `lamL` of the base-changed

  curve on `T` match in degree at every pushed field-point pair, then they are

  simultaneously degree-zero.  B-4b discharges the matching hypothesis from the B-2
  shuffle

  via the degree seam `relPicDeg_relPicCrossBase`, and this equivalence restricts
  θ to the

  degree-zero subfunctors.'
file: AlgebraicJacobian/Picard/Pic0Theta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_pic0Subgroup_iff_of_degAt_pushFieldPoint_eq
type: lean
updated: '2026-07-30T15:46:06'
---
theorem mem_pic0Subgroup_iff_of_degAt_pushFieldPoint_eq
    {lam : picEt C ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T)}
    {lamL : picEt ((baseChange k L).obj C) T}
    (hmatch : ∀ (K : Type u) [Field K] [Algebra k K] [Algebra L K]
      [IsScalarTower k L K] (s : overSpec L K ⟶ T),
      degAt lam (pushFieldPoint k s) = degAt lamL s) :
    lam ∈ pic0Subgroup C
        ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T)
      ↔ lamL ∈ pic0Subgroup ((baseChange k L).obj C) T := by
  rw [mem_pic0Subgroup_iff_forall_pushFieldPoint C lam]
  constructor
  · intro h
    refine mem_pic0Subgroup_iff.mpr ?_
    intro K _ _ s
    letI : Algebra k K := ((algebraMap L K).comp (algebraMap k L)).toAlgebra
    haveI : IsScalarTower k L K := .of_algebraMap_eq fun _ => rfl
    rw [← hmatch K s]
    exact h K s
  · intro h K _ _ _ _ s
    rw [hmatch K s]
    exact mem_pic0Subgroup_iff.mp h K s