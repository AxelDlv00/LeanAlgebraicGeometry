# Picard/TensorObjSubstrate.lean — iter-248 fine-grained pass (D2′ η-bridge telescope)

Mode: **fine-grained**. Goal: atomize the D2′ unit-square telescope into named per-sentence
lemmas and close them one at a time. HARD closure bar: **≥1 ★ atomic step-lemma closed
axiom-clean**. **Result: 2 of 3 ★ steps closed axiom-clean + the central defeq linchpin
discovered and pinned + assembly transposition landed + D2′ closer fully wired.**

## Blueprint sentences → Lean lemmas

### ★ Step 3 — `lem:comp_homequiv_factor_sheafify_pullback` → `compHomEquivFactor`
- **Type:** general — for composable `adj₁ : L₁ ⊣ R₁`, `adj₂ : L₂ ⊣ R₂`,
  `(adj₁.comp adj₂).homEquiv g = adj₁.homEquiv (adj₂.homEquiv g)`.
- **Result: RESOLVED — axiom-clean** (`propext, Classical.choice, Quot.sound` only).
- Proof: `simp only [Adjunction.homEquiv_unit, Adjunction.comp_unit_app, Functor.comp_map,
  Functor.map_comp]; exact Category.assoc _ _ _`. (`Adjunction.comp_homEquiv` does NOT exist in
  Mathlib; the factorisation is derived from the `homEquiv = unit ≫ R.map` formula +
  `comp_unit_app`.) The prover-flagged uncertainty ("verify `Adjunction.comp … homEquiv` form
  first") is **resolved**: there is no direct `comp_homEquiv` lemma, but the unit-based proof closes.

### LINCHPIN (not separately pinned in blueprint) → `sheafificationCompPullback_eq_leftAdjointUniq`
- **Type:** `SheafOfModules.sheafificationCompPullback φ = A.leftAdjointUniq B`, where
  `A = (sheafificationAdjunction 𝟙_X).comp (SheafOfModules.pullbackPushforwardAdjunction φ)` and
  `B = (PresheafOfModules.pullbackPushforwardAdjunction φ').comp (sheafificationAdjunction 𝟙_Y)`.
- **Result: RESOLVED — axiom-clean, by `rfl`.**
- **This is the key unblock of the whole route.** The blueprint asserts this identity; it had never
  been confirmed in Lean and was the prover's named "3-layer adjunction defeq wall". It holds
  **definitionally**: (i) `A.leftAdjointUniq B` typechecks (so A and B have a defeq-equal right
  adjoint — `pushforward φ ⋙ forget_X` ≡ `forget_Y ⋙ pushforward φ'`), and (ii) the comparison is
  `rfl`-equal to `sheafificationCompPullback φ`. With this, every `homEquiv_leftAdjointUniq` mate
  identity fires for the concrete unit-square adjunctions. **Recommend the planner add a blueprint
  block for this** (it is load-bearing and reusable; it is what makes step 4 mechanical).

### ★ Step 4 — `lem:leftadjointuniq_app_unit_eta` → `leftAdjointUniqUnitEta`
- **Type:** `A.homEquiv ((sheafificationCompPullback φ).hom.app 𝟙ᵖ)
  = presheafAdj.unit.app 𝟙ᵖ ≫ (pushforward φ').map (sheafAdj_Y.unit.app (F.obj 𝟙ᵖ))`.
- **Result: RESOLVED — axiom-clean.**
- Proof: rewrite `(sheafificationCompPullback φ).hom.app 𝟙ᵖ = (A.leftAdjointUniq B).hom.app 𝟙ᵖ`
  (by `rfl`, the linchpin), then `refine Eq.trans (Adjunction.homEquiv_leftAdjointUniq_hom_app A B
  𝟙ᵖ) ?_` (defeq-unifies the `.obj`/`.val` mismatch that blocked a direct `rw`), then
  `rw [hB, Adjunction.comp_unit_app]; rfl`.

### Step 6 — `lem:presheaf_unit_comp_map_eta` → `presheafUnit_comp_map_eta`
- **Result: PRE-EXISTING, axiom-clean** (landed iter-247, reused — not rebuilt). ~L1495.

### IsIso plumbing — `lem:isiso_sheafifyeta_of_unitsquare` → `isIso_sheafifyEta_of_unitSquare`
- **Result: PRE-EXISTING, axiom-clean** (landed, reused). ~L1518.

### ★ Step 7 — `lem:epsilon_presheaf_to_sheaf_unit` → `epsilonPresheafToSheafUnit`
- **Result: NOT CREATED — blueprint statement does not typecheck as written.**
- **Blocker (precise):** the blueprint writes `ε(pushforward φ) = unitToPushforwardObjUnit φ` at the
  **sheaf** level, but **there is no `Functor.LaxMonoidal` instance on `SheafOfModules.pushforward φ`
  in Mathlib at the pin** (confirmed by loogle: only the *presheaf* `presheafPushforwardLaxMonoidal`
  exists, on `PresheafOfModules.pushforward φ'`). So `Functor.LaxMonoidal.ε (SheafOfModules.pushforward φ)`
  is ill-typed. The genuine content is a **presheaf↔sheaf `.val`-level identity** reconciling the
  presheaf `ε (pushforward φ')` with the sheaf `unitToPushforwardObjUnit φ` (whose value is
  `unitToPushforwardObjUnit_val_app_apply : (…).val.app X a = φ.hom.app X a`). Its exact Lean type
  is best pinned **from inside the (∗∗) subgoal** of the assembly (see below) once steps 1–6 have
  been driven there. **Planner action:** rewrite the blueprint block to state a `.val`/sheafification
  identity, not a sheaf-monoidal `ε`.

### Assembly — `lem:eta_bridge_unit_square` → `pullbackEtaUnitSquare`
- **Type:** the unit square `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η F) ≫ sheafifyUnitIso.hom
  = pullbackObjUnitToUnit φ` (matches `isIso_sheafifyEta_of_unitSquare`'s `hsq`).
- **Result: PARTIAL — transposition + step 1 landed; single scoped `sorry` at the (∗∗) core.**
- Landed in the body (typechecks):
  1. `apply ((pullbackPushforwardAdjunction φ).homEquiv 𝒪_X 𝒪_Y).injective` — transpose across the
     **sheaf** adjunction.
  2. `rw [SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit]` — RHS image
     becomes `unitToPushforwardObjUnit φ` (Mathlib mate identity).
  3. `rw [Adjunction.homEquiv_unit]` — reaches the **canonical (∗∗)** form
     `sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map m = unitToPushforwardObjUnit φ`,
     `m = pullbackValIso.inv ≫ a_Y.map (η F) ≫ sheafifyUnitIso.hom`.
- **Remaining (the one `sorry`, with handoff in-code):** distribute `(pushforward φ).map` over `m`,
  pull `pullbackValIso.inv` past the unit via `Adjunction.unit_naturality` (step 2), apply
  `compHomEquivFactor` (step 3, CLOSED) + `leftAdjointUniqUnitEta` (step 4, CLOSED) to reach the
  presheaf head `presheafAdj.unit.app 𝟙ᵖ ≫ (pushforward φ').map (η F)`, rewrite to `ε (pushforward φ')`
  via `presheafUnit_comp_map_eta` (step 6, CLOSED), then the step-7 `.val`-level reconciliation above.
  **All the abstract adjunction lemmas it needs are now closed; the residual is the counit/sheafify
  bookkeeping (steps 2,5) + the step-7 retyping.**

### D2′ closer — `lem:pullback_tensor_iso_unit` → `pullbackTensorMap_unit_isIso`
- **Type:** `IsIso (pullbackTensorMap f 𝒪_X 𝒪_X)`.
- **Result: FULLY WIRED — compiles, depends only on the assembly's single `sorry`.**
- Proof: `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta f
  (isIso_sheafifyEta_of_unitSquare f (pullbackEtaUnitSquare f))`. This decl did **not exist** before;
  the entire D2′ obligation is now reduced to the one (∗∗) residual.

## Summary
- **★ steps closed axiom-clean: 2 / 3** (`compHomEquivFactor`, `leftAdjointUniqUnitEta`) — **HARD bar
  (≥1) exceeded.** 3rd ★ (`epsilonPresheafToSheafUnit`) is mis-typed in the blueprint (no sheaf
  LaxMonoidal instance); reported precisely, deferred pending a blueprint retype.
- **Bonus axiom-clean closure:** `sheafificationCompPullback_eq_leftAdjointUniq` — the `rfl` linchpin
  that resolves the prover's 5-iter "3-layer defeq wall".
- **New decls created:** `compHomEquivFactor`, `sheafificationCompPullback_eq_leftAdjointUniq`,
  `leftAdjointUniqUnitEta` (all axiom-clean), `pullbackEtaUnitSquare` (1 sorry), and
  `pullbackTensorMap_unit_isIso` (D2′ closer, fully wired).
- **Sorry count (file): 1 → 2.** Pre-existing `exists_tensorObj_inverse` (L670, guardrail — untouched).
  New: the single (∗∗) core inside `pullbackEtaUnitSquare`. Net: the **entire D2′ critical path** now
  bottoms out in **one** concrete residual (down from a fully-open 3-layer telescope), with 2 ★ steps
  + the linchpin + the IsIso plumbing + the D2′ closer all in place.
- File compiles, 0 errors. Only warnings: deprecated `Sheaf.val` (project-wide, deferred polish).

## `\leanok` flags for the review agent (sync_leanok handles markers)
Ready (axiom-clean, no sorry): `lem:comp_homequiv_factor_sheafify_pullback`,
`lem:leftadjointuniq_app_unit_eta`. NOT ready (carry/produce sorry): `lem:eta_bridge_unit_square`
(∗∗ residual), `lem:pullback_tensor_iso_unit` (depends on it). New unpinned linchpin
`sheafificationCompPullback_eq_leftAdjointUniq` — suggest the planner add a blueprint block.

## Why I stopped
**Real progress (genuine critical-path sorry-elimination, the metric flat for 5 iters):**
- 2/3 ★ steps closed axiom-clean + the `rfl` linchpin that was the documented blocker.
- The route is **no longer STUCK**: the abstract 3-layer adjunction mate-calculus is fully discharged
  (steps 3,4 + linchpin), the assembly is transposed to the canonical (∗∗) identity, and D2′ is wired
  to depend on exactly one residual.

**Partial progress:** `pullbackEtaUnitSquare` — transposition + step 1 landed; the (∗∗) residual is
the counit/sheafify bookkeeping (steps 2,5,6 reuse) + the step-7 retyping. Specific remaining goal
(in-code, see L~1656): `sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map (pullbackValIso.inv ≫
a_Y.map (η F) ≫ sheafifyUnitIso.hom) = unitToPushforwardObjUnit φ`.

**Approaches written but not attempted:** none — every comment names a lemma that is either CLOSED
this iter or whose blocker is stated precisely (step-7 retype).

**Blueprint correction needed:** `lem:epsilon_presheaf_to_sheaf_unit` must be restated as a
presheaf↔sheaf `.val`-level identity (no sheaf-level `Functor.LaxMonoidal.ε`). Recommend a
follow-up `prove` pass targeting `pullbackEtaUnitSquare`'s (∗∗) core with directive to (a) pin the
step-7 `.val` identity from the live subgoal, (b) finish steps 2/5/6 with the now-closed step-lemmas.
```
