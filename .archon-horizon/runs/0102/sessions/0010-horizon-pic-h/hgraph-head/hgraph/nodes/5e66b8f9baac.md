---
author: sync
chapter: Cohomology of sheaves of modules
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:MayerVietorisSquare
lean_status: mathlib_ok
mathlib_name:
- CategoryTheory.GrothendieckTopology.MayerVietorisSquare
order: 326
title: Mayer--Vietoris square
type: tex
updated: '2026-07-17T16:57:15'
---
\textit{Provided by Mathlib.}
  Let \((\mathcal C, J)\) be a small site. A Mayer--Vietoris square consists of four objects
  \(X_1, X_2, X_3, X_4\) of \(\mathcal C\) and morphisms \(f_{12} : X_1 \to X_2\),
  \(f_{13} : X_1 \to X_3\), \(f_{24} : X_2 \to X_4\), \(f_{34} : X_3 \to X_4\) such that the
  two composites \(X_1 \to X_2 \to X_4\) and \(X_1 \to X_3 \to X_4\) agree, \(f_{13}\) is a
  monomorphism, and, after applying the representable-presheaf-then-sheafification functor
  \(\mathcal C \to \mathrm{Sh}(\mathcal C, J; \mathrm{Set})\), the resulting square of
  sheaves of sets is a pushout square: the image of \(X_4\) is the pushout, over the image of
  \(X_1\), of the images of \(X_2\) and \(X_3\). The prototypical example is
  \(X_1 = U \cap V\), \(X_2 = U\), \(X_3 = V\), \(X_4 = U \cup V\) for two opens \(U, V\) of a
  topological space, with the evident inclusions.