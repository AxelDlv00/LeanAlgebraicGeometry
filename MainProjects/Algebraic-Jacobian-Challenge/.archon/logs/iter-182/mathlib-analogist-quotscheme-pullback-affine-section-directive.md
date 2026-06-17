# Mathlib Analogist — `Scheme.Modules.pullback` affine-open section identification

## Mode: api-alignment

## Slug
quotscheme-pullback-affine-section

## Iteration
182

## Question

For a morphism `g : S' ⟶ S` of schemes, `N : S.Modules`, and an
affine open `U : S'.Opens`, is there a Mathlib lemma identifying
`Γ((Scheme.Modules.pullback g).obj N, U)` with
`Γ(S', U) ⊗_{Γ(S, V)} Γ(N, V)` for any compatible affine `V ⊆ S`?

This is the load-bearing gap inside the iter-181 Lane F substantive
helper
`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
(`Picard/QuotScheme.lean:468`), the
`[IsAffine S]`-specialised step of Stacks 02KE algebraic flat-base-
change cohomology. Without it, the lane keeps producing helpers
without payoff (4 helpers, 2 iters, +1 sorry).

## Project artifact(s)

- `AlgebraicJacobian/Picard/QuotScheme.lean:468-499`
  (`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`)
  — body `:= sorry`, ~30 LOC of docstring spelling out the substantive
  Mathlib gap.
- `AlgebraicJacobian/Picard/QuotScheme.lean:430-434`
  (`pushforward_pullback_section_eq_pullback_section`) — closes the
  RHS bridge axiom-clean iter-181 by `rfl`.
- `AlgebraicJacobian/Picard/QuotScheme.lean:618-628`
  (`canonicalBaseChangeMap_app_app_isIso`) — wraps the affine-open
  helper; transitively `sorryAx`-tainted.
- `blueprint/src/chapters/Picard_QuotScheme.tex` §5 — discusses the
  affine-open section formula as a project-bespoke bridge.
- Mathlib `Mathlib.AlgebraicGeometry.Modules.Pullback` — defines
  `Scheme.Modules.pullback` via sheafification of
  `PresheafOfModules.pullback`. Only exposes the closed-form
  identification at *locally free* sheaves (`pullbackObjFreeIso`).

## Decisions identified

### Decision 1: Affine-open section formula for `Scheme.Modules.pullback`

The Stacks 02KE proof relies on
`Γ((Scheme.Modules.pullback g).obj N, U) ≅
  Γ(S', U) ⊗_{Γ(S, V)} Γ(N, V)` for affine `U, V`. Is there a
Mathlib lemma giving this iso under `[IsAffine S']` (or any other
reasonable hypothesis)?

Candidates to verify:
- `Scheme.Modules.pullback_obj_app_isoTensor` — guessing, may not exist.
- `PresheafOfModules.pullback_obj_app` — likely exposes the presheaf
  formula but not after sheafification.
- `Sheafify` interaction with affine-open sections.

### Decision 2: `Module.Flat.isBaseChange` consumer-side packaging

iter-181 Lane F task_result identifies
`Module.Flat.isBaseChange` (from `Mathlib.RingTheory.Flat.Stability`)
as the algebraic atom. Once Decision 1 lands, what's the cleanest
chain from `IsBaseChange` to the desired `IsIso`?

### Decision 3: Base-side Mayer-Vietoris reduction for general `S`

The general case (non-affine `S`) reduces to the `[IsAffine S]`
specialization via Mayer-Vietoris on the base. Does Mathlib have
`canonicalBaseChangeMap_app_app_isIso_of_baseAffineCover` or
similar? If not, what's the canonical idiom?

## Hard ask

For each Decision, return:
- **Mathlib idiom** (verified).
- **Project's current path**.
- **Gap classification**.
- **Recommended action**.

Then produce a **persistent recipe at `analogies/quotscheme-pullback-affine-section.md`** with:
- Concrete Lean signatures + Mathlib API names for the affine-open
  body and the Mayer-Vietoris reduction.
- Estimated LOC for the `_of_isAffineOpen_of_isAffineBase` body and
  for the missing project-side helper(s) if any.
- An explicit recommendation on whether to dispatch a prover lane
  this iter to close the affine-base helper (if recipe lands) or to
  defer pending project-side helper construction.

If `Scheme.Modules.pullback`'s affine-open section formula genuinely
requires a project-side helper not yet in Mathlib, the recipe should
say so with `BUILD_PROJECT_HELPER` verdict and propose the smallest
helper that would unblock the lane.
