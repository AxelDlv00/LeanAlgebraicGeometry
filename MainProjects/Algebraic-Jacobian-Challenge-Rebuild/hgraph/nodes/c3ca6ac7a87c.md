---
author: sync
content_type: structure
created: '2026-07-24T17:02:47'
decl: morphism;
file: AlgebraicJacobian/Picard/GrassmannianSeparated.lean
generated: lean
lean_status: lean_ok
title: morphism;
type: lean
updated: '2026-07-24T17:02:47'
---
  structure morphism; `isSeparated_grScheme`: the glued scheme is separated.
* `AlgebraicGeometry.Grassmannian.chartRingAlgHomEquiv`: `(R^I →ₐ[k] S) ≃` free-entry
  matrix data valued in `S`.
-/

set_option autoImplicit false

universe u

open AlgebraicGeometry CategoryTheory TensorProduct

namespace AlgebraicGeometry.Grassmannian

set_option maxHeartbeats 3200000 in
-- The patch computation traverses the `pullbackDiagonalMapIdIso` / `pullbackSpecIso`
-- instance diamonds over the heavy localised chart rings (defeq-expensive `erw`s);
-- elaboration cost, not a kernel raise — the route map carries the same raise.
set_option backward.isDefEq.respectTransparency false in
open CategoryTheory.Limits in