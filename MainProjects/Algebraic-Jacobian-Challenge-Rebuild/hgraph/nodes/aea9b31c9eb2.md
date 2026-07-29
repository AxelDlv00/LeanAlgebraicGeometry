---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: CategoryTheory.PresheafOfGroups.OneCocycle.res_id
file: AlgebraicJacobian/Picard/CechH1.lean
generated: lean
lean_status: lean_ok
stale: true
title: CategoryTheory.PresheafOfGroups.OneCocycle.res_id
type: lean
updated: '2026-07-29T15:26:31'
---
lemma res_id (γ : OneCocycle G U) : γ.res (fun i ↦ 𝟙 (U i)) = γ :=
  ext γ.toOneCochain.res_id