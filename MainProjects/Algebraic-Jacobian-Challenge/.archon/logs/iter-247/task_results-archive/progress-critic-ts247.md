# Progress Critic Report

## Slug
ts247

## Iteration
247

## Routes audited

### Route TS — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 2 across iter-242 to iter-246. FLAT for 8+ iters (traced
  back to iter-239). Neither `exists_tensorObj_inverse` (L696) nor `addCommGroup_via_tensorObj`
  (L1535) has closed at any point in the audited window. Both are acknowledged structural end-targets
  whose closure gates on D4' (`pullback_tensor_iso_loctriv`).

- **Helper accumulation**: 5 iters (242–246), 15+ axiom-clean declarations landed:
  - iter-242: 2 (presheaf lax/oplax monoidal instances)
  - iter-243: pivot + helpers (loc-triv preservation bricks)
  - iter-244: 7 (D1 `pullbackLanDecomposition` + carriers/adjunctions)
  - iter-245: 2 (reduction brick `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` + helper)
  - iter-246: 4 (`isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`, assembly, converse W-lemma,
    `sheafifyUnitIso`)
  — Zero sorry-elimination across the full 5-iter window.

- **Prover dispatch pattern**: 1 of 1 ready lane dispatched in each of iters 242–246. No
  under-dispatch (FlatBaseChange on documented hold; no other lane ready).

- **Recurring blockers**:
  - Iters 241–243: "Mathlib-scale / pullbackTensorIso confirmed Mathlib-scale / forward bridge
    Mathlib-scale" — three surface descriptions of the same root gap. Correctly diagnosed CHURNING
    at iter-244 and bypassed via the loc-triv pivot.
  - Iter-244: "D2/D3 general strong-monoidal build Mathlib-scale (20–38 iters)" — one appearance;
    bypassed in iter-245 via the reduction brick.
  - Iter-245 and carry-forward iter-246: "η-bridge not yet built (mate calculus)" — now in its
    second iter of mention, but the D2' δ-side WAS addressed in iter-246 (4 axiom-clean decls). The
    η-bridge is being attacked for the FIRST TIME in iter-247 (iter-246 addressed the δ-half of D2'
    first). Not a third repetition of the same wall; first direct attempt scheduled.
  - No "Mathlib-absent" blocker phrase has recurred across ≥3 iters under the loc-triv route. The
    current η-bridge residual is described as "the unit-side analog of the PROVEN
    `pullbackObjUnitToUnit_comp`, NOT a new Mathlib-absent blocker."

- **Avoidance patterns**: None. Active prover dispatch in every audited iter. No off-critical-path
  reclassification. No consecutive plan-only iters.

- **Prover status pattern**: PARTIAL × 5 (iter-242 through iter-246). All five iters produced
  axiom-clean declarations; none produced sorry-elimination.

- **Throughput**: ON_SCHEDULE for the loc-triv phase (entry: iter-245; elapsed: 2 iters; strategy
  estimate for A.1.c.sub: ~7–15 iters). 2 ≤ 7 → on schedule. Note: the pre-loc-triv history shows
  a prior OVER_BUDGET phase (orbit-helper orbit + aborted general build), but those ran under
  different strategic routes now abandoned. The current phase budget is fresh.

- **Verdict: CHURNING**

  **Rule triggers that fire:**

  1. **PARTIAL × 5 → CHURNING**: fires mechanically. Five consecutive PARTIAL prover statuses in
     the 5-iter window.

  2. **Helpers without sorry-elimination → STUCK**: fires mechanically. 15+ helpers added across 5
     iters; zero sorry closures. Technically yields STUCK (worse than CHURNING).

  **Mitigating context (does NOT change the verdict but calibrates the corrective):**

  - The first CHURNING trigger — "helpers added AND sorry flat AND **no structural change in
    approach**" — does NOT fire. Structural changes have been genuine and sequential: iter-243 pivot
    to loc-triv, iter-244 D1 decomposition, iter-245 collapse-to-single-goal reduction brick,
    iter-246 D2' δ-wrapping. Each iter narrowed the residual in a categorically distinct way.

  - The STUCK trigger fires, but the prior iter-246 progress-critic established the correct
    exemption condition for this route's designed sorry-stasis: the sorry counter is DESIGNED to
    stay flat until D4'; STUCK becomes genuinely indicative only if a NEW Mathlib-absent blocker
    appears on the D2'→D4' chain. Iter-246 produced no new Mathlib-absent blocker — the η-bridge
    is a named, tractable mate-calculus step whose analog (`pullbackObjUnitToUnit_comp`) is
    axiom-clean in the same file (L904). The prior critic's STUCK exemption condition is met.

  - Choosing CHURNING (not STUCK) as the operative verdict: the structural-change and
    no-new-blocker context makes CHURNING the more proportionate classification. The route is
    making real forward progress; the sorry-stasis is structural, not evasive. However, this same
    excuse cannot be applied a FOURTH time: if the η-bridge produces yet another "named next
    step" without sorry closure in iter-247, the exemption is exhausted and iter-248 must
    classify STUCK with user escalation.

