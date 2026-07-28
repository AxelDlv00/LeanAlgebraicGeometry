---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:internal_hom_isSheaf
lean_status: lean_ok
order: 718
title: The internal hom is a sheaf; the sheaf-level dual
type: tex
updated: '2026-07-28T22:30:27'
---
\textit{Source: [Stacks Project], ``Modules on Ringed Spaces'', \S Internal Hom
  (tag area 01CM).}
  Let \(X\) be a scheme, \(R = X.\mathtt{ringCatSheaf}\), and let
  \(M, N \in \Scheme.\mathtt{Modules}\,X\) with \(N\) a sheaf of modules. Then the
  presheaf internal hom \(\mathcal{H}om(M, N)\) of \cref{def:presheaf_internal_hom}
  satisfies the sheaf condition: for an open cover \(\{U_i\}\) of \(U\), a family of
  morphisms \(M|_{U_i} \to N|_{U_i}\) agreeing on the overlaps
  \(U_i \cap U_j\) glues to a unique morphism \(M|_U \to N|_U\), because \(N\) is a
  sheaf and morphisms of sheaves of modules are determined and gluable section-wise.
  Hence \(\mathcal{H}om(M, N)\) descends to an object of \(\Scheme.\mathtt{Modules}\,X\).
  Specialising to \(N = \mathcal{O}_X = \mathtt{SheafOfModules.unit}\,R\) gives the
  \emph{sheaf-level dual}
  \[
    \mathtt{dual}\,M \;:=\; \mathcal{H}om_{\mathcal{O}_X}(M, \mathcal{O}_X)
    \;\in\; \Scheme.\mathtt{Modules}\,X,
  \]
  and the evaluation \cref{lem:internal_hom_eval} descends to a morphism of sheaves of
  modules \(M \otimes_X \mathtt{dual}\,M \to \mathcal{O}_X\).