# Mathlib Analogist Report

## Slug

d-app-d-map-iter141

## Iteration

141

## Question (verbatim)

Two pieces, one for each remaining sub-sorry inside
`basechange_along_proj_two_inv_derivation`
(`AlgebraicJacobian/Cotangent/GrpObj.lean:573–643`):

1. **d_app**: Is the iter-140 standalone-validated factoring-lemma pattern
   the right shape for closing the `d_app` sub-sorry at
   `Cotangent/GrpObj.lean:624`?

2. **d_map**: What is the right Mathlib idiom for computing
   `((pushforward ψ).obj LHS).map f` without invoking `whnf` on the
   adjunction-transposed presheaf? (The iter-140 prover hit a
   deterministic `whnf` timeout at `maxHeartbeats=200000` via `change`.)

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: d_app closure shape | PROCEED (streamline via `d_map`) | informational |
| 2: Factoring witness for d_app (categorical chase) | NEEDS_MATHLIB_GAP_FILL | informational |
| 3: d_map unfolding lemma — **the missing name** | **NEEDS_MATHLIB_LEMMA_NAME** | major |
| 4: d_map closure shape (after Decision 3 fix) | ALIGN_WITH_MATHLIB | major |
| 5: LOC envelope (combined ~80–140 LOC) | PROCEED | informational |

## Must-fix-this-iter

None — both sub-sorries are still scaffolded as `sorry`-bodied, so there
is no shipped divergent code to refactor. The d_map fix (Decision 3) is
a *recipe correction* before the iter-142 prover lane attempts closure,
not a retroactive code refactor.

## Major

- **Decision 3 (d_map unfolding lemma name)**: The blueprint's claim of
  "definitional/transparent per
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:39, 86`"
  (`RigidityKbar.tex:702–708`) is technically correct *at the underlying
  `LinearMap`-application level* — `(((pushforward φ).obj M).map f).hom m
  = M.map (F.map f.unop).op m` is `rfl` (verified standalone this iter
  via `lean_run_code`). **But** `pushforward₀_obj` and `pushforward₀`
  are annotated with `set_option backward.isDefEq.respectTransparency
  false in` at `Pushforward.lean:37, 55`. This **explicitly disables**
  the `isDefEq` / `whnf`-based unfolding the iter-140 prover's `change`
  approach relied on. The right Mathlib lemma exists and is named:
  `PresheafOfModules.pushforward_obj_map_apply'` (`@[simp]`-normal form
  at `Pushforward.lean:99–106`) — use `simp only
  [pushforward_obj_map_apply']` rather than `change` to perform the
  unfolding without paying the `whnf` cost. The blueprint pointed to
  the right file but did not name the lemma; the iter-140 prover did
  not search for the named lemma and relied on transparency that
  Mathlib explicitly disables.

- **Decision 4 (d_map closure shape)**: After Decision 3's fix, the
  d_map closure is a three-step ALIGN_WITH_MATHLIB chase:
  (1) `simp only [pushforward_obj_map_apply']` for RHS unfolding;
  (2) `NatTrans.naturality` for ψ (the `(toRingCatSheafHom (snd G G).left).hom`
  natural transformation, which is `(snd G G).left.c` whiskered with
  `forget₂` per `Mathlib.AlgebraicGeometry.Modules.Presheaf:42–45`);
  (3) `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d`
  (`Presheaf.lean:201–207`) for the universal Kähler derivation
  commutation. All three are Mathlib-canonical names.

## Informational

- **Decision 1 (d_app closure shape)**: The iter-140 standalone-validated
  factoring-lemma recipe is correct in shape. Recommend streamlining the
  algebra-side discharge by using `ModuleCat.Derivation.d_map`
  (`Mathlib.Algebra.Category.ModuleCat.Differentials.Basic:80`) directly
  instead of the iter-140 `letI : Algebra ... ; letI : Module ... ; letI
  : IsScalarTower ... ; exact (D : Derivation ...).map_algebraMap _`
  chain. The `d_map` lemma packages exactly this instance-discharge +
  `map_algebraMap` call. Verified standalone this iter:
  ```lean
  example (A B C : CommRingCat) (f1 : A ⟶ B) (g : C ⟶ B) (k : A ⟶ C)
      (hcomm : k ≫ g = f1) (a : A) :
      (CommRingCat.KaehlerDifferential.D g).d (f1.hom a) = 0 := by
    rw [show f1.hom a = g.hom (k.hom a) from by rw [← hcomm]; rfl]
    exact (CommRingCat.KaehlerDifferential.D g).d_map _
  ```
  Saves ~4 LOC per call site; clearer intent.

