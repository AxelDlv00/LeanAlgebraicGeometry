No files edited, no commits — read-only honored. Here is the audit.

## AJCR.w4-rep.datum.dat-b

**P1. "A spreading-out lemma for the RANGE of `relPicToPicEt` along a localisation A → A_f. That is the descent in miniature — not cheap, but bounded and honestly stated."** → **ALREADY PRESENT / not needed.** `IsPlusHonest` (`AlgebraicGeometry.IsPlusHonest`, `AlgebraicJacobian/Picard/Pic0ChartPlusFibreProducer.lean:200`) quantifies over affine opens of `T.left`; the per-piece witnesses are restrictions of one top-level witness, and restriction along the unit *is* `AlgebraicGeometry.picEtMap_relPicToPicEt` (`AlgebraicJacobian/Picard/PicEtUnit.lean:194`). Two scratch probes closed, `lake env lean` EXIT=0, axiom-clean vs a control firing `sorryAx`:
```
theorem probe_isPlusHonest_of_global (μ : picEt C T)
    (h : ∃ z : relPic C T, relPicToPicEt C T z = μ) : IsPlusHonest C T μ := by
  obtain ⟨z, rfl⟩ := h; intro U
  exact ⟨relPicMap C (Over.fromSpecAffine T U) z, (picEtMap_relPicToPicEt C _ z).symm⟩
```
and its affine-test consequence gives full `IsOpen (chartLocus …)` with no localisation step. The row's covariant/contravariant *diagnosis* is right about the arbitrary-class gap; the brick it prescribes crosses the wrong binder. Filed **I-1273**.

**P2. "The residue is the reconciliation of the chart parameter with the threshold" / "the `0 ≤ Σ` legality is the open question."** → **OVER-PRICED, twice.** `AlgebraicGeometry.chartValue_mem_pic0Subgroup` (`AlgebraicJacobian/Picard/DivSchemeAbel.lean:382`) takes only the degree equation — no effectivity. I closed the `g+e` slack instantiation with `rw [hZ]; push_cast; ring`. And `AlgebraicGeometry.mixedParamRepresentableBy` (`AlgebraicJacobian/Picard/Pic0ChartAtlasParamFree.lean:125`) already makes the calibration per-chart. Real residue: DAT-0a at the fibre field. Filed **I-1278**.

**P3. Coverage "staged at a separably closed level."** → **STALE.** `IsSepClosed` occurs in exactly 3 files tree-wide (`AlgebraicJacobian/Curve/SepPointsDense.lean`, `SeparablyClosedPoints.lean`, `SeparablyClosedFibre.lean`); no Picard coverage/chart-locus file imports that layer. The drop-free route deleted the oracle. Also unmentioned: `chartsCoverLocally_of_affineLocal` (`AlgebraicJacobian/Picard/Pic0ChartCoverageAffineTest.lean`) reduces the obligation to affine tests, landed *after* the row's `updated_at`.

**P4. C-0007: "B-6 is arguably FALSE as phrased — `divFunctor` is a proper subfunctor."** → **REAL but scope-limited.** `AlgebraicGeometry.forall_not_isCertified_of_straddling` (`AlgebraicJacobian/Picard/DivisorFamilyAffStrict.lean:127`) quantifies over `DivisorAdaptation` (chart-typed) only, and `isCertified_affine_and_not_isCertified_chart` in the same file proves the widened side *does* certify. The atlas consumes `divFunctorAff` (`abelSigmaChartAff`), so the refutation does not transfer.

## AJCR.w4-rep.datum.dat-c.c9-chartlocus

**P1. "Remaining: a PRODUCER of the per-affine-piece datum … is not claimed."** → **STALE.** `exists_isChartDatumPlusFibre_of_mem_range` (`Pic0ChartPlusFibreProducer.lean:178`) produces it from range membership via `BasicOpenCocycleDatum.exists_cechPicClass_eq` (`AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean:301`). Honesty producers exist for exactly the chart classes (`abelDiv_isPlusHonest`, `chartTwist_isPlusHonest`, and at the R2 carrier `abelDivAff'_isPlusHonest`/`chartValueAff_isPlusHonest` in `AlgebraicJacobian/Picard/Pic0ChartHonestAff.lean`). Ledger dates all postdate the row's `updated_at` 2026-07-29T11:20Z. Only *arbitrary*-class honesty remains open. Filed **I-1277**.

**P2. `Pic0ChartUnivReduce.lean`'s `chartLocusOpens` docstring: "no theorem in the tree produces `haff` for a general test. It is a genuine open obligation."** → **STALE for honest classes.** `chartLocusOpensOfIsPlusHonest` (`:334`) is `chartLocusOpens` with `haff` discharged. I also closed the general restriction form from `Over.fromSpecAffine_naturality` (`PicEtUnit.lean:79`) alone. I-1238 reports the same defect at the widened chart value.

