---
author: sync
content_type: theorem
created: '2026-07-31T16:14:01'
decl: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.subsingleton_hModule'_of_moduleDiff_surjective
file: AlgebraicJacobian/RiemannRoch/Ledger/FixedFiberDegree.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.subsingleton_hModule'_of_moduleDiff_surjective
type: lean
updated: '2026-07-31T19:55:23'
---
theorem subsingleton_hModule'_of_moduleDiff_surjective
    [Subsingleton (Sheaf.HModule' F S.X₂ 1)]
    [Subsingleton (Sheaf.HModule' F S.X₃ 1)]
    (hd : Function.Surjective (S.moduleDiff F)) :
    Subsingleton (Sheaf.HModule' F S.X₄ 1) := by
  refine subsingleton_of_forall_eq 0 ?_
  intro y
  obtain ⟨s, rfl⟩ := S.moduleDelta_surjective F y
  obtain ⟨t, rfl⟩ := hd s
  exact S.moduleDelta_moduleDiff F t