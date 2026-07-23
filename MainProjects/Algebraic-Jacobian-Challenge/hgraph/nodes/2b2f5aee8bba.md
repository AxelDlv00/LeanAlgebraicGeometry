---
author: sync
chapter: Acyclic resolutions compute right-derived functors
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:homology_long_exact_sequence
lean_status: mathlib_ok
mathlib_name:
- CategoryTheory.ShortComplex.ShortExact.homology_exact₁
- CategoryTheory.ShortComplex.ShortExact.homology_exact₂
- CategoryTheory.ShortComplex.ShortExact.homology_exact₃
- CategoryTheory.ShortComplex.ShortExact.δ
order: 150
title: Long exact homology sequence of a short exact sequence of complexes
type: tex
updated: '2026-07-24T03:02:14'
---
\textit{Provided by Mathlib.}
  Let \(\mathcal{C}\) be an abelian category and let
  \[
    0 \longrightarrow S.X_1 \longrightarrow S.X_2 \longrightarrow S.X_3
      \longrightarrow 0
  \]
  be a short exact sequence of cochain complexes in \(\mathcal{C}\) --- that is, a
  short complex \(S = (S.X_1 \to S.X_2 \to S.X_3)\) of objects of the category of
  \(\mathbb{Z}\)-indexed cochain complexes \(\mathrm{HomologicalComplex}\,\mathcal{C}\)
  which is short exact (degreewise mono, epi and exact in the middle). Then for every
  degree \(n\) there is a connecting morphism
  \[
    \delta^n \;:\; H^n(S.X_3) \longrightarrow H^{n+1}(S.X_1)
  \]
  (the Mathlib map \texttt{ShortComplex.ShortExact.\(\delta\)}), and these assemble
  into a long exact sequence of homology objects in \(\mathcal{C}\)
  \[
    \cdots \longrightarrow H^n(S.X_2) \longrightarrow H^n(S.X_3)
      \xrightarrow{\ \delta^n\ } H^{n+1}(S.X_1)
      \longrightarrow H^{n+1}(S.X_2) \longrightarrow \cdots .
  \]
  This is the complex-level homology long exact sequence and its connecting
  homomorphism. The derived-functor long exact sequence used in the sequel is
  constructed from this complex-level result via a horseshoe lift; see
  Lemma~\ref{lem:acyclic_dimension_shift}.