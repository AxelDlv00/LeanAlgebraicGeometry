# Iter-005 plan — horseshoe decomposed, DAG-poisoning fixed, P4 prover dispatched on the new leaves

## Context

iter-004 ran the P4 lane (`mathlib-build` on `AcyclicResolution.lean`) and built every *consumer*
of the horseshoe (5 axiom-clean decls), collapsing the entire P4 chain to ONE remaining
construction — the horseshoe object `InjectiveResolution.ofShortExact`, a monolithic ℕ-recursion
the prover correctly declined (no sorry-free partial fragment). Two carry-forward must-fixes from
the iter-004 review: (1) a false `\leanok` on `lem:injective_resolution_of_ses` (DAG poisoning via
a `sync_leanok` code-fence false-positive); (2) decompose the horseshoe before re-dispatching.

## What I did (this plan phase)

1. **Round 1 (parallel, 3 subagents):**
   - `progress-critic` (P4 route): **UNCLEAR** (route fresh — 1 effective prover iter; iter-003
     was a mechanical noop). No CHURNING/STUCK. Key steer: treat the same-iter scoped re-review +
     prover dispatch as a HARD requirement, not optional — deferring the prover would risk the
     plan-phase-only churn pattern. Decompose-then-build is the correct response to the monolith.
   - `refactor` (fence-fix): reformatted the backtick `def InjectiveResolution.ofShortExact` fence
     in the `.lean` strategy comment to `-- `-prefixed prose. File compiles, 0 sorries. The
     DAG-poisoning root cause is gone; `sync_leanok` will strip the false `\leanok` this iter.
   - `effort-breaker` (horseshoe): **COMPLETE** — split `lem:injective_resolution_of_ses` into a
     7-link `\uses`-chain (2 verified `\mathlibok` anchors, 1 project-decl anchor, **4 new provable
     sub-goals**: `ofShortExact_twist`/`_dComp`/`_chainMap`/`_resolvesMiddle`). Kernel isolated to
     `lem:horseshoe_twist` (the τ cocycle recursion); a 3-way re-break is on standby if it stalls.
2. **blueprint-clean** on the chapter (stripped Lean/process leakage from the new subsection).
3. **whole blueprint-reviewer** (`iter005`): `Cohomology_AcyclicResolution.tex` **PASSES the HARD
   GATE** — `complete: true`, `correct: true`; both `\mathlibok` anchors verified faithful
   (`Injective.instBiprod`, `ShortComplex.Splitting.ofHasBinaryBiproduct`); all 7 sub-lemma
   sketches adequate; `lem:horseshoe_twist` needs NO finer re-break. One "soon" finding
   (imprecise exactness citation in the twist proof) — **fixed directly in the blueprint** (cited
   `InjectiveResolution.exact` + `d_A∘d_A=0` instead of the wrong `lem:right_derived_injective_resolution`).
   `Cohomology_CechHigherDirectImage.tex` `complete: partial` — solely the documented P3 blocker
   (deferral recorded, no writer dispatched, per the reviewer's own recommendation).
4. Wrote the single ready prover lane (P4 horseshoe sub-goals + assembly, `[prover-mode: mathlib-build]`,
   phrased as a build/scaffold dispatch so plan-validate doesn't noop the zero-sorry file).

## Decisions made

### D1 — Go the same-iter fast path: decompose AND dispatch the prover this iter (not decompose-only).
- **Why**: the progress-critic was explicit that a decompose-only iter (no prover) would be
  avoidance, not caution, and would bring the plan-phase-only churn pattern within one iter. The
  effort-breaker decomposition is sound and gate-passed, so there is no reason to wait a whole iter.
  Executed the fast path: effort-breaker → blueprint-clean → whole blueprint-reviewer (gate
  cleared) → prover dispatched THIS iter on the 4 new leaves.
- **Reversal signal**: if the prover stalls on `ofShortExact_twist`, re-dispatch the effort-breaker
  on `lem:horseshoe_twist` with the ready 3-way split (augmentation / inductive lift / cocycle).

### D2 — Single P4 lane; P3/P5 genuinely blocked (honest serialization, parallelism directive considered).
- P4 is the only gate-cleared, statement-sound lane and is a single bottom-up dependency chain in
  one file — not splittable across provers. P3 is blocked by a statement-gap decision (see D3); P5
  needs P3+P4. No second ready lane exists, so this is not under-dispatch (progress-critic
  confirmed dispatch=OK, no under-dispatch finding).

### D3 — P3 statement gap DECIDED: narrow the `CechAcyclic.affine` signature (option a), execute next iter.
- **Decision**: narrow to a standard-cover hypothesis. **Confirmed downstream-safe this iter**: a
  grep shows `CechAcyclic.affine` has NO current proof consumer (only its declaration + doc
  comments; `cech_computes_higherDirectImage` is still a `sorry`), so narrowing breaks nothing.
- **Why next iter, not this iter**: the narrowing needs a precise "standard affine cover" Lean type
  — non-trivial design that should not be rushed alongside the P4 decomposition. Teed up in
  PROGRESS.md Deferred + task_pending. This is the genuine parallel-lane opportunity (it also
  unblocks the deferred file-split of `CechHigherDirectImage.lean`); executing it next iter opens
  a real second lane once P4 is past its kernel.

### D4 — Fix the false `\leanok` at the root (refactor the fence), not by hand-editing markers.
- `\leanok` is sync_leanok's domain. The real fix is the `.lean` fence (done by the refactor);
  sync_leanok strips the false markers automatically this iter. I told the blueprint-reviewer this
  is a known auto-resolving artifact so it would not count it as a content must-fix (it did not).

## Deferred (recorded, not blocking)

- **P3 blocker** (`Cohomology_CechHigherDirectImage.tex` `complete: partial`): `lem:cech_to_cohomology_on_basis`
  awaits a Mathlib basis-comparison criterion — a build dependency, no writer action resolves it.
  Recorded per the blueprint-reviewer's recommendation; NOT a writer dispatch.
- **Coverage debt** (non-gating): 4 already-proven iter-004 decls in `AcyclicResolution.lean` still
  lack `\lean{}` blueprint blocks (incl. the substantive `rightDerivedShiftIsoOfSplitResolutionSES`,
  which folds under `lem:acyclic_dimension_shift` as the resolution-level precursor). Add next iter.

## Subagent skips

- strategy-critic: STRATEGY.md route unchanged since iter-003 (single extraction commit; the only
  edits this iter are a same-route P4 estimate/decomposition refresh, not a route change); the P4
  horseshoe route was independently confirmed cheapest/necessary by mathlib-analogist (iter-003) and
  no live CHALLENGE remains. Skip condition (SHA-stable route + prior SOUND + no live challenge) met.
