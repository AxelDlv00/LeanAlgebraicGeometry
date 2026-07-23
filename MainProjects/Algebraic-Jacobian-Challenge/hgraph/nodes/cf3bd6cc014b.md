---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:ext_covariant_les_mathlib
lean_status: mathlib_ok
mathlib_name:
- CategoryTheory.Abelian.Ext.covariantSequence_exact
- CategoryTheory.Abelian.Ext.covariant_sequence_exact₁
- CategoryTheory.Abelian.Ext.covariant_sequence_exact₂
- CategoryTheory.Abelian.Ext.covariant_sequence_exact₃
order: 219
title: Covariant Ext long exact sequence of a short exact sequence
type: tex
updated: '2026-07-24T03:02:14'
---
\textit{Provided by Mathlib
  (\texttt{Mathlib.Algebra.Homology.DerivedCategory.Ext.ExactSequences}).}
  Let \(C\) be an abelian category with \(\mathrm{HasExt}\), let \(0 \to S_1 \to S_2 \to
  S_3 \to 0\) be a short exact sequence in \(C\), and fix a first argument \(X \in C\).
  Then the groups \(\operatorname{Ext}^n(X, S_i)\) assemble into a long exact sequence,
  with connecting homomorphism \(\operatorname{Ext}^{n_0}(X, S_3) \to
  \operatorname{Ext}^{n_1}(X, S_1)\) (for \(n_0 + 1 = n_1\)) given by composition with
  the Ext class of the extension. Mathlib packages the exactness both as the
  five-term \(\operatorname{ComposableArrows}\) exactness
  \(\operatorname{covariantSequence\_exact}\) and as the three step-lemmas
  three individual step-exactness lemmas.