---
author: sync
chapter: The Quot scheme
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:graded_raisesDegree
lean_status: lean_ok
order: 1048
title: Degree-raising endomorphism
type: tex
updated: '2026-07-27T20:11:16'
---
Let \(M = \bigoplus_n \mathcal{M}_n\) be an internally graded \(\kappa\)-module. A
  \(\kappa\)-linear endomorphism \(x : M \to M\) \emph{raises degree by one} when it
  carries each graded piece into the next: \(x(\mathcal{M}_n) \subseteq
  \mathcal{M}_{n+1}\) for every \(n\). This is the grading-ring-free form of
  ``multiplication by a degree-one element'': it abstracts each of the \(r\)
  commuting degree-one generators \(x \in R_1\) acting on \(M\) into a single
  endomorphism, with no reference to the grading ring \(R\).