---
author: sync
content_type: theorem
created: '2026-07-25T15:32:34'
decl: AlgebraicGeometry.exists_away_supportLocus_subset_of_fibre_subset
docstring: '**The tube-fibre reduction.** If at a base prime `p` the support fibre
  of the system

  lies inside an open `U`, then some `r ∉ p` has the entire support over `D(r)` inside
  `U`.


  Stated so that the remaining certificate obligation is *purely fibrewise*: check
  one fibre,

  get a Zariski chart.  The consumer chain is

  `exists_notMem_supportLocus_subset_of_fibre` → the pulled system''s support over
  `D(r)` →

  `DivisorAdaptation.forall_noLeak_of_forall_supportLocus_subset` → the assembler''s

  `hnoLeak`, and then `isLocallyCertified_of_forall_prime_exists_certified_adaptation`

  consumes the resulting away-certificate.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarTube.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_away_supportLocus_subset_of_fibre_subset
type: lean
updated: '2026-07-29T15:31:39'
---
theorem exists_away_supportLocus_subset_of_fibre_subset
    (d : (relCurve C R).LocalEquations) (U : (relCurve C R).Opens) {p : PrimeSpectrum R}
    (hfib : ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹'
        {(p : Spec (CommRingCat.of R))} ∩ d.supportLocus ⊆ (U : Set (relCurve C R))) :
    ∃ r : R, r ∉ p.asIdeal ∧
      ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹'
          (PrimeSpectrum.basicOpen r : Set (PrimeSpectrum R)) ∩ d.supportLocus
        ⊆ (U : Set (relCurve C R)) :=
  exists_notMem_supportLocus_subset_of_fibre C R d U.isOpen hfib