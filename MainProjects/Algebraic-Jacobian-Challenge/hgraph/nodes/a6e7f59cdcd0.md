---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:isHomogeneousElem_graded_smul_mathlib
lean_status: mathlib_ok
mathlib_name:
- SetLike.IsHomogeneousElem.graded_smul
order: 1042
title: Multiplication by a homogeneous element shifts degree
type: tex
updated: '2026-07-28T02:46:11'
---
\textit{Provided by Mathlib (\texttt{Mathlib.Algebra.GradedMulAction}).}
  Let \(\mathcal{A}\) be a graded family acting on a graded family \(\mathcal{M}\)
  via a graded scalar multiplication. If \(a \in R\) is homogeneous of degree
  \(i\) -- in particular \(x \in R_1\) -- then for \(m \in M_n\) one has
  \(a \cdot m \in M_{i+n}\). This is the degree-shifting property that makes \(xM\)
  a homogeneous submodule (with degree-\((n+1)\) part \(x \cdot M_n\)) and that
  underlies the ambient identity \(x \cdot N \cap M_{n+1} = x \cdot (N \cap M_n)\)
  used in the subquotient closure (\cref{lem:graded_subquotient_ker_coker}) and
  difference identity (\cref{lem:graded_subquotient_degreewise_diff}).