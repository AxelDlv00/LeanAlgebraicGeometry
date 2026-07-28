---
author: sync
chapter: 'The Grassmannian over $\mathbb{Z}$: affine charts and gluing'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:gr_existence_lift
lean_status: lean_ok
order: 1452
title: E4 --- the filler and its two triangles
type: tex
updated: '2026-07-29T06:43:24'
---
\textit{Source: [Nitsure], \S 1.}
  The morphism
  \[
    \ell \;:=\; \Spec(g') \circ \iota_J : \Spec R \to U^J \to \mathrm{Gr}(r,d)
  \]
  (with \(g' : R^J \to R\) from
  \cref{lem:gr_existence_factor_through_valuation_ring} and \(\iota_J\) the chart
  immersion of \cref{def:gr_the_glue_data}) is a diagonal filler of the valuative
  square: it restricts to \(i_1\) over the generic point \(\Spec K\), and it lies
  over \(\Spec \mathbb{Z}\). Hence the valuative square has a lift.