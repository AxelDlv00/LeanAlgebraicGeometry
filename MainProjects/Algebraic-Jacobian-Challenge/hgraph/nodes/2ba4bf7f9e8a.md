---
author: sync
content_type: definition
created: '2026-07-31T04:59:31'
decl: AlgebraicJacobian.GaloisDescent.baseTwist
file: ProbePicFKernel.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicJacobian.GaloisDescent.baseTwist
type: lean
updated: '2026-07-31T06:25:56'
---
noncomputable def baseTwist (gamma : L ≃ₐ[K] L) :
    pullback t (fieldBaseMap K L) ⟶ pullback t (fieldBaseMap K L) :=
  pullback.lift (pullback.fst _ _)
    (pullback.snd _ _ ≫ AlgebraicGeometry.Scheme.PicScheme.specGal gamma) (by
      rw [Category.assoc, AlgebraicGeometry.Scheme.PicScheme.specGal_comp]
      exact pullback.condition)

@[simp, reassoc]