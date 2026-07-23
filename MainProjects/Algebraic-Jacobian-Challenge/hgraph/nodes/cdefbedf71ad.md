---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.toCoverEqLocus
docstring: The global-sections-to-compatible-families map corestricted to the `eqLocus`.
file: AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.toCoverEqLocus
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def toCoverEqLocus {X : Scheme.{u}} (M : X.Modules) {ι : Type u} (U : ι → X.Opens) :
    gammaModA M (⊤ : X.Opens) →ₗ[groundRing X] LinearMap.eqLocus (leftRes M U) (rightRes M U) :=
  (toCover M U).codRestrict _ (leftRes_toCover M U)