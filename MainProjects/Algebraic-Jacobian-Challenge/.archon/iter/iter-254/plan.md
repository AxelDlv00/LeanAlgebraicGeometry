# Iter-254 plan-agent run

## Headline outcome

The **"3rd straight no-close M=2 iter → both lanes diagnosed to NAMED STRUCTURAL WALLS, neither a
re-dispatch: TS-inv's wall is a SELF-IMPOSED `hf`-protection throttle (re-sign + close), TS-cmp's wall is
the 4-iter `restrictScalars(𝟙)`/two-instance whisker collision (execute the STUCK corrective — a
cross-domain analogist consult that returned a decisive δ/μ-naturality reformulation)"** iter. This is a
structural-intervention iter, NOT another helper round. progress-critic pc254 = Route 1 **STUCK** / Route 2
**CHURNING**, with both correctives executed before pc254 returned; pc254 validated the M=2 plan and both
correctives as correct.

## What I processed (iter-253 outcomes)
- **Lane TS-cmp** (`TensorObjSubstrate.lean`): STEP-A reversing signal fired NEGATIVE across 3 approaches
  (element-descent / whisker-calculus whnf-timeout / uniform-instance-helper synth-fail); STEP-B Square-1
  closed (partial). sorry 3→3. → task_done (structural) + task_pending.
- **Lane TS-inv** (`DualInverse.lean`): `homOfLocalCompat` sub-step (b) CLOSED (+`topSectionToHom`×2);
  sub-step (a) BLOCKED on `hf : HEq` (believed PROTECTED). sorry 2→2. → task_done + task_pending.
- **lean-auditor aud253** + **lean-vs-blueprint di253**: both flagged the `hf` HEq blocker as a
  signature-restructure need; di253 must-fix #2 = blueprint sub-step (a) under-specified for the actual
  `hf`. Folded into bw254 (blueprint) + the TS-inv prover directive (Lean re-sign).

## Decision made

**Chosen: a STRUCTURAL-INTERVENTION M=2 iter — fix each wall at its root, then dispatch both provers
armed.** Rather than: (i) another blind re-dispatch of the same shapes (the iter-253 review explicitly
warned against it; pc254 STUCK/CHURNING confirm), (ii) a route abandonment (both walls are addressable),
or (iii) opening the engine 3rd lane blind (un-blueprinted — would be the anti-pattern the strategy warns
against).

**Two root-cause fixes, both executed this iter:**
1. **TS-inv = SELF-IMPOSED THROTTLE.** I verified first-hand that `homOfLocalCompat` is **absent from
   `archon-protected.yaml`** (only `Genus.lean`/`Jacobian.lean`/`AbelJacobi.lean` decls are protected) and
   has **no compiling caller** (`exists_tensorObj_inverse`, its only consumer, is itself a sorry). The
   iter-253 prover throttled itself on a wrong "PROTECTED" belief (echoed from a stale in-file comment).
   So the fix is: re-sign `hf` to the honest sectionwise form (both prover + di253 agree this makes
   sub-step (a) direct) → close `homOfLocalCompat` (FRONTIER base). Blueprint sub-step (a) corrected by
   **bw254**. pc254 confirms the close is SOUND (no residual gap).
