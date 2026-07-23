---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.opensEquivOfIso
docstring: 'The opens-equivalence `Opens X ≌ Opens Y` induced by the scheme iso `φ`.  Built
  from

  `mapMapIso` so that its `functor` is (defeq) `Opens.map φ.inv.base` and its `inverse`
  is (defeq)

  `Opens.map φ.hom.base` — both honest `Opens.map`s, with known continuity.'
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.opensEquivOfIso
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def opensEquivOfIso : TopologicalSpace.Opens X ≌ TopologicalSpace.Opens Y :=
  Opens.mapMapIso (Scheme.forgetToTop.mapIso φ).symm