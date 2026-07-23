---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GradedModule.ker_le
docstring: 'The kernel subquotient nests: `N'' ≤ N ⊓ x⁻¹N''`, using `N'' ≤ N` and
  that `x` preserves

  `N''`. Project-local.'
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GradedModule.ker_le
type: lean
updated: '2026-07-16T21:14:27'
---
lemma ker_le {x : M →ₗ[κ] M} {N N' : Submodule κ M} (hle : N' ≤ N)
    (hpresN' : N'.map x ≤ N') : N' ≤ N ⊓ N'.comap x :=
  le_inf hle (Submodule.map_le_iff_le_comap.mp hpresN')

omit [DirectSum.Decomposition ℳ] in