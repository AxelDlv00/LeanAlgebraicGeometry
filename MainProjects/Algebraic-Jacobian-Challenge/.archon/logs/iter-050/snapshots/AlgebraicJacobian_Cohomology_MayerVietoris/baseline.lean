/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
import Mathlib.CategoryTheory.Limits.Preorder

/-!
# Mayer-Vietoris long exact sequence for `ModuleCat k`-valued sheaf cohomology

This file extracts (iter-027 split) the Mayer-Vietoris LES infrastructure for
`Sheaf J (ModuleCat.{u} k)`-valued cohomology, mirroring Mathlib's
`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean` and
`Mathlib/CategoryTheory/Sites/MayerVietorisSquare.lean` line-by-line for the
`ModuleCat k` flavor. The carrier definitions (`HModule`, `HModule'`, etc.) live
in `AlgebraicJacobian.Cohomology.StructureSheafModuleK` and are imported.

The build-out is the cohort iter-016 → iter-026:

* iter-016: functorial wrappers `HModule'_cohomologyPresheafFunctor` and
  `HModule'_cohomologyPresheaf`.
* iter-017: building blocks `HModule'_toBiprod` and `HModule'_fromBiprod`.
* iter-018: composition-is-zero lemma `HModule'_toBiprod_fromBiprod`.
* iter-019: short-complex carrier `HModule'_shortComplex` plus the helpers
  `HModule'_isPushoutModuleCatFreeSheaf` and `(ModuleCat.free k).IsLeftAdjoint`.
* iter-020: short-exact infrastructure (`Mono`, `Epi`, `Exact`, `ShortExact`)
  plus the helper `(ModuleCat.free k).PreservesMonomorphisms`.
* iter-021: connecting hom `HModule'_δ`.
* iter-022: LES sequence `HModule'_sequence`.
* iter-023: technical heart (4 auxiliary lemmas + comparison iso
  `HModule'_sequenceIso`).
* iter-026: exactness theorem `HModule'_sequence_exact` plus
  `δ`-zero simp companions `HModule'_δ_toBiprod` and `HModule'_fromBiprod_δ`.

See `blueprint/src/chapters/Cohomology_MayerVietoris.tex`.
-/

set_option autoImplicit false

universe u v w w'

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

/-! ## Iter-034 Mathlib gap-fill: `Abelian.Ext.chgUniv` as a `LinearEquiv`

Mathlib's `Abelian.Ext.chgUniv : Ext.{w} X Y n ≃ Ext.{w'} X Y n`
(`Mathlib/Algebra/Homology/DerivedCategory/Ext/Basic.lean` L540) is a bare
`Equiv` only. The iter-034 universe-bridge `HModule'_eq_HModule_linearEquiv`
(below in `section CoverTotality`) requires it as a `LinearEquiv` over the
`Linear R C`-enriched abelian category. The upgrade is mechanical: the
`AddCommGroup (Ext X Y n)` and `Module R (Ext X Y n)` instances are themselves
transferred from the standard derived category through `homEquiv`, and
Mathlib's load-bearing intermediate lemma `Ext.homEquiv_chgUniv` (Basic.lean
L543–545) shows that `chgUniv` preserves the underlying derived-category
morphism. So `chgUniv` automatically commutes with `+` and `•`. Two short
helper lemmas (`chgUniv_add` and `chgUniv_smul`) plus a 7-line `LinearEquiv`
structure literal give the upgrade.

This cohort lives outside `namespace AlgebraicGeometry.Scheme` because the
helpers belong to the `CategoryTheory.Abelian.Ext` namespace. We use the
qualified-name pattern `Abelian.Ext.foo` rather than wrapping the entire file
in a second namespace block. -/

