# Progress Critic Report

## Slug
iter030

## Iteration
030

## Routes audited

---

### Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 5 → 4 → 4 → 4 across R1–R4 (1 closed in R2; flat for 3 consecutive iters)
- **Helper accumulation**: ~1 helper in R1; 0, 0, 0 in R2–R4 (R3–R4 were rider-only / diagnostic rounds with no new proof content)
- **Prover dispatch pattern**: 1 file dispatched for 4 consecutive iters (the only active FBC file)
- **Recurring blockers**: "X.Modules instance diamond" — appears in all 4 rounds (R1 through R4). In R4 the prover proved definitively that even a `rfl`-true `have` whose LHS is the goal's own printed factor cannot be located by `rw`'s `kabstract`; every keyed-rewriting family (rw/simp/erw/conv/set/dsimp) is defeated. This is the same wall named in R1–R3; the diagnosis is now fully characterized, not new.
- **Avoidance patterns**: none (the single-file lane is the only active FBC lane; FBC-B is correctly sequenced after gstar_transpose)
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — 4 consecutive PARTIALs
- **Throughput**: OVER_BUDGET — STRATEGY.md shows `Iters left = 1–3`; directive reports ~12 iters elapsed in phase FBC-A (entered iter-018). 12 elapsed vs 1–3 remaining = 12 > 2×3 = 6.
- **Verdict**: CHURNING

**Primary corrective — Refactor (effort-breaker sub-lemma decomposition):**
The planner's proposed effort-breaker is a **genuine structural corrective**, not a reworded re-dispatch. The distinction is load-bearing: all prior iters dispatched a prover to "build the ~100–150 LOC assembly term" as a single unit. The prover's R4 diagnosis establishes that:
(a) the ~6 genuine-content factors are known and fully proved as standalone helpers,
(b) the sole remaining work is `.trans`-chaining them on *clean, freshly-elaborated terms* (one instance in scope ⇒ no diamond), and
(c) any `refine`/`calc` that touches the composite goal mid-proof breaks at the `≫` (diamond blocks `rw [Category.comp_id]` even there).
The sub-lemma decomposition approach creates ~5–6 named stubs, each stating one `.trans` link against a clean single-instance goal. Each stub is independently provable (≤30 LOC, no diamond), and the final assembly is a chain of already-proved named lemmas with one `exact` at the end that crosses the diamond via defeq. This is categorically different from "try harder at the monolithic term." Dispatch an effort-breaker subagent to enumerate the sub-lemma stubs and record each link's type + clean-term form; then a fine-grained prover fills each stub in isolation.

**Secondary corrective — throughput alarm**: With 12 iters elapsed vs a 1–3 remaining estimate, the planner should revise STRATEGY.md's `Iters left` for FBC-A to reflect reality before the next iter. If the effort-breaker + prover don't close the assembly in 2 iters, escalate to user: this is the project's oldest open stall.

---

### Route QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 → 4 → 4 across all 3 rounds (4 protected stubs throughout; no sorry opened or closed by the prover)
- **Helper accumulation**: 2 helpers (R1), 1 (R2), 1 (R3) = 4 helpers across 3 rounds; zero sorry-elimination across all 3
- **Prover dispatch pattern**: 1 file for 3 consecutive iters (the only active QUOT lane)
- **Recurring blockers**: "presentation transport across `D(g) ≅ Spec R_g`" / "slice instances time out" — named in both R2 and R3 (2 consecutive rounds). The R3 prover report establishes that ALL three route shapes (cover-transport, stalk, section-MV) funnel through the same transport, and even *stating* `q.presentation i` triggers a synthInstance heartbeat timeout on the slice `sheafToPresheaf … .IsRightAdjoint` instance. The blocker is structural, not a one-lemma gap.
- **Avoidance patterns**: none
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL (assumed from helper-addition with no gap1 closure)
- **Throughput**: ON_SCHEDULE — STRATEGY.md shows `Iters left = 4–8` for QUOT-defs; ~3 iters elapsed in the current gap1 sub-build. 3 elapsed ≤ 4 remaining minimum.
- **Verdict**: STUCK

**Applying STUCK rule**: Helpers added (4 total) across K=3 iters with **zero sorry-elimination** (the 4 protected stubs are intentionally frozen, but gap1 — the phase goal — has not been formalized as even a sorry-stub). The "helpers added without any sorry-elimination across K iters" STUCK criterion applies verbatim: the prover is building a scaffold around a well that cannot be reached.

