# AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Summary
- **Declarations added: 1** — `AlgebraicGeometry.pushPull_transport_cancel` (axiom-clean,
  `[propext, Classical.choice, Quot.sound]`, verified with `lean_verify`). Located right after
  `pushPull_unit_mate`.
- **Declarations blocked: 0 in-file** — `pushPullMap_comp` is NOT a declaration (still an in-file
  comment, as before); I did not add it (would require a `sorry`, forbidden). No regression.
- **sorry count (this file): 4 → 4** (all pre-existing: `CechNerve` L89, `CechAcyclic.affine`,
  `cech_computes_higherDirectImage`, `cech_flatBaseChange`). My lemma adds **no** sorry.
- **In-file comment updated** (the `pushPullMap_comp` block) to record the iter-271 breakthrough and
  the precise remaining route.

## Why I stopped
**Real progress** — the planner's **Bar is fully met and exceeded**:
1. **`pushPull_transport_cancel` landed axiom-clean** (the option-(b) generalized cancellation lemma).
2. **Option-(b) is CONFIRMED sufficient — the kernel `whnf` wall is bypassed** (the decisive question
   that decides option-a escalation: **no escalation needed**).
3. **`pushPullMap_comp` fully reduced to a clean, kernel-issue-free pentagon**, with the exact closing
   route identified and verified to fit.

The only thing not done is the final ~60–100 LOC whiskered-pentagon coherence grind, which is now a
well-scoped mechanical follow-up (the kernel obstacle that blocked 5 prior iterations is gone).

## `pushPull_transport_cancel` (added, axiom-clean)
- **Statement:** for `gl : Y₂ ⟶ Y₁`, `p₁ : Y₁ ⟶ X`, `p₂ : Y₂ ⟶ X`, free hypothesis `h : gl ≫ p₁ = p₂`,
  ```
  eqToHom (congrArg (fun q => (pushforward q).obj (pullback gl (pullback p₁ F))) h) ≫
    (pushforward p₂).map ((pullbackComp gl p₁).hom.app F) ≫
    eqToHom (congrArg (fun q => (pushforward p₂).obj (pullback q F)) h)
  = (pushforward (gl ≫ p₁)).map ((pullbackComp gl p₁).hom.app F) ≫
    eqToHom (congrArg (fun q => (pushforward q).obj (pullback q F)) h)
  ```
- **Approach:** `subst h; simp`. Because `h` is a *free* hypothesis (not the specific `Over.w g`),
  `subst` collapses both transports to `eqToHom rfl = 𝟙` on **abstract** objects — kernel-cheap.
- **Result:** RESOLVED, axiom-clean.

