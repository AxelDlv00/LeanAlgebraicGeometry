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
title: AlgebraicGeometry.Scheme.Hom.IsProjectiveWith.baseChangeLift
type: lean
updated: '2026-07-16T21:14:27'
---
private def baseChangeLift {S' : Scheme.{0}} (g : S' ⟶ S) {d : ℕ}
    (i : X ⟶ ℙ(Fin (d + 1); S)) (hcomp : i ≫ (ℙ(Fin (d + 1); S) ↘ S) = π) :
    pullback π g ⟶ ℙ(Fin (d + 1); S') :=
  (ProjectiveSpace.isPullback_map (Fin (d + 1)) g).lift
    (pullback.fst π g ≫ i) (pullback.snd π g)
    (by rw [Category.assoc, hcomp, pullback.condition])