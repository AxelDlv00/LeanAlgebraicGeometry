---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:sectionsFunctorCorepIso
lean_status: lean_ok
order: 414
title: The sections functor is corepresented by \(j_!\mathcal{O}_V\)
type: tex
updated: '2026-07-26T00:08:21'
---
For an open \(V \subseteq X\) there is a natural isomorphism of additive functors
  \[
    \operatorname{sectionsFunctor} V
      \;\cong\;
    \operatorname{Hom}_{X.\mathrm{Modules}}\bigl(j_!\mathcal{O}_V,\, -\bigr)
  \]
  between \(\Gamma(V, -)\) and the covariant additive hom-functor corepresented by
  \(j_!\mathcal{O}_V\). It is the functorial upgrade of the corepresentability bijection of
  Lemma~\ref{lem:jshriek_corepr}.