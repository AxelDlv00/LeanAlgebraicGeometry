---
author: sync
chapter: Closed points, divisors and skyscraper cohomology
content_type: lemma
created: '2026-07-17T16:57:16'
generated: blueprint
label: lem:overAlgebraMap_app
lean_status: lean_ok
order: 620
title: Naturality of the algebra map on sections
type: tex
updated: '2026-07-17T16:57:16'
---
Let \(W, X\) be schemes over \(\Spec K\) and \(f : W \to X\) a morphism of schemes
  over \(\Spec K\). For every open \(U \subseteq X\) and every scalar \(a \in K\), the
  pullback of sections along \(f\) carries the canonical image of \(a\) in
  \(\Gamma(X, U)\) (\ref{def:overAlgebraMap}) to the canonical image of \(a\) in
  \(\Gamma(W, f^{-1}U)\):
  \[
    f^{\sharp}\bigl(\iota^{X}_{U}(a)\bigr) \;=\; \iota^{W}_{f^{-1}U}(a),
  \]
  where \(\iota\) denotes the algebra map on sections.