## `pushPullMap_comp` (NOT added — clean reduction + route established)
- **Decisive experiment (the planner's key question — ANSWERED):** in the actual comp goal,
  `erw [pushPull_transport_cancel (k≫g).left Y₁.hom Y₃.hom (Over.w (k≫g)) F]` **fires and the kernel
  does NOT blow up**. Applying it to all three `pushPullMap` occurrences (LHS once, RHS twice) leaves
  both sides transport-light. **`rw` does not fire** (SheafOfModules comps are defeq-not-syntactic) —
  **`erw` is mandatory**. So **option-(b) suffices; option-(a) (refactoring `pushPullMap`
  transport-light) is NOT needed.**
- **Key structural finding:** `Scheme.Modules.pushforwardComp` is `Iso.refl` (pushforward is *strictly*
  functorial), so its comparison factor is `𝟙` and is absorbed by the same `erw`.
  `pullbackComp` is its conjugate-mate (`leftAdjointCompIso`), so the genuine content is the pullback
  pseudofunctor pentagon. Both `pushforward (a≫b) = pushforward a ⋙ pushforward b` and
  `(pushforward (a≫b)).map φ = (pushforward b).map ((pushforward a).map φ)` hold by **`rfl`**.
- **Reduction (verified in scratch):** the comp proof skeleton is
  ```
  conv_lhs => rw [pushPullMap]
  erw [pushPull_transport_cancel (k≫g).left Y₁.hom Y₃.hom (Over.w (k≫g)) F]
  conv_rhs => rw [pushPullMap, pushPullMap]
  erw [pushPull_transport_cancel g.left Y₁.hom Y₂.hom (Over.w g) F,
       pushPull_transport_cancel k.left Y₂.hom Y₃.hom (Over.w k) F]
  -- (then: simp only [Over.comp_left] to expose k.left ≫ g.left, and apply the aux lemma below)
  ```
- **The remaining nugget = `pushPullMap_comp_aux`** (a generalized post-`erw` lemma, mirror of
  `pushPull_transport_cancel`'s free-hypothesis trick — verified to typecheck in scratch):
  ```
  lemma pushPullMap_comp_aux {Y₁ Y₂ Y₃ : Scheme} (gl₂ : Y₂ ⟶ Y₁) (kl : Y₃ ⟶ Y₂)
      (p₁ : Y₁ ⟶ X) (p₂ : Y₂ ⟶ X) (p₃ : Y₃ ⟶ X)
      (hg : gl₂ ≫ p₁ = p₂) (hk : kl ≫ p₂ = p₃) (hkg : (kl ≫ gl₂) ≫ p₁ = p₃) (F : X.Modules) :
    [LHS transport-light G'(k≫g)] = [RHS transport-light G'(g) ≫ G'(k)]
  ```
  Proving it: `subst hg hk; simp only [eqToHom_refl, Category.comp_id]` clears all transports except
  **one** residual `eqToHom ((kl≫gl₂)≫p₁ = kl≫(gl₂≫p₁))` (the associativity / pentagon cell). The
  resulting goal is the **pure pseudofunctor pentagon** (no kernel issues), which closes by:
  - `pushPull_unit_mate kl gl₂` — converts the composite unit `η^{kl≫gl₂}` into iterated units, and
  - `Scheme.Modules.pseudofunctor_associativity (f := kl) (g := gl₂) (h := p₁)` — whose **four**
    `pullbackComp` 2-cells (`pullbackComp kl (gl₂≫p₁)`, `pullbackComp gl₂ p₁`, `pullbackComp kl gl₂`,
    `pullbackComp (kl≫gl₂) p₁`) match **exactly** the four cells appearing in the goal.
- **Remaining friction (the only thing left):** the whiskered-pentagon + `eqToHom` bookkeeping —
  combining factors under `(pushforward p₁).map` via `erw [← Functor.map_comp]` and threading the
  associativity cell. This is the standard defeq-not-syntactic `erw` grind (~60–100 LOC). Naïve
  `rw [← Functor.map_comp]` fails with *motive-not-type-correct* due to the dependent `eqToHom(hkg)`;
  use `conv`/`erw` and handle the assoc cell explicitly (it is `(pushforward p₁ ⋙ pushforward gl₂ ⋙
  pushforward kl).map` of a pullback-level `eqToHom`, by the `rfl` decompositions above).

## Dead ends (do not retry)
- **Sectionwise `Scheme.Modules.hom_ext; intro U`**: decomposes but exposes the non-sectionwise-trivial
  adjunction units — dead (consistent with the `pushPullMap_id` experience).
- **`simp` / `aesop_cat` on the post-subst pentagon**: only reassociates; cannot combine cross-functor
  factors or apply the mate (the units are not pure coherence). Curated
  `simp only [pushforwardComp, Iso.refl_hom, …, pushPull_unit_mate]` leaves the goal unchanged.
- **`rw` (not `erw`) of `pushPull_transport_cancel`**: never fires (defeq-not-syntactic comps).

## Blueprint markers
- `def:push_pull_map` (`pushPullMap`) and the `pushPull_unit_mate` core are unchanged.
- `lem:push_pull_functor` pins both `pushPullMap_id` (DONE) and `pushPullMap_comp` (still open). The
  `% NOTE (iter-264)` in `Cohomology_CechHigherDirectImage.tex` already flags that the statement-block
  `\leanok` over-states the lemma (only `pushPullMap_id` exists). No new declaration is ready for a
  marker this iteration. `pushPull_transport_cancel` is a new project-local supplement brick (no
  blueprint environment of its own — it is infrastructure for the deferred `pushPullMap_comp`).

## Recommendation for next iter
The lane is **de-risked**: dispatch a focused prover pass to close `pushPullMap_comp_aux` via the
documented mate + `pseudofunctor_associativity (f:=kl,g:=gl₂,h:=p₁)` route, then derive
`pushPullMap_comp` from it via the `erw [pushPull_transport_cancel …]` skeleton above, then assemble
`pushPullFunctor` and close `CechNerve`. Option-(a) escalation is **unnecessary** (option-(b)
confirmed sufficient).
