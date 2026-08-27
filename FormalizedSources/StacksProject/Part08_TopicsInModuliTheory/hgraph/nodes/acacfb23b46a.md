---
author: sync
chapter: Moduli Stacks
content_type: remark
created: '2026-08-27T16:31:52'
generated: blueprint
group: moduli
label: moduli-remark-quot-numerical
lean_status: empty
order: 18
ref: stacks:0DP6
title: Numerical invariants
type: tex
updated: '2026-08-27T16:31:52'
---
\href{https://stacks.math.columbia.edu/tag/0DP6}{\texttt{Stacks tag 0DP6}}



Let $f : X \to B$ and $\mathcal{F}$ be as in the introduction to this section.
Let $I$ be a set and for $i \in I$ let $E_i \in D(\mathcal{O}_X)$ be perfect.
Let $P : I \to \mathbf{Z}$ be a function. Recall that we have a morphism
$$
\Quotfunctor_{\mathcal{F}/X/B} \longrightarrow \Cohstack_{X/B}
$$
which sends the element $\mathcal{F}_T \to \mathcal{Q}$
of $\Quotfunctor_{\mathcal{F}/X/B}(T)$ to the object $\mathcal{Q}$
of $\Cohstack_{X/B}$ over $T$, see proof of
Quot, Proposition \ref{quot-proposition-quot}. Hence we can form
the fibre product diagram
$$
\begin{array}{cc}\Quotfunctor^P_{\mathcal{F}/X/B} \longrightarrow\downarrow & \Cohstack^P_{X/B} \downarrow \\ \Quotfunctor_{\mathcal{F}/X/B} \longrightarrow & \Cohstack_{X/B}\end{array}
$$
This is the defining diagram for the algebraic space in the
upper left corner. The left vertical arrow is a
flat closed immersion which is an open and closed immersion
for example if $I$ is finite, or $B$ is locally Noetherian, or
$I = \mathbf{Z}$ and $E_i = \mathcal{L}^{\otimes i}$ for some
invertible $\mathcal{O}_X$-module $\mathcal{L}$ (in the last
case we sometimes use the notation
$\Quotfunctor^{P, \mathcal{L}}_{\mathcal{F}/X/B}$).
See Situation \ref{moduli-situation-numerical} and
Lemmas \ref{moduli-lemma-open-P} and \ref{moduli-lemma-finite-list-perfect-objects} and
Example \ref{moduli-example-hilbert-polynomial}.