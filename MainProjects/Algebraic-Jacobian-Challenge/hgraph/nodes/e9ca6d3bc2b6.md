---
author: sync
chapter: The Quot scheme
content_type: theorem
created: '2026-07-16T21:14:30'
generated: blueprint
label: thm:quot_representable
lean_status: sorry
order: 1209
title: Representability of the Quot functor
type: tex
updated: '2026-07-24T10:32:51'
---
\textit{Source: [Nitsure], \S 5, Theorem (Grothendieck), Theorem
  (Altman--Kleiman) (FGA Explained Ch.~5); cf.\ Grothendieck, FGA TDTE-IV.}
  Let \(S\) be a noetherian scheme, \(\pi : X \to S\) a projective morphism,
  \(L\) a relatively very ample line bundle on \(X\), \(E\) a coherent
  \(\mathcal{O}_X\)-module, and \(\Phi \in \mathbb{Q}[\lambda]\). Then the
  functor \(\Quot^{\Phi,L}_{E/X/S}\) of \cref{def:quot_functor} is
  representable by a projective \(S\)-scheme \(\Quot^{\Phi,L}_{E/X/S}\),
  equipped with a universal quotient
  \[
    q^{\mathrm{univ}} :
    \pi^*_{\Quot} E \twoheadrightarrow \mathcal{F}^{\mathrm{univ}}
    \quad \text{on } X \times_S \Quot^{\Phi,L}_{E/X/S},
  \]
  flat over \(\Quot^{\Phi,L}_{E/X/S}\) with constant Hilbert polynomial
  \(\Phi\) on every fiber. The Hilbert scheme is the special case
  \(E = \mathcal{O}_X\): \(\Hilb^{\Phi,L}_{X/S} = \Quot^{\Phi,L}_{\mathcal{O}_X/X/S}\)
  represents the functor of \(T\)-flat closed subschemes
  \(Y \subset X_T\) with fiberwise Hilbert polynomial \(\Phi\).