---
author: sync
content_type: lemma
created: '2026-07-28T12:23:40'
decl: AlgebraicGeometry.Scheme.RationalMap.pair_mem_diffPairingRep_domain
docstring: 'The pair of two `Dom f`-valued morphisms lands pointwise in the domain
  of

  the explicit pairing representative `diffPairingRep`.'
file: AlgebraicJacobian/Albanese/Milne33Diagonal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.RationalMap.pair_mem_diffPairingRep_domain
type: lean
updated: '2026-07-28T12:23:40'
---
lemma pair_mem_diffPairingRep_domain
    {T : Scheme.{u}} (aD bD : T ⟶ ↑f.toPartialMap.domain)
    (w : (aD ≫ f.toPartialMap.domain.ι) ≫ X.hom
      = (bD ≫ f.toPartialMap.domain.ι) ≫ X.hom)
    (t : ↥T) :
    (pullback.lift (aD ≫ f.toPartialMap.domain.ι) (bD ≫ f.toPartialMap.domain.ι)
      w).base t ∈ (diffPairingRep f hover).domain := by
  rw [diffPairingRep_domain, TopologicalSpace.Opens.mem_inf]
  constructor
  · have h1 : (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.fst X.hom X.hom).base t
        = (aD ≫ f.toPartialMap.domain.ι).base t := by
      rw [pullback.lift_fst]
    change (pullback.lift _ _ w).base t
      ∈ (f.toPartialMap.precomp (pullback.fst X.hom X.hom)
        (isOpenMap_pullback_fst_self X)).domain
    rw [Scheme.PartialMap.precomp_domain]
    change (pullback.fst X.hom X.hom).base ((pullback.lift _ _ w).base t)
      ∈ f.toPartialMap.domain
    rw [show (pullback.fst X.hom X.hom).base ((pullback.lift
        (aD ≫ f.toPartialMap.domain.ι) (bD ≫ f.toPartialMap.domain.ι) w).base t)
      = (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.fst X.hom X.hom).base t
      from rfl, h1]
    exact (aD.base t).2
  · have h2 : (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.snd X.hom X.hom).base t
        = (bD ≫ f.toPartialMap.domain.ι).base t := by
      rw [pullback.lift_snd]
    change (pullback.lift _ _ w).base t
      ∈ (f.toPartialMap.precomp (pullback.snd X.hom X.hom)
        (isOpenMap_pullback_snd_self X)).domain
    rw [Scheme.PartialMap.precomp_domain]
    change (pullback.snd X.hom X.hom).base ((pullback.lift _ _ w).base t)
      ∈ f.toPartialMap.domain
    rw [show (pullback.snd X.hom X.hom).base ((pullback.lift
        (aD ≫ f.toPartialMap.domain.ι) (bD ≫ f.toPartialMap.domain.ι) w).base t)
      = (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.snd X.hom X.hom).base t
      from rfl, h2]
    exact (bD.base t).2