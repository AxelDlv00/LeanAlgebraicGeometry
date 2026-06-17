# Mathlib Analogist Report

## Mode
api-alignment

## Slug
gmscaling-projection-idiom

## Iteration
184

## Question

Lane B 5-iter CHURNING route: `gmScalingP1_chart_agreement_cross01` body
in `Genus0BaseObjects/GmScaling.lean:382-397`. After
`cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv`, the
cocycle goal lifts to `Spec ((Away (X 0 · X 1)) ⊗ GmRing) ⟶ Proj 𝒜`.
The substantive residual is collapsing `iso.inv ≫ pullback.fst/snd`
through the iso's 7-step `Iso.trans`-chain. 5 iter-183 attempts failed
because chain STEP 4 = `asIso (pullback.map _ _ _ _ (𝟙) (Proj.pullbackAwayιIso _).hom (𝟙) _ _)`
and no Mathlib simp lemma collapses `(asIso (pullback.map …)).inv ≫ pullback.fst/snd`.

The directive asks Q1/Q2/Q3:
- Q1: canonical idiom for `inv (pullback.map _ _ _ _ (𝟙) i₂ (𝟙) _ _) ≫ pullback.fst`?
- Q2: does Mathlib ship a simp lemma firing through outer `pullback.map`/`pullback.congrHom` wraps?
- Q3: canonical "shared intersection chart" definition for the cocycle?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) `pullback.map ≫ pullback.fst/snd` has no Mathlib simp lemma; project must build local helpers | BUILD_PROJECT_HELPER | critical |
| (2) `@[simps]` on iso would NOT help; use explicit named projection lemmas | PROCEED | informational |
| (3) "Shared target" stays `Spec ((Away (X 0 · X 1)) ⊗ GmRing)` — no new tensor-of-algebras | PROCEED | informational |

## Must-fix-this-iter

None — Lane B's existing iso `gmScalingP1_cover_intersection_X_iso`
is correct; only PROJECTION lemmas + ring-level closure need to land
(NEW code, not refactor of shipped code).

## Major

- **Decision 1 BUILD_PROJECT_HELPER**: add two project-side
  `@[reassoc (attr := simp)]` lemmas `pullback_map_fst_proj` /
  `pullback_map_snd_proj` (4 LOC each, body `pullback.lift_fst _ _ _`)
  at the top of `Genus0BaseObjects/GmScaling.lean`. These unblock the
  chain-projection simp recipe that closes Lane B. The lemmas are
  candidates for upstream Mathlib contribution (the absence of
  `@[simp]` on `pullback.lift_fst/snd` is a Mathlib infelicity).

## Answers to Q1/Q2/Q3 (verbatim)

### Q1 answer
**There is NO Mathlib idiom that fires under `simp` for
`inv (pullback.map _ _ _ _ i₁ i₂ i₃ _ _) ≫ pullback.fst _ _`.** The
mathematical content is `pullback.fst _ _ ≫ inv i₁` (since
`pullback.map_isIso` defines the inverse as `pullback.map _ _ _ _ (inv i₁) (inv i₂) (inv i₃)`, and `pullback.map ≫ pullback.fst = pullback.fst ≫ i₁` via `pullback.lift_fst` after `pullback.map` unfolds to `pullback.lift`). But:

- `pullback.map_isIso` is an INSTANCE, not a simp equation.
- `pullback.lift_fst` is `@[reassoc]` ONLY — not `@[simp]`.
- Consequence: `simp` cannot connect the two.

**Two workarounds, both verified at iter-184**:

(a) **Manual `rw` recipe** (closes isolated `asIso (pullback.map …)` step):
```lean
rw [Iso.inv_comp_eq, asIso_hom, pullback.lift_fst, Category.comp_id]
```
Verified `lean_run_code` probe; closes the equation
`(asIso (pullback.map f₁ f₂ f₁ g₂ (𝟙) i₂.hom (𝟙) _ _)).inv ≫ pullback.fst f₁ f₂ = pullback.fst f₁ g₂` axiom-clean.

