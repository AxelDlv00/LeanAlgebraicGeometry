---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-17T21:42:07'
generated: blueprint
label: def:picEtCrossBase
lean_status: lean_ok
order: 1061
title: The componentwise lift of the base-field shuffle
type: tex
updated: '2026-07-17T21:42:07'
---
Let \(T\) be a test object of \(\Over(\Spec L)\).  The underlying schemes of \(T\)
  and \(\sigma_{!}T\) coincide, so their affine opens and section rings are literally
  shared, and by the scalar tower of
  Lemma~\ref{lem:isScalarTower_sections_map} each section ring \(\Gamma(T, U)\) is a
  legal test algebra for the base-field shuffle.  Applying the shuffle
  \(\mathrm{Sh}_{\Gamma(T,U)}\) of Definition~\ref{def:PicEtAff_baseFieldShuffle}
  componentwise to a compatible family defines a group isomorphism
  \[
    \mathrm{picEt}(C, \sigma_{!}T) \;\cong\; \mathrm{picEt}(C_L, T),
  \]
  the \emph{componentwise lift} of the shuffle.