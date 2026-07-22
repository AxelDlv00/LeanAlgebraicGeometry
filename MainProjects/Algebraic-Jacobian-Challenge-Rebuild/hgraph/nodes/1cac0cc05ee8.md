---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.TwoCover.h1CokEquiv_symm_mk
docstring: 'Compatibility of the bridge with the connecting map, inverse form: the
  inverse

  bridge sends the class of a section on the overlap to its connecting class.'
file: AlgebraicJacobian/Cohomology/TwoCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.TwoCover.h1CokEquiv_symm_mk
type: lean
updated: '2026-07-16T21:33:27'
---
lemma h1CokEquiv_symm_mk (s : Γ(X, U₀ ⊓ U₁)) :
    (h1CokEquiv k X U₀ U₁ hcov hU₀ hU₁).symm (Submodule.Quotient.mk s) =
      delta k X U₀ U₁ hcov s := by
  apply (h1CokEquiv k X U₀ U₁ hcov hU₀ hU₁).injective
  rw [LinearEquiv.apply_symm_apply, h1CokEquiv_delta]