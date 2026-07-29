---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Scheme.TwoCoverPairData.h0TensorEquiv
docstring: '**The module-coefficient clause** (Kleiman `eq:Q`, worksheet §1.2): on
  the vanishing

  locus, formation of `H⁰(X, F)` commutes with `⊗_R P` for **every** `R`-module `P`
  — the

  sheaf-level form of `RigidEngine.kerRTensorEquiv` through the H⁰ carrier.'
file: AlgebraicJacobian/Cohomology/RigidEngine4Assembly.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.TwoCoverPairData.h0TensorEquiv
type: lean
updated: '2026-07-29T15:26:13'
---
noncomputable def h0TensorEquiv (hH1 : Subsingleton (dat.pair hU₀ hU₁).H1)
    [Module.Flat R (F.obj.obj (op (U₀ ⊓ U₁)))]
    (P : Type u) [AddCommGroup P] [Module R P] :
    (Sheaf.HModule F 0) ⊗[R] P ≃ₗ[R]
      ↥(LinearMap.ker ((dat.pair hU₀ hU₁).diff.rTensor P)) :=
  (LinearEquiv.rTensor P (dat.h0Equiv hU₀ hU₁ hcov)).trans
    (RigidEngine.kerRTensorEquiv (dat.pair hU₀ hU₁).diff
      (dat.surjective_diff hU₀ hU₁ hH1) P)