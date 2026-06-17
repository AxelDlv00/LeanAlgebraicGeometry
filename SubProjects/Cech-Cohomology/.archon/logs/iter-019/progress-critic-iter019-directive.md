# Progress-critic directive — iter-019

Assess convergence per active route over the last K=4 prover iterations (note: iter-017's
prover phase never ran — `failed_all_noop` — so there is no iter-017 trajectory data; the
prover iters are 015, 016, 018). For each route below: signals are sorry-count per prover iter,
axiom-clean helper decls added per prover iter, prover status, and recurring blocker phrases.
Then judge the planner's proposed iter-019 objective list (bottom).

## Route 1 — CechAcyclic.lean (P3 standard-cover Čech vanishing, L1 bridge)
- Phase entered current form (Q4 absolute-section redesign): iter-017. Strategy `Iters left`: ~4–6.
- iter-015: sorry 1→1; +9 axiom-clean (`CombinatorialCech.*`, L3 constant contracting homotopy).
- iter-016: sorry 1→1; +9 axiom-clean (`CombinatorialCech.Dependent.*`, L3 dependent port, ends `depDiff_exact`).
- iter-018: sorry 1→1; +22 axiom-clean (`AwayComparison.*` 11 + `CechLocalized.*` 11, ending capstone
  `cechLocalized_exact` = positive-degree exactness of the section complex localised at a spanning element).
- Recurring fact: the single sorry (line ~109) is the OLD relative-form `CechAcyclic.affine`,
  explicitly SUPERSEDED by the iter-017 Q4 redesign and intentionally left untouched. The real
  target is the section-complex form (`sectionCech_affine_vanishing`), built bottom-up; the named
  decls do not exist yet, so the loop's sorry-count cannot see the progress.
- Prover status iter-018: PARTIAL — "stopped at a clean architectural boundary, not a blocker."
  Handed off a precise 3-step decomposition (D• module complex + `exact_of_isLocalized_span`
  IsLocalizedModule.pi step → `qcohSectionsAwayLocalized` → `section_cech_homology_exact`).
- Blocker phrases: none repeating; each iter built a distinct sub-layer (L3 const, L3 dep, localisation algebra).

## Route 2 — FreePresheafComplex.lean (P3b free side, `cechFreeComplex_quasiIso`)
- Phase entered: iter-016 (file split out). Strategy `Iters left` (P3b): ~4–7.
- iter-016: sorry 0→0; +8 axiom-clean (`cechFreePresheafComplex` + simplicial backbone).
- iter-018: sorry 0→0; +3 axiom-clean +1 repaired broken proof (`cechFreeComplexAug` augmentation chain map).
- Target `cechFreeComplex_quasiIso` NOT landed in either prover iter (large ~250–450 LOC homotopy + objectwise reduction).
- Prover status iter-018: PARTIAL — building blocks all verified present in Mathlib; precise 3-step
  decomposition handed off (objectwise reduction / sectionwise free-module description / contracting homotopy).

## Route 3 — CechBridge.lean (P3b bridge, `cechComplex_hom_identification`)
- Phase entered: iter-017 (file created). First prover data point = iter-018.
- iter-018: sorry 0→0; +5 axiom-clean (entire mathematical core: cosimplicial Hom, per-degree iso,
  projection-characterisation, naturality). Target `cechComplex_hom_identification` held back
  OPERATIONALLY — the imported FreePresheafComplex.lean was broken by a concurrent lane the whole
  session, so the import chain would not build; recipe for the final 2 decls fully derived and handed off.
- Prover status iter-018: PARTIAL (operational block, now resolved — FreePresheafComplex compiles).

## Route 4 — HigherDirectImagePresheaf.lean (P5a 01XJ leaf)
- Phase entered: iter-018 (new file). First prover data point = iter-018.
- iter-018: sorry 0→0; +6 axiom-clean (reusable 01XJ engine `homologyIsoSheafify` + resolution form
  `higherDirectImage_iso_sheafify_presheafHomology`). Named target (absolute-cohomology-presheaf form)
  not built — a deliberate design-fork avoidance; resolves to a planner blueprint re-sign (option 1).

## Planner's proposed iter-019 objectives (4 files, but only 3 prover lanes)
1. `CechBridge.lean` — type the 2 derived decls to land `cechComplex_hom_identification` (operational block cleared).
2. `FreePresheafComplex.lean` — continue building toward `cechFreeComplex_quasiIso` (the homotopy lane).
3. `CechAcyclic.lean` — continue L1: build D• + `exact_of_isLocalized_span` step (the handed-off step 1).
4. `HigherDirectImagePresheaf.lean` — NO prover; re-sign blueprint to the resolution form (already proved) + wire root import.

Give a per-route verdict (CONVERGING / UNCLEAR / CHURNING / STUCK) and, for any CHURNING/STUCK,
name the corrective type. I am specifically unsure whether Route 1 (CechAcyclic, sorry 1→1→1 across
three prover iters but +40 distinct axiom-clean decls toward a redesigned target) is churning or
genuine slow multi-step progress.
