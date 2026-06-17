# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
tscmp254

## Iteration
254

## Structural problem
Naturality of the tensor-comparison morphism of a monoidal localization/reflection (sheafification
of presheaves of modules), shape `(p ⊗ₘ q) ≫ (η ▷ ≫ ◁ η) = (η ▷ ≫ ◁ η) ≫ (ā ⊗ₘ b̄)`. Blocked
by (1) two defeq-but-head-distinct `MonoidalCategoryStruct` instances that `whisker_exchange` cannot
bridge across the cross-group crossing, and (2) an identity base-change wrapper `restrictScalars (𝟙 R)`
on the reflection unit's codomain that detonates `whnf` under `erw`.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Functor.LaxMonoidal.μ_natural_left/right`, `OplaxMonoidal.δ_natural_left/right` (`Monoidal/Functor.lean:70-104,246-286`) | monoidal functors | low–medium | ANALOGUE_FOUND |
| `Localization.Monoidal` `tensorBifunctorIso` + `μ_natural_left` (`Localization/Monoidal/Basic.lean:184-201`; consumed by `Sites/Monoidal.lean`) | localization / sheafification | high (principle only) | PARTIAL_ANALOGUE |
| `ModuleCat.restrictScalarsId'App_inv_naturality` + `map_id` (`ChangeOfRings.lean:188-226`; usage `Presheaf/Colimits.lean:79`, `Limits.lean:84`) | change-of-rings for modules | low | ANALOGUE_FOUND |

## Top suggestion
Stop hand-proving `sheafifyTensorUnitIso_hom_natural` (and S3 of `pullbackTensorMap_natural`) with
whisker calculus. Recast it as the **two single-sided naturality lemmas** of the sheafification
monoidal comparison — `Functor.OplaxMonoidal.δ_natural_left`/`δ_natural_right` (or
`LaxMonoidal.μ_natural_left/right`) — of the **same** monoidal functor the project already uses for
the sibling square S2 (it cites `Functor.OplaxMonoidal.δ_natural` at TensorObjSubstrate.lean:2016).
Read `Mathlib/CategoryTheory/Monoidal/Functor.lean:70-104,246-286` (all are `@[reassoc (attr := simp)]`),
then make `sheafifyTensorUnitIso` literally the comparison `δ`/`μ` of `sheafification ⋙ forget`.
Because each lemma whiskers on **one** side against **one** `μ`/`δ`, every term stays in a single
`MonoidalCategoryStruct` instance: the cross-group crossing never forms and `tensorHom_def` is never
needed — so neither failed approach (the `letI` bridge, the `erw` whnf) is re-entered. First file to
touch: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1914-1962`.

This is not guesswork: it is exactly how Mathlib makes sheafification monoidal. `Sheaf.monoidalCategory`
(`CategoryTheory/Sites/Monoidal.lean:161-205`) is built from `LocalizedMonoidal`
(`CategoryTheory/Localization/Monoidal/Basic.lean`), which (a) carries the monoidal structure on a
**type synonym holding one canonical instance** (`:86-88`, `:172-180`) so no defeq-spelling collision
can arise, and (b) proves the comparison-with-whiskering squares by reading
`NatTrans.naturality_app` off a bifunctor iso `tensorBifunctorIso`
(`μ_natural_left := NatTrans.naturality_app … ` at `:191`) — never by `whisker_exchange` across two
instances. Do **not** instantiate `LocalizedMonoidal` literally (it needs `MonoidalClosed (ModuleCat-
presheaf)` + `J.W.IsMonoidal`, recorded DEAD for this project in memory ts233); borrow only the
principle, realized cheaply through the `δ`/`μ` lemmas above.

Pair it with the `restrictScalars (𝟙)` fix (Analogue 3): mirror `Presheaf/Colimits.lean:79` /
`Limits.lean:84` and strip the wrapper with an **eager** `rw` of the dedicated naturality lemma
(`ModuleCat.restrictScalarsId'App_inv_naturality` at the ModuleCat level; the project's
`restrictScalarsId_map` at the PresheafOfModules level — Mathlib has **no** presheaf-level
`restrictScalarsId` NatIso, only `(restrictScalars (𝟙 R)).Full = 𝟭.Full` at
`Presheaf/ChangeOfRings.lean:63`, so the project's lemma is the correct local fill) **before** any
whisker/`erw` step, so the `whnf` from failed approach #2 is never triggered. The wrapper's origin is
`Presheaf/Sheafify.lean:329`, where `toSheafify α φ : M₀ ⟶ (restrictScalars α).obj (sheafify α φ).val`
bakes `restrictScalars α` into the unit codomain.

## Verdict on the directive's binary (i vs ii)
Neither pure (i) "strip a `simp` lemma so plain `rw` fires" nor pure (ii) "different architecture":
the correct fix is a **focused proof-architecture reformulation onto the monoidal-functor comparison**
(`δ`/`μ` naturality) that *simultaneously* pins one instance (avoiding the whisker collision) and
keeps the wrapper-strip as a one-line eager `rw`. On the explicit restate question: yes — state
`pullbackTensorMap` and its helper isos on the **single canonical ring-functor spelling Mathlib uses
for the monoidal instance**, namely `X.presheaf ⋙ forget₂ CommRingCat RingCat`
(registered at `Algebra/Category/ModuleCat/Presheaf/Monoidal.lean:32,104-105`), not on
`Sheaf.val X.ringCatSheaf` or `X.ringCatSheaf.obj`. That also clears the D1′ Square-2 `Sheaf.val`/`.obj`
merge (TensorObjSubstrate.lean:2006-2027), which is the same head-keyed spelling split.

## Discarded
- Literal `LocalizedMonoidal`/`Sheaf.monoidalCategory` instantiation — requires `MonoidalClosed` +
  enriched-hom + `J.W.IsMonoidal` for `PresheafOfModules`, recorded DEAD (memory ts233); kept only as
  the structural warrant for the `δ`/`μ` route.
- Authoring a new `:= rfl` whisker-projection brick / `letI` instance-unification — prior analogist
  whisker252 disproved these live; not re-suggested.

## Persistent file
- `analogies/tscmp254.md` — full analogue list and rationale for future iters.

Overall verdict: the square is a `δ`/`μ` monoidal-functor naturality in disguise — recast S3 as
`OplaxMonoidal.δ_natural_left/right` of the sheafification functor (the lemma family already powering
S2), pin every comparison map on the `… ⋙ forget₂ CommRingCat RingCat` spelling, and strip
`restrictScalars (𝟙)` eagerly; the two-instance whisker bridge then never needs to exist.
