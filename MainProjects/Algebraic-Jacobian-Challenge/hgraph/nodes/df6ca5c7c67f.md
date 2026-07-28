---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.skyModule_obj_of_not_mem
file: AlgebraicJacobian/RiemannRoch/Ledger/Skyscraper.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.skyModule_obj_of_not_mem
type: lean
updated: '2026-07-28T18:12:20'
---
lemma skyModule_obj_of_not_mem (x : X) (M : ModuleCat.{u} K) {U : X.Opens} (h : x ∉ U) :
    (skyModule x M).obj.obj (op U) = terminal (ModuleCat.{u} K) := by
  rw [skyModule_obj, if_neg h]