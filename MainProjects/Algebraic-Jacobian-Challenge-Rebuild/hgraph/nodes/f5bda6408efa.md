---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.DescentDatum.exact_mk_coactionSub
docstring: '**Amitsur exactness in degrees `≤ 1`**: for a faithfully flat `A → B`
  and any

  `A`-module `N`, the sequence `0 → N → B ⊗[A] N ⇉ B ⊗[A] B ⊗[A] N` is exact; here
  the pair

  of arrows is encoded by the single map `coactionSub` of the canonical descent datum,
  whose

  kernel is the equalizer.'
file: AlgebraicJacobian/Descent/ModuleDescent.lean
generated: lean
lean_status: lean_ok
title: Module.DescentDatum.exact_mk_coactionSub
type: lean
updated: '2026-08-01T09:44:10'
---
theorem exact_mk_coactionSub (N : Type u) [AddCommGroup N] [Module A N] :
    Function.Exact (TensorProduct.mk A B N 1) (baseChange A B N).coactionSub := by
  apply (Module.FaithfullyFlat.lTensor_exact_iff_exact A B _ _).mp
  intro z
  constructor
  · intro hz
    refine ⟨actionMap A B (B ⊗[A] N) z, ?_⟩
    have hx := (baseChange A B N).coaction_actionMap (x := z) (sub_eq_zero.mp (by
      rw [← coactionSub_lTensor_apply]; exact hz))
    rw [baseChange_coaction] at hx
    rw [← LinearMap.baseChange_eq_ltensor]
    exact hx
  · rintro ⟨x, rfl⟩
    rw [coactionSub_lTensor_apply, sub_eq_zero]
    induction x with
    | zero => simp
    | tmul b n => simp
    | add x y hx hy => simp only [map_add, hx, hy]