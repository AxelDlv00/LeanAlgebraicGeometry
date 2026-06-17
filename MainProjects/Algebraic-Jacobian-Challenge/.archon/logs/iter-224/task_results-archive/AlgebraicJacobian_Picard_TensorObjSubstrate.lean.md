# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-223

## Summary
- **Target:** close the `naturality` field of `PresheafOfModules.internalHomEval` (the iter-222
  typed `sorry`). **NOT closed.** sorry count: **4 → 4** (unchanged).
- **Build: GREEN.** Authoritative `lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
  → `EXIT=0`, errors=0. The 4 sorry-declarations (final authoritative compile) are L612
  `isLocallyInjective_whiskerLeft_of_W`, L1463 `internalHomEval` (this target), L1921
  `exists_tensorObj_inverse`, L1971 `addCommGroup_via_tensorObj` (baseline restored — the iter-222
  count was also 4; no regression).
- **Verdict:** `Infrastructure missing / genuinely new obstacle` — the three planned routes
  (#1 generalize-unit, #2 pushforward-lemmas, #3 elementwise) ALL fail for the SAME deeper reason,
  newly characterized this iter by authoritative bisection. This is the explicit iter-224
  mathlib-analogist escalation trigger (progress-critic ts223 tripwire).

## THE OBSTACLE (newly characterized, authoritative `lake env lean` bisection)
The naturality goal, after `intro X Y f; refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)`,
is:
```
((tensorObj M (dual M)).map f ≫ (restrictScalars _).map (internalHomEvalApp M Y)).hom (s ⊗ₜ φ)
  = (internalHomEvalApp M X ≫ (𝟙_).map f).hom (s ⊗ₜ φ)
