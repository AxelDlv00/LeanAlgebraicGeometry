---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorObjWhiskerLeftIso_refl
docstring: Reflexivity of the hand-built left-whiskering.  Route (b), via the canonical
  bridge.
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.tensorObjWhiskerLeftIso_refl
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma tensorObjWhiskerLeftIso_refl (F G : X.Modules) :
    tensorObjWhiskerLeftIso F (Iso.refl G) = Iso.refl _ := by
  rw [tensorObjWhiskerLeftIso_eq]; apply Iso.ext; simp