---
author: sync
content_type: theorem
created: '2026-07-25T15:32:34'
decl: AlgebraicGeometry.ThetaGeneratorSeed.divisorAdaptation_isCertified_of_noLeak_liftQ_degree
docstring: '**The seed certificate with no invented submodule and the landed degree
  input.** The

  three substantive inputs are now: fibrewise no-leak (produced Zariski-locally by
  the

  support tube, `DivSchemeCertZarTube.lean`), residue-fibre injectivity of the injectivized

  Čech difference, and the degree of every pulled presentation divisor (already proved
  for

  the pointwise generator seed).'
file: AlgebraicJacobian/Picard/DivSchemeCertZarKerSpan.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.divisorAdaptation_isCertified_of_noLeak_liftQ_degree
type: lean
updated: '2026-07-25T15:32:34'
---
theorem divisorAdaptation_isCertified_of_noLeak_liftQ_degree {n : ℕ}
    (hnoLeak : ∀ (j : (A).index) (s : Spec (.of R)),
      ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {s}
          ∩ closure
            ((D.localEquations hD).supportLocus ∩
              ((A).pieces j : Set (relCurve C R))) ⊆
        ((A).pieces j : Set (relCurve C R)))
    (hinj : ∀ p : PrimeSpectrum R,
      Function.Injective
        (((LinearMap.ker ((A).deltaLeft - (A).deltaRight)).liftQ
          ((A).deltaLeft - (A).deltaRight) le_rfl).rTensor p.asIdeal.ResidueField))
    (hdeg : ∀ (p : PrimeSpectrum R)
      (hproj : ∀ j : (A).index, Module.Projective R ((A).colength j)),
      Scheme.CurveDivisor.deg p.asIdeal.ResidueField
          (Scheme.presentationDivisor p.asIdeal.ResidueField
            (((A).pulledEquations p.asIdeal.ResidueField hproj).presentation)) =
        (n : ℤ)) :
    (A).IsCertified n :=
  D.divisorAdaptation_isCertified_of_noLeak_kernel_spanning_degree hD hnoLeak
    (LinearMap.ker ((A).deltaLeft - (A).deltaRight)) le_rfl
    (fun p => (ker_rTensor_le_range_subtype_iff_liftQ_rTensor_injective
      ((A).deltaLeft - (A).deltaRight) p.asIdeal.ResidueField).mpr (hinj p))
    hdeg