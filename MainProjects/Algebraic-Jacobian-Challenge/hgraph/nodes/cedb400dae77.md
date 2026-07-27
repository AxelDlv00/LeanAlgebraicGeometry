---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:cover_datum_bridge
lean_status: lean_ok
order: 236
title: Standard-cover opens are the distinguished opens \(D(s_i)\)
type: tex
updated: '2026-07-27T15:50:36'
---
\textit{Project-bespoke compatibility lemma.}
  Let \(\mathcal{U}\) be the standard affine cover associated to a spanning family
  \(s : \iota \to R\) with \(\operatorname{span}(\operatorname{range} s) = \top\)
  (Definition~\ref{def:standard_affine_cover}). For each index \(i\) the \(i\)-th open of
  \(\mathcal{U}\) is exactly the distinguished open \(D(s_i)\):
  \[
    \operatorname{coverOpen} \mathcal{U}\, i \;=\; D(s_i)
    \quad\text{in } \mathrm{Opens}(\operatorname{Spec} R).
  \]
  This identifies the opens of a standard cover with distinguished opens, which is the form in
  which a standard cover is recognised inside the basis \(\mathcal{B}\) of the affine cover system.