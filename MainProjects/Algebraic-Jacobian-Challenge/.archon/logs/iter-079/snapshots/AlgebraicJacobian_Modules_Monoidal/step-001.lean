/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# The symmetric monoidal structure on `X.Modules`

Phase C step C0 (per `STRATEGY.md`): the category of $\mathcal O_X$-modules
on a scheme $X$ carries a canonical symmetric monoidal structure, with
tensor product given by sheafification of the presheaf tensor product and
tensor unit given by the structure sheaf $\mathcal O_X$ itself.

See `blueprint/src/chapters/Modules_Monoidal.tex`.

## Status (iteration 077 — refactor-subagent scaffold)

This file scaffolds the three signatures (`tensorObj`,
`instMonoidalCategoryStruct`, `instMonoidalCategory`) needed by Phase C
step C1 (refining `LineBundle` from `CommRing.Pic Γ(X, ⊤)` to the
invertible-object definition). The bodies are `sorry` for the prover
rounds iter-078+ to fill, using:

- `PresheafOfModules.monoidalCategory` (presheaf-side structure)
- `PresheafOfModules.Monoidal.tensorObj` (pointwise tensor)
- `PresheafOfModules.sheafification` (left adjoint to inclusion)
- `SheafOfModules.toSheafCompSheafToPresheafIso` (the comparison data)

## Mathematical content

For two $\mathcal O_X$-modules $M$ and $N$,
$$
  M \otimes_{\mathcal O_X} N
    := \mathrm{sheafify}(M_{\mathrm{psh}} \otimes_{\mathcal O_X, \mathrm{psh}} N_{\mathrm{psh}}).
$$
The associator/unitors/braiding on the sheaf side are sheafifications of their
presheaf counterparts; the coherence axioms transfer via the universal
property of sheafification.
-/

set_option autoImplicit false

universe u

open CategoryTheory MonoidalCategory

namespace AlgebraicGeometry.Scheme.Modules

variable (X : Scheme.{u})

/-- The tensor product of two $\mathcal O_X$-modules: sheafify the presheaf
tensor product of the underlying presheaves-of-modules.

The instance lookup for `MonoidalCategoryStruct (PresheafOfModules R₀)` requires
`R₀` to syntactically present as `R ⋙ forget₂ CommRingCat RingCat`. Since
`X.ringCatSheaf.obj = X.sheaf.val ⋙ forget₂ CommRingCat RingCat` only
definitionally (through `sheafCompose`), we use `show` to expose the form. -/
noncomputable def tensorObj (M N : X.Modules) : X.Modules :=
  letI : MonoidalCategoryStruct (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategoryStruct
      (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
      inferInstance
  (_root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
    ((Modules.toPresheafOfModules X).obj M ⊗ (Modules.toPresheafOfModules X).obj N)

/-- The presheaf-to-sheaf sheafification functor for `X.Modules`. Abbreviated `L`
in comments. -/
noncomputable abbrev sheafificationFunctor :
    _root_.PresheafOfModules.{u} X.ringCatSheaf.obj ⥤ X.Modules :=
  _root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)

/-- The morphism property in `PresheafOfModules X.ringCatSheaf.obj` consisting of
morphisms inverted by sheafification. By `Adjunction.isLocalization` together with
fullness/faithfulness of the right adjoint (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`),
the sheafification functor is a localization at this class. -/
noncomputable abbrev W : MorphismProperty
    (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
  (MorphismProperty.isomorphisms _).inverseImage (sheafificationFunctor X)

/-- Sheafification is a localization at `W`. Follows from `Adjunction.isLocalization`
since the right adjoint of `sheafification (𝟙 _)` is Full + Faithful. -/
noncomputable instance sheafificationIsLocalization :
    (sheafificationFunctor X).IsLocalization (W X) :=
  (_root_.PresheafOfModules.sheafificationAdjunction
    (𝟙 X.ringCatSheaf.obj)).isLocalization

/-- GAP-FILL: sheafification of `PresheafOfModules` sends presheaf-tensor whiskering
of an iso-inverted morphism to an iso. This is the single semantic gap-fill
needed to invoke the `LocalizedMonoidal` machinery (`CategoryTheory.Localization.Monoidal`)
on the sheafification functor.

Mathematical content. The class `W X` of morphisms in `PresheafOfModules X.ringCatSheaf.obj`
inverted by sheafification is stable under left- and right-whiskering by any presheaf-of-modules.
This holds because sheafification is a left adjoint to a fully-faithful right adjoint, and the
presheaf tensor product `tensorLeft`/`tensorRight` are colimit-preserving bifunctors on each
variable (see `PresheafOfModules.tensorLeft.PreservesColimitsOfSize` in
`Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean:237,243`).

Closing this `IsMonoidal` instance below the level of `MorphismProperty.IsMonoidal.mk'` reduces
to the iso-stability of `sheafification` under presheaf-tensor whiskering, which is the analog
for `PresheafOfModules` of `GrothendieckTopology.W.monoidal` for fixed-value sheaves
(`Mathlib/CategoryTheory/Sites/Monoidal.lean:149`). The latter is proved via internal-hom
adjunction; the `PresheafOfModules` version needs the same technique but adapted to the
varying-value-category setting — substantial Mathlib infrastructure not currently present.
Marked sorry until the upstream gap is filled. -/
noncomputable instance instIsMonoidal_W : (W X).IsMonoidal := by
  letI : MonoidalCategory (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategory
      (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
      inferInstance
  refine MorphismProperty.IsMonoidal.mk' _ ?_
  intro X₁ X₂ Y₁ Y₂ f g hf hg
  -- `hf hg` say `sheafification f` and `sheafification g` are isos in `X.Modules`.
  -- Goal: `sheafification (f ⊗ₘ g)` is an iso. Substantive: needs iso-stability of
  -- sheafification under presheaf-tensor whiskering. See declaration docstring.
  sorry

/-- The symmetric monoidal category structure on `X.Modules`: derived from the
`LocalizedMonoidal` machinery applied to the sheafification functor
`L : PresheafOfModules X.ringCatSheaf.obj ⥤ X.Modules` at the class `W X` of morphisms
inverted by `L`, with unit `L.obj (𝟙_ presheaf)` and `ε := Iso.refl _`.

The localization's `tensorObj` is `((tensorBifunctor L W ε).obj M).obj N`, which is
naturally isomorphic to (but not definitionally equal to) the `tensorObj` defined above
as `L.obj (F.obj M ⊗ F.obj N)`; both unfold to sheafification of the presheaf tensor. -/
noncomputable instance instMonoidalCategoryStruct :
    MonoidalCategoryStruct (X.Modules) := by
  letI : MonoidalCategory (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategory
      (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
      inferInstance
  exact inferInstanceAs (MonoidalCategoryStruct
    (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))

/-- The pentagon, triangle, and hexagon axioms transfer from the presheaf side
through the localization-monoidal universal property. -/
noncomputable instance instMonoidalCategory :
    MonoidalCategory (X.Modules) := by
  letI : MonoidalCategory (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategory
      (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
      inferInstance
  exact inferInstanceAs (MonoidalCategory
    (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))

end AlgebraicGeometry.Scheme.Modules
