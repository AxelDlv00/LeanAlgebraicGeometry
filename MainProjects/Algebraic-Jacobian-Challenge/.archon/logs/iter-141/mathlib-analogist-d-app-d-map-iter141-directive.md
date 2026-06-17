# Mathlib analogist directive — d_app + d_map sub-sorry shape (iter-141)

## Standing scope and purpose

The iter-141 strategy-critic + progress-critic + blueprint-reviewer all
converge on dispatching a mathlib-analogist this iter to confirm (or refute)
the shape of the iter-140 prover lane's standalone-validated d_app recipe
**and** to scope the iter-140 NEW blocker phrase
"`(pushforward ψ).obj.map` whnf-opacity at maxHeartbeats=200000" for d_map.

Your task is to render a recipe-shape verdict on these two sub-sorries and
identify the right Mathlib lemma(s) for closure. This is the 5th consult
on piece (i.b) Step 2; per STRATEGY.md L422 narrowed rule, it does NOT
widen the envelope (confirms iter-140 standalone-validated recipe shape and
scopes a new opacity blocker on an existing sub-sorry).

## Project artefacts

- `AlgebraicJacobian/Cotangent/GrpObj.lean:540–625` — iter-140 piece (i.b)
  Step 2 helpers state:
  - `isIso_of_app_iso_module` (L544–L550, private, iso-reflection bridge for `PresheafOfModules`).
  - `basechange_along_proj_two_inv_derivation` (L573–L643) — Route (b) inverse-direction derivation; `d_add` + `d_mul` closed honestly; **`d_app` sub-sorry at L624 + `d_map` sub-sorry at L643 remain**.
  - `basechange_along_proj_two_inv` (L654–L668) — adjunction-transposed inverse map (no internal sorry).
  - `relativeDifferentialsPresheaf_basechange_along_proj_two` (L670–L690) — main piece (i.b) Step 2 iso; iter-140 narrowed IsIso sub-sorry to per-open via `isIso_of_app_iso_module ... (fun _ => sorry)` at L689 (not your scope this iter).

- `task_results/Cotangent_GrpObj.lean.md` — iter-140 prover task result.
  - §"d_app: detailed gap" L68–L108: 5-step closure recipe + standalone-validated `lean_run_code` example (factoring-lemma + `Derivation.map_algebraMap`).
  - §"d_map: detailed gap" L111–L143: 3-step closure recipe + iter-140 `whnf` timeout discovery.

- `blueprint/src/chapters/RigidityKbar.tex` — substantive chapter for piece (i.b) Step 2.
  - d_app NOTE block at L602–L659 (3-step categorical-chase recipe).
  - d_map NOTE block at L661–L708 (ψ-naturality + `relativeDifferentials'_map_d` chase; asserts `((pushforward ψ).obj LHS).map f = LHS.map (snd⁻¹f)` is "definitional/transparent").

