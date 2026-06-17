# Progress Critic Report

## Slug
iter132

## Iteration
132

## Routes audited

### Route 1: `AlgebraicJacobian/Cotangent/GrpObj.lean` (piece (i.a))

- **Sorry trajectory**: 0 → 0 → 0 → 0 across iter-128 to iter-131 in this file.
  Project-total sorry count is 3 across all four iters — **no project-level sorry
  elimination over 4 iters of activity on this route.**
- **Helper accumulation**: 2 declarations introduced across 4 iters
  (iter-128 `lieAlgebra` def; iter-131 `cotangentSpaceAtIdentity_eq_extendScalars`
  strong acceptance lemma). The *body* of the central declaration
  `cotangentSpaceAtIdentity` has been reworked **three times in four iters**:
  iter-129 rename + signature relaxation, iter-130 Replacement-(B) body swap,
  iter-131 `by`-tactic → pure-term `noncomputable def` refactor with
  `Classical.choose`-chain pattern.
- **Recurring blockers**:
  - "Classical.choice / `Nonempty` opacity" — appears in iter-130 lean-auditor
    must-fix AND iter-131 mathlib-analogist `ALIGN_WITH_MATHLIB` verdict on the
    iter-130 body. iter-131 refactor lane claims to have resolved this via
    term-mode rewrite.
  - "Computes zero `k`-module / kernel-clean but mathematically degenerate" —
    iter-129 mathlib-analogist verdict on iter-128 body. Resolved iter-130.
  - Pattern: **every "COMPLETE" prover status on this declaration has been
    flagged by a subsequent-iter critic as defective on a different structural
    ground.** Two distinct opacity classes already observed.
- **Prover status pattern**: COMPLETE (iter-128, later flagged degenerate) →
  NO-DISPATCH (iter-129 plan-phase refactor) → COMPLETE (iter-130, later
  flagged opaque) → NO-DISPATCH (iter-131 plan-phase refactor + no-op prover
  lane). Two COMPLETEs, two refactor iters. Both COMPLETEs were post-hoc
  invalidated structurally.
- **Verdict**: **CHURNING**

  Verdict rule application:
  - "Helpers added in ≥2 of last K iters" — matches (iter-128 + iter-131).
  - "Sorry count net unchanged or down by <1 per 2 iters" — matches
    (project-total flat at 3 across the 4-iter window).
  - "No structural change in approach" — partially fails: iter-131 *did*
    deliver a substantive structural change (term-mode + strong acceptance
    lemma + documented `[verified]` closure chain). That partial mismatch
    keeps the verdict at CHURNING rather than STUCK.
  - STUCK alternate clause "helpers added without any sorry-elimination
    across K iters" — strictly matches at the project-sorry level (2 helpers,
    0 sorries eliminated across 4 iters), but STUCK implies "stop the route,"
    which is the wrong action here because the planner's iter-132 proposal
    is the first sorry-elimination dispatch (rank lemma), not another body
    reshape. CHURNING with explicit tripwire is the correct read.
- **Primary corrective**: **Enforce meta-pattern tripwire on iter-132 outcome.**
  The planner's iter-132 proposal (scaffold + close
  `cotangentSpaceAtIdentity_finrank_eq` against the iter-131 body) is the
  right structural escalation — it's a sorry-elimination dispatch, not a
  fifth body reshape, and the iter-131 strong acceptance lemma + 6-step
  documented closure chain give it real evidence of closure-readiness.

  **However:** if iter-132 returns PARTIAL or surfaces a third opacity-class
  defect (e.g. rank-lemma closure blocked by a structural property of the
  iter-131 `Classical.choose` chain that wasn't visible in the
  `rfl`-acceptance test), the planner MUST NOT assign another body-reshape
  iter. Two body-reshape lanes already happened (iter-130 swap, iter-131
  refactor); a third would be definitional churn. Escalate instead:

  - First fallback: **user escalation** — surface the cumulative
    body-shape interaction count (now 4, entering iter-132) and the
    two-opacity-class record to the user with a concrete proposal-set
    (e.g. swap to direct quotient construction, or invert the abstraction
    layer so the rank is exposed at definition time).
  - Second fallback: dispatch `mathlib-analogist` AGAIN with a strictly
    different question than prior consults — "What is the canonical mathlib
    pattern for *defining* the cotangent space at the identity of a smooth
    group scheme such that its rank is *immediately* accessible via
    `Module.finrank` rewriting, without an intermediate
    `Classical.choose`-chain or `extendScalars` rewrite step?" The prior
    analogist consults answered correctness questions about chart base
    changes and opacity; this question targets shape-for-rank-access.
