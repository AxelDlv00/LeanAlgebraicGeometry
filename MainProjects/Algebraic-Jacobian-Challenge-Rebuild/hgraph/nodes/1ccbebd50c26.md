---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.unitsPresheaf
docstring: 'The units presheaf `𝒪_X^*` of a scheme `X`, on its small Zariski site:
  the composite

  of the structure presheaf with the units functor, valued in commutative groups.


  This is `abbrev` (reducible): the Čech layer constantly mixes sections typed through

  `unitsPresheaf.obj` with sections typed `Γ(X, U)ˣ`, and rewriting across that boundary

  requires the two to agree at instance transparency.'
file: AlgebraicJacobian/Picard/UnitsPresheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.unitsPresheaf
type: lean
updated: '2026-07-16T21:33:28'
---
abbrev unitsPresheaf (X : Scheme.{u}) : (X.Opens)ᵒᵖ ⥤ CommGrpCat.{u} :=
  X.presheaf ⋙ forget₂ CommRingCat CommMonCat ⋙ CommMonCat.units