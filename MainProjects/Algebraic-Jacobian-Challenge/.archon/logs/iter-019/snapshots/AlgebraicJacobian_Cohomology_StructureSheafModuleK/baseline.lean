/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.StructureSheafAb

/-!
# Sheaves of `k`-modules: sheafification, Ext, and the structure sheaf

Phase A step 5 (per `STRATEGY.md`):

* **Prerequisites** (iter-005, closed): the `HasSheafify` and `HasExt` instances
  on the topology of opens of an arbitrary topological space, valued in
  `ModuleCat k`. The `Linear k` enrichment on the resulting sheaf category is
  auto-inferable from Mathlib and therefore needs no scaffold here; together
  with `CategoryTheory.Abelian.Ext.instModule` it gives the path to a
  `Module k` structure on `Ext` groups.
* **Main** (iter-006, scaffolded here): the structure sheaf of a `Spec k`-scheme
  `C : Over (Spec (CommRingCat.of k))` viewed as a sheaf of `k`-modules. Built
  from the structure-morphism-derived ring map `k → Γ(C, U)` (helpers (1)–(5))
  and packaged as the presheaf `toModuleKPresheaf` (6), proven to be a sheaf
  by `toModuleKPresheaf_isSheaf` (7), and bundled as `toModuleKSheaf` (8).

See `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`.

## Status (iteration 006 — refactor scaffold)

The two prerequisite declarations (lines below) are honestly closed (iter-005).
The eight Phase A step 5 main declarations are scaffolded as `sorry`. The
iter-006 prover round is responsible for filling them.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

namespace AlgebraicGeometry.Cohomology

/-- Phase A step 5 prerequisite (a): sheafification on the topology of opens of
any topological space, valued in `ModuleCat k`. Inferable from Mathlib's
small-site / concrete-category sheafification API; the prover's task is the
universe pinning, mirroring the iter-004 `instHasSheafify_Opens_AddCommGrp`. -/
instance instHasSheafify_Opens_ModuleCatK
    (k : Type u) [CommRing k] (X : TopCat.{u}) :
    CategoryTheory.HasSheafify (Opens.grothendieckTopology X)
      (ModuleCat.{u} k) :=
  inferInstance

/-- Phase A step 5 prerequisite (b): `Ext` on the sheaf category. The universe
annotation `HasExt.{u+1}` is forced by the morphism universe of
`Sheaf (Opens.gT X) (ModuleCat.{u} k)`; mirrors the iter-004
`instHasExt_Sheaf_Opens_AddCommGrp`. -/
noncomputable instance instHasExt_Sheaf_Opens_ModuleCatK
    (k : Type u) [CommRing k] (X : TopCat.{u}) :
    CategoryTheory.HasExt.{u+1}
      (CategoryTheory.Sheaf (Opens.grothendieckTopology X)
        (ModuleCat.{u} k)) :=
  CategoryTheory.HasExt.standard _

end AlgebraicGeometry.Cohomology

namespace AlgebraicGeometry.Scheme.toModuleKSheaf

variable {k : Type u} [CommRing k]

/-- Phase A step 5 main, helper (1): the ring map `k → Γ(C, U)` induced by the
structure morphism `C.hom : C.left ⟶ Spec (CommRingCat.of k)` and the
restriction along `U ≤ ⊤`. -/
noncomputable def kToSection (C : Over (Spec (CommRingCat.of k)))
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    (CommRingCat.of k) ⟶ C.left.presheaf.obj U :=
  (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫
    C.hom.app ⊤ ≫ C.left.presheaf.map (homOfLE le_top).op

/-- Phase A step 5 main, helper (2): `Γ(C, U)` is a `k`-algebra via the ring
map of `kToSection`. -/
noncomputable instance algebraSection (C : Over (Spec (CommRingCat.of k)))
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    Algebra k (C.left.presheaf.obj U) :=
  RingHom.toAlgebra (kToSection C U).hom

/-- Phase A step 5 main, helper (3): unfolding lemma for the algebra map. -/
lemma algebraMap_eq_kToSection (C : Over (Spec (CommRingCat.of k)))
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    (algebraMap k (C.left.presheaf.obj U)) = (kToSection C U).hom :=
  rfl

/-- Phase A step 5 main, helper (4): the structure-morphism algebra map is
natural in `U`. -/
lemma kToSection_naturality (C : Over (Spec (CommRingCat.of k)))
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) :
    kToSection C U ≫ C.left.presheaf.map f = kToSection C V := by
  simp only [kToSection, Category.assoc, ← C.left.presheaf.map_comp]
  rfl

