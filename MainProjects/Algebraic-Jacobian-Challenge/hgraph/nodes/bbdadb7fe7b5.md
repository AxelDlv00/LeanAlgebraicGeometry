---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:directSum_gmodule_mathlib
lean_status: mathlib_ok
mathlib_name:
- DirectSum.Gmodule
order: 1338
title: External-direct-sum graded module
type: tex
updated: '2026-07-28T14:04:00'
---
\textit{Provided by Mathlib (\texttt{Mathlib.Algebra.Module.GradedModule}).}
  Let \(A : \mathbb{N} \to \mathrm{Type}\) carry a graded semiring structure as
  in \cref{lem:directSum_gsemiring_mathlib} and let
  \(M : \mathbb{N} \to \mathrm{Type}\) be a family of additive commutative
  monoids with a graded scalar action \(A_i \times M_j \to M_{i+j}\) satisfying
  the graded module axioms (the data of a \(\mathrm{Gmodule}\) of \(M\) over
  \(A\)). Then the external direct sum \(\bigoplus_j M_j\) is a module over the
  semiring \(\bigoplus_i A_i\), with scalar multiplication the bilinear
  extension of the graded action.