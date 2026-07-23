---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:sectionCechAugV
lean_status: lean_ok
order: 384
title: Canonical augmentation of the section {\v C}ech complex over \(V\)
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Project-local.}
  Fix an open \(V \subseteq X\). The \emph{canonical augmentation}
  \[
    \varepsilon_{\mathrm{can}} : \Gamma(V, \mathcal{F}) \longrightarrow
      \prod_i \Gamma(U_i \cap V, \mathcal{F})
  \]
  of the concrete section {\v C}ech complex over the restricted family
  \(U'_i = \operatorname{coverOpen}\mathcal{U}\,i \cap V\) is the evaluation at \(V\) of the {\v C}ech
  augmentation \(\mathcal{F} \to \mathcal{C}^0\) of Definition~\ref{def:cech_augmentation},
  transported across the degree-\(0\) object isomorphism of Lemma~\ref{lem:coreIso_obj_iso}.
  Concretely it is the composite
  \(G_V\bigl(\Psi(\operatorname{cechAugmentation})\bigr) \cdot (\mathrm{objIso}\,0).\mathrm{hom}\),
  where \(\Psi = \operatorname{forget}\cdot\operatorname{restrictScalars}(\mathrm{id})\) is the
  push--pull adapter, \(G_V = \operatorname{toPresheaf}\cdot\operatorname{ev}_V\) is the
  section-at-\(V\) functor, and \(\mathrm{objIso}\,0\) is the degree-\(0\) instance of
  Lemma~\ref{lem:coreIso_obj_iso}. It carries no free parameter: this is the unique augmentation
  for which the comparisons below hold.