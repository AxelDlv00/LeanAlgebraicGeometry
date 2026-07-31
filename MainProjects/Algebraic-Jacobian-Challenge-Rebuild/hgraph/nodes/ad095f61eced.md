---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: TruncExpCech.cechUnitsReduction
docstring: '**The reduction map of two-chart Čech `Ȟ¹`-of-units groups**

  `Ȟ¹ˣ(B[ε]) →* Ȟ¹ˣ(B)` induced by reduction mod `ε` — the Čech-cocycle incarnation
  of

  the restriction `Pic(C ×_k Spec k[ε]) → Pic(C)` along `ε ↦ 0`. Its kernel is computed

  by `truncExpCechKernelAddEquiv` below.'
file: AlgebraicJacobian/Tangent/TruncExpCech.lean
generated: lean
lean_status: lean_ok
title: TruncExpCech.cechUnitsReduction
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def cechUnitsReduction (ρ₁ : A₁ →+* B) (ρ₂ : A₂ →+* B) :
    ((B[ε])ˣ ⧸ cechCoboundaryUnits (mapRingHom ρ₁) (mapRingHom ρ₂)) →*
      Bˣ ⧸ cechCoboundaryUnits ρ₁ ρ₂ :=
  QuotientGroup.map _ _ (unitsFst (R := B))
    (cechCoboundaryUnits_le_comap_unitsFst ρ₁ ρ₂)