/-- Phase A step 5 main, helper (5): corollary of (4) at the level of
`algebraMap`. -/
lemma algebraMap_naturality (C : Over (Spec (CommRingCat.of k)))
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) (r : k) :
    (C.left.presheaf.map f).hom (algebraMap k (C.left.presheaf.obj U) r)
      = algebraMap k (C.left.presheaf.obj V) r := by
  rw [algebraMap_eq_kToSection, algebraMap_eq_kToSection]
  exact congrArg (fun (g : (CommRingCat.of k) ⟶ _) => g.hom r)
    (kToSection_naturality (C := C) f)

end AlgebraicGeometry.Scheme.toModuleKSheaf

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [CommRing k]

/-- Phase A step 5 main, helper (6): the presheaf of `k`-modules built from
`O_C` and the structure-morphism algebra structure. -/
noncomputable def toModuleKPresheaf (C : Over (Spec (CommRingCat.of k))) :
    (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} k where
  obj U := ModuleCat.of k (C.left.presheaf.obj U)
  map {U V} f := ModuleCat.ofHom
    { toFun := fun x => (C.left.presheaf.map f).hom x
      map_add' := fun x y => by
        simp [(C.left.presheaf.map f).hom.map_add]
      map_smul' := fun r x => by
        simp only [Algebra.smul_def, RingHom.map_mul, RingHom.id_apply]
        congr 1
        exact AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality
          (C := C) f r }
  map_id U := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_id, LinearMap.id_coe, id_eq]
    exact congrFun (congrArg (·.hom) (C.left.presheaf.map_id U)) x
  map_comp {U V W} f g := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_comp, LinearMap.coe_comp, Function.comp_apply]
    exact congrFun (congrArg (·.hom) (C.left.presheaf.map_comp f g)) x

/-- Object-evaluation simp lemma for `toModuleKPresheaf`. Definitionally true
by construction; tagged `@[simp]` so consumers can rewrite without unfolding
the constructor. Phase A step 5 polish (iter-007). -/
@[simp] lemma toModuleKPresheaf_obj (C : Over (Spec (CommRingCat.of k)))
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    (toModuleKPresheaf C).obj U = ModuleCat.of k (C.left.presheaf.obj U) :=
  rfl

/-- Phase A step 5 main, helper (7): the presheaf of (6) is a sheaf for the
Grothendieck topology of opens of `C.left.toTopCat`. -/
lemma toModuleKPresheaf_isSheaf (C : Over (Spec (CommRingCat.of k))) :
    Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (toModuleKPresheaf C) := by
  rw [Presheaf.isSheaf_iff_isSheaf_forget _ _ (CategoryTheory.forget (ModuleCat.{u} k))]
  convert (Presheaf.isSheaf_iff_isSheaf_forget _ _
      (CategoryTheory.forget CommRingCat.{u})).mp C.left.sheaf.property using 1

/-- Phase A step 5 main: the structure sheaf of a `Spec k`-scheme as a sheaf
of `k`-modules. Bundles `toModuleKPresheaf` (helper 6) and
`toModuleKPresheaf_isSheaf` (helper 7) into the standard `Sheaf` shape. -/
noncomputable def toModuleKSheaf (C : Over (Spec (CommRingCat.of k))) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k) :=
  ⟨toModuleKPresheaf C, toModuleKPresheaf_isSheaf C⟩

