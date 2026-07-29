---
author: sync
content_type: theorem
created: '2026-07-18T01:31:27'
decl: AlgebraicGeometry.baseChange_idIso_hom_app_left
docstring: 'The forward identity base-change iso on the frozen `Challenge` spelling
  has first

  projection `pullback.fst` along the trivial base map.'
file: AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.baseChange_idIso_hom_app_left
type: lean
updated: '2026-07-29T18:21:29'
---
theorem baseChange_idIso_hom_app_left (k : Type u) [Field k] (C : Over (Spec (.of k))) :
    ((baseChange.idIso k).hom.app C).left
      = pullback.fst C.hom (Spec.map (CommRingCat.ofHom (algebraMap k k))) := by
  have hσ : Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 (Spec (.of k)) := by
    rw [Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id]
  simp only [baseChange.idIso, Iso.trans_hom, NatTrans.comp_app, Over.comp_left, eqToIso.hom,
    eqToHom_app, pullbackId_hom_app_left, Over.eqToHom_left]
  exact pullback_fst_congr_left C.hom hσ _

/-! ## The Leg-4 atom, `snd` leg

The K-1a Leg-4 atom is the scheme identity
`((baseChange.idIso k).app C).inv ▷ overSpec k B).left = (crossBaseAffineIso k k C B).inv`,
to be proved by `(Over.isPullback_left _ _).hom_ext` on the two projections.  The `snd` leg
is below, closed; the `fst` leg is the file's residue (see the STATUS block). -/

open MonoidalCategory CartesianMonoidalCategory in