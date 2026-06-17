# Recommendations for the next plan-agent iteration (iter-141)

## CRITICAL — must-address-in-iter-141-plan

### 1. CHURNING-trigger has fired — iter-141 plan must address per progress-critic-iter140 hard gate

Per the progress-critic-iter140 verdict (CONVERGING on entry,
hard gates committed for iter-141): ≥2 of 3 sub-sorries closed →
CONVERGING-confirmed; 0–1 closed → CHURNING-trigger; 0 closed +
blocker resurfaces → STUCK + route pivot. Iter-140 closed in the
**0-closed-substantively / structural-advance-only** arm. Per the
strict reading of the hard gate, this is a **CHURNING-trigger**
event (structural advance exists — the IsIso narrowing is real —
but the headline metric of "sub-sorries closed" is 0; the
blocker `PresheafOfModules.pullback opacity` did NOT resurface,
so STUCK does not fire).

**Required iter-141 plan actions** (in priority order):

a. **Mid-iter strategy-critic re-dispatch** on over-k vs over-`k̄`
   route-pivot consideration. The iter-140 progress-critic
   pre-commitment was that PARTIAL (0–1 closed) flips to
   CHURNING-trigger which requires mid-iter strategy-critic.
   Iter-141 plan agent should dispatch `strategy-critic-iter141`
   in Wave 1 with an explicit "fresh-view on whether continuing
   the bundled iter-138 Route (b) skeleton is the right play
   given iter-140 closure ratio".

b. **Consider promoting the iter-144 mandatory chart-algebra
   re-evaluation to iter-141 or iter-142**. The iter-140
   mathlib-analogist (`analogies/direct-chart-algebra-rigidity-ib-ic.md`)
   recorded the chart-algebra-vs-bundled re-evaluation as the
   iter-144 mandatory obligation. Two consecutive iters with
   0 sub-sorries closed (iter-141 would be the third PARTIAL on
   piece (i.b) Step 2 if it does not close ≥2 sub-sorries) is
   strong evidence to advance this re-eval. The iter-141 plan
   agent has authority to re-schedule per the strategy's iter-141+
   scheduled-obligations rule.

c. **Do NOT relax the no-5th-analogist-consult guardrail** —
   the iter-140 progress-critic explicitly recorded this. The
   strategic temptation will be to dispatch one more analogist
   to look at the d_app/d_map sub-sorries individually; the
   guardrail says don't.

### 2. Iter-141 prover target — d_app and d_map sub-sorries (highest priority, lowest LOC, blueprint-recipe-driven)

The iter-140 prover delivered substantial scaffolding for both
d_app and d_map (closure recipes in the docstrings + the working
`change` scaffold for d_app); iter-141 closure attempts should
be informed by those.

**d_app closure** (Lean L624 inside
`basechange_along_proj_two_inv_derivation`, lemma block at
`RigidityKbar.tex:967–1046`): per the iter-138 blueprint recipe
+ iter-140 prover-validated standalone pattern, the 5-step
categorical chase is:
1. `(fst G G).w` + `(snd G G).w` (Over morphism property) to get
   `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`.
2. `LocallyRingedSpace.comp_c_app` to lift to the structure-sheaf
   level on each open:
   `G.hom.c.app X ≫ (fst G G).left.c.app (G.hom⁻¹ X)
    = G.hom.c.app X ≫ (snd G G).left.c.app (G.hom⁻¹ X)`.
3. `pullbackPushforwardAdjunction.homEquiv`-transpose this identity
   to obtain the corresponding identity on the
   `φ_G / φ_LHS / ψ` compatibility morphisms.
4. Construct the witness `h : Source ⟶ ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)`
   such that `h ≫ (φ_LHS.app (snd⁻¹X)) = (φ_G.app X) ≫ (ψ.app X)`.
5. Discharge via `Derivation.map_algebraMap` after setting up
   `Algebra C B / Module C (KaehlerDifferential f) / IsScalarTower`
   instances via `g.hom.toAlgebra` (iter-140-validated standalone
   pattern).

**LOC envelope**: ~40–80 LOC chase + ~10 LOC instance discharge
(per task_result and iter-138 mathlib-analogist).

**d_map closure** (Lean L643 inside same): per the iter-138
blueprint recipe + iter-140 negative result on `change`/`whnf`:

1. Apply ψ-naturality from `NatTrans.naturality` (the natural
   transformation `(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`):
   `(ψ.app Y).hom (G.left.presheaf.map f .hom x)
    = (G ⊗ G).left.presheaf.map (snd⁻¹f) .hom ((ψ.app X).hom x)`.
2. Apply Mathlib's
   `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d`
   (verified by iter-140 prover via `lean_loogle`):
   `LHS.map (snd⁻¹f) .hom ((KD φ_LHS_X).d ((ψ.app X).hom x))
    = (KD φ_LHS_Y).d ((G ⊗ G).left.presheaf.map (snd⁻¹f) .hom ((ψ.app X).hom x))`.
3. Bridge `(pushforward ψ).obj LHS .map f = LHS.map (snd⁻¹f)`
   via the `simp` lemmas
   `PresheafOfModules.pushforward_obj_map`,
   `restrictScalars_map_apply`
   (NOT via `change` — iter-140 negative result codified: `change`
   triggers `whnf` timeout on the `(pushforward _).map` carrier).

**LOC envelope**: ~30–60 LOC.

### 3. Iter-141 prover target — per-open IsIso (slot 3, larger LOC)

