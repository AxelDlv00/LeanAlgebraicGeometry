---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:glue_sections_equalizer
lean_status: lean_ok
order: 1207
title: Global sections of a glued sheaf are the compatible families
type: tex
updated: '2026-07-28T04:57:37'
---
With the data and module cocycle conditions (C1)(C2) of
  \Cref{def:scheme_modules_glue}, restriction to the charts induces a
  \(\Gamma(D.\mathrm{glued}, X)\)-linear isomorphism
  \[
    \Gamma\bigl(\mathrm{glue}(D,M,g),\, X\bigr) \;\xrightarrow{\ \sim\ }\;
      \mathrm{Compat}(D, M, g)
  \]
  (\Cref{def:glue_gamma_compatible}), sending a global section to the family
  of its restrictions to the charts \(U_i\), with inverse sending a
  compatible family to the unique global section restricting to it on every
  chart. In particular global sections of the glued sheaf are jointly
  detected by their restrictions to the charts.