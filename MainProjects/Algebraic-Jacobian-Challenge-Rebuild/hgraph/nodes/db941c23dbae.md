---
author: sync
content_type: theorem
created: '2026-07-20T17:01:58'
decl: AlgebraicGeometry.divUniversalSndWindow_toSubmodule_eq_span
docstring: 'The second universal window in the transported `H_{M+s}` ambient is

  the span of the compared tautological second-kernel generators.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivSndRes.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divUniversalSndWindow_toSubmodule_eq_span
type: lean
updated: '2026-07-29T15:26:35'
---
theorem divUniversalSndWindow_toSubmodule_eq_span :
    (divUniversalSndWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule
      = Submodule.span RZ
          ((fun n =>
              LinearMap.baseChange RZ
                (b₂.equivFun.symm.trans (seedWindowShiftEquiv C π hπ g)).toLinearMap
                (windowCompare (PairChartRing k g r₁ g r₂ i j) RZ n)) ''
            ((pairTautSnd k g r₁ r₂ i j).toSubmodule :
              Set (TensorProduct k (PairChartRing k g r₁ g r₂ i j) (Fin r₂ → k)))) := by
  have h0 : (divUniversalSndWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule
      = Submodule.map
          (LinearMap.baseChange RZ
            (b₂.equivFun.symm.trans (seedWindowShiftEquiv C π hπ g)).toLinearMap)
          (divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule :=
    congrAmbient_toSubmodule
      (b₂.equivFun.symm.trans (seedWindowShiftEquiv C π hπ g))
      (divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
  rw [h0, divUniversalSnd_toSubmodule_eq_span_aux
      (C := C) (π := π) hπ g r₁ r₂ b₁ b₂ i j,
    Submodule.map_span, ← Set.image_comp]
  rfl