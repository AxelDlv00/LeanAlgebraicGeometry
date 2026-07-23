---
author: sync
chapter: The rigidity lemma and its Milne \S I.1--I.3 corollaries
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:rigidity_core
lean_status: lean_ok
order: 539
title: Scheme-level gluing core of the Rigidity Lemma
type: tex
updated: '2026-07-16T21:14:29'
---
Let \(\bar k\) be algebraically closed, \(X\) proper, \(X \times Y\) geometrically irreducible,
  reduced and locally of finite type over \(\bar k\), and \(Z\) separated. Let
  \(f \colon X \times Y \to Z\) collapse the slice \(X \times \{y_0\}\) to a single point \(z_0\).
  Then \(f\) equals its composite with the collapse endomorphism \((x, y) \mapsto (x_0, y)\), i.e.\
  \(f = \mathtt{retract} \fatsemi f\). The proof takes the non-empty open \(U\) on which \(f\) and
  \(\mathtt{retract} \fatsemi f\) agree (\cref{lem:rigidity_eqOn_dense_open}); since \(X \times Y\)
  is geometrically irreducible over the one-point base \(\Spec \bar k\), it is irreducible, so the
  non-empty open \(U\) is dense and its inclusion is dominant; the dominant-source/separated-target
  rigidity handle then promotes agreement on \(U\) to equality of the two morphisms everywhere.