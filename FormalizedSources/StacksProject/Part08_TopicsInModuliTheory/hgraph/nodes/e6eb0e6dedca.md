---
author: sync
chapter: Moduli of Curves
content_type: lemma
created: '2026-08-27T16:31:53'
generated: blueprint
group: moduli-curves
label: moduli-curves-lemma-prestable-curves
lean_status: empty
order: 94
ref: stacks:0E6U
title: Prestable curves
type: tex
updated: '2026-08-27T16:31:53'
---
\href{https://stacks.math.columbia.edu/tag/0E6U}{\texttt{Stacks tag 0E6U}}


There exist an open substack $\Curvesstack^{prestable} \subset \Curvesstack$
such that
\begin{enumerate}
\item given a family of curves $f : X \to S$ the following are equivalent
\begin{enumerate}
\item the classifying morphism $S \to \Curvesstack$ factors
through $\Curvesstack^{prestable}$,
\item $X \to S$ is a prestable family of curves,
\end{enumerate}
\item given $X$ a scheme proper over a field $k$ with
$\dim(X) \leq 1$ the following are equivalent
\begin{enumerate}
\item the classifying morphism $\Spec(k) \to \Curvesstack$
factors through $\Curvesstack^{prestable}$,
\item the singularities of $X$ are at-worst-nodal, $\dim(X) = 1$,
and $k = H^0(X, \mathcal{O}_X)$.
\end{enumerate}
\end{enumerate}