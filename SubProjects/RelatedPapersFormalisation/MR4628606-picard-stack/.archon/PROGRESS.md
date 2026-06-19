# Project Progress

## Current Stage
autoformalize

## Stages
- [x] init
- [x] dag
- [ ] autoformalize
- [ ] prover
- [ ] polish

## Current Objectives

The blueprint (DAG elaboration) is COMPLETE. The next stage is `autoformalize` — dispatching the autoformalization loop to translate blueprint declarations into Lean 4 stubs.

Recommended first objectives for the autoformalize stage:

### Parallel lane A — Combinatorial foundations (sorry-free target)
Formalize the following declarations in order; all are sorry-free once combinatorics are in place:
1. `def:prestable_graph` → `MR4628606.PrestableGraph`
2. `def:prestable_graph_isom` → `MR4628606.PrestableGraphIsom`
3. `lem:prestable_graph_finite_isom_classes` → `MR4628606.prestableGraphFiniteIsomClasses`
4. `def:prestable_graph_degree` → `MR4628606.PrestableGraphDegree`
5. `def:aut_prestable_graph_degree` → `MR4628606.AutPrestableGraphDegree`
6. `def:weighting_mod_r` → `MR4628606.WeightingModR`
7. `lem:weightings_cardinality` → `MR4628606.weightingsCardinality`
8. `def:decorated_prestable_graph` → `MR4628606.DecoratedPrestableGraph`
9. `def:pixton_formula_r` → `MR4628606.PixtonFormulaR`
10. `prop:pixton_polynomiality` → `MR4628606.pixtonPolynomiality`
11. `def:pixton_formula` → `MR4628606.PixtonFormula`

### Parallel lane B — Algebraic geometry axiomatics (axiom-complete target)
Formalize the geometric content as named axioms (see STRATEGY.md for sub-phase decomposition):
1. Sub-phase (i): `def:picard_stack` → `Axiom.PicardStackSmooth` + `MR4628606.PicardStack`
2. Sub-phase (ii): `def:operational_chow` → `Axiom.OperationalChow` + `MR4628606.OperationalChow`
3. Sub-phase (iii): `def:tautological_classes` → `MR4628606.TautologicalClasses`
4. Sub-phase (iv): `def:boundary_map_j` → `Axiom.BoundaryStratumMap` + `MR4628606.BoundaryStratumMap`
5. `def:tautological_ring` → `MR4628606.TautologicalRing`

After both lanes complete:
- Formalize the six invariance lemmas of Section 0.3: `lem:invariance_dualizing` (I),
  `lem:invariance_unweighted_marking` (II), `lem:invariance_weight_translation` (III),
  `lem:invariance_twisting_pullback` (IV), `lem:invariance_vertical_twisting` (V),
  `lem:invariance_partial_stabilization` (VI). Note: I, IV, V are independent deliverables
  (DAG leaves); only II, III, VI feed `thm:main` (II+III reduce to the universal case, VI is
  used inside it).
- Formalize `thm:dr_existence`, `thm:main`, `thm:vanishing`, `thm:twisted_differentials`,
  and the degree-0 specialization `thm:universal_deg0` (Section 0.7).
