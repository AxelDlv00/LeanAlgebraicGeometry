# Progress Critic Report

## Slug
routeb

## Iteration
044

## Routes audited

### Route: B — QcohTildeSections.lean (01I8 keystone, sheaf-axiom equalizer route)

- **Sorry trajectory**: 2 → 2 → 2 → 2 across iters 040–043. Invariant by design: both sorries are in other, frozen/superseded files; `QcohTildeSections.lean` is and has been 0-sorry throughout. Sorry count is not the throughput signal here — axiom-clean decls added is.
- **Helper accumulation**: +4 (iter-040, sibling file) +3 (iter-041) +1 (iter-042) +2 (iter-043) = 10 axiom-clean decls across 4 iters; named targets `tile_section_comparison` / `tile_section_localization` have not landed in any iter.
- **Prover dispatch pattern**: 1 of N dispatched each iter (directive does not supply the ready-count; no under-dispatch finding can be confirmed from available data).
- **Recurring blockers**: "Sub-lemma B section comparison is non-definitional / cross-ring `ModuleCat R_g` vs `ModuleCat R`" appears in iter-042 and iter-043 reports. **The framing changed between the two**: iter-042 = "~150 LOC non-definitional wall"; iter-043 = "two scalar bridges are rfl; residual = ONE ring identity ~30–50 LOC, closable by `IsLocalization.Away` uniqueness or `ΓSpecIso` naturality." The phrase recurs but the obstruction shrank, so this is not the full-stall pattern the rule targets — nonetheless it has recurred across 2 iters.
- **Avoidance patterns**: None. No off-critical-path reclassifications. No consecutive plan-only iters. No persistent deferral language.
- **Prover status pattern**: PARTIAL (iter-041), PARTIAL (iter-042), PARTIAL (iter-043) — **three consecutive PARTIALs**.
- **Throughput**: SLIPPING — STRATEGY.md estimates ~2 iters for the current phase, elapsed = 3 iters (041, 042, 043). Not yet OVER_BUDGET (threshold = 4 iters).
- **Verdict**: **CHURNING**
- **Primary corrective**: **Blueprint expansion** — sequence the prover dispatch AFTER the blueprint-writer delivers the updated `lem:tile_section_comparison` sketch.

  **Why.** The CHURNING trigger fires verbatim on the "PARTIAL prover status ≥3 of last K iters" rule. Every iter produced real axiom-clean decls, so this is not stall-by-inaction — but the named keystone target has not landed in three consecutive rounds, each time handing back a finer decomposition. The iter-043 review explicitly diagnosed the root cause: the `lem:tile_section_comparison` blueprint sketch has become **inaccurate** (overstates the residual 3–5×; the "genuinely non-definitional" and "~100–150 LOC" claims are stale), and the review flagged dispatching a blueprint-writer as a prerequisite for re-dispatching the closer. The plan for iter-044 is already dispatching a blueprint-writer in parallel. **The corrective is to enforce the sequencing**: the prover must read the updated sketch, not the stale one. If the parallel dispatch cannot be sequenced (writer completes before prover starts), the prover must be directed to the in-file documentation exclusively and must NOT rely on the stale `lem:tile_section_comparison` sketch.

  **Secondary corrective**: Validate the in-file "PROVEN tactic prefix" claim before relying on it. The lean-auditor (iter-043) flagged this comment as a potential over-claim: `tile_scalar_compat` was never compiled — only described in a `/-...-/` comment. A prover following the prefix verbatim may encounter unexpected failures. The prover should run `lean_multi_attempt` or `lean_goal` at the relevant position to confirm the prefix produces the claimed single residual goal before building on it.

---

### Informational note — why this is CHURNING-but-close, not CHURNING-by-rotation

The CHURNING trigger fires on the rule (PARTIAL × 3), but the analytical picture is distinctly different from canonical churn-by-helper-accumulation:

- The obstruction has shrunk monotonically each iter: "section-comparison not rfl" (iter-041) → "~150 LOC non-definitional wall" (iter-042) → "one ring identity, ~30–50 LOC, two named closure routes" (iter-043).
- Every prover round landed axiom-clean infrastructure that is genuinely load-bearing.
- The route is NOT going in circles — each PARTIAL changed the residual, not just relabelled it.
- The "recurring blocker phrase" shrank between its two appearances, distinguishing this from a stuck route.

The correct read is: this route is converging rapidly but is being slowed by blueprint-sketch lag. The corrective (blueprint expansion) is already being applied this iter. Once the updated sketch lands and the prover is directed to the validated in-file documentation, the CHURNING trigger should clear — the remaining residual is exactly one ~30–50 LOC structure-sheaf ring identity with two named Mathlib closure routes.

## PROGRESS.md dispatch sanity

Verdict: OK — file count 1 within cap 10; directive does not identify other ready files absent from the proposal, so no under-dispatch finding can be confirmed. No bloat (file count flat at 1 across last 3 iters).

## Must-fix-this-iter

- **Route B: CHURNING** — primary corrective: Blueprint expansion. The blueprint-writer for `lem:tile_section_comparison` must complete and the prover must receive the updated sketch (or be directed to in-file documentation only) before or at the start of prover work. Do NOT re-dispatch the closer against the stale sketch. The iter-043 review stated this prerequisite explicitly: "dispatch a blueprint-writer … before re-dispatching the closer."
- **Route B: SLIPPING** — STRATEGY.md estimates ~2 iters; elapsed = 3. If the 5th dispatch (iter-044) does not close `tile_section_localization`, revise the `Iters left` estimate in STRATEGY.md before iter-045 begins.

## Overall verdict

One route audited (Route B, `QcohTildeSections.lean`). Verdict is CHURNING by the PARTIAL × 3 rule, primary corrective blueprint expansion — already being applied this iter via the parallel writer dispatch. The route is in genuinely good shape mathematically (one ~30–50 LOC ring identity remaining), but the plan must enforce sequencing: prover sees updated blueprint sketch (or in-file documentation only) before the 5th dispatch, and must validate the "PROVEN tactic prefix" comment in the file before relying on it. Throughput is SLIPPING; if iter-044 does not close the keystone leaf, the STRATEGY.md estimate needs a revision to reflect the true remaining work.
