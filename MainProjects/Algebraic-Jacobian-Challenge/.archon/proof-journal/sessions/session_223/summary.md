# Session 223 (iter-223) — review summary

## Metadata
- **Session / iter:** 223 (review of iter-223).
- **Lane:** the funded Decision-1 sheaf internal-hom build, sub-step 3 (the evaluation counit).
  Mode this iter: `prove` (switched from `mathlib-build` by the iter-223 planner — close ONE
  existing sorry whose recipe was worked out).
- **Prover:** 1 (claude-opus-4-8). Status: **PARTIAL / BLOCKED** (honest non-closure).
- **Sorry trajectory:** file code sorries **4 → 4** (no change, no regression); **project sorry
  81 → 81** (unchanged). `sync_leanok` iter 223, sha `097055c7`, **added 0 / removed 0**.
- **Build:** GREEN. `lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate.lean` → EXIT=0,
  0 errors. The 4 sorry-decls: L612 `isLocallyInjective_whiskerLeft_of_W`, L1463 `internalHomEval`
  (this target), L1921 `exists_tensorObj_inverse`, L1971 `addCommGroup_via_tensorObj`.
- **`internalHomEval` axiom check (re-verified this review):** `{propext, sorryAx, Classical.choice,
  Quot.sound}` — confirms the `naturality` field is still a typed `sorry`.
- **Blueprint doctor:** CLEAN (no orphans, all `\ref`/`\uses` resolve, no `axiom` decls).

## Target attempted — `PresheafOfModules.internalHomEval` naturality (the iter-222 typed sorry)

**Not closed.** The iter-222 review mandated "iter-223 MUST close it (sorry 81→80), not propagate
it." That mandate was **NOT met** — the sorry remains. The iter is nonetheless not pure churn: it
produced a decisive negative finding that invalidates the iter-222 handoff and pins the exact next
action.

### The obstacle — re-characterized, authoritatively, via ~12 `lake env lean` bisection compiles

The naturality goal, after `intro X Y f; refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)`,
is (codomain = the monoidal unit `𝟙_`):
```
((tensorObj M (dual M)).map f ≫ (restrictScalars _).map (internalHomEvalApp M Y)).hom (s ⊗ₜ φ)
  = (internalHomEvalApp M X ≫ (𝟙_).map f).hom (s ⊗ₜ φ)
```
**EVERY goal-rewriting tactic bombs with `(deterministic) timeout at whnf, 200000 heartbeats` on its
FIRST rewrite.** Root cause: the goal codomain is the `PresheafOfModules` monoidal unit `𝟙_` and the
goal is saturated with `dual M = internalHom M 𝟙_`; `kabstract` (used by `rw`/`erw`/`simp` to locate
the rewrite site) runs `isDefEq`, which forces a `whnf` of Mathlib's
`PresheafOfModules.Monoidal.tensorUnit` machinery whose normal form is ~exponential. NOT budget-bound
(`maxHeartbeats` is forbidden by the objectives — cost is exponential, not budget-limited).

