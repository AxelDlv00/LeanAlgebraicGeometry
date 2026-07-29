---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: Module.comparisonDescentUnit
docstring: '**The per-piece descent unit** ((C2) effectivity, brick E2): the unit
  of

  `(S ⊗[A] B) ⊗[S] (S ⊗[A] B)` corresponding to a comparison unit

  `v : (S ⊗[A] (B ⊗[A] B))ˣ` under the descent-cocycle ring identification

  `pieceDescentEquiv`.  On a piece `V`, `v` is the value `Over.pieceEquiv` transports
  the

  piece restriction of the E1 comparison `θ` to.'
file: AlgebraicJacobian/Picard/EffectivityDescentDatum.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.comparisonDescentUnit
type: lean
updated: '2026-07-29T15:26:33'
---
noncomputable def comparisonDescentUnit (v : (S ⊗[A] (B ⊗[A] B))ˣ) :
    ((S ⊗[A] B) ⊗[S] (S ⊗[A] B))ˣ :=
  Units.map (pieceDescentEquiv A S B).symm.toAlgHom.toRingHom.toMonoidHom v

@[simp]