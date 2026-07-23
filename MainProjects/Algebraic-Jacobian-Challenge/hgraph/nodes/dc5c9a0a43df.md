---
author: sync
content_type: instance
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.opensMapHomBase_isEquivalence
docstring: '`Opens.map φ.hom.base` is an equivalence (twin of `opensMapInvBase_isEquivalence`).'
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.opensMapHomBase_isEquivalence
type: lean
updated: '2026-07-16T21:14:26'
---
instance opensMapHomBase_isEquivalence : (Opens.map φ.hom.base).IsEquivalence :=
  inferInstanceAs (Opens.mapMapIso (Scheme.forgetToTop.mapIso φ)).functor.IsEquivalence