---
author: sync
chapter: Closed points, divisors and skyscraper cohomology
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:graphSectionEval
lean_status: lean_ok
order: 666
title: The evaluation at the graph section
type: tex
updated: '2026-07-17T16:57:16'
---
Let \(W\) be an open of \(C_K\) containing the graph point \(x_t\). The preimage of
  \(W\) under the section \(g_t\) is all of \(\Spec K\) (a one-point space whose point maps
  to \(x_t \in W\)), so pullback of sections along \(g_t\) defines a ring homomorphism
  \[
    \varepsilon_t \colon \Gamma(C_K, W) \longrightarrow \Gamma(\Spec K, \top),
  \]
  compatible with restriction of the open.