- **Primary corrective**: **Mathlib analogy consult**, targeted specifically at the η-bridge
  transposed pushforward-side mate identity.

  **Why**: The prover has now described the η-bridge as "tractable, analog of proven calc" for two
  iters. The δ-side was addressed first; the η-side is first attempted in iter-247. Before
  dispatching the prover, the planner should run a focused Mathlib analogy consult confirming that
  the specific Lean 4 type for the transposed pushforward-side mate identity at the sheafification
  adjunction unit is directly accessible (the referenced `pullbackObjUnitToUnit_comp` path may
  require a version of `NatTrans.id_app`/mate calculus that has a subtle API surface). If confirmed
  immediately, dispatch the η-bridge prover without delay — the consult should be lightweight, not
  a blocking research effort. If the consult surfaces a Lean API gap, escalate to route pivot or
  user escalation rather than dispatching a prover into a known wall.

  **Hard constraint for iter-247**: The η-bridge must produce an axiom-clean D3' brick (or close
  the η-goal outright) by end of iter-247. "Named concrete residual remains with additional
  setup needed" is NOT acceptable as a PARTIAL outcome again. If iter-247 returns PARTIAL on
  the η-bridge with yet another named sub-step, iter-248 must classify STUCK and prescribe
  user escalation.

---

### Route RPF — `Picard/RelPicFunctor.lean`

- **Sorry trajectory**: 1 → 4 across iter-245 to iter-246 (REGRESSION). The route entered with 1
  sorry (the `addCommGroup` body at L235/L269). Iter-246 landed 4 sorries via the local-duplication
  workaround. Current count: 4.

- **Helper accumulation**: iter-246: 4 typed-sorry bridges (local duplicates of substrate decls).
  These are not helpers building toward closure — they are workaround debt.

- **Prover status pattern**: PARTIAL × 1 (iter-246 only; route is fresh).

- **Recurring blockers**: None (1 iter of data). Primary structural issue is the import cycle:
  `TensorObjSubstrate.lean` imports `RelPicFunctor.lean`, so RPF cannot cite substrate decls.
  The prover's workaround (local duplication) was correctly condemned by both prover and review:
  "the wrong fix — fragile downstream-duplication; correct sequencing is architecture-first."

- **Avoidance patterns**: None. Route is fresh; the hold from iter-235 to iter-245 was documented
  and sanctioned.

- **Throughput**: ESTIMATE_FREE — route opened iter-246; 1 iter elapsed; strategy estimate ~7–12
  iters from iter-246 entry. Insufficient data for throughput assessment.

- **Verdict: UNCLEAR**

  Fresh route (1 iter of data; K=5 required for full CHURNING/STUCK assessment). The UNCLEAR
  verdict is correct by the fresh-route rule.

  The sorry regression (1→4) is a warning signal, not a CHURNING signal: it is the direct result
  of a provably wrong approach (local duplication), and the planner has diagnosed it correctly.
  The proposed corrective (break import cycle via architecture refactor, then rebuild citing real
  upstream decls) is the right action. Applying CHURNING or STUCK to a 1-iter-old route whose
  failure mode was immediately diagnosed and corrected in the plan would be a false signal.

  **Monitoring condition for iter-247**: The refactor (Core.lean split) must produce a
  compile-clean import graph. If the RPF prover is dispatched post-refactor and rebuilds
  `addCommGroup` citing Core.lean with the sorry count returning to 1 (or lower), the route is
  CONVERGING. If the refactor fails or the sorry count does not improve, re-classify CHURNING.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (TensorObjSubstrate.lean + RelPicFunctor.lean). Cap: 10 (default).
