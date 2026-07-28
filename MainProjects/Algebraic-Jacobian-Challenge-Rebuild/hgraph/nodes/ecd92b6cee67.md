---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: LinearMap.lTensor_barMap_injective_of_flat_coker
docstring: '**Purity of the image from a flat cokernel**: if `N ⧸ range δ` is `R`-flat,
  then

  the induced injection `M ⧸ ker δ → N` stays injective after tensoring with any

  module.'
file: AlgebraicJacobian/Picard/FlatCokernel.lean
generated: lean
lean_status: lean_ok
private: true
title: LinearMap.lTensor_barMap_injective_of_flat_coker
type: lean
updated: '2026-07-28T17:25:26'
---
private theorem lTensor_barMap_injective_of_flat_coker
    [Module.Flat R (N ⧸ LinearMap.range δ)]
    (A : Type u) [AddCommGroup A] [Module R A] :
    Function.Injective ((barMap δ).lTensor A) := by
  refine lTensor_injective_of_exact_of_flat (LinearMap.range δ).mkQ
    (Submodule.mkQ_surjective _) (barMap δ) (barMap_injective δ) ?_ A
  rw [LinearMap.exact_iff, Submodule.ker_mkQ, barMap, Submodule.range_liftQ]