**This is DEEPER than the iter-222 diagnosis.** iter-222 localized the bomb to the single
`restr_map_homMk (𝟙_) f` step and proposed three "whnf-free" routes (#1 generalize-unit,
#2 pushforward-lemmas, #3 elementwise). iter-223 confirmed that **all three routes bomb on their
FIRST rewrite** — the unit toxicity is in the goal itself, not in one lemma instantiation. iter-222's
"verified in pieces" had been done with `lean_multi_attempt`, which does NOT reproduce full-elaboration
heartbeat accounting; under a real `lake` compile every route bombs.

### Attempts (each a separate authoritative compile)
1. `simp only [ModuleCat.hom_comp, LinearMap.comp_apply]` → whnf bomb.
2. `erw [ModuleCat.hom_comp, ModuleCat.hom_comp, LinearMap.comp_apply, LinearMap.comp_apply]; erw [tensorObj_map_tmul]; rw [internalHomEvalApp_tmul, internalHomEvalApp_tmul]` → whnf bomb on first rewrite.
3. `rw [PresheafOfModules.Monoidal.tensorUnit_map]` → whnf bomb.
4. `rw [show (𝟙_ …) = PresheafOfModules.unit _ from rfl]` → whnf bomb (the `rfl`-show itself needs `isDefEq` on the unit).
5. `simp only [PresheafOfModules.Monoidal.tensorUnit_map]` → whnf bomb.
6. `attribute [local irreducible] internalHomEvalApp dual in …` + any of 1–5 → STILL whnf bomb. Irreducibility on the project bodies cannot shield Mathlib's `𝟙_` machinery; and making `dual` irreducible additionally breaks the `φ : restr X.unop M ⟶ restr X.unop 𝟙_` cast (which needs `(dual M).obj X` defeq the hom type).
7. **False-positive episode (recorded for honesty):** each of the six worked steps verified
   empty-diagnostics under `lean_multi_attempt`; the prover briefly wrote a docstring claiming
   "sorry 4→3 / axiom-clean / sub-step 3 RETIRED" and then **reverted it** once the authoritative
   `lake env lean` compile showed the whnf bomb. No false claim survives in source (pending the
   lean-auditor ts223 confirmation).

### The worked mathematics (correct; only the Lean assembly is blocked)
Preserved verbatim in a comment block above the in-source `sorry` — a six-step reduction:
1. break the two `≫` on `s ⊗ₜ φ`, then `tensorObj_map_tmul` + `internalHomEvalApp_tmul ×2` ⇒
   **G**: `evalLin M Y (dual.map f φ) (M.map f s) = ((𝟙_).map f).hom (evalLin M X φ s)`;
2. `PresheafOfModules.Monoidal.tensorUnit_map` (verified-exists) ⇒ RHS = ring map `R.map f`;
3. (★) `((restr X.unop 𝟙_).map (Over.homMk f.unop).op).hom r = (R.map f) r`;
4. `key := naturality_apply (φ : restr X.unop M ⟶ restr X.unop 𝟙_) (Over.homMk f.unop).op s`;
5. `hdt`: `((dual M).map f φ).app (op (Over.mk (𝟙 Y.unop))) = φ.app (op (Over.mk f.unop))`;
6. close: `exact hdt2.trans (key.trans (star (evalLin M X φ s)))`.
Each step is individually sound; only the *assembly against the live `𝟙_`-laden goal* (which
requires step-1/step-2 rewriting) triggers the bomb.

### Verified-exists Mathlib lemmas found this iter (for the iter-224 analogist)
- `PresheafOfModules.Monoidal.tensorUnit_map (f) : (𝟙_ (PresheafOfModules R)).map f = ModuleCat.ofHom (RingHom.toModule (ConcreteCategory.hom (R.map f)))`
- `PresheafOfModules.Monoidal.tensorUnit_obj (X) : (𝟙_ (PresheafOfModules R)).obj X = ModuleCat.of (R.obj X) (R.obj X)`
- `PresheafOfModules.pushforward_obj_map_apply`, `PresheafOfModules.unit_map_apply`, `PresheafOfModules.naturality_apply` — all confirmed present.

## Process read (honest)
- **Mandate not met, but no regression and no anti-pattern.** The funded build's project sorry has
  now been at **81 for two consecutive iters** (went 80→81 in iter-222 by stubbing this naturality,
  flat 81→81 in iter-223). The prover did NOT push a new `dual`-shaped helper-sorry (the iter-214 d.1
  anti-pattern), did NOT brute-force `maxHeartbeats`, and honestly reverted its own over-optimistic
  docstrings. This is a hard wall, not helper-churn.
- **The reversal tripwire is TRIPPED.** The iter-223 planner explicitly pre-committed: "iter-223
  returns with the whnf bomb STILL present and none of routes #2/#1/#3 closing the sorry → iter-224
  runs the mathlib-analogist consult BEFORE any further dispatch." That is exactly the outcome.
  iter-224 must escalate; it must NOT re-run the same syntactic approach.

## Environment note (carried from the prover, do not mis-budget next iter)
The harness was severely degraded this session: long stretches where `Bash`/`Read`/`lean_*` calls
returned EMPTY, and `lean_diagnostic_messages` repeatedly returned STALE/batched results (phantom
errors / `[]` while `lake` showed the true whnf bomb). The prover relied on
`lake env lean … > log; echo EXIT=$?` + `until grep EXIT` polling as the only authoritative signal.
This is an environment factor, not evidence the math got harder.

## Blueprint markers updated (manual)
- None. `lem:internal_hom_eval` already carries an accurate `% NOTE:` (the per-open `internalHomEvalApp`
  is built; the remaining obligation is the naturality/assembly step). No rename, nothing closed.
  Statement-block `\leanok` (decl exists with ≥1 sorry) is the deterministic `sync_leanok` verdict and
  is correct; the proof block remains unmarked.

## Review subagents
- **lean-auditor ts223** — scoped to TensorObjSubstrate.lean, docstring-honesty + sorry-count
  accuracy. See `logs/iter-223/lean-auditor-ts223-report.md`. (Findings folded into recommendations.)
- **lean-vs-blueprint-checker ts223** — TensorObjSubstrate.lean vs `Picard_TensorObjSubstrate.tex`,
  confirming the `lem:internal_hom_eval` block does not overclaim the open naturality. See
  `logs/iter-223/lean-vs-blueprint-checker-ts223-report.md`.
