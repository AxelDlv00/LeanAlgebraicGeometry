# Recommendations for the next plan-agent iteration (iter-117)

## CRITICAL — User has responded in `USER_HINTS.md`; act on it before anything else

The iter-116 plan-phase wrote a 3-option escalation to `USER_HINTS.md`. **The file currently carries user-authored direction that supersedes the 3-option fan.** The iter-117 plan-phase MUST read it FIRST and reshape the iteration plan around the user's directive.

The user's five concrete asks (verbatim summarized from `USER_HINTS.md`):

1. **Self-decide the best strategy** — the user does NOT pick among the planner's Options 1/2/3 on the L175 route. The loop must form its own judgement on how to resolve the L175 unique-gluing impasse.
2. **Strict correctness — no temporarily-wrong statements** — any wrong mathematical statement (definition, signature, proof) currently in the codebase must be removed, and the gap left by the removal must be filled (with a correct closure or an honest disclosure that is itself mathematically clean).
3. **Blueprints must be detailed enough for provers** — chapters need enough mathematical material that a prover can formalize from them without re-deriving content.
4. **STRATEGY.md must be cleanly organized — focused on STRATEGY, not history** — current STRATEGY.md ("too messy") is too prose-heavy with cumulative achievement enumeration. Rewrite to focus on the forward-looking plan, with the per-iter history moved out.
5. **Nothing should be deferred** — every sorry must have a closure plan. The "named Mathlib gap" disclosure as a *permanent* deferral framing is no longer acceptable. Each of the 7+1 named gaps + 8 substep deferrals + Phase-C3-gated sorries needs a concrete closure route, even if multi-iter.

**The user has effectively asked for a strategic reboot.** The iter-117 plan-phase should treat all five asks as binding policy and replan iter-117+ accordingly.

### Concrete iter-117 actions

