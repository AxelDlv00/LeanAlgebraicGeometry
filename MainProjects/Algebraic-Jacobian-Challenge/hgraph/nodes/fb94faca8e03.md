---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:section_localization_descent
lean_status: lean_ok
order: 1117
title: Section-localization descent for quasi-coherent modules (gap1 keystone)
type: tex
updated: '2026-07-27T20:11:17'
---
For a quasi-coherent sheaf of modules \(M\) on \(\Spec R\) and \(f \in R\), the section
  restriction \(\Gamma(M, \top) \to \Gamma(M, D(f))\) exhibits the target as the
  localization \(\Gamma(M, \top)[1/f]\) over \(R\). This is the statement of
  \cref{lem:qcoh_section_localization_basicOpen} at the affine open \(\top\) of
  \(\Spec R\), proved here by finite-cover descent --- not through the affine
  equivalence of quasi-coherent modules with modules, which is instead \emph{derived}
  from this lemma in \cref{lem:qcoh_affine_isIso_fromTildeΓ}.