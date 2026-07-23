---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:cech_cohomology_accessor
lean_status: lean_ok
order: 311
title: '{\v C}ech cohomology accessor'
type: tex
updated: '2026-07-24T03:02:14'
---
\textit{Project-local accessor.}
  For an index family \(U : \iota \to \mathrm{Opens}(X)\) (giving the covering \(\mathcal{U}\)), a
  presheaf of \(\mathcal{O}_X\)-modules \(\mathcal{F}\), and \(p \geq 0\), the \emph{{\v C}ech
  cohomology} \(\check{H}^p(\mathcal{U}, \mathcal{F})\) is the degree-\(p\) homology of the section
  {\v C}ech complex of Definition~\ref{def:section_cech_complex},
  \[
    \check{H}^p(\mathcal{U}, \mathcal{F}) \;:=\;
      H^p\bigl(\check{\mathcal{C}}^\bullet(\mathcal{U}, \mathcal{F})\bigr),
  \]
  taken as an object of \(\mathrm{Ab}\). This is the named wrapper that the 01EO chain refers to
  uniformly.