```
**EVERY goal-rewriting tactic bombs with `(deterministic) timeout at whnf, 200000 heartbeats` on its
FIRST rewrite** — confirmed by separate full compiles:
- `erw [ModuleCat.hom_comp, ModuleCat.hom_comp, LinearMap.comp_apply, LinearMap.comp_apply]` → BOMB
- `rw [PresheafOfModules.Monoidal.tensorUnit_map]` → BOMB
- `rw [show (𝟙_ …) = PresheafOfModules.unit … from rfl]` → BOMB
- `simp only [PresheafOfModules.Monoidal.tensorUnit_map]` → BOMB
- `attribute [local irreducible] internalHomEvalApp dual in …` + any of the above → STILL BOMB

**Root cause:** the goal's codomain is the `PresheafOfModules` monoidal unit `𝟙_`, and the whole
goal is saturated with `dual M = internalHom M 𝟙_` (via `s ⊗ₜ φ`'s type and the composition).
`kabstract` (used by `rw`/`erw`/`simp` to locate the rewrite site and build the motive) runs
`isDefEq` on these subterms, which forces a `whnf` of the monoidal-unit machinery whose normal form
is enormous (>200000 heartbeats, ~exponential — NOT budget-bound).

**Why this is DEEPER than the iter-222 diagnosis:** iter-222 localized the bomb to the single
`restr_map_homMk (𝟙_) f` step and proposed three routes that avoid *that* step. But the bomb
actually fires on the FIRST rewrite of ANY route — the unit toxicity is in the goal itself, not in
one lemma instantiation. iter-222's "verified in pieces" was via `lean_multi_attempt`, which does
NOT reproduce the full-elaboration heartbeat accounting; under real `lake` compile every route bombs.

**Why `local irreducible` doesn't help:** making the project defs `dual`/`internalHomEvalApp`
irreducible shields *their* bodies, but the toxic `whnf` is in *Mathlib's* `𝟙_` monoidal-unit
machinery (`PresheafOfModules.Monoidal.tensorUnit` and its `.obj`/`.map`), which cannot be made
irreducible from the project. (Also: making `dual` irreducible breaks the `key` cast
`(φ : restr X.unop M ⟶ restr X.unop 𝟙_)`, which needs `(dual M).obj X` defeq the hom type.)

**`maxHeartbeats` is forbidden** by the objectives (cost is exponential, not budget-bound).

## The worked mathematics (correct; only the Lean assembly is blocked)
Preserved verbatim in a comment block above the `sorry` in-source. Six steps:
1. break the two `≫` on `s ⊗ₜ φ`, then `tensorObj_map_tmul` + `internalHomEvalApp_tmul ×2`
   ⇒ **G**: `evalLin M Y (dual.map f φ) (M.map f s) = ((𝟙_).map f).hom (evalLin M X φ s)`.
2. `PresheafOfModules.Monoidal.tensorUnit_map` **[verified-exists iter-223]**:
   `(𝟙_).map f = ofHom (RingHom.toModule (R.map f))` → RHS becomes the ring map `R.map f`.
3. (★) `((restr X.unop 𝟙_).map (Over.homMk f.unop).op).hom r = (R.map f) r`, via
   `unfold restr; rw [show pushforward₀ (Over.forget X.unop) R = pushforward (𝟙 …) from rfl,
   pushforward_obj_map_apply, unit_map_apply]`.
4. `key := naturality_apply (φ : restr X.unop M ⟶ restr X.unop 𝟙_) (Over.homMk f.unop).op s`;
   its `(restr X.unop M).map _` side is DEFEQ to `M.map f` (`restr_map_homMk`, cheap on abstract `M`).
5. `hdt`: `((dual M).map f φ).app (op (Over.mk (𝟙 Y.unop))) = φ.app (op (Over.mk f.unop))` via
   `congrArg ModuleCat.Hom.hom (eq_of_heq (hom_app_heq φ (congrArg op (congrArg Over.mk
   (Category.id_comp f.unop)))))`; `hdt2 := DFunLike.congr_fun hdt _`.
6. close: `exact hdt2.trans (key.trans (star (evalLin M X φ s)))`.

Each step is individually sound; it is the *assembly against the live `𝟙_`-laden goal* (which
requires at least step-1/step-2 rewriting) that triggers the whnf bomb.

## VERIFIED-EXISTS Mathlib lemmas found this iter (for the analogist / next agent)
- `PresheafOfModules.Monoidal.tensorUnit_map (f) : (𝟙_ (PresheafOfModules R)).map f
   = ModuleCat.ofHom (RingHom.toModule (ConcreteCategory.hom (R.map f)))`
- `PresheafOfModules.Monoidal.tensorUnit_obj (X) : (𝟙_ (PresheafOfModules R)).obj X
   = ModuleCat.of (R.obj X) (R.obj X)`
- `PresheafOfModules.pushforward_obj_map_apply`, `PresheafOfModules.unit_map_apply`,
  `PresheafOfModules.naturality_apply` — all confirmed present.

## Concrete next step (iter-224 mathlib-analogist directive)
Find/confirm a whnf-FREE way to discharge a `PresheafOfModules.Hom` naturality square whose
codomain is the monoidal unit `𝟙_`. Candidate directions:
- A `PresheafOfModules.Hom.ext`-style or `Hom.mk`-builder lemma that takes the per-section equation
  WITHOUT requiring `kabstract` over the unit (e.g. an `app`-wise constructor whose naturality
  obligation is stated in already-reduced form).
- Building the morphism via `PresheafOfModules.unit`-based unit and a `tensorUnit ≅ unit` iso so the
  toxic `𝟙_` never appears in the proof goal.
- Whether `conv`-localization + `rw (config := { transparency := .reducible })` (or
  `Lean.MVarId.rewrite` with reducible transparency) can prevent `kabstract` from whnf-ing the unit.

## Why I stopped (brutally honest)
`Infrastructure missing` (genuinely new obstacle). I did NOT close the sorry; sorry count 4 → 4.
**Real progress made:** authoritatively characterized (via ~12 `lake env lean` bisection compiles)
that the obstacle is NOT the iter-222 single-step bomb but a goal-wide `𝟙_`-whnf toxicity that
defeats `rw`/`erw`/`simp`/`local irreducible` alike; found and confirmed the exact Mathlib lemma
`tensorUnit_map` the next route needs; preserved the full six-step reduction in-source; reverted my
own over-optimistic docstring edits (which had briefly claimed the sorry closed) to an honest state.
The informal agent was NOT consulted — this is not a "find me a lemma" gap; the missing ingredient
is a whnf-free naturality discharge technique, which is precisely the mathlib-analogist's remit per
the iter-224 escalation tripwire. Build left GREEN with the typed `sorry`.

**Tooling note for the planner:** the harness was severely degraded this session — long stretches
where every `Bash`/`Read`/`lean_*` call returned EMPTY, and `lean_diagnostic_messages` repeatedly
returned STALE/batched results (showed `[]` or a phantom L1458 error while `lake` showed the true
whnf bomb). I relied on `lake env lean ... > logfile; echo EXIT=$?` + `until grep EXIT` polling as
the only authoritative signal. Trust `lake` exit codes over streamed LSP diagnostics this session.

## Blueprint markers
- `lem:internal_hom_eval` (`internalHomEval`): NOT ready for `\leanok` on its proof block
  (naturality `sorry` remains). Statement block is fine.
