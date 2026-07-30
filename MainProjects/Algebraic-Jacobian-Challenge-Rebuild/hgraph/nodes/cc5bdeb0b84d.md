---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.thetaSectionFst
docstring: '**The first manufactured theta section** `σ = (t₀ᵃ; 1)`: the chart-0 coordinate

  power on the chart-0 pieces, `1` on the chart-1 pieces.'
file: AlgebraicJacobian/Picard/DivisorFamilyThetaSections.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.thetaSectionFst
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def thetaSectionFst : A.chartProd := fun j =>
  match j with
  | Sum.inl j₀ => Ideal.Quotient.mk (Ideal.span {A.eqn (Sum.inl j₀)})
      ((relCurve C R).resHom (A.pieces_inl_le j₀) (relFiberCoordPow C R π a))
  | Sum.inr _ => 1