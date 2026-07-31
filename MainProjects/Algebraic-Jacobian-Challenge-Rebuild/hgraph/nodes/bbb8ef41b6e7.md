---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.twistTriv₁_twistCollapse₁
docstring: Chart-1 analogue of `twistTriv₀_twistCollapse₀`.
file: AlgebraicJacobian/Cohomology/RelThetaTransportCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.twistTriv₁_twistCollapse₁
type: lean
updated: '2026-07-31T20:15:18'
---
lemma twistTriv₁_twistCollapse₁ (y) :
    twistTriv₁ k (relCover C k (fiberTwoCover π)).V₀ (relCover C k (fiberTwoCover π)).V₁
        (relThetaCocycle C k π n) (le_refl _) (twistCollapse₁ C π n y) =
      sectionsCollapse C (fiberChart₁ π)
        (isAffineOpen_preimage_chartOpen π 1).isCompact
        (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated
        (twistTriv₁ k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) (le_refl _) y) := by
  rw [twistCollapse₁]
  simp only [LinearEquiv.trans_apply]
  exact LinearEquiv.apply_symm_apply _ _