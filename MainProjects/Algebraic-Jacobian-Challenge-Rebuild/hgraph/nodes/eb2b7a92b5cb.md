---
author: sync
content_type: theorem
created: '2026-07-18T01:31:27'
decl: AlgebraicGeometry.baseChange_idIso_hom_app_left
docstring: 'The forward identity base-change iso on the frozen `Challenge` spelling
  has first

  projection `pullback.fst` along the trivial base map.'
file: AlgebraicJacobian/Picard/Pic0ThetaProjectionCoherence.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.baseChange_idIso_hom_app_left
type: lean
updated: '2026-07-31T20:15:27'
---
theorem baseChange_idIso_hom_app_left (k : Type u) [Field k] (C : Over (Spec (.of k))) :
    ((baseChange.idIso k).app C).hom.left
      = pullback.fst C.hom (Spec.map (CommRingCat.ofHom (algebraMap k k))) := by
  unfold baseChange.idIso
  exact pullbackId_transport_hom_app_left _ (by simp) _ C

open MonoidalCategory CartesianMonoidalCategory in