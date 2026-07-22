---
author: sync
chapter: Closed points, divisors and skyscraper cohomology
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:fiberCover
lean_status: lean_ok
order: 637
title: The pinned two-cover and its coordinate
type: tex
updated: '2026-07-17T16:57:16'
---
Write \(V_0 = \pi^{-1}(U_0)\) and \(V_1 = \pi^{-1}(U_1)\) for the preimages of the two standard
  charts \(U_i = D_+(X_i)\) of \(\PP^1\) (\ref{def:P1_chartOpen}); they cover \(Y\)
  (\ref{lem:preimage_chart_sup}). The pinned two-cover assigns to a point of \(Y\) the chart \(V_0\)
  if the point lies in \(V_0\), and \(V_1\) otherwise. Let
  \[
    t_0 \;=\; \pi^{\sharp}(t_{01}) \;\in\; \Gamma(Y, V_0)
  \]
  be the pullback along \(\pi\) of the chart-\(0\) coordinate \(t_{01} = X_1/X_0\)
  (\ref{def:P1_chartCoord}). Then the overlap of the two-cover is exactly the locus where \(t_0\) is
  invertible:
  \[
    V_0 \cap V_1 \;=\; D(t_0),
  \]
  the basic open of \(t_0\); consequently the restriction of \(t_0\) to \(V_0 \cap V_1\) is a unit of
  \(\Gamma(Y, V_0 \cap V_1)\).