/-- Iter-034 Mathlib gap-fill (a): `Abelian.Ext.chgUniv` is additive. The
underlying `homEquiv` (`Mathlib/Algebra/Homology/DerivedCategory/Ext/Basic.lean`
L162) is preserved by `chgUniv` (Mathlib lemma `Ext.homEquiv_chgUniv`,
L543–545), and the `AddCommGroup (Ext X Y n)` instance (L241–243) is defined by
transferring the `AddCommGroup` from the standard derived category through
`homEquiv`. Combining these via the `Ext.ext` extensionality (L177–179) gives
additivity. -/
private lemma Abelian.Ext.chgUniv_add
    {C : Type*} [Category C] [Abelian C]
    [HasExt.{w} C] [HasExt.{w'} C] {X Y : C} {n : ℕ} (a b : Abelian.Ext.{w} X Y n) :
    Abelian.Ext.chgUniv.{w'} (a + b) =
      Abelian.Ext.chgUniv.{w'} a + Abelian.Ext.chgUniv.{w'} b := by
  letI := HasDerivedCategory.standard C
  ext
  rw [Abelian.Ext.add_hom, ← Abelian.Ext.homAddEquiv_apply,
      ← Abelian.Ext.homAddEquiv_apply, ← Abelian.Ext.homAddEquiv_apply]
  change Abelian.Ext.homEquiv (Abelian.Ext.chgUniv.{w'} (a + b)) =
    Abelian.Ext.homEquiv (Abelian.Ext.chgUniv.{w'} a) +
      Abelian.Ext.homEquiv (Abelian.Ext.chgUniv.{w'} b)
  rw [Abelian.Ext.homEquiv_chgUniv, Abelian.Ext.homEquiv_chgUniv,
      Abelian.Ext.homEquiv_chgUniv, ← Abelian.Ext.add_hom]

/-- Iter-034 Mathlib gap-fill (b): `Abelian.Ext.chgUniv` is `R`-linear when `C`
is `Linear R`-enriched. Same proof shape as `chgUniv_add`, but using
`smul_hom` (`Mathlib/Algebra/Homology/DerivedCategory/Ext/Linear.lean` L52–55)
in place of `add_hom`. -/
private lemma Abelian.Ext.chgUniv_smul
    {R : Type*} [Ring R] {C : Type*} [Category C] [Abelian C] [Linear R C]
    [HasExt.{w} C] [HasExt.{w'} C] {X Y : C} {n : ℕ}
    (r : R) (a : Abelian.Ext.{w} X Y n) :
    Abelian.Ext.chgUniv.{w'} (r • a) = r • Abelian.Ext.chgUniv.{w'} a := by
  letI := HasDerivedCategory.standard C
  ext
  rw [Abelian.Ext.smul_hom, ← Abelian.Ext.homAddEquiv_apply,
      ← Abelian.Ext.homAddEquiv_apply]
  change Abelian.Ext.homEquiv (Abelian.Ext.chgUniv.{w'} (r • a)) =
    r • Abelian.Ext.homEquiv (Abelian.Ext.chgUniv.{w'} a)
  rw [Abelian.Ext.homEquiv_chgUniv, Abelian.Ext.homEquiv_chgUniv,
      ← Abelian.Ext.smul_hom]

/-- Iter-034 Mathlib gap-fill (c): the `R`-linear upgrade of Mathlib's bare-`Equiv`
`Abelian.Ext.chgUniv : Ext.{w} X Y n ≃ Ext.{w'} X Y n` to a `LinearEquiv`,
when `C` is `Linear R`-enriched abelian. Combines (a) and (b). The
`Mathlib/Algebra/Homology/DerivedCategory/Ext/Basic.lean` L540 declaration is
universe-polymorphic but only proves the underlying bijection; this wrapper
adds the algebraic structure preservation needed for downstream `LinearEquiv`
chaining (specifically, the iter-034 universe bridge
`HModule'_eq_HModule_linearEquiv` below). -/
noncomputable def Abelian.Ext.chgUnivLinearEquiv
    {R : Type*} [Ring R] {C : Type*} [Category C] [Abelian C] [Linear R C]
    [HasExt.{w} C] [HasExt.{w'} C] {X Y : C} {n : ℕ} :
    Abelian.Ext.{w} X Y n ≃ₗ[R] Abelian.Ext.{w'} X Y n where
  toFun a := Abelian.Ext.chgUniv.{w'} a
  invFun a := Abelian.Ext.chgUniv.{w} a
  left_inv a := Abelian.Ext.chgUniv.{w'}.left_inv a
  right_inv a := Abelian.Ext.chgUniv.{w'}.right_inv a
  map_add' a b := Abelian.Ext.chgUniv_add a b
  map_smul' r a := Abelian.Ext.chgUniv_smul r a

namespace AlgebraicGeometry.Scheme

/-- Phase A step 6 *Path 2* (iter-016): the substantive functor mirroring
Mathlib's `Sheaf.cohomologyPresheafFunctor` for the `ModuleCat k` flavor. Sends
a sheaf `F : Sheaf J (ModuleCat k)` to the presheaf
`X ↦ Ext^n((presheafToSheaf J _).obj ((yoneda ⋙ ModuleCat.free k).obj X), F)`,
i.e.\ to a presheaf `Cᵒᵖ ⥤ AddCommGrpCat` whose value at `op X` is
`HModule' k F n X` (definitionally, see `HModule'_cohomologyPresheaf` below).

The codomain is `Cᵒᵖ ⥤ AddCommGrpCat` (not `Cᵒᵖ ⥤ ModuleCat k`) because Mathlib's
`Abelian.extFunctor n : Cᵒᵖ ⥤ C ⥤ AddCommGrpCat` always lands in `AddCommGrpCat`
regardless of the source category's `Linear`-enrichment; the per-fiber `Module k`
structure on `(HModule'_cohomologyPresheaf k F n).obj (op X)` is preserved
through the iter-014 `HModule'` reducibility chain. Probe-confirmed body
(iter-016 plan-agent). Used downstream as the prerequisite for the queued
iter-017+ `ModuleCat k`-flavored Mayer-Vietoris LES. -/
noncomputable def HModule'_cohomologyPresheafFunctor
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] (J : GrothendieckTopology C)
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (n : ℕ) :
    Sheaf J (ModuleCat.{u} k) ⥤ Cᵒᵖ ⥤ AddCommGrpCat :=
  Functor.flip
    ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k) ⋙
      presheafToSheaf _ _).op ⋙ Abelian.extFunctor n)

/-- Phase A step 6 *Path 2* (iter-016): the abbrev wrapper mirroring Mathlib's
`Sheaf.cohomologyPresheaf` for the `ModuleCat k` flavor. Evaluates the
`HModule'_cohomologyPresheafFunctor` at a sheaf `F`, giving a presheaf
`Cᵒᵖ ⥤ AddCommGrpCat` whose value at `op X` is `HModule' k F n X` definitionally
(probe-confirmed `rfl` by the iter-016 plan-agent). The `noncomputable abbrev`
form is required for the per-fiber definitional identification with `HModule'`;
under `def` the wrapper would block the `rfl`-level reduction that downstream
Mayer-Vietoris and Stein-factorization arguments rely on. -/
noncomputable abbrev HModule'_cohomologyPresheaf
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) :
    Cᵒᵖ ⥤ AddCommGrpCat :=
  (HModule'_cohomologyPresheafFunctor k J n).obj F

/-- Phase A step 6 *Path 2* (iter-017): the first Mayer-Vietoris LES building
block on the `ModuleCat k` side — the sum of the two restriction maps
`(cohomologyPresheaf F n).map S.f₂₄.op` and `(cohomologyPresheaf F n).map S.f₃₄.op`,
as a single map into the biproduct. Direct mirror of Mathlib's
`GrothendieckTopology.MayerVietorisSquare.toBiprod` (file
`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`, L43–46) for
the `ModuleCat k` flavor with `F.cohomologyPresheaf → HModule'_cohomologyPresheaf k F`.

The codomain `(... ).obj (op S.X₂) ⊞ (...).obj (op S.X₃)` is the biproduct in
`AddCommGrpCat` (Mathlib `Mathlib/Algebra/Category/Grp/Biproducts.lean`); since
`HModule'_cohomologyPresheaf k F n` is `Cᵒᵖ ⥤ AddCommGrpCat`, the biproduct
auto-resolves. Probe-confirmed body (iter-017 plan-agent). Used downstream as the
first of three Mayer-Vietoris LES building blocks; iter-018 will add the
composition-is-zero lemma and the connecting hom `δ`, iter-019 the LES sequence
and exactness theorem. -/
noncomputable def HModule'_toBiprod
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) :
    (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₄) ⟶
      (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₂) ⊞
        (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₃) :=
  biprod.lift ((HModule'_cohomologyPresheaf k F n).map S.f₂₄.op)
              ((HModule'_cohomologyPresheaf k F n).map S.f₃₄.op)

/-- Phase A step 6 *Path 2* (iter-017): the second Mayer-Vietoris LES building
block on the `ModuleCat k` side — the difference of the two restriction maps
`(cohomologyPresheaf F n).map S.f₁₂.op` and `(cohomologyPresheaf F n).map S.f₁₃.op`,
as a single map out of the biproduct. Direct mirror of Mathlib's
`GrothendieckTopology.MayerVietorisSquare.fromBiprod` (file
`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`, L67–70) for
the `ModuleCat k` flavor.

The negation `-(HModule'_cohomologyPresheaf k F n).map S.f₁₃.op` uses the
preadditive structure on `AddCommGrpCat`-morphisms; the sign is the standard
Mayer-Vietoris convention encoding the alternating-sum structure of the Čech
complex. Probe-confirmed body (iter-017 plan-agent). -/
noncomputable def HModule'_fromBiprod
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) :
    (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₂) ⊞
        (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₃) ⟶
      (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₁) :=
  biprod.desc ((HModule'_cohomologyPresheaf k F n).map S.f₁₂.op)
              (-(HModule'_cohomologyPresheaf k F n).map S.f₁₃.op)

/-- Phase A step 6 *Path 2* (iter-018): the third Mayer-Vietoris LES building
block on the `ModuleCat k` side — the composition-is-zero lemma asserting
`HModule'_toBiprod k S F n ≫ HModule'_fromBiprod k S F n = 0`. Direct mirror
of Mathlib's `GrothendieckTopology.MayerVietorisSquare.toBiprod_fromBiprod`
(file `Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`,
L72–75) for the `ModuleCat k` flavor.

The proof unwinds via the biproduct universal property
(`biprod.lift_desc : biprod.lift a b ≫ biprod.desc c d = a ≫ c + b ≫ d`),
the preadditive negation (`Preadditive.comp_neg`), the addition-of-negation
arithmetic (`← sub_eq_add_neg`), the zero-iff-equal arithmetic
(`sub_eq_zero`), the contravariant functoriality of `cohomologyPresheaf`
(`← Functor.map_comp`, `← op_comp`), and the Mayer-Vietoris square
factorisation `S.toSquare.fac` (which says `S.f₁₂ ≫ S.f₂₄ = S.f₁₃ ≫ S.f₃₄`).
Probe-confirmed proof (iter-018 plan-agent); the `simp only` set transfers
verbatim from Mathlib's `AddCommGrpCat`-flavored proof because every step
is value-category-agnostic.

The `@[reassoc (attr := simp)]` attribute generates the post-composition
form `… ≫ HModule'_fromBiprod … ≫ Z = 0 ≫ Z = 0` and registers the lemma
as a `simp` lemma; both are required for downstream Mayer-Vietoris LES
exactness arguments. -/
@[reassoc (attr := simp)]
lemma HModule'_toBiprod_fromBiprod
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) :
    HModule'_toBiprod k S F n ≫ HModule'_fromBiprod k S F n = 0 := by
  simp only [HModule'_toBiprod, HModule'_fromBiprod, biprod.lift_desc,
    Preadditive.comp_neg, ← sub_eq_add_neg, sub_eq_zero,
    ← Functor.map_comp, ← op_comp, S.toSquare.fac]

/-- Phase A step 6 *Path 2* (iter-019 helper, Mathlib gap-fill): `ModuleCat.free k`
is left adjoint to `forget (ModuleCat k)`. Mathlib's
`Mathlib/Algebra/Category/ModuleCat/Adjunctions.lean` provides the adjunction
`ModuleCat.adj k : ModuleCat.free k ⊣ forget (ModuleCat k)` but does not register
the corresponding `IsLeftAdjoint` instance (whereas `AddCommGrpCat.free.IsLeftAdjoint`
is registered in `Mathlib/Algebra/Category/Grp/Adjunctions.lean` L84). This
project-local instance fills the gap so that `Sheaf.composeAndSheafify J (ModuleCat.free k)`
acquires the necessary `PreservesColimit` instance, used by
`HModule'_isPushoutModuleCatFreeSheaf` below. -/
instance ModuleCat_free_isLeftAdjoint
    (k : Type u) [Field k] : (ModuleCat.free k).IsLeftAdjoint :=
  ⟨_, ⟨ModuleCat.adj k⟩⟩

/-- Phase A step 6 *Path 2* (iter-019): the `ModuleCat k`-flavored
pushout-of-free-sheaves analog of Mathlib's
`GrothendieckTopology.MayerVietorisSquare.isPushoutAddCommGrpFreeSheaf`
(file `Mathlib/CategoryTheory/Sites/MayerVietorisSquare.lean`, L154–160).
States that the image of the Mayer-Vietoris square `S` under the composite
`yoneda ⋙ Functor.whiskeringRight ⋅ (ModuleCat.free k) ⋙ presheafToSheaf J _`
is a pushout square in `Sheaf J (ModuleCat k)`. The proof transfers the
type-level pushout `S.isPushout` through `Sheaf.composeAndSheafify J (ModuleCat.free k)`
(which preserves pushouts because `(ModuleCat.free k).IsLeftAdjoint`, registered
in `ModuleCat_free_isLeftAdjoint` above) and adjusts via the canonical iso
`presheafToSheafCompComposeAndSheafifyIso`.

Probe-confirmed body (iter-019 plan-agent); the proof is verbatim from Mathlib L156–160
with `AddCommGrpCat.free → ModuleCat.free k`. Used downstream in iter-020+ to
prove `Mono` / `Epi` / `Exact` instances on the iter-019 short complex
`HModule'_shortComplex`, and ultimately in the iter-022+ `δ` connecting hom. -/
lemma HModule'_isPushoutModuleCatFreeSheaf
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    (S.map (yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k) ⋙
      presheafToSheaf J _)).IsPushout :=
  (S.isPushout.map (Sheaf.composeAndSheafify J (ModuleCat.free k))).of_iso
    ((Square.mapFunctor.mapIso
      (presheafToSheafCompComposeAndSheafifyIso J (ModuleCat.free k))).app
        (S.map yoneda))

/-- Phase A step 6 *Path 2* (iter-019): the `ModuleCat k`-flavored
short complex of free sheaves underlying the Mayer-Vietoris LES.
Direct mirror of Mathlib's `GrothendieckTopology.MayerVietorisSquare.shortComplex`
(file `Mathlib/CategoryTheory/Sites/MayerVietorisSquare.lean`, L234–249) for the
`ModuleCat k` flavor with `AddCommGrpCat.free → ModuleCat.free k`.

The objects are the sheafified free `ModuleCat k`-valued presheaves on the four
vertices of the Mayer-Vietoris square (with the middle pair `S.X₂` and `S.X₃`
biproduct-summed). The two morphisms are: `f` (the difference `(yoneda.map S.f₁₂)
– (yoneda.map S.f₁₃)` lifted through the biproduct), and `g` (the sum
`(yoneda.map S.f₂₄) + (yoneda.map S.f₃₄)` desced through the biproduct).
The `zero` proof (i.e.\ `f ≫ g = 0`) follows from the
`cokernelCofork.condition` of the pushout square in
`HModule'_isPushoutModuleCatFreeSheaf` above.

Probe-confirmed body (iter-019 plan-agent); structure-literal mirror of Mathlib L235–249
with `AddCommGrpCat.free → ModuleCat.free k`. The `@[simps]` attribute generates
field-projection simp lemmas (`HModule'_shortComplex_X₁`, `..._X₂`, `..._X₃`,
`..._f`, `..._g`) consumed by the iter-020+ `Mono`/`Epi`/`Exact`/`ShortExact`
proofs and the iter-022+ `δ` definition. -/
@[simps]
noncomputable def HModule'_shortComplex
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    ShortComplex (Sheaf J (ModuleCat.{u} k)) where
  X₁ := (presheafToSheaf J _).obj (yoneda.obj S.X₁ ⋙ ModuleCat.free k)
  X₂ := (presheafToSheaf J _).obj (yoneda.obj S.X₂ ⋙ ModuleCat.free k) ⊞
    (presheafToSheaf J _).obj (yoneda.obj S.X₃ ⋙ ModuleCat.free k)
  X₃ := (presheafToSheaf J _).obj (yoneda.obj S.X₄ ⋙ ModuleCat.free k)
  f :=
    biprod.lift
      ((presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₁₂) _))
      (-(presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₁₃) _))
  g :=
    biprod.desc
      ((presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₂₄) _))
      ((presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₃₄) _))
  zero :=
    (S.map (yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k) ⋙
        presheafToSheaf J _)).cokernelCofork.condition

/-- Phase A step 6 *Path 2* (iter-020 helper, Mathlib gap-fill): the free-module
functor `ModuleCat.free k : Type u ⥤ ModuleCat.{u} k` preserves monomorphisms.
Mathlib registers `AddCommGrpCat.instPreservesMonomorphismsFree :
AddCommGrpCat.free.PreservesMonomorphisms` in
`Mathlib/Algebra/Category/Grp/Adjunctions.lean` but does not register the
corresponding instance for `ModuleCat.free k` in
`Mathlib/Algebra/Category/ModuleCat/Adjunctions.lean`. This project-local
instance fills the gap so that, after `simp only [biprod.lift_snd]`, the
typeclass-search engine can discharge the residual `Mono` goal in the proof
of `HModule'_shortComplex_f_mono` below.

The proof: for an injective function `f : X → Y` between types,
`(ModuleCat.free k).map f = ModuleCat.ofHom (Finsupp.lmapDomain k k f)` (defeq),
and `Finsupp.mapDomain f` is injective on `Finsupp X k → Finsupp Y k` by
Mathlib's `Finsupp.mapDomain_injective`. Bridging via `ModuleCat.mono_iff_injective`
recovers `Mono` in `ModuleCat k`. -/
instance ModuleCat_free_preservesMonomorphisms
    (k : Type u) [Field k] : (ModuleCat.free k).PreservesMonomorphisms := by
  refine ⟨fun {X Y} f hf ↦ ?_⟩
  have hf' : Function.Injective f := (CategoryTheory.mono_iff_injective f).mp hf
  rw [ModuleCat.mono_iff_injective]
  exact Finsupp.mapDomain_injective hf'

-- Phase A step 6 *Path 2* (iter-020): `(HModule'_shortComplex k S).f` is a
-- monomorphism in `Sheaf J (ModuleCat k)`. Direct mirror of Mathlib's
-- `MayerVietorisSquare.lean` L251–257 with `AddCommGrpCat.free → ModuleCat.free k`.
-- The `set_option backward.isDefEq.respectTransparency false in` attribute is
-- required because the typeclass-search engine needs to unfold the `dsimp`-normal
-- form of `(HModule'_shortComplex k S).f` past structure-literal projection.
set_option backward.isDefEq.respectTransparency false in
instance HModule'_shortComplex_f_mono
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    Mono (HModule'_shortComplex k S).f := by
  have : Mono ((HModule'_shortComplex k S).f ≫ biprod.snd) := by
    dsimp
    simp only [biprod.lift_snd]
    infer_instance
  exact mono_of_mono _ biprod.snd

/-- Phase A step 6 *Path 2* (iter-020): `(HModule'_shortComplex k S).g` is an
epimorphism in `Sheaf J (ModuleCat k)`. Direct mirror of Mathlib's
`MayerVietorisSquare.lean` L259–261 with `AddCommGrpCat.free → ModuleCat.free k`.
The proof is a one-line term-mode body using
`ShortComplex.exact_and_epi_g_iff_g_is_cokernel` and the iter-019 lemma
`HModule'_isPushoutModuleCatFreeSheaf`'s `isColimitCokernelCofork` accessor. -/
instance HModule'_shortComplex_g_epi
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    Epi (HModule'_shortComplex k S).g :=
  ((HModule'_shortComplex k S).exact_and_epi_g_iff_g_is_cokernel.2
    ⟨(HModule'_isPushoutModuleCatFreeSheaf k S).isColimitCokernelCofork⟩).2

/-- Phase A step 6 *Path 2* (iter-020): `(HModule'_shortComplex k S).Exact`,
i.e. the kernel of `g` equals the image of `f` in `Sheaf J (ModuleCat k)`.
Direct mirror of Mathlib's `MayerVietorisSquare.lean` L263–265 with
`AddCommGrpCat.free → ModuleCat.free k`. The proof is a one-line term-mode
body using `ShortComplex.exact_of_g_is_cokernel` and the iter-019 lemma
`HModule'_isPushoutModuleCatFreeSheaf`'s `isColimitCokernelCofork` accessor. -/
lemma HModule'_shortComplex_exact
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    (HModule'_shortComplex k S).Exact :=
  ShortComplex.exact_of_g_is_cokernel _
    (HModule'_isPushoutModuleCatFreeSheaf k S).isColimitCokernelCofork

/-- Phase A step 6 *Path 2* (iter-020): `(HModule'_shortComplex k S).ShortExact`,
the short-exact predicate (combining `Mono f`, `Epi g`, and `Exact`) in
`Sheaf J (ModuleCat k)`. Direct mirror of Mathlib's `MayerVietorisSquare.lean`
L267–268 with `AddCommGrpCat.free → ModuleCat.free k`. The proof is a one-line
anonymous-constructor: the `Mono f` and `Epi g` predicates are typeclass-resolved
from `HModule'_shortComplex_f_mono` and `HModule'_shortComplex_g_epi`, leaving
only the `exact` field which is filled with `HModule'_shortComplex_exact`. The
named lemma is consumed in iter-021+ as `S.HModule'_shortComplex_shortExact.extClass`
to define the connecting hom `HModule'_δ` of the Mayer-Vietoris LES. -/
lemma HModule'_shortComplex_shortExact
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    (HModule'_shortComplex k S).ShortExact where
  exact := HModule'_shortComplex_exact k S

/-- Phase A step 6 *Path 2* (iter-021): the connecting homomorphism `δ` of the
Mayer-Vietoris long exact sequence in `ModuleCat k`-valued sheaf cohomology.
For a Mayer-Vietoris square `S` and adjacent cohomological degrees `n₀ + 1 = n₁`,
the morphism
  δ : (HModule'_cohomologyPresheaf k F n₀).obj (op S.X₁) ⟶
        (HModule'_cohomologyPresheaf k F n₁).obj (op S.X₄)
in `AddCommGrpCat` is the precomposition with the extension class
`(HModule'_shortComplex_shortExact k S).extClass : Ext (...X₁...) (...X₃...) 1`
followed by `AddCommGrpCat.ofHom` to wrap the resulting `AddMonoidHom` as a
categorical morphism. Direct mirror of Mathlib's `MayerVietorisSquare.δ`
(`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean` L112–114)
for the `ModuleCat k` flavor with `AddCommGrpCat.free → ModuleCat.free k`.

The `[HasExt (Sheaf J (ModuleCat.{u} k))]` typeclass is required (the
`Ext.precomp` operation depends on it) and matches the corresponding
requirement on iter-016 `HModule'_cohomologyPresheafFunctor` / `..._cohomologyPresheaf`,
iter-017 `HModule'_toBiprod` / `..._fromBiprod`, and iter-018
`HModule'_toBiprod_fromBiprod`.

This connecting hom is the missing third link of the Mayer-Vietoris exact
sequence: combined with iter-017's `toBiprod` (sum of restriction) and
`fromBiprod` (difference of restriction), iter-018's `toBiprod ≫ fromBiprod = 0`,
and the iter-022+ packaging into a `ComposableArrows`-form sequence + iter-023+
sequence-iso to `Ext.contravariantSequence` + iter-024+ exactness theorem, it
will yield the full LES `... → Hⁿ(X₄) → Hⁿ(X₂) ⊞ Hⁿ(X₃) → Hⁿ(X₁) → Hⁿ⁺¹(X₄) → ...`
in `ModuleCat k`-valued sheaf cohomology. -/
noncomputable def HModule'_δ
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    (HModule'_cohomologyPresheaf k F n₀).obj (Opposite.op S.X₁) ⟶
      (HModule'_cohomologyPresheaf k F n₁).obj (Opposite.op S.X₄) :=
  AddCommGrpCat.ofHom ((HModule'_shortComplex_shortExact k S).extClass.precomp _ (by omega))

/-- Phase A step 6 *Path 2* (iter-022): the Mayer-Vietoris long exact sequence
in `ModuleCat k`-valued sheaf cohomology, packaged as a `ComposableArrows` of
length 5 in `AddCommGrpCat`. The five composable morphisms are, in order,
`HModule'_toBiprod` at degree `n₀`, `HModule'_fromBiprod` at degree `n₀`, the
connecting hom `HModule'_δ` from degree `n₀` to degree `n₁`, `HModule'_toBiprod`
at degree `n₁`, and `HModule'_fromBiprod` at degree `n₁`. Direct mirror of
Mathlib's `MayerVietorisSquare.sequence`
(`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean` L120–122)
for the `ModuleCat k` flavor.

The `noncomputable abbrev` form is load-bearing: downstream `dsimp`-based
unfolding (in iter-023+ `HModule'_sequenceIso` and iter-024+
`HModule'_sequence_exact`) needs to access `mk₅`'s field-projection simp
lemmas through the abbrev. -/
noncomputable abbrev HModule'_sequence
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    ComposableArrows AddCommGrpCat 5 :=
  ComposableArrows.mk₅ (HModule'_toBiprod k S F n₀) (HModule'_fromBiprod k S F n₀)
    (HModule'_δ k S F n₀ n₁ h)
    (HModule'_toBiprod k S F n₁) (HModule'_fromBiprod k S F n₁)

/-- Iter-023 aux lemma 1: explicit elementwise formula for `HModule'_toBiprod`
(mirror Mathlib `MayerVietoris.lean` L48–64). -/
lemma HModule'_toBiprod_apply
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    {n : ℕ} (y : (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₄)) :
    HModule'_toBiprod k S F n y =
      (AddCommGrpCat.biprodIsoProd _ _).inv
        ⟨(HModule'_cohomologyPresheaf k F n).map S.f₂₄.op y,
          (HModule'_cohomologyPresheaf k F n).map S.f₃₄.op y⟩ := by
  apply (AddCommGrpCat.biprodIsoProd _ _).addCommGroupIsoToAddEquiv.injective
  dsimp [HModule'_toBiprod]
  ext
  · rw [Iso.addCommGroupIsoToAddEquiv_apply, Iso.addCommGroupIsoToAddEquiv_apply,
      ← AddCommGrpCat.biprodIsoProd_inv_comp_fst_apply, Iso.hom_inv_id_apply,
      ← ConcreteCategory.comp_apply, biprod.lift_fst, Iso.inv_hom_id_apply]
  · rw [Iso.addCommGroupIsoToAddEquiv_apply, Iso.addCommGroupIsoToAddEquiv_apply,
      ← AddCommGrpCat.biprodIsoProd_inv_comp_snd_apply, Iso.hom_inv_id_apply,
      ← ConcreteCategory.comp_apply, biprod.lift_snd, Iso.inv_hom_id_apply]

/-- Iter-023 aux lemma 2: explicit elementwise formula for `HModule'_fromBiprod`
on the inverse of `biprodIsoProd` (mirror Mathlib L77–83). -/
lemma HModule'_fromBiprod_biprodIsoProd_inv_apply
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    {n : ℕ}
    (y₁ : (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₂))
    (y₂ : (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₃)) :
    HModule'_fromBiprod k S F n
        ((AddCommGrpCat.biprodIsoProd _ _).inv ⟨y₁, y₂⟩) =
      (HModule'_cohomologyPresheaf k F n).map S.f₁₂.op y₁ -
        (HModule'_cohomologyPresheaf k F n).map S.f₁₃.op y₂ := by
  dsimp [HModule'_fromBiprod]
  rw [← ConcreteCategory.comp_apply]
  simp [AddCommGrpCat.biprodIsoProd_inv_comp_desc, sub_eq_add_neg]

-- Iter-023 aux lemma 3: bridges `AddCommGrpCat`-side `biprodIsoProd` and
-- `Ext`-side `Ext.biprodAddEquiv` for the `toBiprod` morphism
-- (mirror Mathlib L85–91). The `set_option ... in` and `attribute ... in`
-- wrappers match Mathlib L85, L86 verbatim.
set_option backward.isDefEq.respectTransparency false in
attribute [local simp] HModule'_toBiprod_apply in
lemma HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    {n : ℕ} (x : (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₄)) :
    Abelian.Ext.biprodAddEquiv.symm
        ((AddCommGrpCat.biprodIsoProd _ _).hom (HModule'_toBiprod k S F n x)) =
      (Abelian.Ext.mk₀ (HModule'_shortComplex k S).g).comp x (zero_add n) :=
  Abelian.Ext.biprodAddEquiv.injective (by cat_disch)

-- Iter-023 aux lemma 4: bridges the same machinery for the `fromBiprod`
-- morphism (mirror Mathlib L93–106).
set_option backward.isDefEq.respectTransparency false in
attribute [local simp] sub_eq_add_neg in
lemma HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    {n : ℕ}
    (x : ↑((HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₂) ⊞
           (HModule'_cohomologyPresheaf k F n).obj (Opposite.op S.X₃))) :
    (Abelian.Ext.mk₀ (HModule'_shortComplex k S).f).comp
        (Abelian.Ext.biprodAddEquiv.symm
          ((AddCommGrpCat.biprodIsoProd _ _).hom x)) (zero_add n) =
      (HModule'_fromBiprod k S F n x) := by
  obtain ⟨⟨x₂, x₃⟩, rfl⟩ :=
    (AddCommGrpCat.biprodIsoProd _ _).addCommGroupIsoToAddEquiv.symm.surjective x
  dsimp
  rw [Abelian.Ext.biprodAddEquiv_symm_apply,
    Iso.addCommGroupIsoToAddEquiv_symm_apply,
    HModule'_fromBiprod_biprodIsoProd_inv_apply]
  cat_disch

-- Iter-023 main: comparison iso from the iter-022 LES sequence to
-- `Ext.contravariantSequence` (mirror Mathlib L124–138). The technical heart
-- of the Mayer-Vietoris LES.
set_option backward.isDefEq.respectTransparency false in
noncomputable def HModule'_sequenceIso
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    HModule'_sequence k S F n₀ n₁ h ≅
      Abelian.Ext.contravariantSequence (HModule'_shortComplex_shortExact k S)
        F n₀ n₁ (by omega) :=
  ComposableArrows.isoMk₅ (Iso.refl _)
    ((AddCommGrpCat.biprodIsoProd _ _).trans
      (Abelian.Ext.biprodAddEquiv.symm).toAddCommGrpIso)
    (Iso.refl _) (Iso.refl _)
    ((AddCommGrpCat.biprodIsoProd _ _).trans
      (Abelian.Ext.biprodAddEquiv.symm).toAddCommGrpIso)
    (Iso.refl _)
    (by ext; apply HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply)
    (by ext; symm; apply HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom)
    (by dsimp; rw [Category.comp_id, Category.id_comp]; rfl)
    (by ext; apply HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply)
    (by ext; symm; apply HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom)

/-- Iter-026: Mayer-Vietoris LES exactness theorem (mirror Mathlib
`MayerVietoris.lean` L140–141). The iter-022 sequence is exact via the iter-023
comparison iso to `Ext.contravariantSequence`. -/
lemma HModule'_sequence_exact
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    (HModule'_sequence k S F n₀ n₁ h).Exact :=
  ComposableArrows.exact_of_iso (HModule'_sequenceIso k S F n₀ n₁ h).symm
    (Abelian.Ext.contravariantSequence_exact _ _ _ _ _)

/-- Iter-026: `δ ≫ toBiprod = 0` simp companion (mirror Mathlib L143–145). -/
@[reassoc (attr := simp)]
lemma HModule'_δ_toBiprod
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    HModule'_δ k S F n₀ n₁ h ≫ HModule'_toBiprod k S F n₁ = 0 :=
  (HModule'_sequence_exact k S F n₀ n₁ h).zero 2

/-- Iter-026: `fromBiprod ≫ δ = 0` simp companion (mirror Mathlib L147–149). -/
@[reassoc (attr := simp)]
lemma HModule'_fromBiprod_δ
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    HModule'_fromBiprod k S F n₀ ≫ HModule'_δ k S F n₀ n₁ h = 0 :=
  (HModule'_sequence_exact k S F n₀ n₁ h).zero 1

section AffineCoverMVSquare

/-- Phase A step 6 *Path 2* (iter-028): a bundled 2-affine cover of a scheme
together with the affineness of the pairwise intersection. The geometric input
to the abstract Mayer-Vietoris LES `HModule'_sequence_exact` consumes — packaged
to record the affineness conditions and the cover-totality hypothesis that the
abstract MV-square does not capture. The accessor `toMayerVietorisSquare`
produces the underlying Mathlib `MayerVietorisSquare`.

Mathematically: a 2-affine open cover of `X` whose pairwise intersection is also
affine. The cover hypothesis `cover : U₁ ⊔ U₂ = ⊤` is load-bearing for downstream
Serre-finiteness use (it identifies the `MayerVietorisSquare` corner `X₄` with
the whole scheme `X`). -/
structure AffineCoverMVSquare (X : Scheme.{u}) where
  /-- First affine open of the cover. -/
  U₁ : X.Opens
  /-- Second affine open of the cover. -/
  U₂ : X.Opens
  /-- `U₁` is affine. -/
  isAffineOpen_U₁ : IsAffineOpen U₁
  /-- `U₂` is affine. -/
  isAffineOpen_U₂ : IsAffineOpen U₂
  /-- The intersection `U₁ ⊓ U₂` is affine. -/
  isAffineOpen_inf : IsAffineOpen (U₁ ⊓ U₂)
  /-- Total cover: `U₁ ⊔ U₂ = ⊤`. -/
  cover : U₁ ⊔ U₂ = ⊤

/-- Phase A step 6 *Path 2* (iter-028): the underlying abstract Mayer-Vietoris
square produced by a 2-affine cover. Bridge from the geometric input (an
`AffineCoverMVSquare`) to the categorical input (a `MayerVietorisSquare` for
the Grothendieck topology on `Opens X.toTopCat`) the abstract MV-LES theorem
`HModule'_sequence_exact` consumes. The four corners collapse definitionally:
`X₁ = U₁ ⊓ U₂`, `X₂ = U₁`, `X₃ = U₂`, `X₄ = U₁ ⊔ U₂` (each by `rfl`,
plan-agent probe-verified). -/
noncomputable def AffineCoverMVSquare.toMayerVietorisSquare {X : Scheme.{u}}
    (S : X.AffineCoverMVSquare) :
    (Opens.grothendieckTopology X.toTopCat).MayerVietorisSquare :=
  Opens.mayerVietorisSquare S.U₁ S.U₂

/-- Iter-029 corner identification: `X₁ = U₁ ⊓ U₂`. The first three corners are
`rfl`-equal because `Opens.mayerVietorisSquare` defines them definitionally. -/
@[simp]
lemma AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₁
    {X : Scheme.{u}} (S : X.AffineCoverMVSquare) :
    S.toMayerVietorisSquare.toSquare.X₁ = S.U₁ ⊓ S.U₂ := rfl

/-- Iter-029 corner identification: `X₂ = U₁`. -/
@[simp]
lemma AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₂
    {X : Scheme.{u}} (S : X.AffineCoverMVSquare) :
    S.toMayerVietorisSquare.toSquare.X₂ = S.U₁ := rfl

/-- Iter-029 corner identification: `X₃ = U₂`. -/
@[simp]
lemma AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₃
    {X : Scheme.{u}} (S : X.AffineCoverMVSquare) :
    S.toMayerVietorisSquare.toSquare.X₃ = S.U₂ := rfl

/-- Iter-029 cover-totality identification: `X₄ = ⊤`. The substantive corner
identification — uses the `cover` field, which is the totality hypothesis
`U₁ ⊔ U₂ = ⊤` recorded in `AffineCoverMVSquare`. -/
@[simp]
lemma AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₄
    {X : Scheme.{u}} (S : X.AffineCoverMVSquare) :
    S.toMayerVietorisSquare.toSquare.X₄ = ⊤ := S.cover

/-- Iter-029 Mayer-Vietoris LES sequence on a 2-affine cover: a routine
specialisation of the iter-022 abstract sequence `HModule'_sequence` to the
bundled `AffineCoverMVSquare` data. Parameterised over a generic sheaf `F`
for reusability; the `toModuleKSheaf C` application is iter-030+ work. The
fully-qualified `_root_.AlgebraicGeometry.Scheme.HModule'_sequence` reference
is required because `def AffineCoverMVSquare.HModule'_sequence` auto-opens the
`AffineCoverMVSquare` namespace inside the body, causing bare
`HModule'_sequence` to recursively resolve to itself. -/
noncomputable def AffineCoverMVSquare.HModule'_sequence
    (k : Type u) [Field k] {X : Scheme.{u}} (S : X.AffineCoverMVSquare)
    (F : Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    ComposableArrows AddCommGrpCat 5 :=
  _root_.AlgebraicGeometry.Scheme.HModule'_sequence k S.toMayerVietorisSquare F n₀ n₁ h

/-- Iter-029 Mayer-Vietoris LES exactness on a 2-affine cover: a routine
specialisation of the iter-026 abstract exactness theorem
`HModule'_sequence_exact` to the bundled `AffineCoverMVSquare` data. -/
lemma AffineCoverMVSquare.HModule'_sequence_exact
    (k : Type u) [Field k] {X : Scheme.{u}} (S : X.AffineCoverMVSquare)
    (F : Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    (S.HModule'_sequence k F n₀ n₁ h).Exact :=
  _root_.AlgebraicGeometry.Scheme.HModule'_sequence_exact k S.toMayerVietorisSquare F n₀ n₁ h

/-- Iter-030 Mayer-Vietoris LES on a 2-affine cover of a curve: a routine
binding of the iter-029 sheaf-parameterised `HModule'_sequence` to the
structure sheaf `toModuleKSheaf C` for `C : Over (Spec (CommRingCat.of k))`.
The dot-notation `S.HModule'_sequence` resolves cleanly via method-call
against `S : AffineCoverMVSquare`, sidestepping the iter-029 sub-namespace
shadowing trap that required `_root_` disambiguation in the abstract
specialisation's body. -/
noncomputable def AffineCoverMVSquare.HModule'_sequence_curve
    (k : Type u) [Field k] {C : Over (Spec (CommRingCat.of k))}
    (S : C.left.AffineCoverMVSquare)
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    ComposableArrows AddCommGrpCat 5 :=
  S.HModule'_sequence k (Scheme.toModuleKSheaf C) n₀ n₁ h

/-- Iter-030 Mayer-Vietoris LES exactness on a 2-affine cover of a curve:
the exactness companion of `HModule'_sequence_curve`, by direct application
of the iter-029 abstract `HModule'_sequence_exact` to the structure sheaf
`toModuleKSheaf C`. -/
lemma AffineCoverMVSquare.HModule'_sequence_curve_exact
    (k : Type u) [Field k] {C : Over (Spec (CommRingCat.of k))}
    (S : C.left.AffineCoverMVSquare)
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    (S.HModule'_sequence_curve k n₀ n₁ h).Exact :=
  S.HModule'_sequence_exact k (Scheme.toModuleKSheaf C) n₀ n₁ h

end AffineCoverMVSquare

section CoverTotality

/-- Iter-031 cover-totality source-object identification. For a category `C`
with terminal object `T`, the sheafification of the free `k`-module on the
representable presheaf at `T` is canonically isomorphic to the constant sheaf
at `ModuleCat.of k k`. This is the natural-iso prerequisite for identifying
`HModule' k F n T` (open-evaluation cohomology at the terminal `T`, iter-014)
with `HModule k F n` (global cohomology, iter-009): both are `Ext` groups
whose source objects are made canonically isomorphic by this iso.

Assembled from three Mathlib pieces, mirroring the structure
`constantSheaf J D = Functor.const Cᵒᵖ ⋙ presheafToSheaf J D`:
1. `yoneda.obj T ≅ (Functor.const Cᵒᵖ).obj PUnit` — the terminal-collapse
   of the representable, by `IsTerminal.from`/`IsTerminal.hom_ext`.
2. `Functor.constComp _ PUnit (ModuleCat.free k)` — the identity
   `(Functor.const Cᵒᵖ).obj PUnit ⋙ ModuleCat.free k =
    (Functor.const Cᵒᵖ).obj ((ModuleCat.free k).obj PUnit)`
   packaged as an iso.
3. `(Finsupp.LinearEquiv.finsuppUnique k k PUnit).toModuleIso` —
   `(ModuleCat.free k).obj PUnit ≅ ModuleCat.of k k`. -/
noncomputable def HModule'_top_sourceIso
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    {T : C} (hT : IsTerminal T) :
    (presheafToSheaf J _).obj
        ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj T)
      ≅ (constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k) :=
  (presheafToSheaf J _).mapIso
    (Functor.isoWhiskerRight
        (NatIso.ofComponents
          (fun _ => Equiv.toIso { toFun := fun _ => PUnit.unit
                                  invFun := fun _ => hT.from _
                                  left_inv := fun _ => hT.hom_ext _ _
                                  right_inv := fun _ => rfl })
          (fun _ => by ext; rfl))
        (ModuleCat.free k) ≪≫
      Functor.constComp _ PUnit.{u+1} (ModuleCat.free k) ≪≫
      (Functor.const Cᵒᵖ).mapIso
        (Finsupp.LinearEquiv.finsuppUnique k k PUnit).toModuleIso)

/-- Iter-032 cover-totality Ext-transport at universe `u+1`. Combining the
iter-031 `HModule'_top_sourceIso` (a sheaf-level natural iso between source
objects of two `Ext` computations) with the Mathlib Ext-API operation
`precompOfLinear` (pre-composition of `Ext` along an `Ext 0`-element) yields
a `k`-linear equivalence between the universe-`u+1` Ext at the sheafified
representable on `T` and `HModule k F n`.

The universe annotation `Abelian.Ext.{u+1}` on the LHS is load-bearing —
without it Lean would pick `Ext.{u}` (matching iter-014's `HModule'` choice),
and the equivalence would not typecheck against `HModule k F n : Type (u+1)`
(iter-009). By pinning the LHS to `Ext.{u+1}` we sidestep the iter-031
universe mismatch (`HModule' : Type u` vs `HModule : Type (u+1)`); both
sides of this equivalence live at `Type (u+1)`. The bridge from
`HModule' k F n T : Type u` to the LHS here is iter-033+ work — most
plausibly via a small refactor on iter-014 to align `HModule'`'s universe,
or via a `ULift.{u+1}` wrapper.

Body uses `LinearEquiv.ofLinear` with two pre-composition maps via the
iter-031 iso's hom/inv. The round-trip equations close by a four-step
rewrite: associativity (with the middle factor degree 0), composition
collapse via `mk₀_comp_mk₀`, the iso identity, and `mk₀_id_comp`. -/
noncomputable def HModule_top_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) {T : C} (hT : IsTerminal T) :
    Abelian.Ext.{u+1}
        ((presheafToSheaf J (ModuleCat.{u} k)).obj
          ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj T)) F n
      ≃ₗ[k] HModule k F n :=
  let α := HModule'_top_sourceIso k hT
  LinearEquiv.ofLinear
    ((Abelian.Ext.mk₀ α.inv).precompOfLinear k F (zero_add n))
    ((Abelian.Ext.mk₀ α.hom).precompOfLinear k F (zero_add n))
    (by
      ext x
      change (Abelian.Ext.mk₀ α.inv).comp
        ((Abelian.Ext.mk₀ α.hom).comp x (zero_add n)) (zero_add n) = x
      rw [← Abelian.Ext.comp_assoc_of_second_deg_zero, Abelian.Ext.mk₀_comp_mk₀,
          α.inv_hom_id, Abelian.Ext.mk₀_id_comp])
    (by
      ext y
      change (Abelian.Ext.mk₀ α.hom).comp
        ((Abelian.Ext.mk₀ α.inv).comp y (zero_add n)) (zero_add n) = y
      rw [← Abelian.Ext.comp_assoc_of_second_deg_zero, Abelian.Ext.mk₀_comp_mk₀,
          α.hom_inv_id, Abelian.Ext.mk₀_id_comp])

/-- Iter-033 cover-totality Ext-transport at universe `u`. The universe-`u`
parallel of iter-032's `HModule_top_linearEquiv`. Combining the iter-031
`HModule'_top_sourceIso` (a sheaf-level natural iso between source objects
of two `Ext` computations) with the Mathlib Ext-API operation
`precompOfLinear` (pre-composition of `Ext` along an `Ext 0`-element)
yields a `k`-linear equivalence between `HModule' k F n T` (the iter-014
universe-`u` cohomology of an open at the terminal) and the universe-`u`
`Ext` at the constant sheaf on `ModuleCat.of k k`.

Both sides live at `Type u` (matching iter-014's `HModule'` ascription).
This is the universe-`u` parallel of iter-032's universe-`u+1` form; the
final bridge between the two (`Ext.{u}((constantSheaf J _).obj
(ModuleCat.of k k)) F n ≃ₗ[k] HModule k F n = Ext.{u+1}(...)`) is
iter-034+ work, requiring Mathlib's `Abelian.Ext.chgUniv` (a bare
`Equiv`, file `Mathlib/Algebra/Homology/DerivedCategory/Ext/Basic.lean`
L540) to be upgraded to a `LinearEquiv`.

The body is shape-identical to iter-032: `LinearEquiv.ofLinear` with two
pre-composition maps via the iter-031 iso's hom/inv. The round-trip
equations close by the same four-step rewrite chain. Lean's universe
inference adapts automatically because the LHS `HModule' k F n T`
forces `Ext.{u}` everywhere. -/
noncomputable def HModule'_top_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) {T : C} (hT : IsTerminal T) :
    HModule' k F n T
      ≃ₗ[k] Abelian.Ext ((constantSheaf J (ModuleCat.{u} k)).obj
              (ModuleCat.of k k)) F n :=
  let α := HModule'_top_sourceIso k hT
  LinearEquiv.ofLinear
    ((Abelian.Ext.mk₀ α.inv).precompOfLinear k F (zero_add n))
    ((Abelian.Ext.mk₀ α.hom).precompOfLinear k F (zero_add n))
    (by
      ext x
      change (Abelian.Ext.mk₀ α.inv).comp
        ((Abelian.Ext.mk₀ α.hom).comp x (zero_add n)) (zero_add n) = x
      rw [← Abelian.Ext.comp_assoc_of_second_deg_zero, Abelian.Ext.mk₀_comp_mk₀,
          α.inv_hom_id, Abelian.Ext.mk₀_id_comp])
    (by
      ext y
      change (Abelian.Ext.mk₀ α.hom).comp
        ((Abelian.Ext.mk₀ α.inv).comp y (zero_add n)) (zero_add n) = y
      rw [← Abelian.Ext.comp_assoc_of_second_deg_zero, Abelian.Ext.mk₀_comp_mk₀,
          α.hom_inv_id, Abelian.Ext.mk₀_id_comp])

/-- Iter-034 universe-bump bridge. Composes iter-033's
`HModule'_top_linearEquiv` (universe-`u` cover-totality between `HModule' k F n T`
and `Ext.{u} ((constantSheaf J _).obj (ModuleCat.of k k)) F n`) with the
universe shift `Abelian.Ext.chgUnivLinearEquiv` (Mathlib gap-fill at the top
of this file) lifting the result to `Ext.{u+1} ((constantSheaf J _).obj
(ModuleCat.of k k)) F n = HModule k F n` (definitional unfold of the iter-009
abbrev). The composition gives the full bridge `HModule' k F n T ≃ₗ[k]
HModule k F n` for terminal `T`, closing Step 3 of the Serre-finiteness
scaffold. Iter-035+ specialises this to `AffineCoverMVSquare` using
iter-029's `toMayerVietorisSquare_toSquare_X₄ : ... = ⊤` simp lemma. -/
noncomputable def HModule'_eq_HModule_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt.{u} (Sheaf J (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) {T : C} (hT : IsTerminal T) :
    HModule' k F n T ≃ₗ[k] HModule k F n :=
  (HModule'_top_linearEquiv k F n hT).trans Abelian.Ext.chgUnivLinearEquiv

/-- Iter-035 corner-bridge specialisation, abstract sheaf form. With iter-034's
universal bridge `HModule'_eq_HModule_linearEquiv` in scope, the natural
specialisation lands the bridge on the `X₄` corner of an `AffineCoverMVSquare`,
where iter-029's simp lemma `toMayerVietorisSquare_toSquare_X₄` identifies the
corner with `⊤ : Opens X.toTopCat`. Mathlib's `Preorder.isTerminalTop`
(`Mathlib/CategoryTheory/Limits/Preorder.lean`) supplies the
`IsTerminal ⊤` witness; transporting this back via the simp lemma's `.symm`
gives the required `IsTerminal X₄` to feed into the universal bridge. The
qualified `TopologicalSpace.Opens X.toTopCat` form is required to sidestep the
iter-029 sub-namespace shadowing trap (bare `Opens X.toTopCat` inside `def
AffineCoverMVSquare.foo` shadows to `Scheme.Opens` which expects a `Scheme`). -/
noncomputable def AffineCoverMVSquare.HModule'_X₄_linearEquiv
    (k : Type u) [Field k] {X : Scheme.{u}} (S : X.AffineCoverMVSquare)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))]
    (F : Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k)) (n : ℕ) :
    HModule' k F n S.toMayerVietorisSquare.toSquare.X₄ ≃ₗ[k] HModule k F n :=
  HModule'_eq_HModule_linearEquiv k F n
    (S.toMayerVietorisSquare_toSquare_X₄.symm ▸
      (Preorder.isTerminalTop (TopologicalSpace.Opens X.toTopCat)))

/-- Iter-035 corner-bridge curve specialisation. Direct application of
`AffineCoverMVSquare.HModule'_X₄_linearEquiv` to `F := Scheme.toModuleKSheaf C`
for `C : Over (Spec (CommRingCat.of k))`, via the dot-notation method-call form
`S.HModule'_X₄_linearEquiv` (mirrors the iter-030 `HModule'_sequence_curve`
pattern: dot-notation method-call resolves cleanly via lookup against
`S : C.left.AffineCoverMVSquare`, sidestepping the iter-029 sub-namespace
shadowing trap that required `_root_.` disambiguation in the abstract
`_sequence` body). -/
noncomputable def AffineCoverMVSquare.HModule'_X₄_linearEquiv_curve
    (k : Type u) [Field k] {C : Over (Spec (CommRingCat.of k))}
    (S : C.left.AffineCoverMVSquare)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    (n : ℕ) :
    HModule' k (Scheme.toModuleKSheaf C) n S.toMayerVietorisSquare.toSquare.X₄
      ≃ₗ[k] HModule k (Scheme.toModuleKSheaf C) n :=
  S.HModule'_X₄_linearEquiv k _ n

/-- Iter-036 finrank corollary, abstract sheaf form. With iter-035's corner-bridge
`HModule'_X₄_linearEquiv` in scope, the immediate algebraic consequence is that the
genus carrier `Module.finrank k (HModule k F n)` equals the open-evaluated form
`Module.finrank k (HModule' k F n X₄)`, by Mathlib's `LinearEquiv.finrank_eq`
applied to the bridge. The `.symm` is required: the bridge is
`HModule' k F n X₄ ≃ₗ[k] HModule k F n` (LHS-to-RHS), so the symmetric form
gives the orientation wanted by `genus C := Module.finrank k (HModule k _ 1)`. -/
theorem AffineCoverMVSquare.finrank_HModule_eq_HModule'_X₄
    (k : Type u) [Field k] {X : Scheme.{u}} (S : X.AffineCoverMVSquare)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))]
    (F : Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k)) (n : ℕ) :
    Module.finrank k (HModule k F n) =
      Module.finrank k (HModule' k F n S.toMayerVietorisSquare.toSquare.X₄) :=
  (S.HModule'_X₄_linearEquiv k F n).symm.finrank_eq

/-- Iter-036 finrank corollary, curve specialisation. Direct application of (a) to
`F := Scheme.toModuleKSheaf C` for `C : Over (Spec (CommRingCat.of k))`, via the
dot-notation method-call form `S.finrank_HModule_eq_HModule'_X₄` (mirrors the
iter-030 `_sequence_curve` and iter-035 `_X₄_linearEquiv_curve` patterns: dot-notation
method-call resolves cleanly via lookup against `S : C.left.AffineCoverMVSquare`,
sidestepping the iter-029 sub-namespace shadowing trap). -/
theorem AffineCoverMVSquare.finrank_HModule_eq_HModule'_X₄_curve
    (k : Type u) [Field k] {C : Over (Spec (CommRingCat.of k))}
    (S : C.left.AffineCoverMVSquare)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    (n : ℕ) :
    Module.finrank k (HModule k (Scheme.toModuleKSheaf C) n) =
      Module.finrank k (HModule' k (Scheme.toModuleKSheaf C) n
        S.toMayerVietorisSquare.toSquare.X₄) :=
  S.finrank_HModule_eq_HModule'_X₄ k _ n

/-- Iter-037 `Module.Finite` transport companion, abstract sheaf form. With iter-035's
corner-bridge `HModule'_X₄_linearEquiv : HModule' k F n X₄ ≃ₗ[k] HModule k F n`
in scope (LHS = X₄ form, RHS = global form), Mathlib's `Module.Finite.equiv`
transports finiteness from LHS to RHS: given `Module.Finite k (HModule' k F n X₄)`
as a hypothesis, we get `Module.Finite k (HModule k F n)` as a conclusion.
**No `.symm` is needed** — `Module.Finite.equiv` consumes the hypothesis on the
LHS of the equiv (`[Module.Finite R M]`) and produces the conclusion on the RHS
(`Module.Finite R N`), which is exactly the orientation `smoothOfRelativeDimension_genus`
(Jacobian.lean) eventually consumes. -/
theorem AffineCoverMVSquare.module_finite_HModule_of_HModule'_X₄
    (k : Type u) [Field k] {X : Scheme.{u}} (S : X.AffineCoverMVSquare)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))]
    (F : Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k)) (n : ℕ)
    [Module.Finite k (HModule' k F n S.toMayerVietorisSquare.toSquare.X₄)] :
    Module.Finite k (HModule k F n) :=
  Module.Finite.equiv (S.HModule'_X₄_linearEquiv k F n)

/-- Iter-037 `Module.Finite` transport companion, curve specialisation. Direct
application of (a) to `F := Scheme.toModuleKSheaf C` for `C : Over (Spec (CommRingCat.of k))`,
via the dot-notation method-call form `S.module_finite_HModule_of_HModule'_X₄`
(mirrors the iter-030 `_sequence_curve`, iter-035 `_X₄_linearEquiv_curve`, and
iter-036 `_finrank_HModule_eq_HModule'_X₄_curve` patterns: dot-notation method-call
resolves cleanly via lookup against `S : C.left.AffineCoverMVSquare`, sidestepping
the iter-029 sub-namespace shadowing trap). -/
theorem AffineCoverMVSquare.module_finite_HModule_of_HModule'_X₄_curve
    (k : Type u) [Field k] {C : Over (Spec (CommRingCat.of k))}
    (S : C.left.AffineCoverMVSquare)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    (n : ℕ)
    [Module.Finite k (HModule' k (Scheme.toModuleKSheaf C) n
        S.toMayerVietorisSquare.toSquare.X₄)] :
    Module.Finite k (HModule k (Scheme.toModuleKSheaf C) n) :=
  S.module_finite_HModule_of_HModule'_X₄ k _ n

/-- Iter-049: top-supremum HModule transport. With iter-048's
`subsingleton_HModule'_supr_of_isCechAcyclicCover` consumer in scope (lifting
`IsCechAcyclicCover F 𝒰 + compIso` to `Subsingleton (HModule' k F n (⨆ 𝒰))`)
and iter-034's `HModule'_eq_HModule_linearEquiv` universe bridge in scope
(identifying `HModule' k F n ⊤ ≃ₗ[k] HModule k F n`), this thin transport
chains them: under the cover-totality hypothesis `⨆ i, 𝒰 i = ⊤`, the iter-048
`HModule'`-on-supremum subsingleton lifts (via `h ▸ this`) to `HModule' k F n ⊤`,
which iter-034's bridge `.symm.toEquiv.subsingleton` transports to `HModule k F n`.

This is the universe-`u+1` form of the iter-048 vanishing, which is what
downstream consumers (notably the iter-052+ genus carrier `Module.Finite k
(HModule k (toModuleKSheaf C) 1)`) ultimately need: `genus C =
Module.finrank k (HModule k (toModuleKSheaf C) 1)` (iter-011) lives at
universe `u+1`, but the iter-048 acyclicity carrier and consumer live at
universe `u`. Iter-049 bridges. -/
theorem subsingleton_HModule_of_isCechAcyclicCover_top
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)}
    {ι : Type u} {𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat}
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [IsCechAcyclicCover F 𝒰] (h : ⨆ i, 𝒰 i = ⊤)
    (compIso : ∀ (n : ℕ),
      cechCohomology C F 𝒰 n ≃ₗ[k]
        HModule' k F n (⨆ i, 𝒰 i))
    (n : ℕ) (hn : 0 < n) :
    Subsingleton (HModule k F n) := by
  haveI : Subsingleton (HModule' k F n (⨆ i, 𝒰 i)) :=
    subsingleton_HModule'_supr_of_isCechAcyclicCover compIso n hn
  haveI : Subsingleton (HModule' k F n ⊤) := h ▸ this
  exact (HModule'_eq_HModule_linearEquiv k F n
    (Preorder.isTerminalTop _)).symm.toEquiv.subsingleton

/-- Iter-049: curve specialisation at `F := Scheme.toModuleKSheaf C`.

Mirrors the iter-039 / iter-042 / iter-043 / iter-048 `_curve` pattern: a thin
dot-notation wrapper that saves call sites in the curve setting (where `F` is
the structure sheaf) from re-typing `toModuleKSheaf C` whenever the iter-049
consumer is chained through. Used by the iter-053 genus carrier producer
`Module.Finite k (HModule k (toModuleKSheaf C) 1)`. -/
theorem subsingleton_HModule_of_isCechAcyclicCover_top_curve
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} {𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat}
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [IsCechAcyclicCover (toModuleKSheaf C) 𝒰] (h : ⨆ i, 𝒰 i = ⊤)
    (compIso : ∀ (n : ℕ),
      cechCohomology C (toModuleKSheaf C) 𝒰 n ≃ₗ[k]
        HModule' k (toModuleKSheaf C) n (⨆ i, 𝒰 i))
    (n : ℕ) (hn : 0 < n) :
    Subsingleton (HModule k (toModuleKSheaf C) n) :=
  subsingleton_HModule_of_isCechAcyclicCover_top (𝒰 := 𝒰) h compIso n hn

end CoverTotality

end AlgebraicGeometry.Scheme
