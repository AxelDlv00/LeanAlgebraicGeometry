---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.TrivializingFamily.cocycle
docstring: 'The unit Čech cocycle of a trivializing family on its pointed cover: the
  value on

  `T ≤ D(sec x) ⊓ D(sec y)` is the restriction of the transition unit.'
file: AlgebraicJacobian/Picard/CechPicSurjective.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.TrivializingFamily.cocycle
type: lean
updated: '2026-07-16T21:33:28'
---
noncomputable def cocycle : X.unitsCocycle F.cover where
  ev x y _ a b :=
    X.unitsRestrict ((le_inf a.le b.le).trans (X.basicOpen_mul (F.sec x) (F.sec y)).ge)
      (F.transition x y)
  ev_precomp _ _ _ _ _ _ _ := unitsRestrict_unitsRestrict _ _ _
  ev_trans x y z _ a b c :=
    F.transition_mul x y z
      ((le_inf a.le b.le).trans (X.basicOpen_mul (F.sec x) (F.sec y)).ge)
      ((le_inf b.le c.le).trans (X.basicOpen_mul (F.sec y) (F.sec z)).ge)
      ((le_inf a.le c.le).trans (X.basicOpen_mul (F.sec x) (F.sec z)).ge)