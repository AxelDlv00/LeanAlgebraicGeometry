# Iter-105 (Archon canonical) / iter-107 (project narrative) — review

## Outcome at a glance

- **Single prover lane on `BasicOpenCech.lean`** committed to **option 3** (in-line per-coord scalar pullback, wrapper bypassed) per progress-critic-iter105 STUCK + strategy-critic-iter105 sunk-cost verdicts.
- **Result**: **PARTIAL — 0 sorry closed, 0 sorry added, structural infrastructure staged**.
  - 7 prover attempts on L1120: 6 failed routes (whnf timeout × 4, simp no progress × 1, eqToHom application mismatch × 1), 1 final partial-commit.
  - **Final committed state** at L1115–L1120: `have hRel' := omega; have h_iter104 := cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'; sorry`. The iter-104 binder-level R-linearity is now in tactic-state as `h_iter104`; iter-108 can build on it.
  - **Step 2 stretch (L1754 `g_R.map_smul'`) correctly skipped** per the plan's escalation rule.
- **Sorry trajectory**: BasicOpenCech **6 → 6**. Project total **14 → 14**.
  - Hard cap of 6 met; iter-105 PROGRESS.md target of 5 missed by 1; stretch of 4 not met.
- **Compile-verified**: yes (`lean_diagnostic_messages` severity=error returns `[]` end-to-end). **Thirteenth consecutive compile-verified prover iteration** (iter-092 onwards).
- **No new axioms; no protected signatures touched; iter-104/105 helpers `cechCofaceMap_summand_family*` + `_R_linear` byte-for-byte preserved; iter-105 partial-proof scaffold inside `cechCofaceMap_pi_smul`'s body (S1–S5 chain at L1095–L1114) byte-for-byte preserved.**
- **STREAK STATUS**: 7 consecutive PARTIAL iters on the `cechCofaceMap_pi_smul` slot (iter-099/100/101/103/105/106/107). Iter-104 was a different target. Progress-critic-iter105 STUCK verdict fires for the second time. **Iter-108 abort policy now triggered** (see `recommendations.md` § "CRITICAL").

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **14**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **6** at L1120 (`cechCofaceMap_pi_smul` trailing — partial, iter-104 R-linearity staged), L1212 (substep (a) augmented Čech, deferred), L1536 (`K → K₀` transport, deferred), L1564 (substep (a) for `s₀`, deferred), L1754 (`g_R.map_smul'`, gated on L1120 closure), L1783 (`h_loc_exact`, deferred). Iter-105 refactor lane removed iter-106's dead-end Route 1 lemma (was L728); line numbers stable post-refactor.
  - `AlgebraicJacobian/Differentials.lean`: **5** at L113, L517, L711, L727, L871. Line numbers shifted by -240 (was L122/L636/L957/L974/L1116 pre-refactor) due to deletion of the iter-076 dead-code block.
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173 (Mathlib upstream gap; off-limits + iter-104 critical finding RESTATED by lean-auditor-iter105).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179 (`nonempty_jacobianWitness`; STRATEGY.md iter-105 ratified as JacobianWitness deferral pattern).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L190 (`PicardFunctor.representable`; gated on Phase C C0–C3, and now flagged by lean-auditor-iter105 as upstream of the critical-severity `LineBundle` finding).
- **Solved this iter**: none (target was reduce by 1; missed by 1).
- **Partial this iter**:
  - `cechCofaceMap_pi_smul` L1120: option 3 attempted across 7 routes; iter-104 R-linearity staged as `h_iter104` body-local have. Banks load-bearing infrastructure for iter-108.
- **Blocked this iter**: none formally; the L1120 residual has three concrete iter-108 abort-policy routes (refactor / strategy-critic / mathlib-analogist) — see `recommendations.md`.
- **Untouched (deferred)**: 5 BasicOpenCech sorries (L1212/L1536/L1564/L1754/L1783) + 5 Differentials + 1 Monoidal + 1 Jacobian + 1 Picard.Functor — total 13 untouched.

## What the iter-105 plan got right

- **Acted on every critic verdict** (progress-critic STUCK + strategy-critic CHALLENGE/REJECT). The iter-105 plan:
  1. Dispatched 3 parallel blueprint-writers to clear 3 must-fix blueprint issues — all COMPLETE, verified by lean-vs-blueprint-checker-basicopencech this review.
  2. Dispatched a refactor subagent to clean iter-104/iter-106 sunk-cost (Route 1 lemma, 4 stale docstrings, 238-LOC dead-code block in Differentials) — all COMPLETE.
  3. Updated STRATEGY.md with the Phase A iter-108 abort policy, Phase C3 exit policy (JacobianWitness deferral), and D/E re-statusing.
  4. Forced the prover onto option 3 (rejected the heartbeat-lift / lemma-rework alternatives that would have re-entered the streak pattern).
