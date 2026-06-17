# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ocofp-carrierset-submodule-api

## Iteration
185

## Question

Four questions about the `carrierSet → carrierSubmodule → presheaf → sheaf` chain
inside `RiemannRoch/OCofP.lean` for the Hartshorne subsheaf-of-`K_C` direct
construction of `lineBundleAtClosedPoint`:

1. Is there a Mathlib idiom for "subsheaf of `K(C)` cut out by an order condition"?
2. Which Mathlib API supplies the three `Submodule` closure proofs (`0`, `+`, `kbar • _`)?
3. Sheaf property: gluing-by-stalks vs `isSheaf_iff_isSheaf_forget`?
4. Is `Scheme.RationalMap.order` a parallel API to `IsDedekindDomain.HeightOneSpectrum.valuation`?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: Subsheaf-of-ModuleCat idiom (Q1) | PROCEED | informational |
| 2a: Zero closure (Q2) | ALIGN_WITH_MATHLIB | major |
| 2b: Add closure + class upgrade (Q2) | ALIGN_WITH_MATHLIB | **critical** |
| 2c: `kbar`-scalar closure (Q2) | ALIGN_WITH_MATHLIB | major |
| 3: Sheaf property via `isSheaf_iff_isSheaf_forget` (Q3) | ALIGN_WITH_MATHLIB | **critical** |
| 4: `RationalMap.order` API alignment (Q4) | PROCEED | informational |

## Must-fix-this-iter

Two ALIGN_WITH_MATHLIB verdicts apply to shipped code that has been the route's
recurring blocker for 18 elapsed iters:

- **Decision 2b** (carrier-class upgrade). `WeilDivisor.lean:173-186`'s
  `Scheme.IsRegularInCodimensionOne.out` ships only
  `Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)`. This is strictly weaker than
  what Hartshorne's `(*)` means classically (DVR stalks at prime divisors) and
  blocks `Ring.ordFrac_add`
  (`Mathlib.RingTheory.OrderOfVanishing.Noetherian`) — the canonical
  non-archimedean inequality for `Ring.ordFrac`, which **requires
  `[IsDiscreteValuationRing R]`**, not `[Ring.KrullDimLE 1 R]`. The class field
  must be upgraded to `IsDiscreteValuationRing` (with auto-derivation of
  `Ring.KrullDimLE 1` from DVR via `IsDiscreteValuationRing.TFAE`). ~10 LOC
  edit. Without this, the add-closure proof for `carrierSubmodule` is either
  a typed `sorry` (the iter-183 outcome) or 30-50 LOC of bespoke valuation
  re-derivation (a parallel-API tax that also blocks every downstream consumer).

- **Decision 3** (sheaf-property route). The iter-183 plan (OCofP L143-144)
  chose "gluing-by-stalks" as the sheaf-property route, but the project
  already has a battle-tested `isSheaf_iff_isSheaf_forget` template at
  `StructureSheafModuleK/SheafProperty.lean:32-37` (`toModuleKPresheaf_isSheaf`).
  Mirroring that template halves the LOC (~40 vs ~100) and reuses an
  axiom-clean idiom. The mathematical content collapses because the Type-valued
  forget is a sub-Type-presheaf of the constant presheaf at `K(C)`, which on
  an irreducible scheme (`IsIntegral C.left` already in scope) is automatically
  a sheaf via "all matching `fᵢ` are the same `f ∈ K(C)`".

## Major

Three further ALIGN_WITH_MATHLIB verdicts apply to in-proposal code (the three
closure proofs of the `carrierSubmodule` upgrade):

- **Decision 2a (zero closure)**: 5 LOC via `WithZero.log_zero` +
  `MonoidHomClass.map_zero` (both ship from `Mathlib.Algebra.GroupWithZero.WithZero`).
- **Decision 2b (add closure, after Step 1)**: 10-15 LOC via `Ring.ordFrac_add`
  with case-split on `f + g = 0`.
- **Decision 2c (kbar-scalar closure)**: 5-10 LOC via `Ring.ordFrac_le_smul`
  (works under `Ring.KrullDimLE 1`, no DVR-upgrade required; only needs the
  `[Algebra kbar (stalk)]` + `[IsScalarTower kbar stalk K(C)]` instances, which
  should be inferable from `C : Over (Spec (.of kbar))`).