The IsIso sub-sorry at Lean L689 has post-iter-140 type
`∀ X, IsIso ((basechange_along_proj_two_inv G).app X)`. Closure
per Route (b'2) in `analogies/isiso-basechange-along-proj-two-inv.md`:

1. Build `pullbackObjEquivTensor` helper (~30–60 LOC; shared with
   Route (a); upstream-PR candidate).
2. Build chart-level `Algebra.IsPushout`-from-affine-product
   helper (~80–150 LOC; shared with Route (a); upstream-PR
   candidate; uses `CommRingCat.isPushout_iff_isPushout`,
   `pullbackSpecIso`, `isPullback_SpecMap_of_isPushout`).
3. Apply `tensorKaehlerEquiv_symm_D_tmul` for the value identity
   `D b ↦ 1 ⊗ D b` per-open.

**LOC envelope**: ~160–310 LOC. This is the larger sub-piece;
if the iter-141 LOC budget is tight, consider attempting the
d_app + d_map sub-sorries first (smaller total: ~70–140 LOC) and
defer per-open IsIso to iter-142+.

### 4. Optional — blueprint-writer touch-up on `RigidityKbar.tex:491–504`

Iter-139 NOTE block references the iter-138 `letI := sorry`
pattern; iter-140's structural refactor moved the pattern to
`(fun _ => sorry)` inside `isIso_of_app_iso_module`. The
`sync_leanok` mis-mark concern persists, but the pattern shape
has changed. The iter-141 plan may dispatch a single-shot
blueprint-writer to update the NOTE — low-priority cosmetic only;
defer if iter-141 LOC budget is tight.

## MEDIUM

### 5. Knowledge Base addition (this review session)

Add to PROJECT_STATUS.md Knowledge Base: the iter-140
**`change` succeeds on d_app, fails on d_map** pattern (recorded
in summary.md § "Negative results"). The codified rule: for
nested-functor naturality goals in `Derivation'.mk`-style
constructions, prefer `simp only` with explicit lemma names
over `change` when the goal carries `(pushforward _).map f`-like
opaque `whnf`-blocking terms on either side.

### 6. Blueprint-writer for iter-139 NOTE-block update (already-described)

See §4 above. Low-priority cosmetic.

### 7. `HasAffineCechAcyclicCover` producer instance — track in
deferred-work queue

The lean-auditor flagged this as a structural gap (87-iter
carry-over from iter-053). Not a wrong definition, but the
absence prevents downstream
`Module.Finite k (HModule k (toModuleKSheaf C) 1)` from firing
through the existing `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`
chain. **Currently not on the critical path** for the Phase-C
piece (i.b) work (which uses a different chain to access the
genus carrier); track for the iter-150+ window once piece (i.b)
closes.

## LOW / informational notes

- **`Genus.lean:6`** + **`SheafCompose.lean:7`** wide `import Mathlib`
  style — pure cosmetic.
- **`RigidityKbar.lean:80,86`** underscore-prefixed hypothesis names
  (`_hgenus`, `_hf`, `p`) unused under the current `sorry` body;
  expected, will resolve when `rigidity_over_kbar` is closed.
- **`Algebraic-Lean-Challenge` typo** in `attempts_raw.jsonl` at
  log L101: prover's recovery was immediate; useful breadcrumb
  for the prover-prompt review (the prover briefly mistyped the
  project root path in a `lean_multi_attempt` call).

## Targets — do NOT retry with same approach

- **d_map `change`-based scaffold** — repeating the iter-140 attempt
  with maxHeartbeats raised will not help; the underlying issue
  is that `pushforward = pushforward₀ ∘ restrictScalars` is
  `@[simps]` but not reducible, so `whnf` cannot complete the
  reduction. Use `simp only` with explicit lemma names instead.

- **Iter-138/139/140 progress-critic strict rubric** had iter-140
  in the UNCLEAR-leaning-CONVERGING band, but the strict-arm
  hard gate forces a CHURNING-trigger at iter-141 given the
  iter-140 outcome. The plan agent should NOT silently retry
  another bundled lane on the same three sub-sorries without
  the mid-iter strategy-critic re-dispatch — that is the
  failure pattern the strict rubric exists to prevent.

## Closest-to-completion / prioritization for iter-141

1. **d_app** (smallest LOC, recipe validated standalone, narrow
   chase): highest priority.
2. **d_map** (small LOC, recipe well-documented, requires
   `simp only` discipline): second priority. Could be bundled
   with d_app at the iter-141 prover lane.
3. **Per-open IsIso** (largest LOC, two upstream-PR-candidate
   helpers needed): defer to iter-142+ unless iter-141 LOC budget
   is generous.
4. **Main `mulRight_globalises_cotangent`** composition: blocked
   on Step 2 closure; PASS arm only.

## Iter-141 hard gates committed (per progress-critic-iter140 trigger)

- 0–1 sub-sorries closed AND the iter-140 strategy-critic
  re-dispatch (item 1a) IS done → CHURNING-confirmed; iter-142
  plan must include a route-pivot analyst dispatch.
- 0–1 sub-sorries closed AND the iter-140 strategy-critic
  re-dispatch is NOT done → STUCK + plan agent failure to
  respond to gate.
- ≥2 sub-sorries closed → CONVERGING-restored; back to standard
  progression. Iter-142 PASS arm targets `mulRight_globalises_cotangent`
  main composition.
