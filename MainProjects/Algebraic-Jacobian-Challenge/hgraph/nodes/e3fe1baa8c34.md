---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: DualNumber.unitsFst_map_mapRingHom
docstring: "Naturality of reduction mod `ε` on units: the square\n\n```\n(R[ε])ˣ →\
  \ (S[ε])ˣ\n   ↓          ↓\n   Rˣ    →    Sˣ\n```\n\ncommutes."
file: AlgebraicJacobian/Picard/DualNumberUnits.lean
generated: lean
lean_status: lean_ok
title: DualNumber.unitsFst_map_mapRingHom
type: lean
updated: '2026-07-16T21:14:26'
---
theorem unitsFst_map_mapRingHom (f : R →+* S) (u : (R[ε])ˣ) :
    unitsFst (Units.map (mapRingHom f).toMonoidHom u)
      = Units.map f.toMonoidHom (unitsFst u) :=
  Units.ext <| by simp