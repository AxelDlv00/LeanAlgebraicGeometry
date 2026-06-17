# Mathlib Analogist Report

## Mode
api-alignment

## Slug
mate207

## Iteration
207

## Question
Build, project-side, the base-change comparison map
`(pullback φ).obj (A ⊗ B) ⟶ (pullback φ).obj A ⊗ (pullback φ).obj B` as the mate of
`pushforward φ`'s monoidal structure. Specifically: (1) should we build
`Adjunction.leftAdjointOplaxMonoidal` by dualizing `rightAdjointLaxMonoidal`, and is the
dual genuinely absent? (2) construction shape of the oplax δ; (3) is the adjunction +
`pushforward` LaxMonoidal wiring present for the same φ? (4) is there a cheaper concrete
open-immersion restriction route?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A. Build `leftAdjointOplaxMonoidal` dual | ALIGN_WITH_MATHLIB (use existing — do NOT build) | critical |
| B. `(pushforward φ).LaxMonoidal` (the real gap) | NEEDS_MATHLIB_GAP_FILL (small, sectionwise) | informational |
| C. Concrete open-immersion restriction route (Q4) | PROCEED (no shortcut exists or needed) | informational |

## Must-fix-this-iter

- **Decision A — the planner's central proposal is redundant.**
  `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` **already exists** in current
  Mathlib at `Mathlib/CategoryTheory/Monoidal/Functor.lean:1009`:
  ```
  variable {F : C ⥤ D} {G : D ⥤ C} (adj : F ⊣ G) [G.LaxMonoidal]
  def leftAdjointOplaxMonoidal : F.OplaxMonoidal
  ```
  with full coherence proven (lines 1012–1051) plus the `Adjunction.IsMonoidal` instance
  (1053) and `laxMonoidalEquivOplaxMonoidal` (1070). **Do not build a project-side dual.**
  The planner's loogle name-search reported it absent because of loogle name-substring
  behaviour / a rate-limit hit, not absence — `loogle "rightAdjointLaxMonoidal"` finds the
  sibling, and the dual sits 110 lines below it in the same file. Re-deriving it would be a
  parallel API that won't compose with Mathlib's `IsMonoidal`/`laxMonoidalEquivOplaxMonoidal`.

## Informational

- **The construction shape the planner asked about is already realized (Q2).** The oplax
  data Mathlib uses (Functor.lean:1010–1011):
  - `η := (adj.homEquiv _ _).symm (ε G)`
  - `δ X Y := (adj.homEquiv _ _).symm ((adj.unit.app X ⊗ₘ adj.unit.app Y) ≫ μ G _ _)`
  i.e. δ is the mate of `G`'s lax `μ` via unit/counit, exactly as conjectured; the oplax
  axioms follow by the dual diagram chase, already discharged. **The required comparison
  map is `Functor.OplaxMonoidal.δ (F := pullback φ) A B`** once the instance below is in scope.

- **Wiring (Q3): adjunction present, the lax hypothesis is the only gap.**
  `PresheafOfModules.pullbackPushforwardAdjunction φ : pullback φ ⊣ pushforward φ`
  (`.../Presheaf/Pullback.lean:50`) exists for the SAME φ (`pullback φ :=
  (pushforward φ).leftAdjoint`, Pullback.lean:44) — no reindexing mismatch. BUT
  `[(pushforward φ).LaxMonoidal]` is NOT shipped: `pushforward φ := pushforward₀ F R ⋙
  restrictScalars φ` (Pushforward.lean:86), and Mathlib's monoidal instance covers only the
  first factor — `(pushforward₀OfCommRingCat F R).Monoidal`
  (`.../PushforwardZeroMonoidal.lean:33`). The `restrictScalars φ` factor has no
  presheaf-level lax instance.

- **The real project-side obligation (Decision B) is one small sectionwise instance:**
  `(PresheafOfModules.restrictScalars φ).LaxMonoidal`. This is a sectionwise lift of the
  EXISTING `ModuleCat.restrictScalars f` LaxMonoidal lemma
  (`Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean:102`, itself built as
  `(extendRestrictScalarsAdj f).rightAdjointLaxMonoidal` — Mathlib uses the same mate idiom
  one level down). Presheaf tensor is sectionwise (`(M₁⊗M₂).obj X = M₁.obj X ⊗ M₂.obj X`,
  Presheaf/Monoidal.lean:46–81) and presheaf `restrictScalars φ` is sectionwise
  `ModuleCat.restrictScalars (φ.app X)`, so assemble a `Functor.CoreLaxMonoidal` from the
  per-section ModuleCat data + naturality. Then `Functor.LaxMonoidal.comp` (Functor.lean:221)
  + `Functor.Monoidal.toLaxMonoidal` on `pushforward₀` give
  `(pushforward₀ ⋙ restrictScalars φ).LaxMonoidal`, and a `CoreLaxMonoidal`/`inferInstanceAs`
  transport across the `pushforward` def yields `(pushforward φ).LaxMonoidal`. **Setup
  constraint:** state everything over CommRingCat-factored presheaves of rings
  (`R ⋙ forget₂ _ _`, Presheaf/Monoidal.lean:30) with φ a morphism of presheaves of
  commutative rings — satisfied by `(Scheme.Hom.toRingCatSheafHom f).hom`.
  Envelope: ~40–90 LOC (lax instance) + ~10 LOC plumbing.

- **Q4 — no concrete open-immersion shortcut.** No `SheafOfModules` pullback/monoidal file
  and no `IsOpenImmersion`-keyed monoidal restriction in `Algebra/Category/ModuleCat`;
  restriction to an open still goes through the abstract `PresheafOfModules.pullback`. With
  `leftAdjointOplaxMonoidal` already present, the abstract route is cheap (one sectionwise
  instance away), so special-casing open immersions buys nothing.

## Persistent file
- `analogies/mate207.md` — design rationale + recipe captured for future iters.

Overall verdict: do NOT build the dual mate lemma — `Adjunction.leftAdjointOplaxMonoidal`
already ships in Mathlib (Functor.lean:1009); the comparison map is its `δ`, and the sole
project-side gap is the small sectionwise instance `(PresheafOfModules.restrictScalars φ).LaxMonoidal`.
</content>
