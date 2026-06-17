# Progress Critic Directive

## Slug
p4t3

## Iter
007

## Active routes / files under review

### Route: P4 abstract acyclic-resolution lemma → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

- **Started at iter**: 003 (iter-003 prover phase was a mechanical NOOP — the
  zero-sorry file was dropped by the dispatch filter; first *effective* prover
  iter was 004).
- **Iters audited**: 004–006.

> IMPORTANT METRIC NOTE: this lane runs under `[prover-mode: mathlib-build]`. It
> *builds new axiom-clean infrastructure declarations* rather than closing
> `sorry`s in this file. The file has had **0 sorries throughout** (the two
> global sorries are in a different file, out of scope). So "sorry count 0→0" is
> EXPECTED and is NOT a stall signal here. The real progress metric is
> **(i) axiom-clean declarations added per iter** and **(ii) named P4 blueprint
> targets closed per iter**. Both are given below.

#### Sorry counts per iter (this file)
- iter-004: 0
- iter-005: 0
- iter-006: 0
(All axiom-clean, `{propext, Classical.choice, Quot.sound}` only. mathlib-build lane.)

#### Declarations added per iter (axiom-clean)
- iter-004: +5 (all *consumers* of the horseshoe: the dimension-shift engine
  `rightDerivedShiftIsoOfSplitResolutionSES` + 4 supporting decls)
- iter-005: +27 (the horseshoe *core*: twisted-biproduct complex, the τ twist
  recursion + cocycle; 3 of 4 decomposed horseshoe sub-goals)
- iter-006: +14 (the missing-from-Mathlib `quasiIso_τ₂`, the middle-resolution
  quasi-iso, horseshoe assembly, object-level dimension shift)

#### Named P4 targets closed per iter
- iter-004: 0 of 3 named targets (built infra consumers only; correctly declined
  the horseshoe monolith — no sorry-free partial fragment existed)
- iter-005: 0 of 3 named (built 3 of 4 horseshoe sub-leaves; the 4th
  `_resolvesMiddle` blocked on an absent Mathlib lemma)
- iter-006: **2 of 3 named targets** — TARGET 1 (horseshoe `ofShortExact`) ✅,
  TARGET 2 (dimension shift `rightDerivedShiftIsoOfAcyclic`) ✅, plus the
  `quasiIso_τ₂` supplement that had been the sole gap. TARGET 3 (the staircase
  `rightDerivedIsoOfAcyclicResolution`) declined — needs an effort-break.

#### Prover statuses per iter
- iter-004: PARTIAL — built all consumers; declined the horseshoe monolith (no
  axiom-clean partial), handed off a precise decomposition.
- iter-005: PARTIAL — built horseshoe core (3/4 sub-goals); blocked on absent
  `quasiIso_τ₂`, handed off a concrete recipe (homology five-lemma window).
- iter-006: PARTIAL/COMPLETE — built `quasiIso_τ₂` + closed TARGET 1 & 2;
  declined TARGET 3 as a separate multi-lemma construction, handed off a precise
  (a)+(b) decomposition recipe.

#### Prover count per iter (files dispatched)
- iter-004: 1 of 1 truly-ready (P4 only ready lane; P3 blocked by statement gap, P5 needs P3+P4)
- iter-005: 1 of 1 truly-ready
- iter-006: 1 of 1 truly-ready

#### Recurring blocker phrases
- "declined the monolith / needs effort-break / handed off a decomposition"
  appears iter-004, iter-005, iter-006 — BUT each time the decomposition was a
  DIFFERENT, strictly-smaller residual (horseshoe monolith → horseshoe core +
  quasiIso_τ₂ → TARGET 3 (a)+(b)). The blocker target shrank every iter; this is
  the decompose-then-build pattern, not a repeated wall on the same goal.
- "absent from Mathlib" — iter-005 (`quasiIso_τ₂`); RESOLVED iter-006. No longer live.

#### Route status changes per iter
- iter-004: active
- iter-005: active
- iter-006: active

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (verbatim, P4 row): "~2–4"
- **Elapsed iters in current phase**: 4 effective (004–007; 003 was a NOOP)
- **Phase started at iter**: iter-003 (effective 004)

#### Planner's current proposal for this iter
Effort-break TARGET 3 (`lem:acyclic_resolution_computes_derived`) into the
prover-recommended (a) base-case coker iso (= part (2) of the dimension-shift
lemma) and (b) cosyzygy-SES staircase leaves; blueprint-clean + scoped
blueprint-review to clear the HARD GATE; then dispatch ONE prover lane
(mathlib-build) on `AcyclicResolution.lean` to build the (a)+(b) leaves and
assemble the staircase. This is the same decompose-then-build fast path that
carried iters 005→006.

## PROGRESS.md proposal (this iter)

- **File count**: 1
- **Files**: `AcyclicResolution.lean`
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**:
  none. The other 3 leandag-frontier nodes (`cech_to_cohomology_on_basis`,
  `cech_augmented_resolution`, `higher_direct_image_presheaf`) all live in
  `CechHigherDirectImage.lean`, whose chapter is `complete: partial` (open P3
  standard-cover-vs-general-cover statement gap) and which carries the two
  global sorries — it FAILS the blueprint HARD GATE and its targets are not
  closeable build targets yet (P5 needs P3 + completed P4). So there is no
  second ready lane.
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
- P3 (`CechAcyclic.affine`) and P5 (`cech_computes_higherDirectImage`) — both in
  `CechHigherDirectImage.lean`, blocked (P3 statement gap; P5 needs P3+P4). Not
  considered for dispatch this iter.
