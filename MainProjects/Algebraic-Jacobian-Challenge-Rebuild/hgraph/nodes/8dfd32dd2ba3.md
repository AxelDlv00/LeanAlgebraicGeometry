---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.divFamZarAff_of_forall_prime_certified_adaptation
docstring: '**The `DivFamZarAff` class of a system certified pointwise on the base.**  The
  endpoint

  of the widened certificate lane: this is what a DD-R consumer receives, and no hypothesis
  on

  `|P¹(k)|` appears anywhere in its production.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffAssemble.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divFamZarAff_of_forall_prime_certified_adaptation
type: lean
updated: '2026-07-31T20:14:47'
---
noncomputable def divFamZarAff_of_forall_prime_certified_adaptation
    {d : (relCurve C R).LocalEquations}
    (h : ∀ p : PrimeSpectrum R, ∃ r, r ∉ p.asIdeal ∧
      haveI : IsOpenImmersion (relCurveMap C R (Localization.Away r)) :=
        isOpenImmersion_relCurveMap_away C R (Localization.Away r) r
      ∃ (Dr : AffCoverData C (Localization.Away r))
        (A : AffAdaptation Dr
          (d.pullback (relCurveMap C R (Localization.Away r))
            (Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
              (relCurveMap C R (Localization.Away r)) d))),
        A.IsCertified n) :
    DivFamZarAff C R n :=
  DivFamZarAff.mk d (isLocallyCertifiedAff_of_forall_prime_certified_adaptation h)