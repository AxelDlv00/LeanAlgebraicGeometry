This is a read-only survey task; I have enough to answer all six questions. No file edits were made, no commits needed.

I have gathered sufficient evidence to answer all six questions comprehensively.

## Findings

**1. No pullback/base-change route exists that transports "own-member germ self-regularity" of `d` to `d.pullback f hreg` for arbitrary `f`.** What exists is the reverse-composite machinery in `AlgebraicJacobian/Picard/DivisorFamilyZarKit.lean` (namespace `Scheme.LocalEquations`):

- `germ_pullbackEqn_mem_nonZeroDivisors_of_forall_self` (:88) — member normalization only; does not reduce a pullback-along-`f` obligation to the base system's regularity.
- `germ_self_pullbackEqn_mem_nonZeroDivisors_of_divEq` (:114) and `germ_pullbackEqn_mem_nonZeroDivisors_of_divEq` (:159) — transport across `DivEq`, not across a base change of the ring/scheme.
- `germ_pullbackEqn_comp` (:174), signature:
```
theorem germ_pullbackEqn_comp {Z : Scheme.{u}} {f : Y ⟶ X} {g : Z ⟶ Y} {h : Z ⟶ X}
    (hgf : g ≫ f = h) (E : X.LocalEquations) (hregf) (ζ : Z) :
```
This is the composite-of-two-pullbacks route: given `d : X.LocalEquations` and `g ≫ f = h`, the germ of `pullbackEqn h d ζ` equals the germ of `pullbackEqn g (d.pullback f hregf) ζ`. Its hypothesis `hregf` is exactly the regularity of `d.pullback f` — i.e. it needs that pullback's regularity as an *input*, not a producer of it from `d`'s own regularity. So it does not solve the stated obstacle; it only lets you factor a two-stage pullback once you already have `hregf`.
- `germ_pullbackEqn_mem_nonZeroDivisors_of_immersion_cover` (:236) covers open-immersion Zariski-locality on the *source*, not a base-ring change.

None of these give, for `f = relCurveMap C R R'` with `R' = Localization.Away r`, a derivation of `d.pullback f hreg`'s own-member regularity purely from `d`'s own-member regularity — except in the special case `f` is an open immersion (see point 6), which `relCurveMap C R (Localization.Away r)` actually is.

