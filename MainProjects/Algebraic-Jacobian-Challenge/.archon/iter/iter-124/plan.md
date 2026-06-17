# Iter-124 (Archon canonical) plan-agent run

## Headline outcome

Iter-123 returned PARTIAL on `appLE_isLocalization` (M1.b) with
Step 1 (forward map via `IsLocalization.lift`) + Step 4 (reduction
via `IsLocalization.isLocalization_of_algEquiv`) closed concretely
in body; Steps 2 + 3 packaged as a single residual `sorry` at
`Differentials.lean:362` on the `Localization M ≃ₐ[Γ(S, U)] A_colim`
AlgEquiv hole. Project sorry trajectory entering iter-124: **2**
(`Differentials.lean:362` M1.b + `Jacobian.lean:179`
`nonempty_jacobianWitness`).

Iter-124 plan-phase landed:

1. **Three mandatory critics + 1 refactor + 1 mathlib-analogist
   dispatched (5 total)**:
   - `strategy-critic-iter124` → CHALLENGE on all 4 routes
     (M1 sunk-cost re-emergence; M2 phantom prereqs; M3 escalation
     timing + options; sequencing wait-window). Addressed via the
     sharpened iter-125 pivot trigger + phantom-prereq spot-check
     inline results + named-axiom alternative staging + sequencing
     wait-window in STRATEGY.md.
   - `blueprint-reviewer-iter124` → HARD GATE CLEARED on
     `Differentials.tex`; 5 soon items (2 fixed inline this iter:
     L138 prose, `\uses{}` direction; 3 deferred: dedicated `\lean`
     blocks for inline helpers, Jacobian.tex C.2.d char-`p`
     hazard, C.2.f Galois descent name); 3 informational
     (4 orphan chapters for cleanup).
   - `progress-critic-iter124` → CONVERGING with watch flags.
     M1.b sub-step residual 4 → 1 across iter-122/iter-123; no
     helper-churn pattern; pre-committed escalation triggers if
     iter-124 hits cofinality blocker or requests "more helpers".
   - `refactor-deadcode-cleanup-iter124` → COMPLETE. 4 dead
     declarations + 1 sketch deleted from
     `Cohomology/StructureSheafModuleK.lean` + `Genus.lean`;
     project sorry count unchanged at 2.
   - `mathlib-analogist-rigidity-refactor-scoping-iter124` →
     ALIGN_WITH_MATHLIB. iter-125 Rigidity refactor staged (drop
     8 unused hyps; weaken `IsProper Y` to `IsSeparated Y`; rename
     `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen`);
     1 iter / ~25 LOC execution cost.