- **Pre-stated iter-108 abort policy** is the plan-agent's deliberate setup for the review-agent to fire post-failure. It worked as designed: option 3 failed → policy now binding on iter-108.
- **Mandatory subagent dispatches all completed** during plan phase (blueprint-reviewer, progress-critic, strategy-critic). The catalog-driven workflow is functional.
- **Refactor dispatch cleaned auditor-found issues from iter-104** (Route 1 lemma, dead-code block, stale docstrings) — verified by lean-auditor-iter105 this review: 4 prior "Body left as sorry" stale docstrings and the Differentials 238-LOC dead-code block are gone.
- **Blueprint label corrections landed cleanly**: lean-vs-blueprint-checker-basicopencech confirms `def:Scheme_HModule_prime_eq_HModule_linearEquiv` replacement is exhaustive across the blueprint tree.

## What the iter-105 plan got slightly wrong

- **The plan deferred the lean-auditor-iter104 critical findings on `LineBundle` and `instIsMonoidal_W` to "strategic decisions"** but did not surface them to `TO_USER.md`. The lean-auditor-iter105 has re-promoted both to must-fix-this-iter; the user still has not been alerted via the dashboard banner. **Action**: iter-108 plan-agent must write `TO_USER.md` flagging these two items.
- **The plan did not anticipate that option 3's body-local rfl-helper escape route was already dead** (iter-099 E1 finding). The prover correctly tried it (Attempt 3) and it failed, confirming the iter-099 finding in the post-S5 frame. Minor cost: ~1 lemma-search + 1 multi_attempt. Not a planning failure — the plan didn't *forbid* the rfl-helper approach because it was the highest-leverage cheapest attempt left. Acceptable.
- **The "option 3" framing** assumed the call-site Pi.lift body is *definitionally* equal to `cechCofaceMap_summand_family s₀ n (Fin.cast hRel'.symm i)` at the post-S5 frame. The prover's Attempt 6 with `change`/`show` proves this is *propositionally* true (via Fin.cast) but not directly *definitionally* — `omega` cannot discharge the family-equality between `Fin ((prev n) + 2) → s₀` and `Fin (n+1) → s₀`. Reconfirms iter-100's `_`-codomain ascription dead-end in a new frame. **Lesson**: when iter-108 plan-agent considers a "DEFINITIONALLY equal" claim in plan prose, verify the def-eq experimentally before committing the prover to it.

## What the iter-105 plan got more importantly wrong

- **The iter-108 abort policy now has to fire, and the plan-agent must NOT try to soften it.** The committed STRATEGY.md text says "do NOT continue wrapper engineering, heartbeat budget escalation, or scalar-extraction tactic accumulation." This iter's reviewer (me) reads "option 3 failed" as "all three forbidden patterns are now also forbidden" — the iter-108 plan-agent does not get a fresh menu of wrapper variants. The three abort-policy options (refactor / strategy-critic / mathlib-analogist) are mutually exclusive; one must be picked, and the plan-agent does NOT get to add a fourth "one more wrapper attempt" sneak option.

## Sorry-trajectory continuity (sanity check, included for iter-108 plan-agent's reference)

| Iter | Slot status | Source target | Sorries (BasicOpenCech) | Net | Notes |
|------|-------------|---------------|--------------------------|-----|-------|
| 099 | hG residual at L728 | bridge | 6 → 6 | 0 | Step 1 closed; bridge applied; hG residual open. |
| 100 | hG residual at L811 (now L1120) | refactor wait | 6 → 6 | 0 | Plan: refactor mandate; no prover advance. |
| 101 | S1–S3 chain at L811 | iter-101 plan | 6 → 6 | 0 | Structural advance (S1–S3 landed); 6 routes failed at S4. |
| 102 | refactor lane | named-family extraction | 6 → 6 | 0 | Iter-098 split-slot pattern extended; named family + R-linearity skeleton. |
| 103 | S4–S5 chain at L827 | iter-103 plan | 6 → 6 | 0 | Constant-level rfl pivot + comp_apply decomp; iter-104 fix at L536 closed alternating_zsmul_pi_smul_aux_sum_comp body. |
| 104 | L536 R-linearity | named-family R-linearity | 6 → 6 → 6 | 0 | Closed L536 cleanly; same slot L988 untouched. |
| 105 | wrapper helpers + L1147 partial | iter-105 plan | 6 → 6 | 0 | 2 wrappers fully proved; L1147 partial scaffold (does not close). |
| 106 | Route 1 lemma + 5 attempts at L1179 | Route B continuation | 6 → 7 | +1 | Iter-106 plan added Route 1 lemma w/ dead-end body; iter-105 plan-phase refactor backed it out → 7 → 6. |
| 107 | option 3 attempt at L1120 | iter-105 plan | 6 → 6 | 0 | Option 3 with 7 routes failed; partial-commit stages h_iter104. |

