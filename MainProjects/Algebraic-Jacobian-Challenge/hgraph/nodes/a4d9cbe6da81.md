---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Hom.IsProjectiveWith.baseChangeLift
docstring: 'The comparison morphism from the base-changed total space into the

  base-changed projective space.'
file: AlgebraicJacobian/Picard/ProjectiveMorphism.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Hom.IsProjectiveWith.baseChangeLift
type: lean
updated: '2026-07-31T04:59:30'
---
private def baseChangeLift {S' : Scheme.{0}} (g : S' ⟶ S) {n : Type} [Finite n]
    (i : X ⟶ ℙ(n; S)) (hcomp : i ≫ (ℙ(n; S) ↘ S) = π) :
    pullback π g ⟶ ℙ(n; S') :=
  (ProjectiveSpace.isPullback_map n g).lift
    (pullback.fst π g ≫ i) (pullback.snd π g)
    (by rw [Category.assoc, hcomp, pullback.condition])