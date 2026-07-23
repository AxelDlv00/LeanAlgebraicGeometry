---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:cech_free_eval_prepend_homotopy_spec
lean_status: empty
order: 202
title: The prepend homotopy contracts the augmented evaluated complex, by transport
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Source: Stacks Project, Cohomology, \texttt{lemma-homology-complex}
  (the contracting identity).}
  In the situation of Lemma~\ref{lem:cech_free_eval_prepend_homotopy}
  (\(I_1(V) \neq \varnothing\), \(i_{\mathrm{fix}} \in I_1\) fixed), the transported
  prepend homotopy \(h\) satisfies the contracting identity
  \[
    d \circ h + h \circ d = \mathrm{id}
  \]
  on the augmented evaluated complex
  \(\cdots \to K(\mathcal{U})_1(V) \to K(\mathcal{U})_0(V) \to
  \mathcal{O}_{\mathcal{U}}(V) \to 0\) (including the degree-\(0\)/degree-\((-1)\)
  augmentation term). Here \(d\) is the alternating-sum {\v C}ech differential of
  Lemma~\ref{lem:cech_free_eval_sectionwise}.