**Primary corrective — Mathlib analogy consult (BEFORE any transport sub-build):**
The synthInstance heartbeat timeout on `(sheafToPresheaf (J.over (q.X i)) _).IsRightAdjoint` is a red flag that the current API shape (working via `J.over` slice sites) is wrong, not merely hard. Mathlib's `AlgebraicGeometry/Modules/` provides `Presheaf`, `Sheaf`, and `Tilde` but no site-slice ↔ scheme-pullback bridge — the prover's three routes all collide with this gap because they all share the same shape. A mathlib-analogist consult should:
1. Identify whether there is an existing `restrictScalars`/restriction-to-open functor in `Mathlib.AlgebraicGeometry.Modules` (or a nearby namespace) that the prover missed, or determine there is truly none.
2. If none: blueprint the correct shape for `restrictModulesToBasicOpen : (Spec R).Modules ⥤ (Spec R_r).Modules` and the `Presentation`-transport across `D(r) ≅ Spec R_r`, using whatever Mathlib affine-restriction API exists (e.g. via `AlgebraicGeometry.Scheme.restrict`, `Scheme.Opens`, or `CategoryTheory.Over`).
3. Determine whether the timeout is avoidable (wrong predicate, wrong site, wrong universe) or structural (the slice-site approach needs to be abandoned in favor of a direct `IsLocalizedModule` route that doesn't touch `J.over` at all).

The planner should NOT dispatch another prover until the mathlib-analogist returns a blueprint sketch. Sending another prover to "build the transport" against an unknown API shape is the failure mode that generated the last 3 rounds of PARTIAL status.

---

### Route GR — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

- **Sorry trajectory**: 0 sorries in the file throughout (target declarations don't exist yet — they are NEW work to add, per the HANDOFF comment)
- **Helper accumulation**: R1 added 4 axiom-clean helpers; R2 produced no output, no edits committed
- **Prover dispatch pattern**: 1 file for 2 rounds
- **Recurring blockers**: none identified (R1 was productive; R2 no-output gives no blocker phrase)
- **Avoidance patterns**: none
- **Prover status pattern**: CONVERGING (R1), INCOMPLETE/no-output (R2)
- **Throughput**: SLIPPING — STRATEGY.md shows `Iters left = 1–3`; 2 iters elapsed. 2 elapsed > 1 minimum remaining but ≤ 2×3 = 6.
- **Verdict**: UNCLEAR

**Rationale**: Only K=2 rounds of data — below the K=3–5 threshold for pattern detection. One no-output round on a new-declaration target (not an existing sorry) is concerning but not definitively STUCK: the recipe is fully specified in the HANDOFF comment (`ringHom_ext` + reuse `cocycle_imageMatrix_eq`; ~30–50 LOC of ring arithmetic, no instance diamond). The target is import-independent pure-ring content. The single no-output round may be a session-budget issue (the cocycle ring identity requires careful ring arithmetic validation), not a structural blockage.

**Recommendation**: Re-dispatch immediately with the sharpened directive the planner proposes — prove the ring identity `Φ=id` as a STANDALONE named lemma first (pure ring, no scheme content, no instance diamond), then assemble the `GlueData`. If the next round also produces no sorry-stub or no declaration, escalate to STUCK. One no-output round does not warrant a pivot; two would.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: none identified — FBC-B is correctly sequenced after `gstar_transpose`; GF-geo is explicitly sequenced pending gap1; SNAP-S1 is BLOCKED on Q1; all other routes are completed or sequenced downstream. The 3 active routes are all in the proposal.
- **Over the cap**: no
- **Under-dispatch finding**: no — all unjustified under-dispatch criteria fail; the sequencing of GF-geo is a valid strategic dependency, not avoidance
- **Iter-over-iter trend**: 3 → 3 → 3 (stable; matches the 3 active unblocked routes)
- **Verdict**: OK — file count 3 within cap 10, no under-dispatch

---

## Must-fix-this-iter

- **Route FBC**: CHURNING — primary corrective: Refactor (effort-breaker sub-lemma decomposition). Why: 4 consecutive PARTIAL rounds, recurring "X.Modules instance diamond" blocker across all 4, and 12 iters elapsed vs STRATEGY.md's 1–3 remaining. The monolithic-assembly dispatch pattern has not worked; decomposing into isolated per-`.trans`-link named stubs is the correct structural change.
- **Route FBC**: OVER_BUDGET — STRATEGY.md estimates 1–3 iters remaining; 12 iters elapsed in phase FBC-A (entered iter-018). Either revise the estimate to reflect actual cost, or escalate to user if the effort-breaker + fine-grained prover approach fails within 2 more iters.
- **Route QUOT**: STUCK — primary corrective: Mathlib analogy consult before any transport sub-build. Why: 4 helpers added across 3 rounds with zero sorry-elimination (gap1 not formalized at all); same transport blocker in ≥2 consecutive rounds; synthInstance timeout signals wrong API shape, not just a missing lemma. Dispatching another prover without first identifying the correct shape repeats the pattern.

---

## Informational

- **GR UNCLEAR**: One no-output round is a yellow flag, not a red one. The HANDOFF recipe is complete and the ring identity is pure-ring with no instance complexity. Re-dispatch with sharpened directive as planned. If R3 also produces nothing, escalate to STUCK.
- **FBC corrective is genuine**: The effort-breaker approach (naming each `.trans` link as an isolated sub-lemma) is structurally different from all prior dispatches. Prior rounds dispatched a prover to build the monolithic 100–150 LOC term in a single session under 5 KB goal-state pressure. The sub-lemma approach eliminates the diamond from each step (one instance in scope), makes progress testable link-by-link, and reduces each step to ≤30 LOC. This is NOT a reworded re-dispatch.
- **QUOT mathlib-analogist timing**: The planner correctly identifies this as a "consult-first, build-second" situation. The transport sub-build is a genuine multi-iter effort, but it should not start before the analogist determines whether the `J.over` slice shape is the right entry point or whether a direct `IsLocalizedModule`-via-`Scheme.restrict` shape avoids the timeout.

---

## Overall verdict

Two routes require immediate intervention: **FBC is CHURNING** (4 consecutive PARTIAL rounds, "X.Modules instance diamond" recurring across all 4, OVER_BUDGET by 2×) and **QUOT is STUCK** (4 helpers added across 3 rounds with zero sorry-elimination, same transport blocker in ≥2 consecutive rounds, synthInstance timeout signalling wrong API shape). The planner's proposed correctives — effort-breaker sub-lemma decomposition for FBC, mathlib-analogist consult before any QUOT transport work — are both genuine structural changes, not reworded re-dispatches; they should be enacted as proposed. **GR is UNCLEAR** (only 2 rounds; one productive, one no-output; proceed with sharpened re-dispatch and watch). Dispatch sanity is OK (3 files, all active unblocked routes covered, no under-dispatch). The planner must not silently re-assign the FBC assembly to another prover without the effort-breaker decomposition step, and must not dispatch a QUOT transport prover before the analogist returns.
