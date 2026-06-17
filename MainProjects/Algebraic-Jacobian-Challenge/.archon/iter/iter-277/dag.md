# DAG iter-277 narrative

## Headline: closed the last non-exempt structural defect — isolated-blueprint 2 → 0. Criterion 5 (54 lean-aux in the active prover lane) is now the SOLE remaining gap to COMPLETE.

The live `leandag` (rebuilt at iter start) matched iter-276 exactly: 54 uncovered
`lean-aux`, 2 ∞-effort lean-aux, 0 broken `\uses{}`, 0 ∞ blueprint sources,
`content.tex` 38/38, **2 isolated blueprint leaves**. Five gate criteria already
passed; the two open items were (4) the 2 isolated leaves and (5) the 54 lean-aux.

I established up front, against the live DAG and STRATEGY.md, what each gap really
is — and which is genuinely actionable this iter:

- **The 54 lean-aux (criterion 5)** are ALL in the two A.1.c.sub prover-lane files
  (`TensorObjSubstrate.lean` 40, `DualInverse.lean` 14), both untracked WIP carrying
  31 live sorries. 52 are sorry-free proved infrastructure; 2 are the lane's current
  sorry targets (the 2 ∞-effort nodes). STRATEGY.md's phases table confirms A.1.c.sub
  is ACTIVE (D3′ STUCK + dual route-2 CHURNING), so these helpers turn over each
  prover iter. Covering them now creates duplicate-pin churn; standing policy (iters
  274–276, reviewer-acknowledged) is to cover once the sorry count stops moving. I
  did NOT thrash this — deferral confirmed sound.

- **The 2 isolated leaves (criterion 4)** — `lem:S3_sep_2_*`, `lem:S3_pi_2_*` — I
  traced to leaf "closer" lemmas of the **abandoned path (b)** of
  `lem:constants_integral_over_base_field`. Path (b) was superseded by the iter-152
  alg-closed pivot (`constants_integral`'s live proof is the alg-closed path (a); its
  `\uses{}` is empty). Their only notional consumer (the path-(b) assembler) was
  dropped. Crucially, **STRATEGY.md tracks no general-over-k route** (the prior-agent
  in-file NOTE "retained for the general-over-k route" reflects no live strategy), and
  Route C (Riemann–Roch) is permanently USER-paused. So these are genuine off-cone
  scaffolding for a route the strategy does not pursue. Unlike iters 274–276 (which
  treated them as "isolation-EXEMPT"), I judged this resolvable and put the question
  to the reviewer.

## What I dispatched

1. **`blueprint-reviewer` (certify277, whole-blueprint, mandatory).** I gave it the
   live DAG state, the standing criterion-5 deferral (asked it only to confirm the
   consolidated chapter's faithfulness, not re-litigate), and the one decision I
   needed: an explicit `wire-up` / `remove` / `keep` disposition on each of the 2
   isolated leaves, with the established facts (no honest consumer; STRATEGY tracks no
   general-over-k route). Verdict: **HARD GATE CLEARS for all active lanes**
   (A.1.c.sub DUAL/ENGINE/D3′, A.2.c-engine, A.1.c.fun OPENING); **all 38 chapters
   `complete: true, correct: true`; no must-fix-this-iter**. Both leaves →
   **`remove`** (`wire-up` explicitly NOT available; nonzero isolated count is NOT an
   acceptable terminal state), conservative form: **convert to `\remark{}`** to keep
   the Stacks-cited math as documentation while removing them from the graph.

2. **`blueprint-writer` (rigiditykbar-remarks277)** to execute the gated `remove`.
   Tight 3-edit directive: convert `lem:S3_sep_2_*` and `lem:S3_pi_2_*` (lemma+proof)
   to `\remark{}` (drop `\label`/`\lean`, preserve all prose + Stacks-0BUG/030K
   citations), and repair the one now-dangling `\cref{lem:S3_sep_2_*}` in
   `lem:S3_sep_1`'s proof. Returned clean; no strategy-modifying findings. (It also
   noted the two former `\lean{}` TODO targets are now unreferenced — recorded for the
   plan agent, out of my scope.)

## leandag: before → after

