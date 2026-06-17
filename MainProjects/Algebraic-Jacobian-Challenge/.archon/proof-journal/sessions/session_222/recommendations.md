# Recommendations — for the iter-223 plan agent

## HIGH — closest to completion / must-do

### 1. Close the `internalHomEval` naturality sorry — tame the whnf bomb
- **Target:** `PresheafOfModules.internalHomEval` (`lem:internal_hom_eval`),
  `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` L1449–1455.
- **State:** the reduction is DONE and verified in pieces. `tensor_ext` reduces naturality to
  `G: evalLin M Y ((dual M).map f φ) (M.map f s) = ((𝟙_).map f).hom (evalLin M X φ s)`; the
  `Over.map` coherence is solved (`restr_map_homMk`, `dual_map_app_terminal` both axiom-clean).
  The ONLY blocker is a `whnf` heartbeat bomb (>3.2M heartbeats, ~exponential — NOT budget-bound)
  localized to instantiating the `rfl`-bridge `restr_map_homMk` at the concrete unit `𝟙_` /the
  closing `exact key.symm`.
- **Action:** re-dispatch the SAME `mathlib-build` lane with one of the three recorded whnf-free
  routes (do NOT re-derive the reduction; it is complete in `task_results/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md`):
  1. **Generalize the unit** — `set U := 𝟙_ ...` (or `generalize`) BEFORE `naturality_apply`/`rw
     ...at key`/`exact`, do the `restr_map_homMk`/`naturality_apply`/`exact` with `U` ABSTRACT
     (cheap, like `restr_map_homMk M f`), then specialize `U := 𝟙_` only at the very end.
  2. **Use Mathlib `pushforward_obj_map_apply'` / `pushforward_map_app_apply'`** (from
     `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward`) so matching is syntactic, not
     whnf — note `pushforward₀ F R = pushforward (𝟙 (F.op ⋙ R))`.
  3. **Close `G` elementwise** — after syntactic `rw [dual_map_app_terminal, restr_map_homMk]`
     (avoiding the unit-instantiation form), finish with `LinearMap.ext`/`congr 1` so every
     residual goal is between small `evalLin`/`φ.app` terms.
- **Success bar:** `internalHomEval` axiom-clean (no `sorryAx`); **project sorry 81 → 80**.
- **Churn watch (must-fix-this-iter if triggered):** sub-step 3 has now consumed 2 iters
  (221 slip → 222 stub). If iter-223 returns PARTIAL still unable to tame the whnf bomb, that is a
  GENUINE within-sub-phase wall — STOP re-dispatching the same lane and run a **mathlib-analogist
  (cross-domain-inspiration)** consult on "how does Mathlib avoid whnf explosions when defeq-ing
  against a deeply-nested unit object", OR reconsider whether the unit `𝟙_` should be presented in
  a shape with a smaller `whnf` normal form. Do NOT spend a third iter bumping heartbeats — that is
  proven not to help.

## HIGH — blueprint HARD GATE for the next prover round on this file

### 2. Enrich `lem:internal_hom_eval` proof sketch (blueprint-writer)
- The chapter (`Picard_TensorObjSubstrate.tex` ~L2608–2680) is complete + correct mathematically,
  but `lean-vs-blueprint-checker ts222` (major #1) flags the proof sketch as **under-specified for
  the whnf fix**: it states the math identity `φ(s)|_V = (φ|_V)(s|_V)` but not the tactic-level
  obstacle (whnf bomb) or the 3 fixes, which live only in `task_results`. Before re-dispatching the
  prover, dispatch a `blueprint-writer` on this chapter to fold in the obstacle + the 3 routes so
  the chapter can guide the next prover, not just the math. (Per the HARD GATE, this is the
  guidance deficit to close on the chapter feeding the live lane; the chapter is otherwise
  `complete + correct`, so this is an enrichment, not a blocker re-classification.)

## MEDIUM

### 3. Fold the stale file-header fix into the next prover directive
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` L37–47 (`## Status (current)`) still lists 3
  sorry residuals and calls the dual block "axiom-clean toward closing them" without mentioning the
  new `internalHomEval` sorry — actual file sorry count is now 4 (auditor major #1). The review
  agent cannot edit `.lean`; instruct the iter-223 prover to correct the header as a ride-along
  comment edit (it will likely close `internalHomEval` anyway, in which case the header returns to
  3 residuals — but it must reflect reality either way).

### 4. Fix `sync_leanok` pin/tracking gaps (plan-agent `\lean{...}` hints)
- `lem:islocallyinjective_whisker_of_W` and `lem:isiso_sheafification_map_of_W` have `\leanok`
  but NO `\lean{...}` pin — add `\lean{...}` so sync can track them
  (`isLocallyInjective_whiskerLeft_of_W` carries a sorry, so its statement-`\leanok` is correct,
  but the pin is needed for sync to manage it; `isIso_sheafification_map_of_W` is axiom-clean).
- `lem:tensorobj_unit_iso`, `lem:presheaf_pushforward_adj_substrate`,
  `lem:restrictscalars_ringiso_strongmonoidal` have axiom-clean Lean decls but no statement
  `\leanok` — likely the multi-pin `\lean{..., ...}` form is not parsed by `sync_leanok`. Worth a
  one-time investigation so the frontier stops under-reporting completed work. (Low urgency;
  cosmetic on the dashboard, but it hides genuine progress.)

## Reusable proof patterns discovered / confirmed this iter
- **Isolate a heavy `whnf` defeq into a `private` `rfl` lemma** (`restr_map_homMk`) so it runs once
  in its own heartbeat budget — works when the parameter is ABSTRACT; **breaks (exponential `whnf`)
  when instantiated at the concrete unit `𝟙_`**, whose normal form is enormous. Generalize-then-
  specialize the unit is the counter-pattern.
- **Keep eval values at their NATURAL over-ring type** (not ascribed to the unit value) to make the
  contraction simp lemma (`internalHomEvalApp_tmul`) `rfl`-provable — confirms the
  [[ts-assoc-flatness-gap]] diamond-bridge trick.
- `hom_app_heq` (`subst h; rfl` + `eq_of_heq`) + `congrArg Over.mk (Category.id_comp f.unop)`
  discharges the `Over.map`-pseudofunctor-coherence (`dual_map_app_terminal`) — the iter-220
  `restrictionMap` template, ported successfully (the iter-221 blocker is now SOLVED).

## Do NOT re-assign / anti-patterns
- Do NOT re-attempt the naturality with higher `maxHeartbeats` — `{1.6M, 3.2M}` all time out; the
  cost is ~exponential, not budget-bound. The fix is structural (whnf-free), not a budget bump.
- Do NOT pin/forward a `dual`-shaped helper-sorry to launder `exists_tensorObj_inverse` (the
  iter-214 d.1 anti-pattern). The current `internalHomEval` sorry is on the genuine target and must
  be CLOSED, not propagated.