2. **TS-cmp = the STUCK corrective.** Dispatched the cross-domain mathlib-analogist **tscmp254** on the
   4-iter `restrictScalars(𝟙)`-over-sheafification whnf wall + two-defeq-monoidal-instance collision. It
   returned a decisive reformulation (NOT another api-alignment `letI` retry, which whisker252 already
   disproved): recast the whisker square onto the **single-sided monoidal-functor naturality lemmas**
   `Functor.OplaxMonoidal.δ_natural_left/right` (or `μ_natural_left/right`) of the sheafification functor
   — each is single-instance, so the cross-group whisker crossing never forms and `tensorHom_def` is never
   needed (this is literally how Mathlib's `Sheaf.monoidalCategory`/`LocalizedMonoidal` proves these
   squares). Plus: pin every comparison map on the canonical `…⋙ forget₂ CommRingCat RingCat` spelling
   (clears STEP-B's `Sheaf.val`/`.obj` merge too) + strip `restrictScalars(𝟙)` eagerly. I grep-VERIFIED
   the lemma names exist in the pinned Mathlib (`Monoidal/Functor.lean:246,250,70,74` all
   `@[reassoc (attr := simp)]`; `ChangeOfRings.lean:217`). `analogies/tscmp254.md`.

**Why (evidence):**
- **pc254 Route 1 = STUCK** (recurring blocker ≥3 iters; sorry 3→3→3), primary corrective = **Mathlib
  analogy consult** = tscmp254 (dispatched + returned). pc254 explicitly: "the correct corrective; the
  iter-254 plan has responded appropriately… the prover must be restricted to ONLY the analogist-prescribed
  normalization." Executed exactly.
- **pc254 Route 2 = CHURNING** (PARTIAL×3), primary corrective = **structural refactor of `hf`** =
  bw254 + the Lean re-sign. pc254 soundness assessment: "The close is sound — no residual mathematical gap
  identified."
- **pc254 dispatch-sanity = OK for M=2**; the engine 3rd lane is the only other candidate and is
  un-blueprinted, so deferral to iter-255 is acceptable — but pc254 flags the **avoidance clock** (the
  engine lane has been "deferred" 3 iters): I COMMIT to dispatching its blueprint-writer iter-255.
- **Reversing-signal routing (autonomous):** per the standing AUTONOMOUS directive, the TS-cmp reversing
  signal does NOT escalate to the user (pc254's "escalate to user" suggestion is overridden by the
  permanent directive); instead it routes the next decision to the PLANNER — a `refactor`-subagent
  restatement of the defs onto the canonical spelling, or reordering to finish the dual chain first.

**Cheapest reversal signal:** TS-cmp — the δ/μ recast does not close STEP A (then the defs genuinely need
a `refactor`-subagent restatement, or reorder DualInverse-first). TS-inv — re-signed `hf` doesn't reduce
sub-step (a) as diagnosed (then a deeper gluing-engine issue, re-scope).

## Subagent dispatches (plan-phase)

| Subagent | Slug | Purpose | Outcome |
|---|---|---|---|
| blueprint-writer | bw254 | Fix sub-step (a) of `lem:sheafofmodules_hom_of_local_compat` (HEq→sectionwise) + add `lem:scheme_modules_hom_local_section` proof block | COMPLETE; no strategy-modifying findings |
| mathlib-analogist | tscmp254 | cross-domain: the 4-iter `restrictScalars(𝟙)`/two-instance whisker wall | Decisive δ/μ-naturality reformulation + spelling pin + eager `restrictScalars(𝟙)` strip; `analogies/tscmp254.md` |
| progress-critic | pc254 | convergence + dispatch-sanity for the 2-file plan | Route 1 STUCK / Route 2 CHURNING; both correctives correct; M=2 OK; engine lane → blueprint iter-255 |
| blueprint-reviewer | br254 | same-iter fast-path scoped re-review of the bw254-patched chapter (gates both lanes) | (verdict folded into PROGRESS.md gate-judgment) |

## Plan-agent verifications done first-hand
- `homOfLocalCompat` / `hf` **absent from `archon-protected.yaml`** (only Genus/Jacobian/AbelJacobi) — the
  "PROTECTED" belief is FALSE; re-sign is a legal prover action.
- `homOfLocalCompat` has **no compiling caller** (grep: only `exists_tensorObj_inverse`, itself sorry).
- tscmp254 lemma names grep-VERIFIED in the pinned Mathlib: `δ_natural_left/right` (`Functor.lean:246,250`),
  `μ_natural_left/right` (`:70,74`), `restrictScalarsId'App_inv_naturality` (`ChangeOfRings.lean:217`).
- `MOONSHOT_API_KEY` is SET (informal-agent fallback available if needed; not used this iter — the
  mathlib-analogist subagent is the better structural-consult tool and was used instead).

## Subagent skips
- **strategy-critic**: STRATEGY.md edits this iter are a status/velocity refresh of the A.1.c.sub row
  + an engine-lane scheduling note WITHIN the existing route decomposition — no route swap, no phase
  add/remove, no new strategic fork. Prior verdict sc252 (iter-252) = SOUND with all CHALLENGEs addressed;
  no live CHALLENGE remains. (iter-253 also skipped on the same basis.) Re-dispatch when a genuine
  strategic change lands (e.g. opening the engine route as a 3rd phase at iter-255, which WILL warrant it).

## Next-iter setup
- **iter-255 COMMITMENTS:** (1) dispatch a blueprint-writer for the engine 3rd lane
  (`IsLocallyTrivial⟹IsFinitePresentation`, engine252-scoped; new chapter) to enable genuine M=3
  parallelism per the standing PARALLELISM directive (pc254 avoidance-clock); (2) if TS-cmp's δ/μ recast
  failed, take the planner-side structural decision (refactor restatement OR DualInverse-first reorder).
