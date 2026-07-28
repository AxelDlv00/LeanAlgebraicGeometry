---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:islocallyinjective_whiskerleft_via_stalk
lean_status: lean_ok
order: 668
title: Unconditional left-whiskering of the localizer, via d.2
type: tex
updated: '2026-07-29T06:43:24'
---
Let \(R\), \(J\) be as above with \(J.\mathtt{WEqualsLocallyBijective}\,\mathtt{Ab}\),
  let \(F\) be an \emph{arbitrary} presheaf of \(R\)-modules, and let \(g : M \to N\)
  be a morphism whose underlying morphism lies in \(J.W\). Then the left-whiskered
  morphism \(F \triangleleft g = \mathrm{id}_F \otimes g\) is \(J\)-locally injective
  (indeed lies in \(J.W\)). No flatness and no local-triviality hypothesis on \(F\) is
  required. This discharges the open left-whiskering obligation
  \cref{lem:islocallyinjective_whisker_of_W} that the unconditional associator
  \cref{lem:tensorobj_assoc_iso} consumes.