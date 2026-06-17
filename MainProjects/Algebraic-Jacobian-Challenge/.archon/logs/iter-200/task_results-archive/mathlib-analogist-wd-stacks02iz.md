# Mathlib Analogist Report

## Mode
api-alignment

## Slug
wd-stacks02iz

## Iteration
200

## Question

For Lane WD-A4a-Sub-build-1: build, axiom-clean, the open-immersion
stalk-bridge for prime divisors (Stacks 02IZ / 005X). Given integral
locally Noetherian `X`, open `U ⊆ X`, and `Y : X.PrimeDivisor` with
`Y.point ∈ U`, produce `Y_U : (↑U).PrimeDivisor` with the underlying
point lifting via `Subtype.val : ↥U → X`. The directive estimates
~150-250 LOC; assess whether Mathlib substrate is sufficient and
propose a concrete recipe.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: Mathlib's open-immersion stalk iso (Stacks 02IZ stalk side) | PROCEED — `Scheme.Opens.stalkIso` is drop-in | informational |
| 2: Topological coheight transfer across open subspace | ALIGN_WITH_EXISTING_PROJECT_INFRASTRUCTURE | **critical** |
| 3: Stacks 005X (coheight ↔ Krull dim of stalk) for schemes | ALIGN_WITH_EXISTING_PROJECT_INFRASTRUCTURE | **critical** |
| 4: Prime-divisor pushforward `i_*` for open immersions | NEEDS_PROJECT_BUILD — small (~20-40 LOC) | major |
| 5: `Ring.ordFrac` naturality across stalk iso (Sub-build 2 preview) | NEEDS_MATHLIB_GAP_FILL — out of Sub-build 1 scope | informational |

## Must-fix-this-iter