/-- Phase A step 5 polish (iter-007): forget-and-recover natural iso between
the iter-006 `ModuleCat k`-valued structure sheaf and the iter-004
`AddCommGrpCat`-valued structure sheaf. The two sheaves agree on the nose at
the underlying-presheaf level: forgetting from `ModuleCat k` to `AddCommGrpCat`
via `forget₂` recovers the iter-004 `toAbSheaf C.left`. Closure body
`Iso.refl _`; probe-confirmed (`lean_run_code`, iter-007 plan-agent). -/
noncomputable def toModuleKSheaf_forgetCompare
    (C : Over (Spec (CommRingCat.of k))) :
    (sheafCompose (Opens.grothendieckTopology C.left.toTopCat)
        (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})).obj (toModuleKSheaf C)
      ≅ toAbSheaf C.left :=
  Iso.refl _

/-- Phase A step 5/6 bridge (iter-009 scaffold): the parallel `Sheaf.H` for
`ModuleCat k`-valued sheaves. Mathlib's `CategoryTheory.Sheaf.H` is
parameterised over `Sheaf J AddCommGrpCat` only, so closing `genus` honestly
requires this `ModuleCat k`-flavoured version. The result carries `Module k`
automatically via `CategoryTheory.Abelian.Ext.instModule`, and
`Module.finrank k` is therefore well-defined on it. The declaration is a
`noncomputable abbrev` (rather than `def`) so that instance synthesis sees
through the wrapper to find `Module k` and `AddCommGroup` instances. -/
noncomputable abbrev HModule
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) : Type (u+1) :=
  Abelian.Ext ((constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k)) F n

/-- Phase A step 6 algebraic bridge (iter-010 scaffold): the $k$-linear
identification of `HModule k F 0` with the Hom group from the constant
sheaf at `ModuleCat.of k k`. Mathlib provides
`CategoryTheory.Abelian.Ext.linearEquiv₀ : Ext X Y 0 ≃ₗ[R] (X ⟶ Y)` in any
`Linear R`-enriched abelian category; specialised to the `Linear k`
enrichment of `Sheaf J (ModuleCat.{u} k)` (auto-inferable from
`HasSheafify J (ModuleCat.{u} k)`), this collapses `HModule k F 0` to a
`k`-linear Hom group. The closure body is `Abelian.Ext.linearEquiv₀`;
probe-confirmed one-liner (iter-010 plan-agent). Used downstream to
identify `H⁰(C, toModuleKSheaf C)` with `Γ(C, O_C)` viewed as a
`k`-module on a connected proper `k`-curve. -/
noncomputable def HModule_zero_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) :
    HModule k F 0 ≃ₗ[k]
      ((constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k) ⟶ F) :=
  Abelian.Ext.linearEquiv₀

/-- Phase A step 6 *Path 2* (iter-013 scaffold): the `ModuleCat k`-flavored
cohomology of an open `X : C` with values in a sheaf `F : Sheaf J (ModuleCat.{u} k)`.
Mirrors Mathlib's `Sheaf.H' F n X = (F.cohomologyPresheaf n).obj (op X)`
(`Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean` L105) for
`AddCommGrpCat`-valued sheaves, with `AddCommGrpCat.free → ModuleCat.free k`.

The codomain is `Type u` (not `ModuleCat.{u} k`): `Abelian.Ext` returns a bare
`Type u` carrying `Module k` via `Abelian.Ext.instModule` through the `Linear k`
enrichment. The `noncomputable abbrev` form (rather than `def`) is required so
instance synthesis sees through the wrapper to find `Module k (HModule' k F n X)`
and `AddCommGroup (HModule' k F n X)` — under `def`, `Module.finrank` would fail
to typecheck (cf. iter-009 design rationale on `HModule`).

This is the prerequisite for the iter-014+ `ModuleCat k`-flavored Mayer-Vietoris
LES (mirror of `Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`).
The iter-014+ work will state and prove the LES on a `MayerVietorisSquare`,
specialising to a 2-affine cover of a proper `k`-curve in iter-015+. The
comparison theorem `cechCohomology_OC C 𝒰 n ≅ HModule k (toModuleKSheaf C) n`
for an acyclic cover (the technical heart of Path-2) is also queued for
iter-015+. -/
noncomputable abbrev HModule' (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) (X : C) : Type u :=
  Abelian.Ext ((presheafToSheaf _ _).obj
    ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X)) F n

