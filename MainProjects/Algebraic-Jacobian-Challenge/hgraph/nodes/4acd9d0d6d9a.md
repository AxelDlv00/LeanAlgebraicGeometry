---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueData_bridge_src
docstring: 'Triple-overlap bridge (source): on `V_ijk = V_ij ×_{U_i} V_ik` the two
  projections to

  `V_ij` and `V_ik` followed by the overlap immersions `f_ij`, `f_ik` agree as morphisms
  to

  `U_i`. This is the pullback condition; it identifies the sources of the `ij`- and

  `ik`-transports. Project-local helper for the module cocycle (C2).'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueData_bridge_src
type: lean
updated: '2026-07-16T21:14:27'
---
theorem glueData_bridge_src (D : Scheme.GlueData.{u}) (i j k : D.J) :
    pullback.fst (D.f i j) (D.f i k) ≫ D.f i j
      = pullback.snd (D.f i j) (D.f i k) ≫ D.f i k := pullback.condition