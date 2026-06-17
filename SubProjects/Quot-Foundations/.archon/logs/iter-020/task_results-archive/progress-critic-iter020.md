# Progress Critic Report

## Slug
iter020

## Iteration
020

## Routes audited

---

### Route: FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 4 → 4 (iter-015 to iter-019). Flat for 5 iters; zero net movement.
- **Helper accumulation**: 6 helpers added in 3 of 5 iters (017: +4, 018: +0, 019: +2); 0 sorries closed across the entire window. iter-019's 2 helpers (`_unitExpand`, `_gammaDistribute`) are sorry-free sub-lemmas that do not touch the assembly `sorry`.
- **Recurring blockers**: "Seam-2 step-(iii) assembly goal UNMOVED" / "leg-lock" / "instance diamond" appear verbatim in iter-018 and iter-019 reports and are traceable to iter-014 (6 iters continuous). This is the dominant signal.
- **Prover status pattern**: PARTIAL × 5 (iter-015 through iter-019).
- **Throughput**: OVER_BUDGET — STRATEGY.md estimates 3–4 iters for FBC-A; the phase has been active since before iter-014, ≥6 iters elapsed. The "Iters left = 3–4" figure is now known to be dishonest relative to actual velocity.
- **Verdict**: **STUCK**
- **Primary corrective**: **Refactor** — the prover's iter-019 report names the exact intervention with full precision: "rewrite the `g'`-unit via a `g'`-parametrised lemma BEFORE `subst`, so `g'` is still a free local and matches syntactically." No new information is needed; the refactor directive can be written now. See "On the analogist decision" below.

**On the analogist decision (question 1 from the directive):** The planner's no-prover + analogist + deferred-refactor sequence is directionally correct (this route IS stuck and requires a structural corrective, not another prover round). However, it introduces a 1-iter delay compared to dispatching the refactor directly. The iter-019 prover report already contains the precise technical prescription. A mathlib-analogist consult may produce one of two outcomes: (a) it confirms what the prover already wrote — burning an iter for no new signal; or (b) it surfaces a genuinely different Lean idiom for pre-`subst` unit rewriting that the prover missed. Outcome (b) justifies the analogist; outcome (a) does not. The risk is that outcome (a) is more likely given the specificity of the iter-019 prover report. **Cheaper path**: dispatch the refactor this iter using the iter-019 prover report as the directive (it is already a precise specification), and run the analogist simultaneously or skip it. If the analogist has already been dispatched, the refactor must land in iter-021 without further deferral — not iter-022+.

**OVER_BUDGET flag**: revise the STRATEGY.md FBC-A estimate or mark it as throughput-exhausted and state the actual remaining scope. A "Iters left = 3–4" that has been running for ≥6 iters without sorry movement is a planning fiction; it should either be updated to "Iters left = 1–2 post-refactor" (if the refactor is confident) or escalated to the user.

---

### Route: GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 4 → 3 → 3 → 3 (iter-016 to iter-019). One sorry eliminated at iter-017 (L5 closed), then flat for 3 iters.
- **Helper accumulation**: 8 helpers in 4 iters (017: +1, 018: +6, 019: +1); 1 sorry closed total (L5 at iter-017). Rate: 0.25 sorries/iter across the window, below the 0.5/iter threshold.
- **Recurring blockers**: none currently active. OreLocalization diamond (iters 015–016) closed at iter-017; L4 injectivity crux (iters 015–018) closed at iter-019. No blocker has survived ≥2 iters past its corrective — this is a genuine positive.
- **Prover status pattern**: PARTIAL × 4 (iter-016 through iter-019).
- **Throughput**: SLIPPING — STRATEGY.md estimates "GF-alg: Iters left = 2"; current sorry count is 3 (L4 finiteness + genericFlatnessAlgebraic + genericFlatness). Closing L4 this iter reduces to 2, but those 2 are themselves non-trivial (dévissage + geometric descent). The "2 iters" estimate appears optimistic from here.
- **Verdict**: **CHURNING** — 4 consecutive PARTIAL + sorry flat for 3 iters + helper accumulation with sub-0.5/iter payoff rate.

**Verdict qualification (question 2):** The churn here is pace-based, not approach-based. The injectivity crux was a 5-iter stall that closed cleanly at iter-019; the remaining L4 finiteness leaf has a fully specified concrete recipe (witness `g := g0·g1`, `Algebra.finite_adjoin_of_finite_of_isIntegral`). No structural problem with the route; the blocker sequence has been resolving. The single-leaf framing is genuine: the iter-019 prover report is explicit that all Mathlib lemmas are verified and the negative (no Mathlib shortcut for finiteness descent) is confirmed. Risk of hidden depth: low — the recipe is Nitsure-style integral clearing, well-understood.

- **Primary corrective**: **Refactor** (objective scope) — the plan for iter-020 dispatches "close L4 finiteness, then start genericFlatnessAlgebraic." These two pieces must execute in the SAME prover session, not gated sequentially across iters. If L4 finiteness closes in 30 minutes of the session, the remaining time must be spent opening the `genericFlatnessAlgebraic` dévissage scaffold — not deferring it to iter-021. The sorry count has been flat because each iter closes a crux but then scopes out before touching the next node. Tighten the session objective: "close L4 finiteness AND prove at least one dévissage step in `genericFlatnessAlgebraic`." This prevents another 4→3→3→3-style flatline at 3→2→2→2.

---

### Route: QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 5 (iter-016 to iter-019). Net +1 over 4 iters; no sorry eliminated. The +1 at iter-019 was deliberate (accepted cost of end-to-end keystone assembly).
- **Helper accumulation**: 50 helpers added across iters 017–019 (+13, +20, +17); zero sorry elimination at file level across the full K=4 window.
- **Recurring blockers**: finiteness transfer (implied iters 017–019 blocker) — CLOSED axiom-clean at iter-019. The `iSupIndep` leaf is iter-019 only (1 iter; route (a) confirmed dead end, route (b) queued). No recurring blocker currently active.
- **Prover status pattern**: PARTIAL × 3 (iter-017 through iter-019).
- **Throughput**: SLIPPING — STRATEGY.md estimates "SNAP: Iters left = 2–4." Keystone is assembled; the remaining 1 work sorry + 4 protected stubs places this on the optimistic end of that range if the `iSupIndep` leaf closes cleanly.
- **Verdict**: **STUCK** (rules applied verbatim: helpers added in ≥3 of K=4 iters AND no sorry eliminated across the full K=4 window → rule trigger). The STUCK verdict is a metric artifact: the 4 protected stubs are fixed-by-design deliverables, not failed eliminations, and the 50 helpers added in iters 017–019 were ALL proved sorry-free except for the deliberate terminal leaf introduced in iter-019 to assemble the keystone end-to-end. The practical situation is a route at its terminal 1-leaf residual, not a genuine stall.

**On "single-leaf framing hiding a deeper stall" (question 2):** No. The iter-019 prover report is specific and complete: `iSupIndep` of degreewise images in finite-dimensional `Q₀`; the degree-`n` projection detector `Φ` is the instrument; route (a) (`liftQ`-based) is a confirmed dead end (scalar-ring clash documented); route (b) (dfinsupp destructuring of `⨆ j≠n`, staying inside `Q₀`) avoids the ring clash. The finishing lemma `Submodule.finite_ne_bot_of_iSupIndep` is verified present. No hidden depth is indicated.

- **Primary corrective**: **Refactor** (approach restriction) — the prover must approach the `iSupIndep` leaf exclusively via route (b) (dfinsupp destructuring). Route (a) is a confirmed dead end: `Submodule.liftQ` produces an `S`-linear map but the target is only a κ-module. Any attempt to revisit route (a) "from a different angle" wastes the session. The directive for iter-020 must include a hard prohibition on route (a) and a concrete sketch of route (b): decompose `⨆ j≠n range (ψ j)` via `Submodule.mem_iSup_iff_exists_dfinsupp`, extract the finsupp support, use `decompose_of_mem_ne` degree-wise, stay entirely inside `Q₀`'s κ-structure, no outgoing map.

---

## PROGRESS.md dispatch sanity

Verdict: **OK** — file count 2 (GF, QUOT) within cap; FBC deliberately excluded for structural corrective (analogist); no under-dispatch relative to prover-ready files. FBC's absence from the prover lane this iter is the correct response to a STUCK route undergoing a structural corrective, not an avoidance pattern (only 1 no-prover iter for FBC so far; avoidance pattern triggers at ≥3 consecutive).

---

## Must-fix-this-iter

- **Route FBC: STUCK** — primary corrective: Refactor. The refactor directive (pre-`subst` unit-rewrite restructuring) must be dispatched **no later than iter-021**. If the analogist is already running this iter, its output should sharpen the refactor directive; if the analogist confirms what the iter-019 prover already wrote, skip it and proceed directly to the refactor. Do not defer the refactor to iter-022+.
- **Route FBC: OVER_BUDGET** — STRATEGY.md estimates FBC-A at 3–4 iters; elapsed ≥6 iters. Revise the estimate or document throughput exhaustion with a post-refactor re-estimate ("1–2 iters post-refactor if the pre-`subst` intervention resolves the leg-lock").
- **Route GF: CHURNING** — tighten iter-020 prover objective: "close L4 finiteness AND begin genericFlatnessAlgebraic in the same session." The planner's current proposal ("close L4 finiteness conjunct, then start genericFlatnessAlgebraic") already specifies this, but the directive to the prover must make clear that "start" means "prove at least one dévissage step," not "open a scaffold sorry."
- **Route QUOT: STUCK** (metric artifact) — primary corrective: Refactor (approach restriction). The iter-020 QUOT prover directive must explicitly prohibit route (a) and provide a route (b) sketch. Planner's current proposal addresses the leaf; add the route-restriction language.

---

## Informational

**GF single-leaf depth is not a concern.** The iter-019 prover explicitly confirmed negative results (no Mathlib shortcut for the finiteness descent direction), and the recipe is concrete and tested against verified lemmas. The concern would be that `Algebra.finite_adjoin_of_finite_of_isIntegral` requires an `IsIntegral` hypothesis that needs its own small proof; but the iter-019 prover notes the integral dependence follows from `hint` (the `gf_torsion_reindex`-style argument) once the monic relation coefficients are cleared by `g1`. Medium-confidence estimate: L4 finiteness closes in 1 iter.

**QUOT helpful pattern note.** The foundation-additive approach (iters 017–018 adding helpers proved sorry-free) worked: every helper in those iters closed immediately. The iter-019 keystone assembly was the correct culmination. The STUCK verdict fires on the file-level sorry-count metric, which cannot distinguish "50 sorry-free helpers added" from "50 helper stubs left open." Future planner iterations may want to track "sorry-free helpers added vs. sorry-leaving helpers added" as a secondary metric for QUOT-style routes.

---

## Overall verdict

One route (FBC) is genuinely STUCK with a 6-iter recurring leg-lock blocker and an OVER_BUDGET phase estimate; the planner's structural corrective (analogist + deferred refactor) is the right category of response but should compress to a 1-iter turnaround (refactor in iter-021, not iter-022). One route (GF) is CHURNING on pace (4 consecutive PARTIAL, sorry rate 0.25/iter vs. 0.5 needed), with a working approach and a concrete recipe for the residual; the corrective is to enforce that L4 finiteness AND genericFlatnessAlgebraic open in the same iter-020 session. One route (QUOT) triggers STUCK by the metric rules (no sorry eliminated across K=4 iters despite helper additions), but this is an artifact of the protected-stub structure and the deliberate keystone assembly approach; the practical situation is 1 terminal leaf with a confirmed viable route (route b only); the prover directive must hard-prohibit route (a). Two prover lanes dispatched (GF, QUOT); dispatch is within cap and FBC exclusion is appropriate.
