# Mathlib Analogist — OCofP `lineBundleAtClosedPoint` / `toFunctionField`

## Mode: api-alignment

## Slug
ocofp-sheaf-internalhom

## Iteration
182

## Question

The project's `RiemannRoch/OCofP.lean` declares two sorry-bodied
load-bearing carriers:
- `lineBundleAtClosedPoint` (L140) — `noncomputable def := sorry`
  returning a `Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)`.
- `lineBundleAtClosedPoint.toFunctionField` (L154) — `noncomputable def := sorry`
  returning a `kbar`-linear map from sections to the function field.

These bodies block `globalSections_iff` (which now has the correct
signature `∃ s, toFunctionField P hP s = f` per iter-181 plan-phase
refactor). Without `toFunctionField`'s body, the iff is *mathematically
vacuous* (the lean-auditor iter-181 MAJOR finding).

Hartshorne II.6 packages `O_C(P)` as the subsheaf of `K_C` of rational
functions with `(f) ≥ -[P]`. Mathlib has:
- `Mathlib.AlgebraicGeometry.FunctionField.functionField` — the function
  field `K(X)` at the generic point for an integral scheme.
- `Mathlib.AlgebraicGeometry.Sheafify` infrastructure.
- `Mathlib.AlgebraicGeometry.PresheafOfModules.*` — `PresheafOfModules`
  category with `pullback` / `sheafify`.

## Project artifact(s)

- `AlgebraicJacobian/RiemannRoch/OCofP.lean:140` `lineBundleAtClosedPoint`
- `AlgebraicJacobian/RiemannRoch/OCofP.lean:154`
  `lineBundleAtClosedPoint.toFunctionField`
- `blueprint/src/chapters/RiemannRoch_OCofP.tex` —
  - L149-167 "Equivalent description via the ideal sheaf": defines
    `O_C(P)` as `Hom_{O_C}(I_P, O_C)` where `I_P` is the ideal sheaf
    of `P`, packaged as a subsheaf of `K_C`.
  - L237-241 the iff's binding of `s ↔ f`.
- iter-180 Lane D task_result (referenced in OCofP L195+):
  identifies the blocker as Sheaf internal-Hom + ModuleCat forget
  Mathlib gap.

## Decisions identified

### Decision 1: Sheaf-internal-Hom for `Sheaf C (ModuleCat R)` — does Mathlib have it?

For a Grothendieck site `C` and a ring `R`, does Mathlib expose
`internalHom (F G : Sheaf C (ModuleCat R)) : Sheaf C (ModuleCat R)`
(or equivalently `Sheaf.Hom` packaged as a sheaf)?

If yes: what's the canonical name + signature, and is it the right
abstract gadget to define `lineBundleAtClosedPoint`?

If no: what's the canonical Mathlib path to build it?

### Decision 2: Ideal-sheaf-of-a-closed-point — Mathlib status?

Does Mathlib have `Scheme.idealSheafOf : Scheme.Opens → Sheaf` or
`idealSheafOfClosedPoint : C → P : C.left → Sheaf`? If no, what's the
canonical idiom (probably `Scheme.affineLocallyOfFiniteType` +
local-ring `maximalIdeal` packaging)?

### Decision 3: Subsheaf-of-the-function-field — alternative formulation.

Hartshorne packages `O_C(P)` directly as a subsheaf of `K_C`. Is there
a Mathlib idiom for "subsheaf of the constant sheaf at `K_C`"? Project
side: `lineBundleAtClosedPoint.toFunctionField` is exactly the
inclusion `O_C(P) ↪ K_C`. The right shape might be packaging
`lineBundleAtClosedPoint` as a subsheaf from the start, making
`toFunctionField` literally the inclusion (not a def to be filled).

### Decision 4: Bottom-up alternative — open a new `RiemannRoch/IdealSheafDual.lean` file.

iter-180 Lane D task_result suggests an in-project
`IdealSheafDual.lean` bottom-up lane. Evaluate: is that the right move
given the analyses in Decisions 1-3, or does Mathlib have enough to
land both bodies in this file directly?

## Hard ask

For each Decision, return:
- **Mathlib idiom** (verified by `lean_loogle` / `lean_leansearch`).
- **Project's current path**.
- **Gap classification**.
- **Recommended action**.

Then produce a **persistent recipe at `analogies/ocofp-sheaf-internalhom.md`** with:
- Concrete Lean signatures and Mathlib API names for both
  `lineBundleAtClosedPoint` and `toFunctionField` bodies.
- Estimated LOC for both bodies + any intermediate helpers.
- If a new file (`IdealSheafDual.lean`) is the right move, describe
  its file-skeleton shape (top-level decls + ETA per body).

If neither body is feasible at the pinned Mathlib commit, the recipe
should say so explicitly with `NOT_FOUND` / `BUILD_PROJECT_HELPER`
verdict, naming the specific project-side helpers needed.
