# Iter-223 (Archon canonical) — review

## Outcome at a glance

- **The "mandate missed, obstacle re-characterized" iter.** Sub-step 3 of the funded Decision-1
  sheaf internal-hom build (committed iter-219; ~6–12 iter estimate; **elapsed 5**; sub-step 3
  spanning iters 221→223). One prover (opus, `prove` mode), status **PARTIAL / BLOCKED**.
- **The iter-222 mandate was NOT met.** iter-222 review: *"iter-223 MUST close it (sorry 81→80),
  not propagate it."* The naturality `sorry` of `internalHomEval` is **still open** — re-verified
  this review: `#print axioms PresheafOfModules.internalHomEval` = `{propext, sorryAx,
  Classical.choice, Quot.sound}`. **Project sorry 81 → 81** (flat for the second consecutive iter:
  80→81 in 222 by stubbing, 81→81 in 223).
- **What it DID produce:** a decisive negative finding. iter-222's diagnosis (bomb localized to the
  single `restr_map_homMk (𝟙_) f` step; three "whnf-free" routes) is **WRONG** — all three routes
  bomb on their FIRST rewrite. The `whnf` toxicity is goal-wide (Mathlib's
  `PresheafOfModules.Monoidal.tensorUnit` machinery, `kabstract`→`isDefEq`→`whnf`, ~exponential),
  not lemma-localized; `local irreducible` on project defs cannot shield it. The prover also
  confirmed the exact lemma the next route needs (`tensorUnit_map`) and preserved the six-step
  reduction in-source.
- **Build GREEN; blueprint-doctor CLEAN.** `sync_leanok` iter 223, sha `097055c7`, **+0 / −0**.

## The defining tension — honest non-closure vs a missed hard mandate

iter-223 must be reported as both, not rounded:

- **Forward (real):** the obstacle is now correctly understood. iter-222 sent the next prover down
  three routes that were all dead on arrival; iter-223 spent ~12 authoritative `lake env lean`
  bisection compiles to prove that and to pin the true blocker — a structural Mathlib-API gap
  (`whnf`-free naturality discharge for a `𝟙_`-codomain `PresheafOfModules.Hom`), not a math gap.
  That re-characterization is what makes the iter-224 escalation well-posed instead of another blind
  retry. The math itself is complete (six steps individually sound).
- **Back (real):** the project sorry counter has not moved down since iter-217 (81→80), and has been
  pinned at 81 across the two iters since the iter-222 stub. The eval-counit naturality has now
  resisted closure for the entire span of sub-step 3. The iter-222 review's explicit "MUST close"
  bar was not cleared. This is a genuine **STUCK** on the naturality sub-goal — no structural advance
  on *closing* it, only on *understanding why it won't close by the planned means*.

## Process correctness

- **The prover behaved correctly under a hard wall.** No new `dual`-shaped helper-sorry (the
  iter-214 d.1 anti-pattern avoided), no `maxHeartbeats` brute force (forbidden), no regression
  (4→4). It momentarily wrote "sorry closed / axiom-clean" docstrings off the back of
  `lean_multi_attempt`'s empty-diagnostics false positive, then **reverted them** once the
  authoritative `lake` compile exposed the bomb. That self-correction is the right behaviour; the
  lean-auditor ts223 pass (dispatched this review) independently checks no false claim survives.
- **The planner's pre-committed reversal signal fired exactly as designed.** iter-223 plan recorded:
  *"whnf bomb STILL present + none of routes #2/#1/#3 close the sorry → iter-224 runs the
  mathlib-analogist consult BEFORE any further dispatch."* This is the outcome. The corrective is
  pre-named and structural (an API-shape consult), so no route-change beyond that is warranted yet —
  but iter-224 must NOT re-dispatch the same syntactic approach, and the planner should hold the
  fallback (revert `internalHomEval` to ABSENT, sorry 81→80) ready if the analogist dead-ends.
- A note for the iter-224 progress-critic directive: this is the route's **second** consecutive
  no-downward-move iter on the same target. Mechanically that reads CHURNING/STUCK; the mitigating
  fact is that iter-223 converted a vague blocker into a precise, escalatable one. The critic should
  weigh whether the analogist consult is genuinely a new corrective TYPE (it is) vs. a dressed-up
  retry (it is not, provided the prover does not re-run rw/erw/simp on the same goal).

## Environment confounder (do not mis-budget iter-224)
The prover reported a severely degraded harness this session: empty `Bash`/`Read`/`lean_*`
returns and stale/batched `lean_diagnostic_messages` (phantom errors while `lake` showed the true
bomb). It fell back to `lake env lean … ; echo EXIT=$?` polling. This inflated each compile cycle
to minutes and is an environment factor, not evidence the math hardened.

## Review subagents (both 0 must-fix)
- **lean-auditor ts223** (`logs/iter-223/lean-auditor-ts223-report.md`) — 3 major / 2 minor /
  **0 must-fix**. Both focus areas PASS: no over-optimistic "sorry closed" language survived the
  prover's revert; file-header sorry count (4) accurate. The 3 majors are stale docstrings
  (L1644 `tensorObj_assoc_iso`, L1937 `tensorObjOnProduct`, L1926–7 `exists_tensorObj_inverse`
  comment) — MEDIUM, polish-pass material.
- **lean-vs-blueprint-checker ts223** (`logs/iter-223/lean-vs-blueprint-checker-ts223-report.md`) —
  5 major / 3 minor / **0 must-fix**. `internalHomEval` / `lem:internal_hom_eval` PASS: no overclaim,
  `% NOTE:` accurate, pin correct, statement faithful. The 5 majors are the known `sync_leanok`
  multi-pin gap (3 blocks), a missing `internalHomEvalApp` pin, and a stale file-header docstring —
  all non-blocking / standing-deferral.
- Findings + actions landed into `recommendations.md` (none block the iter-224 escalation; bundle
  into the deferred polish pass).
