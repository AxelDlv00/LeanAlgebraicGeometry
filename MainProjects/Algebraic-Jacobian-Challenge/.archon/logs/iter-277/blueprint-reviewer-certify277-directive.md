# blueprint-reviewer — certify277 (DAG iter-277, whole-blueprint)

You are the whole-blueprint auditor for the Algebraic-Jacobian-Challenge DAG phase.
Audit the ENTIRE blueprint as you always do (per-chapter completeness + correctness
checklist, Lean-target well-formedness, multi-route coverage, and the standard
`### Dependency & isolation findings` section). Do NOT scope-limit — the cross-chapter
view is the point.

## Live DAG state (leandag, rebuilt this iter)

- 880 blueprint nodes (443 proved, 1 mathlib), 1490 edges, 54 lean-aux uncovered,
  2 ∞-effort nodes, 0 broken `\uses{}`, 0 ∞ blueprint sources (`archon dag-query gaps`
  = 0 of 0), `Isolated (no edges) = 56 (2 blueprint)`, content.tex 38/38.
- The 54 uncovered lean-aux are ALL in the two actively-churning A.1.c.sub prover-lane
  files (`Picard/TensorObjSubstrate.lean` 40, `Picard/TensorObjSubstrate/DualInverse.lean`
  14), both untracked WIP carrying 31 live sorries between them. Standing policy (iters
  274–276): cover once the lane's sorry count stops moving — the loop's plan/review
  agents handle `\lean{}` repinning as names drift. **You are NOT being asked to re-litigate
  that deferral**; just confirm the consolidated chapter `Picard_TensorObjSubstrate.tex`
  (which `% archon:covers` all five TensorObjSubstrate files) is mathematically faithful
  and clears the HARD GATE for the active DUAL/ENGINE/D3′ lanes.

## The one decision I need from you — disposition of the 2 isolated blueprint leaves

Both live in `blueprint/src/chapters/RigidityKbar.tex` (NOT a protected file):

1. `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable` (line ~2252) — "(S3.sep.2)
   geometrically-reduced finite field extension is separable" (Stacks 0BUG part 4).
2. `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` (line ~2357) —
   "(S3.pi.2) purely inseparable from unique minimal prime of base change" (Stacks 030K).

Both are LEAF "closer" lemmas (empty `\uses{}`, self-contained proofs from Stacks tags)
of **path (b)** of `lem:constants_integral_over_base_field`. Established facts:

- Their ONLY notional consumer is the **path-(b) assembler inside
  `lem:constants_integral_over_base_field`**, which was DROPPED at the iter-152 alg-closed
  pivot: `constants_integral`'s live proof is path (a) (alg-closed one-liner via
  `IsAlgClosed.algebraMap_bijective_of_isIntegral`); its `\uses{}` is empty and the in-file
  NOTEs say it "no longer uses" the S3 cluster.
- Their sibling gateway lemmas `lem:S3_sep_1_...` (uses `lem:S3_pi_1_...`) and
  `lem:S3_pi_1_...` form the rest of the path-(b) cluster; that cluster is off the goal
  cone (`lem:S3_sep_1` has rdep_count 0 — nothing consumes it either).
- A prior-agent NOTE retains them "for the general-over-k route," but **STRATEGY.md does
  NOT track any general-over-k route** — the live strategy proves rigidity only over an
  algebraically closed base (alg-closed pivot), and Route C (Riemann–Roch) is
  permanently USER-paused. So these leaves back a route the current strategy does not pursue.

For EACH of the two leaves, give an explicit tag in your `### Dependency & isolation
findings`:
- **`wire-up`** — only if you can name an HONEST existing consumer whose proof genuinely
  uses the leaf (an edge that is currently missing). If the only honest consumer is the
  dropped path-(b) assembler, `wire-up` is NOT available — say so.
- **`remove`** — if you judge the leaf is genuinely dead scaffolding for an
  unpursued/abandoned route, safe to delete via the gated removal flow. Note: the lemmas
  are mathematically correct and fully Stacks-cited; weigh whether deletion loses
  documented value vs. converting to a `remark` (remarks leave the graph).
- **`keep`** — if you judge they should stay as documented off-cone exempt scaffolding
  (the disposition of iters 274–276). If `keep`, state explicitly that the resulting
  nonzero isolated-blueprint count is an acceptable terminal state for this blueprint.

I will act on your tags next: `remove`/`wire-up` become a scoped follow-up; `keep` is
recorded as an exemption.

## Output

Your standard whole-blueprint report to `task_results/blueprint-reviewer-certify277.md`,
including the per-chapter checklist, any must-fix-this-iter findings, the
`## Unstarted-phase blueprint proposals` section (if any phase lacks coverage), and the
`### Dependency & isolation findings` with the two explicit leaf dispositions above.
