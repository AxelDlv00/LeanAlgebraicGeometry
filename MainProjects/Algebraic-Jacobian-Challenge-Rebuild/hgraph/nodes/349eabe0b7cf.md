---
author: sync
content_type: theorem
created: '2026-08-05T10:50:56'
decl: AlgebraicGeometry.PicRankOneLocalPresentation.sectionsMapTop_datumSectionBaseChange_away_ne_zero
docstring: 'The local-away generator supplied over the presentation ring gives the
  exact

  fibrewise-nonvanishing hypothesis required by the divisor construction after localizing.


  This is the missing consumer bridge between the finite-projective generator theorem
  and

  `sectionLocalEquationsOfDatumSectionBaseChange`.  It compares residue fields across
  the

  localization, cancels the iterated tensor product, and then uses the presentation''s

  canonical `H⁰` base-change equivalence.'
file: AlgebraicJacobian/Picard/Pic0RankOnePresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneLocalPresentation.sectionsMapTop_datumSectionBaseChange_away_ne_zero
type: lean
updated: '2026-08-14T10:32:38'
---
theorem sectionsMapTop_datumSectionBaseChange_away_ne_zero
    (P : PicRankOneLocalPresentation pi lam)
    (f : P.cover.Carrier)
    (y : Sheaf.HModule P.datum.sheaf 0)
    (hy : ∀ p : PrimeSpectrum P.cover.Carrier, f ∉ p.asIdeal →
      (y ⊗ₜ (1 : p.asIdeal.ResidueField) :
        Sheaf.HModule P.datum.sheaf 0 ⊗[P.cover.Carrier]
          p.asIdeal.ResidueField) ≠ 0)
    (q : PrimeSpectrum (Localization.Away f)) :
    (P.datum.baseChange (Localization.Away f)).sectionsMapTop
      q.asIdeal.ResidueField
      (P.datumSectionBaseChange (Localization.Away f) y) ≠ 0 := by
  let B := Localization.Away f
  let K := q.asIdeal.ResidueField
  have hiter : ((1 : K) ⊗ₜ[B]
      ((1 : B) ⊗ₜ[P.cover.Carrier] y) :
      K ⊗[B] (B ⊗[P.cover.Carrier]
        Sheaf.HModule P.datum.sheaf 0)) ≠ 0 :=
    away_one_tmul_one_tmul_ne_zero f y hy q
  have hyB : ((1 : K) ⊗ₜ[B]
      (P.h0BaseChange B ((1 : B) ⊗ₜ[P.cover.Carrier] y)) :
      K ⊗[B] Sheaf.HModule (P.datum.baseChange B).sheaf 0) ≠ 0 :=
    P.h0BaseChange_one_tmul_ne_zero B K y hiter
  have hH1 : Subsingleton (datumPair (P.datum.baseChange B)).H1 :=
    P.datumPair_h1_baseChange B
  let yB : Sheaf.HModule (P.datum.baseChange B).sheaf 0 :=
    P.h0BaseChange B ((1 : B) ⊗ₜ[P.cover.Carrier] y)
  change (P.datum.baseChange B).sectionsMapTop K
    (Sheaf.HModule.linearEquiv₀
      (Opens.grothendieckTopology ((relCurve C B : Scheme.{u}) : TopCat))
      isTerminalTop (P.datum.baseChange B).sheaf yB) ≠ 0
  exact sectionsMapTop_ne_zero_of_one_tmul_ne_zero
    (P.datum.baseChange B) hH1 yB hyB