---
author: sync
content_type: theorem
created: '2026-07-30T00:50:57'
decl: AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced_of_leafB
docstring: '**Leaf B implies headline obligation 2**, `Pic0Et.geometricallyReduced`.


  Via `smooth_of_leafB` and this project''s `Smooth.geometricallyReduced`

  (`Curve/GeometricallyReduced.lean`) — packaged upstream as

  `SmoothOfRelativeDimension.geometricallyReduced`.


  The import matters and is the reason this lives in a new file rather than in

  `Pic0Et.lean`: that module''s cone does not contain `Curve/GeometricallyReduced`,
  so the

  bridge is invisible from inside it and a synthesis probe there reads as absence

  (the measure-at-the-root lesson recorded at `Pic0AbelianVariety.lean:1208-1211`).


  Consequently `Pic0Et.geometricallyReduced` is a *sub-problem* of leaf B, not a peer
  of

  it, and the two distances must not be added. It does **not** follow that obligation
  2

  is cheaper than it was: it is the weaker statement, so proving it directly remains
  the

  right attack, and this implication is useless in that direction.'
file: AlgebraicJacobian/Picard/Pic0EtRelativeDimension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced_of_leafB
type: lean
updated: '2026-07-30T00:50:57'
---
theorem geometricallyReduced_of_leafB
    (hB : SmoothOfRelativeDimension (genus C) (Pic0SchemeEt C).hom) :
    GeometricallyReduced (Pic0SchemeEt C).hom :=
  haveI := hB
  SmoothOfRelativeDimension.geometricallyReduced (genus C) _

/-! ## §2. What leaf B actually asks: an affine-chart-pair condition

Both statements here are mathlib's, instantiated. They are recorded because the
headline docstring describes leaf B's residue in terms of "the rank of `Ω`" without
saying where that rank is measured, and the answer — on affine charts of `Pic⁰`, not at
the identity — is what separates it from the landed tangent-space chain. -/