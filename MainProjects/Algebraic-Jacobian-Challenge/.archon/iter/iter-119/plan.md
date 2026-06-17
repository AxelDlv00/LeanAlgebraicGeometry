# Iter-119 (Archon canonical) plan-agent run

## Headline outcome

The iter-118 hard-gate was cleared (Differentials.tex was refactored
+ blueprint-rewritten that iter; both lean-vs-blueprint-checker
audits returned `0 must-fix / 0 major / 0 minor`). Iter-119 dispatches
the scheduled Phase C prover lane on `Differentials.lean:87`
`smooth_locally_free_omega` against the verified 6-lemma Mathlib
chain, concurrently with a blueprint-writer cleanup of
`Cohomology_MayerVietoris.tex` (stale BasicOpenCech.lean prose
must-fix from blueprint-reviewer-iter119, orthogonal to the prover
lane).

**Expected sorry trajectory**: project 2 → 1 if the prover lane
returns COMPLETE. Remaining `sorry` would be the single foundational
hypothesis `nonempty_jacobianWitness` at `Jacobian.lean:179`, putting
the project in its declared end-state.

## What I consumed

- `task_results/` entering iter-119: 3 iter-118-review files
  (`lean-auditor-review118.md`,
  `lean-vs-blueprint-checker-differentials-review118.md`,
  `lean-vs-blueprint-checker-jacobian-review118.md`). Archived to
  `logs/iter-118/` after reading; cleared from `task_results/`.
- `USER_HINTS.md`: empty (only header). No new user instruction.
- `STRATEGY.md`: read; **unchanged this iter** (the iter-118 edits
  already absorbed the strategy-critic-iter118 advisories; this iter's
  strategy-critic returned SOUND with only minor slate notes that
  belong in the prover directive, not in the strategy file).
