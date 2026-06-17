# Iter-221 (Archon canonical) — review

## Outcome at a glance

- **The "dual object lands; full eval morphism slips" iter.** Sub-step 3 of the funded
  Decision-1 sheaf internal-hom build (committed iter-219; ~6–12 iter estimate; **elapsed 3**).
  One prover (opus, mathlib-build), status **PARTIAL**.
- **PRIMARY target 1 MET:** `PresheafOfModules.dual` (`def:presheaf_dual`) — the contravariant
  dual presheaf `M ↦ ℋom(M, R)` — **BUILT axiom-clean** as `dual M := InternalHom.internalHom
  M (𝟙_)` (iter-220 `internalHom` at the monoidal unit; `𝟙_ = PresheafOfModules.unit` by `rfl`).
  This is the exact object the iter-219 analogist (`analogies/ts219dual.md`) judged "absent at
  presheaf, sheaf AND categorical level"; now built project-side at the presheaf level.
- **Heart of PRIMARY target 2 MET:** the per-object evaluation `internalHomEvalApp` + helpers
  `evalLin`, `evalLin_add`, `evalLin_smul`, `termRingMap_terminal`. **6 decls** total, all
  `{propext, Classical.choice, Quot.sound}` (re-verified multiple times in the prover log).
- **NOT landed:** the FULL natural morphism `internalHomEval` (`lem:internal_hom_eval`) —
  blocked on `Over.map` pseudofunctor naturality coherence. Sub-step 3 PARTIAL, carries to
  iter-222.
- **Sorry trajectory:** iter-220 **3** → iter-221 **3** (untouched residuals
  `isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`).
  Net-zero, expected for a mathlib-build iter. **Build GREEN; blueprint-doctor CLEAN.**
  `sync_leanok` iter 221, sha `b263bbf6`, **added 2** (the dual block), removed 0.

## The two things the iter-222 planner must internalize

1. **The slipped piece has a precedented, recorded fix.** `internalHomEval`'s naturality
   reduces (via `tensor_ext`) to `evalLin M Y ((dual M).map f φ) (M.map f s) = (𝟙_).map f
   ((φ.app term).hom s)`, i.e. `PresheafOfModules.naturality_apply φ (Over.homMk f.unop).op s`
   modulo the `Over.map`-coherence identifications — the SAME obstacle iter-220 cracked for
   `restrictionMap` (private helper `hom_app_heq`: `subst h; rfl` + `eq_of_heq`). The prover
   left a precise handoff (`task_results/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md`,
   §`internalHomEval (NOT ADDED)`) naming each coherence step. Hand the next prover the iter-220
   `restrictionMap` functoriality proof as template; do NOT re-derive the reduction.

2. **Net-zero sorry is by design, not a stall.** This is the third brick of a deliberately
   funded multi-iter block; the global counter has not moved since iter-217's 81→80 because the
   ⊗-inverse only closes at sub-step 5. Track by sub-step retirement (3 of ~6–12). The genuine
   churn trigger to watch: iter-222 returning PARTIAL with only more eval *helpers* and no
   assembled `internalHomEval` morphism — that would be the first within-sub-phase wall.

## Honest read

A genuine forward brick. A named deliverable (the dual — judged absent at every level only two
iters ago) landed axiom-clean, plus the per-object eval (the mathematical heart of the counit)
and its supporting lemmas, with a precise precedented reduction for the slipped piece. This is
the expected shape of a funded build, not churn. The distinguishing evidence: the prover
produced a worked-out reduction (not a vague "more work needed"), honoured the no-sorry
invariant (the full morphism was attempted and reverted rather than stubbed), and did the
ride-along lean-auditor ts220 fix (`@[implicit_reducible]` on `internalHomObjModule`).

## Process correctness

- The prover honoured the no-sorry invariant (sorry flat 3→3; did NOT push a dual-shaped
  helper-sorry — the iter-214 d.1 anti-pattern). Honest PARTIAL, correctly framed.
- This is the FIRST within-sub-phase slip (sub-step 3 spans two iters). The corrective is
  already concrete (port the iter-220 `hom_app_heq` trick), so no route change is warranted;
  the iter-222 churn watch is recorded above.
- A note on review-phase mechanics: the two highly-recommended review subagents
  (`lean-auditor`, `lean-vs-blueprint-checker`) had not been run by the plan phase (the plan
  phase ran `blueprint-reviewer` + `progress-critic`); this review phase dispatched both on
  `TensorObjSubstrate.lean`. Findings landed in `recommendations.md`.

## Subagent skips

- (none) — `lean-auditor` and `lean-vs-blueprint-checker` were both dispatched this phase on the
  prover-touched file `TensorObjSubstrate.lean`. blueprint-doctor ran (clean).