- **Secondary correctives**:
  - The iter-131 strategy-critic has already armed this tripwire in its
    directive language. Credit that; my role is to make it gate-enforced
    rather than advisory. The plan agent must, in iter-132's `plan.md`,
    name the explicit iter-133 plan branch ("if iter-132 PARTIAL → ...")
    in concrete terms, not in promise terms.

### Route 2: `AlgebraicJacobian/Jacobian.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 2 across iter-127 to iter-131.
- **Helper accumulation**: 1 declaration in iter-127 (scaffold), 0 in
  iter-128 through iter-131.
- **Recurring blockers**: none. The deferral is intentional and gated on
  downstream pieces (i.a)/(ii)/(iii) per current sequencing.
- **Prover status pattern**: NO PROVER DISPATCH × 5 iters. File off-limits.
- **Verdict**: **UNCLEAR** (intentionally deferred; no active iteration
  signals apply)
- **Primary corrective**: none. The file's off-limits status is the correct
  posture given the sequencing dependency on piece (i.a). When piece (i.a)
  closes, Route 2 unblocks; until then there is no churn signal to address.
  Planner's iter-132 proposal (file stays off-limits) is correct.

### Route 3: `AlgebraicJacobian/RigidityKbar.lean`

- **Sorry trajectory**: 1 → 1 → 1 → 1 → 1 across iter-127 to iter-131.
- **Helper accumulation**: 0 across all 5 iters.
- **Recurring blockers**: none. Deferral is intentional, gated on
  pieces (i.a)→(i.b)→(i.c)→(ii)→(iii) per STRATEGY.md sequencing.
- **Prover status pattern**: NO PROVER DISPATCH × 5 iters. File gated
  downstream.
- **Verdict**: **UNCLEAR** (intentionally deferred; no active iteration
  signals apply)
- **Primary corrective**: none. The iter-132 plan-phase blueprint-writer
  dispatch on `RigidityKbar.tex` Piece (i.a) prose is correct — that is
  prose-only work and does not affect the Lean route's deferral. No Lean
  prover lane on this file iter-132 is the correct call.

## Must-fix-this-iter

- **Route 1 (`AlgebraicJacobian/Cotangent/GrpObj.lean`)**: CHURNING —
  primary corrective: **enforce meta-pattern tripwire on iter-132 outcome
  with concrete iter-133 branch language in `plan.md`**. Why: 4 iters of
  body-shape work on one declaration, two critic-flagged defect classes,
  zero project-level sorry elimination; iter-131 refactor is genuinely
  structural so iter-132's rank-lemma dispatch is the right escalation,
  but iter-132's outcome is the 5th body-shape interaction and a third
  defect class would constitute definitional churn requiring user
  escalation rather than another reshape.

## Informational

- **Route 2 (`AlgebraicJacobian/Jacobian.lean`)**: UNCLEAR — intentionally
  deferred. Will unblock when piece (i.a) closes (Route 1's terminal state).
- **Route 3 (`AlgebraicJacobian/RigidityKbar.lean`)**: UNCLEAR — intentionally
  deferred. Gated downstream of multiple pieces; iter-132 blueprint-writer
  prose dispatch on the corresponding `.tex` chapter is not a Lean signal.

## Overall verdict

One route under active prover-lane review (Route 1) is CHURNING; two routes
(Routes 2 + 3) are correctly deferred and produce no churn signals because
they produce no activity signals. The planner's iter-132 proposal is
structurally correct — it escalates Route 1 from body-shape reshaping to
the first downstream sorry-elimination dispatch (rank lemma), which is the
right kind of move after three reshape iters. The corrective I'm naming
is not a redirection but a *gate*: the planner must commit, in iter-132's
`plan.md`, to an explicit iter-133 branch that does NOT include a fourth
body reshape on `cotangentSpaceAtIdentity`. If iter-132 PARTIALs or
surfaces a third opacity-class defect, the branch must be either user
escalation or a strictly novel `mathlib-analogist` question targeting
shape-for-rank-access (not chart base change or opacity, both already
consulted). Silently scheduling another body reshape on a CHURNING route
is the failure pattern this verdict exists to prevent.
