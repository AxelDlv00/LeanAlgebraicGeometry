---
author: sync
chapter: Moduli of Curves
content_type: remark
created: '2026-08-27T16:31:52'
generated: blueprint
group: moduli-curves
label: moduli-curves-remark-boundedness-aut-does-not-work-surfaces
lean_status: empty
order: 58
ref: stacks:0DSR
title: Boundedness aut does not work surfaces
type: tex
updated: '2026-08-27T16:31:52'
---
\href{https://stacks.math.columbia.edu/tag/0DSR}{\texttt{Stacks tag 0DSR}}


The boundedness argument in the proof of
Lemma \ref{moduli-curves-lemma-curves-diagonal-separated-fp}
does not work for moduli of surfaces and in fact,
the result is wrong, for example because K3 surfaces
over fields can have infinite discrete automorphism groups.
The ``reason'' the argument does not work is that on a
projective surface $S$ over a field,
given ample invertible sheaves $\mathcal{N}$
and $\mathcal{L}$ with Hilbert polynomials $Q$ and $P$,
there is no a priori bound on the Hilbert polynomial
of $\mathcal{N} \otimes_{\mathcal{O}_S} \mathcal{L}$.
In terms of intersection theory, if $H_1$, $H_2$ are ample effective
Cartier divisors on $S$,
then there is no (upper) bound on the intersection number $H_1 \cdot H_2$
in terms of $H_1 \cdot H_1$ and $H_2 \cdot H_2$.