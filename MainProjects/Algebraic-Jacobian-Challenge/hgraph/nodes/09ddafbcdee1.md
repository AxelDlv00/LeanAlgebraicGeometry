---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.resSecHom
docstring: The base-restriction morphism `Over.mk (b ≫ a) ⟶ Over.mk a` in `Over S`.
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.resSecHom
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def resSecHom {V T : Scheme.{0}} (b : V ⟶ T) (a : T ⟶ S) :
    Over.mk (b ≫ a) ⟶ Over.mk a :=
  Over.homMk b rfl

set_option backward.isDefEq.respectTransparency false in