- Cross-reference analogies:
  - `analogies/kaehler-tensorequiv-presheafpullback.md` (iter-137) — 5-step universal-property-at-presheaf recipe; envelope ~360–710 LOC for Step 2.
  - `analogies/isiso-basechange-along-proj-two-inv.md` (iter-139) — Route (b'2) IsIso recipe.
  - `analogies/phi-compatibility-morphisms.md` (iter-135) — `Scheme.Hom.toRingCatSheafHom` idiom for `PresheafOfModules.pullback` compatibility morphisms.

## Specific questions

### Question 1: d_app recipe shape

The iter-140 prover lane validated standalone (via `lean_run_code`) a
factoring-lemma pattern:

```
example (A B C : CommRingCat) (f1 : A ⟶ B) (g : C ⟶ B) (k : A ⟶ C)
    (hcomm : k ≫ g = f1) (a : A) :
    (CommRingCat.KaehlerDifferential.D g).d (f1.hom a) = 0 := by
  have heq : f1.hom a = g.hom (k.hom a) := by rw [← hcomm]; rfl
  rw [heq]
  letI : Algebra C B := g.hom.toAlgebra
  letI : Module C (CommRingCat.KaehlerDifferential g) :=
    Module.compHom _ (algebraMap C B)
  letI : IsScalarTower C B (CommRingCat.KaehlerDifferential g) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  exact (CommRingCat.KaehlerDifferential.D g :
    Derivation C B (CommRingCat.KaehlerDifferential g)).map_algebraMap _
```

**Question**: Is this the right shape for closing the d_app sub-sorry
inside `basechange_along_proj_two_inv_derivation` at
`Cotangent/GrpObj.lean:624`?

The d_app sub-sorry's goal (after `change` succeeds at L623) is:
```
(KaehlerDifferential.D φ_LHS_at_(snd⁻¹X)).d ((ψ.app X).hom ((φ_G.app X).hom a)) = 0
```

The factoring witness `h` would have type:
```
h : ((pullback G.hom.base).obj (Spec k).presheaf).obj X ⟶
    ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)
```
with `h ≫ (φ_LHS.app (snd⁻¹X)) = (φ_G.app X) ≫ (ψ.app X)`.

The categorical witness for `h` comes from `(fst G G).w + (snd G G).w` in
`Over (Spec k)` lifted via `LocallyRingedSpace.comp_c_app` and
adjunction-transposed via
`(pullbackPushforwardAdjunction).homEquiv.symm`.

- Confirm or refute: the iter-140 factoring-lemma pattern is the right
  shape for d_app, modulo the categorical-witness construction of `h`.
- Surface any cleaner Mathlib chains that would by-pass the
  `Derivation.map_algebraMap` route (e.g., direct derivation-zero-on-image
  lemmas).
- Estimate LOC for the d_app closure as written: how much is the
  categorical-witness construction of `h` vs. the instance-discharge
  + `map_algebraMap` application?

### Question 2: d_map whnf-opacity scope

The iter-140 prover lane attempted a `change (CommRingCat.KaehlerDifferential.D _).d _ = _`
approach (which worked for d_add/d_mul) but **reverted** it for d_map
because of a deterministic `whnf` timeout at `maxHeartbeats=200000`.

The d_map sub-sorry's goal (after intros `X Y f x`):
```
(KD φ_LHS_at_(snd⁻¹Y)).d ((ψ.app Y).hom (G.left.presheaf.map f .hom x))
= ((pushforward ψ).obj LHS).map f .hom
    ((KD φ_LHS_at_(snd⁻¹X)).d ((ψ.app X).hom x))
```

The blueprint asserts that `((pushforward ψ).obj LHS).map f = LHS.map (snd⁻¹f)`
is "definitional/transparent per
`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:39, 86`"
since `pushforward = pushforward₀ ∘ restrictScalars`. The iter-140 prover
empirically found this **NOT to be the case** at the d_map field
elaboration site — `whnf` times out.

**Question**: What is the right Mathlib idiom for computing
`((pushforward ψ).obj LHS).map f` without invoking `whnf` on the
adjunction-transposed presheaf?

Candidates to investigate (the iter-140 prover did not exhaustively
search these):

- Explicit `PresheafOfModules.pushforward_obj_map` / `pushforward_obj_obj`
  unfolding lemmas in `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward`.
- `PresheafOfModules.pushforward₀.obj.map` direct accessors (since
  `pushforward = pushforward₀ ∘ restrictScalars`).
- Categorical commutation lemmas chaining
  `(NatTrans.naturality)` for ψ with `relativeDifferentials'_map_d`.
- Any `Scheme.Modules.Hom.naturality`-style lemmas.

The iter-137 blocker phrase was "PresheafOfModules.pullback chart-opacity"
and was resolved by the iter-138 helper-pair refactor recipe via inverse-
direction-via-adjunction-transpose (i.e., side-step the opacity
structurally rather than peel it). The iter-140 NEW phrase is opacity on
`pushforward.obj.map` (the same family, dual direction). The iter-138
pattern suggests the right response may be another structural side-step,
not a peeling lemma; but the question is whether a peeling lemma exists.

Render the verdict shape:
- `ALIGN_WITH_BLUEPRINT` — the blueprint's claim of "definitional/transparent"
  IS correct; the iter-140 prover's `whnf` timeout was due to elaboration-
  context noise (e.g., metavariable proliferation in the `Derivation'.mk`
  context); a different proof shape (not `change`, but `simp only [...]`
  with explicit unfolding lemmas) would close.
- `NEEDS_MATHLIB_LEMMA_NAME` — the right Mathlib lemma exists but the
  blueprint did not name it; name it and re-route the recipe.
- `NEEDS_STRUCTURAL_SIDE_STEP` — like the iter-138 helper-pair refactor:
  the recipe needs structural rearrangement to side-step the opacity
  rather than peel it. Name the structural rearrangement.
- `NEEDS_MATHLIB_GAP_FILL` — Mathlib doesn't have a usable computation of
  `(pushforward ψ).obj.map` on the relevant slice; the project must build
  the bridge lemma. Estimate LOC.

### Question 3: combined LOC and follow-on guidance

After your verdict on Questions 1 + 2:

- Estimate total LOC for d_app + d_map closure under your recommended
  recipe shape.
- Does this fit inside the iter-137-renormalised piece (i.b) cumulative
  LOC arm (`1000 LOC without converging`)? Cumulative (i.b)-side build
  entering iter-141 is approximately 485 LOC (iter-134 + iter-136 + iter-138
  + iter-140); your d_app + d_map estimate adds to this.
- Recommend the iter-141 follow-on shape:
  - If `ALIGN_WITH_BLUEPRINT` on Q2 + clean PROCEED on Q1: dispatch
    blueprint-writer to expand the recipes (the (B) follow-on in
    strategy-critic-iter141 terms), then iter-142 prover lane targets
    the d_app + d_map sub-sorries with the validated recipe.
  - If `NEEDS_MATHLIB_LEMMA_NAME`: name the lemma; blueprint-writer
    expands; prover lane iter-142.
  - If `NEEDS_STRUCTURAL_SIDE_STEP`: scope the side-step recipe;
    blueprint-writer expands; prover lane iter-142 or iter-143.
  - If `NEEDS_MATHLIB_GAP_FILL`: the iter-141 plan agent should NOT
    dispatch blueprint-writer; instead reopen the strategic question
    (the iter-138 pattern: structural side-step lasted 3 iters of build).

## What you may NOT read

Do not read `PROGRESS.md`, `STRATEGY.md`, `iter/iter-NNN/plan.md` (any
iter), `task_pending.md`, `task_done.md`, or `proof-journal/`. Your value
is the focused recipe-shape verdict on these two sub-sorries.

Do not engage with the IsIso sub-sorry at L689 (separate scope; iter-141+
target after d_app/d_map closure).

Do not engage with piece (iii) Frobenius scoping (that's a parallel
analogist running this iter).

## Persistent output

Write your full report to `task_results/mathlib-analogist-d-app-d-map-iter141.md`
(the dispatcher wrapper handles the path). Write your persistent analogy
file to `analogies/d-app-d-map-recipe-shape.md` (or update an existing
relevant file if there's no point creating a new one). The analogy file
is the input for the iter-141 blueprint-writer follow-on (the (B) action).
