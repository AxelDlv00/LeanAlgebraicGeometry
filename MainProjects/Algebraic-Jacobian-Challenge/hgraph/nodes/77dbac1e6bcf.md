---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:overProdLeftIsoPullback_mathlib
lean_status: mathlib_ok
mathlib_name:
- CategoryTheory.Over.prodLeftIsoPullback
order: 342
title: The underlying object of a slice binary product is the pullback
type: tex
updated: '2026-07-24T03:02:14'
---
\textit{Provided by Mathlib.}
  For \(S \in \mathcal{C}\) and two objects \(Y, Z \in \operatorname{Over} S\) (with \(\mathcal{C}\)
  having the relevant pullback), the underlying object of their binary product in the slice is the
  fibre product of their structure maps: \((Y \times Z).\mathrm{left} \cong \operatorname{pullback}
  Y.\mathrm{hom}\, Z.\mathrm{hom}\), compatibly with the projections.