---
author: sync
chapter: Acyclic resolutions compute right-derived functors
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:right_derived_injective_resolution
lean_status: mathlib_ok
mathlib_name:
- CategoryTheory.InjectiveResolution.isoRightDerivedObj
order: 147
title: Right-derived functor via an injective resolution
type: tex
updated: '2026-07-24T03:02:13'
---
\textit{Provided by Mathlib.}
  Let \(\mathcal{A}\) be an abelian category with enough injectives,
  \(\mathcal{B}\) abelian, and \(G : \mathcal{A} \to \mathcal{B}\) additive. For an
  object \(X\) of \(\mathcal{A}\), a choice of injective resolution
  \(I\) of \(X\) (an exact complex \(0 \to X \to I^0 \to I^1 \to \cdots\) with each
  \(I^n\) injective), and every \(n \in \mathbb{N}\), there is a canonical
  isomorphism in \(\mathcal{B}\)
  \[
    (R^n G)(X)
      \;\cong\;
      H^n\bigl(G(I^\bullet)\bigr),
  \]
  where \(G(I^\bullet)\) is the cochain complex obtained by applying \(G\)
  degreewise to the resolution complex \(I^\bullet\) and \(H^n\) is its \(n\)-th
  cohomology object. This is the defining computation of the right-derived functor
  and the seed from which the acyclic-resolution generalization is bootstrapped.