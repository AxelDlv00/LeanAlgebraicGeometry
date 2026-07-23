---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.serreTwistGlued
docstring: The Serre twist `O(m)` on the glued total space of the basic-open cover.
file: AlgebraicJacobian/Picard/SerreTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.serreTwistGlued
type: lean
updated: '2026-07-16T21:14:28'
---
def serreTwistGlued (m : ℕ) : (glueData n₀).glued.Modules :=
  Scheme.Modules.glue (glueData n₀)
    (fun i => SheafOfModules.unit ((glueData n₀).U i).ringCatSheaf)
    (fun i j => twistTransition n₀ m i j)
    (fun i => twistTransition_self n₀ m i)
    (fun i j k => twistTransition_cocycle n₀ m i j k)