The slot has been **PARTIAL or unchanged for 7 of 7 prover-bearing iters since iter-099** (excluding iter-102/104 which were on different targets). Net change in the count of sorries on this specific slot: zero. The streak is unequivocal.

## Subagent-finding summary (for iter-108 plan-agent's recommendations.md inputs)

### lean-auditor-iter105 (must-fix-this-iter: 4)

- L+B `Picard/LineBundle.lean:85-86` — **iter-104 critical RESTATED**: `LineBundle := CommRing.Pic Γ(X,⊤)` is wrong on the project's central target (smooth proper curves are not affine). User-decision item.
- `Modules/Monoidal.lean:166-173` — **iter-104 critical RESTATED**: `instIsMonoidal_W` is a `sorry`-bodied instance; "no consumers" claim is false (transitively consumed by `instMonoidalCategoryStruct`/`instMonoidalCategory`). Mathlib upstream gap + user-decision item.
- `Cohomology/StructureSheafModuleK.lean:27-31` — **NEW iter-105**: stale status block lying about 8 closed declarations. Plan-phase prose fix.
- `Rigidity.lean:19-23` — **NEW iter-105**: stale status block lying that `eq_of_eqOnOpen` is `sorry` (80+ iters stale). Plan-phase prose fix.

### lean-vs-blueprint-checker-basicopencech (must-fix: 0, major: 0, minor: 2)

- (minor) Blueprint Step 2 of `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` could mention `R`-linearity of the localized differential to justify the R-linearity scaffolding.
- (minor) `thm:cechCohomology_subsingleton_of_cechCochain_exactAt` (L1139) and `def:Scheme_splitEpi_pi_lift_of_injective` (L1121) lack `\uses{...}` annotations.

- **mv-fix verified**: broken `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` is gone; replacement is exhaustive.

## Iter-108 entry state (predicted)

Sorry inventory: BasicOpenCech **6** (unchanged); Differentials 5; Monoidal 1; Jacobian 1; Picard.Functor 1. Project total **14**.

**Iter-108 abort-policy options** (mutually exclusive — plan-agent picks one):

1. **(Preferred) Option A**: refactor subagent to eliminate the anonymous-closure Pi.lift root cause. Outcome: BasicOpenCech 6 → 6 (transient +1 on the new helper offset by Route 1's permanent removal); iter-109 prover closes L1120 + new helper.
2. **Option B**: re-dispatch strategy-critic mid-iter to validate the entire R-linearity-via-pi_smul route. No proof work; pure planning.
3. **Option C**: dispatch mathlib-analogist on `Pi.hom_ext` / `LinearMap.pi`. No proof work; analysis-only.

**Forbidden iter-108 patterns** (per progress-critic + strategy-critic + iter-108 abort policy): wrapper-helper continuation; heartbeat-budget escalation; new scalar-extraction tactic accumulation; body-local rfl-helper; `set` smul-target renaming; `change`/`show` with literal Pi.lift; `rcases n` for hPrev propagation; `← LinearMap.comp_apply` chain reversal. All confirmed dead across 7+ iters.

Mandatory iter-108 subagent dispatches (per the catalog): blueprint-reviewer, progress-critic, strategy-critic. All three are expected to re-evaluate; progress-critic-iter106 in particular will test whether the iter-108 plan-agent honors the streak escalation.

Additionally: iter-108 plan-agent must write `TO_USER.md` flagging the two lean-auditor critical findings (`LineBundle` weakened-wrong def + `instIsMonoidal_W` load-bearing sorry-instance), since the harness refreshes that file every iter and the user has not yet been alerted via the banner.

## Notes

- The prover's commit at L1115–L1120 is the iter-107 deliverable. It is honest in-flight infrastructure, not an excuse-commit: the comment block is 3 lines naming a specific blocker + pointing to the attempt log; `h_iter104` is concretely staged and consumable by iter-108.
- The iter-104 critical findings on `LineBundle` and `instIsMonoidal_W` have now persisted through 3 review cycles (iter-104 review, iter-105 plan + review). Neither has been surfaced to `TO_USER.md`. The lean-auditor's must-fix-this-iter classification is correctly persistent across iters; the loop's per-iter gating is functioning. Resolution requires user action, which the loop cannot trigger autonomously — but the loop can at minimum alert the user via `TO_USER.md`. **Action this review**: write the alert.
