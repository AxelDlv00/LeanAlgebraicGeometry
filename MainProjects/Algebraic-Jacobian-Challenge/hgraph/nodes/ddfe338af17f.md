---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:restrictscalars_laxmonoidal
lean_status: lean_ok
order: 641
title: Sectionwise lax-monoidal structure on \(\mathtt{restrictScalars}\,\varphi\)
type: tex
updated: '2026-07-28T04:57:36'
---
Let \(\varphi : R \to S\) be a morphism of presheaves of \emph{commutative}
  rings on a site (so that both \(R\) and \(S\) factor through
  \(\mathtt{CommRingCat}\) and the category of presheaves of modules over each
  is monoidal). Then the presheaf-of-modules restriction-of-scalars functor
  \(\mathtt{PresheafOfModules.restrictScalars}\,\varphi\) is lax monoidal.
  Consequently, composing with the already-monoidal Mathlib functor
  \(\mathtt{pushforward}_0\mathtt{OfCommRingCat}\) via
  \(\mathtt{Functor.LaxMonoidal.comp}\), the full pushforward
  \[
    \mathtt{pushforward}\,\varphi
      \;\;:=\;\;
    \mathtt{pushforward}_0\,F\,R \;\circ\; \mathtt{restrictScalars}\,\varphi
  \]
  is lax monoidal. This lemma is a self-contained
  \(\mathtt{CommRingCat}\)-level lax-monoidal supplement: it stands on its own
  and is retained for potential reuse, but it is \emph{off the critical path}
  for the tensor group law. In particular it is \emph{not} an ingredient of
  \cref{lem:tensorobj_restrict_iso}, whose proof identifies restriction along an
  open immersion with base change along a structure-sheaf isomorphism and
  consequently needs no lax-monoidal structure on the pushforward.