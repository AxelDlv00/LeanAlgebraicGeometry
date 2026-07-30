---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.twistTriv₁_apply
file: AlgebraicJacobian/Cohomology/TwistedSheaf.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.twistTriv₁_apply
type: lean
updated: '2026-07-30T15:28:03'
---
lemma twistTriv₁_apply {W : X.Opens} (hW : W ≤ V₁)
    (p : ↥(twistSubmodule k V₀ V₁ g W)) :
    twistTriv₁ k V₀ V₁ g hW p = X.resHom (le_inf le_rfl hW) p.val.2 :=
  rfl