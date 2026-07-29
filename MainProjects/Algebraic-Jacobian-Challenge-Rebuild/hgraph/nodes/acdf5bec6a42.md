---
author: sync
content_type: theorem
created: '2026-07-29T05:13:20'
decl: AlgebraicGeometry.ThetaGeneratorSeed.isLocallyCertifiedAff_of_forall_prime_certified_adaptation
docstring: '**The seed-level per-prime widened gate.**  At every prime of the base
  it suffices to

  produce an away localization carrying a certified WIDENED adaptation of the pulled
  seed system.


  Contrast the gate above: this form is the one to use when the degree datum only
  becomes

  available after shrinking the base, which is the situation the support tube produces.  What
  it

  does not do is discharge the away-base fibre transport — that is the hypothesis.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffSeedGate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.isLocallyCertifiedAff_of_forall_prime_certified_adaptation
type: lean
updated: '2026-07-29T15:31:44'
---
theorem isLocallyCertifiedAff_of_forall_prime_certified_adaptation [IsNoetherianRing R] {n : ℕ}
    (hD : D.IsGenerator)
    (h : ∀ p : PrimeSpectrum R, ∃ r, r ∉ p.asIdeal ∧
      haveI : IsOpenImmersion (relCurveMap C R (Localization.Away r)) :=
        isOpenImmersion_relCurveMap_away C R (Localization.Away r) r
      ∃ (Dr : AffCoverData C (Localization.Away r))
        (A : AffAdaptation Dr
          ((D.localEquations hD).pullback (relCurveMap C R (Localization.Away r))
            (Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
              (relCurveMap C R (Localization.Away r)) (D.localEquations hD)))),
        A.IsCertified n) :
    IsLocallyCertifiedAff n (D.localEquations hD) :=
  -- The `_root_` qualification is load-bearing: inside `namespace ThetaGeneratorSeed` the short
  -- name resolves to THIS declaration, so the general assembler must be named in full.
  _root_.AlgebraicGeometry.isLocallyCertifiedAff_of_forall_prime_certified_adaptation
    (n := n) h