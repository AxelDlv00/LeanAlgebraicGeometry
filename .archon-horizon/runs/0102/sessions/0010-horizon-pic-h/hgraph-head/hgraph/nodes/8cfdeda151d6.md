---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: lemma
created: '2026-07-16T21:33:29'
generated: blueprint
label: lem:snd_left_naturality
lean_status: lean_ok
order: 799
title: The base square of the second projection
type: tex
updated: '2026-07-17T18:01:33'
---
For a morphism \(g \colon T' \to T\) of test objects, whiskering \(C \lhd g\) on the product
  intertwines the two projections:
  \[
    (C \lhd g)_{\mathrm{left}} \circ (\mathrm{snd}_{C,T})_{\mathrm{left}}
      = (\mathrm{snd}_{C,T'})_{\mathrm{left}} \circ g_{\mathrm{left}}.
  \]
  Consequently the two legs of this square have equal open preimages: for every open \(V
  \subseteq T_{\mathrm{left}}\), \((C \lhd g)^{-1}\mathrm{pr}^{-1} V = \mathrm{pr}'^{-1}
  g_{\mathrm{left}}^{-1} V\).