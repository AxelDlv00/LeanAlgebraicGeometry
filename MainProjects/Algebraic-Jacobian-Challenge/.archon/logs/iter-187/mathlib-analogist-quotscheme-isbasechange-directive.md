# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
quotscheme-isbasechange-tilde

## Design question

How does Mathlib idiomatically prove `IsBaseChange` for **sections of a
module-sheaf pullback over a pair of affine opens** — i.e. given
`g : Y ⟶ X` a morphism of schemes, `N : X.Modules`, `U : Y.Opens` and
`V : X.Opens` both affine opens with `U ≤ g ⁻¹ᵁ V`, prove that the
canonical `Γ(X, V)`-linear map
`Γ(N, V) →ₗ[Γ(X, V)] Γ((Scheme.Modules.pullback g).obj N, U)`
exhibits `Γ((pullback g).obj N, U)` as `Γ(Y, U) ⊗_{Γ(X, V)} Γ(N, V)` —
**without first requiring `N` to be quasi-coherent**?

Specifically:

- Does Mathlib's `Tilde` API + `Scheme.Modules.pullback` machinery have
  a *direct* `IsBaseChange`-conclusion lemma we can invoke?
- If `[IsQuasiCoherent N]` is the missing hypothesis, what does the
  Mathlib idiom look like, and where in the consumer chain
  (`pullback_app_isoTensor_isBaseChange` consumer
  `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
  at L656) should the quasicoherence assumption be threaded?
- Is `Module.Flat.isBaseChange` (algebraic Stacks 02KE on the affine
  ring map `g.appLE V U e`) the cheaper route, and if so, what
  flatness hypothesis would the consumer signature carry?
- Are there other Mathlib-canonical idioms — e.g. via
  `PresheafOfModules.pullback`, or via
  `AlgebraicGeometry.IsLocallyOfFiniteType` + flat-base-change
  cohomology infrastructure — that bypass both the `IsQuasiCoherent`
  and the explicit `Module.Flat` hypothesis?

## Project artifact(s) under question

- `AlgebraicJacobian/Picard/QuotScheme.lean:563-584` —
  `pullback_app_isoTensor_baseMap_isBaseChange` (typed sorry; the
  iter-186 Step 4 typed sorry that gates the Step 2 `baseMap`
  closure cascade).
- `AlgebraicJacobian/Picard/QuotScheme.lean:508-545` —
  `pullback_app_isoTensor_baseMap` (axiom-clean iter-186; the
  `Γ(X, V)`-linear baseMap built from `pullback_app_isoTensor_unitAtV`
  + presheaf restriction `Y.presheaf.map (homOfLE e).op`).
- `AlgebraicJacobian/Picard/QuotScheme.lean:586-606` —
  `pullback_app_isoTensor_isBaseChange` (axiom-clean modulo the
  Step 4 sorry above).
- `AlgebraicJacobian/Picard/QuotScheme.lean:608-660` —
  `pullback_app_isoTensor` (the affine-open section formula iso —
  the consumer of the IsBaseChange Prop).
- `AlgebraicJacobian/Picard/QuotScheme.lean` consumer
  `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
  L656 — the inline sorry the planner's iter-187 plan wants to
  close via the Step 4 cascade.

## Why now

The iter-187 progress-critic (`route187`) returned a **CHURNING**
verdict on Lane F with the explicit corrective: "Mathlib-idiom
consult on `IsBaseChange` + `IsQuasiCoherent` + `Tilde` functor
before another prover round". The Step 4 `IsBaseChange` sorry has
been the named blocker across iter-184/185/186 (3 consecutive
PARTIAL iters) and the project has been proposing the
"Tilde-isoTop route" for 3 iters without execution. Sorry count
stuck at 9 across iter-183-iter-186.

We need this verdict BEFORE assigning a Lane F prover this iter:
either confirm the Tilde-isoTop route is correct (with
`[IsQuasiCoherent N]` threaded), or surface an alternative
(`Module.Flat.isBaseChange` or other Mathlib idiom) that the
prover can execute.

The downstream blocker for the project is the consumer
`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
(L656 inline sorry) which propagates to
`flatBaseChangeCohomology` and ultimately to
A.2.b.iii Quot scheme construction (STRATEGY.md row A.2.b.iii
Iters left ~36-72; elapsed ~16). This is on the critical path
for the Route A engine.

## Hints (optional)

Relevant Mathlib namespaces and concepts:

- `AlgebraicGeometry.Scheme.Modules` (the `.Modules` category =
  `SheafOfModules` over the scheme's structure ring).
- `Mathlib.AlgebraicGeometry.Modules.Tilde` — the `~` functor from
  modules over a commutative ring to module-sheaves on `Spec`.
  Specifically: `AlgebraicGeometry.Modules.Tilde.isoTop`,
  `Mathlib/AlgebraicGeometry/Modules/Tilde.lean` L71-77 (the iter-186
  task_result referenced the pattern at this line range).
- `AlgebraicGeometry.IsQuasiCoherent` — the quasicoherence
  predicate (Mathlib already has this at b80f227).
- `Module.Flat.isBaseChange` /
  `LinearAlgebra.TensorProduct.IsBaseChange` (the algebraic
  Stacks 02KE statement on ring-map flatness).
- `AlgebraicGeometry.PresheafOfModules.pullback` (presheaf-level
  pullback, BEFORE sheafification).
- `IsBaseChange.equiv` and `IsBaseChange.of_lift_isoStep` (the
  consumer-facing equiv-from-base-change-prop API).
- `Scheme.Modules.pullback : (X ⟶ Y) → Y.Modules ⥤ X.Modules`
  (Mathlib backbone, used iter-186 Lane A.1.b for the
  LineBundlePullback closures).

The iter-186 task_result for `QuotScheme.lean` documents (lines
68-87 of the task_result, archived to
`.archon/iter/iter-186/`):

> "1. **Tilde route**: on `Spec(Γ(X, V))` (via `hV.isoSpec`) and
>    `Spec(Γ(Y, U))` (via `hU.isoSpec`), `N|_V` restricts to a
>    tilde-shape sheaf — requires either:
>    - quasi-coherence of `N` (currently not assumed at the
>      consumer signature; iter-187 plan-agent decision: add
>      `[IsQuasiCoherent N]` hypothesis to the consumer chain and
>      propagate), or
>    - the alternative route via `Module.Flat.isBaseChange`
>      (algebraic Stacks 02KE) on the affine ring map
>      `g.appLE V U e`."

We need you to assess whether either path is the Mathlib idiom or
whether a third (e.g. via `PresheafOfModules.pullback` +
`Sheafify` + an existing Mathlib base-change-of-tilde lemma)
better matches Mathlib's design.

## Severity expectation

high-stakes — the choice between `[IsQuasiCoherent N]` thread vs.
`[Module.Flat]` thread vs. third route propagates back through the
consumer chain
`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
→ `flatBaseChangeCohomology` → A.2.b.iii consumers. Getting this
wrong wastes another 3-iter cycle on the same wall.
