---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.skyModule_subsingleton_of_not_mem
docstring: Over an open avoiding `x`, the module of sections of the skyscraper sheaf
  is trivial.
file: AlgebraicJacobian/RiemannRoch/Skyscraper.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.skyModule_subsingleton_of_not_mem
type: lean
updated: '2026-07-29T15:31:50'
---
private lemma skyModule_subsingleton_of_not_mem (x : X) (M : ModuleCat.{u} K) {U : X.Opens}
    (h : x ∉ U) : Subsingleton ((skyModule x M).obj.obj (op U)) := by
  rw [skyModule_obj_of_not_mem x M h]
  exact ModuleCat.subsingleton_of_isZero terminalIsTerminal.isZero