1. **Clear `USER_HINTS.md` after reading** — the response is consumed.
2. **Rewrite `STRATEGY.md`** — cut the historical narrative ("iter-110 achievements", "iter-115 prior-critique-status remarks", etc.); produce a clean per-phase strategy that names every active sorry, its closure route, and its budget. The cumulative history of prior iters belongs in `iter/iter-NNN/plan.md` sidecars and `PROJECT_STATUS.md`'s knowledge base, not in STRATEGY.md.
3. **Audit the codebase for wrong-but-not-yet-marked statements** — dispatch `lean-auditor` (no strategy bias) with a directive that explicitly asks "report every declaration whose statement is mathematically wrong or whose hypothesis-strength is incorrect", and act on the report by either fixing the signature (refactor lane) or removing it and rewriting the chapter to no longer claim it. Note: iter-112 already surfaced 3 wrong signatures in `Differentials.lean` that were corrected via the iter-113 refactor lane (`smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`); the iter-117 audit may surface more.
4. **Audit the blueprint for under-detail** — dispatch `blueprint-reviewer` with the directive "report any chapter whose proof sketch is too thin for a prover to formalize from without re-deriving content"; the standard plan-phase review covered this from a completeness-vs-correctness angle, but the user's bar is higher.
5. **Design closure plans for the 7 named gaps + budget-deferral** — for each of:
   - `Modules/Monoidal.lean:L173 instIsMonoidal_W`
   - `Differentials.lean:L737 cotangentExactSeq_structure case h_exact`
   - `Differentials.lean:L1091 serre_duality_genus`
   - `Picard/LineBundle.lean:L82 pullback_tensorObj`
   - `Picard/LineBundle.lean:L96 pullback_oneIso`
   - `Picard/Functor.lean:L181 representable`
   - `Jacobian.lean:L179 nonempty_jacobianWitness`
   - `BasicOpenCech.lean:L1846 h_loc_exact` (budget-deferral)
   - `BasicOpenCech.lean:L1120 h_loc_eq_zero` (PAUSED)
   - `BasicOpenCech.lean:L1212/L1536/L1564` (substep-deferred), `L1754` (gated on L1120)
   - `Differentials.lean:L191 relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (the route at the core of the iter-115 STUCK + iter-116 escalation)
   write a multi-iter closure plan into STRATEGY.md (or per-route notes). Where Mathlib genuinely has no off-the-shelf route, the closure plan must say "build the Mathlib bridge ourselves" with budget and route, **not** "permanent named-deferral".

6. **For the L175 unique-gluing impasse specifically** — the user's "find the best strategy yourself" means the loop chooses between the planner's Options 1/2/3 (or some hybrid). Given:
   - The iter-114 mathlib-analogist consult confirmed NEEDS_MATHLIB_GAP_FILL on the affine-basis-to-X sheaf bridge.
   - The user's "nothing deferred" rule rules out Option 3 (declare L175 named gap #8) as a *permanent* solution but allows it as an interim scaffolding step while a different route is built.
   - Option 2 (refactor consumers to presheaf-only) preserves mathematical content while sidestepping the missing bridge entirely.
   - Option 1 (build the bridge) is the most expensive but the most general.

   **Author's recommendation for the iter-117 plan agent's autonomous decision**: Option 2 first — dispatch a `refactor` subagent to rewrite downstream consumers of `Ω_{X/S}` (chiefly `cotangent_at_section`) in terms of the presheaf-on-affine-charts characterisation that the existing `relativeDifferentialsPresheaf_obj_kaehler` already provides, removing the obligation to produce a sheaf at all. This satisfies the user's "no temporarily-wrong statements" and "nothing deferred" rules: the sheaf claim is dropped (not deferred), and the presheaf-only consumers are mathematically correct (the project never needed sheafification for the goal-theorem chain — that was a structural choice, not a mathematical necessity). Cost: ~1–2 iters of refactor planning + 1 iter of execution + the existing 5–8 iters of L880/L897 work against the refactored form. Total Phase B ~ 7–11 iters.

   Option 1 (build the bridge) remains the right call only if downstream phases genuinely need the sheaf condition; the iter-117 plan-phase should verify this against the actual `Jacobian.lean` / `AbelJacobi.lean` / `Picard/Functor.lean` consumers before committing.

### Subagent dispatches the iter-117 plan-phase will likely need

- Mandatory: strategy-critic, blueprint-reviewer, progress-critic (the standard 3).
- Likely additional: lean-auditor (to fulfill the user's "remove all wrong mathematical statements" ask); refactor (if Option 2 is chosen); blueprint-writer × multiple (to fulfill the user's "blueprints detailed enough" ask, likely on Differentials.tex, Picard chapters, and possibly Genus.tex / Cohomology_MayerVietoris.tex).
- Possibly: mathlib-analogist (re-consulted on the refactor's API-shape decision if Option 2 fires); reference-retriever (only if the strategy reshape needs new sources, which is unlikely).

## HIGH — Do NOT re-dispatch a prover round on `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` in iter-117 without acting on the user direction

The iter-115 STUCK / iter-116 hard-gate / user-escalation arc is a 6-iter sequence in which the autonomous loop has correctly identified that another helper round on this route would be a Bar-C-trigger (third reformulation, no math content). Until the iter-117 plan-phase has either:

(a) Reshaped the strategy to drop the sheaf obligation entirely (Option 2 refactor), so the L175 sorry is no longer reachable from any active route, OR
(b) Begun an explicit Mathlib-bridge build under a new file (Option 1), with the iter-117 prover lane targeting the bridge's own first sub-lemma not L175 itself,

the prover-target surface for L175 / L191 remains hard-gated. Re-dispatching a third helper round on L175 directly is forbidden by the iter-115 hard gate AND by the user's "nothing deferred" rule (the gate is no longer about deferral — it's about the route's mathematical viability).

## HIGH — `STRATEGY.md` reorganization is a load-bearing iter-117 task

The user's ask #4 ("strategy file is too messy, should be more clearly organize without making it an endless prose") names STRATEGY.md as a problem in itself, independent of the L175 impasse. The iter-117 plan-phase should rewrite STRATEGY.md from scratch (or near-scratch) along these lines:

- **§ Top-level goal** (one paragraph, no more): the 9 protected declarations + the goal theorem chain.
- **§ Phase index** (one table): Phases A / B / C0 / C1 / C2 / C3 / D with one-sentence status + one-sentence forward plan + budget.
- **§ Per-phase plan**: for each active phase, the per-sorry closure route. No iter-by-iter history.
- **§ Active route** (one): the iter-117 active prover surface and its iter budget.

History should NOT live in STRATEGY.md. It belongs in `iter/iter-NNN/plan.md` sidecars (per-iter narrative), `PROJECT_STATUS.md` (knowledge base + iteration log), and `proof-journal/sessions/session_N/` (per-iter prover analysis). Each of those serves the iter-NNN-to-iter-MMM lookup, so STRATEGY.md can stay forward-looking.

## HIGH — `Differentials.lean` inline-comment Mathlib misnamings (carryover from iter-116 blueprint-reviewer)

Inline comments at `Differentials.lean:L72, L112, L246` reference `KaehlerDifferential.isLocalizedModule_map` — the `_map` suffix is wrong (Mathlib's name has no `_map`). The iter-116 cosmetic blueprint-writer dispatch fixed this in `Differentials.tex` at L59 but cannot touch the Lean comments (out-of-domain). Schedule a doctor/refactor pass in iter-117 (perhaps bundled with the user-asked codebase audit) to fix:

```
Differentials.lean:72   `KaehlerDifferential.isLocalizedModule_map`  →  `KaehlerDifferential.isLocalizedModule`
Differentials.lean:112  (same)
Differentials.lean:246  (same)
```

Bonus: the comment at L72 frames `KaehlerDifferential.isLocalizedModule_map` as "the scheme variant" — but no such variant exists in Mathlib. The prose claim is also wrong and should be deleted.

## MEDIUM — Blueprint line-reference drift in the named-deferral inventory

`Cohomology_MayerVietoris.tex:1198` § "iter-108 escape-valve status" carries 4 stale line refs (iter-116 blueprint-reviewer enumerates them: `Differentials.lean:636` should be `:737`; `Differentials.lean:877` should be `:1091`; `Jacobian.lean:179` should be `:176`; `Picard/Functor.lean:181` should be `:176`). Sister slip at `Picard_Functor.tex:88` (`LineBundle.lean:93` → `:96`). Bundle into the iter-117 STRATEGY.md reshape's blueprint-writer pass (same writer can update both chapters in one dispatch).

## MEDIUM — Re-arm progress-critic on the post-user-direction route

When the iter-117 plan-phase picks the next active route (likely Option 2 refactor + L880-forward), dispatch `progress-critic` with the freshly extracted signals for the newly-prioritized route. The iter-114→iter-116 STUCK arc is now closed (the user response is the corrective); the next time progress-critic audits, it should be against a clean K=1 baseline on the new route.

## MEDIUM — Mathlib name re-verification budget

The iter-112 / iter-113 / iter-115 / iter-116 plan-phases all surfaced fresh Mathlib name drift (`forget AddCommGrpCat`, `isLocalizedModule_map`, `AlgebraicGeometry.Modules.tilde`, `iff_exists_basis_kaehlerDifferential`, `isSmoothOfRelativeDimension_iff`). The pattern is: blueprint prose names drift faster than the Lean code does. Iter-117 should budget ~10 minutes of `lean_loogle` + Mathlib source grep on the load-bearing Mathlib names of any active chapter — this is cheap insurance for the prover's docstring authority.

## LOW — Targets that remain off-limits this round (pending iter-117 reshape)

The full list is in PROGRESS.md § "Off-limits this iteration" — every named-gap target + Phase-A subgoals + Phase-C3-gated sorries. The user's "nothing deferred" ask will reshape this list, but until the iter-117 plan-phase commits the reshape, no prover should be dispatched against any of these.

## LOW — Reusable proof patterns from iter-116

No new proof patterns this iter (no prover work). The iter-115 unique-gluing reformulation route pattern documented in PROJECT_STATUS.md § "Knowledge Base" is now flagged as a **route the project may abandon under Option 2**; if iter-117 picks Option 2, the Knowledge Base entry should be marked as historical-only ("retained for posterity; the project no longer routes through `IsSheafUniqueGluing` for L175").

## Targets the plan agent should NOT assign in iter-117 (consecutive-blocker rule)

Per the review-prompt guidance on consecutive-blocker streaks:

- **DO NOT** assign `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` as a direct prover target. The 6-iter blocked streak (iter-111…iter-116, counting iter-116 as the escalation/pause iter) makes another direct attack the gate's prohibited "third helper round" pattern.
- **DO NOT** introduce another sorry-bodied sub-helper on this route (`_isSheafUniqueGluing_descent_type`, `_basicOpen_iso_tilde`, etc.) without the Option 2 refactor or Option 1 bridge build first being committed in STRATEGY.md.
- **DO NOT** reformulate to yet another equivalent sheaf condition. Same content, same blocker.
- **DO** dispatch a `refactor` subagent on the downstream consumers if Option 2 is chosen.
- **DO** dispatch a `lean-auditor` to address the user's "no wrong statements" ask before any new prover work.
- **DO** dispatch `blueprint-writer` on chapters needing detail expansion, with the user's "detailed enough for provers" bar in mind.

## Closing remark

Iter-116 is a healthy iteration. The autonomous loop's hard-gate machinery worked exactly as designed: a STUCK route was detected, automated correctives were exhausted, and the loop paused itself rather than emit more sorry-bodied wrappers. The user has now responded with substantive direction; iter-117 is the first iter under the new policy regime.
