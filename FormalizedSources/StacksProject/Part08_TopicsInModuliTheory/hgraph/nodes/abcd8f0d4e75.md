---
author: sync
chapter: Moduli of Curves
content_type: lemma
created: '2026-08-27T16:31:53'
generated: blueprint
group: moduli-curves
label: moduli-curves-lemma-one-piece-per-genus
lean_status: empty
order: 74
ref: stacks:0E1K
title: One piece per genus
type: tex
updated: '2026-08-27T16:31:53'
---
\href{https://stacks.math.columbia.edu/tag/0E1K}{\texttt{Stacks tag 0E1K}}


There is a decomposition into open and closed substacks
$$
\Curvesstack^{grc, 1} = \coprod\nolimits_{g \geq 0} \Curvesstack^{grc, 1}_g
$$
where each $\Curvesstack^{grc, 1}_g$ is characterized as follows:
\begin{enumerate}
\item given a family of curves $f : X \to S$ the following are equivalent
\begin{enumerate}
\item the classifying morphism $S \to \Curvesstack$ factors
through $\Curvesstack^{grc, 1}_g$,
\item the geometric fibres of the morphism $f : X \to S$ are
reduced, connected, of dimension $1$ and
$R^1f_*\mathcal{O}_X$ is a locally free $\mathcal{O}_S$-module
of rank $g$,
\end{enumerate}
\item given a scheme $X$ proper over a field $k$ with $\dim(X) \leq 1$
the following are equivalent
\begin{enumerate}
\item the classifying morphism $\Spec(k) \to \Curvesstack$ factors
through $\Curvesstack^{grc, 1}_g$,
\item $X$ is geometrically reduced, geometrically connected,
has dimension $1$, and has genus $g$.
\end{enumerate}
\end{enumerate}