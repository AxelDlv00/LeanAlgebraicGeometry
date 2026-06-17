/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate
import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom

/-!
# Slice transport for the dual (A.1.c.SubT §Dual SliceTransport)

Auxiliary declarations feeding `DualInverse.lean`:
- §0: `unitDualSectionEquiv`, `dualUnitIsoGen` (`namespace PresheafOfModules`)
- §A: `isIso_ε_restrictScalars_appIso`, `dualUnitRingSwap`, `dualUnitRingSwapInv`,
  `dualUnitRingSwapHom`, `isIso_ε_restrictScalars_appIso_hom`,
  `isIso_ε_restrictScalars_presheafMap`, `unitRelabelSwap`,
  `sliceDualTransportInv`, `sliceDualTransport` (`namespace AlgebraicGeometry.Scheme.Modules`)
-/
set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

/-! ## §0. Presheaf-level: the dual of the monoidal unit is the unit

Project-local supplement to `PresheafInternalHom.lean`: `PresheafOfModules.dual 𝟙_ ≅ 𝟙_`
(the evaluation-at-`1` isomorphism `ℋom(𝟙_, 𝟙_) ≅ 𝟙_`), built over a general single-universe
base category.  It feeds `Scheme.Modules.dual_unit_iso` (below) at `R₀ := Y.presheaf`. -/

namespace PresheafOfModules

open InternalHom Opposite

variable {D : Type u} [Category.{u, u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}

/-- **Section equivalence for the dual of the unit.** At an object `X`, endomorphisms of the
(restricted) unit `restr X 𝟙_ ⟶ restr X 𝟙_` are identified `R₀(X)`-linearly with `R₀(X)` itself,
via evaluation at `1`; the inverse is multiplication by a global scalar (`globalSMul`). The
substantive content is `left_inv`: every endomorphism of the unit is multiplication by its value
at `1` (proved from `φ`-naturality toward the terminal object of the slice). -/
noncomputable def unitDualSectionEquiv (X : Dᵒᵖ) :
    letI := internalHomObjModule X.unop
      (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
      (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    (restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) ⟶
        restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))))
      ≃ₗ[(R₀.obj (op X.unop) : Type u)] (R₀.obj (op X.unop) : Type u) := by
  letI := internalHomObjModule X.unop
    (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
  exact
    { toFun := fun φ =>
        evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) X φ
          (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
      map_add' := fun φ φ' => rfl
      map_smul' := fun c φ => by
        exact DFunLike.congr_fun (evalLin_smul _ X c φ)
          (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
      invFun := fun r =>
        globalSMul Over.mkIdTerminal
          (restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))) r
      left_inv := fun φ => by
        ext Y
        dsimp only
        erw [globalSMul_hom_apply]
        have hnat := PresheafOfModules.naturality_apply φ (Over.mkIdTerminal.from Y.unop).op
          (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
        erw [PresheafOfModules.unit_map_one] at hnat
        erw [hnat, smul_eq_mul, mul_one]
        rfl
      right_inv := fun r => by
        change ((globalSMul Over.mkIdTerminal
            (restr X.unop
              (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))) r).app
            (op (Over.mk (𝟙 X.unop)))).hom
            (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u)) = r
        rw [globalSMul_hom_apply, termRingMap_terminal]
        exact mul_one r }

