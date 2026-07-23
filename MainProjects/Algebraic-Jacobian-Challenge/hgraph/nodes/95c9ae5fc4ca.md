---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:qcoh_iso_tilde_sections_of_presentation
lean_status: lean_ok
order: 240
title: Affine structure theorem from a global presentation
type: tex
updated: '2026-07-24T03:02:14'
---
\textit{Source: Stacks Project, Schemes, Tag 01I8, \texttt{lemma-quasi-coherent-affine}.}
  Let \(X = \operatorname{Spec} R\) and let \(\mathcal{F}\) be an \(\mathcal{O}_X\)-module that admits
  a \emph{global} presentation (a global exact sequence
  \(\mathcal{O}_X^{(J)} \to \mathcal{O}_X^{(I)} \to \mathcal{F} \to 0\), the data
  \(\mathcal{F}.\mathrm{Presentation}\)). Then \(\mathcal{F}\) is isomorphic to the sheaf
  \(\widetilde{\Gamma(X, \mathcal{F})}\) associated to its module of global sections. This is the
  presentation-driven discharge of the conditional hypothesis
  \(\operatorname{IsIso}(\operatorname{fromTilde\Gamma})\) of Lemma~\ref{lem:qcoh_iso_tilde_sections}.