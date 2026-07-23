---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:standard_cover_cofinal_affine
lean_status: lean_ok
order: 419
title: Standard covers are cofinal among open covers of a general affine open
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Source: Stacks Project, Sheaves on Spaces, Tag 009L,
  \texttt{lemma-cofinal-systems-coverings-standard-case}.}
  Let \(V\) be \emph{any} affine open of \(\operatorname{Spec} R\), and let \(\{W_\alpha\}_{\alpha \in A}\)
  be an arbitrary open covering of \(V\) (each \(W_\alpha\) an open of \(\operatorname{Spec} R\) contained
  in \(V\)). Then there exist a finite \(n\), a family \(g : \{1, \dots, n\} \to R\), and a reindexing
  \(\varphi : \{1, \dots, n\} \to A\) such that
  \[
    V = \bigcup_{i=1}^n D(g_i)
    \qquad\text{and}\qquad
    D(g_i) \subseteq W_{\varphi(i)} \quad (1 \le i \le n).
  \]
  That is, every open covering of an arbitrary affine open \(V\) is refined by a finite standard cover by
  distinguished opens, each sitting inside a member of the original covering. This is the
  general-affine-open companion of Lemma~\ref{lem:standard_cover_cofinal}, the only change being the source
  of quasi-compactness: the compactness of the affine open \(V\) (every affine scheme is quasi-compact) in
  place of the compactness of a distinguished \(D(f)\).