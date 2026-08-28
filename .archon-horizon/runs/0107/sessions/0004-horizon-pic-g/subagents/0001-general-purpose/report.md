My audit is complete. Here are the findings.

## (1) `(divFunctor ...).RepresentableBy _` producers

| Producer | Location | Status |
|---|---|---|
| `divFunctorZeroRepresentableBy` | `DivisorFamilyDegreeZeroRep.lean:227` | **UNCONDITIONAL, sorry-free** — but only at parameter **n=0** (represented by terminal object; degree-0 sections are a subsingleton). The one real producer. |
| `divFunctor_representableBy_of_chartClause` | `DivRepAffPullClause.lean:490` | **GATED** on `(hU : DivRepChartFamily.IsChartClause ... U)` = U2 (G-4 cert). Plus `include hO hchi`. No producer of the gate. |
| `divFunctor_representableBy_of_id` | `DivRepAffPullClause.lean:510` | **GATED** on `(hid : ∀ i j, IsDivRepClassify ... (U i j) (ChartMap i j))` = U2 at identity point. |
| `divFunctor_representableBy_of_chartRange` | `DivRepChartRange.lean:220` | **GATED** on `(hrange : ∀ i j, ∃ F, (divRepClassifyZar ... F).left = ChartMap i j)` = U2 preimage; "Nothing here produces such a class." |
| `DivRepGlobalData.representableBy` | `DivRepKit.lean:113` | **GATED** on `(D : DivRepGlobalData ...)` — unwitnessed structure (`DivRepKit.lean:68`), no unconditional builder. |
| `DivRepAffinePullback.representableBy` | `DivRepGlobalClassify.lean:306` | **GATED** on `(D : DivRepAffinePullback ...)` — unwitnessed structure (`DivRepAffKit.lean:175`); only builder re-requires `IsChartClause`. |

No sorry in any of these. `DivRepGlobalLift.lean` has no RepresentableBy-concluding def (plumbing). Net: only n=0 is unconditional; every general-`n`/`g` producer bottoms out in the undischarged U2/G-4 certificate.

## (2) Coverage class-equation `h` — producer vs re-statement

**NO file discharges `h`.** The exact remaining hypothesis appears in:
- `chartsCoverLocally_of_slice` / `isLocallySurjective_of_slice` — `Pic0ChartCoverageSlice.lean:187, 216`: `h : ∀ Y [IsAffine Y] s y, ∃ W (_:y∈W) (g : Over.mk (W.ι ≫ s.1) ⟶ D), (pic0TypeFunctor C).map ... = ⟨chartValue C π n m Z ... (rep.homEquiv ...), chartValue_mem_pic0Subgroup ...⟩`
- `chartsCoverLocally_of_affineLocal` — `Pic0ChartCoverageAffineTest.lean:150`: the affine-test pointwise-hit form `∃ W (_:y∈W) i x, (f i).app _ x = ... map (W.ι).op s`.

A project-wide search for any caller supplying `h` to these three returns **only the `Pic0ChartCoverage*` files themselves** (re-statements/converses). No producer exists. `Pic0ChartCoverageSlice.lean:213` says so: "The class equation is still open... a spreading-out, absent from the tree." `exists_uniform_admissibleCoverageChart_eq_univ` (`Pic0ChartCoverageThreshold.lean:381`) proves `chartLocus = Set.univ` uniformly, but its own `:93-104` states it "closes no antecedent of `pic0RepresentableByOfCharts`" — disjoint carrier, does not feed (b).

## (3) Sorry counts (all zero)

`Pic0SigmaSheaf.lean: 0`, `Pic0ChartCoverageSlice.lean: 0`, `Pic0ChartCoverageAffineTest.lean: 0`, `Pic0ChartCoverageThreshold.lean: 0`, `PicRepDatum.lean: 0`, `JacobianData.lean: 0`, `DivisorFamilyDegreeZeroRep.lean: 0`.

**Two open leaf gates:** (a) U2/G-4 certificate for general-`n` `rep` (only n=0 is free); (b) the per-point class equation `h` — no producer, only re-statements. They sit on opposite sides of one rank inequality with nothing in the tree connecting them.

Caveat: unread advisory inbox item I-1690 claims a new `Picard/RepresentableByTerminal.lean` with a Div⁰ producer; I did not audit it (not a named target, may not be at HEAD).
