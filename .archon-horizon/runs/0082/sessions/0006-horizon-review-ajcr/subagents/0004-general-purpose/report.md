Both claims are now settled. Here are the findings.

## CLAIM A — FALSE as stated (count is wrong; the "none is a reduction" half is TRUE)

**1. The definition.** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartPlusFibreProducer.lean:200-203`, exactly:

```lean
def IsPlusHonest (T : Over (Spec (.of k))) (μ : picEt C T) : Prop :=
  ∀ U : T.left.affineOpens, ∃ z : relPic C (overSpec k Γ(T.left, U.1)),
    relPicToPicEt C (overSpec k Γ(T.left, U.1)) z
      = picEtMap C (Over.fromSpecAffine T U) μ
```

**2. The census: ELEVEN declarations, not six.** All 28 grep hits are in that one file (`grep -rn "IsPlusHonest" --include="*.lean" AlgebraicJacobian | wc -l` = 28; one file). Confirmed no hits anywhere else in the repo including sibling projects and scratch dirs. Splitting mentions into declarations vs. prose: lines 35, 40, 60, 69, 71, 196 are docstring/header text (six prose mentions — possibly the source of the reviewer's "six"). The declarations, all in `Pic0ChartPlusFibreProducer.lean`:

| # | line | name | role |
|---|---|---|---|
| 1 | :200 | `IsPlusHonest` | the definition |
| 2 | :209 | `IsPlusHonest.mul` | closure (consumes 2, concludes 1) |
| 3 | :220 | `IsPlusHonest.inv` | closure |
| 4 | :230 | `IsPlusHonest.pow` | closure |
| 5 | :245 | `thetaFamily_isPlusHonest` | producer, unconditional for θ-families |
| 6 | :256 | `sigmaFamily_isPlusHonest` | producer (Σ is a θ-family by definition) |
| 7 | :275 | `abelDiv_isPlusHonest` | producer, unconditional for the Abel value |
| 8 | :294 | `chartTwist_isPlusHonest` | preservation (consumes for `lam`, concludes for the twist) |
| 9 | :316 | `isOpen_chartLocus_of_isPlusHonest` | consumer — the payoff, CHART-U(b) |
| 10 | :334 | `chartLocusOpensOfIsPlusHonest` | consumer (def, packages 9 as an open) |
| 11 | :343 | `mem_chartLocusOpensOfIsPlusHonest` | `Iff.rfl` simp restatement of 10 |

**3. The substantive half of Claim A holds.** None of the eleven is a spreading-out, localisation, or field-point reduction. Nothing has the shape "IsPlusHonest at all fibres → IsPlusHonest" or "IsPlusHonest over a localisation → IsPlusHonest". The three producers (5, 6, 7) are *unconditional* for specific class families, not reductions of the general case; the closure lemmas move within a fixed `T`; 9–11 only consume. So the reviewer's conclusion survives, but the census supporting it is off by five and the mis-count is in the direction that understates how much is there.

**4. Context worth flagging:** `Pic0ChartPlusFibreProducer.lean` has ZERO importers (`grep -rln "import AlgebraicJacobian.Picard.Pic0ChartPlusFibreProducer"` returns nothing). Nothing downstream consumes `isOpen_chartLocus_of_isPlusHonest` yet.

## CLAIM B — SUPPORTED. No such descent exists; I found the near-misses instead

**5. `relPicToPicEt`** is at `AlgebraicJacobian/Picard/PicEtUnit.lean:126`: `def relPicToPicEt (T : Over (Spec (.of k))) : relPic C T →* picEt C T`, the component at `T` of the étale-sheafification unit, built as `PicEtAff.unit` on each affine open of `T.left`. Bundled as the natural transformation `picEtUnit : relPicFunctor C ⟶ picEtFunctor C` at `PicEtUnit.lean:231`.

**6. Every declaration mentioning it is naturality or affine-consistency, never range.** The 60 hits across 6 files reduce to: `relPicToPicEt_val` (`:152`), `picEtAffineEquiv_relPicToPicEt` (`:161`), `picEtMap_relPicToPicEt` (`:194`), `picEtUnit`/`_app` (`:231`, `:238`, `:243`), `degAt_relPicToPicEt` (`AbelElement.lean:69`), `picEtCrossBase_relPicToPicEt` (`PicEtCrossBaseGraph.lean:105`), plus the producer file's own `:156`/`:178`. No surjectivity, epi, essential-surjectivity, `Set.range`, or `mem_range` statement about it exists anywhere.

**7. What I searched.** `relPicToPicEt`, `Set.range.*relPic`, `mem_range`, `localSurj`/`LocalSurj`/`isLocallySurjective`/`IsLocallySurjective`, `descent`/`Descent`/`descend`, `spreadingOut`/`spread_out`/`SpreadOut`, `IsLocalization`/`Localization`/`Away`/`awayMap` restricted to `PicEt*`/`Pic0*`/`RelPic*`, and `range.*localiz`/`localiz.*range`/`honest.*localiz`. I enumerated every `private` declaration in `AlgebraicJacobian/Picard/` (~60) per the workspace lesson — none is a descent statement for a range; they are algebra/tower/appTop plumbing. I read the headers and declaration lists of `Pic0ChartHonest.lean`, `Pic0ChartPlusFibreTower.lean`, `PicEtAffZariskiGlue.lean`, `Pic0ZariskiSheaf.lean`, `RelPicCoverInjective.lean`, `RelPic.lean`, `Pic0ChartLocusOpen.lean`. Notably, `grep relPic | grep -i "away\|localizat\|basicOpen"` returns **nothing** — `relPic` has no localisation API at all, which is the structural reason the descent cannot be assembled from parts either.

**8. Closest near-miss #1 — descent for the WRONG object.** `PicEtAff.exists_mapAlg_eq_of_compat`, `AlgebraicJacobian/Picard/PicEtAffZariskiGlue.lean:337`, glues a compatible family `x : ∀ i, PicEtAff C (S i)` over `Away`-localizations `[∀ i, IsLocalization.Away (g i) (S i)]` with `Ideal.span (Set.range g) = ⊤` to `∃ z : PicEtAff C A, ∀ i, mapAlg C (IsScalarTower.toAlgHom k A (S i)) z = x i`. This is Zariski descent for **`PicEtAff` classes**, i.e. the target of the unit. It does not descend *being in the range of the unit*: the glued `z` is a plus class with no claim that it is a `relPicToPicEt` image, and there is no `relPic`-level analogue to make the diagram commute.

**9. Closest near-miss #2 — honesty produced UPWARD, never brought down.** `PicEtAff.map_mk_eq_unit_self` (`Pic0ChartHonest.lean:118`) and `exists_honest_of_picEtAff` (`Pic0ChartHonest.lean:136`) give honesty over the class's own étale carrier `E.Carrier`. That file's header states the gap explicitly at `Pic0ChartHonest.lean:47-52`: "It gives honesty **over `Spec E.Carrier`**, not over `Spec A`. ... **Nothing here performs that descent**; the topological core of it is landed as `isOpen_of_isOpen_comap_preimage`." That is descent of an **open set** (`Pic0ChartLocusOpen.lean:129`, pure point-set topology), not of range membership.

**10. Closest near-miss #3 — local surjectivity as a HYPOTHESIS/instance, for a different map.** Every `IsLocallySurjective` in the Picard layer is `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)` — the chart-atlas coverage input, carried as an instance binder (`JacobianDataCharts.lean:117`, `Pic0AtlasFiniteType.lean:179`, `Pic0ChartRestrictedFibre.lean:263`, and others) and proved only for `Sigma.desc` (`Pic0ChartLocalSurjectivity.lean:103`). Nothing about `relPicToPicEt`.

**11. Closest near-miss #4 — away-localisation transport of a DIFFERENT predicate.** `DivFamZar.isH1VanishingAt_comap_away_iff`, `AlgebraicJacobian/Picard/DivisorFamilyH1Locus.lean:328`, transports H¹-vanishing membership across `S → Localization.Away f` at lying-over primes. Right shape (predicate invariance along an away localisation), wrong predicate — H¹ vanishing, not range membership of the sheafification unit.

**What I could not check:** I did not run `lake build` or `lake env lean`, so all of this is static reading — I have not verified that the file currently compiles, nor that the eleven declarations are `sorry`-free (I did not run a `sorry` census on them). The absence claim rests on source-text grep over `AlgebraicJacobian/`; a descent statement phrased with none of my search tokens and no `relPicToPicEt` mention (e.g. stated purely in terms of `PicEtAff.unit` composed with something, under an unrelated name) would evade it, though near-miss #8 is the natural home for such a thing and does not contain it.