**P3. "c9b's gate is clause (ii) alone (CERT-Σ/divRep through `IsChartLocusFibre`'s `exists_factor`)."** → **REAL.** `IsChartLocusFibre` (`Pic0ChartUnivReduce.lean:166`) is a `Prop` over `ChartFibrePresented` (`AlgebraicJacobian/Picard/Pic0ChartOpenImmersionCriterion.lean:129`), whose `exists_factor` field is coverage-on-the-locus. Consistent with I-1216: all four `IsChartUniv` producers take `rep` as a binder.

## AJCR.w4-rep.datum.dat-d.ddr.divrep.u2

**P1. "What a prover lane can do THIS ROUND: (i) root `DivisorFamilyAffThetaTyping.lean`; (ii) restate declarations over `ThetaTrivData`."** → **STALE, both steps.** Rooted at `AlgebraicJacobian.lean:346` with a live olean. And step (ii) is far past "whichever declarations U2 needs": the file already carries `trivDeltaRight`, `trivGluedSubmodule`, `trivEval`, `trivEval_mem`, `trivGluedEval`, `ker_trivGluedEval`, `trivWindowCarve`, `trivWindowCarve_surjective` and **`trivWindowQuotEquiv`** — the whole chain, conditional only on `Function.Surjective (trivGluedEval A T)`. All axiom-clean. Filed **I-1275**.

**P2. "The probe this leaf owes and nobody has run in two rounds: does `univSeed`'s supportLocus meet both V0 and V1? … Do it first."** → **Wrong question.** `ThetaGeneratorSeed` (`AlgebraicJacobian/Picard/DivSchemeFamily.lean:74`) has a `side` field and `piece_le : D.piece z ≤ relPinnedChart C R π (D.side z)` (`:98`); `localEquations` (`:349`) sets `cover.opens := D.piece` by `rfl`. The cover is chart-subordinate *by construction*, so measuring the support decides nothing. Stronger, uncited obstruction: `DivisorAdaptation.isClosed_supportLocus_inter_chart_of_isCertified` (`AlgebraicJacobian/Picard/DivSchemeCertZarConfine.lean`) needs no connectivity. Filed **I-1276**.

**P3. "a > 0 producer is absent."** → **REAL**, and the row correctly notes `a = 0` is where `divisorDatum` runs.

**P4. "No producer of `IsChartClause`; G-4 discharge still the gate."** → **REAL.** `IsChartClause.of_id` and `divFunctor_representableBy_of_id` exist as claimed; no `IsChartClause` producer. Corroborated by I-1248.

## AJCR.w4-rep.datum.dat-glue

This row self-describes as audited-and-correct. I re-checked and agree.

- **G-1 `Pic0PreservesFilteredBaseColimit`** → **REAL.** A named `Prop` (`AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136`); every occurrence is prose or a hypothesis binder. The one conclusion-position hit (`PicRepColimitResidual.lean:49`) is inside a docstring code block.
- **G-2 two remaining DAT-J inputs** → **REAL and exact.** `toJacobianDataOfAbelLifts` (`AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:132`) has precisely those two hypotheses; `PicRepDatum` has zero producers across all 49 occurrences.
- **G-6 `ofCharts` vs `ofChartsOfCompactSpace`** → accurate as stated (`AlgebraicJacobian/Picard/JacobianDataCharts.lean:182` / `:209`).
- **G-7 no hypothesis gap at the frozen signature** → **verified independently.** The `inferInstance` example exists (`:237`), `GeometricallyReduced` is not a file-level variable there, and I re-derived it in a fresh file from `[SmoothOfRelativeDimension 1 C.hom]` *alone*.

## Where a prover lane could win cheaply

1. **dat-b P1** — delete the prescribed spreading-out brick; the three-line naturality lemma replaces it. Highest value: it is the only brick the row names as its lane-facing recommendation.
2. **c9 P1/P2** — retire the "producer not claimed" residue and fix the `chartLocusOpens` docstring. Zero Lean cost; prevents the rediscovery I-1238 already paid once.
3. **u2 P1** — both prescribed steps are done; a lane taking the row at its word re-lands landed work.
4. **dat-b P2** — the `0 ≤ Σ` "open question" is not a hypothesis of the legality theorem; `ring` closes the slack index.
5. **u2 P2** — skip the support measurement; `ThetaGeneratorSeed.piece_le` answers the structural question.

**Verdict.** dat-glue is converging and honestly priced. c9-chartlocus and u2 are **churning on stale prose**: both name as "this round's bounded win" work that already landed, and c9's own summary documents this as a four-instance pattern — r7 is not the last instance, it continues. dat-b is **advancing in Lean but mispriced in prose**: real progress (drop-free coverage, affine reduction, the honesty producer) sits under a summary whose one lane-facing prescription is unnecessary. No sorries, no axioms, no vacuity in anything I checked; the defect is uniformly in the costing, always in the direction of over-pricing.

One caveat on my own scope: I did not close the `relCover`-vs-`fiberChart` spelling bridge (`relCover` is a `pullbackProd` base change), so my fibre-Weil-divisor bound on u2 P2 is one step short of a full answer — recorded as such in I-1276 rather than smoothed over.
