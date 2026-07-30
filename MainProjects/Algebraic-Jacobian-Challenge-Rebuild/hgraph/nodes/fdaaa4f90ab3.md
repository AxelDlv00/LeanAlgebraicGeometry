---
author: sync
content_type: lemma
created: '2026-07-17T16:57:12'
decl: AlgebraicGeometry.twistCollapseN_diff
docstring: '**The Čech differential square**: the overlap collapse intertwines the
  two-cover Čech

  differential of the field pair with that of the relative pair, through the two chart

  collapses.'
file: AlgebraicJacobian/Cohomology/RelThetaTransportCore.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.twistCollapseN_diff
type: lean
updated: '2026-07-30T15:28:06'
---
lemma twistCollapseN_diff
    (z : (thetaTwistSheaf π n).obj.obj (op (fiberChart₀ π)) ×
      (thetaTwistSheaf π n).obj.obj (op (fiberChart₁ π))) :
    twistCollapseN C π n ((thetaFieldPair C π n).diff z) =
      (relTwistPair C k π (relThetaCocycle C k π n)).diff
        (twistCollapse₀ C π n z.1, twistCollapse₁ C π n z.2) := by
  rw [TwoLatticePair.diff_apply, TwoLatticePair.diff_apply, map_sub]
  congr 1
  · exact twistCollapseN_twistRes_left C π n z.1
  · exact twistCollapseN_twistRes_right C π n z.2