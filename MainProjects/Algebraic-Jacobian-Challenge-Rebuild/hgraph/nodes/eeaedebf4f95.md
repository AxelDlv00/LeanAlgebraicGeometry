---
author: sync
content_type: definition
created: '2026-07-25T15:32:34'
decl: AlgebraicGeometry.ThetaGeneratorSeed.divFamZar_of_forall_away_certified
docstring: '**The `DivFamZar` class of a Zariski-locally certified seed** — the object
  every DD-R

  consumer (`divRepPullAt`, `DivRepAffinePullback.pull`, `divRepClassifyZar`) actually

  takes as input.  No global `IsCertified` over `R` is required.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarSeed.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.divFamZar_of_forall_away_certified
type: lean
updated: '2026-07-29T15:26:38'
---
noncomputable def divFamZar_of_forall_away_certified (hD : D.IsGenerator)
    {m : ℕ} (g : Fin m → R) (hg : Ideal.span (Set.range g) = ⊤)
    (hcert : ∀ i : Fin m,
      haveI : IsOpenImmersion (relCurveMap C R (Localization.Away (g i))) :=
        isOpenImmersion_relCurveMap_away C R (Localization.Away (g i)) (g i)
      ∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) pi n,
        Scheme.LocalEquations.DivEq G.eqns
          ((D.localEquations hD).pullback
            (relCurveMap C R (Localization.Away (g i)))
            (Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
              (relCurveMap C R (Localization.Away (g i))) (D.localEquations hD)))) :
    DivFamZar C R pi n :=
  DivFamZar.mk (D.localEquations hD)
    (isLocallyCertified_of_forall_away_certified hD g hg hcert)