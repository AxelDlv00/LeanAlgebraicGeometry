---
author: sync
content_type: theorem
created: '2026-07-29T06:04:34'
decl: AlgebraicGeometry.DivFamZarAff.exists_certified_away_rep_of_mk
docstring: 'Step 1 read at an explicit system and pin, for a caller who has just produced
  one (e.g. from

  `ThetaGeneratorSeed.isLocallyCertifiedAff_of_swallowing_affineOpen`) and has not
  packaged the

  class yet.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffAwayRep.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivFamZarAff.exists_certified_away_rep_of_mk
type: lean
updated: '2026-07-31T20:14:45'
---
theorem DivFamZarAff.exists_certified_away_rep_of_mk
    {d : (relCurve C S).LocalEquations} (hd : IsLocallyCertifiedAff n d) :
    ∃ (m : ℕ) (h : Fin m → S), Ideal.span (Set.range h) = ⊤ ∧
      ∀ l : Fin m, ∃ G : CertifiedDivisorFamilyAff C (Localization.Away (h l)) n,
        G.toZarAff = DivFamZarAff.mapAlg (Localization.Away (h l)) n
          (DivFamZarAff.mk d hd) :=
  DivFamZarAff.exists_certified_away_rep _