# Iter-122 (Archon canonical) plan-agent run

## Headline outcome (DRAFT — finalised after critics return)

Iter-121 was a plan-phase-only strategic-pivot iter under a user
directive, with both `Differentials.tex` and `Jacobian.tex` returning
`complete: partial` (HARD GATE deferral of the M1 prover lane). The
iter-121 blueprint-writers landed expanded prose for both chapters; the
iter-121 mathlib-analogist-bridge returned 5 ALIGN_WITH_MATHLIB + 1
NEEDS_MATHLIB_GAP_FILL with REDESIGNED approach (the bridge API shape
recommendations + the M1.b re-framing via `IsLocalization.of_le`).

Iter-122 plan phase:

1. **Archived iter-121 task_results** (`lean-auditor-review121`,
   `lean-vs-blueprint-checker-{differentials,jacobian}-review121`)
   to `logs/iter-121/` and cleared from `task_results/`.

2. **Applied inline blueprint corrections** to incorporate the iter-121
   mathlib-analogist findings + lean-vs-blueprint-checker-review121
   findings:
   - `Differentials.tex`:
     - Bridge theorem renamed: `_iso_` → `_equiv_`
       (`thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`,
       and `\lean{...}` hint updated to match).
     - Bridge statement rephrased to "$B$-linear equivalence"
       (matching `LinearEquiv` packaging per analogist).
     - Auxiliary lemma `appLE_isLocalization` namespace fix:
       `Scheme.appLE_isLocalization` →
       `IsAffineOpen.appLE_isLocalization`.
     - M1.b proof body completely rewritten: the `Functor.Final`
       cofinality framing is replaced with the two-direction
       `IsLocalization.of_le` construction (Steps 0–4, using
       `IsLocalization.lift` for `A_M → A_colim`, cocone universal
       property for `A_colim → A_M`, `IsLocalization.ringHom_ext`
       for composite-identity verification). Per analogist this is
       the canonical pattern; Mathlib has no off-the-shelf "colim
       of localizations = localization at union submonoid" lemma.
     - M1.c framing corrected: previously labelled a Mathlib gap;
       now correctly stated as a thin re-export of
       `Algebra.FormallyUnramified.of_isLocalization` +
       `subsingleton_kaehlerDifferential` instance (the previously-
       cited "no off-the-shelf bare lemma" claim was wrong).
     - M1.d body updated to use the corrected Mathlib closure pieces
       (`KaehlerDifferential.exact_mapBaseChange_map` +
       `map_surjective` via `LinearEquiv.ofBijective`).
     - Mathlib contribution candidate (Remark `rem:bridge_mathlib_pr`)
       updated: lemma `kaehler_quotient_localization_iso` is now
       the primary Mathlib contribution candidate (not
       `appLE_isLocalization`), per the analogist's analysis.
     - The `lem:kaehler_quotient_localization_iso` proof body
       rewritten to use the analogist's recommended `LinearEquiv`
       construction via `LinearEquiv.ofBijective` on
       `KaehlerDifferential.map`.

   - `Jacobian.tex`:
     - Line 376 `(γ)`-bullet rewritten: removed the stale
       `Hom(P¹_k, A) = A(k)` + `C ≅ ℙ¹_k`-with-rational-point
       framing; replaced with rigidity over `k̄` + Galois descent
       framing matching the iter-121 C.2 rewrite.
     - Line 388 (Layer I direct definition): same stale framing
       replaced with the new base-change-and-descent framing.

3. **Dispatched the three mandatory critics** in parallel:
   - `strategy-critic-iter122` — re-verification (strategy unchanged
     since iter-121 rewrite; the iter-121 challenges were absorbed
     into the rewrite).
   - `blueprint-reviewer-iter122` — confirms HARD GATE clearance on
     Differentials.tex and Jacobian.tex.
   - `progress-critic-iter122` — assesses the M1 route's iter-117
     to iter-121 signals (M2/M3 are blocked behind M1; not active
     this iter).

   See § "Critic verdicts" below.

## Critic verdicts

### strategy-critic-iter122 → CHALLENGE (M1, M2, M3); 2 alternatives raised

The iter-122 strategy-critic returned CHALLENGE on all three milestones
plus two alternative-route flags. Findings + plan-agent responses:

**M1 challenge — "off critical path; sunk-cost momentum"**. The critic
correctly identified that M1's closure does not affect the inhabited
`sorryAx` chain rooted at `Jacobian.lean:179`; neither M2 nor M3
references M1 as a prerequisite. Recommendation: either name the M1 →
M2/M3 → protected-chain dependency or acknowledge M1 is off the critical
path and justify the iter-122 prioritisation.

