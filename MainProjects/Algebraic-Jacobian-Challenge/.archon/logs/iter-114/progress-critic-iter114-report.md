# Progress Critic Report

## Slug
iter114

## Iteration
114

## Routes audited

### Route: AlgebraicJacobian/Differentials.lean — Phase B helper #1 / unique-gluing route (L122 → L177 → L175)

- **Sorry trajectory**: file-level **5 → 5 → 5 → 5** across iter-110 to iter-113. Project-total **16 → 16 → 16 → 16**. Net change over the 4-iter audit window: **zero sorry-eliminations**.
- **Helper accumulation**: iter-110 and iter-111 had no prover dispatched (deeper-think / blueprint-writer iters), so they cannot count for or against the route's prover-side momentum. The two iters that *did* dispatch a prover both added helpers:
  - iter-112: +2 top-level helpers (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type` at L159 with a sorry body; `relativeDifferentialsPresheaf_isSheaf_type` at L188 closed). Main theorem body closed.
  - iter-113: +1 top-level helper (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type` at L168 with a sorry body). The previous iter's helper at L209 was closed, but the residual mathematical content was migrated into the new sub-helper. The iter-113 prover characterized this in their own report as a **"reformulation rather than genuine mathematical progress"** — the unique-gluing and OpensLeCover forms are Mathlib-verified equivalent. Net effect: one closed helper, one new sorry-bodied helper carrying the same residual.
- **Recurring blockers**:
  - **"no off-the-shelf Mathlib lemma packages sheaf-on-affine-basis-of-Scheme ⇒ sheaf for Scheme.PresheafOfModules"** — verbatim recurrence across iter-110 blueprint-writer report, iter-112 prover report, and iter-113 blueprint chapter `[gap]` callout. That is **3 of 4** audited iters and **2 of 2** prover-bearing iters. The reformulation in iter-113 did not move this blocker; it simply changed which named predicate the blocker hides behind.
  - **"Bar B (acceptable, single sub-lemma close): the residual moves into one new sub-helper"** — appears verbatim in iter-112 PROGRESS.md as the *target* outcome and again in iter-113 as the *actual* outcome. The route has now matched the Bar B shape two iters running without progressing past it.
- **Prover status pattern**: `(no prover) → (no prover) → PARTIAL → PARTIAL`. On the prover-bearing iters alone: **PARTIAL → PARTIAL**, with the second PARTIAL explicitly self-flagged by its own author as non-substantive.

#### Verdict-rule trace

Applied verbatim per the directive's rule set with K = 4:

