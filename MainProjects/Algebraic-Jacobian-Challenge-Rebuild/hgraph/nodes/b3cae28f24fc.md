---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.divFamZarAffSetoid
docstring: The divisor-equality setoid on widened locally-certified systems.
file: AlgebraicJacobian/Picard/DivisorFamilyAffZar.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divFamZarAffSetoid
type: lean
updated: '2026-07-29T15:26:31'
---
def divFamZarAffSetoid : Setoid {d : (relCurve C R).LocalEquations //
    IsLocallyCertifiedAff n d} where
  r d₁ d₂ := Scheme.LocalEquations.DivEq d₁.1 d₂.1
  iseqv :=
    ⟨fun d => Scheme.LocalEquations.divEq_refl d.1,
     fun h => h.symm, fun h h' => h.trans h'⟩