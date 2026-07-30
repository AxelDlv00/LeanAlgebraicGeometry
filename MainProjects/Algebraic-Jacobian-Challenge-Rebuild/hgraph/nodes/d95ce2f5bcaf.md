---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: LinearMap.lTensor_ker_subtype_injective_of_flat_coker
docstring: '**Purity of the kernel from a flat image**: if `M ⧸ ker δ` is `R`-flat,
  then the

  inclusion of `ker δ` stays injective after tensoring with any module.'
file: AlgebraicJacobian/Picard/FlatCokernel.lean
generated: lean
lean_status: lean_ok
stale: true
title: LinearMap.lTensor_ker_subtype_injective_of_flat_coker
type: lean
updated: '2026-07-30T15:28:04'
---
theorem lTensor_ker_subtype_injective_of_flat_coker
    [Module.Flat R (M ⧸ LinearMap.ker δ)]
    (A : Type u) [AddCommGroup A] [Module R A] :
    Function.Injective ((LinearMap.ker δ).subtype.lTensor A) :=
  lTensor_injective_of_exact_of_flat (LinearMap.ker δ).mkQ
    (Submodule.mkQ_surjective _) (LinearMap.ker δ).subtype
    (Submodule.injective_subtype _) (exact_subtype_mkQ _) A