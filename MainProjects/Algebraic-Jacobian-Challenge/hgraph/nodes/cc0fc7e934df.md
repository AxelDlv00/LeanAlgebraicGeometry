---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.algebraMap_comp_liftToBaseOfMemRange
docstring: 'The defining property of `liftToBaseOfMemRange`: composing the corestriction
  back with the

  structure map `R ↪ K` recovers the original `φ`. Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.algebraMap_comp_liftToBaseOfMemRange
type: lean
updated: '2026-07-16T21:14:27'
---
private lemma algebraMap_comp_liftToBaseOfMemRange {A R K : Type*} [CommRing A] [CommRing R]
    [Field K] [Algebra R K] [IsFractionRing R K] (φ : A →+* K)
    (hmem : ∀ x, φ x ∈ (algebraMap R K).range) :
    (algebraMap R K).comp (liftToBaseOfMemRange φ hmem) = φ := by
  letI hinj : Function.Injective (algebraMap R K).rangeRestrict := fun a b h =>
    IsFractionRing.injective R K (by
      have hv := congrArg Subtype.val h
      rwa [RingHom.coe_rangeRestrict, RingHom.coe_rangeRestrict] at hv)
  set e := RingEquiv.ofBijective (algebraMap R K).rangeRestrict
    ⟨hinj, (algebraMap R K).rangeRestrict_surjective⟩ with he
  ext x
  change algebraMap R K (e.symm (φ.codRestrict (algebraMap R K).range hmem x)) = φ x
  have happ : (algebraMap R K).rangeRestrict (e.symm (φ.codRestrict (algebraMap R K).range hmem x))
      = φ.codRestrict (algebraMap R K).range hmem x := by
    rw [← RingEquiv.ofBijective_apply (algebraMap R K).rangeRestrict
      ⟨hinj, (algebraMap R K).rangeRestrict_surjective⟩, ← he, RingEquiv.apply_symm_apply]
  have hv := congrArg Subtype.val happ
  rwa [RingHom.coe_rangeRestrict] at hv