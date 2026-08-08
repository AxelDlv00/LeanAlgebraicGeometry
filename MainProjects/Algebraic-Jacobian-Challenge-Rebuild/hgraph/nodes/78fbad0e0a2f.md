---
author: sync
content_type: theorem
created: '2026-08-07T02:08:03'
decl: AlgebraicGeometry.PicRankOneLocalPresentation.baseOpenDatumSectionLocalEquations_divEq_of_unit
docstring: The arbitrary-coefficient unit-rescaling bridge specialized to a basic
  open.
file: AlgebraicJacobian/Picard/Pic0RankOneLocalDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneLocalPresentation.baseOpenDatumSectionLocalEquations_divEq_of_unit
type: lean
updated: '2026-08-08T11:34:20'
---
theorem baseOpenDatumSectionLocalEquations_divEq_of_unit
    (P : PicRankOneLocalPresentation pi lam)
    [IsNoetherianRing P.cover.Carrier]
    (f : P.cover.Carrier)
    (y y' : Sheaf.HModule P.datum.sheaf 0)
    (hy : ∀ p : PrimeSpectrum P.cover.Carrier, f ∉ p.asIdeal →
      (y ⊗ₜ (1 : p.asIdeal.ResidueField) :
        Sheaf.HModule P.datum.sheaf 0 ⊗[P.cover.Carrier]
          p.asIdeal.ResidueField) ≠ 0)
    (hy' : ∀ p : PrimeSpectrum P.cover.Carrier, f ∉ p.asIdeal →
      (y' ⊗ₜ (1 : p.asIdeal.ResidueField) :
        Sheaf.HModule P.datum.sheaf 0 ⊗[P.cover.Carrier]
          p.asIdeal.ResidueField) ≠ 0)
    (v : (Localization.Away f)ˣ)
    (hsec : P.datumSectionBaseChange (Localization.Away f) y' =
      (v : Localization.Away f) • P.datumSectionBaseChange (Localization.Away f) y) :
    Scheme.LocalEquations.DivEq
      (P.baseOpenDatumSectionLocalEquations f y hy)
      (P.baseOpenDatumSectionLocalEquations f y' hy') := by
  have hsec_y : ∀ q : PrimeSpectrum (Localization.Away f),
      (P.datum.baseChange (Localization.Away f)).sectionsMapTop q.asIdeal.ResidueField
        (P.datumSectionBaseChange (Localization.Away f) y) ≠ 0 :=
    fun q => P.sectionsMapTop_datumSectionBaseChange_away_ne_zero f y hy q
  have hsec_y' : ∀ q : PrimeSpectrum (Localization.Away f),
      (P.datum.baseChange (Localization.Away f)).sectionsMapTop q.asIdeal.ResidueField
        (P.datumSectionBaseChange (Localization.Away f) y') ≠ 0 :=
    fun q => P.sectionsMapTop_datumSectionBaseChange_away_ne_zero f y' hy' q
  simpa only [baseOpenDatumSectionLocalEquations] using
    (P.sectionLocalEquationsOfDatumSectionBaseChange_divEq_of_unit
      (Localization.Away f) y y' hsec_y hsec_y' v hsec)

set_option maxHeartbeats 800000 in
-- The unique-unit wrapper reuses the preceding non-vacuous generator and section bridges.