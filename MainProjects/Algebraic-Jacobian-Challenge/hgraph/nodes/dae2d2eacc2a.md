---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:graded_polyQuot_finite_of_le_numerator
lean_status: lean_ok
order: 1086
title: Shrinking the numerator preserves finiteness
type: tex
updated: '2026-07-28T04:57:37'
---
Let \(N_1 \le N_2\) and \(P'\) be \(\kappa\)-submodules of \(M\), each stable under
  the commuting family \(t_0, \dots, t_{r-1}\), and suppose the subquotient
  \(N_2/P'\) is finite over \(\kappa[t_0, \dots, t_{r-1}]\)
  (\cref{def:graded_polyModule}, \cref{def:graded_polySubmodule}). Then \(N_1/P'\) is
  also finite over \(\kappa[t_0, \dots, t_{r-1}]\). Indeed the inclusion
  \(N_1 \subseteq N_2\) induces an injective \(\kappa[t_0, \dots, t_{r-1}]\)-linear
  map \(N_1/P' \hookrightarrow N_2/P'\); since
  \(\kappa[t_0, \dots, t_{r-1}]\) is Noetherian
  (\cref{lem:mvPolynomial_isNoetherianRing_fin_mathlib}), the finite module
  \(N_2/P'\) is Noetherian
  (\cref{lem:isNoetherian_of_isNoetherianRing_of_finite_mathlib}), so its submodule
  \(N_1/P'\) is finite (\cref{lem:module_finite_of_injective_mathlib}). This supplies
  the finiteness witness of the kernel constructor
  (\cref{def:graded_subquotientDatum_ker}).