---
author: sync
chapter: FGA representability of the Picard scheme
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:has_div_functor
lean_status: empty
order: 1531
title: Existence carrier for the relative-divisor functor
type: tex
updated: '2026-07-24T03:02:15'
---
The predicate \(\mathrm{HasDivFunctor}(C)\) asserts that the category of presheaves
  of types on \((\Sch/k)^{op}\) admits at least one object intended to be the
  relative-effective-divisor functor \(\mathrm{Div}_{C/k}\), sending a
  \(k\)-scheme \(T\) to the set of relative effective Cartier divisors on
  \(C \times_k T\) flat over \(T\). It is the existence carrier for
  \(\mathrm{Div}_{C/k}\); since the A.2.b divisor functor
  (\cref{def:div_functor}) landed, its instance
  \cref{def:inst_has_div_functor} is proved and the class survives only as
  the pinned carrier.