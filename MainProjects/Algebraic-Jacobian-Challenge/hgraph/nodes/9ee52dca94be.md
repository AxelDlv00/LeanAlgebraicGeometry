---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.W_tripWhisker
docstring: The whiskered triple row is a local isomorphism.
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.W_tripWhisker
type: lean
updated: '2026-07-24T03:02:12'
---
private lemma W_tripWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (hf : (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map f))
    (R : X.PresheafOfModules) :
    (opensTopology X).W (tripWhisker f R) := by
  have h1 : (opensTopology X).W
      (MonoidalCategory.whiskerRight (uModHom f)
        (MonoidalCategory.tensorObj (uModRingPresheaf X) (uModPresheaf R))) :=
    (W_uModHom f hf).whiskerRight _
  have h2 := (W_whiskerRight_modToAb_iff (opensTopology X) _).mpr h1
  refine (((opensTopology X).W).arrow_mk_iso_iff
    (Arrow.isoMk (uTripIso P R) (uTripIso Q R) ?_)).mp h2
  show (uTripIso P R).hom ≫ tripWhisker f R
    = Functor.whiskerRight
        (MonoidalCategory.whiskerRight (uModHom f)
          (MonoidalCategory.tensorObj (uModRingPresheaf X) (uModPresheaf R))) modToAb.{u} ≫
      (uTripIso Q R).hom
  exact (uTripIso P R).hom_inv_id_assoc _