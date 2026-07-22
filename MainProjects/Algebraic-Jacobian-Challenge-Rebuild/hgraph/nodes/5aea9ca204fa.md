---
author: sync
content_type: instance
created: '2026-07-19T21:01:15'
decl: AlgebraicGeometry.DatG0.isSeparable_finSubext
docstring: '**DG-G0.δ, separability of each stage.**  Every finite subextension `k''''/k`
  of a separable

  extension `K/k` is itself separable (`Algebra.isSeparable_tower_bot_of_isSeparable`
  on the native

  tower `k → k'''' → K`).  With `IntermediateField.isSeparable_iSup` the colimit `⨆
  k''''` is separable,

  so the δ system is the directed system of *finite separable* subextensions.'
file: AlgebraicJacobian/Picard/PicRepColimitResidual.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.isSeparable_finSubext
type: lean
updated: '2026-07-19T21:01:15'
---
instance isSeparable_finSubext [Algebra.IsSeparable k K] (L : FinSubext k K) :
    Algebra.IsSeparable k L.1 :=
  Algebra.isSeparable_tower_bot_of_isSeparable k L.1 K