- **CONVERGING**: requires "sorry count strictly decreasing in K-iter window AND no recurring blocker." Fails on both clauses — sorry count is flat at 5 and the Mathlib-gap blocker phrase recurs across 3 iters.
- **CHURNING**: first disjunct met — helpers added in ≥2 of last K iters (iter-112, iter-113), sorry count net unchanged (5 → 5), no structural change (the prover's own admission). Second disjunct (PARTIAL ≥3 of K) is not strictly met because two of the four iters had no prover, but the first disjunct alone qualifies.
- **STUCK**: **both disjuncts met independently.**
  - First disjunct: sorry count unchanged across K iters (yes) **AND** recurring blocker phrase across ≥3 iters (yes — the Mathlib-bridge phrase recurs in iter-110, iter-112, iter-113).
  - Second disjunct: helpers added (yes, in both prover-bearing iters) **without any sorry-elimination across K iters** (yes — file-level count never moved off 5; the helpers introduced in iter-112 were either resolved-by-migration or carried forward, not net-eliminated).

Per the tiebreaker rule ("STUCK > CHURNING"), the verdict is **STUCK**.

- **Verdict**: **STUCK**

- **Primary corrective**: **Mathlib analogy consult.** Dispatch `mathlib-analogist` (or the project's equivalent) on the load-bearing predicate `Scheme.PresheafOfModules ⊢ IsSheaf` and its hoped-for affine-basis bridge **before** committing iter-114's prover slot to another sorry-bodied sub-helper round. The recurring blocker phrase has been *cited* across three reports but never *independently audited*. The planner's iter-114 3-step recipe explicitly contains the same bridge as step (2) "structure-sheaf gluing" — if no off-the-shelf Mathlib bridge exists, the recipe will produce a Bar B outcome identical in shape to iter-112 and iter-113. The analogist needs to answer two specific questions: (a) is there a Mathlib lemma along the lines of `Scheme.PresheafOfModules.IsSheaf.of_isSheaf_affineCover` / `PresheafOfModules.isSheaf_iff_isSheaf_affineCover` / `Scheme.AffineOpenCover`-keyed gluing that the project has not surveyed; (b) if not, is `Scheme.PresheafOfModules`-as-sheaf even the right predicate, or should the project shift to `SheafOfModules.{u}` / `Sheaf (Opens X)` / `Scheme.OpenCover`-indexed gluing?
  This is a **cheap unstick attempt** — analogist is read-only on `.lean` files, fast, and either gives the iter-114 prover a concrete named API to drive against (CHURNING risk drops) or it confirms the gap is real (which is itself useful: it tells us the route IS doomed in its current form, justifying the secondary corrective). Either way, the planner should NOT dispatch a fourth iter on the same Bar-B shape without the analogist's findings first.

- **Secondary corrective**: **Route pivot**, conditional on mathlib-analogist confirming the Mathlib gap is real. If no off-the-shelf bridge exists, the planner should treat the bridge itself as the real obligation and route iter-115 either (i) directly toward closing the bridge as a series of explicit sublemmas inside Differentials.lean (i.e. accept that the load-bearing residual is the sheaf-on-affine-basis-to-full-Scheme step and stop hiding it behind reformulations), or (ii) revisit STRATEGY.md to find a proof structure for the original L122 obligation that does not require this bridge at all. If the planner takes this route, mid-iter re-dispatch of `strategy-critic` is appropriate to validate the pivot.

## Must-fix-this-iter

- **Route: AlgebraicJacobian/Differentials.lean — Phase B helper #1 / unique-gluing route**: **STUCK** — primary corrective: **mathlib analogy consult** on the `Scheme.PresheafOfModules`-sheaf-from-affine-basis predicate. **Why**: zero sorry-eliminations in 4 iters; the load-bearing Mathlib-bridge blocker phrase recurs verbatim across 3 of those iters; the iter-113 prover self-classified their own output as a reformulation; the iter-114 proposal contains the same bridge as a recipe step. Another sorry-bodied sub-helper round without first auditing the blocker independently will produce a fourth consecutive PARTIAL with the same residual.

## Informational

None — the single audited route lands as STUCK and is must-fix.

## Overall verdict

One route audited; one **STUCK**. The planner's iter-114 proposal — a Phase B prover lane on `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` with a concrete 3-step recipe — is a genuine intent-level escalation (it names specific Mathlib lemmas, sets an explicit Bar C regression detector, and the prose blueprint-writer dispatch will align prose to the unique-gluing form). That intent is credited; however, the *signals* across the K = 4 audit window are unambiguous: the load-bearing blocker is a Mathlib-side gap that has now been parroted across three reports without independent audit, and two consecutive prover iters have produced reformulations rather than net sorry-eliminations. **Before iter-114 spends its prover slot on this route, the planner should insert a single `mathlib-analogist` dispatch on the load-bearing predicate** — this is a fast, read-only call whose outcome either (a) hands the iter-114 prover the named Mathlib API the route has been missing, sharply lowering the Bar-C risk, or (b) confirms the gap is real, which justifies pivoting STRATEGY.md rather than running a third iter of the same shape. The iter should *not* proceed straight to "another Bar-B sub-helper round" — that is exactly the pattern this verdict exists to prevent.
