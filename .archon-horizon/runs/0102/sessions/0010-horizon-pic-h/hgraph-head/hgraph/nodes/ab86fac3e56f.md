---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.thetaIdealUnit
docstring: '**The transition units of the twisted ideal sheaf `𝒪(Θᵃ − d)`** on the
  piece

  overlaps: the ratio unit times the theta twisting unit.  In the piece trivializations

  "cofactor over `f_j` in the chart picture of the piece", the matching

  `s_i = (f_j/f_i)·θ^{±a}·s_j` is exactly the twisted-pair matching

  `f_i·s_i = θ^{±a}·(f_j·s_j)` of an honest section vanishing along `d`.'
file: AlgebraicJacobian/Picard/DivisorThetaDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.thetaIdealUnit
type: lean
updated: '2026-08-01T09:44:14'
---
noncomputable def thetaIdealUnit (i j : A.index) :
    Γ(relCurve C R, A.pieces i ⊓ A.pieces j)ˣ :=
  A.eqnRatio i j * A.thetaOvlUnit a i j