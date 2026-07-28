---
author: sync
content_type: theorem
created: '2026-07-29T07:30:33'
decl: AlgebraicGeometry.uniformBaseDivisor_zero_of_genus_eq_zero
docstring: '**`UniformBaseDivisor C 0` for a curve of genus zero** (★★).'
file: AlgebraicJacobian/RiemannRoch/Ledger/VanishingFieldDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.uniformBaseDivisor_zero_of_genus_eq_zero
type: lean
updated: '2026-07-29T07:30:33'
---
theorem uniformBaseDivisor_zero_of_genus_eq_zero (hg : genus C = 0) :
    UniformBaseDivisor C 0 :=
  uniformBaseDivisor_zero_of_subsingleton C
    ((subsingleton_hModule_one_iff_genus_eq_zero C).mpr hg)