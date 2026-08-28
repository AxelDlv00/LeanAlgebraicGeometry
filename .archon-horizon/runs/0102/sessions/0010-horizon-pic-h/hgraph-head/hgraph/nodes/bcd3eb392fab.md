---
author: sync
chapter: Cohomology of sheaves of modules
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:fiberTwoCover
lean_status: lean_ok
order: 464
title: The pinned affine two-cover
type: tex
updated: '2026-07-24T17:02:48'
---
For an affine morphism \(\pi : Y \to \PP^1\), the chart preimages
  \(V_0 = \pi^{-1}D_+(X_0)\), \(V_1 = \pi^{-1}D_+(X_1)\) form an \emph{affine two-cover}
  of \(Y\) (\ref{def:AffineTwoCover}): both charts are affine
  (\ref{lem:preimage_chart_affine}), they cover \(Y\)
  (\ref{lem:preimage_chart_sup}), and the overlap
  \(V_0 \cap V_1 = \pi^{-1}D_+(X_0 X_1)\) (\ref{lem:P1_chartOpen_inf}) is affine, being
  the preimage of an affine open under an affine morphism. This is the cover of
  \ref{def:fiberCover}, upgraded with the affineness of the overlap; the whole engine
  runs on it and on its base change.