/-- Phase A step 6 *Path 2* (iter-015): the `H⁰` algebraic bridge for `HModule'`,
mirroring iter-010's `HModule_zero_linearEquiv` for the iter-014 `HModule'`. The
$k$-linear identification of `HModule' k F 0 X` with the Hom group from the
sheafified representable `(presheafToSheaf _ _).obj ((yoneda ⋙ ModuleCat.free k).obj X)`.
Mathlib provides `CategoryTheory.Abelian.Ext.linearEquiv₀ : Ext X Y 0 ≃ₗ[R] (X ⟶ Y)`
in any `Linear R`-enriched abelian category; specialised to `R = k` and to the
`Linear k`-enriched abelian category `Sheaf J (ModuleCat.{u} k)` (the `Linear k`
enrichment is auto-inferable from `HasSheafify J (ModuleCat.{u} k)` via Mathlib's
`Sheaf.linear`), this collapses `HModule' k F 0 X` to a `k`-linear Hom group. The
closure body is `Abelian.Ext.linearEquiv₀`; probe-confirmed one-liner (iter-015
plan-agent). Used downstream as the algebraic prerequisite for Stein-factorization-
derived `H⁰(C, O_C) ≃ k` on a connected proper `k`-curve (multi-iteration; queued
iter-017+ alongside the Mayer-Vietoris LES of iter-016+). -/
noncomputable def HModule'_zero_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (X : C) :
    HModule' k F 0 X ≃ₗ[k]
      ((presheafToSheaf _ _).obj
        ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X) ⟶ F) :=
  Abelian.Ext.linearEquiv₀

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

end AlgebraicGeometry.Scheme

namespace AlgebraicGeometry

/-- Phase A step 6 *Path 2* (iter-012 scaffold): the Čech cochain complex of
the structure sheaf of a `Spec k`-scheme `C : Over (Spec (CommRingCat.of k))`,
with respect to an arbitrary indexed family of opens `𝒰 : ι → Opens C.left.toTopCat`.
Built from Mathlib's `CategoryTheory.cechComplexFunctor` (file
`Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean`) applied to the
underlying presheaf of `Scheme.toModuleKSheaf C` (iter-006). The result is a
cochain complex valued in `ModuleCat.{u} k`, indexed by `ℕ`.

The cohomology of this complex is `Scheme.cechCohomology_OC` below. The
downstream comparison theorem (Čech cohomology = derived-functor cohomology
= `Scheme.HModule k (Scheme.toModuleKSheaf C)` for an acyclic cover) is
queued for iter-013+; iter-012 only establishes the Čech-side carrier. -/
noncomputable def Scheme.cechCochain_OC
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat) :
    CochainComplex (ModuleCat.{u} k) ℕ :=
  (cechComplexFunctor 𝒰).obj ((sheafToPresheaf _ _).obj (Scheme.toModuleKSheaf C))

/-- Phase A step 6 *Path 2* (iter-012 scaffold): the `n`-th Čech cohomology
of the structure sheaf for an arbitrary indexed open cover. Defined as the
`n`-th homology of the Čech cochain complex `Scheme.cechCochain_OC`. The
result lives in `ModuleCat.{u} k` and therefore carries a `Module k`
structure for free; the iter-013+ comparison theorem will identify it
with `Scheme.HModule k (Scheme.toModuleKSheaf C) n` when the cover is
acyclic. -/
noncomputable def Scheme.cechCohomology_OC
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat) (n : ℕ) :
    ModuleCat.{u} k :=
  (Scheme.cechCochain_OC C 𝒰).homology n

end AlgebraicGeometry