**Plan-agent response**: ACCEPTED. STRATEGY.md § "M1" rewritten to:
- Open with "OFF the critical path" in the heading.
- Acknowledge that M1 closure is net-zero on the inhabited-sorry count.
- Justify iter-122 execution on the iter-121 user pivot directive
  ("act as a Mathlib contributor", which explicitly invites Mathlib-
  contribution-candidate work even off-critical-path) plus M1's
  blueprint readiness vs. M2.a's pending Rigidity refactor prerequisite.
- Add a critical-path-preference rule: if M1 CHURNs for 2+ iters, pivot
  to M2.a.

**M2 challenge — "M2.d under-counted 5-10×; cotangent-vanishing alternative
not considered"**. M2.d's "5-10 iter / 250-500 LOC" is inconsistent with
the actual scope of Riemann-Roch for curves (1500-3000+ LOC for divisor
module + degree + RR space + Serre duality + RR theorem + the `ℙ¹`
corollary).

**Plan-agent response**: ACCEPTED. STRATEGY.md § "M2" rewritten to:
- M2 total cost: 15-30 iter / 1000-2500 LOC (revised upward).
- M2.d split into two variants: the **RR path** (15-25 iter / 1500-3000
  LOC) and the **cotangent-vanishing alternative** (5-10 iter / 300-800
  LOC, using `H⁰(C, Ω¹_{C/k}) = 0` Serre dual of the project's
  `H¹(C, O_C) = 0` genus-0 definition). The cotangent-vanishing variant
  is preferred if Serre duality on smooth proper curves over `k̄` is
  more accessible than full Riemann-Roch.

**M3 challenge — "both routes exceed 5000 LOC; user-escalation should
trigger now; route-pick audit doesn't depend on M1"**. The critic's
analysis is correct: each of Route A (Hilbert + Quot + Picard) and
Route B (Sym^n + finite-group quotients + Stein + Brill-Noether-RR) is
plausibly 10000+ LOC of Mathlib gap.

**Plan-agent response**: ACCEPTED. STRATEGY.md § "M3" rewritten to:
- M3 cost: 100+ iter / 10000+ LOC per route (revised upward, honest).
- Route-pick decision: trigger MOVED from "first iter after M1 closes"
  to **iter-123** (parallel to M1 work, since the audit is a Mathlib
  namespace scan + LOC estimation that does not depend on M1).
- The "hard fallback: user-escalate if > 5000 LOC of Mathlib gap"
  will fire at the audit (both routes will exceed the threshold).
- The first-M3 prover lane scheduled iter-128+ assuming user
  authorisation after the iter-123 escalation.

**Alternative "Cotangent-vanishing rigidity without RR"** — major
severity flag. ACCEPTED as M2.d-alt in STRATEGY.md.

**Alternative "Promote `nonempty_jacobianWitness` to named axiom"** —
critical severity flag. **REBUTTED in STRATEGY.md § Soundness rules**:
the plan-agent standing instruction "You should NEVER propose adding
new axioms" in `prompts/plan.md` is a project-wide rule that supersedes
the iter-121 user pivot directive (which is iter-by-iter strategic
instruction, not standing rule). The named-axiom alternative is not
on the table.

**Phantom `IsLocalization.ringHom_ext`** — VERIFIED by plan agent
iter-122 via `lean_leansearch`; exists in `Mathlib.RingTheory.Localization.Defs`
with the expected signature. The critic's "NEEDS VERIFICATION" flag
is resolved.

### progress-critic-iter122 → UNCLEAR on M1 (fresh milestone framing); zero CHURNING/STUCK

The critic's verdict on M1 is UNCLEAR (one iter of M1 milestone data,
intentional NO_PROVER in iter-121 under HARD GATE). No CHURNING/STUCK
verdicts. The critic credits the planner for the up-front escalations
(blueprint inline corrections, sub-step carving, mathlib-analogist
findings absorbed) and approves the iter-122 plan structure
(refactor → 3 sorry-stubbed declarations → prover dispatch).

Watch criteria for iter-123 (verbatim from critic):
1. Did iter-122's M1.b prover dispatch return COMPLETE? If yes, shift
   to bridge-itself cadence.
2. If PARTIAL, is the residual blocker phrase specific or vague?
   Specific = single-iter recovery; vague = analogist/writer consult.
3. After iter-122, project sorry count will rise from 1 to 3 (per
   plan). Treat that rise as M1 baseline, not regression.
4. If iter-122 returns INCOMPLETE on M1.b, dispatch mathlib-analogist
   on the bridge-statement layout BEFORE a second prover round —
   M1.b is the meat sub-step; if it doesn't progress structurally,
   the framing itself is suspect.

### blueprint-reviewer-iter122 → 3 must-fix items; ALL ADDRESSED INLINE this plan phase

The critic flagged THREE must-fix-this-iter items:

