---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: LinearMap.quotRangeBaseChangeEquiv
docstring: '**Base change commutes with cokernels**: for a linear map `f : M →ₗ[R]
  N` and an

  `R`-algebra `A`, the base change of the cokernel of `f` is the cokernel of the base

  change of `f`, `A`-linearly. Right-exactness of `A ⊗[R] -` in the two-term form
  consumed

  by the Čech-complex base change.'
file: AlgebraicJacobian/Cohomology/RelativeH1BaseChange.lean
generated: lean
lean_status: lean_ok
title: LinearMap.quotRangeBaseChangeEquiv
type: lean
updated: '2026-07-16T21:33:27'
---
noncomputable def quotRangeBaseChangeEquiv :
    A ⊗[R] (N ⧸ LinearMap.range f) ≃ₗ[A]
      (A ⊗[R] N) ⧸ LinearMap.range (f.baseChange A) :=
  ((Submodule.quotEquivOfEq _ _ (ker_mkQ_baseChange A f).symm).trans
    (((LinearMap.range f).mkQ.baseChange A).quotKerEquivOfSurjective
      (surjective_mkQ_baseChange A f))).symm

@[simp]