---
author: sync
content_type: definition
created: '2026-07-20T16:31:23'
decl: AlgebraicGeometry.universalMulMap
docstring: The sum of all multiplier-basis translates of the first universal window.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivMulSpan.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.universalMulMap
type: lean
updated: '2026-07-29T15:31:42'
---
noncomputable def universalMulMap :
    universalMulSource (hπ := hπ) g r₁ r₂ b₁ b₂ i j →ₗ[RZ]
    RZ ⊗[k] HMS :=
  ∑ t : Fin (Module.finrank k HS),
    (LinearMap.baseChange RZ (windowShiftMul hπ g ((Module.finBasis k HS) t))).comp
      ((divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule.subtype.comp
        (LinearMap.proj t))