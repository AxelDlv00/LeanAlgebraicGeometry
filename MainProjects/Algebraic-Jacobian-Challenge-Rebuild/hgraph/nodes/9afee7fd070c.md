---
author: sync
content_type: theorem
created: '2026-07-28T13:42:16'
decl: AlgebraicGeometry.JacobianData.isProper_and_smooth_of_abelSource
docstring: '**Proper and smooth over `k`**, given an Abel source (P1) and geometric

  reducedness (S1). Properness is P3 (`isProper_of_abelSource`: X1 + P2 + the

  local-finite-type certificate) and smoothness is S2 (`JacobianData.smooth`, i.e.

  mathlib''s group-scheme criterion).'
file: AlgebraicJacobian/AbelianVariety/JacobianAbelianVariety.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.JacobianData.isProper_and_smooth_of_abelSource
type: lean
updated: '2026-07-29T15:31:33'
---
theorem isProper_and_smooth_of_abelSource (a : AbelSourceData d)
    [GeometricallyReduced d.J.hom] :
    IsProper d.J.hom ∧ Smooth d.J.hom :=
  ⟨isProper_of_abelSource a, d.smooth⟩