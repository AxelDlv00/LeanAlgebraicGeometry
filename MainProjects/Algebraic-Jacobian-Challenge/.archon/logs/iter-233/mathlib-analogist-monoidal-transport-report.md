# Mathlib Analogist Report

## Mode
api-alignment

## Slug
monoidal-transport

## Iteration
233

## Question
Can the project obtain the associator (and unitors, braiding) for its scheme-module
tensor product `tensorObj` **unconditionally** (no flatness, no local triviality) by
anchoring on Mathlib's monoidal-sheafification machinery, instead of the hand-built
whiskering transport that has been stuck for ~15 iterations?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| `Sheaf.monoidalCategory` / `J.W.IsMonoidal` chain applies to `SheafOfModules` over a varying ring | NEEDS_MATHLIB_GAP_FILL | critical (premise false) |
| `J.W.IsMonoidal` free "from enough points" / `Sites.Point.IsMonoidalW` | NEEDS_MATHLIB_GAP_FILL | critical (cited decl does not exist) |
| Cheapest path to retire `isLocallyInjective_whiskerLeft_of_W` | route (a) NEEDS_MATHLIB_GAP_FILL; local-triviality route ALIGN | high |

## Answer to the four directive questions

**1. Do the cited declarations exist?**
- `PresheafOfModules.monoidalCategory` — **YES**
  (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`): full `MonoidalCategory` on
  `PresheafOfModules (R.comp (forget₂ CommRingCat RingCat))` for `R : Cᵒᵖ ⥤ CommRingCat`.
  The project already uses its `monoidalCategoryStruct.associator` — the presheaf level
  is fine.
- `CategoryTheory.Sheaf.monoidalCategory` — **YES**
  (`Mathlib.CategoryTheory.Sites.Monoidal`): `MonoidalCategory (Sheaf J A)` for a
  **fixed** monoidal value category `A`, gated `[J.W.IsMonoidal] [HasWeakSheafify J A]`.
- `J.W.IsMonoidal` = `CategoryTheory.MorphismProperty.IsMonoidal`
  (`Mathlib.CategoryTheory.Localization.Monoidal.Basic`). The ONLY instance providing it
  for a topology is `CategoryTheory.GrothendieckTopology.W.monoidal`
  (`Mathlib.CategoryTheory.Sites.Monoidal`), with hypotheses `[MonoidalCategory A]`,
  **`[MonoidalClosed A]`**, `[∀ F₁ F₂, HasFunctorEnrichedHom A F₁ F₂]`,
  `[∀ F₁ F₂, HasEnrichedHom A F₁ F₂]`. (Plus `W.transport_isMonoidal` along a
  cover-dense full continuous functor — not points-based.)
- `Sites.Point.IsMonoidalW` — **DOES NOT EXIST.** No hit in `lean_leansearch` /
  `lean_loogle` under any phrasing. `TopCat.hasEnoughPoints` did not surface and is not
  load-bearing (no points-based `IsMonoidal` instance consumes it). The project's own
  comment (Vestigial.lean:232-236, 252-264) claiming Mathlib provides `J.W.IsMonoidal`
  flatness-free via enough points is **unsubstantiated at the pinned commit**.

**2. Does the chain apply to `SheafOfModules` over the varying `X.ringCatSheaf`?**
**NO.** `SheafOfModules R` is sheaves of modules over a varying sheaf of rings; its
monoidal structure (`PresheafOfModules.monoidalCategory`, tensor over the varying ring)
is NOT the pointwise monoidal structure on a functor category `Cᵒᵖ ⥤ A`, so it is not an
instance of `Sheaf J A` for any fixed monoidal `A`. Confirmed Mathlib-absent:
`MonoidalCategory (SheafOfModules _)` (loogle: none), `SheafOfModules.Monoidal` (none),
"sheafification of `PresheafOfModules` is monoidal" (none — only `sheafification`,
`sheafify`, `toSheafify`, `sheafifyMap`, none monoidal). A transport step is genuinely
required — exactly the sheafification-of-the-presheaf-tensor the project already does.
The proposed "read the associator off `Sheaf.monoidalCategory`" shortcut is not available.

**3. Cheapest path to an unconditional `tensorObj_assoc_iso` that retires the sorry?**
- **Route (a)** — "establish `J.W.IsMonoidal` and read off the associator": NOT
  off-the-shelf. The `IsMonoidal` typeclass does NOT eliminate the obligation — its
  `whiskerLeft` field (or the `mk'` `tensorHom` field) IS
  `isLocallyInjective_whiskerLeft_of_W` for `W = inverseImage toPresheaf J.W` on
  `PresheafOfModules`. To use Mathlib's machinery here you must first build
  `MonoidalClosed (PresheafOfModules R)` (the tensor-hom **adjunction**; the project's
  ts219 internal-hom is only the value object) AND a `W.monoidal`-analog stated for
  `PresheafOfModules` (Mathlib's `W.monoidal` is for `Cᵒᵖ ⥤ A`). That is strictly MORE
  work than route (b) and reproduces the same whiskering content via the closed-adjoint
  argument. → NEEDS_MATHLIB_GAP_FILL; do not pursue.
- **Route (b)** — prove `isLocallyInjective_whiskerLeft_of_W` directly via the stalk
  (d.2): the genuine unconditional residual, ~200-400 LOC, the Mathlib-absent stalk-⊗
  commutation `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x` at the `PresheafOfModules` level (d.1
  `stalkLinearMap` already built project-side).
- **Route (b′) local-triviality scoping** — the cheapest realization for the only
  objects the group law consumes (⊗-invertible / locally-trivial line bundles), and the
  match to the iter-232 carrier pivot. `tensorObj_assoc_iso` already takes
  `IsLocallyTrivial M/N/P` but discards them, calling the sorry-dependent `_of_W`. The
  project's flat lemmas `W_whiskerLeft_of_flat` / `W_whiskerRight_of_flat`
  (Vestigial.lean:188/204) are **already sorry-free**, but — per the project's own
  iter-212 finding (TensorObjSubstrate.lean:322-335) — local triviality does NOT give
  *global* sectionwise flatness (global sections over a non-affine open are not flat), so
  `_of_flat` cannot be fed for a line bundle globally either. The correct realization is
  to whisker on the trivializing cover where `P ≅ 𝒪`, so `η ▷ P ≅ η ∈ J.W` for free —
  no stalk port, no MonoidalClosed, no false flatness.

**4. LOC / risk and blocking prerequisites for route (a):**
Route (a) requires, none of which ship in Mathlib for `PresheafOfModules`:
`MonoidalClosed (PresheafOfModules R)` (tensor-hom adjunction — multi-iter build, the
ts219 internal-hom value is a fraction of it), the enriched-hom typeclasses
`HasFunctorEnrichedHom` / `HasEnrichedHom` over the varying-ring module functor
category, and a PresheafOfModules-level `W.monoidal`. The `MonoidalClosed` prerequisite
is exactly the typeclass that "might not hold / is not built" for the `Opens X`
module-sheaf setting, and it blocks route (a). Net: route (a) ≥ route (b) in cost and
adds prerequisites; route (b′ local) is far cheaper and is the recommended unblock.

## Must-fix-this-iter

- **Stop citing the non-existent `Sites.Point.IsMonoidalW` / "enough points ⇒
  `J.W.IsMonoidal` free" as a live route.** It appears in the rationale of
  `isLocallyInjective_whiskerLeft_of_W` (Vestigial.lean:232-236, 252-264) and frames the
  unconditional whiskering as a "Mathlib-blessed flatness-free technique". It is not in
  Mathlib at the pinned commit; the only `J.W.IsMonoidal` instance needs `MonoidalClosed`.
  Any planning that treats route (a) / route (d) as a cheap unconditional realization is
  building on a false premise — redirect to route (b′ local-triviality) or route (b stalk).

## Informational

- The presheaf-level associator the project transports (`PresheafOfModules.monoidalCategory`)
  is the correct, fully-available Mathlib idiom — keep it.
- The flat whiskering lemmas (`W_whisker{Left,Right}_of_flat`) are sorry-free and the
  right shape; the only gap to a locally-trivial associator is "where `P ≅ 𝒪`, whisker
  there", not a stalk port.

## Persistent file
- `analogies/monoidal-transport.md` — full design-rationale captured for future iters.

Overall verdict: The proposed Mathlib monoidal-sheafification shortcut does NOT yield an
unconditional `SheafOfModules` associator — that machinery is for fixed-`A` sheaf
categories, the cited `Sites.Point.IsMonoidalW` does not exist, and the only
`J.W.IsMonoidal` instance needs a `MonoidalClosed (PresheafOfModules)` structure the
project lacks; the cheapest real unblock is the iter-232 local-triviality scoping (or the
~200-400 LOC d.2 stalk port for the truly unconditional lemma).
