---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.residueDeg
docstring: '**The residue degree** `[κ(x) : K]`: the `K`-dimension of the residue
  field at `x`.'
file: AlgebraicJacobian/RiemannRoch/ClosedPoint.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.residueDeg
type: lean
updated: '2026-07-30T15:28:03'
---
noncomputable def Scheme.residueDeg (x : X) : ℕ :=
  Module.finrank K (X.residueField x)