---
author: sync
content_type: theorem
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.subsingleton_hModule'_twistSheaf_one₁
docstring: '**Twisted affine vanishing on the second chart.**'
file: AlgebraicJacobian/Cohomology/TwistedSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.subsingleton_hModule'_twistSheaf_one₁
type: lean
updated: '2026-07-29T15:31:36'
---
theorem subsingleton_hModule'_twistSheaf_one₁ (h₁ : IsAffineOpen V₁) :
    Subsingleton (Sheaf.HModule' (twistSheaf k V₀ V₁ g) V₁ 1) :=
  h₁.subsingleton_hModule'_one_of_qcoh (twistSheaf k V₀ V₁ g)