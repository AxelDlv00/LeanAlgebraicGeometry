---
author: sync
chapter: Moduli Stacks
content_type: definition
created: '2026-08-27T16:31:52'
generated: blueprint
group: moduli
label: moduli-situation-numerical
lean_status: empty
order: 6
ref: stacks:0DNC
title: 'Situation: Numerical invariants'
type: tex
updated: '2026-08-27T16:31:52'
---
\href{https://stacks.math.columbia.edu/tag/0DNC}{\texttt{Stacks tag 0DNC}}


Let $f : X \to B$ be as in the introduction to this section. Let $I$
be a set and for $i \in I$ let $E_i \in D(\mathcal{O}_X)$ be perfect.
Given an object $(T \to B, \mathcal{F})$ of $\Cohstack_{X/B}$
denote $E_{i, T}$ the derived pullback of $E_i$ to $X_T$.
The object
$$
K_i = Rf_{T, *}(E_{i, T} \otimes_{\mathcal{O}_{X_T}}^\mathbf{L} \mathcal{F})
$$
of $D(\mathcal{O}_T)$ is perfect and its formation commutes with base change,
see Derived Categories of Spaces, Lemma
\ref{spaces-perfect-lemma-base-change-tensor-perfect}.
Thus the function
$$
\chi_i : |T| \longrightarrow \mathbf{Z},\quad
\chi_i(t) =
\chi(X_t, E_{i, t} \otimes_{\mathcal{O}_{X_t}}^\mathbf{L} \mathcal{F}_t) =
\chi(K_i \otimes_{\mathcal{O}_T}^\mathbf{L} \kappa(t))
$$
is locally constant by Derived Categories of Spaces, Lemma
\ref{spaces-perfect-lemma-chi-locally-constant}.
Let $P : I \to \mathbf{Z}$ be a map. Consider the substack
$$
\Cohstack^P_{X/B} \subset \Cohstack_{X/B}
$$
consisting of flat families of coherent sheaves with proper support
whose numerical invariants agree with $P$. More precisely, an object
$(T \to B, \mathcal{F})$ of $\Cohstack_{X/B}$ is in
$\Cohstack^P_{X/B}$ if and only if $\chi_i(t) = P(i)$ for all $i \in I$
and $t \in T$.