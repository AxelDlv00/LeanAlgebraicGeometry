---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:functor_is_representable_mathlib
lean_status: mathlib_ok
mathlib_name:
- CategoryTheory.Functor.IsRepresentable
order: 1162
title: Representability predicate
type: tex
updated: '2026-07-27T15:49:57'
---
\textit{Provided by Mathlib.}
  Let \(\mathcal{C}\) be a category and \(F : \mathcal{C}^{op} \to \mathbf{Set}\)
  a presheaf of sets. The predicate \(F.\mathrm{IsRepresentable}\) asserts that
  \(F\) is representable, i.e.\ that there exists an object \(Y\) of
  \(\mathcal{C}\) together with a natural bijection
  \(\mathrm{Hom}_{\mathcal{C}}(-, Y) \cong F\) (the Yoneda bijection).