---
author: horizon
created: '2026-07-29T07:45:46'
date: '2026-07-29T07:45:46'
provenance:
  projects: Algebraic-Jacobian-Challenge-Rebuild
  role: horizon
  round: '7'
  rounds: '8'
  run: '0072'
  session: 0016-horizon-ajcr-charts
  task: ajcr-charts
  task_title: C9 chartLocus, the chart pair, and DAT-B/DAT-C coverage
updated: '2026-07-29T07:45:46'
---
SUPERSEDED IN PART 2026-07-29 (run 0072 r7, lane ajcr-charts). The "at EVERY extension L of
kappa(t), strictly more than IsChartDatumPlusFibre asks" framing OVERPRICES the gap: it is ZERO.

hplus at L is hfib at kappa(t) pushed forward along PicEtAff.map C L -- PicEtAff.map_map on the
left, PicEtAff.map_unit on the right, relCurveMap_comp over k -> A -> kappa(t) -> L on the class.
Three functoriality laws, no geometry, nothing specific to cechPicClass at all. The transport is
isChartDatumPlusFibreAt_of_isScalarTower (Picard/Pic0ChartPlusFibreTower.lean).

WHY IT WENT UNPRICED, and this is the transferable part: that transport was CITED BY NAME in
Pic0ChartPresentationConverse's header ("the honest statement of when the kappa(t)-level hfib
gives the L_t-level one") and DID NOT EXIST anywhere in the tree. A sorry census, an axiom probe
and a green root build are ALL SILENT about a docstring naming an absent declaration.

USE isChartDatumPresentation_of_plusFibre_tower -- IsChartDatumPresentation from hfib ALONE.

A SECOND FINDING, about a STATEMENT rather than a proof. hasWitnessH1Vanishing_of_isSplitWitness_at
quantifies its hplus binder over (Algebra A L) with only IsScalarTower k A L. That is stronger
than its own proof consumes AND unprovable from hfib: IsChartDatumPlusFibreAt mentions
relCurveMap C A L, so at an A-structure unrelated to the composite A -> kappa(t) -> L the RHS
pulls D.cechPicClass along a DIFFERENT morphism. Not merely hard to supply -- the WRONG STATEMENT.
Restated as hasWitnessH1Vanishing_of_isSplitWitness_tower with IsScalarTower A kappa(t) L, exactly
the component towerOfResidueFieldExtension already returns and the landed proof already discards.

ENDPOINT: isOpen_chartLocus_of_plusFibre is CHART-U(b) at a general test from the witness-free
hypothesis alone; chartLocusOpensOfPlusFibre gives the locus as T.left.Opens, the shape a chart
datum's W field consumes. NOT claimed: a PRODUCER of the per-affine-piece datum.

Full root build GREEN, 9283 jobs, EXIT=0, zero errors, zero sorry warnings. Every new declaration
axiom-clean [propext, Classical.choice, Quot.sound] against a control that fires sorryAx.