These three closures together upgrade `carrierSet` to a `Submodule` in ~25 LOC.

## Informational

- **Decision 1**: No Mathlib subsheaf API exists for `Sheaf J (ModuleCat kbar)`-
  valued sheaves. `CategoryTheory.Subpresheaf` / `Subfunctor` ship Type-only
  (`Mathlib.CategoryTheory.Subfunctor.Basic`); `SheafOfModules` has no
  subobject-by-per-open-submodule API either. The project's stepwise build is
  the correct shape — there's no Mathlib idiom to ALIGN to. PROCEED with the
  five-step recipe.
- **Decision 4**: `Scheme.RationalMap.order` (= `WithZero.log ∘ Ring.ordFrac`)
  is **not** a parallel API to `IsDedekindDomain.HeightOneSpectrum.valuation`.
  The two operate at different granularities: `Ring.ordFrac` is per-stalk
  (`Ring.KrullDimLE 1 R`-parameterised), while `HeightOneSpectrum.valuation`
  requires `IsDedekindDomain R` on the whole ring (a global property,
  inappropriate for the stalk of an integral scheme regular only in codim 1).
  The project's per-stalk factoring is right; the only correction is the
  Decision 2b class upgrade so that the per-stalk hypothesis is DVR-strength
  rather than only `Ring.KrullDimLE 1`-strength.

## Iter-186 recipe (5 steps, ~110 LOC total)

| Step | Action | LOC | File |
|------|--------|-----|------|
| 1 | Upgrade `Scheme.IsRegularInCodimensionOne.out` to `IsDiscreteValuationRing`; auto-derive `Ring.KrullDimLE 1` | ~10 | `WeilDivisor.lean:171-186` |
| 2 | Define `carrierSubmodule` with three closure proofs | ~25 | `OCofP.lean` (new, after `carrierSet_mono`) |
| 3 | Define `presheaf` functor with `Submodule.inclusion` restrictions (uses iter-183's `carrierSet_mono`) | ~30 | `OCofP.lean` (new) |
| 4 | Prove `presheaf_isSheaf` via `Presheaf.isSheaf_iff_isSheaf_forget`, mirroring `toModuleKPresheaf_isSheaf` | ~40 | `OCofP.lean` (new) |
| 5 | Replace `OCofP.lean:224-233` `sorry` body with `⟨presheaf, presheaf_isSheaf⟩` (plus `[IsLocallyNoetherian]` + `[IsRegularInCodimensionOne]` class hypotheses on the def) | ~5 | `OCofP.lean:224-233` |

Total: **~110 LOC, all in-project, no Mathlib upstream PRs required**.

## What NOT to do

- **Do NOT** prove the non-archimedean inequality on `Ring.ordFrac` from
  scratch for `KrullDimLE 1`-only stalks. The inequality is mathematically
  false in that generality (e.g. `ℤ[x]/(x^2)`). The correct path is the
  Step 1 class upgrade — which, conceptually, restores the meaning Hartshorne
  attaches to `(*)`.
- **Do NOT** route through `IsDedekindDomain.HeightOneSpectrum.valuation`.
  That API requires `IsDedekindDomain` on the whole ring, a wrong-granularity
  hypothesis for the stalk of an integral scheme regular only in codim 1.
- **Do NOT** prove the sheaf property via stalk-gluing. The
  `isSheaf_iff_isSheaf_forget` route reuses the project's existing template
  (`SheafProperty.lean:32-37`) and is materially cheaper.
- **Do NOT** open a new file (e.g. `IdealSheafDual.lean`) — already
  flagged DIVERGE_INTENTIONALLY by iter-182 analogist
  `ocofp-sheaf-internalhom.md` Decision 4.

## Persistent file
- `analogies/ocofp-carrierset-submodule-api.md` — full design-rationale, with
  per-decision citations, code recipes, and cost-of-not-acting analysis,
  captured for future iters.

Overall verdict: **ALIGN_WITH_MATHLIB on the carrier-class upgrade
(Decision 2b) and the sheaf-property route (Decision 3); execute the 5-step
~110-LOC recipe in iter-186 Lane A — no new helpers beyond the recipe.**