(b) **Project-side simp helper** (preferred — composes through chains):
```lean
@[reassoc (attr := simp)]
lemma pullback_map_fst_proj {C : Type*} [Category C] {W X Y Z S T : C}
    (f₁ : W ⟶ S) (f₂ : X ⟶ S) [Limits.HasPullback f₁ f₂] (g₁ : Y ⟶ T)
    (g₂ : Z ⟶ T) [Limits.HasPullback g₁ g₂] (i₁ : W ⟶ Y) (i₂ : X ⟶ Z) (i₃ : S ⟶ T)
    (eq₁ : f₁ ≫ i₃ = i₁ ≫ g₁) (eq₂ : f₂ ≫ i₃ = i₂ ≫ g₂) :
    Limits.pullback.map f₁ f₂ g₁ g₂ i₁ i₂ i₃ eq₁ eq₂ ≫
        Limits.pullback.fst g₁ g₂ =
      Limits.pullback.fst f₁ f₂ ≫ i₁ :=
  Limits.pullback.lift_fst _ _ _
```
(plus mirror for `snd`). With these in simp set, the chain simp recipe
fires cleanly. Verified at iter-184 via `lean_run_code` probe 4.

### Q2 answer
**Mathlib does NOT ship a `pullbackAwayιIso_inv_fst_assoc`-style simp
lemma that fires through outer `pullback.map`/`pullback.congrHom`
wraps.** What Mathlib DOES ship at simp severity for the chain:
- `pullback.congrHom_inv` (`@[simp]`) unfolds `congrHom.inv` to `pullback.map`.
- `pullbackRightPullbackFstIso_inv_*`, `pullbackLeftPullbackSndIso_inv_*`,
  `pullbackSymmetry_inv_comp_*`, `Proj.pullbackAwayιIso_inv_fst/_snd`
  are all `@[reassoc (attr := simp)]`.

The gap is exactly `pullback.map ≫ pullback.fst/snd` (which after
`congrHom_inv` unfolds, blocks the chain). Fixing this gap via Recipe 1
(Q1 answer (b)) unblocks all chain projections.

**`@[simps]` on `gmScalingP1_cover_intersection_X_iso` would NOT help**
— `@[simps]` only generates field-projection lemmas at the Iso
structure level (`.hom`, `.inv` field projections), not the chained
`Iso.trans` projections through `≪≫`. The right project response is to
add EXPLICIT named projection lemmas (`gmScalingP1_cover_intersection_X_iso_inv_fst/_snd`)
proven via the simp recipe (Recipe 2 in the persistent file).

### Q3 answer
**The "shared intersection chart" target should stay as the EXISTING
`Spec ((Away (X 0 · X 1)) ⊗ GmRing)`** — no new `Algebra.TensorProduct.map`-
based helper is needed. The cocycle closure reduces to ring-level
equality via `Proj.SpecMap_awayMap_awayι.symm` (factoring `awayι (X i) =
Spec.map (awayMap X_{1-i} rfl) ≫ awayι (X 0 · X 1)`), then `cancel_mono
(awayι (X 0 · X 1))`, then `MvPolynomial.algHom_ext` +
`IsLocalization.Away.mul_invSelf` for the `t · u = 1` residual.

The iter-183 attempt 5's "build `Algebra.TensorProduct.map (awayMapₐ _) (AlgHom.id _)`-based
shared target" route is unnecessary — the `Spec ((Away (X 0 · X 1)) ⊗ GmRing)`
target IS the shared target. The `Algebra.TensorProduct.map` ring
construction shows up only INSIDE the body of the
`gmScalingP1_cover_intersection_X_iso_inv_fst/_snd` lemmas' RHS, where
it's the algebraic content that the simp chain produces (not something
the prover needs to define separately).

## Informational

- Decision 2 PROCEED: `@[simps]` route is the wrong response to Q2.
- Decision 3 PROCEED: shared target is the existing iso codomain.
- The iter-182 task_result's Recipe 2 (intersection-ring-cross01.md L294-328) was correct in
  structure but underspecified the projection step — the new Recipe 2 in
  this consult's persistent file makes the projection step explicit.

## Persistent file
- `analogies/gmscaling-projection-idiom.md` — design-rationale and recipes (Recipes 1-3, including the Q1/Q2/Q3 verbatim answers and empirical probes 1-4).

Overall verdict: Lane B can close iter-184 in ~95-130 LOC across 3 sub-tasks (Recipe 1 simp helpers, Recipe 2 projection lemmas, Recipe 3 cocycle body) — the 5-iter CHURNING was a missing-simp-lemma diagnostic, not a structural strategy failure.