2. **M2.c + M2.d-alt + (additional) `geomIrred.exists_kalg_pt`
   phantom-prereq spot-checks** (per iter-123 STRATEGY.md
   commitment + strategy-critic-iter124's expanded list):
   - **M2.c "Galois descent of morphism equality of schemes"**:
     not a complete phantom. Mathlib snapshot `b80f227` has
     `AlgebraicGeometry.IsLocalAtTarget.descendsAlong` /
     `IsZariskiLocalAtTarget.descendsAlong`
     (`Mathlib.AlgebraicGeometry.Morphisms.Descent`),
     `RingHom.FaithfullyFlat.codescendsAlong_surjective`
     (`Mathlib.RingTheory.Flat.FaithfullyFlat.Descent`), and
     `AlgebraicGeometry.Spec.map_inj` + `Spec.map_injective`
     for the affine case. The specific "two morphism equality
     from base-change equality" lemma needs to be assembled
     (~300–500 LOC). The Mathlib descent framework is broad
     enough that assembly is mechanical, NOT a multi-K LOC
     contribution.
   - **M2.d-alt "abelian-variety cotangent triviality"**:
     **PHANTOM**, confirming iter-123 strategy-critic flag and
     iter-124 strategy-critic's repeat. No
     `AbelianVariety.cotangent_trivial`,
     `GroupScheme.Omega_trivial`, "smooth group object →
     cotangent locally free of rank dim" lemma. Mathlib has
     `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
     for the algebra-layer local case, but globally trivial
     (the abelian-variety statement) is a genuine gap.
   - **`geomIrred.exists_kalg_pt`** ("base-change-to-`k̄`
     rational-point existence" for the M2 strategy): **PHANTOM**.
     Mathlib has the `Algebra.IsGeometricallyReduced`
     machinery (`Mathlib.RingTheory.Nilpotent.GeometricallyReduced`)
     but no witness lemma for geometrically irreducible
     non-empty schemes acquiring a `k̄`-rational point.

3. **Refactor `deadcode-cleanup-iter124`** dispatched (background)
   to address `lean-auditor-review123` Must-fix items #1 + #3:
   - Item #1: Delete dead `IsAffineHModuleHomFinite` class + 3
     consumers in `Cohomology/StructureSheafModuleK.lean:458–519`.
   - Item #3: Delete stale `OXAsAddCommGrpSheaf` sketch + retitle
     stale status block in `Genus.lean:15–61`.
   - Both items orthogonal to the M1.b prover lane; no protected
     signatures touched.

4. **Inline blueprint doc-drift edits** to `Differentials.tex`
   per iter-123 lean-vs-blueprint-checker minor findings + session_123
   review recommendations HIGH #5 + HIGH #6:
   - **L165 + L175 hedge tightened**: stale "two-direction
     `IsLocalization.of_le` pattern" replaced with "two-direction
     equivalence-based pattern"; `IsLocalization.of_le` and
     `IsLocalization.of_ringEquiv` alternatives dropped from the
     closure-lemma list; `IsLocalization.isLocalization_of_algEquiv`
     named as the canonical Step 4 closer (matching the
     iter-123 prover's actual closure).
   - **Three missing `\lean{...}` references added**:
     `appLE_unitSubmonoid` in the M1.a definition of $M$;
     `isUnit_appLE_unitSubmonoid_in_colim` in Step 0 of the
     `lem:appLE_isLocalization` proof; `appLE_colimRingHom_comp_φV`
     in the M1.e proof of `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`.
   - **Wrong-direction `\uses{lem:appLE_isLocalization}` removed**
     from `lem:kaehler_localization_subsingleton` (the subsingleton
     lemma is more general and is used BY the bridge proof, not
     vice versa — iter-123 blueprint-reviewer "soon" item).

## Critic verdicts

### strategy-critic-iter124 → CHALLENGE (4 routes, 4 verdicts)

| Route | Verdict | Action |
|---|---|---|
| M1 | CHALLENGE | Sunk-cost re-emerged: iter-123 pre-commitment was "Step 1+3+4 closure"; actual is Step 1+4 with Step 3 packaged into AlgEquiv hole. Either pivot to M2.a now, OR rewrite the commitment honestly. |
| M2 | CHALLENGE | Three phantom prereqs (M2.c, M2.d-alt, `geomIrred.exists_kalg_pt`) remain unverified. Also `Rigidity.lean` refactor that gates M2.a is un-scoped. |
| M3 | CHALLENGE | User escalation should have fired iter-123, not iter-124. Escalation should present TWO options (PR-and-wait + named-axiom), not one. |
| Sequencing | CHALLENGE | Strategy lacks "multi-month wait window" plan if M3 escalates to upstream PRs. |

Three alternatives raised:
1. **Pivot to M2.a + Rigidity refactor NOW** (critical) — skip M1.b
   prover lane this iter; dispatch Rigidity refactor-scoping;
   iter-125 runs Rigidity refactor; iter-126 runs M2.a prover lane.
   Run M3 escalation in parallel this iter.
2. **Offer the user a named-axiom option in escalation** (major)
   — the iter-122 critic's named-axiom alternative should be put to
   the user (not unilaterally ruled out via the plan-agent standing
   rule).
3. **Treat M1 as off-loop work** (major) — M1 is a clean Mathlib-
   contribution candidate; off-loop work (separate branch /
   hand-formalization) is consistent with the user pivot directive
   without consuming loop budget.

### strategy-critic-iter124 response (planner action)

**On the M1 pivot question**: I am pursuing a hybrid path between
"pivot now" and "continue M1.b":

- **Continue M1.b this iter** with the focused Step 2 + Step 3
  prover lane (per the iter-123 PROGRESS.md watch criterion 2 + the
  iter-123 prover's 6-substep closure recipe in
  `task_results/AlgebraicJacobian_Differentials.lean.md`).
  Rationale: the iter-123 structural advance was real (Step 0 +
  Step 1 + Step 4 in body; the residual is exactly one named hole
  with a documented closure plan); the prover-task-result quality
  is exemplary; and the LOC estimate (140–230 LOC) is feasible for
  one prover iter.
- **HOWEVER, the iter-123 pre-commitment is rewritten honestly**
  per the critic's must-fix #1: the actual outcome was "Step 1+4
  closure with Step 3 packaged" (a single named hole), NOT "Step
  1+3+4 closure with multiple sorries closed." The iter-125 pivot
  trigger is sharpened: **if iter-124 returns anything short of
  COMPLETE or PARTIAL-with-no-residual-AlgEquiv, iter-125 fires
  the M2.a + Rigidity refactor pivot unconditionally** (no further
  "we are close" justifications; the strict-rule reading applies).
- **In parallel this iter**: scope the `Rigidity.lean` refactor
  via a `mathlib-analogist` consult on `GrpObj.eq_of_eqOnOpen`
  (the source-side `[GrpObj X]` hypothesis blocking M2.a per the
  iter-121 blueprint-writer findings). This is the iter-124
  plan-phase deliverable that the strategy-critic's must-fix #2
  explicitly demands ("scope the Rigidity.lean refactor that gates
  M2.a"). The refactor itself runs iter-125; M2.a prover lane is
  iter-126+.

**On the named-axiom option (must-fix #3, alternative #2)**: The
plan-agent standing instruction is "You should NEVER propose
adding new axioms." This applies to the agent proposing — the
escalation banner the iter-124 review agent will surface in
TO_USER.md can flag that the strategy-critic-iter124 has raised
the named-axiom path as an alternative the USER may choose to
authorize, without the plan agent endorsing or proposing it.
The user retains authority over the project direction (iter-121
pivot was a user directive); the loop's role is to surface options
the critic raised, not to gate them away. **This iter's TO_USER.md
update is the review agent's responsibility**; this sidecar
documents the input.

**On the phantom prereqs (must-fix #2)**: the planner ran the
spot-checks this iter (results inlined above). STRATEGY.md is
updated to (a) confirm M2.c is partially-supported by Mathlib's
descent framework (estimate revised: 4–8 iter / 300–500 LOC, up
from 3–6 iter / 150–300 LOC), (b) confirm M2.d-alt and
`geomIrred.exists_kalg_pt` are genuine phantoms (M2.d-alt
estimate remains 10–20 iter / 800–1500 LOC as already revised
iter-123; geomIrred witness flagged as new sub-task ~3–5 iter
/ 200–400 LOC).

**On the M3 escalation timing (must-fix #3)**: TO_USER.md was
authored iter-123 by the review agent and remains active. The
iter-124 review agent should re-author it to include the named-axiom
option per the critic's alternative #2; the plan agent stages this
input here. No further M3 work this iter beyond the review-side
TO_USER.md update.

**On sequencing (must-fix #4)**: STRATEGY.md gets a "multi-month
wait window" section naming the iter-124 → iter-125 → iter-126
→ iter-127+ activity queue: (124) M1.b prover lane + Rigidity
refactor scoping; (125) M2.a Rigidity refactor; (126) M2.a
prover lane (rigidity over `k̄`); (127+) M2.b genus-0 witness
assembly, with M2.c + M2.d phantom-prereq builds running in
parallel as the relevant prover lanes need them.

**On the "M1 as off-loop work" alternative #3 (major)**: rejected
this iter — M1.b is one residual sorry from COMPLETE; the cost
to finish it inside the loop (one more focused prover iter) is
lower than the cost of marking it off-loop and re-onboarding a
fresh hand-formalization later. The alternative is acknowledged
and may be reconsidered if iter-124 returns PARTIAL again.

### blueprint-reviewer-iter124 → HARD GATE CLEARED

13 chapters audited; 0 must-fix-this-iter; 5 soon; 3 informational.

- **`Differentials.tex` HARD GATE CLEARED** for iter-124 prover
  lane (`complete: true, correct: partial` only via minor stale
  L138 prose which the Lean prover does not read).
- **L138 vs L165 prose inconsistency** flagged (L138 still says
  "via `IsLocalization.of_le`"; L165 correctly uses
  `isLocalization_of_algEquiv`). **Plan agent fixed L138 inline
  this iter** (post-reviewer); no further blueprint-writer
  dispatch needed.
- **Wrong-direction `\uses{lem:appLE_isLocalization}` on
  `lem:kaehler_localization_subsingleton`**: VERIFIED RESOLVED
  (planner's inline fix earlier this iter confirmed).
- **4 orphan chapters** (`Modules_Monoidal.tex`, `Picard_Functor.tex`,
  `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`) describe Lean
  files no longer in the source tree (`AlgebraicJacobian/Modules/...`
  and `AlgebraicJacobian/Picard/...` paths don't exist). Not
  included in `content.tex` so they don't enter the blueprint pdf
  and don't block any prover. **Severity: informational**
  (cleanup candidate for a future iter; not iter-124 blocking).
- **5 "soon" findings**:
  1. `Differentials.tex` L138 prose (FIXED inline this iter).
  2. Same paragraph "analogist-verified pattern" sentence (FIXED
     inline as part of #1 above).
  3. Promote `appLE_unitSubmonoid` / `isUnit_appLE_unitSubmonoid_in_colim`
     / `appLE_colimRingHom_comp_φV` to dedicated `\begin{lemma}`
     blocks (this iter added inline `\lean{...}` references, not
     dedicated blocks — defer block promotion to a future
     blueprint-writer pass).
  4. `Jacobian.tex` C.2.d char-`p` hazard not yet in prose
     (STRATEGY.md M2.d-alt has it; chapter does not). Soon —
     M2.d-alt is iter-130+, defer.
  5. `Jacobian.tex` C.2.f Galois descent name unnamed —
     planner's iter-124 spot-check found Mathlib has partial
     coverage via `IsLocalAtTarget.descendsAlong`. Could be
     inlined as a follow-up; soon, not iter-124 blocking.

iter-124 prover lane on `Differentials.lean` **CLEARED for
dispatch.**

### progress-critic-iter124 → CONVERGING (with watch flags)

One route audited (M1.b body — `appLE_isLocalization`); zero
CHURNING or STUCK verdicts.

**Why not CHURNING despite the strict ≥3-PARTIAL rule firing**
(the critic's own analysis):
- iter-119's PARTIAL was on a different sub-route (pre-M1
  Differentials refactor) closed by iter-120's COMPLETE.
- M1.b body dedicated work is just iter-122 + iter-123 (2
  legitimate "decomposition execution" PARTIALs).
- Scaffolding came in a single iter-122 burst (7 named declarations
  including Step 0); iter-123 added 0 new helpers but closed
  Step 1 + Step 4 in-body. Inverts the helper-churn pattern.
- Sub-step residual within M1.b body has shrunk 4 → 1.
- No blocker phrase has hit twice. The "cofinality" phrase appears
  as a forward-looking concern in 2 reports but has NOT yet hit as
  a concrete blocker.

**Watch flags** (proceed but pre-commit to escalation triggers):
1. Project sorry count has been flat at 2 across iter-122/iter-123.
   **iter-124 must actually close the AlgEquiv residual to keep
   the route honest**. A 3rd consecutive PARTIAL pushes this to
   CHURNING regardless of structural narrative.
2. **If iter-124 hits the "cofinality on cocone universal property"
   as a concrete blocker** (i.e., as a Step-2 stall), iter-125
   plan MUST dispatch a mathlib-analogist consult on the cofinality
   step BEFORE another prover round.
3. **If iter-124 returns PARTIAL with a "need more helpers"
   request**, that IS the CHURNING signal — the planner must
   reject the helper round and escalate.

Credit to the iter-124 plan agent for the targeted lane (Step
2a/b/c/d + Step 3 + Step 4 assembly, 140–230 LOC, NO new helpers
proposed). This is the key differentiator from churn.

**Planner action**: iter-124 prover lane proceeds with the
targeted Step 2 + Step 3 lane per the iter-123 prover task result's
6-substep decomposition. The iter-125 pivot triggers committed in
this sidecar are unchanged (sharpened to "any PARTIAL → M2.a
pivot") and now augmented with the progress-critic's two
additional escalation triggers (cofinality consult, helper-round
rejection).

### refactor-deadcode-cleanup-iter124 → COMPLETE

- Item #1: deleted 4 declarations
  (`IsAffineHModuleHomFinite` class + 3 consumers) at
  `Cohomology/StructureSheafModuleK.lean:448–519`; updated
  iter-043 / iter-046 docstrings to drop cross-refs to deleted
  variants and appended a "removed dead scaffolding" historical
  note. File-header status block refreshed to name the surviving
  finite-length carriers.
- Item #3: deleted `Genus.lean:39–61` Phase A sketch + retitled
  the L15–29 status block to past-tense.
- Project sorry count: **unchanged at 2** (verified
  via `sorry_analyzer.py AlgebraicJacobian/`).
- Two stray docstring cross-references in
  `StructureSheafModuleK.lean:L494, L847` still reference the
  removed declaration; left untouched per directive scope, flagged
  for a future cleanup pass.

## What I consumed

- `task_results/AlgebraicJacobian_Differentials.lean.md` (iter-123
  prover report). Archived to `logs/iter-123/`. Cleared from
  `task_results/`.
- `task_results/lean-auditor-review123.md`,
  `task_results/lean-vs-blueprint-checker-differentials-review123.md`
  (iter-123 review-phase reports). Archived to `logs/iter-123/`.
  Cleared from `task_results/`.
- `USER_HINTS.md`: empty. The iter-123 plan.md fallback ("continue
  on-critical-path work; M3 itself paused pending user response")
  remains the iter-124 user-silent action.
- `STRATEGY.md`: read; revised this iter to absorb the
  strategy-critic-iter124 findings (M1 pre-commitment rewritten
  honestly; M2 phantom-prereq spot-checks inlined; M3 escalation
  options noted for review-side surfacing; sequencing wait-window
  added).
- `PROGRESS.md`: rewritten this iter for the iter-124 M1.b focused
  Step 2+3 prover lane.
- `task_pending.md` / `task_done.md`: read for sorry inventory.
- `archon-protected.yaml`: unchanged. 9 protected declarations.
- `iter/iter-121/{plan,review}.md`, `iter/iter-122/{plan,review}.md`,
  `iter/iter-123/{plan,review}.md`: read for context (injected by
  the recent-iter window).
- `proof-journal/sessions/session_123/recommendations.md`: read for
  iter-124 action items. Adopted: CRITICAL #0 items #1 + #3 (refactor
  dispatched this iter); CRITICAL #1 (M1.b prover lane); HIGH #5 +
  #6 (blueprint doc-drift — done inline this iter). Deferred:
  HIGH #4 (Step-2 helper-extraction refactor — discretionary,
  conditional on iter-124 prover stall); CRITICAL #2 (M3
  escalation — review-agent domain).

## Iter-124 prover lane

Single prover dispatch: `AlgebraicJacobian/Differentials.lean`
targeting the residual AlgEquiv sorry at L362 inside the
`suffices AE : Localization M ≃ₐ[Γ(S, U)] A_colim` block of
`appLE_isLocalization`.

Decomposition (per iter-123 prover task result § "Detailed plan
for iter-124"): 6 sub-steps totalling 140–230 LOC.

- Step 2a (~30–60 LOC): basic-open-cover helper.
- Step 2b (~30–50 LOC): cocone arm constructor.
- Step 2c (~30–50 LOC): cocone naturality.
- Step 2d (~10–20 LOC): assemble cocone via
  `Functor.descOfIsLeftKanExtension` / `IsColimit.desc`.
- Step 3 (~30–50 LOC): inverse identities (`IsLocalization.ringHom_ext`
  + `IsLeftKanExtension.hom_ext_of_isLeftKanExtension` / `IsColimit.hom_ext`).
- Step 4 assembly (~10 LOC): already in place via the `suffices`
  reduction.

## Watch criteria committed for iter-125

1. **iter-124 prover lane returns COMPLETE on `appLE_isLocalization`**
   → M1 milestone closes; iter-125 plan-phase dispatches the
   Rigidity refactor + M2.a Rigidity prover lane scoping in
   parallel, with M2.a prover lane queued for iter-126.
2. **iter-124 prover lane returns PARTIAL** (any flavor — Step 2
   stalled, Step 3 residual, AlgEquiv reduction working but
   incomplete) → **iter-125 fires the M2.a pivot unconditionally**
   per the strategy-critic-iter124 must-fix-#1 sharpened commitment.
   No further "we are close" continuation. M1.b parks indefinitely
   with its current state; iter-125 dispatches the Rigidity
   refactor; iter-126+ runs M2.a prover lane.
3. **iter-124 Rigidity refactor scoping (mathlib-analogist consult)
   returns by iter-125 plan phase** with concrete LOC estimate
   + refactor directive draft.
4. **iter-124 M3 review-agent TO_USER.md update** surfaces the
   strategy-critic-iter124 named-axiom alternative option.
5. **Iter-125 phantom-prereq dispatches**: if M2.a as a prover lane
   moves up to iter-126, schedule the M2.c Mathlib-descent-framework
   sub-task (4–8 iter / 300–500 LOC) and M2.d-alt
   abelian-variety-cotangent-triviality sub-task (10–20 iter /
   800–1500 LOC) into the iter-127+ horizon.

## Fallback if no user response

If the iter-124 TO_USER.md (re-authored by the review agent with
the named-axiom alternative + the existing PR-and-wait alternative)
receives no user response by iter-125:

- **Option**: continue executing on-critical-path work via M2.a
  Rigidity refactor + M2.a prover lane. The named-axiom option
  REMAINS open for the user at any later iter — the loop does not
  auto-add named axioms (plan-agent standing rule), but the loop
  does proceed on the critical-path direction the user originally
  pivoted to in iter-121.
- **What the iter-125 plan agent will do**: re-confirm the iter-124
  TO_USER.md banner is still active (review agent's domain to
  decide whether to re-author or carry forward); write
  PROGRESS.md targeting either the iter-124-COMPLETE→Rigidity-refactor
  follow-up OR the iter-124-PARTIAL→M2.a pivot per the sharpened
  watch criteria above.

The loop does not stall waiting for M3 input — M2.a + Rigidity
refactor is the productive parallel lane the strategy-critic-iter124
explicitly named for the wait-window.

## Subagent dispatches this iter (running total)

| # | Subagent | Slug | Outcome (so far) |
|---|---|---|---|
| 1 | strategy-critic | iter124 | CHALLENGE (4 routes, 4 verdicts) — 3 alternatives raised; all addressed in this sidecar + STRATEGY.md |
| 2 | blueprint-reviewer | iter124 | HARD GATE CLEARED on `Differentials.tex`; 0 must-fix, 5 soon (2 fixed inline this iter), 3 informational (4 orphan chapters flagged for cleanup) |
| 3 | progress-critic | iter124 | CONVERGING with watch flags — sub-step residual 4 → 1 across iter-122/iter-123; no helper-churn pattern; pre-committed escalation triggers in iter-125 (cofinality consult, helper-round rejection) |
| 4 | refactor | deadcode-cleanup-iter124 | COMPLETE — 4 dead declarations + 1 sketch deleted, status blocks refreshed; project sorry count unchanged at 2 |
| 5 | mathlib-analogist | rigidity-refactor-scoping-iter124 | ALIGN_WITH_MATHLIB — 8 hypotheses unused (drop all); refactored signature `Scheme.Over.ext_of_eqOnOpen` with `[GeometricallyIrreducible X.hom]`, `[IsSeparated Y.hom]` (weakened from `IsProper`), `[IsReduced X.left]`; zero project Lean consumers; 1 iter / ~25 LOC for the iter-125 refactor execution |

## Iter-125 Rigidity refactor directive (staged for iter-125
plan-phase execution)

Per the iter-124 `mathlib-analogist-rigidity-refactor-scoping-iter124`
report:

- **Refactored signature** (replaces `GrpObj.eq_of_eqOnOpen` at
  `AlgebraicJacobian/Rigidity.lean:79`):

  ```lean
  theorem AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen
      {k : Type u} [Field k]
      {X Y : Over (Spec (.of k))}
      [GeometricallyIrreducible X.hom] [IsSeparated Y.hom]
      [IsReduced X.left]
      (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
      (h : (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₁.left =
        (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₂.left) :
      g₁ = g₂
  ```

  Drops: `{n m : ℕ}`, `[SmoothOfRelativeDimension n X.hom]`,
  `[IsProper X.hom]`, `[GrpObj X]`, `[SmoothOfRelativeDimension m Y.hom]`,
  `[GeometricallyIrreducible Y.hom]`, `[GrpObj Y]`.
  Weakens `[IsProper Y.hom]` to `[IsSeparated Y.hom]` (the only
  load-bearing target-side hypothesis per the proof body's
  `ext_of_isDominant_of_isSeparated'` call).
  Keeps: `[GeometricallyIrreducible X.hom]` (for the
  `IrreducibleSpace X.left` instance), `[IsReduced X.left]` (for
  the dominant-immersion step), and the two morphisms + open +
  hypothesis triple.
  Renames: `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen`
  (matching Mathlib's `AlgebraicGeometry.Scheme.Hom.ext` /
  `ext_of_isDominant_of_isSeparated'` naming idiom).

- **Mathlib contribution candidate**: a thin `ext_of_eqOnNonemptyOpen`
  corollary in `Mathlib.AlgebraicGeometry.Morphisms.Separated`
  (~5 LOC); borderline value (the existing
  `ext_of_isDominant_of_isSeparated'` already covers most cases).
  Not iter-125 work.

- **Project consumer count**: 0 Lean consumers (the only callsite
  is the iter-126+ M2.a prover lane, which has not been
  scheduled yet). 2 mechanical blueprint cross-refs
  (`Rigidity.tex`, `Jacobian.tex` C.2.g) that will need
  `\lean{...}` hint updates.

- **Cost**: 1 iter / ~25 LOC; no new sorries; refactor execution
  is a single `Rigidity.lean` Edit + 2 blueprint Edits + a
  potential rename in `archon-protected.yaml` (but
  `GrpObj.eq_of_eqOnOpen` is NOT protected, so no YAML edit
  needed).

Persistent design rationale: `analogies/rigidity-refactor.md`.
