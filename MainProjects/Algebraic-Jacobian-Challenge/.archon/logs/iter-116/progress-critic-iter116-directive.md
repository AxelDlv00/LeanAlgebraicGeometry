# Progress Critic Directive

## Slug
iter116

## Iter
116

## Active routes / files under review

### Route: `Differentials.lean` L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`

- **Started at iter**: 113 (the iter-113 prover introduced the `_isSheafUniqueGluing_type` sub-helper after pivoting away from the original L122 sheaf-condition formulation; the chain of L175-route prover dispatches is iter-112 → iter-113 → iter-115 with iter-114 being a no-prover deeper-think iter).
- **Iters audited**: 111–115 (K = 5).

#### Sorry counts per iter (file-level for `Differentials.lean`)

- iter-111: 5
- iter-112: 5 (file PARTIAL Bar B; helper #1 and #2 introduced; helper #2 closed; helper #1 sorry-bodied)
- iter-113: 5 (file PARTIAL Bar B variant; helper #1's body closed by delegating to a new sub-helper `_isSheafUniqueGluing_type`)
- iter-114: 5 (no prover lane; deeper-think iter; blueprint-writer + analogist dispatched)
- iter-115: 5 (file INCOMPLETE; only edits = docstring rewrite + `intro` advance; no closure)

#### Project total sorry counts per iter

- iter-111: 16
- iter-112: 16
- iter-113: 16
- iter-114: 16
- iter-115: 16

#### Helpers added per iter (top-level declarations on the L175 route)

- iter-111: 0 (no prover lane on `Differentials.lean` L175 — was a different prover round)
- iter-112: +2 (`_isSheafOpensLeCover_type` helper #1 sorry-bodied + `_isSheaf_type` helper #2 closed)
- iter-113: +1 (new sub-helper `_isSheafUniqueGluing_type` at L168 with sorry body; helper #1's body closed by delegation)
- iter-114: 0 (no prover lane)
- iter-115: 0 (no new sub-helper; prover deliberately stayed at 0 new helpers per iter-115 hard rules; only edits were docstring rewrite + `intro` advance)

Net across K iters: +3 helpers added, 0 sorries closed.

#### Prover statuses per iter

- iter-111: NO PROVER LANE (other Differentials work, not L175 — irrelevant to this route audit)
- iter-112: PARTIAL Bar B — helper #1 sorry-bodied; helper #2 closed; main body closed; "no off-the-shelf basis-to-X bridge" first surfaces in prover report
- iter-113: PARTIAL Bar B (variant) — prover SELF-CLASSIFIED as "reformulation rather than genuine mathematical progress"; introduced new sub-helper `_isSheafUniqueGluing_type` and closed helper #1 by delegating to it; bridge blocker phrase recurs
- iter-114: NO PROVER (deeper-think iter; blueprint-writer + analogist dispatched as the corrective for iter-113's prior STUCK status); analogist's persistent file `analogies/affine-basis-sheaf-bridge.md` confirms NEEDS_MATHLIB_GAP_FILL on the bridge
- iter-115: INCOMPLETE — Bar A NOT MET, Bar B NOT MET (no recipe step closed as a sound sub-helper), Bar C NOT TRIGGERED (no new sorry-bodied wrapper introduced); honest stop per iter-115 hard rules; "no off-the-shelf basis-to-X bridge" blocker recurs in prover's "Why Bar B was not achieved" section

#### Recurring blocker phrases

- "no off-the-shelf Mathlib lemma packages `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on `X`" (or near-verbatim variants) appears in iter-112 prover report, iter-113 prover report, iter-114 mathlib-analogist persistent file, iter-115 prover report. **4 of 5 audited iters** name this exact blocker. Iter-110 blueprint-writer report also names it transitively in the chapter `[gap]` annotation.
- "deferring to yet another sorry-bodied sub-helper" / reformulation pattern: iter-113 self-classification + iter-115 Bar C avoidance language. **Pattern recognized 2 of 5 iters**.

#### Planner's current proposal for this iter

Iter-116 plan-phase has paused the L175 lane via user escalation per the iter-115 review's primary recommendation (Option B). USER_HINTS.md was written this iter requesting decision among 3 options (build the Mathlib bridge / refactor to presheaf-only / declare named gap #8). **NO prover lane is dispatched on `Differentials.lean` this iter.** The iter-116 plan agent is asking you whether: (a) the user-escalation pause is the right response to the 5-iter STUCK signal you saw at iter-115 (your iter-115 verdict was STUCK with Primary corrective: PROCEED-as-corrective-then-judge); (b) any other route in the project's active set is starting to look STUCK / CHURNING (the planner's current set is just the L175 route — no other prover lane this iter).

## Out of scope

The planner is not considering prover dispatch on any of:
- `BasicOpenCech.lean` (Phase A; all 6 sorries off-limits this iter)
- `Modules/Monoidal.lean` L173 `instIsMonoidal_W` (named gap #1; off-limits)
- `Picard/LineBundle.lean` L82/L96 (named gap pair; off-limits)
- `Picard/Functor.lean` L181 `representable` (gated on Phase C3; off-limits)
- `Jacobian.lean` L179 `nonempty_jacobianWitness` (Phase C3 exit policy; off-limits)
- `Differentials.lean` other sorries: L737 `h_exact` (named gap #2; off-limits), L931 `smooth_iff_locally_free_omega` (Phase B prover-viable, scheduled iter-117+ but pending user response), L947 `cotangent_at_section` (Phase B prover-viable; scheduled later), L1091 `serre_duality_genus` (named gap #7; off-limits)

So the only active route on the planner's table this iter is the L175 lane, which is being paused via user escalation rather than dispatched.
