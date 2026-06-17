# Mathlib Analogist Directive

## Slug
c1-route

## Design question

What is the canonical Mathlib idiom for defining the **Picard group of a
scheme as the units of a monoidal category of `O_X`-modules**, and is
that idiom executable today against the project's already-shipped
`MonoidalCategory (X.Modules)` / `BraidedCategory (X.Modules)` chain
(which transitively depends on the deferred `instIsMonoidal_W` sorry
for `(W X).IsMonoidal`)?

Specifically:

1. The strategy text proposes refactoring `LineBundle X` from
   `CommRing.Pic Γ(X, ⊤)` (an admitted-wrong global-sections
   approximation) to `MonoidalCategory.Invertible (X.Modules)` — but
   Mathlib b80f227 has no type literally named `MonoidalCategory.Invertible`.
   What is the actual Mathlib API for "invertible objects in a (braided)
   monoidal category"? Likely candidates I've spotted via leansearch:
   - `(CategoryTheory.Skeleton C)ˣ` — units of the skeleton-monoid
     (`CategoryTheory.Skeleton.instMonoid` / `instCommMonoid` for
     braided/symmetric C). This is the pattern Mathlib uses for
     `CommRing.Pic R := (Skeleton (SemimoduleCat R))ˣ` (per the
     `Pic` definition in `Mathlib.RingTheory.PicardGroup`).
   - `Module.Invertible R M` — typeclass on the module itself
     (used by `CommRing.Pic.mk` to register inhabitants).
   - Some combination via `Mon_` (monoid-objects-in-monoidal-category).

2. **The deferred dependency**. `BraidedCategory (X.Modules)` derives
   via `Localization.Monoidal.instBraidedCategoryLocalizedMonoidal`,
   which requires `[W.IsMonoidal]` — and `(W X).IsMonoidal` is the
   project's `instIsMonoidal_W` SORRY (`Modules/Monoidal.lean` L166–L173,
   carrying a docstring naming the upstream Mathlib gap on
   `stalk_tensorObj` for varying-ring `R₀`). This sorry is deferred
   indefinitely as a Mathlib gap. So the C1 LineBundle would type-check
   against the in-scope `instIsMonoidal_W` sorry but transitively depend
   on it. Is this acceptable, or does it constitute a hidden dependency
   that the project's "3 named Mathlib gaps" end-state framing
   misrepresents?

3. **Pullback functoriality**. The current `Pic.pullback` (LineBundle.lean
   L120) is defined as `CommRing.Pic.mapRingHom (globalSectionsHom f).hom`.
   The C1-promoted version would need to derive from a categorical
   pull-back functor `f^* : Y.Modules ⥤ X.Modules` plus that functor's
   tensor-preservation (a `Functor.Monoidal` instance). What does
   Mathlib provide for `Functor.Monoidal` on the inverse-image functor
   between `SheafOfModules` categories? Is the tensor-preservation
   automatic from the construction (sheafification of presheaf-pullback
   composed with presheaf-tensor), or does it itself need a non-trivial
   gap-fill?

4. **Inhabitants — how to register a `LineBundle X`**. `CommRing.Pic.mk`
   takes a `Module R M` + a `Module.Invertible R M` instance and
   returns a `CommRing.Pic R` element. What is the analogous Mathlib API
   for constructing a `(Skeleton X.Modules)ˣ` from an `M : X.Modules`
   together with a witness that `M ⊗ M⁻¹ ≅ 𝟙_`? Is there a constructor
   like `(Skeleton C).mkUnits` or do we need to manually build a
   `Units` element from a `CategoryTheory.Iso` witness?

## Project artifact(s) under question

- `AlgebraicJacobian/Picard/LineBundle.lean` (full file, ~150 LOC) —
  the current `LineBundle` definition, `instCommGroupLineBundle`, and
  `Pic.pullback` API.
- `AlgebraicJacobian/Modules/Monoidal.lean` (full file, ~195 LOC) —
  the `MonoidalCategory (X.Modules)` chain, including the deferred
  `instIsMonoidal_W` sorry at L173.
- `AlgebraicJacobian/Picard/Functor.lean:67-150` — the
  `PicardFunctor` definition that consumes `Pic.pullback`.
- `AlgebraicJacobian/Picard/FunctorAb.lean` — the `AddCommGrp`-flavor
  `PicardFunctorAb` derived from `PicardFunctor`.
- `Mathlib.RingTheory.PicardGroup` — the canonical Mathlib precedent
  (`CommRing.Pic` and `Module.Invertible`).
- `Mathlib.CategoryTheory.Monoidal.Skeleton` — the
  `Skeleton.instMonoid` / `instCommMonoid` / `instMonoidalCategory`
  chain.
- `Mathlib.CategoryTheory.Localization.Monoidal.Braided` — the
  `LocalizedMonoidal` ← `[W.IsMonoidal]` derivation chain.

## Why now

The plan-agent (Archon iter-108 / narrative iter-110) has fired the
Phase A escape-valve menu (Option (i) defer-L1846-as-budget-deferral),
and is deciding whether to ALSO fire C1 promotion this iter (the
strategy-critic-iter108 alternative recommendation). My one-pass
verification this iter found:

- `MonoidalCategory.Invertible` does not exist as a literal type in
  Mathlib b80f227 (only `Mon_`, `(Skeleton C)ˣ`, and
  `Module.Invertible R M` patterns surface).
- `BraidedCategory (X.Modules)` exists transitively via
  `instBraidedCategoryLocalizedMonoidal`, but requires the deferred
  `instIsMonoidal_W` sorry.
- `Skeleton.instCommMonoid` requires `BraidedCategory` (so the canonical
  `(Skeleton X.Modules)ˣ` route inherits the deferred dependency).
- The current strategy assumes C1 is "unblocked" by `instIsMonoidal_W`
  (per Modules/Monoidal.lean docstring); this needs verification at
  the API level.

The plan-agent will fire C1 next iter (iter-109 narrative / Archon
iter-109) informed by your report. **High-stakes: this design choice
will be load-bearing for Phase C2 and the entire downstream Picard
arc**. Don't rubber-stamp.

## Hints

- Pattern from `Mathlib.RingTheory.PicardGroup`:
  `def CommRing.Pic (R : Type u) [CommSemiring R] : Type u :=
   (CategoryTheory.Skeleton (SemimoduleCat R))ˣ` (or similar — verify
  exact definition).
- `CategoryTheory.Skeleton.instCommMonoid : CommMonoid (Skeleton C)`
  derives from `[BraidedCategory C]` plus `[MonoidalCategory C]`.
- For a generic `CommMonoid M`, `Mˣ` is automatically a `CommGroup`
  via `instCommGroupUnits`.
- `Module.Invertible` is the typeclass for "rank-1 free over a CommSemiring";
  scheme-side analog might be a typeclass `SheafOfModules.Invertible M`
  or simply pure-categorical "M ⊗ M⁻¹ ≅ 𝟙_".
- `Mathlib.CategoryTheory.Monoidal.Mon_` has `Mon_` (monoid objects);
  there might be a `Grp_` (group objects) or analog that captures
  invertibility — worth checking.

## Severity expectation

high-stakes
