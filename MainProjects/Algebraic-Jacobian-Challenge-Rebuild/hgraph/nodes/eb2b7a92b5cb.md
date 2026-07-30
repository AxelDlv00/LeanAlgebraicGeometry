---
author: sync
content_type: theorem
created: '2026-07-18T01:31:27'
decl: AlgebraicGeometry.baseChange_idIso_hom_app_left
docstring: 'The forward identity base-change iso on the frozen `Challenge` spelling
  has first

  projection `pullback.fst` along the trivial base map.'
file: AlgebraicJacobian/Picard/Pic0ThetaCocycleIdentity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.baseChange_idIso_hom_app_left
type: lean
updated: '2026-07-31T03:02:20'
---
theorem baseChange_idIso_hom_app_left (k : Type u) [Field k] (C : Over (Spec (.of k))) :
    ((baseChange.idIso k).hom.app C).left
      = pullback.fst C.hom (Spec.map (CommRingCat.ofHom (algebraMap k k))) := by
  unfold baseChange.idIso
  exact pullbackId_transport_hom_app_left _ (by simp) _ C

/-! ## The Leg-4 atom, `snd` leg

The K-1a Leg-4 atom is the scheme identity
`((baseChange.idIso k).app C).inv ▷ overSpec k B).left = (crossBaseAffineIso k k C B).inv`,
to be proved by `(Over.isPullback_left _ _).hom_ext` on the two projections.  The `snd` leg
is below, closed; the `fst` leg is the file's residue (see the STATUS block). -/

open MonoidalCategory CartesianMonoidalCategory in