---
author: sync
content_type: definition
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.h1BaseFieldEquiv
docstring: '**`H¹` base-field invariance** (the parked deg-d5b D2 item, headline):
  for the

  challenge curve `C` over `k` and any field extension `K/k`,


  `H¹(C, 𝒪) ⊗[k] K ≃ₗ[K] H¹(C_K, 𝒪)`


  on the Rebuild carriers, where `C_K = (C ⊗ overSpec k K).left` is the base-changed
  curve

  of `Curve.BaseChangeInstances` (a legal curve over `K`, structure morphism the second

  projection). Engine-grade flat/free CBC on the two-cover Čech complex — not Mumford

  II.5.'
file: AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.h1BaseFieldEquiv
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def h1BaseFieldEquiv :
    letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
    K ⊗[k] Sheaf.HModule (C.left.moduleKSheaf k) 1 ≃ₗ[K]
      Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 1 :=
  curveH1BaseChange C K (curveCover C)