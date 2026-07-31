---
author: sync
content_type: theorem
created: '2026-07-30T04:44:47'
decl: AlgebraicGeometry.exists_certifiedAff_divEq
docstring: '**Over a field, every widened locally certified system is divisor-equal
  to a globally

  certified widened family** — the widened `DivFam.exists_toZar_eq`

  (`Picard/DivSchemeAbel.lean:77`), stated at the level of systems rather than of
  classes.


  A span-`⊤` family over a field has a nonzero member, which is a unit, so

  `Localization.Away (g i)` is `K` itself (`IsLocalization.atUnits`); the local certified
  family

  base-changes back along that isomorphism, and the composite pullback collapses by

  `relCurveMap_id`.  Every step is about the base, so the widening is invisible here.


  **The `DivEq` conclusion is deliberate and is what makes this cheap.**  The class-level
  form

  `∃ G, G.toZarAff = F₀` would need `toZarAff (F.mapAlg R'' n hinf) = DivFamZarAff.mapAlg
  R'' n

  F.toZarAff`, which does not exist in the tree; the consumer

  (`AffAdaptation.deg_presentationDivisor_of_divEq`) wants a `DivEq` anyway, so the
  quotient

  level is never re-entered.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffClassDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_certifiedAff_divEq
type: lean
updated: '2026-07-31T20:15:23'
---
theorem exists_certifiedAff_divEq (d : (relCurve C K).LocalEquations)
    (hd : IsLocallyCertifiedAff n d) :
    ∃ G : CertifiedDivisorFamilyAff C K n, Scheme.LocalEquations.DivEq G.eqns d := by
  obtain ⟨m, g, hspan, hG⟩ := id hd
  -- some member of the span-⊤ family is nonzero
  have hex : ∃ i, g i ≠ 0 := by
    by_contra hall
    have hall' : ∀ i, g i = 0 := fun i => by
      by_contra hi
      exact hall ⟨i, hi⟩
    have hle : Ideal.span (Set.range g) ≤ ⊥ := Ideal.span_le.mpr (by
      rintro x ⟨i, rfl⟩
      rw [SetLike.mem_coe, Ideal.mem_bot]
      exact hall' i)
    rw [hspan, top_le_iff] at hle
    exact one_ne_zero (Ideal.mem_bot.mp (hle ▸ Submodule.mem_top (x := (1 : K))))
  obtain ⟨i, hgi⟩ := hex
  haveI : IsOpenImmersion (relCurveMap C K (Localization.Away (g i))) :=
    isOpenImmersion_relCurveMap_away C K (Localization.Away (g i)) (g i)
  obtain ⟨Gᵢ, hGdiv⟩ := hG i
  -- the away localization at a unit is `K` itself
  have hunits : Submonoid.powers (g i) ≤ IsUnit.submonoid K := by
    rintro x ⟨e, rfl⟩
    exact (isUnit_iff_ne_zero.mpr hgi).pow e
  haveI : IsLocalization (Submonoid.powers (g i)) K :=
    IsLocalization.of_le_isUnit hunits
  let e₀ : K ≃ₐ[K] Localization.Away (g i) :=
    IsLocalization.atUnits K (Submonoid.powers (g i)) hunits
  let e : Localization.Away (g i) ≃ₐ[k] K := e₀.symm.restrictScalars k
  letI : Algebra (Localization.Away (g i)) K := e.toAlgHom.toRingHom.toAlgebra
  haveI : IsScalarTower k (Localization.Away (g i)) K :=
    .of_algebraMap_eq fun a => (e.commutes a).symm
  have hKA : ∀ a : K, e (algebraMap K (Localization.Away (g i)) a) = a := by
    intro a
    change e₀.symm (algebraMap K (Localization.Away (g i)) a) = a
    rw [← e₀.commutes a]
    exact e₀.symm_apply_apply _
  haveI : IsScalarTower K (Localization.Away (g i)) K :=
    .of_algebraMap_eq fun a => (hKA a).symm
  -- base change the local family back to `K` and collapse the composite pullback
  refine ⟨Gᵢ.mapAlg K n Gᵢ.cover.hasAffineOverlaps_of_isProper, ?_⟩
  refine (CertifiedDivisorFamilyAff.divEq_mapAlg_pullback n K Gᵢ
    Gᵢ.cover.hasAffineOverlaps_of_isProper
    (hd.germ_pullbackEqn_mem_nonZeroDivisors K n) hGdiv).trans ?_
  exact Scheme.LocalEquations.divEq_pullback_id relCurveMap_id d _

/-! ## The widened class-degree law -/

set_option maxHeartbeats 1600000 in
/- The `Quotient.inductionOn` unfolds `DivFamZarAff.picClass` through the setoid; within the
DivSchemeAbel precedent for the chart-typed twin. -/