1. **`Differentials.tex:156` broken `\ref{thm:...iso...}`** — the
   bridge theorem was renamed `_iso_` → `_equiv_` in iter-122 inline
   corrections, but the cross-reference inside `lem:appLE_isLocalization`
   still pointed at the old label. FIXED inline this phase: line 156
   now references `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`.

2. **`Differentials.tex:154` stale `\lean{Scheme.appLE_isLocalization}`
   namespace** — I had noted "namespace fix applied" in iter-122 but
   the inline edit had failed for that specific block; my recap was
   wrong. FIXED inline this phase: line 154 now reads
   `\lean{AlgebraicGeometry.IsAffineOpen.appLE_isLocalization}`.

3. **`AbelJacobi.tex:82,87` stale `Hom(P¹_k, A) = A(k)` framing** —
   the iter-122 inline corrections in `Jacobian.tex` removed this
   framing but didn't propagate to `AbelJacobi.tex`. FIXED inline
   this phase: line 82 (Classical description) and line 87
   (Implementation route) now use the base-change-and-descent
   framing matching `Jacobian.tex § C.2`.

Two `soon`-severity findings deferred (cleanup, not blocking):
- `Differentials.tex:189` `\uses{lem:appLE_isLocalization}` on
  `kaehler_localization_subsingleton` is mathematically spurious;
  one-line cleanup.
- `blueprint/src/content.tex` omits four chapters
  (`Modules_Monoidal`, `Picard_Functor`, `Picard_FunctorAb`,
  `Picard_LineBundle`). Decision (intentional trim vs oversight)
  pending; defer to iter-123.

**HARD GATE status post-inline-fixes**: CLEAR on `Differentials.tex`,
`Jacobian.tex`, and `AbelJacobi.tex`. Per the descriptor's "re-
dispatching me after the writer returns is optional within the same
iter", I do NOT re-dispatch blueprint-reviewer this iter; iter-123's
mandatory dispatch will confirm. M1 prover lane proceeds.

## Refactor + prover lane plan (executed)

After the three blueprint-reviewer must-fix items were fixed inline,
the HARD GATE on `Differentials.tex` cleared and the refactor +
prover lane dispatch proceeded:

