---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: CategoryTheory.Sheaf.HModule.map_id_apply
file: AlgebraicJacobian/RiemannRoch/Ledger/ModuleKSheaf.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.HModule.map_id_apply
type: lean
updated: '2026-07-28T18:12:20'
---
lemma map_id_apply {n : ℕ} (x : HModule F n) : map (𝟙 F) n x = x := by
  simp [map_apply]