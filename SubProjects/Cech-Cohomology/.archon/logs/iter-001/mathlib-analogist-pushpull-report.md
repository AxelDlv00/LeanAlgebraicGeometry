# Mathlib Analogist Report

## Mode
api-alignment

## Slug
pushpull

## Iteration
001

## Question
Does Mathlib already provide the functoriality of `p ↦ p_* p^* F` (or `p ↦ p_* p^*`) for
sheaves of modules on schemes, so we should NOT hand-roll `pushPullMap` / `pushPullMap_comp`?
(1) pseudofunctor→functor straightening for a fixed `F` giving `(Over X)ᵒᵖ ⥤ X.Modules`?
(2) a Mathlib idiom for the cosimplicial object from applying a pseudofunctor to the Čech
nerve, building `CechNerve` from `coverCechNerve` without `G`/`map_comp`? (3) if hand-rolled
is right, is the `pushPullMap` definition shape (two over-triangle `eqToHom` transports) the
problem — would the adjunction-transpose / free-hypothesis route give a `map_comp` provable
by `pseudofunctor_associativity` without the defeq wall?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 — straightening to a fixed-`F` functor exists in Mathlib | NEEDS_MATHLIB_GAP_FILL | informational |
| Q2 — build `CechNerve` from the nerve without `G`/`map_comp` | PROCEED | informational |
| Q3 — `pushPullMap_comp` proof/def shape should align to the mate calculus | ALIGN_WITH_MATHLIB | major |

## Major

- **Q3 — prove `pushPullMap_comp` in the mate/conjugate algebra, not on the pushforward side.**
  Mathlib structures pushforward (right-adjoint) functoriality as the *conjugate* of pullback
  (left-adjoint) functoriality: the pentagon `Scheme.Modules.pseudofunctor_associativity`
  (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`) is stated **only on the pullback side**, and
  `conjugateEquiv_pullbackComp_inv` bridges to pushforward. The composition law of *any*
  right-adjoint-valued contravariant functor is an instance of
  **`CategoryTheory.conjugateEquiv_comp`** (`Mathlib/CategoryTheory/Adjunction/Mates.lean`):
  `conjugateEquiv adj₁ adj₂ α ≫ conjugateEquiv adj₂ adj₃ β = conjugateEquiv adj₁ adj₃ (β ≫ α)`
  — *mate-of-composite = composite-of-mates*, the exact content of `pushPullMap_comp`. Reduced
  via injectivity of the `conjugateEquiv` bijection, it becomes the pullback-side identity that
  IS `pseudofunctor_associativity`, usable as a clean `rw`/`simp` (it never `whnf`-unfolds
  `pullbackComp` into its raw `TwoSquare.equivNatTrans`/`mateEquiv` form — that explosion is the
  documented dead-end, and it only happens because the project is grinding the pentagon on the
  *pushforward* side via `erw`/`congr`).
  This is `major` (not must-fix) because the divergence is in an *unfinished* proof
  (`pushPullMap_comp` is still open), not shipped code — the planner should adopt the mate route
  for the next prover pass rather than refactor a closed proof.

## Informational

- **Q1 — NEEDS_MATHLIB_GAP_FILL.** Mathlib has no pseudofunctor→functor straightening that
  yields the fixed-`F` functor `(Over X)ᵒᵖ ⥤ X.Modules`. The only straightening,
  `CategoryTheory.Pseudofunctor.Grothendieck` / `CoGrothendieck`
  (`Mathlib/CategoryTheory/Bicategory/Grothendieck.lean`), (a) requires the target bicategory to
  be `Cat` while `Scheme.Modules.pseudofunctor` lands in `Adj Cat`, and (b) builds the *total
  fibered category*, not "fix the object, vary the base map". The over-category pushforwards that
  do exist (`CategoryTheory.Over.pullback`, `ExponentiableMorphism.pushforward`) are the
  topos/slice constructions, unrelated to module pushforward. The hand-rolled `G` is genuine
  missing infrastructure, NOT a parallel API — keep building it.

- **Q2 — PROCEED.** The simplicial→cosimplicial passage has clean Mathlib plumbing:
  `coverCechNerve : SimplicialObject.Augmented Scheme` carries its augmentation to `X`, so
  `CategoryTheory.Over.lift` (`Mathlib/CategoryTheory/Comma/Over/Basic.lean`) lifts it to
  `SimplexCategoryᵒᵖ ⥤ Over X`; then `(·).op ⋙ G` is the cosimplicial `X.Modules` object.
  But this composition *consumes* `G` as a genuine `Functor`, i.e. it needs `pushPullMap_comp`.
  No Mathlib route emits the cosimplicial module object from the simplicial scheme while dodging
  functoriality — the obstacle is genuinely on the critical path, confirming the planner's
  "rate-limiter" diagnosis. Do not chase a bypass; invest in Q3.

## Persistent file
- `analogies/pushpull-functoriality.md` — full Mathlib-infrastructure inventory, the
  three-decision analysis, and the concrete mate-route recipe for `pushPullMap_comp`.

Overall verdict: keep the hand-rolled `G` (no Mathlib straightening, and functoriality is
unavoidably on the critical path), but prove `pushPullMap_comp` via the mate calculus
(`conjugateEquiv_comp` + injectivity ⇒ pullback-side `pseudofunctor_associativity`) instead of
grinding the pushforward-side pentagon with `erw` — the project already built the right bridges
(`pushPull_unit_mate`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`); finish that route.
