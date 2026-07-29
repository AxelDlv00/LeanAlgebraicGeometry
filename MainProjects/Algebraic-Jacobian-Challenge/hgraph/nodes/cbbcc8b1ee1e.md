---
author: sync
chapter: FGA representability of the Picard scheme
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:has_div_functor
lean_status: linked
order: 1570
title: Vacuous carrier, not the existence of \(\Div_{C/k}\)
type: tex
updated: '2026-07-29T20:27:14'
---
The predicate \(\mathrm{HasDivFunctor}(C)\) asserts only that the category of
  presheaves of types on \((\Sch/k)^{op}\) is \emph{nonempty}. The curve \(C\)
  does not occur in the assertion, so it is vacuously true --- a constant functor
  witnesses it --- and it must never be cited as the existence of
  \(\Div_{C/k}\). Use \cref{def:div_functor_carrier} for that; it is a genuine
  definition instantiating \cref{def:div_functor} at \(C \to \Spec k\).