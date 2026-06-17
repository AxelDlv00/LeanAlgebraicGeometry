# Progress-critic directive — iter-051

Assess convergence per active route. K=4 iters of signals below.

## Route GF — `Picard/FlatteningStratification.lean` (critical path)
- STRATEGY: Iters-left 3–5; phase entered long ago, flagged "over budget".
- iter-047: +3 axiom-clean (seam-1 reduction); sorry 1→1.
- iter-048: NO prover (plan-validate failed_all_noop, 0 provers ran).
- iter-049: +2 axiom-clean (seam 1b `gf_affine_finite_standard_subcover`, 1c `gf_finite_gen_iff_free_epi`); sorry 1→1.
- iter-050: +5 axiom-clean (`GeneratingSections.map`/`map_I`/`map_isFiniteType` engine, seam-1a `gf_localGenerators_restrict` [the STUCK make-or-break gate, now CLEARED], assembly `gf_finiteType_affine_finite_cover_generated`); seam-1 chain COMPLETE; sorry 1→1.
- Recurring blocker: G1 (`gf_qcoh_fintype_finite_sections`) reduces to a gap1-hard Spec-transport base case (sub-steps a/b/c); G3 (`gf_flat_locality_assembly`) gap1-independent, Mathlib-anchored; `genericFlatness` still 1 sorry.
- iter-051 proposal: GF lane attempts G3 + the new G1 base case, then close genericFlatness.

## Route GR-quot — `Picard/GrassmannianQuot.lean` (NEW, parallel)
- STRATEGY: Iters-left 6–12; phase entered iter-050 (fresh).
- iter-050: NEW file + root import; +3 axiom-clean (`globalUnitSection`, `scalarEnd`, `chartQuotientMap` headline); +5 scaffolds (`glue`, `universalQuotient`, `tautologicalQuotient`, `functor`, `represents`); sorry 0→5 (all intentional signature scaffolds).
- Next ingredient fully specified: `Epi chartQuotientMap` (split-epi, ≥5-lemma chain); `glue` signature must-fix (missing cocycle hyps).
- iter-051 proposal: GR-quot lane builds `Epi chartQuotientMap` + fixes `glue` signature.

## Route SNAP — `Picard/SectionGradedRing.lean`
- STRATEGY: Iters-left 3–6; CHURNING flagged iter-050 (grace = 1 iter).
- iter-047: +10 axiom-clean (layer-1 tensor powers/unitors/braiding/counit).
- iter-049: +1 axiom-clean (`sectionsMul`, last associator-free target).
- iter-050: NO prover (CHURNING corrective = mathlib-analogist consult; route re-decided to Analogue 1; blueprint re-routed crux `isIso_sheafification_whiskerRight_unit`). NOT another helper round.
- iter-051 proposal: first prover attempt on the NEW route — build crux `isIso_sheafification_whiskerRight_unit` (Analogue 1: abelian W.monoidal coequalizer transfer) → `tensorObjAssoc` → `tensorPowAdd`.

## Question
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) + corrective TYPE for any CHURNING/STUCK. Dispatch-sanity: is the 3-file objective set (FlatteningStratification, GrassmannianQuot, SectionGradedRing) sound, or is any lane walking into a repeated wall?