- **Decision 2 + 3 (CRITICAL)**: The project already ships
  `AlgebraicJacobian/Albanese/CoheightBridge.lean` (237 LOC,
  axiom-clean, landed iter-183), providing both
  `Order.coheight_eq_of_isOpenEmbedding` (the topological coheight
  transfer = Stacks 02IZ topological side) and
  `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight` (Stacks
  005X for schemes). **`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
  does NOT import this file**, and the iter-200 directive +
  PROGRESS.md treat both bridges as un-built Mathlib gaps. The
  corrective is informational + structural:

  1. Add `import AlgebraicJacobian.Albanese.CoheightBridge` to
     `WeilDivisor.lean`.
  2. Update the iter-200 prover directive to reference the existing
     `Order.coheight_eq_of_isOpenEmbedding` /
     `Scheme.ringKrullDim_stalk_eq_coheight` /
     `Scheme.ringKrullDimLE_of_coheight_eq_one` decls instead of
     re-describing them as "Mathlib substrate partially absent".

  Concrete cost of NOT correcting: the prover lane re-derives the
  ~100-200 LOC bridge from scratch in `WeilDivisor.lean`, duplicating
  the iter-183 substrate. The progress-critic CHURNING diagnosis
  (8 helpers added, 0 sorries closed in 2 active iters) is consistent
  with the prover groping for a bridge whose existence was elided.

## Major

- **Decision 4**: Build the prime-divisor open-immersion bijection
  thinly on top of the existing CoheightBridge. Recipe:

  ```lean
  -- in WeilDivisor.lean, after the new import

  def Scheme.PrimeDivisor.restrictToOpen
      {X : Scheme.{u}} (U : X.Opens)
      (Y : X.PrimeDivisor) (hYU : Y.point ∈ U) :
      U.toScheme.PrimeDivisor where
    point := ⟨Y.point, hYU⟩
    coheight := by
      rw [← Y.coheight]
      exact (Order.coheight_eq_of_isOpenEmbedding
        U.isOpen Y.point hYU).symm

  def Scheme.PrimeDivisor.ofOpen
      {X : Scheme.{u}} (U : X.Opens)
      (Y_U : U.toScheme.PrimeDivisor) :
      X.PrimeDivisor where
    point := Y_U.point.1
    coheight := by
      rw [Order.coheight_eq_of_isOpenEmbedding
            U.isOpen Y_U.point.1 Y_U.point.2]
      exact Y_U.coheight

  /-- Round-trip + bijection on the appropriate subset of
      `X.PrimeDivisor`. -/
  def Scheme.PrimeDivisor.equivOpen
      {X : Scheme.{u}} (U : X.Opens) :
      {Y : X.PrimeDivisor // Y.point ∈ U} ≃ U.toScheme.PrimeDivisor :=
    sorry  -- ~10-15 LOC of round-trip
  ```

  The principal friction is the alignment between `↥U` (the topological
  subspace, on which `coheight_eq_of_isOpenEmbedding` operates) and
  `U.toScheme.carrier` (the scheme-restrict carrier, which is defeq to
  `↥U.1`). The existing `CoheightBridge.lean:175-185` already navigates
  this defeq (see the `h1 : Order.coheight (α := X) z =
  Order.coheight (α := U.toScheme) ⟨z, hzU⟩` cast there) — copy that
  pattern.

  LOC estimate: 30-50.

## Informational

- **Decision 1**: Mathlib's
  `AlgebraicGeometry.Scheme.Opens.stalkIso : (↑U).presheaf.stalk x ≅
  X.presheaf.stalk ↑x` (`Mathlib.AlgebraicGeometry.Restrict`) provides
  the open-immersion stalk identification as a drop-in iso. No
  project-side bridge is needed for Stacks 02IZ on the stalk side. The
  directive's "open-immersion stalk-bridge" phrasing is potentially
  confusing — the Mathlib piece is available; the project-side work is
  only the *cycle-level* (= prime-divisor structure) bijection.

- **Decision 5**: `Ring.ordFrac` (`Mathlib.RingTheory.OrderOfVanishing`)
  has no naturality lemma across a ring iso shipped in Mathlib at
  `b80f227`. This becomes the iter-201 Sub-build 2 scope. Project-side
  ~30-50 LOC: chase through `IsFractionRing.ringEquivOfRingEquiv` +
  the `Ring.ordMonoidWithZeroHom` naturality at the base ring. Worth a
  Mathlib upstream PR.

- **Concrete recipe summary** (per `analogies/wd-stacks02iz.md`):

  | Step | What | LOC | Mathlib / project helpers |
  |---|---|---|---|
  | 1 | `import AlgebraicJacobian.Albanese.CoheightBridge` | 1 | — |
  | 2 | `Scheme.PrimeDivisor.restrictToOpen` + `ofOpen` + `Equiv` | 30-50 | `Order.coheight_eq_of_isOpenEmbedding` (project) |
  | 3 | `Scheme.PrimeDivisor.stalkIso` | 5-10 | `Scheme.Opens.stalkIso` (Mathlib) |
  | 4 (PUSH-BEYOND) | `Scheme.IsRegularInCodimensionOne` open-immersion descent | 10-20 | combine 1-3 |

  Total realistic LOC: **50-90 substrate-only, 60-110 with
  PUSH-BEYOND**. The directive's ~150-250 LOC budget is over-estimated
  by ~50%; the slack should be applied to Sub-build 2 (ordFrac
  naturality) primer work as a PUSH-BEYOND, NOT to padding Sub-build 1.

## Re-scoping note for the iter-200 planner

The lane SHOULD remain dispatched this iter — the progress-critic's
CHURNING verdict is correct, and the corrective is precisely the
"Mathlib-analogy consult" recommendation. What changes is the prover's
mental model:

- **Before**: "build a fresh Stacks 02IZ/005X coheight↔height bridge
  for scheme stalks" (~150-250 LOC).
- **After**: "the bridge exists at `Albanese/CoheightBridge.lean`;
  import it and build a thin (~50-100 LOC) `Scheme.PrimeDivisor`
  open-immersion bijection on top, with the stalk identification via
  Mathlib's `Scheme.Opens.stalkIso`".

The lane retains its `mathlib-build` mode and its helper budget. The
HARD BAR (land Sub-build 1 axiom-clean) is **more** achievable under
the corrected scope.

## Persistent file
- `analogies/wd-stacks02iz.md` — design-rationale captured for future
  iters. Includes the recipe, the verdicts per decision, and the
  upstream-PR opportunities.

Overall verdict: The iter-200 Lane WD-A4a-Sub-build-1 budget is
realistic and likely OVER-ESTIMATED — the topological substrate is
already in the project at `AlgebraicJacobian/Albanese/CoheightBridge.lean`,
and the stalk iso is in Mathlib (`Scheme.Opens.stalkIso`); the actual
work is a thin (~50-100 LOC) prime-divisor open-immersion bijection,
and the next prover round must be re-pointed at the existing substrate.
