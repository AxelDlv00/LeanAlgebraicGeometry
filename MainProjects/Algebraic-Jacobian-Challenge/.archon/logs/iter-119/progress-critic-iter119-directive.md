# Progress Critic Directive

## Slug
iter119

## Iter
119

## Active routes / files under review

### Route: `AlgebraicJacobian/Differentials.lean` — `smooth_locally_free_omega` (forward direction)

- **Started at iter**: 117 (route reset by aggressive TRIM; declaration renamed iter-118 from
  `smooth_iff_locally_free_omega` (iff form, mathematically false) to
  `smooth_locally_free_omega` (forward-only).
- **Iters audited**: 115 → 116 → 117 → 118 → 119 (5 iters; K=5)

#### Sorry counts per iter (project total / Differentials.lean)

- iter-115: 16 / 5 (pre-trim era; multiple Differentials sorries: unique-gluing, h_exact, smooth-iff, cotangent_at_section, serre-duality)
- iter-116: 16 / 5 (user-escalation pause; no prover dispatch)
- iter-117: 2 / 1 (aggressive TRIM; 14 sorries removed across 5 files including 4 Differentials orphans; `Differentials.lean` rewritten 1100 → 83 LOC; only the iff form of smooth-iff remained)
- iter-118: 2 / 1 (correctness-fix: iff form demoted to forward-only; sorry moved L81 → L93)
- iter-119 (entering): 2 / 1 (no change; iter-119 prover lane scheduled)

#### Helpers added per iter (Differentials.lean only)

- iter-115: 0 (PARTIAL/INCOMPLETE prover round on the iff-form-which-couldn't-close; no new helpers landed)
- iter-116: 0 (no prover dispatch)
- iter-117: 2 helpers preserved (`relativeDifferentialsPresheaf`,
  `relativeDifferentialsPresheaf_obj_kaehler`); file rewritten to single
  forward direction declaration
- iter-118: 0 (refactor only; signature corrected; no new helpers)
- iter-119: 0 (entering; no prover dispatch yet)

#### Prover statuses per iter

- iter-115: INCOMPLETE (affine-basis-bridge blocker re-recurrence; user escalation triggered)
- iter-116: SKIPPED (user-escalation pause; no prover dispatch)
- iter-117: SKIPPED (aggressive TRIM only; no prover dispatch)
- iter-118: SKIPPED (refactor/blueprint only; correctness fix only; no prover dispatch — deferred to iter-119 per blueprint-reviewer hard gate)
- iter-119 (entering): pending — scheduled for this iter

#### Recurring blocker phrases (verbatim from task_results in the audit window)

iter-115 task result on Differentials.lean carried these recurring phrases:
- "affine-basis-bridge blocker"
- "no off-the-shelf basis-to-X bridge"
- "blueprint's 3-step recipe is internally entangled at the Mathlib level"

NONE of those blockers apply to the **post-iter-117 trim signature** because:
- The unique-gluing residual (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type`) was DELETED iter-117.
- The cotangent exact-sequence h_exact gap was DELETED iter-117.
- The Serre-duality genus identity was DELETED iter-117.
- The iter-117 surviving signature was the iff form of smooth/Ω-locally-free, NOT the unique-gluing residual.
- The iter-118 refactor demoted the iff form to a forward-only direction. The forward direction has a fully-verified Mathlib chain (verified this iter via lean_run_code: all 6 closing lemmas exist in `b80f227` — see iter-119 sidecar for the slate).

The iter-119 prover lane therefore starts against a **fresh, correctness-corrected, blueprint-aligned target** with no inherited blockers. The pre-iter-117 history is on a different declaration shape entirely.

#### Watch criteria committed by iter-118 progress-critic

Per iter-118 plan-phase, the progress-critic-iter118 returned UNCLEAR and committed
these resolution rules for the iter-119 outcome:

1. If iter-119 prover round on `smooth_locally_free_omega` returns COMPLETE: route was
   CONVERGING; iter-117 trim was vindicated.
2. If iter-119 returns PARTIAL/INCOMPLETE with a NEW recurring blocker phrase: iter-120
   verdict is CHURNING; primary corrective = `mathlib-analogist` on the named verified
   Mathlib chain.
3. If iter-119 returns PARTIAL without a new blocker (ergonomics-only): iter-120 may
   proceed with polish lane; verdict stays UNCLEAR-trending-CONVERGING.

This iter is the resolution. Your verdict feeds iter-120's response to the iter-119
prover outcome.

## My ask

For the route `Differentials.lean` `smooth_locally_free_omega`, please render the
CONVERGING/CHURNING/STUCK/UNCLEAR verdict for whether this iter's planned prover
dispatch is the right next move. Note: the iter-118 plan-phase already triaged the
iter-117 reset; the question for you is whether the signals justify dispatching the
prover lane this iter (rather than CHURNING-style continued chaffing).
