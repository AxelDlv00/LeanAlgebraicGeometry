# Progress Critic Directive

## Slug
iter118

## Iter
118

## Active routes / files under review

The iter-118 plan agent is considering exactly **one** active route for
prover dispatch this iter, but the blueprint-reviewer hard-gate on the
relevant blueprint chapter has **deferred** the prover round this iter
(the chapter needs a writer pass + the Lean signature needs a refactor
pass before any prover can be assigned). Your audit is of the active
route's *trajectory*, not the immediate this-iter status.

### Route: `AlgebraicJacobian/Differentials.lean:74` `smooth_iff_locally_free_omega` → `smooth_locally_free_omega`

- **Started at iter**: 117 (file was rewritten by the iter-117 refactor
  from ~1100 LOC → 83 LOC; the surviving theorem is the iter-117
  refactor's final state of a previous iff-form route that had been
  active since iter-109+ under several earlier names).
- **Iters audited**: 113, 114, 115, 116, 117 (K = 5).

#### Sorry counts per iter (project-wide; `Differentials.lean` per-file)

- iter-113: project 16; `Differentials.lean` 5.
- iter-114: project 16; `Differentials.lean` 5.
- iter-115: project 16; `Differentials.lean` 5.
- iter-116: project 16; `Differentials.lean` 5.
- iter-117: project **2** (−14 via aggressive trim); `Differentials.lean` 1
  (4 sorries deleted as orphan-to-protected-chain; 1 survivor refactored
  to the iter-118 in-flight target).

#### Helpers added per iter (`Differentials.lean`)

- iter-113: 0 new declarations; 1 docstring rewrite + `intro` advance.
- iter-114: 0 new declarations (prover-round was a corrective package
  spawn — blueprint-writer + mathlib-analogist, not Lean-side helpers).
- iter-115: 0 new declarations; docstring rewrite at L148–167 +
  structural `intro` advance at L191. INCOMPLETE; no sub-helper landed.
- iter-116: 0 new declarations (user-escalation pause; no prover lane).
- iter-117: −9 declarations net (file rewritten from ~1100 → 83 LOC;
  4 cotangent / Serre-duality declarations deleted; 1 declaration
  refactored to presheaf form — the iter-118 target).

#### Prover statuses per iter (`Differentials.lean` if dispatched)

- iter-113: PARTIAL (self-classified non-substantive reformulation).
- iter-114: PARTIAL (corrective package iter; no Lean-side prover lane).
- iter-115: **INCOMPLETE** (iter-115 review classified as below-PARTIAL).
- iter-116: NOT DISPATCHED (user-escalation pause).
- iter-117: NOT DISPATCHED (refactor-only iter; aggressive trim).

#### Recurring blocker phrases

- "affine-basis-bridge missing from Mathlib" (or equivalent
  paraphrases — "no off-the-shelf basis-to-X bridge", "the blueprint's
  3-step recipe is internally entangled at the Mathlib level") appears
  in iter-113, iter-114, iter-115 reports.
- Iter-115's "Bar B not achieved" section names the blocker verbatim.
- The iter-115 hard gate fired in iter-116 on these grounds.

#### Planner's current proposal for this iter

The iter-118 plan agent is **deferring** the prover lane on
`Differentials.lean` per the blueprint-reviewer's hard-gate finding
(the blueprint chapter `Differentials.tex` is `correct: false` because
the iff statement is mathematically false in the converse direction;
the Lean signature needs a refactor to a forward implication first).
Iter-118 dispatches two `blueprint-writer` calls (on `Differentials.tex`
and on `Jacobian.tex`) plus one `refactor` call (on `Differentials.lean`
to demote iff → forward implication). The prover lane on the corrected
signature is scheduled for iter-119.

Iter-118's expected outcome: project sorry count unchanged at 2, but
the signature on `Differentials.lean:74` becomes mathematically correct
(was: false iff; will be: provable forward implication). Iter-119 then
closes the corrected forward implication via the verified Mathlib
chain `smoothOfRelativeDimension_iff` →
`IsStandardSmoothOfRelativeDimension.isStandardSmooth` →
`IsStandardSmooth.free_kaehlerDifferential` instance +
`IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` →
project-local `relativeDifferentialsPresheaf_obj_kaehler`.

The question for you: given the iter-113 → iter-117 trajectory
(repeated PARTIAL / INCOMPLETE, the affine-basis-bridge blocker phrase
appearing 4 of 5 iters before the iter-117 aggressive TRIM repaved
the route), is this route now **CONVERGING** (the iter-117 trim
removed the structural blocker; iter-118 corrects the residual iff
statement; iter-119 closes the forward direction on a clean signature),
or is the iter-118 defer-then-refactor cycle just another helper-churn
episode under a different shape?

The iter-118 plan agent's read: the iter-117 trim was a structural
advance (project sorry 16 → 2 — the project's largest single-iter
reduction). The iter-118 correctness fix is a one-time signature
adjustment, not another helper round. Iter-119 should then close
cleanly. But the planner is in the project's context and is
naturally invested in this read; you are the corrective.
