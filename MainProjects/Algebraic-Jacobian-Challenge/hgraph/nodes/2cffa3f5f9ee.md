---
author: sync
chapter: Acyclic resolutions compute right-derived functors
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:horseshoe_chainMap
lean_status: linked
order: 157
title: The inclusion and projection are chain maps
type: tex
updated: '2026-07-29T11:05:43'
---
With \(d_B\) as in Lemma~\ref{lem:horseshoe_dComp}, the degreewise biproduct
  coprojection \(\iota^n = \iota_{I_A^n} : I_A^n \to I_B^n\) and projection
  \(\pi^n = \pi_{I_C^n} : I_B^n \to I_C^n\) assemble into chain maps
  \(\iota : I_A^\bullet \to I_B^\bullet\) and \(\pi : I_B^\bullet \to I_C^\bullet\); that
  is, \(d_B^n \circ \iota^n = \iota^{n+1} \circ d_A^n\) and
  \(\pi^{n+1} \circ d_B^n = d_C^n \circ \pi^n\). Moreover \(\iota, \pi\) are compatible
  with the augmentations and form, in each degree, the split short exact sequence
  \(0 \to I_A^n \to I_B^n \to I_C^n \to 0\) of
  Lemma~\ref{lem:horseshoe_degree_split}.