**2. The chart-typed lane's fibrewise datum over an away base comes from `germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion` — not from any seed base-change.** Concretely, in `DivisorFamilyAffMapAlg.lean:140-218` (`IsLocallyCertifiedAff.germ_pullbackEqn_mem_nonZeroDivisors`) and in `DivSchemeCertZarSeed.lean:77-127` (`isLocallyCertified_of_forall_exists_away`, `isLocallyCertified_of_forall_away_certified`), every `CertifiedDivisorFamily C (Localization.Away (g i)) pi n` is required to satisfy `DivEq G.eqns (d.pullback (relCurveMap C R (Localization.Away (g i))) hreg)` where `hreg` is supplied inline by
```
Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
  (relCurveMap C R (Localization.Away (g i))) d
```
i.e. because `relCurveMap C R (Localization.Away (g i))` is an open immersion (via `isOpenImmersion_relCurveMap_away`), regularity is *automatic*, with no seed input at all. `DivSchemeCertZarFibreAvoid.lean` and `DivSchemeCertZarTube.lean` don't produce this fibre-regularity datum themselves; they consume `D.germ_self_pullbackEqn_mem_nonZeroDivisors` at the *residue field* fibre (not at `Localization.Away r`) — see `DivSchemeCertZarFibreAvoid.lean:365` and `DivSchemeAdaptationFibreRegular.lean:539`. `DivSchemeCertZarChartPair.lean` has no away-localization content (it's about chart-pair cover data, no `Localization.Away`/`ThetaGeneratorSeed` fibre-regularity theorem). So: the chart-typed lane's answer for a *generic* away base `R'` is not a seed base-change either — it's the free open-immersion fact. The seed enters only at the residue-field endpoint of the tower (`p.asIdeal.ResidueField`), via `DivSchemeAdaptationFibreRegular.lean:545` `eqn_tmul_one_mem_nonZeroDivisors_of_seed` and `:585` `divisorAdaptation_fibre_regular`.

**3. No `ThetaGeneratorSeed` base-change/pullback declaration exists.** Grepping every file that mentions `ThetaGeneratorSeed` for `baseChange`/`pullback`/`map` in that structure's own namespace found nothing — the only `baseChange`-named hits are `AffCoverData.baseChange` (`DivisorFamilyAffBaseChange.lean:87`, defines `AffCoverData C R'` from `AffCoverData C R`) and `ThetaGeneratorSeed.pinnedPieceQuotBaseChangeAlg` (`DivSchemeUnivFibreKerSpan.lean:24`, an unrelated colength-transport lemma about a quotient module, not a seed base-change). `ThetaGeneratorSeed` is defined in `AlgebraicJacobian/Picard/DivSchemeFamily.lean:74-86`:
```
structure ThetaGeneratorSeed (C : Over (Spec (.of k))) (R : Type u) [CommRing R]
    [Algebra k R] (π : C.left ⟶ P1 k) [IsFinite π] (a : ℕ)
    (K : Submodule R (relThetaSections C R π a)) : Type u where
  /-- The pinned chart side of the piece at `z`. -/
  side : relCurve C R → Bool
  /-- The basic-open generator of the piece at `z`. -/
  h : ∀ z : relCurve C R, Γ(relCurve C R, relPinnedChart C R π (side z))
  /-- The point lies in its piece. -/
  mem_basicOpen : ∀ z : relCurve C R, z ∈ (relCurve C R).basicOpen (h z)
  /-- The candidate local generator at `z`. -/
  sec : relCurve C R → relThetaSections C R π a
  /-- The candidate generators are drawn from `K`. -/
  sec_mem : ∀ z, sec z ∈ K
```
A base change `R → R'` would need to produce, for each `z' : relCurve C R'`: a `side`, an `h` (a section over R' of the pinned chart at that side), `mem_basicOpen`, a `sec z' ∈ relThetaSections C R' π a`, and `sec_mem` into a submodule `K' ⊆ relThetaSections C R' π a` (presumably a base-changed `K`). Note `relThetaSections` and `K` are R-linear objects — a base change would additionally need to define what `K'` is over `R'` and transport `IsGenerator`'s two clauses (`dvd`, `fibre_regular`), which quantify over primes of `R`, not `R'`.

**4. `AlgebraicGeometry.ThetaGeneratorSeed.germ_self_pullbackEqn_mem_nonZeroDivisors`** — `DivSchemeAdaptationFibreRegular.lean:314-323`:
```
theorem germ_self_pullbackEqn_mem_nonZeroDivisors (hD : D.IsGenerator)
    (p : PrimeSpectrum R) (z : relCurve C p.asIdeal.ResidueField) :
    ((relCurve C p.asIdeal.ResidueField).presheaf.germ
      (((D.localEquations hD).cover.pullback
        (relCurveMap C R p.asIdeal.ResidueField)).opens z) z
      (((D.localEquations hD).cover.pullback
        (relCurveMap C R p.asIdeal.ResidueField)).mem_opens z)).hom
      (Scheme.LocalEquations.pullbackEqn
        (relCurveMap C R p.asIdeal.ResidueField) (D.localEquations hD) z) ∈
      nonZeroDivisors ((relCurve C p.asIdeal.ResidueField).presheaf.stalk z)
```
It is quantified over `hD : D.IsGenerator`, a prime `p : PrimeSpectrum R`, and a point `z` of the relative curve over `p`'s **residue field** — `relCurveMap` here goes to `p.asIdeal.ResidueField`, NOT to `Localization.Away r`. This is exactly the memory-noted fact: the seed's clause is stated at residue fields, not at an arbitrary away localization.

**5. `AlgebraicGeometry.AffAdaptation.eqn_tmul_one_mem_nonZeroDivisors_of_self_pullbackEqn`** — `DivisorFamilyAffFibre.lean:230-243`:
```
theorem eqn_tmul_one_mem_nonZeroDivisors_of_self_pullbackEqn (j : D.index)
    (p : PrimeSpectrum R)
    (hreg : ∀ z : relCurve C p.asIdeal.ResidueField,
      ((relCurve C p.asIdeal.ResidueField).presheaf.germ
        ((d.cover.pullback (relCurveMap C R p.asIdeal.ResidueField)).opens z) z
        ((d.cover.pullback
          (relCurveMap C R p.asIdeal.ResidueField)).mem_opens z)).hom
        (Scheme.LocalEquations.pullbackEqn
          (relCurveMap C R p.asIdeal.ResidueField) d z) ∈
          nonZeroDivisors
            ((relCurve C p.asIdeal.ResidueField).presheaf.stalk z)) :
    (A.eqn j ⊗ₜ[R] (1 : p.asIdeal.ResidueField) :
        Γ(relCurve C R, D.pieces j) ⊗[R] p.asIdeal.ResidueField) ∈
      nonZeroDivisors (Γ(relCurve C R, D.pieces j) ⊗[R] p.asIdeal.ResidueField)
```
Its `hreg` hypothesis consumes self-regularity of the pulled system exactly at the **residue field** `p.asIdeal.ResidueField` — the same shape produced by item 4's theorem — not at `Localization.Away r`. This confirms: `affAdaptation_fibre_regular` (`DivisorFamilyAffFibre.lean:277-283`) discharges `hfib` by going straight from `R` to `κ(p)` in one step (via `relCurveMap C R p.asIdeal.ResidueField`), never through an intermediate `Localization.Away r`.

**6. Both exist.**
- `AlgebraicGeometry.isOpenImmersion_relCurveMap_away`, `DivisorFamilyZariskiSep.lean:203-208`:
```
theorem isOpenImmersion_relCurveMap_away (f : R) [IsLocalization.Away f S] :
    IsOpenImmersion (relCurveMap C R S)
```
(section variables: `S : Type u`, `[CommRing S] [Algebra k S] [Algebra R S] [IsScalarTower k R S]`).
- `AlgebraicGeometry.Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion`, `DivisorFamilyZariskiGlueKit.lean:242-246`:
```
theorem germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion {Z Y : Scheme.{u}}
    (w : Z ⟶ Y) [IsOpenImmersion w] (d : Y.LocalEquations) (y z : Z)
    (hz : z ∈ (d.cover.pullback w).opens y) :
    (Z.presheaf.germ ((d.cover.pullback w).opens y) z hz).hom (pullbackEqn w d y)
      ∈ nonZeroDivisors (Z.presheaf.stalk z)
```
This is the actually-usable route for `hreg` over `R' = Localization.Away r`: since `relCurveMap C R R'` is an open immersion by (6a), (6b) discharges the pullback-regularity hypothesis `hreg` for free at **any** point, with no seed input. This is exactly how `IsLocallyCertifiedAff.germ_pullbackEqn_mem_nonZeroDivisors` (point 2) and `isLocallyCertified_of_forall_exists_away`/`isLocallyCertified_of_forall_away_certified` (`DivSchemeCertZarSeed.lean`) discharge `hreg` today — they never need the seed's `germ_self_pullbackEqn_mem_nonZeroDivisors` for the `R → R'` leg at all, only for the final `R' → κ(p)` leg, which stays at the residue field.

## Summary of the actual state

There is no seed base-change and no generic "own-member regularity transports across pullback" lemma. But the obstacle as posed may be a non-issue: since `relCurveMap C R R'` for `R' = Localization.Away r` is an open immersion (fact 6a), `hreg` for the pulled system `(D.localEquations hD).pullback (relCurveMap C R R') _` is available for free via `germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion` (fact 6b) — no certificate, no seed base-change, no fibrewise input needed at that step. The seed's `germ_self_pullbackEqn_mem_nonZeroDivisors` (fact 4) is only needed one step further down, at the residue field `κ(p)` of a prime of `R'` (equivalently of `R`, since primes of `Localization.Away r` correspond to primes of `R` not containing `r`) — exactly the shape `AffAdaptation.eqn_tmul_one_mem_nonZeroDivisors_of_self_pullbackEqn` (fact 5) already consumes. This is the same pattern the chart-typed lane already uses (fact 2): compose the free open-immersion step `R → R'` with the seed's existing `R → κ(p)` clause via `germ_pullbackEqn_comp` (fact 1), rather than needing a `ThetaGeneratorSeed` base change to `R'` at all.