- **Over the cap**: No.
- **Ready but not dispatched**: FlatBaseChange is on a documented hold (re-engagement condition
  unchanged). No other files with complete blueprint chapters and open sorries are identified as
  ready.
- **Under-dispatch finding**: No — the 2-file dispatch matches available ready lanes.
- **Within-iter sequencing dependency**: The refactor (import-cycle break) is a PREREQUISITE for
  the RPF dispatch. The plan sequences "refactor → then dispatch both provers," which is correct.
  Risk: if the refactor produces unexpected Lean build failures (lake rebuild required, import
  cycles harder to unwind than anticipated), both prover dispatches are blocked for the iter.
  Recommendation: the plan should name a fallback — if the refactor is incomplete at prover-dispatch
  time, dispatch only the TS prover (η-bridge) and carry the RPF refactor to iter-248.
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch, no bloat. Scheduling-risk note
  on the refactor gate is informational.

---

## Must-fix-this-iter

- **Route TS: CHURNING** — primary corrective: **Mathlib analogy consult** on the η-bridge
  transposed pushforward-side mate identity. Why: the sorry-stasis exemption ("designed shape,
  flat until D4'") has now been applied across three strategic phases. The exemption's own
  condition (no new Mathlib-absent blocker) is currently met, allowing one more prover round
  — but the planner must confirm the η-bridge API before dispatch and set a hard end-of-iter
  closure requirement. A fourth PARTIAL with a new "named sub-step" outcome in iter-247 exhausts
  the exemption and forces STUCK with user escalation in iter-248.

---

## Informational

**Route TS: the pre-set diagnostic from iter-246 was met.** The iter-246 progress-critic set the
monitoring condition: "did a named brick on D2'→D4' land?" D2' partially landed (4 axiom-clean
decls for the δ-side; η-bridge is being attempted for the first time in iter-247). No new
Mathlib-absent blocker appeared. By the pre-set diagnostic, this is the CONVERGING signal — but the
PARTIAL × 5 rule fires regardless, yielding CHURNING. The planner should read this as: the route
is CONVERGING in substance but CHURNING by the formal trajectory metric, and the corrective is
mild (validate the η-bridge API, then dispatch).

**Route RPF: the proposed architecture-first sequencing is correct.** The planner correctly
diagnosed the iter-246 local-duplication failure and chose the right structural corrective. The
refactor (Core.lean split) is the necessary prerequisite before any RPF prover work. The 1-iter
sorry regression (1→4) is the cost of one incorrect dispatch and should be treated as a sunk cost,
not a CHURNING/STUCK signal.

**Sorry count interpretation.** The 2 sorries in TensorObjSubstrate.lean (`exists_tensorObj_inverse`
at L696, `addCommGroup_via_tensorObj` at L1535) are structural end-targets. They close only when
D3' and D4' land. The 8-iter flat counter is NOT evidence of stall — it is the designed payoff
shape for this multi-brick prerequisite chain. However, this structural argument has now been
applied three times. D4' must land within the current strategy estimate window (5–13 more iters
from iter-245 entry) or the estimate must be revised with user input.

---

## Overall verdict

Two routes audited. Route TS is **CHURNING** (PARTIAL × 5; STUCK also fires but is offset by
structural-change evidence and the absence of a new Mathlib-absent blocker; one MUST-FIX item).
Route RPF is **UNCLEAR** (fresh route, 1 iter of data, sorry regressed 1→4 from wrong approach,
but proposed corrective is correct). Dispatch is OK (2 files, within cap, no under-dispatch).

The planner's iter-247 action should be:
1. Run a lightweight Mathlib analogy consult on the η-bridge mate identity (confirm Lean API before
   dispatch; not a blocking research task — should resolve within the plan phase).
2. Execute the import-cycle refactor (Core.lean split).
3. Dispatch the TS prover (η-bridge, with hard closure requirement: D3' brick must land or the
   η-goal must close; "another named sub-step" is not acceptable).
4. Dispatch the RPF prover post-refactor to rebuild `addCommGroup` citing Core.lean.
5. Add a fallback: if the refactor is not complete at prover-dispatch time, dispatch only the TS
   prover and push the RPF dispatch to iter-248.

If iter-247 returns PARTIAL on the η-bridge with yet another "named concrete residual," iter-248
must classify STUCK and prescribe user escalation. The sorry-stasis exemption is exhausted after
this iter.
