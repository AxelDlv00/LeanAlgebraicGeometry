---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.gluedSheaf
docstring: '**The m-chart glued sheaf** of transition units `g i j ∈ Γ(X, U i ⊓ U
  j)ˣ` on the

  pieces `U : J → X.Opens`: the sheaf of `k`-modules on the small Zariski site of
  `X`

  whose sections over `W` are the families `s ∈ Π j, Γ(W ⊓ U j)` with `s i = g i j
  · s j`

  on every double overlap. For a cocycle (`Scheme.IsGluingCocycle`) on a covering
  family

  this is the line bundle presented by the cocycle, trivialized on each piece

  (`gluedTriv`).'
file: AlgebraicJacobian/Cohomology/GluedSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedSheaf
type: lean
updated: '2026-07-31T20:15:17'
---
noncomputable def gluedSheaf :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k) :=
  ⟨gluedPresheaf k U g, isSheaf_gluedPresheaf k U g⟩

@[simp]