---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:isinvertible_inverse_welldef
lean_status: lean_ok
order: 693
title: The tensor inverse is determined up to isomorphism
type: tex
updated: '2026-07-28T00:40:21'
---
\textit{Source: [Stacks Project], Tag 01CR, Lemma~\texttt{lemma-invertible}: when
  \(\mathcal{L}\) is invertible the module \(\mathcal{N}\) with
  \(\mathcal{L} \otimes_{\mathcal{O}_X} \mathcal{N} \cong \mathcal{O}_X\) is
  isomorphic to the dual \(\SheafHom_{\mathcal{O}_X}(\mathcal{L}, \mathcal{O}_X)\),
  hence unique up to isomorphism.}
  Let \(X\) be a scheme and \(M, N, N' \in \Scheme.\mathtt{Modules}\,X\). If
  \(M \otimes_X N \cong \mathcal{O}_X\) and \(M \otimes_X N' \cong \mathcal{O}_X\),
  then \(N \cong N'\). Consequently the assignment \([M] \mapsto [N]\), sending an
  invertible class to the class of its tensor inverse, is well-defined on
  \(\Pic X\).