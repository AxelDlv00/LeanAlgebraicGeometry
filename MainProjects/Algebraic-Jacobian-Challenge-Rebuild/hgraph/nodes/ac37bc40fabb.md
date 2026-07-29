---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.CurveDivisor.deg_sub'
docstring: 'Degree of a difference: `deg (A − B) = deg A − deg B` (public form of
  the

  `WindowLedger` helper).'
file: AlgebraicJacobian/RiemannRoch/SectionSpaces.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.CurveDivisor.deg_sub'
type: lean
updated: '2026-07-29T15:26:31'
---
lemma Scheme.CurveDivisor.deg_sub' (A B : X.CurveDivisor) :
    CurveDivisor.deg K (A - B) = CurveDivisor.deg K A - CurveDivisor.deg K B := by
  rw [sub_eq_add_neg, CurveDivisor.deg_add, CurveDivisor.deg_neg, sub_eq_add_neg]