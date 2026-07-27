---
author: sync
chapter: Codimension-1 indeterminacy extension (A.4.a)
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:rationalMap_prod
lean_status: lean_ok
order: 1679
title: def:rationalMap_prod
type: tex
updated: '2026-07-27T20:42:21'
---
Let \(s_X \colon X \to S\), \(s_Y \colon Y \to S\), \(s_Z \colon Z \to S\) be structure
  morphisms with \(X\) integral and \(s_Y, s_Z\) locally of finite type, and let
  \(a \colon X \dashrightarrow Y\), \(b \colon X \dashrightarrow Z\) be rational maps over
  \(S\) (i.e.\ \(a\) restricted to the generic point commutes with the structure morphisms,
  and likewise for \(b\)). The \textbf{pairing} \(a \times_S b \colon X \dashrightarrow
  Y \times_S Z\) is the rational map corresponding, under the function-field correspondence,
  to the morphism
  \[
    \operatorname{Spec} K(X)
    \xrightarrow{\;\langle a_\eta,\, b_\eta \rangle\;}
    Y \times_S Z
  \]
  obtained from the generic-point morphisms \(a_\eta \colon \operatorname{Spec} K(X) \to Y\)
  and \(b_\eta \colon \operatorname{Spec} K(X) \to Z\) by the universal property of the fibre
  product (their composites with the structure morphisms both equal
  \(\operatorname{Spec} K(X) \to \operatorname{Spec}\mathcal O_{X,\eta} \to X \to S\)).