/-- **The presheaf dual of the monoidal unit is the unit**, `PresheafOfModules.dual 𝟙_ ≅ 𝟙_`,
assembled sectionwise from `unitDualSectionEquiv` with the evaluation-at-`1` naturality (mirroring
`InternalHom.internalHomEval`'s naturality at `M = 𝟙_`). -/
noncomputable def dualUnitIsoGen :
    PresheafOfModules.dual (R₀ := R₀)
        (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
      ≅ 𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) :=
  PresheafOfModules.isoMk (fun X => (unitDualSectionEquiv X).toModuleIso)
    (fun {X Y} f => by
      refine ModuleCat.hom_ext (LinearMap.ext fun φ => ?_)
      change evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) Y
            ((PresheafOfModules.dual
              (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).map f φ)
            (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj Y : Type u))
          = ((𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))).map f).hom
              (evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) X φ
                (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u)))
      have key := PresheafOfModules.naturality_apply
        (φ : restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) ⟶
          restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))))
        (Over.homMk f.unop : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op
        (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
      have hrm : (restr X.unop
            (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).map
          (Over.homMk f.unop : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op
          = (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))).map f := rfl
      rw [hrm] at key
      erw [PresheafOfModules.unit_map_one] at key
      have hAB : (op (Over.mk (𝟙 Y.unop ≫ f.unop)) : (Over X.unop)ᵒᵖ) = op (Over.mk f.unop) :=
        congrArg op (congrArg Over.mk (Category.id_comp f.unop))
      have homAppHEq : ∀ {A B : (Over X.unop)ᵒᵖ} (_ : A = B), HEq (φ.app A) (φ.app B) := by
        intro A B h; subst h; rfl
      have hdt : evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) Y
          ((PresheafOfModules.dual
            (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).map f φ)
          = (φ.app (op (Over.mk f.unop))).hom :=
        congrArg ModuleCat.Hom.hom (eq_of_heq (homAppHEq hAB))
      exact (DFunLike.congr_fun hdt _).trans key)

end PresheafOfModules

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! ## §A. The C-bridge: restriction commutes with the sheaf-level dual -/

open Opposite in
/-- **Leg-B atomic claim: the lax-monoidal unit `ε` of `restrictScalars` along the open-immersion
structure ring iso `(f.appIso W').inv` is an isomorphism.**  Its underlying map is the (bijective)
ring map `(f.appIso W').inv.hom`, so `ε` is an iso by `restrictScalars_isIso_ε_of_bijective`
(`PresheafInternalHom.lean`) fed the bijectivity from `ConcreteCategory.bijective_of_isIso`.  This
is the single load-bearing fact powering `dualUnitRingSwap` (the codomain unit ring swap of leg-B),
phrased at the `CommRingCat` carrier so `CommRing` is native (per `analogies/ma-legb262.md`). -/
lemma isIso_ε_restrictScalars_appIso {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y) :
    IsIso (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom)) :=
  restrictScalars_isIso_ε_of_bijective (Scheme.Hom.appIso f W').inv.hom
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (Scheme.Hom.appIso f W').inv)

open Opposite in
/-- **Leg-B: the codomain unit ring-iso swap** `restrictScalars (f.appIso W').inv (𝟙_X(fW')) ⟶
𝟙_Y(W')`.  It is the inverse of the lax-monoidal unit `ε (restrictScalars (f.appIso W').inv.hom)`,
an isomorphism by `isIso_ε_restrictScalars_appIso`.  The endpoints are written at the canonical
`CommRingCat` section carriers `↑(X.presheaf.obj _)` / `↑(Y.presheaf.obj _)` (the `forget₂`-composite
carrier breaks `MonoidalCategoryStruct` synthesis, `analogies/ma-legb262.md`); they reconcile by
`rfl`/defeq with the `restr`/`𝟙_`-section spellings of `sliceDualTransport`'s `codomainMap` hole. -/
noncomputable def dualUnitRingSwap {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y) :
    (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom).obj
        (𝟙_ (ModuleCat ↑(X.presheaf.obj (op ((Scheme.Hom.opensFunctor f).obj W'))))) ⟶
      𝟙_ (ModuleCat ↑(Y.presheaf.obj (op W'))) :=
  haveI := isIso_ε_restrictScalars_appIso f W'
  CategoryTheory.inv (Functor.LaxMonoidal.ε
    (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom))

open Opposite in
/-- **Leg-B (inverse direction): the unit codomain ring-iso swap for `invFun`** `𝟙_Y(W') ⟶
restrictScalars (f.appIso W').inv (𝟙_X(fW'))`.  This is the lax-monoidal unit
`ε (restrictScalars (f.appIso W').inv.hom)` ITSELF (not its inverse), the reverse of
`dualUnitRingSwap`.  By `isIso_ε_restrictScalars_appIso` it is an isomorphism and is the inverse of
`dualUnitRingSwap f W'` (they cancel by `IsIso.inv_hom_id`/`hom_inv_id`). -/
noncomputable def dualUnitRingSwapInv {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y) :
    (𝟙_ (ModuleCat ↑(Y.presheaf.obj (op W')))) ⟶
      (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom).obj
        (𝟙_ (ModuleCat ↑(X.presheaf.obj (op ((Scheme.Hom.opensFunctor f).obj W'))))) :=
  Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom)

open Opposite in
/-- `dualUnitRingSwapInv` is a section of `dualUnitRingSwap` (`ε ≫ inv ε = 𝟙`). -/
@[simp] lemma dualUnitRingSwapInv_comp_dualUnitRingSwap {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (W' : TopologicalSpace.Opens ↥Y) :
    dualUnitRingSwapInv f W' ≫ dualUnitRingSwap f W' = 𝟙 _ := by
  haveI := isIso_ε_restrictScalars_appIso f W'
  simp [dualUnitRingSwapInv, dualUnitRingSwap]

open Opposite in
/-- `dualUnitRingSwap` is a section of `dualUnitRingSwapInv` (`inv ε ≫ ε = 𝟙`). -/
@[simp] lemma dualUnitRingSwap_comp_dualUnitRingSwapInv {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (W' : TopologicalSpace.Opens ↥Y) :
    dualUnitRingSwap f W' ≫ dualUnitRingSwapInv f W' = 𝟙 _ := by
  haveI := isIso_ε_restrictScalars_appIso f W'
  simp [dualUnitRingSwapInv, dualUnitRingSwap]

open Opposite in
/-- The underlying map of `dualUnitRingSwap` is the `.hom` direction of the open-immersion
structure-ring isomorphism. -/
lemma dualUnitRingSwap_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y)
    (x : (X.presheaf.obj (op ((Scheme.Hom.opensFunctor f).obj W')) : Type u)) :
    (dualUnitRingSwap f W').hom x = (Scheme.Hom.appIso f W').hom.hom x := by
  have h := congrArg ModuleCat.Hom.hom (dualUnitRingSwap_comp_dualUnitRingSwapInv f W')
  have hx := DFunLike.congr_fun h x
  change (dualUnitRingSwapInv f W').hom ((dualUnitRingSwap f W').hom x) = x at hx
  dsimp [dualUnitRingSwapInv] at hx
  have hx' : (Scheme.Hom.appIso f W').inv.hom ((dualUnitRingSwap f W').hom x) = x := by
    simpa only [ModuleCat.restrictScalars_η] using hx
  have hinj : Function.Injective (Scheme.Hom.appIso f W').inv.hom :=
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (Scheme.Hom.appIso f W').inv).1
  apply hinj
  rw [hx']
  exact (ConcreteCategory.congr_hom (Scheme.Hom.appIso f W').hom_inv_id x).symm

open Opposite in
/-- **`invFun` codomain ε is an iso (`.hom` direction).**  The lax-monoidal unit `ε` of
`restrictScalars` along `(f.appIso W').hom` (the `.hom`, not `.inv`, of the structure ring iso) is
an isomorphism, since `(f.appIso W').hom` is a bijective ring map.  This powers the `invFun`
codomain swap (which reindexes the `Over V` section back across `f.opensFunctor` using the
`.hom` direction, the mirror of `dualUnitRingSwap`'s `.inv`). -/
lemma isIso_ε_restrictScalars_appIso_hom {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y) :
    IsIso (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').hom.hom)) :=
  restrictScalars_isIso_ε_of_bijective (Scheme.Hom.appIso f W').hom.hom
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (Scheme.Hom.appIso f W').hom)

open Opposite in
/-- **`invFun` codomain unit ring-iso swap** `restrictScalars (f.appIso W').hom (𝟙_Y(W')) ⟶
𝟙_X(fW')`.  It is the inverse of the lax-monoidal unit `ε (restrictScalars (f.appIso W').hom)`,
an isomorphism by `isIso_ε_restrictScalars_appIso_hom`.  This is the codomain swap of the reverse
transport `invFun` (mirror of `dualUnitRingSwap`, using the `.hom` direction). -/
noncomputable def dualUnitRingSwapHom {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y) :
    (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').hom.hom).obj
        (𝟙_ (ModuleCat ↑(Y.presheaf.obj (op W')))) ⟶
      𝟙_ (ModuleCat ↑(X.presheaf.obj (op ((Scheme.Hom.opensFunctor f).obj W')))) :=
  haveI := isIso_ε_restrictScalars_appIso_hom f W'
  CategoryTheory.inv (Functor.LaxMonoidal.ε
    (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').hom.hom))

open Opposite in
/-- The underlying map of `dualUnitRingSwapHom` is the `.inv` direction of the open-immersion
structure-ring isomorphism (the pointwise mirror of `dualUnitRingSwap_apply`; proved by the same
injectivity rotation, so the deep `inv ε` composite is never sent through `whnf`). -/
lemma dualUnitRingSwapHom_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y)
    (x : (Y.presheaf.obj (op W') : Type u)) :
    (dualUnitRingSwapHom f W').hom x = (Scheme.Hom.appIso f W').inv.hom x := by
  haveI := isIso_ε_restrictScalars_appIso_hom f W'
  have h := congrArg ModuleCat.Hom.hom
    (IsIso.inv_hom_id (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').hom.hom)))
  have hx := DFunLike.congr_fun h x
  change (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').hom.hom)).hom
      ((dualUnitRingSwapHom f W').hom x) = x at hx
  have hx' : (Scheme.Hom.appIso f W').hom.hom ((dualUnitRingSwapHom f W').hom x) = x := by
    simpa only [ModuleCat.restrictScalars_η] using hx
  have hinj : Function.Injective (Scheme.Hom.appIso f W').hom.hom :=
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (Scheme.Hom.appIso f W').hom).1
  apply hinj
  rw [hx']
  exact (ConcreteCategory.congr_hom (Scheme.Hom.appIso f W').inv_hom_id x).symm

open Opposite in
/-- **ε is an iso for the section-ring relabel** `X.presheaf.map (eqToHom e)` (an `eqToHom`-induced,
hence bijective, ring map between section rings `𝒪_X(b) → 𝒪_X(a)` for `a = b`).  Phrased at the
`X.presheaf` (`CommRingCat`) carrier so `CommRing` is native (`analogies/ma-legb262.md`). -/
lemma isIso_ε_restrictScalars_presheafMap {X : Scheme.{u}}
    {a b : (TopologicalSpace.Opens ↥X)ᵒᵖ} (e : a = b) :
    IsIso (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (X.presheaf.map (eqToHom e)).hom)) :=
  restrictScalars_isIso_ε_of_bijective (X.presheaf.map (eqToHom e)).hom
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (X.presheaf.map (eqToHom e)))

open Opposite in
/-- **Unit-section relabel swap** `restrictScalars (X.presheaf.map (eqToHom e)) (𝟙_X(b)) ⟶ 𝟙_X(a)`
for `a = b` (section opens of `X`).  It is `inv ε` of the relabel ring map, an isomorphism by
`isIso_ε_restrictScalars_presheafMap`.  This is the `?unit` codomain transport of
`sliceDualTransportInv`'s reverse component (mirror of `dualUnitRingSwap` for the `he`-relabel). -/
noncomputable def unitRelabelSwap {X : Scheme.{u}}
    {a b : (TopologicalSpace.Opens ↥X)ᵒᵖ} (e : a = b) :
    (ModuleCat.restrictScalars (X.presheaf.map (eqToHom e)).hom).obj
        (𝟙_ (ModuleCat ↑(X.presheaf.obj b))) ⟶
      𝟙_ (ModuleCat ↑(X.presheaf.obj a)) :=
  haveI := isIso_ε_restrictScalars_presheafMap e
  CategoryTheory.inv (Functor.LaxMonoidal.ε
    (ModuleCat.restrictScalars (X.presheaf.map (eqToHom e)).hom))

open Opposite in
/-- The underlying map of `unitRelabelSwap` is the reverse relabel `X.presheaf.map (eqToHom e.symm)`
(pointwise mirror of `dualUnitRingSwap_apply`, by the same injectivity rotation). -/
lemma unitRelabelSwap_apply {X : Scheme.{u}}
    {a b : (TopologicalSpace.Opens ↥X)ᵒᵖ} (e : a = b)
    (x : (X.presheaf.obj b : Type u)) :
    (unitRelabelSwap e).hom x = (X.presheaf.map (eqToHom e.symm)).hom x := by
  haveI := isIso_ε_restrictScalars_presheafMap e
  have h := congrArg ModuleCat.Hom.hom
    (IsIso.inv_hom_id (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (X.presheaf.map (eqToHom e)).hom)))
  have hx := DFunLike.congr_fun h x
  change (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (X.presheaf.map (eqToHom e)).hom)).hom
      ((unitRelabelSwap e).hom x) = x at hx
  have hx' : (X.presheaf.map (eqToHom e)).hom ((unitRelabelSwap e).hom x) = x := by
    simpa only [ModuleCat.restrictScalars_η] using hx
  have hinj : Function.Injective (X.presheaf.map (eqToHom e)).hom :=
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (X.presheaf.map (eqToHom e))).1
  apply hinj
  rw [hx']
  have hcomp : X.presheaf.map (eqToHom e.symm) ≫ X.presheaf.map (eqToHom e) = 𝟙 _ := by
    rw [← Functor.map_comp, eqToHom_trans, eqToHom_refl]
    exact X.presheaf.map_id b
  exact (ConcreteCategory.congr_hom hcomp x).symm

open Opposite in
/-- **Pointwise naturality of the `.hom` direction of the structure ring iso**: `(f.appIso _).hom`
intertwines the `X`- and `Y`-restriction maps. Rotated from `Scheme.Hom.appIso_inv_naturality`
through the iso by injectivity of the `.inv` leg (never touching `inv ε`). This is the single
ring-level square powering all four `SliceTransport` naturality/round-trip pastes. -/
lemma appIso_hom_naturality_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    {U V : TopologicalSpace.Opens ↥Y} (i : op U ⟶ op V)
    (w : (X.presheaf.obj (op ((Hom.opensFunctor f).obj U)) : Type u)) :
    (Scheme.Hom.appIso f V).hom.hom ((X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom w)
      = (Y.presheaf.map i).hom ((Scheme.Hom.appIso f U).hom.hom w) := by
  have hinj : Function.Injective (Scheme.Hom.appIso f V).inv.hom :=
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (Scheme.Hom.appIso f V).inv).1
  apply hinj
  have hVcancel : (Scheme.Hom.appIso f V).inv.hom ((Scheme.Hom.appIso f V).hom.hom
      ((X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom w))
      = (X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom w :=
    ConcreteCategory.congr_hom (Scheme.Hom.appIso f V).hom_inv_id _
  rw [hVcancel]
  have hUw : (Scheme.Hom.appIso f U).inv.hom ((Scheme.Hom.appIso f U).hom.hom w) = w :=
    ConcreteCategory.congr_hom (Scheme.Hom.appIso f U).hom_inv_id w
  have h1 := ConcreteCategory.congr_hom (Scheme.Hom.appIso_inv_naturality f i)
    ((Scheme.Hom.appIso f U).hom.hom w)
  change (Scheme.Hom.appIso f V).inv.hom
      ((Y.presheaf.map i).hom ((Scheme.Hom.appIso f U).hom.hom w))
      = (X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom
        ((Scheme.Hom.appIso f U).inv.hom ((Scheme.Hom.appIso f U).hom.hom w)) at h1
  rw [hUw] at h1
  exact h1.symm

open PresheafOfModules InternalHom Opposite in
/-- **Pointwise naturality square of the reverse slice-transport family** (the `app` of
`sliceDualTransportInv`), extracted standalone (mirror of `sliceDualTransport_naturality_apply`).

For `f₁ : X₁ ⟶ Y₁` in `(Over fV)ᵒᵖ` (with `fV = f.opensFunctor.obj V.unop`), the reverse-transport
component at `Y₁` precomposed with the slice restriction of `M.val` equals the component at `X₁`
postcomposed with the unit restriction.  The two `inv ε` legs (`unitRelabelSwap`, `dualUnitRingSwapHom`)
are kept SHALLOW here so their proven `_apply` lemmas fire cheaply (never `whnf`-reducing the deep
composite — the documented heartbeat trap).  The genuine content is `ψ`-naturality at the slice
morphism `f⁻¹ᵁ Y₁ ⟶ f⁻¹ᵁ X₁` plus the ring square `appIso_inv_naturality` and the thin-poset
`eqToHom` coherence on `Opens X`.  The down-set facts are passed explicitly so everything is nameable. -/
lemma sliceDualTransportInv_naturality_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ)
    (β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj)
    (hβ : ∀ (P : TopologicalSpace.Opens ↥Y),
        ((β.app (op P)).hom).comp ((Scheme.Hom.appIso f P).hom.hom) = RingHom.id _)
    (ψ : (((PresheafOfModules.pushforward β).obj M.val).dual.obj V : Type u))
    {X₁ Y₁ : (Over ((Hom.opensFunctor f).obj (unop V)))ᵒᵖ} (f₁ : X₁ ⟶ Y₁)
    (z : (M.val.obj (op (unop X₁).left) : Type u))
    (hPVX : f ⁻¹ᵁ (unop X₁).left ≤ unop V)
    (heX : f ''ᵁ (f ⁻¹ᵁ (unop X₁).left) = (unop X₁).left)
    (hPVY : f ⁻¹ᵁ (unop Y₁).left ≤ unop V)
    (heY : f ''ᵁ (f ⁻¹ᵁ (unop Y₁).left) = (unop Y₁).left) :
    (unitRelabelSwap (congrArg op heY.symm)).hom
        ((dualUnitRingSwapHom f (f ⁻¹ᵁ (unop Y₁).left)).hom
          ((ψ.app (op (Over.mk (homOfLE hPVY)))).hom
            ((M.val.map (eqToHom (congrArg op heY.symm))).hom
              (((restr ((Hom.opensFunctor f).obj (unop V)) M.val).map f₁).hom z))))
      = ((restr ((Hom.opensFunctor f).obj (unop V))
            (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))).map f₁).hom
          ((unitRelabelSwap (congrArg op heX.symm)).hom
            ((dualUnitRingSwapHom f (f ⁻¹ᵁ (unop X₁).left)).hom
              ((ψ.app (op (Over.mk (homOfLE hPVX)))).hom
                ((M.val.map (eqToHom (congrArg op heX.symm))).hom z)))) := by
  rw [unitRelabelSwap_apply, unitRelabelSwap_apply, dualUnitRingSwapHom_apply,
    dualUnitRingSwapHom_apply]
  -- order facts on the thin poset
  have hba : (unop Y₁).left ≤ (unop X₁).left := ((Over.forget _).map f₁.unop).le
  have hPYX : f ⁻¹ᵁ (unop Y₁).left ≤ f ⁻¹ᵁ (unop X₁).left :=
    (TopologicalSpace.Opens.map f.base).monotone hba
  -- ψ-naturality at the slice morphism `(P_Y-slice) ⟶ (P_X-slice)` over `Over V.unop`
  have hψ := PresheafOfModules.naturality_apply ψ
    (Over.homMk (homOfLE hPYX) (Subsingleton.elim _ _) :
      (Over.mk (homOfLE hPVY) : Over (unop V)) ⟶ Over.mk (homOfLE hPVX)).op
    ((M.val.map (eqToHom (congrArg op heX.symm))).hom z)
  sorry

open PresheafOfModules InternalHom Opposite in
/-- **Reverse slice transport (the `invFun` of `sliceDualTransport`), extracted top-level.**

Given a dual section `ψ : restr V ((pushforward β).obj M.val) ⟶ restr V 𝟙_Y` over `Over V`,
this produces the X-slice dual section `restr fV M.val ⟶ restr fV 𝟙_X` over `Over fV`
(`fV = f.opensFunctor.obj V.unop`), the mirror of `sliceDualTransport`'s forward `toFun`.

For `W'' : (Over fV)ᵒᵖ`, set `P := f⁻¹ᵁ W''.left` (so `f.opensFunctor.obj P = W''.left` only
propositionally, via `image_preimage_of_le` since `fV ⊆ range f`).  The component at `W''` is the
X-slice mirror of the forward component, conjugated by the `eqToHom`s from `image_preimage_of_le`
(mirror of `homLocalSection`):
`eqToHom … ≫ (restrictScalars (f.appIso P).hom.hom).map (ψ.app (op (Over.mk (homOfLE hPV)))) ≫
  dualUnitRingSwapHom f P`,
the codomain swap being `dualUnitRingSwapHom = inv (ε (restrictScalars (f.appIso P).hom.hom))`
(the `.hom`-direction `inv ε`). -/
noncomputable def sliceDualTransportInv {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ)
    (β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj)
    -- β-compatibility (iter-303): `β` is the open-immersion structure ring iso `(f.appIso).inv`,
    -- so post-composing it with `(f.appIso P).hom` is the identity on `𝒪_X(f''ᵁP)`.  This is the
    -- load-bearing ring identity that collapses the double `restrictScalars` in the reverse
    -- component (`?collapse`); it is FALSE for an arbitrary `β`, hence supplied as a hypothesis and
    -- discharged at the unique caller (`sliceDualTransport.invFun`) via `Iso.hom_inv_id`.
    (hβ : ∀ (P : TopologicalSpace.Opens ↥Y),
        ((β.app (op P)).hom).comp ((Scheme.Hom.appIso f P).hom.hom) = RingHom.id _)
    (ψ : (((PresheafOfModules.pushforward β).obj M.val).dual.obj V : Type u)) :
    (((PresheafOfModules.pushforward β).obj M.val.dual).obj V : Type u) := by
  refine { app := fun W'' => ?_, naturality := ?_ }
  · -- app component at `W''` (over `fV`).  `W' := (unop W'').left ≤ fV`; `P := f⁻¹ᵁ W'`.
    -- The down-set facts are established (axiom-clean); the morphism itself is the documented
    -- residual below.
    set W' := (unop W'').left with hW'
    have hW'fV : W' ≤ f ''ᵁ (unop V) := (unop W'').hom.le
    have hPV : f ⁻¹ᵁ W' ≤ unop V :=
      le_trans ((TopologicalSpace.Opens.map f.base).monotone hW'fV)
        (le_of_eq (f.preimage_image_eq (unop V)))
    have he : f ''ᵁ (f ⁻¹ᵁ W') = W' := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
      exact inf_eq_right.mpr (hW'fV.trans (f.image_le_opensRange (unop V)))
    -- **app component — CLOSED axiom-clean (iter-303).**  The X-slice mirror of the forward
    -- `toFun`, conjugated across the propositional preimage round-trip `he : f''ᵁ(f⁻¹ᵁ W') = W'`.
    -- It is the four-leg composite (all legs concrete):
    --   (1) `M.val.map (eqToHom (op he.symm))` : source relabel `M.val(W') ⟶ restr_ρ M.val(fP)`
    --       (SEMILINEAR — codomain restricted along `ρ = X.ringCatSheaf.map (eqToHom (op he.symm))`,
    --       crossing the `𝒪_X(W') ↔ 𝒪_X(fP)` fiber);
    --   (2) `restrictScalars ρ |>.map (?collapse ≫ core)` transports the in-fiber-`fP` core:
    --       `?collapse` (the double-restrict collapse `M.val(fP) ≅ restrictScalars (f.appIso P).hom
    --       (restrictScalars (β.app P) (M.val fP))` via `restrictScalarsId'App` + `restrictScalarsComp'App`
    --       fed the ring identity `hβ (f⁻¹ᵁ W')`), and `core` (legs (3) ψ-reindex `restrictScalars
    --       (f.appIso P).hom |>.map (ψ.app …)` + (4) codomain unit swap `dualUnitRingSwapHom f P`);
    --   (3) `unitRelabelSwap (op he.symm)` : the codomain unit transport `restrictScalars ρ 𝟙_X(fP)
    --       ⟶ 𝟙_X(W')` (`inv ε` of the relabel, the new top-level helper).
    -- The cross-fiber transport (a single `≫`-chain cannot express it — the relabel is semilinear)
    -- is realised by applying the functor `restrictScalars ρ` to the in-fiber-`fP` core.
    -- **core (legs 3+4): VERIFIED well-formed in fiber `𝒪_X(fP)` (iter-303).**  The ψ-reindex
    -- `restrictScalars (f.appIso P).hom ∘ ψ.app` post-composed with the codomain unit swap
    -- `dualUnitRingSwapHom f P` assembles into
    --   `core : restrictScalars (f.appIso P).hom ((pushforward β M.val)(P)) ⟶ 𝟙_X(fP)`,
    -- a morphism of `ModuleCat 𝒪_X(fP)`.  (NB: the leg-3 target `restrictScalars (f.appIso P).hom
    -- ((restr V 𝟙_Y)-section)` DID defeq-unify with leg-4's `restrictScalars (f.appIso P).hom
    -- (𝟙_ (ModuleCat 𝒪_Y(P)))` — the unit-spelling reconciles here, exactly as in the closed
    -- forward `toFun`.)
    have core := (ModuleCat.restrictScalars (Scheme.Hom.appIso f (f ⁻¹ᵁ W')).hom.hom).map
        (ψ.app (op (Over.mk (homOfLE hPV)))) ≫ dualUnitRingSwapHom f (f ⁻¹ᵁ W')
    -- **Cross-fiber transport — CLOSED (iter-303).**  The goal lives in `ModuleCat 𝒪_X(W')` but
    -- `core` lives in `ModuleCat 𝒪_X(fP)` (`fP = f''ᵁf⁻¹ᵁW'`, propositionally `= W'` via `he`, but
    -- the section RINGS `𝒪_X(W')` / `𝒪_X(fP)` are only propositionally equal).  The source relabel
    -- `M.val(W') ⟶ M.val(fP)` is `M.val.map (eqToHom (op he.symm))` — SEMILINEAR, landing in
    -- `restrictScalars (X.ringCatSheaf.map (eqToHom …))`; combined with the source double-restrict
    -- collapse `restrictScalars (f.appIso P).hom ∘ restrictScalars (β.app P) ≅ restrictScalars 𝟙
    -- ≅ id` (ring identity `hβ (f⁻¹ᵁ W')`: `(β.app P).hom ∘ (f.appIso P).hom.hom = 𝟙_{𝒪_X(fP)}`,
    -- collapsed by `ModuleCat.restrictScalarsComp'App` + `restrictScalarsId'App`).  A single
    -- `≫`-chain in one `ModuleCat` cannot express this — the relabel crosses ring fibers — so `core`
    -- is conjugated across the `𝒪_X(fP) ↔ 𝒪_X(W')` fiber by applying the functor
    -- `restrictScalars (X.ringCatSheaf.map (eqToHom (op he.symm)))` to `?collapse ≫ core` (per memory
    -- `ts271-slicedualtransportinv`).  This cross-fiber transport is the next fine-grained target.
    refine M.val.map (eqToHom (congrArg op he.symm)) ≫
      (ModuleCat.restrictScalars ((X.ringCatSheaf.obj.map (eqToHom (congrArg op he.symm))).hom)).map
        (?collapse ≫ core) ≫ ?unit
    case collapse =>
      -- Collapse the double `restrictScalars` on `M.val(fP)` to the identity, using the ring
      -- identity `hβ (f⁻¹ᵁ W')` (`(β.app P).hom ∘ (f.appIso P).hom = 𝟙`).
      exact (ModuleCat.restrictScalarsId'App _ (hβ (f ⁻¹ᵁ W'))
            (M.val.obj (op (f ''ᵁ f ⁻¹ᵁ W')))).inv ≫
        (ModuleCat.restrictScalarsComp'App ((Scheme.Hom.appIso f (f ⁻¹ᵁ W')).hom.hom)
            ((β.app (op (f ⁻¹ᵁ W'))).hom) _ rfl (M.val.obj (op (f ''ᵁ f ⁻¹ᵁ W')))).hom
    case unit =>
      -- **Unit transport (?unit) — CLOSED (iter-303).**  Goal:
      -- `restrictScalars ρ (𝟙_ ModuleCat 𝒪_X(fP)) ⟶ (restr fV 𝟙_X).obj W''`, with
      -- `ρ = X.presheaf.map (eqToHom (op he.symm)) : 𝒪_X(W') → 𝒪_X(fP)` the (bijective, eqToHom-
      -- induced) section-ring relabel.  This is `inv (ε (restrictScalars ρ))`, supplied by the new
      -- top-level helper `unitRelabelSwap` (phrased at the `X.presheaf` CommRingCat carrier so
      -- `CommRing`/`LaxMonoidal` are native — the direct in-place `inv ε` cannot be FORMED here
      -- because the `set`-local `W'` blocks call-site `CommRing ↑(X.presheaf.obj (op W'))` synthesis).
      -- The `X.ringCatSheaf.map`-vs-`X.presheaf.map` and unit-section spellings reconcile by defeq.
      exact unitRelabelSwap (congrArg op he.symm)
  · -- **naturality of the reverse component (the sole remaining hole of `sliceDualTransportInv`,
    -- iter-303 — `app` is now fully CLOSED).**  The thin-poset square over `(Over fV)ᵒᵖ`: for
    -- `f_1 : X_1 ⟶ Y_1`, `restr.map f_1 ≫ app Y_1 = app X_1 ≫ (restr 𝟙_X).map f_1`.  Each `app`
    -- is now the explicit 4-piece composite `M.val.map (eqToHom he) ≫ restrictScalars(ρ).map
    -- (collapse ≫ core) ≫ unitRelabelSwap`; the base maps of `Opens X` agree by `Subsingleton.elim`,
    -- but the four legs (the `eqToHom`/`restrictScalarsComp'App`/`restrictScalarsId'App` transports,
    -- the `ψ`-reindex `core`, and the two ε-swaps) must be slid through the restriction `.map` — an
    -- `erw`-level paste mirroring `homLocalSection.naturality`, NOT yet assembled.  Parallels the
    -- still-open forward `sliceDualTransport.naturality`.
    intro X₁ Y₁ f₁
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    exact sliceDualTransportInv_naturality_apply f M V β hβ ψ f₁ z
      (le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop X₁).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V))))
      (by rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
          exact inf_eq_right.mpr ((unop X₁).hom.le.trans (f.image_le_opensRange (unop V))))
      (le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop Y₁).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V))))
      (by rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
          exact inf_eq_right.mpr ((unop Y₁).hom.le.trans (f.image_le_opensRange (unop V))))

open PresheafOfModules InternalHom Opposite in
/-- **Pointwise naturality square of the forward slice-transport family** (the `toFun` of
`sliceDualTransport`): the `dualUnitRingSwap`-conjugated reindex of a dual section `φ` commutes
with the slice restriction maps. The `inv ε` legs are evaluated through the proven
`dualUnitRingSwap_apply` (never `whnf`-reduced); the genuine content is `φ`-naturality at the
`f`-image of `f₁` plus the ring square `appIso_hom_naturality_apply`. Extracted standalone so
the heavy steps have their own heartbeat budget (the parent def is at its elaboration limit). -/
lemma sliceDualTransport_naturality_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ)
    (φ : restr ((Hom.opensFunctor f).obj (unop V)) M.val ⟶
        restr ((Hom.opensFunctor f).obj (unop V))
          (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))))
    {X₁ Y₁ : (Over (unop V))ᵒᵖ} (f₁ : X₁ ⟶ Y₁)
    (z : (M.val.obj (op ((Hom.opensFunctor f).obj (unop X₁).left)) : Type u)) :
    (dualUnitRingSwap f (unop Y₁).left).hom
        ((φ.app (op (Over.mk ((Hom.opensFunctor f).map (unop Y₁).hom)))).hom
          ((M.val.map ((Hom.opensFunctor f).map ((Over.forget (unop V)).map f₁.unop)).op).hom z))
      = (Y.presheaf.map ((Over.forget (unop V)).map f₁.unop).op).hom
          ((dualUnitRingSwap f (unop X₁).left).hom
            ((φ.app (op (Over.mk ((Hom.opensFunctor f).map (unop X₁).hom)))).hom z)) := by
  -- the `f`-image of `f₁` in the X-slice (thin poset: the `w`-triangle is `Subsingleton.elim`)
  have hκw : (Hom.opensFunctor f).map f₁.unop.left ≫
      (Over.mk ((Hom.opensFunctor f).map (unop X₁).hom)).hom
      = (Over.mk ((Hom.opensFunctor f).map (unop Y₁).hom)).hom := Subsingleton.elim _ _
  -- φ-naturality at the image morphism (entirely forward — no `inv ε` involved)
  have hnat := PresheafOfModules.naturality_apply φ
    ((Over.homMk ((Hom.opensFunctor f).map f₁.unop.left) hκw :
        Over.mk ((Hom.opensFunctor f).map (unop Y₁).hom) ⟶
          Over.mk ((Hom.opensFunctor f).map (unop X₁).hom)).op) z
  refine (dualUnitRingSwap_apply f (unop Y₁).left _).trans ?_
  refine Eq.trans ?_ (congrArg (Y.presheaf.map ((Over.forget (unop V)).map f₁.unop).op).hom
    (dualUnitRingSwap_apply f (unop X₁).left _).symm)
  refine Eq.trans (congrArg (Scheme.Hom.appIso f (unop Y₁).left).hom.hom hnat) ?_
  exact appIso_hom_naturality_apply f (((Over.forget (unop V)).map f₁.unop).op)
    ((φ.app (op (Over.mk ((Hom.opensFunctor f).map (unop X₁).hom)))).hom z)

open PresheafOfModules InternalHom Opposite in
/-- **Leg (A)∘(B): the sectionwise slice transport of the dual along an open immersion.**

For an open immersion `f : Y ⟶ X`, `M : X.Modules`, and an open `V` of `Y` (as `(Opens Y)ᵒᵖ`),
this is the `𝒪_Y(V)`-linear isomorphism between the two sectionwise values of the Step-4 residual
of `dual_restrict_iso`:
```
  ((pushforward β).obj (dual M.val)).obj V  ≅  (dual ((pushforward β).obj M.val)).obj V
```
where `β` is the open-immersion structure ring morphism `Y.ringCatSheaf ⟶ f.opensFunctor.op ⋙
X.ringCatSheaf` (`β.app U = (forget₂ _ _).map (f.appIso U).inv`).

The construction mirrors `homLocalSection` (the thin-poset `eqToHom`-conjugation slice transport)
composed with `restrictScalarsRingIsoDualEquiv` (the `𝒪_Y(V)`-linear codomain-unit ring swap of leg
(B)): a dual section `φ : restr fV M.val ⟶ restr fV 𝟙_X` over `Over (fV)` is reindexed across
`f.opensFunctor` to a dual section over `Over V`, conjugating each component by the structure ring
iso `f.appIso`; naturality on the thin poset `Opens Y` is `Subsingleton.elim`. -/
noncomputable def sliceDualTransport {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ) :
    letI α : Y.presheaf ⟶ (Hom.opensFunctor f).op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv }
    letI β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    (((PresheafOfModules.pushforward β).obj (PresheafOfModules.dual M.val)).obj V) ≅
      ((PresheafOfModules.dual ((PresheafOfModules.pushforward β).obj M.val)).obj V) := by
  -- CONSTRUCTION PLAN (homLocalSection-style leg (A) ∘ restrictScalarsRingIsoDualEquiv leg (B)):
  --
  -- Write `fV := f.opensFunctor.obj V.unop`.  By `PresheafOfModules.pushforward_obj_obj`,
  --   LHS carrier `L = (dual M.val).obj (op fV) = (restr fV M.val ⟶ restr fV 𝟙_X)`,
  --     a `𝒪_X(fV)`-module restricted along `β.app V : 𝒪_Y(V) ⟶ 𝒪_X(fV)` to a `𝒪_Y(V)`-module;
  --   RHS carrier `Rr = (restr V.unop ((pushforward β).obj M.val) ⟶ restr V.unop 𝟙_Y)`,
  --     a `𝒪_Y(V)`-module via `internalHomObjModule`.
  --
  -- Build a `𝒪_Y(V)`-linear equivalence `e : L ≃ₗ[𝒪_Y(V)] Rr` and return `e.toModuleIso`.
  --
  -- `e.toFun φ` (for `φ : restr fV M.val ⟶ restr fV 𝟙_X`) is the dual section over `Over V`
  -- whose component at `W : (Over V.unop)ᵒᵖ` (so `W' := W.unop.left ≤ V.unop`, with image
  -- `fW' := f.opensFunctor.obj W'`) is
  --   `(restr V.unop ((pushforward β).obj M.val)).obj W  ≃defeq  M.val.obj (op fW')`
  --     --[ φ.app (op (Over.mk (f.opensFunctor.map W.unop.hom))) ]-->  X.ring(fW')
  --     --[ (f.appIso W').hom : 𝒪_X(fW') ≅ 𝒪_Y(W') ]-->  Y.ring(W')  =  (restr V.unop 𝟙_Y).obj W,
  -- packaged as a `ModuleCat` hom over `𝒪_Y(W')`.  Naturality of this family in `W` is automatic
  -- on the thin poset `Opens Y` (`Subsingleton.elim` on the base maps, exactly as in
  -- `homLocalSection`'s `naturality` field).  `e.invFun` is the same with `(f.appIso W').inv` and
  -- the inverse reindexing (every `W'' ≤ fV` is `f.opensFunctor.obj (f⁻¹ᵁ W'')` since
  -- `fV ⊆ range f`); `left_inv`/`right_inv` collapse by `Iso.inv_hom_id`/`hom_inv_id` of `f.appIso`
  -- plus the down-set bijection `image_preimage_of_le`.  `𝒪_Y(V)`-linearity (`map_smul'`) is the
  -- `globalSMul`/`homModule`-action compatibility (post-composition with the structure scalar),
  -- intertwined by the ring iso — the presheaf-level shadow of `restrictScalarsRingIsoDualEquiv`'s
  -- `map_smul'`.
  --
  -- The single load-bearing sub-build is `e.toFun`'s underlying `PresheafOfModules.Hom`; it is a
  -- structural copy of `homLocalSection` (component conjugation by `eqToHom` + the `f.appIso` ring
  -- iso) and of `dualPrecompEquiv` (the `≃ₗ` packaging).
  --
  -- STATUS (iter-260): the directive's first step is executed in CODE below —
  -- `refine LinearEquiv.toModuleIso ?_` reduces this iso goal to the `𝒪_Y(V)`-linear equivalence
  --   `(restr fV' M.val ⟶ restr fV' 𝟙_X)  ≃ₗ[𝒪_Y(V)]`
  --   `  (restr V ((pushforward β) M.val) ⟶ restr V 𝟙_Y)`
  -- (the `Module 𝒪_Y(V)` instances DO synthesize automatically — no `letI Module.compHom` is
  -- needed at this step, contra the directive's worry; `fV' = f.opensFunctor.obj V.unop`).
  --
  -- ROUTE-(1) STRUCTURAL INSUFFICIENCY (the EXACT failing step the armed reversing signal asked to
  -- report).  The directive's route (1) is "consume `restrictOverIso`/`unitOverIso` localized to
  -- `V`".  This CANNOT close the reduced `≃ₗ`:
  --   • `restrictOverIso U M : (overEquivalence U).functor.obj (M.restrict U.ι) ≅ M.over U` and
  --     `unitOverIso U : (overEquivalence U).functor.obj (unit _) ≅ unit _` are isomorphisms of
  --     SHEAF objects (`SheafOfModules (X.ringCatSheaf.over U)`) of the modules `M`, `𝟙_`.  They
  --     say nothing about `dual`/internal-hom.
  --   • The reduced goal is a `≃ₗ` between two PRESHEAF internal-hom SECTION modules over DIFFERENT
  --     slice categories (`Over_X fV'` vs `Over_Y V`).  Its content is exactly that the dual
  --     (`internalHomPresheaf · 𝟙_`) COMMUTES with the slice reindexing along `f.opensFunctor`.
  --   • Producing that commutation from the shared root would require `(overEquivalence U).functor`
  --     (a `SheafOfModules.pushforward`) to PRESERVE internal hom, i.e. to be strong monoidal
  --     CLOSED.  Neither `restrictOverIso`/`unitOverIso` nor any project decl supplies this; the
  --     `MonoidalClosed (PresheafOfModules R₀)` structure it needs is the wall the project
  --     deliberately avoids (TensorObjSubstrate §2 `rem:scheme_modules_monoidal_off_path`,
  --     PresheafInternalHom.lean:538).  GREPPED: the shared root has NO dual/internalHom lemma.
  -- ⇒ route (1) is insufficient by construction, not by tactic difficulty.
  --
  -- STATUS (iter-261, ROUTE-2 SANCTIONED + EXECUTED below): route (1) is dead (see above); the
  -- genuine close is route (2), built BY HAND in the code below.  Progress this iter:
  --   • The `Module 𝒪_Y(V)` instance walls are RESOLVED — `set β` folds the goal, and the LHS/RHS
  --     module instances are pinned (`lhsMod` = `inferInstance`, `rhsMod` = `internalHomObjModule`)
  --     and supplied to `LinearEquiv.toModuleIso (m₁ := …) (m₂ := …)` (the bare structure-literal
  --     re-synthesis on the `pushforward₀`-reduced carrier fails — `m₁`/`m₂` MUST be passed).
  --   • toFun's leg-A (reindex `φ` across `f.opensFunctor` via `(restrictScalars β_W).map (φ.app …)`)
  --     is BUILT and typechecks (categorical `.map` avoids the carrier-instance loss that raw
  --     `ModuleCat.ofHom` triggers).
  -- REMAINING (typed sorries below, with the exact obstacle on each): codomainMap (leg-B unit ring
  -- swap = `inv (ε (restrictScalars β_W))`, blocked on a CommRing-instance recovery + a `𝟙_`-vs-
  -- `restr`-section defeq bridge), the toFun naturality (thin-poset `Subsingleton.elim`), invFun
  -- (mirror with `(f.appIso W').inv`), and the four `≃ₗ` proof fields.
  set β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight ({ app := fun U ↦ (Hom.appIso f (Opposite.unop U)).inv } :
      Y.presheaf ⟶ (Hom.opensFunctor f).op ⋙ X.presheaf) (forget₂ CommRingCat RingCat) with hβ
  letI lhsMod : Module (Y.ringCatSheaf.obj.obj V : Type u)
      (((PresheafOfModules.pushforward β).obj (PresheafOfModules.dual M.val)).obj V : Type u) :=
    inferInstance
  letI rhsMod : Module (Y.ringCatSheaf.obj.obj V : Type u)
      ((PresheafOfModules.dual ((PresheafOfModules.pushforward β).obj M.val)).obj V : Type u) :=
    InternalHom.internalHomObjModule (R := Y.presheaf) V.unop
      ((PresheafOfModules.pushforward β).obj M.val) (𝟙_ _)
  refine LinearEquiv.toModuleIso (m₁ := lhsMod) (m₂ := rhsMod) ?_
  refine
    { toFun := fun φ =>
        { app := fun W =>
            -- leg-A: reindex `φ` across `f.opensFunctor` (`restrictScalars β_W` of the `f`-image
            -- component of `φ`), built categorically via `.map` (avoids the `restrictScalars`
            -- carrier-instance loss that raw `ModuleCat.ofHom` triggers).
            (ModuleCat.restrictScalars (β.app (Opposite.op W.unop.left)).hom).map
                (φ.app (Opposite.op (Over.mk (Hom.opensFunctor f |>.map W.unop.hom)))) ≫
              -- leg-B: codomain unit ring-iso swap `restrictScalars β_W (𝟙_X(fW')) ⟶ 𝟙_Y(W')`,
              -- supplied by the named `dualUnitRingSwap` (= `inv (ε (restrictScalars (f.appIso W').inv))`,
              -- an iso by `isIso_ε_restrictScalars_appIso`).  Its `CommRingCat`-carrier endpoints
              -- reconcile by `rfl`/defeq with the `restr`/`𝟙_`-section spellings of this hole
              -- (`analogies/ma-legb262.md`); the `β.app`/`(f.appIso _).inv.hom` ring maps agree by `rfl`.
              dualUnitRingSwap f W.unop.left
          naturality := ?_ }
      invFun := ?_
      map_add' := ?_
      map_smul' := ?_
      left_inv := ?_
      right_inv := ?_ }
  -- codomainMap is now supplied inline by `dualUnitRingSwap f W.unop.left` (leg-B CLOSED, iter-262;
  -- the `CommRingCat`-carrier endpoints reconcile by `rfl`/defeq with the `restr`/`𝟙_` section forms).
  -- The remaining six fields are the (instance-delicate) `≃ₗ`-packaging; goal order (verified by
  -- `lean_goal`): naturality, map_add', map_smul', invFun, left_inv, right_inv.
  --
  -- (1) naturality of the leg-A∘leg-B family in `W`: the thin-poset `Subsingleton.elim` square over
  --     `(Over (unop V))ᵒᵖ`.  After `apply PresheafOfModules.hom_ext`, the connecting `restr`-map
  --     edges agree by `Subsingleton.elim` on the base hom-sets, but the `restrictScalars`-functor
  --     `.map` of the reindexed `φ.app` must be commuted through `dualUnitRingSwap` — needs the
  --     ε-naturality of `restrictScalars` along the structure ring iso (an `erw`-level paste, NOT
  --     yet built).
  · intro X₁ Y₁ f₁
    -- naturality CLOSED (iter-007): pointwise glue into the extracted standalone square
    -- `sliceDualTransport_naturality_apply` (kept cheap here — the def is at its heartbeat limit).
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    exact sliceDualTransport_naturality_apply f M V φ f₁ z
  -- (2) map_add': `toFun (x+y) = toFun x + toFun y`.  CLOSED (iter-263) with the verified
  --     `analogies/ma-ihom263.md` recipe: the `internalHomObjModule`-add IS the ambient
  --     `PresheafOfModules.Hom` Preadditive add (single shared add), so the `change`-reshape +
  --     `show … from rfl` bridge + `Functor.map_add` (`restrictScalars` is `Additive`) +
  --     `Preadditive.add_comp` (distributing the post-composed `dualUnitRingSwap`) closes outright.
  · intro x y
    apply PresheafOfModules.hom_ext
    intro W
    change (ModuleCat.restrictScalars _).map ((x + y).app _) ≫ _ = _
    rw [show (x + y).app (op (Over.mk ((Hom.opensFunctor f).map (unop W).hom)))
          = x.app (op (Over.mk ((Hom.opensFunctor f).map (unop W).hom)))
            + y.app (op (Over.mk ((Hom.opensFunctor f).map (unop W).hom))) from rfl,
        Functor.map_add, Preadditive.add_comp]
    rfl
  -- (3) map_smul' (iter-263): REDUCED to a precise crux (the `change`-opener of ma-ihom263 + the
  --     genuine smul unfold).  Both `internalHomObjModule` smuls are exposed via `comp_app`:
  --       • LHS  `(m • x).app W''` is the `homModule` X-side action — `x.app W'' ≫ globalSMul s`
  --         with `s = termRingMap (Over fV') W'' ((β.app V) m)` (the pushforward restricts scalars
  --         along `β.app V`, then `homModule` post-composes `globalSMul`);
  --       • RHS  `(m • toFun-section).app W` is the `homModule` Y-side action with scalar
  --         `c = termRingMap (Over V) W m`.
  --     After `ModuleCat.hom_ext`/`LinearMap.ext z` + the `simp only` below the goal is the
  --     SECTIONWISE crux (`u := x.app W''.hom z`):
  --         `dualUnitRingSwap.hom (s • u)  =  c • (toFun-section).hom z`   [RHS `≡defeq c • d.hom u`].
  --     The SOLE remaining content (not a structural wall — tactic friction only):
  --       (i)  the β-naturality ring identity `s = (β.app W').hom c`
  --            (`InternalHom.termRingMap_naturality` + `β.naturality` on the thin poset `Opens Y`,
  --            matching the slice `termRingMap`s to the base restriction via `opensFunctor`); then
  --       (ii) `dualUnitRingSwap.hom` is `𝒪_Y(W')`-linear: `d.hom ((β.app W').hom c • u)
  --            = d.hom (c •_restrictScalars u) = c • d.hom u` via
  --            `ModuleCat.restrictScalars.smul_def'` (verified to fire, `←` direction) + `map_smul`.
  --     BLOCKER: the RHS `(toFun-section).hom z` is a `{app := …}.app W` PROJECTION that is
  --     defeq-but-not-syntactic to `d.hom u`, so `rw [ModuleCat.hom_comp]` / a hand-written
  --     `show … from rfl` both report "pattern not found"; closing (ii) needs a `conv`/`change`
  --     that survives the projection (next fine-grained pass).
  · intro m x
    apply PresheafOfModules.hom_ext
    intro W
    change (ModuleCat.restrictScalars _).map ((m • x).app _) ≫ _
        = _ ≫ (globalSMul Over.mkIdTerminal
            (restr (unop V) (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))))
            ((RingHom.id _) m)).app W
    erw [PresheafOfModules.comp_app]
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply, globalSMul_hom_apply,
      ModuleCat.restrictScalars.map_apply]
    -- Abbreviations: `W' = (unop W).left`, `A = op (Over.mk (opensFunctor.map W.hom))`,
    -- `u = (x.app A).hom z`, `d = dualUnitRingSwap f W'`.  After the `simp only` the goal is
    --   `d.hom (s • u) = c • (g ≫ d).hom z`
    -- with `s = (termRingMap A) ((β.app V) m)`, `c = (termRingMap W) m`,
    -- `g = (restrictScalars (β.app (op W')).hom).map (x.app A)`.
    -- Step 1. Reduce the RHS value `(g ≫ d).hom z` to `d.hom u` (defeq; `conv`+`change` see
    -- through the `ModuleCat`/`restrictScalars` instance projections that block `rw`).
    conv_rhs => arg 2; change (ModuleCat.Hom.hom (dualUnitRingSwap f (unop W).left)) ((ModuleCat.Hom.hom (x.app (op (Over.mk ((Hom.opensFunctor f).map (unop W).hom))))) z)
    -- Step 2. `d.hom` is `𝒪_Y(W')`-linear: `d.hom (s • u) = d.hom (c •[restr] u) = c • d.hom u`,
    -- reducing to the scalar identity `s • u = c •[restr] u` (term-mode to tolerate the
    -- defeq-not-syntactic ring carrier of the codomain scalar `c`).
    refine (congrArg (ModuleCat.Hom.hom (dualUnitRingSwap f (unop W).left))
      (?_ : _ = _)).trans ((dualUnitRingSwap f (unop W).left).hom.map_smul _ _)
    -- Step 3. The scalar identity `s • u = c •[restr] u` reduces (`congr 1`) to the pure ring
    -- identity `(termRingMap A) (β.app V m) = (f.appIso W').inv ((termRingMap W) m)` — the
    -- naturality of `f.appIso.inv` against restriction along `f.opensFunctor`.
    congr 1
    simp only [termRingMap, Functor.comp_map, Functor.op_map, Quiver.Hom.unop_op,
      Over.forget_map, Over.mkIdTerminal_from_left, RingHom.id_apply]
    exact (ConcreteCategory.congr_hom
      (Scheme.Hom.appIso_inv_naturality f (((unop W).hom).op)) m).symm
  -- (4) invFun: the reverse reindexing.  A full `PresheafOfModules.Hom` build over the X-slice
  --     `Over fV`.  SHARPENED RECIPE (iter-265; the leg-B infrastructure is now BUILT, see the new
  --     helpers `dualUnitRingSwapHom`/`isIso_ε_restrictScalars_appIso_hom`/`dualUnitRingSwapInv`):
  --     given `ψ : restr V ((pushforward β).obj M.val) ⟶ restr V 𝟙_Y` over `Over V.unop`, produce
  --     `{ app := fun W'' => …, naturality := … }` over `(Over fV)ᵒᵖ` (W''.left ≤ fV).  Set
  --     `P := f⁻¹ᵁ W''.left` (so `P ≤ V.unop` since `f⁻¹ᵁ fV = V.unop`, and
  --     `f.opensFunctor.obj P = W''.left` by `image_preimage_of_le (..) W''.hom.le`).  The component
  --     at `W''` is the X-slice mirror of `toFun`:
  --       eqToHom (M.val.map: M.val(op W''.left) ≅ M.val(op fP), from image_preimage_of_le) ≫
  --       (ModuleCat.restrictScalars (f.appIso P).hom.hom).map (ψ.app (op (Over.mk (homOfLE hPV)))) ≫
  --       dualUnitRingSwapHom f P                                         -- codomain swap = `inv ε`,
  --                                                                       -- the `.hom`-direction
  --     all conjugated by the `eqToHom`s from `image_preimage_of_le` (mirror of `homLocalSection`).
  --     NOTE (direction fix, supersedes the prior "ε itself not inv ε" gloss): the codomain swap is
  --     `dualUnitRingSwapHom = inv (ε (restrictScalars (f.appIso P).hom.hom))` — i.e. `inv ε` of the
  --     `.hom`-direction functor, because the reindex now uses `restrictScalars (f.appIso P).hom.hom`
  --     (the `.hom`, not `.inv`, since we transport a `𝒪_Y(P)`-section map back to a `𝒪_X(fP)`-map).
  --     `map_add'`/`map_smul'` of this reverse map mirror the closed forward proofs (refine_2/3
  --     templates); naturality is the thin-poset `Subsingleton.elim` + ε-naturality square.
  --     STATUS (iter-271): the reverse map is now the EXTRACTED top-level def
  --     `sliceDualTransportInv f M V β` (the binder-metavar unstick lever); its `app`/`naturality`
  --     remain the documented residuals there.  `invFun` is wired to it below.
  · refine fun ψ => sliceDualTransportInv f M V β ?_ ψ
    -- Discharge the β-compatibility hypothesis for the specific `β = whiskerRight (f.appIso).inv`:
    -- `(β.app (op P)).hom = (f.appIso P).inv.hom`, so the composite with `(f.appIso P).hom` is the
    -- identity by `Iso.hom_inv_id` of the structure ring iso.
    intro P
    rw [hβ]
    have h := congrArg CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom_inv_id
    simpa only [Functor.whiskerRight_app, CommRingCat.forgetToRingCat_map_hom,
      CommRingCat.hom_comp, CommRingCat.hom_id] using h
  -- (5) left_inv: `invFun (toFun φ) = φ`, collapses via `Iso.inv_hom_id` of `f.appIso`
  --     (`dualUnitRingSwap`/`ε` round-trip) + the down-set bijection.  Blocked on (4).
  · sorry -- REPAIR: sorry inserted at broken proof site; fill via analogies/dualnat006.md
  -- (6) right_inv: `toFun (invFun ψ) = ψ`, the `Iso.hom_inv_id` mirror of (5).  Blocked on (4).
  · sorry -- REPAIR: sorry inserted at broken proof site; fill via analogies/dualnat006.md

end Modules

end Scheme

end AlgebraicGeometry
