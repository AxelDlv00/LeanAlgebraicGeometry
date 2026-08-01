---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: CategoryTheory.PresheafOfGroups.OneCocycle.res_id
file: AlgebraicJacobian/Picard/CechH1.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.PresheafOfGroups.OneCocycle.res_id
type: lean
updated: '2026-08-01T09:44:10'
---
lemma res_id (γ : OneCocycle G U) : γ.res (fun i ↦ 𝟙 (U i)) = γ :=
  ext γ.toOneCochain.res_id