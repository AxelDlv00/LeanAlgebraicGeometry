# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
fbc-iter009

## Iteration
009

## Structural problem
Base-change / restriction-extension square iso of `ModuleCat R'` objects
(`(A⊗_R R')⊗_A M ≅ R'⊗_R M`) whose underlying `R'`-action is typeclass-synthesizable, so that
`smul_zero`/`smul_add` fire. The current carriers carry an **opaque `_aux` `Module ↑R'`** coming
through `ModuleCat.ExtendScalars`/`RestrictScalars` functor objects, through which `SMulZeroClass ↑R'`
does not synthesize; the two `r' • 0 = 0` branches of a hand-rolled `map_smul'` cannot close.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Algebra.IsPushout.cancelBaseChange` (`Mathlib.RingTheory.IsTensorProduct`) | comm-algebra / ring pushout | low–med | ANALOGUE_FOUND |
| `ModuleCat.restrictScalarsComp'App` & change-of-rings coherence suite (`…ModuleCat.ChangeOfRings`) | category theory | low | ANALOGUE_FOUND |
| `CommRingCat.moduleCatRestrictScalarsPseudofunctor` / `CategoryTheory.TwoSquare` Guitart-exact | 2-cat / pseudofunctor mate | high | PARTIAL_ANALOGUE |

## Empirically confirmed root cause
Tested at `FlatBaseChange.lean:909` via `lean_multi_attempt`/`lean_goal`:
- Zero-branch goal is `g.toFun (r' • 0) = (RingHom.id ↑R') r' • g.toFun 0`.
- `simp only [smul_zero, map_zero]` → "simp made no progress"; `rw [smul_zero]` → pattern `?a • 0`
  not found; `erw [smul_zero]` → **"failed to synthesize `SMulZeroClass ↑R' ↑((ModuleCat.extendScalars
  Algebra.TensorProduct.includeLeftRingHom).obj M)`"**. The `R'`-instances in context are the opaque
  `base_change_mate_regroupEquiv._aux_3 / ._aux_5`.
- The `add`/`tmul` branches close (committed proof) only because their `smul_*` lemmas unify against
  `•`-subterms already in the goal; `smul_zero`'s bare `0` forces a fresh `SMulZeroClass` synthesis
  that the opaque `_aux` defeats. → the in-place `map_smul'` route is **structurally dead**.
- The file's own note `:851` (imported one-liner "typechecks") is **stale**; note `:911` (diamond
  blocks it) is **correct** — verified: `LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`
  fails with an `(A⊗[R]R')⊗[A]M ≃ₗ[R'] …` vs `↑((extendScalars includeLeftRingHom).obj M) ≃ₗ[R'] …`
  type mismatch (the `Module A (A⊗R')` carrier diamond).

## Top suggestion
Adopt the directive's option **(a), refined**. Replace the regroup *core*
`TensorProduct.AlgebraTensorModule.cancelBaseChange ↑R ↑A ↑A ↑M ↑R'` (only `≃ₗ[A]`, forcing the
hand-rolled `R'`-`map_smul'` that dies on the zero branches) by
`Algebra.IsPushout.cancelBaseChange ↑R ↑R' ↑A (↑A ⊗[↑R] ↑R') ↑M`
(`Mathlib.RingTheory.IsTensorProduct`), which is **natively `≃ₗ[R']`** — Mathlib discharges
`R'`-linearity inside the bundled `LinearEquiv`, so there is **no `map_smul'`, no
`TensorProduct.induction_on`, and no `r' • 0` zero branch**. The required
`Algebra.IsPushout R R' A (A⊗[R]R')` instance is free from `TensorProduct.isPushout'`. Promote with
`LinearEquiv.toModuleIso`; the **only** residual is the `Module A (A⊗R')` diamond against
`(ModuleCat.extendScalars includeLeftRingHom).obj M`, resolved at the **object level** by an `id`
carrier-`≃ₗ[R']` with `map_smul' := fun _ _ => rfl` (the `R'`-linear analogue of the existing `eT`)
or by the `restrictScalarsComp'App` coherence family — modelled on the project's **axiom-clean,
element-free** `gammaPushforwardIso` (`FlatBaseChange.lean:288`), whose change-of-rings coherence
maps are the identity on elements (`restrictScalarsComp'App_hom_apply : … = x`) and so never emit a
`r' • 0` goal.

First files to touch: `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (swap
`base_change_regroup_linearEquiv`'s body to `Algebra.IsPushout.cancelBaseChange`), then
`FlatBaseChange.lean:854` (`base_change_mate_regroupEquiv`).

**Why not option (b)** (abandon the mate equiv; reduce through tilde dictionaries to
`cancelBaseChange`): the consumers `base_change_mate_domain_read`/`codomain_read` are *typed at the
functor objects*, so the same A-diamond bridge is unavoidable with or without a named `regroupEquiv`;
option (b) only inlines the identical obstruction into `base_change_mate_generator_trace_eq` (itself
`sorry` for the unrelated adjoint-mate-unwinding reason) and discards a clean blueprint-referenced
declaration. Keep the named iso; fix its construction.

## Discarded
- `TensorProduct.AlgebraTensorModule.cancelBaseChange` as the core — its `B`-slot is `A`, giving only
  `≃ₗ[A]`; the `R'`-linearity must then be hand-bundled, which is exactly the dead route. Superseded
  by the pushout-form `Algebra.IsPushout.cancelBaseChange` (native `≃ₗ[R']`).
- In-place zero-branch tactics (`letI`/`inferInstanceAs` `SMulZeroClass`, `.toDistribMulAction`
  projection) — overlap the directive's "Failed approaches"; reconfirmed dead.

## Persistent file
- `analogies/fbc-base-change-square-transparent-module.md` — full diagnosis, ranked analogues,
  diamond-resolution recipe, and (a)-vs-(b) rationale captured for future iters.

Overall verdict: option (a)-refined — swap the core to the natively-`R'`-linear
`Algebra.IsPushout.cancelBaseChange`, killing the `map_smul'` zero branches at the source, and
resolve the lone A-diamond at the object level à la `gammaPushforwardIso`.
