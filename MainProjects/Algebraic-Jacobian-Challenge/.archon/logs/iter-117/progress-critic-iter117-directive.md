# Progress-Critic Directive (iter-117)

## Slug

iter117

## Iteration

117

## Routes being considered for this iter's prover assignment

The planner is composing a fresh strategy in response to a substantive
user directive (verbatim from `USER_HINTS.md`: "find the best strategy
yourself, remove all wrong mathematical statements, no deferrals, clean
strategy file, detailed blueprints"). The active route set under
consideration:

### Route 1: `Differentials.lean` L191 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`

Last K=5 iters signals:

- iter-111: introduced helper #1 / #2 family at L168 / L235 (Bar B
  scaffolding). 0 sorries closed; 2 sorries added (file 3 → 5).
- iter-112: prover attempted helper #1 closure. PARTIAL. 0 sorries
  closed.
- iter-113: prover spawned new sub-helper L168
  `_isSheafUniqueGluing_type` and reformulated the residual. Honest
  self-classification: "reformulation rather than genuine
  mathematical progress." PARTIAL. 0 sorries closed.
- iter-114: deeper-think iter, NO prover lane. Mathlib-analogist
  consult returned `NEEDS_MATHLIB_GAP_FILL` on the affine-basis-to-X
  Scheme sheaf bridge (persistent `analogies/affine-basis-sheaf-bridge.md`).
  Blueprint-writer landed the corrected 3-step recipe.
- iter-115: single prover lane on L175 (= L191 now). Returned
  INCOMPLETE. Edits = docstring rewrite at L148–167 propagating 2
  Mathlib name corrections + structural `intro` advance. 0 sorries
  closed.

Recurring blocker phrase: "no off-the-shelf Mathlib bridge for
`Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X" (4 of
5 iters). Iter-116 plan-phase fired the hard-gate Option-B user
escalation; user has now responded with the substantive directive
above.

### Route 2: `Cohomology/BasicOpenCech.lean` L1846 `h_loc_exact`

Last K=5 iters signals:

- iter-108: prover landed Step 1a + 1b scaffolding (~30 LOC inline).
  PARTIAL. 0 sorries closed. Strategy-critic-iter108 confirmed the
  remaining work is mechanizable from existing Mathlib
  (`IsLocalizedModule.{Away,pi,prodMap}` + algebra adapter).
- iter-109 (narrative): prover landed Step 1c scaffolding (~20 LOC
  inline). PARTIAL. 0 sorries closed. Plan-phase fired Option (i)
  escape-valve: annotate sorry as `-- DEFERRED (budget): ...`.
- iter-110, 111, 112, 113, 114, 115, 116: route parked behind Phase
  B priorities; no prover lane.

Open status: budget-deferred per Option (i). The user directive
"nothing deferred" reactivates it.

### Route 3: `Differentials.lean` L931 `smooth_iff_locally_free_omega` (forward)

Last K=5 iters signals:

- No prover work in last 5 iters; signature has been corrected twice
  by plan-phase refactor directives (iter-113 + iter-115).
- Iter-114 strategy-critic decomposed the route into forward+converse
  with separate budgets.
- Iter-115 strategy-critic verified the closing lemma names
  (`Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` [verified],
  `Subsingleton (Algebra.H1Cotangent R S)` hypothesis).
- Iter-116 strategy-critic added bonus findings
  (`Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`,
  `AlgebraicGeometry.isSmoothOfRelativeDimension_iff`).

This route has NOT had prover-lane signal yet, so it's a fresh-route
candidate.

### Route 4: `Cohomology/BasicOpenCech.lean` L1120 `cechCofaceMap_pi_smul`

Last K=5+ iters signals:

- 7 consecutive PARTIAL iters across iter-100..107 on the same root
  cause (Pi.lift compositional wrapper engineering).
- iter-108, 109 (narrative): PAUSED per progress-critic-iter106/107/108
  STUCK verdicts.
- iter-110, 111, 112, 113, 114, 115, 116: route remains PAUSED.

Standing classification: PAUSED. The user directive "nothing deferred"
would reactivate it but the route's structural blocker (Q2 Path B
or Path A architectural refactor) has not been addressed.

## What you should produce

A standard progress-critic report covering all four routes:

- **Verdict per route**: CONVERGING / CHURNING / STUCK / UNCLEAR.
- **Primary corrective per route**.
- **Order recommendation**: given the user has just lifted the
  "indefinitely deferred" framing on Routes 2 and 4, AND the planner
  is reshaping STRATEGY.md, AND Route 3 has not had prover signal
  yet — which route(s) should the iter-117 prover lane(s) target?

The planner is genuinely undecided on this. Your verdicts should
include enough signal-side detail to make the call.

## Constraints (from descriptor)

- Do NOT read STRATEGY.md, blueprint, or "what the project is trying
  to prove" framing. Your value is fresh-context convergence
  detection.
- Acceptable directive content: route block + signals (the above).
- If the directive mistakenly contains broader context, ignore it.

The user-directive context in the opening section is NOT mathematical
framing — it's just the planner explaining WHY four routes are on the
table simultaneously this iter. Treat it as ambient context, not as
"what the project is trying to prove" leakage. Your job is still
narrow convergence analysis on the four route signal blocks above.

## Length

Whatever the audit warrants. Do not pad.
