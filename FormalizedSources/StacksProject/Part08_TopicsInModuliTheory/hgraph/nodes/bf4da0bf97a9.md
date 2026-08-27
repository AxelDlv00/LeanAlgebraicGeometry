---
author: sync
chapter: Moduli of Curves
content_type: lemma
created: '2026-08-27T16:31:53'
generated: blueprint
group: moduli-curves
label: moduli-curves-lemma-stable-curves
lean_status: empty
order: 104
ref: stacks:0E76
title: Stable curves
type: tex
updated: '2026-08-27T16:31:53'
---
\href{https://stacks.math.columbia.edu/tag/0E76}{\texttt{Stacks tag 0E76}}


There exist an open substack $\Curvesstack^{stable} \subset \Curvesstack$
such that
\begin{enumerate}
\item given a family of curves $f : X \to S$ the following are equivalent
\begin{enumerate}
\item the classifying morphism $S \to \Curvesstack$ factors
through $\Curvesstack^{stable}$,
\item $X \to S$ is a stable family of curves,
\end{enumerate}
\item given $X$ a scheme proper over a field $k$ with
$\dim(X) \leq 1$ the following are equivalent
\begin{enumerate}
\item the classifying morphism $\Spec(k) \to \Curvesstack$
factors through $\Curvesstack^{stable}$,
\item the singularities of $X$ are at-worst-nodal, $\dim(X) = 1$,
$k = H^0(X, \mathcal{O}_X)$, the genus of $X$ is $\geq 2$, and
$X$ has no rational tails or bridges,
\item the singularities of $X$ are at-worst-nodal, $\dim(X) = 1$,
$k = H^0(X, \mathcal{O}_X)$, and $\omega_{X_s}$ is ample.
\end{enumerate}
\end{enumerate}