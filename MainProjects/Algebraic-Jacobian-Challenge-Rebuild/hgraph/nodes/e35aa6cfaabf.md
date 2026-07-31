---
author: sync
content_type: definition
created: '2026-07-19T10:31:16'
decl: AlgebraicGeometry.divUniversalSndWindowEquiv
docstring: Mirror of `divUniversalFstWindowEquiv` for the second window point.
file: AlgebraicJacobian/Picard/DivSchemeSeedUniv.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divUniversalSndWindowEquiv
type: lean
updated: '2026-07-31T20:14:51'
---
noncomputable def divUniversalSndWindowEquiv :
    ↥(divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule ≃ₗ[
      DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j]
      ↥(divUniversalSndWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule :=
  LinearEquiv.ofSubmodules
    (LinearEquiv.baseChange k
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      _ _ (b₂.equivFun.symm.trans (seedWindowShiftEquiv C π hπ g))) _ _ rfl