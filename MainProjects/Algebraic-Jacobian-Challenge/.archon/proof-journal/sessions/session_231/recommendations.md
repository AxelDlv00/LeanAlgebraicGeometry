# Recommendations — after iter-231 (review)

## CRITICAL — the hard gate FAILED; bind the pre-committed correctives, do NOT re-scope a fifth time

iter-231's HARD GATE (PASS = 80→79 OR `dual_restrict_iso` axiom-clean) **FAILED** — 0 prover edits,
sorry 80→80. This is the pre-committed terminal node of the iter-227→231 escalation chain. The iter-230
*and* iter-231 plans both pre-committed: on a gate FAIL, **no fifth same-shape re-scope**. Honour that.
The next plan agent must NOT dispatch another "build `dual_restrict_iso` as one monolithic lemma behind
a gate" round — that exact dispatch has now failed across iters 227, 228, 229(consumer), 230(probe), 231.

The two pre-committed FAIL correctives, in priority order:

1. **FILE-SPLIT `TensorObjSubstrate.lean` (do this first — it is cheap, structural, and unblocks
   everything else).** The file is 2375 lines; the prover spent most of its budget just reading it, and
   that re-read cost recurs every iter. Quarantine into separate files: (a) the vestigial whiskering/stalk
   apparatus (L426–725, includes the forbidden L691 sorry); (b) the dead slice-site root (L2264–2375);
   leaving a small dedicated file holding the live dual + inverse surface. This honours the USER
   parallelism directive AND removes the per-iter context tax. Dispatch the `refactor` subagent for this
   (it inserts `sorry` at split boundaries, never fills proofs). **Lowest-risk, highest-leverage action.**

2. **If continuing on the dual: decompose `dual_restrict_iso` into an EXPLICIT multi-iter sub-build,
   first iter lands ONLY the coherence-risk-free piece.** Per the prover: land the per-`V` slice
   equivalence `Over_Y V ≌ Over_X (f.opensFunctor V)` (the per-`V` shadow of `Opens.overEquivalence`) as
   a standalone axiom-clean `def` — the one piece with NO module-coherence risk — so each iter can pass an
   "axiom-clean sub-lemma" bar incrementally instead of all-or-nothing. The `Over.map` module-coherence
   transport (`β = f.appIso` ring-iso) is the genuinely hard residual and gets its own later iter.

## HIGH — route II (pivot inverse off the dual) does NOT actually dodge the C-bridge

The prover flagged this honestly and it must be carried forward so the planner does not mis-bill route II
as an escape: object-gluing `exists_tensorObj_inverse` from local contractions
`(L ⊗ dual L)|_{Uᵢ} ≅ 𝒪_{Uᵢ}` **still transitively needs `dual_isLocallyTrivial` → `dual_restrict_iso`**.
It sidesteps the *global associator/whiskering* machinery but inherits the same C-bridge dependency.
Treat it as a partial escape, not a whole-block break. If the planner adopts route II, the gating piece
is unchanged — so corrective (2) above is still the real work either way.

## HIGH — the one signal the gate failure did NOT produce, and how to cheaply get it

The iter-231 plan named its "cheapest reversing signal": *does the objectwise `V⊆U` map even typecheck,
or is the slice-end value at `V` genuinely not defeq to the sectionwise hom module?* The tool latency
prevented the prover from ever attempting the build, so **this datapoint is still missing**. Before
committing another multi-iter sub-build, a *cheap* next round should: in scratch (not the frontier file),
state the objectwise map and run `lean_goal`/`lean_multi_attempt` on JUST the value-level defeq — a
single targeted probe, not a 200 LOC build. The mathlib-analogist (ts231ih) said near-definitional;
blueprint-clean sized it ~150–300 LOC. That contradiction is the crux and a 10-line probe resolves it.

## MEDIUM — environment: one-batch-behind harness tool latency hit BOTH phase agents for 2 iters

The prover and the iter-231 plan agent independently reported a harness display/latency fault (tool
results arriving one batch late, in delayed bursts). It caused two plan-phase confabulation near-misses
and made the prover's read→edit→verify loop infeasible. This is an environment condition the agents
cannot fix and it materially degraded iter-231. Surfaced in `TO_USER.md`. If it persists, a categorical
build that needs tight LSP round-trips is effectively un-runnable; the file-split (corrective 1) partly
mitigates by shrinking the read surface.

## MEDIUM — resolve the orphan blueprint chapter

`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (14 KB) is orphaned — not `\input` by
`content.tex` (blueprint-doctor finding). It was created by the pkill'd `cohflatbc` writer and the plan
agent says it is **subsumed by the proposed `Picard_HigherDirectImages.tex`**. Next plan agent: either
delete it or migrate its content into `Picard_HigherDirectImages` and add the `\input` line. It currently
renders into nothing.

## MEDIUM — begin A.2.c engine blueprint coverage (the parallel-lane payoff)

strategy-critic ts231 (CHALLENGE, adopted by the plan) noted the substrate, even closed, unblocks only
the parked A.2.c engine (~3400–5500 LOC, Mathlib-absent), and the strategy has no "what fills the
parallel lanes" answer. The blueprint-reviewer ts231 proposed three ungated-root chapters:
`Picard_HigherDirectImages.tex` (`R^i f_*`, Stacks 02KH + Nitsure §3), `Picard_CMRegularity.tex`
(Castelnuovo–Mumford, Nitsure §2), `Picard_SemiContinuity.tex` (Nitsure §3). The iter-231 writer slot
went to the gate-failing `cbridge` fix; these three are DEFERRED. Next plan agent: dispatch one
blueprint-writer per chapter so the file-split's parallelism has actual WORK to land on — otherwise the
file-split enables parallelism with nothing to parallelize.

## Do-NOT-retry list (carry forward)
- **`dual_restrict_iso` via the iter-229 shared root `overSliceSheafEquiv`** — falsified iter-230 (sheaf
  vs presheaf; fixed-value-cat vs varying-ring module; whole-`U` vs per-open slice). Already in the
  PROJECT_STATUS Known Blockers.
- **`dual_restrict_iso` as a single monolithic axiom-clean lemma in one iter** — failed iters 227–231.
  Only attempt it as an explicit decomposed multi-iter sub-build (corrective 2).
