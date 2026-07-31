---
author: sync
content_type: definition
created: '2026-07-20T06:01:15'
decl: AlgebraicGeometry.ThetaGeneratorSeed.relPinnedTermBaseChangeAlg
docstring: '**The side-uniform chart-ring base change**: the whole-chart (`le_rfl`)
  analogue of

  `pinnedPieceSectionsMap`, cased over the side `b` to `relTermBaseChangeAlg` at the
  fibre

  chart.  Its target chart ring is that of the base-changed pinned chart.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignHinjChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.relPinnedTermBaseChangeAlg
type: lean
updated: '2026-07-31T20:14:52'
---
noncomputable def relPinnedTermBaseChangeAlg (b : Bool) :
    R' ⊗[R] Γ(relCurve C R, relPinnedChart C R π b) ≃ₐ[R']
      Γ(relCurve C R', relPinnedChart C R' π b) :=
  match b with
  | false =>
      relTermBaseChangeAlg R' (fiberChart₀ π)
        (fiberTwoCover π).isAffineOpen₀.isCompact
        (fiberTwoCover π).isAffineOpen₀.isQuasiSeparated
  | true =>
      relTermBaseChangeAlg R' (fiberChart₁ π)
        (fiberTwoCover π).isAffineOpen₁.isCompact
        (fiberTwoCover π).isAffineOpen₁.isQuasiSeparated