- **Decision 2 (d_app factoring witness)**: `NEEDS_MATHLIB_GAP_FILL`.
  The witness `h : Source ⟶ Target` factoring `(ψ.app X) ∘ (φ_G.app X)`
  through `φ_LHS.app (snd⁻¹X)` requires bespoke chase of
  `(fst G G).w + (snd G G).w` via `LocallyRingedSpace.comp_c_app`
  + `pullbackPushforwardAdjunction.homEquiv.symm`. Each ingredient is
  Mathlib-canonical; no one-shot combiner exists. LOC estimate
  ~40–80 LOC (load-bearing for d_app closure).

- **Decision 5 (LOC envelope)**: Combined d_app + d_map ≈ 80–140 LOC
  (50–90 for d_app; 30–50 for d_map). Cumulative piece (i.b) build at
  iter-141 entry ≈ 485 LOC; adding 80–140 yields ~565–625 LOC, well
  inside the iter-137 renormalised 1000 LOC envelope arm. **No
  envelope-widening required.**

## Iter-141 follow-on recommendation

**Dispatch blueprint-writer this iter (the (B) follow-on per
strategy-critic-iter141)** with three specific updates to
`RigidityKbar.tex`:

1. **d_app NOTE block (`RigidityKbar.tex:602–659`)**: add an
   "Implementation note" naming `ModuleCat.Derivation.d_map`
   (Basic.lean:80) as the algebra-side closing lemma, replacing the
   `letI + Derivation.map_algebraMap` chain.

2. **d_map NOTE block (`RigidityKbar.tex:661–708`)**: replace the
   "definitional/transparent" claim at L702–708 with:
   > "the unfolding is provided by the explicit `@[simp]`-tagged
   > lemma `PresheafOfModules.pushforward_obj_map_apply'`
   > (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:99–106`);
   > use `simp only [pushforward_obj_map_apply']` rather than `change`,
   > because `pushforward₀` is annotated
   > `set_option backward.isDefEq.respectTransparency false in`
   > (`Pushforward.lean:37, 55`) and `whnf`-based tactics cannot punch
   > through."

3. **Add a negative-lesson NOTE** under the d_map block citing the
   iter-140 prover's `whnf`-timeout discovery (codify in
   `RigidityKbar.tex` rather than letting it linger only in
   `task_results/`), so future iters do not repeat the `change`-first
   approach on `pushforward`-transposed goals.

**Iter-142 prover lane** then targets the d_app + d_map sub-sorries
with the validated recipes. The IsIso per-open sub-sorry at
`Cotangent/GrpObj.lean:689` remains a separate iter-141+/142 target
(out of scope this iter per directive).

**Do NOT** dispatch a structural-side-step refactor (the iter-138
helper-pair pattern). The opacity here is locally resolvable by named-
lemma application; no structural rearrangement of
`basechange_along_proj_two_inv_derivation` is needed.

## Persistent file

- `analogies/d-app-d-map-recipe-shape.md` — full design-rationale
  capture: 5 decisions analyzed, the missing-name discovery, the
  streamlined d_app pattern (verified via `lean_run_code` this iter),
  the d_map three-step chase recipe, and the LOC envelope check.

## Overall verdict

**PROCEED with d_app shape (1 informational streamlining) + ALIGN
d_map closure via the named lemma `pushforward_obj_map_apply'`
(`Pushforward.lean:99–106`).** Combined LOC ~80–140; fits inside the
piece (i.b) 1000 LOC envelope. Iter-141 (B) follow-on: dispatch
blueprint-writer to update the two NOTE blocks; iter-142 prover lane
closes both sub-sorries with the validated recipes.