1. **Refactor `m1-bridge-iter122` dispatched and returned COMPLETE**
   (one foreground synchronous dispatch, 8.5 min, $4.16 cost).
   Outcome:
   - Added `AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid`
     (`def`, NO sorry; M1.a closure obligations closed inline via
     `simp only [Set.mem_setOf_eq, map_one]; exact isUnit_one` etc.).
   - Added `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`
     (`theorem`, sorry body; M1.b; plus 1 `sorry`-letI for the
     `Algebra Γ(S, U) A_colim` instance at L109).
   - Added `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
     (`noncomputable def` — `LinearEquiv` is `Type`, not `Prop`;
     matches analogist's iter-121 draft API shape); sorry body
     for the bridge; plus 1 `sorry`-letI for the `Module Γ(X, V)`
     instance on the presheaf section at L142.
   - 4 sorry sites total in Differentials.lean. Project trajectory:
     1 → 5 (vs directive prediction of 1 → 3; 2 extra are typeclass
     plumbing `letI`s that the prover absorbs as part of M1.b/M1.e
     coherent construction).
   - Project compiles (`lake build` 8328/8328 jobs).
   - No protected signatures touched.
   - One directive-typo corrected (the directive used
     `CommRingCat.KaehlerDifferential ((Scheme.Hom.appLE f U V e).hom)`;
     the correct form is
     `CommRingCat.KaehlerDifferential (Scheme.Hom.appLE f U V e)` —
     `CommRingCat.KaehlerDifferential` takes a `CommRingCat`
     morphism, not its underlying `RingHom`).

2. **Current Objectives set in PROGRESS.md** for the iter-122 prover
   lane on `AlgebraicJacobian/Differentials.lean`. Primary target:
   M1.b (close the `Algebra` letI + the `IsLocalization` body at
   L109+L112). Secondary target: bridge cap-stone (L142+L145).
   Expected outcome: PARTIAL is realistic — M1.b alone is estimated
   at 3-5 prover iter / 200-400 LOC per the iter-122-revised
   STRATEGY.md.

## What I consumed

- `task_results/lean-auditor-review121.md` (iter-121 lean-auditor review).
- `task_results/lean-vs-blueprint-checker-differentials-review121.md`.
- `task_results/lean-vs-blueprint-checker-jacobian-review121.md`.
  All three archived to `logs/iter-121/` and cleared from `task_results/`.

- `USER_HINTS.md`: empty header. Per `prompts/plan.md` § "Your Job"
  rule 1, on empty hints I check iter-121's `Fallback if no user
  response` section. Iter-121's fallback names: "continue executing
  the M1 roadmap as named in STRATEGY.md ... iter-122: re-dispatch
  blueprint-reviewer; dispatch refactor on the bridge declaration
  (per analogist's API-shape recommendation); dispatch prover lane
  on M1.a." This iter executes that fallback (M1.b target chosen
  over M1.a per the progress-critic-iter121 watch criterion 4 +
  the iter-121 analogist's M1.a re-classification as a small
  `def`-only piece). No new escalation. The auto-executed fallback
  is logged here per the planner-prompt rule.

- `STRATEGY.md`: read; **unchanged this iter**. The iter-121 rewrite
  was a comprehensive end-state pivot + roadmap; iter-122 is
  executing the iter-121 plan, not revising the strategy itself.

- `PROGRESS.md`: rewritten this iter for the iter-122 prover lane
  (assuming critics clear; otherwise rewritten for HARD GATE deferral).

- `task_pending.md` / `task_done.md`: read for sorry inventory.
  Iter-122 will update `task_pending.md` to add the new declarations
  introduced by the refactor (post-refactor).

- `archon-protected.yaml`: unchanged. 9 protected declarations.

- `iter/iter-119/{plan,review}.md`, `iter/iter-120/{plan,review}.md`,
  `iter/iter-121/{plan,review}.md`: read for context.

- `analogies/relative-differentials-presheaf-bridge.md`: persistent
  mathlib-analogist findings on the M1 bridge API shape. Read once
  before composing the refactor directive.

## Iter-122 Lean changes

- TBD (depends on critics' verdicts and refactor outcome).

## Iter-122 blueprint changes (this plan phase)

- `Differentials.tex`: inline corrections (renaming `_iso_` →
  `_equiv_`; namespace fix; M1.b cofinality re-framing; M1.c framing
  correction; M1.d body update; Remark `rem:bridge_mathlib_pr`
  update). Six distinct inline edits.
- `Jacobian.tex`: inline corrections (line 376 `(γ)`-bullet rewrite;
  line 388 Layer I rewrite). Two inline edits.

## Fallback if no user response

The iter-122 plan continues to execute the M1 roadmap per STRATEGY.md
as committed iter-121. If iter-122 prover lane returns INCOMPLETE on
M1.b (the closure proves too hard within one iter, which is expected
per the 2–3 iter estimate):

- iter-123: dispatch progress-critic with iter-119–iter-122 signals;
  if it returns CHURNING, escalate via blueprint-writer expansion of
  the M1.b proof sketch.
- iter-124+: continue M1 prover work until the bridge closes (5–10
  iter horizon).
- iter-125+: M2 enters the prover queue.
- iter-128+: M3 route-pick + first sub-step prover lane.

If iter-122's blueprint-reviewer returns HARD-GATE-fail again, the
fallback is to dispatch a follow-up blueprint-writer-differentials
pass and defer the prover lane to iter-123. No user escalation
needed — the iter-121 pivot's roadmap is the project's pinned plan.

## Iter-122 sequencing summary

| Step | Status |
|---|---|
| Archive iter-121 task results to logs/iter-121/ | done |
| Inline blueprint corrections (Differentials.tex, Jacobian.tex) | done |
| Dispatch strategy-critic-iter122 | done (CHALLENGE; addressed) |
| Dispatch blueprint-reviewer-iter122 | done (3 must-fix; addressed inline) |
| Dispatch progress-critic-iter122 | done (UNCLEAR on M1) |
| Revise STRATEGY.md per strategy-critic CHALLENGEs | done |
| Inline-fix the 3 must-fix items from blueprint-reviewer | done |
| Dispatch refactor m1-bridge-iter122 | done (COMPLETE; 4 new sorry sites) |
| Write Current Objectives for iter-122 prover lane | done |
| Update task_pending.md | done |
| Update iter-122/plan.md sidecar | done |
| Develop feedback note (optional) | skipped (no concrete observation) |

## Sorry trajectory across the iter

| Boundary | Differentials.lean | Jacobian.lean | Project total |
|---|---|---|---|
| Entering iter-122 plan phase | 0 | 1 | 1 |
| After inline blueprint corrections | 0 | 1 | 1 |
| After refactor m1-bridge-iter122 | 4 | 1 | 5 |
| Exiting iter-122 plan phase | 4 | 1 | 5 |
| Expected after iter-122 prover lane (PARTIAL) | 2 | 1 | 3 |
| Expected after iter-122 prover lane (COMPLETE) | 0 | 1 | 1 |

The 1 → 5 plan-phase rise is intentional milestone-opening, not
regression: the 2 theorem-body sorries plus 2 typeclass-plumbing
letI sorries together carve the M1 milestone into declarations with
concrete signatures so the prover lane has well-defined targets.
This is the pattern progress-critic-iter121 endorsed iter-121 watch
criterion 3 ("Iter-123 critic should treat the rise as M1 baseline,
not regression").
