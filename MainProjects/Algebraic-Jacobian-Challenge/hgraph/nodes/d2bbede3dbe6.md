---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:over_mkIdTerminal_mathlib
lean_status: mathlib_ok
mathlib_name:
- CategoryTheory.Over.mkIdTerminal
order: 400
title: The identity arrow is terminal in the slice category
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Provided by Mathlib.}
  For an object \(S\) of a category, \(\operatorname{Over.mk}(\mathrm{id}_S)\) is a terminal object
  of the slice category \(\operatorname{Over} S\). This is what makes the base of a wide pullback
  over \(S\) terminal in the slice, so that
  Lemma~\ref{lem:widePullbackCone_isLimitOfFan_mathlib} exhibits the fibre power over \(S\) as the
  product in \(\operatorname{Over} S\) in Lemma~\ref{lem:widePullback_overX_eq_prod}.