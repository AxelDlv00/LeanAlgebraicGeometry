---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:isoSpec_scheme_mathlib
lean_status: mathlib_ok
mathlib_name:
- AlgebraicGeometry.Scheme.isoSpec
order: 415
title: The canonical isomorphism of an affine scheme with its spectrum
type: tex
updated: '2026-07-24T11:03:43'
---
\textit{Provided by Mathlib.}
  Let \(U\) be a scheme with \([\,\mathrm{IsAffine}\ U\,]\). Then there is a canonical
  \emph{whole-scheme} isomorphism of schemes
  \[
    U \;\cong\; \operatorname{Spec}\Gamma(U, \mathcal{O}_U),
  \]
  identifying \(U\) with the spectrum of its ring of global sections. This is a genuine isomorphism of
  schemes (not merely an open immersion), so it induces an equivalence of module categories.