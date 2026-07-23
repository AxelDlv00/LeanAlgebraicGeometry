---
author: sync
chapter: 'Effective descent: restriction of the glued sheaf to a chart'
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:gr_glueChartComponent
lean_status: lean_ok
order: 1442
title: The \(j\)-th component of the candidate inverse
type: tex
updated: '2026-07-16T21:14:30'
---
Given the transition isomorphisms \(g_{ij} : f_{ij}^{*}\mathcal{M}_i \xrightarrow{\sim}
  (t_{ij}\circ f_{ji})^{*}\mathcal{M}_j\), the \(j\)-th component of the candidate
  inverse \(\mathrm{s}_i\) is the composite
  \[
    \mathcal{M}_i
      \xrightarrow{\ \eta_{f_{ij}}\ }
    (f_{ij})_{*}\,f_{ij}^{*}\mathcal{M}_i
      \xrightarrow{\ (f_{ij})_{*}g_{ij}\ }
    (f_{ij})_{*}\,(t_{ij}\circ f_{ji})^{*}\mathcal{M}_j
      \xrightarrow{\ \gamma_{ij}^{-1}\ }
    \iota_i^{*}\bigl((\iota_j)_{*}\mathcal{M}_j\bigr),
  \]
  i.e. the geometric unit along \(f_{ij}\), the pushforward of the transition
  \(g_{ij}\), and the inverse of \(\gamma_{ij}\) (\cref{def:gr_glueOverlapFactorIso}).