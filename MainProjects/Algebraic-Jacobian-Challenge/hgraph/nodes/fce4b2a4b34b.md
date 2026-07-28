---
author: sync
chapter: The Quot scheme
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:graded_polyModule
lean_status: lean_ok
order: 1091
title: Polynomial-ring module structure on $M$
type: tex
updated: '2026-07-28T22:30:28'
---
The \emph{polynomial-module structure} is the \(\kappa[t_0, \dots, t_{r-1}]\)-module
  structure on \(M\) obtained by restricting scalars along
  \(\mathrm{polyEndHom}(t)\) (\cref{def:graded_polyEndHom}): a polynomial \(p\) acts on
  \(m \in M\) by \(p \cdot m = \mathrm{polyEndHom}(t)(p)(m)\). This is the module over the
  free polynomial ring on which the ambient subquotient induction's finiteness condition
  is measured.