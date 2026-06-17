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

/-- Bridging instance: `PresheafOfModules X.ringCatSheaf.obj` carries the
`MonoidalCategory` structure inherited from `PresheafOfModules.monoidalCategory`
through the definitional equality `X.ringCatSheaf.obj = X.sheaf.obj ⋙ forget₂ ...`.
Needed for `MorphismProperty.IsMonoidal`, `LocalizedMonoidal`, and all downstream
constructions in this file to typecheck. -/
noncomputable instance instMonoidalCategoryPresheaf :
    MonoidalCategory (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
  show MonoidalCategory
    (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
    inferInstance

/-- The presheaf-to-sheaf sheafification functor for `X.Modules`. Abbreviated `L`
in comments. -/
noncomputable abbrev sheafificationFunctor :
    _root_.PresheafOfModules.{u} X.ringCatSheaf.obj ⥤ X.Modules :=
  _root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)

/-- The morphism property in `PresheafOfModules X.ringCatSheaf.obj` consisting of
morphisms inverted by sheafification. By `Adjunction.isLocalization` together with
fullness/faithfulness of the right adjoint of `PresheafOfModules.sheafificationAdjunction`,
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

## Iter-080 investigation (stalks-level route).

The plan-agent recipe for this iteration was to attempt closure via stalks. After
`simp only [MorphismProperty.inverseImage_iff, MorphismProperty.isomorphisms.iff] at hf hg ⊢`
the goal reduces to `IsIso (L (f ⊗ₘ g))` with `hf : IsIso (L f)` and `hg : IsIso (L g)`,
where `L = sheafificationFunctor X`. Applying `MonoidalCategory.tensorHom_def` decomposes
`f ⊗ₘ g = (f ▷ Y₁) ≫ (X₂ ◁ g)`, so `L (f ⊗ₘ g) = L (f ▷ Y₁) ≫ L (X₂ ◁ g)` via
`Functor.map_comp`. The remaining content is `IsIso (L (f ▷ Y₁))` and `IsIso (L (X₂ ◁ g))`
— sheafification preserves whisker-iso.

Mathematically, stalkwise, `(f ▷ Y₁)_x = f_x ⊗_{R₀.stalk x} id_{(Y₁)_x}` in `ModuleCat`
over the stalk ring. Tensoring with the identity preserves isos in any monoidal category.
Combined with `WEqualsLocallyBijective` (an iso after sheafification ⟺ locally bijective
⟺ stalkwise iso), this gives `IsIso (L (f ▷ Y₁))` from `IsIso (L f)`.

The blocker is the precise Mathlib identification:
`(M ⊗_psh N).stalk x ≅ M.stalk x ⊗_{R₀.stalk x} N.stalk x`
(stalks-of-presheaf-tensor = tensor-of-stalks, over the stalk ring, in the varying-ring
setting). Mathlib has the analogous statement for fixed-ring `ModuleCat R` (see
`Mathlib/Algebra/Category/ModuleCat/Tilde.lean`), and stalks-commute-with-colimits is
abstractly available, but the explicit identification for `PresheafOfModules R₀` with
varying `R₀` is absent from `Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafify.lean`
and the surrounding modules — searches via `lean_leansearch` for "stalk presheaf tensor"
and grep for "stalk.*tensor" in `Mathlib/Algebra/Category` return nothing.

Alternative routes investigated and ruled out (preserved from iter-079):
- `tensorHom_def` decomposition alone is circular at the abstract level — it reduces to
  the same whiskerLeft/whiskerRight closure question.
- `sheafificationCompToSheaf` (sheafification of `PresheafOfModules` = sheafification of
  underlying abelian-grp presheaves) gives an iso-detection in `AddCommGrpCat`, but the
  tensor products on the two sides do not commute (`PresheafOfModules` tensor is
  $R_0(U)$-balanced, `AddCommGrpCat` tensor is $\mathbb{Z}$-balanced), so the iso-stability
  question on the abelian-grp side does not transfer to the module side under tensor.
- Closedness via internal hom requires `MonoidalClosed (PresheafOfModules R₀)`, which
  Mathlib provides only for fixed-ring `ModuleCat R`
  (`Mathlib.Algebra.Category.ModuleCat.Monoidal.Closed`), not for varying-ring
  `PresheafOfModules R₀`. A multi-PR Mathlib upstream effort would be needed.

Marked sorry until the upstream gap (stalk-of-presheaf-tensor in the varying-ring setting)
is filled. Per user policy 2026-05-11, no project-local helper lemma may be introduced to
bridge it — the closure must remain Mathlib-only.

Note: this sorry does NOT block downstream consumers, which use `MonoidalCategory X.Modules`
(set up by `instMonoidalCategoryStruct` + `instMonoidalCategory` below, both fully closed
iter-079 via `LocalizedMonoidal`). Only consumers that take `(W X).IsMonoidal` as an
explicit hypothesis would be affected, and there are none in the project. Phase C step C1
(LineBundle refinement) is unblocked. -/
noncomputable instance instIsMonoidal_W : (W X).IsMonoidal := by
  -- `IsMonoidal.mk'` reduces to: if `L f` and `L g` are isos in `X.Modules`,
  -- then `L (f ⊗ₘ g)` is also iso. Substantive content: iso-stability of
  -- sheafification under presheaf-tensor whiskering. See docstring.
  refine MorphismProperty.IsMonoidal.mk' _ fun {X₁ X₂ Y₁ Y₂} f g hf hg => ?_
  simp only [MorphismProperty.inverseImage_iff,
    MorphismProperty.isomorphisms.iff] at hf hg ⊢
  sorry

/-- The symmetric monoidal category structure on `X.Modules`: derived from the
`LocalizedMonoidal` machinery applied to the sheafification functor
`L : PresheafOfModules X.ringCatSheaf.obj ⥤ X.Modules` at the class `W X` of morphisms
inverted by `L`, with unit `L.obj (𝟙_ presheaf)` and `ε := Iso.refl _`.

The localization's `tensorObj` is `((tensorBifunctor L W ε).obj M).obj N`, which is
naturally isomorphic to (but not definitionally equal to) the `tensorObj` defined above
as `L.obj (F.obj M ⊗ F.obj N)`; both unfold to sheafification of the presheaf tensor. -/
noncomputable instance instMonoidalCategoryStruct :
    MonoidalCategoryStruct (X.Modules) :=
  inferInstanceAs (MonoidalCategoryStruct
    (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))

/-- The pentagon, triangle, and hexagon axioms transfer from the presheaf side
through the localization-monoidal universal property. -/
noncomputable instance instMonoidalCategory :
    MonoidalCategory (X.Modules) :=
  inferInstanceAs (MonoidalCategory
    (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))

end AlgebraicGeometry.Scheme.Modules
