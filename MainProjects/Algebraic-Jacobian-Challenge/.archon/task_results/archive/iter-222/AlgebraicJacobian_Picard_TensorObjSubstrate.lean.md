# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (2 axiom-clean):**
  - `PresheafOfModules.internalHomEvalApp_tmul` (≈L1421, `rfl`) — the contraction simp lemma.
  - `PresheafOfModules.restr_map_homMk` (≈L1434, `rfl`) — `(restr U N).map (Over.homMk f.unop).op = N.map f`.
  Both VERIFIED `#print axioms = {propext, Classical.choice, Quot.sound}`.
- **PRIMARY target `internalHomEval` (`lem:internal_hom_eval`): NOT landed** — the naturality
  reduction is **fully worked out and verified in pieces**, but the final assembly hits a `whnf`
  **heartbeat BOMB** (times out even at `maxHeartbeats 3200000`). Held as a typed `sorry`
  naturality field to keep the build **GREEN**; the complete worked proof + the `dual_map_app_terminal`
  lemma + the precise bomb diagnosis are preserved verbatim in a `/- … -/` block above the decl.
- **File status:** compiles **GREEN** (verified `errors=0`).
- **sorry count:** 3 → 4 (added `internalHomEval` naturality sorry; pre-existing 3:
  `isLocallyInjective_whiskerLeft_of_W`, `tensorObj_assoc_iso`, `exists_tensorObj_inverse`).

## What is fully VERIFIED (each compiles axiom-clean in isolation, < 200000 heartbeats)
Confirmed via `lean_multi_attempt` and standalone compiles:
1. `internalHomEvalApp_tmul := rfl` — axiom-clean (landed).
2. `restr_map_homMk := rfl` (N abstract) — axiom-clean (landed). **Cheap only for abstract N.**
3. `dual_map_app_terminal` (`((dual M).map f φ).app term_Y = φ.app (op (Over.mk f.unop))`,
   proof = `hom_app_heq` + `congrArg Over.mk (Category.id_comp f.unop)`) — axiom-clean in isolation.
4. The reduction: after `intro X Y f`, `refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)`,
   then `change` to the contraction form (defeq-valid, confirmed), `erw [Monoidal.tensorObj_map_tmul]`,
   `rw [internalHomEvalApp_tmul, internalHomEvalApp_tmul]` reduces the naturality square to
   **G**: `evalLin M Y ((dual M).map f φ) (M.map f s) = ((𝟙_).map f).hom (evalLin M X φ s)`.
5. `key := PresheafOfModules.naturality_apply (φ : restr X.unop M ⟶ restr X.unop (𝟙_)) (Over.homMk f.unop).op s`
   elaborates fine; `rw [restr_map_homMk M f] at key` fires.

## THE BLOCKER — `whnf` heartbeat bomb at the unit instantiation
The step `rw [restr_map_homMk (𝟙_ (PresheafOfModules …)) f] at key` (instantiating the `rfl`-bridge
at the **concrete unit object** `𝟙_`) and/or the final `exact key.symm` trigger a `whnf` explosion
of the deeply nested `ofPresheaf ∘ pushforward₀ ∘ Over.map ∘ restrictScalars ∘ tensorObj ∘ unit`
machinery — **> 3.2M heartbeats** (`(deterministic) timeout at whnf`). Diagnostic detail:
- `restr_map_homMk M f` with **M abstract** is cheap (verified). The explosion is specific to the
  **unit `𝟙_`** (its `whnf` normal form is enormous), so `restr_map_homMk (𝟙_) f` and any tactic
  that defeq-checks against the unit (`exact key.symm`, `change`/`from rfl` touching the unit) blow up.
- `set_option maxHeartbeats {1.6M, 3.2M}` all time out → not a budget issue, the cost is ~exponential.

## NEXT ITER — tame the bomb (whnf-free assembly)
Concrete routes (any one should close it; all keep every step syntactic, never whnf the unit):
1. **Generalize the unit.** Before `naturality_apply`/`rw …at key`, `set U := 𝟙_ (PresheafOfModules …)`
   (or `generalize`), do the `restr_map_homMk`/`naturality_apply`/`exact` with `U` ABSTRACT (cheap),
   then `subst`/specialize `U := 𝟙_` only at the very end where no further whnf is forced.
2. **Use Mathlib's pushforward map lemmas** instead of the `rfl`-bridge so matching is syntactic:
   `PresheafOfModules.pushforward_obj_map_apply'` / `pushforward_map_app_apply'`
   (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward`) —
   `(((pushforward φ).obj M).map f) m = (M.map (F.map f.unop).op) m`. Rewrite `key` with these
   (note `pushforward₀ F R = pushforward (𝟙 (F.op ⋙ R))`).
3. **Close G elementwise without `exact key.symm`:** after syntactic `rw [dual_map_app_terminal,
   restr_map_homMk]` (avoiding the unit-instantiation form), finish with `LinearMap.ext` / `congr 1`
   / `exact (key …)` where every remaining goal is between small (`evalLin`/`φ.app`) terms.

The reduction is done; only this elaboration-cost issue remains. Expected ≤ 1 focused iter.

## Why I stopped
Two compounding factors: (a) a persistent tooling-output lag (LSP/Bash results returned only in
large delayed batches, so each edit→compile→read cycle cost minutes — I worked around it with
background `lake env lean` runs writing bare error-counts); (b) a genuine `whnf` heartbeat bomb in
the final assembly that exceeds 3.2M heartbeats and is not fixable by bumping the budget. With the
reduction fully verified in pieces and the bomb precisely localized to the unit-`𝟙_` instantiation,
the responsible outcome is a GREEN build (typed `sorry`) + the complete worked proof preserved
in-source + this sharp handoff. This is a materially stronger position than iter-221 ("blocked on
Over.map coherence"): the coherence is solved (`restr_map_homMk`, `dual_map_app_terminal`,
axiom-clean), and only an elaboration-cost obstacle with three concrete fixes remains.

**Real progress:** 2 axiom-clean declarations (`internalHomEvalApp_tmul`, `restr_map_homMk`) +
a verified reduction of `internalHomEval` naturality to a single whnf-cost obstacle.

## Blueprint markers
- `lem:internal_hom_eval` (`internalHomEval`): NOT ready for `\leanok` (naturality `sorry`).
- `internalHomEvalApp_tmul`, `restr_map_homMk`: supporting lemmas (no dedicated pins).
