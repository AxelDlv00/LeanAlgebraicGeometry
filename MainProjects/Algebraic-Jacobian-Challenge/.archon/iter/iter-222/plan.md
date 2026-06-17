# Iter-222 plan-agent run

## Headline outcome

The "finish sub-step 3 — assemble the slipped `internalHomEval` morphism" iter. iter-221
(mathlib-build sub-step 3) landed PRIMARY target 1 `PresheafOfModules.dual` axiom-clean (leanok'd)
+ the per-object evaluation `internalHomEvalApp` and 5 helpers (the mathematical heart of PRIMARY
target 2), but the FULL natural morphism `internalHomEval` slipped — blocked on `Over.map`
pseudofunctor-coherence in the `Hom.mk` naturality field, with a precise worked-out reduction
recorded by the prover. This iter I (a) processed iter-221 results, (b) ran progress-critic
(= CONVERGING; re-dispatch endorsed; STUCK-threshold watch recorded), (c) dispatched a
blueprint-writer to durably record the per-object/assembly split in `lem:internal_hom_eval`
(addressing the lvb ts221 major) + blueprint-clean (CLEAN), and (d) dispatched the `mathlib-build`
prover to COMPLETE sub-step 3 — assemble `internalHomEval` via the ported iter-220
`hom_app_heq`/`subst` template. Build GREEN entering; project sorry 80; one additive blueprint
edit; no Lean edits by plan.

## What I processed (iter-221 outcomes)

- iter-221 closed NO project sorry (flat 80 — by design; `exists_tensorObj_inverse` closes only at
  sub-step 5). 6 axiom-clean decls landed (`dual` + `internalHomEvalApp` + `evalLin`/`evalLin_add`/
  `evalLin_smul`/`termRingMap_terminal`); the `@[implicit_reducible]` ride-along fix was DONE.
  Nothing migrates to `task_done.md`. Archived the 3 processed iter-221 result files
  (`AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md`, `lean-auditor-ts221.md`,
  `lean-vs-blueprint-checker-ts221.md`) → `task_results/archive/iter-221/`.
- iter-221 review reports actioned this iter:
  - **lean-vs-blueprint-checker ts221** (0 must-fix; 1 major, 1 minor): the major — `lem:internal_hom_eval`
    did not acknowledge the already-built per-object `internalHomEvalApp`, making the per-object/assembly
    split invisible to the next prover. ADDRESSED by blueprint-writer ts222 (`% NOTE:` + assembly prose
    + `\uses{lem:presheaf_internal_hom_restriction}`); confirmed pure by blueprint-clean ts222. The minor
    (helper namespace = `PresheafOfModules`, not `InternalHom`) is informational; no action.
  - **lean-auditor ts221** (0 must-fix; 3 major, 6 minor): the two stale docstrings
    (`tensorObjOnProduct` L1853, `tensorObj_assoc_iso` L1562) folded into the prover directive as an
    optional comment-only ride-along. The 14-site `Sheaf.val`→`ObjectProperty.obj` deprecation is
    recorded as a STANDING DEFERRAL (dedicated polish pass post-dual; deprecation warnings, not errors —
    migrating 14 sites mid-build risks destabilizing the lane).

## Decision made — complete sub-step 3 (assemble `internalHomEval`); no strategy fork re-open

**Fork considered:** (i) re-dispatch the SAME lane to finish `internalHomEval` via the ported
`hom_app_heq` trick; (ii) treat the first within-sub-phase slip as a churn signal and pivot/consult;
(iii) re-open the RR-fork (lift RR pause / divisor route).

**Chosen: (i).** Rationale:
- The build is a deliberately-committed multi-iter block (decided iter-219, strategy-critic ts219 =
  SOUND). Under the standing USER directives (ROUTE C PAUSE permanent; PRIMARY GOAL = Pic_{C/k}
  representability bottom-up on Route A) I cannot pivot to the cheaper divisor route myself, and within
  Route A the ⊗-inverse object is unavoidable. STRATEGY.md is unchanged; no new signal re-opens the fork
  → (iii) off the table this iter.
- progress-critic ts222 = **CONVERGING** and explicitly endorsed (i): re-dispatching with the ported
  `hom_app_heq` template is "apply a known technique to a named, precisely-reduced obstacle" — structural
  follow-through, not "add helpers and hope." 2 of 5 sub-steps retired; sub-step 3 at ~50%; the single
  PARTIAL is the first slip in 3 productive iters; elapsed 3 of ~6–12 (lower-bound pace).
- The fix is concrete and precedented: the iter-221 prover left a worked-out reduction
  (`tensor_ext` → `internalHomEvalApp_tmul` simp lemma → 3 named `Over.map` coherence steps), and
  iter-220 already cracked the SAME `Over.map` coherence obstacle for `restrictionMap` via `hom_app_heq`/
  `subst`. So the directive says "attempt the body; recipe: <handoff §internalHomEval + iter-220
  template>", NOT "owed iter-N+" — the recipe exists, so throttling would be artificial.

**Response to the progress-critic STUCK watch (must-internalize, not a must-fix yet).** The `Over.map`
coherence blocker has appeared 2 consecutive iters. The critic's rule: if iter-222 reports it AGAIN
despite the ported `hom_app_heq` — OR the `tensor_ext` reduction fails to reach `naturality_apply` for a
NEW structural reason — the 3-iter STUCK threshold is hit and iter-223 MUST run a mathlib-analogist
consult (how `PresheafOfModules.Hom` naturality is proved when the restriction functor is `Over.map`-
defined) BEFORE re-dispatching. This is recorded verbatim in the objectives + PROGRESS so the next
planner acts on it without re-deriving.

**Cheapest reversal signal:** iter-222 returning PARTIAL with only more eval *helpers* and no assembled
`internalHomEval` morphism → first genuine within-sub-phase churn signal → trigger the mathlib-analogist
consult per the STUCK watch above.

## Soundness check (cheap disprove pass)

`internalHomEval` is not a candidate for being false-as-written: it is a definitional construction
(a morphism assembled from already-built per-open contractions), the per-object content is already
axiom-clean (iter-221), the statement is sourced (Stacks "Modules on Ringed Spaces", §Internal Hom,
tag area 01CM, the canonical evaluation `F ⊗ Hom(F,G) → G`), and the naturality identity
`φ(s)|_V = (φ|_V)(s|_V)` is a triviality of restriction. No disprove pass warranted; the obstacle is
Lean-elaboration coherence, not mathematics.

## Subagent skips

- **strategy-critic**: STRATEGY.md unchanged since iter-219 (all of iters 219–221 sidecars confirm
  "STRATEGY.md unchanged"); prior ts219 verdict SOUND with no live CHALLENGE/REJECT. Skip condition met.
- **blueprint-reviewer**: `lem:internal_hom_eval` (the sole block feeding this iter's prover lane) was
  cleared `complete:true, correct:true, 0 must-fix` by blueprint-reviewer ts221; this iter's writer edit
  is purely ADDITIVE (a `% NOTE:` + 2 sentences of assembly prose + a `\uses` cross-ref; statement and
  `\lean{}` pin untouched) and was confirmed pure + structurally valid by blueprint-clean ts222. The
  gate is satisfied by the standing ts221 verdict; an additive clarification to an already-cleared block
  cannot lower its complete/correct status. (Not the same-iter fast path — no statement change to re-verify.)

## Harness note (process)

The tool-result channel stalled badly mid-phase (tool outputs buffered and flushed in bursts across
many calls). All dispatches DID run and all reports landed on disk; I waited out the buffering and read
the genuine reports (progress-critic ts222 CONVERGING, blueprint-writer ts222 COMPLETE, blueprint-clean
ts222 CLEAN) before acting. No fabrication — every verdict above is from the on-disk report. A stray
`_harness_probe.txt` written during the stall was removed.

## State entering iter-222 prover
- Build GREEN; project sorry 80 (3 in TensorObjSubstrate.lean: `isLocallyInjective_whiskerLeft_of_W`,
  `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` — all untouched this iter, all FORBIDDEN).
- blueprint-doctor iter-221: CLEAN (no orphans/broken refs/axioms).
- Single prover lane dispatched: `TensorObjSubstrate.lean` [mathlib-build], complete sub-step 3.
- All other lanes HELD per USER directives (RPF, FGA, Quot engine, Albanese cone, Route 2, WD, RCI, A.3.*).
