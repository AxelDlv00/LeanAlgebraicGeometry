---
author: sync
content_type: definition
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.Scheme.residueDeg
docstring: '**The residue degree** `[κ(x) : K]`: the `K`-dimension of the residue
  field at `x`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/ClosedPoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.residueDeg
type: lean
updated: '2026-07-28T18:12:20'
---
noncomputable def Scheme.residueDeg (x : X) : ℕ :=
  Module.finrank K (X.residueField x)