- `PROGRESS.md`: rewritten this iter for the iter-119 prover lane.
- `task_pending.md` / `task_done.md`: read for sorry inventory +
  protected status. `task_pending.md` updated for iter-119 entry.
  `task_done.md` unchanged (no new closures yet — those are review
  phase's domain).
- `archon-protected.yaml`: unchanged. 9 protected declarations.
- `iter/iter-117/{plan,review}.md`, `iter/iter-118/{plan,review}.md`:
  read for context (injected by the recent-iter window).
- `proof-journal/sessions/session_118/recommendations.md`: read for
  iter-119 action items (CRITICAL #1 = dispatch the prover lane;
  CRITICAL #2 = delete the dead `IsAffineHModuleHomFinite` chain
  in `StructureSheafModuleK.lean`; HIGH #3 / #4 = scaffolding-class
  decisions on `MayerVietorisCover.lean` + redundant typeclass args
  on `Rigidity.lean`).

The CRITICAL #2 + HIGH #3/#4 items are NOT taken up this iter
(triage rationale below in "Why I did not act on session_118
recommendations 2-4 this iter").

## Critic verdicts this iter

### strategy-critic-iter119 — SOUND

4 routes audited (Phase C close, iff→forward demotion, single-sorry
end-state, infrastructure-ships-unconditionally). All four PASS on
goal-alignment + mathematical soundness; no sunk-cost reasoning; no
phantom prerequisites; effort estimates honest.

Two minor slate-completeness advisories rendered:

- **M1 (slate completeness)**: the slate doesn't include the
  reconciliation step between the project's `f.c`-via-adjunction map
  (used inside `relativeDifferentialsPresheaf`) and `(f.appLE U V e).hom`
  (produced by `smoothOfRelativeDimension_iff`). They are the same map
  by definition; the prover will need a small `simp [Scheme.Hom.appLE,
  ...]` or `show ... by rfl` reconciliation. **Folded into PROGRESS.md
  prover directive as informational hint.**

- **M2 (`Nontrivial` synthesis)**: the slate omits the prerequisite
  `[Nontrivial Γ(X, U)]` that `rank_kaehlerDifferential` requires.
  From `x ∈ U`, the Mathlib lemma to use is
  `AlgebraicGeometry.Scheme.component_nontrivial`
  (instance: `[Nonempty ↥U] → Nontrivial (X.presheaf.obj (.op U))`).
  I verified this lemma's existence this iter via `lean_leansearch`.
  **Folded into PROGRESS.md prover directive as informational hint.**

The iter-118 axiomization CHALLENGE on `nonempty_jacobianWitness` was
explicitly not re-raised by the iter-119 strategy-critic ("the
rebuttal stands"). Treat as resolved for as long as the plan-agent
hard rule on axioms stands.

### blueprint-reviewer-iter119 — `Differentials.tex` READY; one must-fix on `Cohomology_MayerVietoris.tex` (orthogonal to the prover lane)

Per-chapter checklist (9 active chapters per `content.tex`):

- `Cohomology_SheafCompose` / `Cohomology_StructureSheafAb` /
  `Cohomology_StructureSheafModuleK` / `Differentials` / `Genus` /
  `Jacobian` / `Rigidity` / `AbelJacobi`: `complete: true,
  correct: true` (8 of 9). No must-fix.
- `Cohomology_MayerVietoris`: `complete: partial` (must-fix per
  gate-rule wording). The first half (L1–L915) is correct and
  describes the live `MayerVietorisCore.lean`/`MayerVietorisCover.lean`;
  the second half (L941–L1180) describes `BasicOpenCech.lean` content
  that was **deleted in its entirety at iter-117 trim**. The "iter-108
  escape-valve" remark at L1167 enumerates SEVEN named deferrals, six
  of which point at deleted files (`instIsMonoidal_W`,
  `cotangentExactSeq_structure.h_exact`, `serre_duality_genus`,
  `PicardFunctor.representable`, `SheafOfModules.pullback_*` pair);
  only `nonempty_jacobianWitness` survives in the live project.

**Decisive note from the reviewer**: "this finding does NOT touch
`Differentials.lean:87`, and so does not gate the iter-119 prover
lane on `smooth_locally_free_omega`."

So the prover lane proceeds; the must-fix is addressed
concurrently by a blueprint-writer dispatch on the MV chapter
(directive: prune the orphan basic-open sections + add a small
"Use in the project" closer).

**One soft finding ("soon")**: `Differentials.tex` Step 5 of
`thm:smooth_locally_free_omega` could use a one-line acknowledgement
of the Lean-side coercion between `X.ringCatSheaf.presheaf.obj (.op U)`
and the algebra `B` from `mk_iff`. **Folded into PROGRESS.md prover
directive** (Step 6 mentions cast/`Module.Free.of_equiv` transport),
not into the chapter, because the chapter is `complete: true,
correct: true` per the reviewer and the M1 slate advisory already
captures the same point.

### progress-critic-iter119 — UNCLEAR, proceed with dispatch

Audit window: iter-115 → iter-119. Verdict rules verbatim:

- CONVERGING (sorry count strictly decreasing in K-window): FAILS
  (5,5,1,1,1 is not strictly decreasing).
- CHURNING (helpers in ≥2 iters AND residual unchanged): FAILS (helpers
  only at iter-117; co-occurring with 4-sorry mass deletion, not
  "without payoff"). PARTIAL-streak: FAILS (zero PARTIAL in window).
- STUCK (count unchanged across K iters): FAILS (5→1 step at iter-117).
  Recurring-blocker-across-K: FAILS (all iter-115 blocker phrases —
  "affine-basis-bridge", "blueprint's 3-step recipe is internally
  entangled" — attach to declarations that were DELETED iter-117).
  Helpers-without-payoff: FAILS.
- UNCLEAR ("route is fresh < K iters of data, OR signals ambiguous"):
  MATCHES — the current `smooth_locally_free_omega` (forward) shape is
  effectively iter-1; the pre-iter-117 history is on a deleted-and-
  replaced declaration.

The critic explicitly says: "The planner should proceed with the prover
dispatch as planned and should NOT preemptively escalate (no blueprint
expansion, no mathlib-analogist, no refactor) before the prover attempt
returns — there is no signal-level basis for such escalation right now."

Iter-120 watch criteria (committed):

1. COMPLETE → CONVERGING (retroactive); advance to polish stage.
2. PARTIAL/INCOMPLETE + NEW blocker phrase → CHURNING; corrective =
   `mathlib-analogist` on the 6-lemma slate.
3. PARTIAL w/o new blocker (ergonomics-only) → UNCLEAR-trending-
   CONVERGING; polish lane permitted.
4. **(Added by iter-119 critic)** INCOMPLETE with iter-115
   affine-basis-bridge blocker re-emerging → STUCK; primary corrective
   = route pivot (STRATEGY.md revision) + strategy-critic re-dispatch
   mid-iter. This rule exists because the iter-117 trim was supposed
   to retire that blocker; its recurrence would mean the retirement
   was illusory.

## Mathlib-name verification this iter

All six Phase C closing lemmas re-verified this iter via
`lean_run_code` (past iters' verification does NOT carry forward per
plan-agent rule):

1. `AlgebraicGeometry.smoothOfRelativeDimension_iff` [verified]
   (mk_iff generated; bound types in conclusion match prover need).
2. `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra` [verified]
   (`@[algebraize ...]`-annotated; the `algebraize` tactic will pick
   it up automatically).
3. `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`
   [verified].
4. `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified]
   (instance).
5. `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
   [verified] (n is explicit; needs `[Nontrivial S]`).
6. `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler`
   [verified] (project-local; body `rfl`).

Plus the `Nontrivial` synthesis bridge:
7. `AlgebraicGeometry.Scheme.component_nontrivial` [verified]
   (instance: `[Nonempty ↥U] → Nontrivial (X.presheaf.obj (.op U))`).

Strategy-critic independently re-located all six via ripgrep against
`.lake/packages/mathlib`. Convergent verification.

## Why I did not act on session_118 recommendations 2-4 this iter

`proof-journal/sessions/session_118/recommendations.md` lists three
secondary action items beyond the iter-119 prover lane:

- **CRITICAL #2** — delete the iter-043-admitted dead
  `IsAffineHModuleHomFinite` chain in `StructureSheafModuleK.lean`
  (one class + three consumers; ~70 LOC).
- **HIGH #3** — decide on the two scaffolding classes
  `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` in
  `MayerVietorisCover.lean` (downgrade to explicit-arg theorems, or
  delete).
- **HIGH #4** — trim redundant typeclass arguments on
  `Rigidity.lean:62-67 GrpObj.eq_of_eqOnOpen`.

Three reasons to defer all three to iter-120:

1. **Progress-critic explicitly said "no preemptive escalation"**.
   Adding three concurrent refactor dispatches before the prover lane
   returns is exactly what the critic warns against. The prover-lane
   outcome is the resolving signal for the iter-118 UNCLEAR verdict;
   secondary refactors should land *after* that signal, not in parallel
   noise.

2. **The MV blueprint-writer dispatch IS load-bearing** (it addresses
   the blueprint-reviewer's explicit must-fix). The CRITICAL #2 +
   HIGH #3/#4 items are NOT load-bearing for the iter-119 prover lane:
   `Differentials.lean` doesn't depend on `StructureSheafModuleK`'s
   `IsAffineHModuleHomFinite` chain, nor on the
   `MayerVietorisCover.lean` scaffolding classes, nor on
   `Rigidity.lean`'s eq_of_eqOnOpen.

3. **Doing them all this iter dilutes the iter-119 signal.** If the
   prover lane returns COMPLETE, the project is in end-state at
   iter-120 entry and the secondary cleanups are appropriate as
   polish-stage tasks. If the prover lane returns PARTIAL/INCOMPLETE,
   the next-iter response depends on the failure mode (see the four
   watch rules above) and concurrent cleanups would have wasted
   subagent cycles on the wrong axis.

These three items are explicitly carried forward to iter-120 in the
review-phase recommendations of this iter (session_119/recommendations.md
will inherit them).

## What I dispatch this iter

1. **strategy-critic** (mandatory) — SOUND verdict (slate advisories
   M1, M2 folded into prover directive).
2. **blueprint-reviewer** (mandatory) — `Differentials.tex` ready;
   must-fix on `Cohomology_MayerVietoris.tex` addressed concurrently
   via writer dispatch.
3. **progress-critic** (mandatory) — UNCLEAR; proceed with prover
   dispatch; no preemptive escalation.
4. **blueprint-writer for `Cohomology_MayerVietoris.tex`**
   (slug `mayervietoris-iter119`) — prune the orphan basic-open
   sections (L941+, ~265 LOC of stale prose pointing at deleted
   Lean code) and add a small live "Use in the project" closer.
   Dispatched concurrent with the prover lane.

## Prover lane scheduled this iter

- **`AlgebraicJacobian/Differentials.lean`** L87
  `smooth_locally_free_omega` (forward implication, iter-118
  signature) — close via the 6-lemma chain + M1 reconciliation +
  M2 `Nontrivial` synthesis described in `PROGRESS.md`.

Estimated cost: 100–300 LOC; expected outcome COMPLETE in 1 prover iter.

## What lands this iter (verified)

- `PROGRESS.md` rewritten for iter-119 with the prover directive
  (signature + 6-lemma slate + M1/M2 advisories + watch criteria).
- `task_pending.md` updated to iter-119 entry status.
- `STRATEGY.md` unchanged (no strategy-modifying findings; the
  iter-118 edits are still current).
- `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — writer
  dispatched concurrent with prover lane (output will land before
  end of plan phase).
- 3 critic reports archived to `.archon/logs/iter-119/`.

## Project state after iter-119 plan phase

- Sorry count: 2 (Differentials.lean L93; Jacobian.lean L179) —
  unchanged.
- Project compiles clean (per-file `lean_diagnostic_messages` returns
  `[]` errors).
- No new axioms.
- `archon-protected.yaml` unchanged.
- USER_HINTS.md: empty.

## Fallback if no user response

Not applicable — no user-escalation this iter. The strategy is sound,
the blueprint is gating-ready for the prover lane, the progress-critic
explicitly authorises the dispatch. No request to the user is pending.

## Notes for iter-120 plan agent

If iter-119 prover round returns COMPLETE:

1. Migrate `smooth_locally_free_omega` closure to `task_done.md`.
2. Advance stage in `PROGRESS.md`: `prover` → `polish`.
3. **Polish-stage backlog inherited from session_118/session_119
   recommendations** (run as polish-stage tasks in order of severity):
   - Delete the dead `IsAffineHModuleHomFinite` chain in
     `StructureSheafModuleK.lean` (must-fix from lean-auditor-review118;
     ~70 LOC).
   - Decide on `HasCechToHModuleIso` / `HasAffineCechAcyclicCover`
     scaffolding-class fate in `MayerVietorisCover.lean` (downgrade
     to explicit-arg theorems per lean-auditor's preferred option (a),
     OR delete if no live callers — must verify by grep).
   - Trim redundant typeclass arguments on
     `Rigidity.lean:62-67 GrpObj.eq_of_eqOnOpen`.
   - Minor: stale status-line headers (`AbelJacobi.lean:14`,
     `Genus.lean:14`); commented-out historical sketch in `Genus.lean:39-61`;
     rank-vs-finrank stylistic note on `Differentials.lean:92`.
4. The two clusters of Mathlib gap-fills (CategoryTheory in
   StructureSheafModuleK, ModuleCat_free in MayerVietorisCore)
   stay parked as a future upstream-PR effort.

If iter-119 prover returns PARTIAL or INCOMPLETE, follow the four
watch rules in this sidecar's "progress-critic-iter119" section to
choose the iter-120 corrective.