```
                          iter-start (live)   iter-end (live)
blueprint nodes                 880                878   (−2; leaves → remarks)
lean-aux (uncovered)             54                 54   (active lane; deferred)
edges                          1490               1488
isolated blueprint                2                  0   (−2; criterion 4 CLOSED)
∞ blueprint sources               0                  0
∞-effort lean-aux                 2                  2
broken \uses{}                    0                  0
Unmatched \lean{}                46                 44   (−2; leaves' TODO pins gone)
content.tex                    38/38              38/38
```

Post-edit verification: `grep` shows no `\label`/`\cref` to either leaf;
`leandag build` clean (`unknown_uses: 0`); `archon dag-query gaps` = 0 of 0;
`Isolated (no edges) = 54 (0 blueprint)`.

## Gate status

Criteria 1 (∞ sources), 2 (broken refs), 3 (pins), 4 (isolated-blueprint=0,
**newly closed**), 6 (content.tex) all PASS. Criterion 5 (1-to-1, 54 lean-aux)
is the sole remaining gap, cleanly and entirely attributable to the active,
churning A.1.c.sub prover lane — deferred per standing policy. Status stays
**in_progress** for that one reason; the blueprint roadmap is otherwise a complete,
fully-wired single cone.

## Why not COMPLETE this iter

Honest 1-to-1 coverage (criterion 5) requires covering the 54 lean-aux. They are an
actively-growing prover lane (31 sorries, STUCK/CHURNING per STRATEGY); covering
churning helpers now produces duplicate pins that re-break next prover iter, and the
reviewer classified them as standing-policy deferral, NOT a must-fix. Declaring
COMPLETE would also halt the DAG loop while the lane is still spawning helpers that
need coverage. The correct trigger is lane stabilisation (sorry count on the two
files stops moving), at which point one writer batch covers all 54 without re-churn.

## The 353 rendering findings — explicit deferral (per blueprint-doctor's "address or explain" rule)

The reviewer surfaced 353 soon-severity rendering findings (`literal-ref`,
`math-delim`, `bare-label`, `undefined-macro`) across 25 chapters. I am **deferring
the batch to a dedicated rendering-cleanup iteration**, with rationale:
- **Zero gate impact.** The three active-lane chapters (`Picard_TensorObjSubstrate`,
  `Cohomology_CechHigherDirectImage`, `Picard_RelPicFunctor`) have **zero** rendering
  findings; the HARD GATE is unaffected. All 353 are in inactive/paused/held chapters.
- **Zero leandag impact.** `unknown_uses = 0`; these are `leanblueprint web`
  rendering issues, not dependency-graph breakage.
- **Scope.** A faithful 353-fix pass across 25 chapters (with per-chapter tightly
  scoped writers so prose is not "improved" beyond the fix) is its own focused
  iteration; bundling it with a structural gate-closure iter risks introducing errors.
  `Picard_RelPicFunctor`'s `bare-label`s — flagged as the gate before A.1.c.fun
  prover dispatch — are Kleiman paper-citation labels confined to section-intro prose
  (reviewer: chapter CLEARS the gate), and A.1.c.fun's full close is gated on A.1.c.sub
  (STUCK) anyway, so no prover dispatch on it is imminent.
- **Protected file routed out.** `AbelJacobi.tex`'s 2 `literal-ref` findings (in a
  protected file, in informal remarks) are routed to `TO_USER.md` for the mathematician
  per the dag-prompt rule, not auto-repaired.

## Subagent skips

- strategy-critic: STRATEGY.md not touched by the DAG phase this iter; prior verdict
  (iter-272, carried as skips through 273–276) was uniformly SOUND across all routes
  with no live CHALLENGE/REJECT (the one forward-carry caveat — re-run the Pic≅Cl
  theorem-level disjointness check when A.4 Route 1 is actually built — is not yet
  relevant: A.4 is gated on A.2.c and unstarted). Skip conditions met.
- dag-walker: 0 ∞ blueprint sources (`archon dag-query gaps` = 0 of 0); after the
  remark conversion there are 0 isolated blueprint nodes. The 54 isolated lean-aux are
  criterion-5 coverage debt (active lane, deferred), not untranscribed blueprint
  dependencies — nothing for a cone-walker to wire.
- effort-breaker: 0 ∞ blueprint sources and no high-effort frontier blueprint node to
  decompose; the 2 ∞-effort nodes are sorry-bodied lean-aux (prover targets), which
  have no informal proof to break and are not blueprint sources.
