---
author: sync
chapter: The rigidity lemma and its Milne \S I.1--I.3 corollaries
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:rigidity_snd_lift
lean_status: lean_ok
order: 536
title: Cartesian-monoidal collapse identity
type: tex
updated: '2026-07-24T11:03:43'
---
Let \(X\), \(Y\) be objects over \(\bar k\) and fix a \(\bar k\)-point \(x_0\) of \(X\).
  Post-composing the second projection \(p_2 \colon X \times Y \to Y\) with the slice section
  \(y \mapsto (x_0, y)\) equals the ``collapse the \(X\)-coordinate onto \(x_0\)'' endomorphism
  \((x, y) \mapsto (x_0, y)\) of \(X \times Y\). This is pure cartesian-monoidal algebra (no
  geometry): the product universal property distributes \(p_2\), the \(Y\)-component simplifies by
  the identity law, and the \(X\)-component collapses by uniqueness of maps to the terminal object.