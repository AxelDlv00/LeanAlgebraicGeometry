/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate
import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom

/-!
# Dual-inverse parallel lane (A.1.c.SubT §Dual, iter-251)

This file holds the **dual-inverse chain** that feeds `exists_tensorObj_inverse` in
`TensorObjSubstrate.lean`:

1. `dual_restrict_iso` — restriction along an open immersion commutes with the sheaf-level
   dual (blueprint `lem:dual_restrict_iso`; the C-bridge).  **PARTIAL** (held iter-258): Steps 1–3
   (`restrictFunctorIsoPullback`/`sheafificationCompPullback`/strip) + H1
   (`pushforwardPushforwardAdj`∘`leftAdjointUniq`) are in place; one `sorry` remains at the
   identified Step-4 presheaf residual
   `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`,
   assembled sectionwise from `sliceDualTransport` (see piece 1b below) plus a thin-poset
   naturality square.

   1b. `sliceDualTransport` — the per-`V` `𝒪_Y(V)`-linear iso of the Step-4 residual.  **PARTIAL**
   (iter-262): the obligation is a `𝒪_Y(V)`-linear equivalence between the two morphism (`Hom`)
   types `(restr fV' M.val ⟶ restr fV' 𝟙_X)` (restricted along `β.app V`) and
   `(restr V ((pushforward β).obj M.val) ⟶ restr V 𝟙_Y)`, where `fV' = f.opensFunctor.obj V`.
   ROUTE-1 (consume the shared root `Scheme.Modules.overEquivalence`/`restrictOverIso`/`unitOverIso`)
   is **STRUCTURALLY DEAD** (iter-260): those are `restrict↦over` / `unit↦unit` SHEAF isos — they say
   nothing about `dual`; producing the dual-commutation they lack needs the avoided
   `MonoidalClosed (PresheafOfModules)`.  The genuine close is the direct sectionwise build
   (ROUTE-2, sanctioned iter-261): leg-A reindexes `φ` across `f.opensFunctor` (categorical
   `restrictScalars … |>.map`), leg-B swaps the codomain unit ring via `dualUnitRingSwap`
   (= `inv (ε (restrictScalars (f.appIso W').inv.hom))`).  **Leg-B is CLOSED (iter-262)** as the named
   `dualUnitRingSwap` + `isIso_ε_restrictScalars_appIso` (recipe `analogies/ma-legb262.md`); the
   `codomainMap` hole is filled by defeq.  `map_add'` is CLOSED (iter-263) and `map_smul'` is CLOSED
   (iter-264, axiom-clean: β-naturality ring identity `s = (β.app W').hom c` via
   `Scheme.Hom.appIso_inv_naturality` + `𝒪_Y(W')`-linearity of `dualUnitRingSwap.hom` via `map_smul`).
   REMAINING (typed sorries, 4 of the `≃ₗ`-packaging fields): `naturality`, the reverse `invFun`, and
   its `left_inv`/`right_inv` round-trips.
2. `dual_isLocallyTrivial` — the dual of a locally-trivial module is locally trivial
   (blueprint `lem:dual_isLocallyTrivial`).  **TRANSITIVELY PARTIAL** (depends on
   `dual_restrict_iso` Step-4 `isoMk` naturality sorry at ~L546): the three-step chart-chase
   `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` is assembled and compiles, but it
   inherits the `dual_restrict_iso` residual axiomatically.  The third leg `dual_unit_iso`
   and its presheaf core `presheafDualUnitIso` (= the §0 `dualUnitIsoGen`, the eval-at-`1`
   `dual 𝟙_ ≅ 𝟙_`) are built axiom-clean.
3. `homOfLocalCompat` — a compatible family of local `𝒪_X`-module morphisms over an open
   cover glues to a unique global morphism (blueprint `lem:sheafofmodules_hom_of_local_compat`;
   the A-bridge).  **CLOSED** (iter-256), axiom-clean; the multi-piece sheaf-of-homs gluing
   engine.  The final sub-step (c) sectionwise `𝒪_X`-linearity is closed by the native↔
   `restrictScalars 𝟙` smul bridge `hbridge` (from `Scheme.Opens.ι_appIso` +
   `ModuleCat.restrictScalars.smul_def'`), feeding the native f-leg linearity `hfl_native`.

The prover lane for this file works **in parallel** with the D1′/D3′/D4′ lane in
`TensorObjSubstrate.lean`.

Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.
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
    -- RESIDUAL (the genuine ~100-LOC instance-delicate build, recipe verified iter-271):
    -- The component is the X-slice mirror of the forward `toFun`, but the preimage round-trip
    -- `f''ᵁ(f⁻¹ᵁ W') = W'` (`he`) is only *propositional*, so unlike the forward map it needs
    -- `eqToHom` conjugation AND a change-of-rings reconciliation.  Build it as:
    --   (1) `M.val.map (eqToHom (op he.symm))` : the source relabel `M.val(W') ⟶ M.val(f''ᵁ P)`;
    --   (2) bridge `M.val(f''ᵁ P)` (native `X.presheaf(f''ᵁ P)`-module) to the source of the
    --       ψ-reindex `(restrictScalars (f.appIso P).hom.hom).obj ((pushforward β M.val)(op P))`
    --       — these have equal CARRIER but a-priori different module structures, reconciled by
    --       `restrictScalarsComp'App` + `restrictScalarsId'App` using the RING identity
    --       `(β.app (op P)) ≫ (f.appIso P).hom = 𝟙` (the `.inv ≫ .hom` of `f.appIso P`), so the
    --       two `restrictScalars` collapse to `restrictScalars 𝟙 ≃ id`;
    --   (3) `(restrictScalars (f.appIso P).hom.hom).map (ψ.app (op (Over.mk (homOfLE hPV))))`;
    --   (4) `dualUnitRingSwapHom f (f⁻¹ᵁ W')` : codomain swap to `𝟙_X(f''ᵁ P)`;
    --   (5) `eqToHom`/relabel back to `(restr fV 𝟙_X).obj W'' = 𝟙_X(W')` via `he`.
    -- BLOCKER (precise): step (2)'s `restrictScalarsComp'App`/`restrictScalarsId'App` instances
    -- and the (1)/(5) `eqToHom` transports must be threaded through the semilinear
    -- `PresheafOfModules.map` codomain (which is itself `restrictScalars`-wrapped), and the `𝟙_`
    -- vs `restr`-section ModuleCat-object defeq must be bridged at each leg.  All ingredients are
    -- named; the assembly is the next fine-grained pass.
    -- STRUCTURED SKELETON (iter-303): legs (3) ψ-reindex + (4) codomain unit swap are now
    -- CONCRETE; the two surviving holes are the precise module-instance reconciliations:
    --   ?src : (restr fV M.val).obj W''  ⟶  restrictScalars (f.appIso P).hom (𝒪_X(fP)-section of M)
    --     — the source relabel `M.val(W') ⟶ M.val(fP)` (eqToHom along `he`, semilinear codomain)
    --       composed with the double-restrict collapse `restrictScalars (f.appIso P).hom ∘
    --       restrictScalars (β.app P) ≅ restrictScalars 𝟙 ≅ id` (ring identity
    --       `(β.app P).hom ∘ (f.appIso P).hom.hom = 𝟙_{𝒪_X(fP)}` via `appIso_inv_naturality`,
    --       collapsed by `ModuleCat.restrictScalarsComp'App`/`restrictScalarsId'App`).  The genuine
    --       wall: leg-1's `M.val.map (eqToHom …)` codomain is restricted along
    --       `X.ringCatSheaf.map (eqToHom (op he.symm)) : 𝒪_X(W') → 𝒪_X(fP)`, a DIFFERENT base ring
    --       than leg-2's `𝒪_X(fP)` outer ring; bridging needs the ε-conjugation along that ring
    --       relabel (per memory ts271-slicedualtransportinv).
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
    -- **Sole remaining hole (iter-303 sharpened):** the goal lives in `ModuleCat 𝒪_X(W')` but
    -- `core` lives in `ModuleCat 𝒪_X(fP)` (`fP = f''ᵁf⁻¹ᵁW'`, propositionally `= W'` via `he`, but
    -- the section RINGS `𝒪_X(W')` / `𝒪_X(fP)` are only propositionally equal).  The source relabel
    -- `M.val(W') ⟶ M.val(fP)` is `M.val.map (eqToHom (op he.symm))` — SEMILINEAR, landing in
    -- `restrictScalars (X.presheaf.map (eqToHom …))`; combined with the source double-restrict
    -- collapse `restrictScalars (f.appIso P).hom ∘ restrictScalars (β.app P) ≅ restrictScalars 𝟙
    -- ≅ id` (ring identity `(β.app P).hom ∘ (f.appIso P).hom.hom = 𝟙_{𝒪_X(fP)}` via
    -- `Scheme.Hom.appIso_inv_naturality`, collapsed by `ModuleCat.restrictScalarsComp'App` +
    -- `restrictScalarsId'App`).  A single `≫`-chain in one `ModuleCat` cannot express this — the
    -- relabel crosses ring fibers — so `core` must be conjugated across the `𝒪_X(fP) ↔ 𝒪_X(W')`
    -- fiber by `restrictScalars`-transport along `X.presheaf.map (eqToHom (op he))` (per memory
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
    exact sorry

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
  · sorry
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
  · sorry
  -- (6) right_inv: `toFun (invFun ψ) = ψ`, the `Iso.hom_inv_id` mirror of (5).  Blocked on (4).
  · sorry

/-- **Restriction along an open immersion commutes with the sheaf-level dual (C-bridge).**

Blueprint `lem:dual_restrict_iso` (§`sec:tensorobj_dual_bridge`).  For an open immersion
`f : Y ⟶ X` and `M : X.Modules`, there is a canonical isomorphism of `𝒪_Y`-modules
```
  (dual M).restrict f  ≅  dual (M.restrict f)
```
natural in `M`, between the restriction of the sheaf-level dual and the dual of the
restriction.

/- Planner strategy:
   Blueprint label: lem:dual_restrict_iso (~L5374).

   Proof-sketch (blueprint §5.4):
   The proof runs at the PRESHEAF-OF-MODULES level (Step 3 of the tensorObj_restrict_iso
   H1∘H2 recipe already strips the outer sheafification).  Three ingredients:

   (a) Per-V slice equivalence: for each V ≤ U (= image of f), the opens functor
       `f.opensFunctor` is fully faithful with image = {W ≤ U}, so
       `Over_Y V ≃ Over_X (f.opensFunctor V)`.  This is the per-open shadow of
       `TopologicalSpace.Opens.overEquivalence` (CLOSED in Vestigial.lean via
       `overSliceSheafEquiv`).

   (b) Agreement of codomain: the structure sheaf of Y agrees with that of X under (a).

   (c) Ring-iso transport of module structure:
       `lem:restrictscalars_ringiso_dualequiv` (CLOSED in PresheafInternalHom.lean as
       `restrictScalarsRingIsoDualEquiv`):
         `RingEquiv e → Dual(restrictScalars e.toRingHom A) ≃ restrictScalars e.toRingHom (Dual A)`
       applies sectionwise at each V to transport the `𝒪_X(fV)`-module structure on
       `(dual M)|_f(V)` to the `𝒪_Y(V)`-module structure via the ring iso
       `β_V = (f.appIso V).inv : 𝒪_X(fV) ≅ 𝒪_Y(V)`.

   High-level recipe (mirrors tensorObj_restrict_iso Steps 1–4 with `dual` in place of `⊗`):
   Step 1: `(Scheme.Modules.restrictFunctorIsoPullback f).app (dual M)` — reduce `restrict`
           to abstract pullback.
   Step 2: `SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom` — move pullback
           inside sheafification.
   Step 3: strip the outer sheafification via `(sheafification …).mapIso`.
   Step 4 (the genuine new build):  close the residual presheaf goal
             `pushforward β (PresheafOfModules.dual M.val)
                 ≅ PresheafOfModules.dual ((pushforward β).obj M.val)`
           The ROUTE: sectionwise, at each V ≤ U, the value of the LHS is
           `Hom_{Over_X(fV)}(restr(fV) M.val, restr(fV) 𝟙_X)` and the value of the RHS is
           `Hom_{Over_Y V}(restr V (pushforward β M.val), restr V 𝟙_Y)`.
           The slice equivalence (a) identifies these indexing categories; the agreement (b)
           identifies the codomain `𝟙`; the ring-iso transport (c) via
           `restrictScalarsRingIsoDualEquiv` reconciles the module structures.
           Naturality in V is automatic on the thin poset `Opens X` by `Subsingleton.elim`.

   STATUS NOTE (iter-260; the shared root IS now green — `SheafOverEquivalence.lean` is sorry-free;
   supersedes the stale "route (1) gated" claim):
   The Step-4 residual reduces (via `sliceDualTransport`) to the per-`V` `𝒪_Y(V)`-linear
   equivalence (reduction now executed IN CODE in `sliceDualTransport` via
   `refine LinearEquiv.toModuleIso ?_`; the `Module 𝒪_Y(V)` instances synthesize automatically):
     `((pushforward₀ f.opensFunctor X.ringCatSheaf.obj).obj (dual M.val)).obj V`
       ≃ₗ[𝒪_Y(V)]
     `(internalHomPresheaf ((pushforward β).obj M.val) 𝟙_Y).obj V`
   i.e. `(restr fV' M.val ⟶ restr fV' 𝟙_X) ≃ₗ[𝒪_Y(V)]`
        `(restr V (pushforward β M.val) ⟶ restr V 𝟙_Y)`,
   with `fV' = f.opensFunctor.obj V.unop`.

   ROUTE-(1) IS STRUCTURALLY INSUFFICIENT (iter-260 finding — the EXACT failing step):
     The shared root `Scheme.Modules.overEquivalence` and its consumer isos
     `restrictOverIso`/`unitOverIso` (`Picard/SheafOverEquivalence.lean`) are now GREEN, but they
     are object-isos of `restrict ↦ over` and `unit ↦ unit` at the SHEAF level — they say NOTHING
     about `dual`/internal-hom.  The reduced `≃ₗ` is precisely the statement that the dual
     (`internalHomPresheaf · 𝟙_`) COMMUTES with the slice reindexing along `f.opensFunctor`.  No
     shared-root decl (grepped) provides a `dual`-commutation; obtaining one from `overEquivalence`
     would require its functor (`SheafOfModules.pushforward`) to be strong monoidal CLOSED — the
     `MonoidalClosed (PresheafOfModules R₀)` wall the project deliberately avoids
     (TensorObjSubstrate §2 `rem:scheme_modules_monoidal_off_path`).  Hence route (1) cannot close
     `sliceDualTransport`; this is structural, not tactic difficulty.  See the in-body comment of
     `sliceDualTransport` for the full diagnosis.

   GENUINE CLOSE = ROUTE (2) (the direct sectionwise build; ~150–250 LOC, instance-delicate):
     build `sliceDualTransport`'s forward map à la `homLocalSection` (`eqToHom`-conjugation
     across `f.opensFunctor` along `image_preimage_of_le`, naturality `Subsingleton.elim`, leg A)
     ∘ `restrictScalarsRingIsoDualEquiv` (the codomain-unit ring swap via `(f.appIso V).inv`,
     leg B).  Leg B does NOT type-apply standalone (fixed-carrier `N →ₗ[S] S`; here the two sides
     have different over-category INDEXING, so leg A runs first).  Per the iter-260 armed reversing
     signal this build is NOT undertaken unilaterally; it awaits planner sanction (or, instead,
     a new shared-root "overEquivalence preserves internal hom" lemma, which itself needs the
     avoided monoidal-closed structure and is therefore the harder of the two).

   Named CLOSED base lemmas this stub consumes:
   - `PresheafOfModules.dual` (PresheafInternalHom.lean) — presheaf-level dual.
   - `Scheme.Modules.dual` (TensorObjSubstrate.lean ~L207) — sheaf-level dual.
   - `InternalHom.restrictScalarsRingIsoDualEquiv` (PresheafInternalHom.lean ~L234) — the
     ring-iso / dual commutation at the `ModuleCat` level.
   - `Scheme.Modules.restrictFunctorIsoPullback` (Mathlib) — Step 1 iso.
   - `SheafOfModules.sheafificationCompPullback` (Mathlib) — Step 2 iso.
   - `PresheafOfModules.pushforwardPushforwardAdj` (PresheafInternalHom.lean) — H1.
   - `PresheafOfModules.restrictScalarsMonoidalOfBijective` (PresheafInternalHom.lean) — H2
     (not directly needed for `dual`, but the same `β`-bijectivity is used).
-/
-/
noncomputable def dual_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    (dual M).restrict f ≅ dual (M.restrict f) := by
  -- Step 1. Reduce `restrict` to `pullback` along the open immersion `f`.
  refine (Scheme.Modules.restrictFunctorIsoPullback f).app (dual M) ≪≫ ?_
  -- Step 2. Sheafification commutes with pullback.
  refine (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).app
      (PresheafOfModules.dual (R₀ := X.presheaf) M.val) ≪≫ ?_
  -- Step 3. Strip the outer sheafification, descending to the presheaf residual.
  refine (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
      (𝟙 Y.ringCatSheaf.obj)).mapIso ?_
  -- Step 4 (RESIDUAL): the presheaf goal
  --   `(pullback φ).obj (dual M.val) ≅ dual ((M.restrict f).val)`.
  -- H1: replace `pullback φ` with `pushforward β` (β the open-immersion structure ring iso).
  let φR := (Scheme.Hom.toRingCatSheafHom f).hom
  let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
    { app := fun U => (f.appIso U.unop).inv }
  let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight α (forget₂ CommRingCat RingCat)
  have hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φR :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φR
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let H1 := hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)
  refine (H1.app (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).symm ≪≫ ?_
  -- Residual: `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`.
  -- Assemble sectionwise from `sliceDualTransport`.  The `isoMk` naturality square is the
  -- thin-poset `Opens Y` coherence of the `sliceDualTransport` family; it becomes routine once
  -- `sliceDualTransport`'s body is concrete (its `.hom` is currently a `sorry`, so the square
  -- cannot be discharged yet — it is left as the assembly residual, per the planner bar).
  refine PresheafOfModules.isoMk (fun V => sliceDualTransport f M V) ?_
  intro V W g
  sorry

/-! ## §B. Local triviality of the dual -/

/-- **Presheaf-level: the dual of the monoidal unit is the unit.**
`PresheafOfModules.dual 𝟙_ = ℋom(𝟙_, 𝟙_) ≅ 𝟙_`, the evaluation-at-`1` isomorphism.
Local supplement (the `PresheafOfModules`-level ingredient of `dual_unit_iso`). -/
noncomputable def presheafDualUnitIso {Y : Scheme.{u}} :
    PresheafOfModules.dual (R₀ := Y.presheaf)
        (𝟙_ (_root_.PresheafOfModules.{u} (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
      ≅ 𝟙_ (_root_.PresheafOfModules.{u} (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) :=
  PresheafOfModules.dualUnitIsoGen (R₀ := Y.presheaf)

/-- **The dual of the structure sheaf is the structure sheaf.** `dual 𝒪_Y ≅ 𝒪_Y`.
The presheaf-level dual of the monoidal unit `𝟙_` is the unit (evaluation at `1`),
sheafified and identified with the (already-sheaf) unit by the sheafification counit.
Mirrors `tensorObj_unit_iso` with the presheaf left unitor replaced by
`presheafDualUnitIso`. The third leg of the `dual_isLocallyTrivial` chain. -/
noncomputable def dual_unit_iso {Y : Scheme.{u}} :
    dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf :=
  (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).mapIso
      (presheafDualUnitIso (Y := Y)) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 Y.ringCatSheaf.val)).counit).app
      (SheafOfModules.unit Y.ringCatSheaf)

/-- **The dual of a locally-trivial `𝒪_X`-module is locally trivial.**

Blueprint `lem:dual_isLocallyTrivial` (~L5472).  If `L : X.Modules` satisfies
`LineBundle.IsLocallyTrivial L`, then `dual L` is also locally trivial.

/- Planner strategy:
   Blueprint label: lem:dual_isLocallyTrivial (~L5472).
   Uses (dual_restrict_iso is PARTIAL — Step-4 `isoMk` naturality sorry at ~L546; all other deps CLOSED):
     lem:internal_hom_isSheaf  → `Scheme.Modules.dual` (TensorObjSubstrate.lean ~L207)
     lem:dual_restrict_iso     → `dual_restrict_iso` (this file, §A above — PARTIAL, Step-4 sorry)
     def:scheme_modules_dual_iso_of_iso → `Scheme.Modules.dualIsoOfIso`
                                          (TensorObjSubstrate.lean ~L218)
     lem:restrictscalars_ringiso_dualequiv → `restrictScalarsRingIsoDualEquiv`
                                             (PresheafInternalHom.lean ~L234)

   Proof-sketch (blueprint §5.4, three-step chain):
   Unpack `hL : LineBundle.IsLocallyTrivial L`:  for each `x : X` choose an affine open
   `U` with `x ∈ U`, `IsAffineOpen U`, and `eL : L.restrict U.ι ≅ SheafOfModules.unit _`.
   It suffices to exhibit `(dual L).restrict U.ι ≅ SheafOfModules.unit _`.
   The three-step chain (blueprint §5.4):

   Step 1 — `dual_restrict_iso U.ι L`:
     `(dual L).restrict U.ι  ≅  dual (L.restrict U.ι)`

   Step 2 — `dualIsoOfIso eL` (contravariant):
     `dual (L.restrict U.ι)  ≅  dual (SheafOfModules.unit (U : Scheme).ringCatSheaf)`

   Step 3 — `dual_unit_iso` (the dual of the unit is the unit):
     `dual (SheafOfModules.unit _)  ≅  SheafOfModules.unit _`
     The dual of `𝒪_U` is `ℋom(𝒪_U, 𝒪_U) ≅ 𝒪_U` via evaluation-at-1; this should be
     derivable from `InternalHom.internalHomEval` (PresheafInternalHom.lean) + the
     presheaf-level left unitor `λ_ (𝟙_)`.

   Composing Steps 1–3 gives the trivialisation of `(dual L)|_U`.
   Since x was arbitrary, `dual L` is locally trivial.

   Implementation note: the pattern is identical to `tensorObj_isLocallyTrivial`
   (TensorObjSubstrate.lean ~L526), with `dual_restrict_iso` playing the role of
   `tensorObj_restrict_iso` and `dualIsoOfIso` the role of `tensorObjIsoOfIso`.
   Use `intro x; obtain ⟨U, hxU, hU_aff, ⟨eL⟩⟩ := hL x` to unpack, then
   `exact ⟨U, hxU, hU_aff, ⟨dual_restrict_iso U.ι L ≪≫ dualIsoOfIso eL ≪≫ dual_unit_iso⟩⟩`.
   `dual_unit_iso` is CLOSED axiom-clean (§B above); the chain is assembled and compiles,
   inheriting only the `dual_restrict_iso` Step-4 residual axiomatically.

   Named CLOSED base lemmas:
   - `Scheme.Modules.dualIsoOfIso` (TensorObjSubstrate.lean ~L218).
   - `dual_restrict_iso` (this file §A — must be proved first).
   - `SheafOfModules.unit` (Mathlib).
   - `InternalHom.internalHomEval` (PresheafInternalHom.lean) — for `dual_unit_iso`.
-/
-/
lemma dual_isLocallyTrivial {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    LineBundle.IsLocallyTrivial (dual L) := by
  -- Mirrors `tensorObj_isLocallyTrivial`: trivialise the dual on each affine open `U`
  -- where `L` is trivial, via the three-step chain
  --   `(dual L)|_U ≅ dual (L|_U) ≅ dual 𝒪_U ≅ 𝒪_U`.
  intro x
  obtain ⟨U, hxU, hU_aff, ⟨eL⟩⟩ := hL x
  refine ⟨U, hxU, hU_aff, ⟨?_⟩⟩
  exact dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso

/-! ## §C. The A-bridge: compatible local morphisms glue to a global morphism -/

open Opposite TopologicalSpace in
/-- **The local section of the hom-sheaf manufactured from `f i`** (the load-bearing piece
of `homOfLocalCompat`, blueprint `localSection`).  Working with the underlying `Ab`-presheaves
`F = M.val.presheaf`, `G = N.val.presheaf`, the presheaf of types
`presheafHom F G` (`Mathlib.CategoryTheory.Sites.SheafHom`) sends an open `W` to the morphisms of
the restrictions of `F`, `G` to the slice `Over W`.  Its value at `U i` is built from the
components of `f i`, conjugated by `eqToHom` along the down-set identity
`(U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ V) = V` (valid for `V ≤ U i`).  The naturality field — the genuine
coherence risk — is automatic on the thin poset `Opens X` once the `eqToHom`-conjugation is
peeled, via `Subsingleton.elim` on the hom-sets. -/
noncomputable def homLocalSection {X : Scheme.{u}} {M N : X.Modules} {ι : Type*}
    (U : ι → X.Opens) (f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι) (i : ι) :
    (CategoryTheory.presheafHom M.val.presheaf N.val.presheaf).obj (op (U i)) where
  app W :=
    haveI hle : W.unop.left ≤ U i := W.unop.hom.le
    haveI himg : (U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ W.unop.left) = W.unop.left := by
      simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
      exact inf_eq_right.mpr hle
    M.val.presheaf.map (eqToHom (congrArg op himg.symm)) ≫
      ((PresheafOfModules.toPresheaf _).map (f i).val).app (op ((U i).ι ⁻¹ᵁ W.unop.left)) ≫
      N.val.presheaf.map (eqToHom (congrArg op himg))
  naturality := by
    intro A B φ
    have hBA : (unop B).left ≤ (unop A).left := ((Over.forget (U i)).map φ.unop).le
    let κ : (U i).ι ⁻¹ᵁ (unop B).left ⟶ (U i).ι ⁻¹ᵁ (unop A).left :=
      (Opens.map (U i).ι.base).map (homOfLE hBA)
    have himgA : (U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ (unop A).left) = (unop A).left := by
      simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
      exact inf_eq_right.mpr (unop A).hom.le
    have himgB : (U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ (unop B).left) = (unop B).left := by
      simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
      exact inf_eq_right.mpr (unop B).hom.le
    -- naturality of the underlying ab-presheaf morphism of `f i`
    have hm := ((PresheafOfModules.toPresheaf _).map (f i).val).naturality κ.op
    -- the two thin-poset square edges agree (`Opens X` is a thin poset)
    have hsubM : ((Over.forget (U i)).map φ.unop).op ≫ eqToHom (congrArg op himgB.symm)
        = eqToHom (congrArg op himgA.symm) ≫ ((U i).ι.opensFunctor.map κ).op :=
      Subsingleton.elim _ _
    have hsubN : ((U i).ι.opensFunctor.map κ).op ≫ eqToHom (congrArg op himgB)
        = eqToHom (congrArg op himgA) ≫ ((Over.forget (U i)).map φ.unop).op :=
      Subsingleton.elim _ _
    -- M-side: the φ-restriction followed by the `eqToHom` is the `eqToHom` followed by `κ`
    have hML : M.val.presheaf.map ((Over.forget (U i)).map φ.unop).op ≫
          M.val.presheaf.map (eqToHom (congrArg op himgB.symm))
        = M.val.presheaf.map (eqToHom (congrArg op himgA.symm)) ≫
          (M.restrict (U i).ι).val.presheaf.map κ.op := by
      rw [(M.val.presheaf.map_comp _ _).symm, hsubM]
      exact M.val.presheaf.map_comp _ _
    -- N-side analogue
    have hNR : N.val.presheaf.map ((U i).ι.opensFunctor.map κ).op ≫
          N.val.presheaf.map (eqToHom (congrArg op himgB))
        = N.val.presheaf.map (eqToHom (congrArg op himgA)) ≫
          N.val.presheaf.map ((Over.forget (U i)).map φ.unop).op := by
      rw [(N.val.presheaf.map_comp _ _).symm, hsubN]
      exact N.val.presheaf.map_comp _ _
    dsimp only [Functor.comp_map, Functor.op_map, Functor.op_obj, Functor.comp_obj]
    rw [← Category.assoc, hML]
    erw [Category.assoc, reassoc_of% hm, hNR]
    simp only [Category.assoc]
    rfl

open Opposite TopologicalSpace in
/-- **Convert a section of `presheafHom F G` over the terminal open `⊤` into a global
morphism `F ⟶ G`.**  Since `⊤` is terminal in `Opens X`, the value of `presheafHom F G`
at `op ⊤` already determines a full compatible family of sections (each open's value is the
restriction of the top section), which `presheafHomSectionsEquiv` identifies with a morphism
`F ⟶ G`.  This is sub-step (b) of `homOfLocalCompat`. -/
noncomputable def topSectionToHom {X : TopCat.{u}}
    {F G : (TopologicalSpace.Opens X)ᵒᵖ ⥤ Ab.{u}}
    (s : (CategoryTheory.presheafHom F G).obj (op ⊤)) : F ⟶ G :=
  CategoryTheory.presheafHomSectionsEquiv F G
    ⟨fun W => (CategoryTheory.presheafHom F G).map (homOfLE le_top).op s, by
      intro W W' e
      dsimp only
      rw [← Functor.map_comp_apply]
      congr 1⟩

open Opposite TopologicalSpace in
/-- **Sectionwise value of `topSectionToHom`.**  At an open `W`, the recovered morphism
evaluates to the `Over.mk (homOfLE le_top)`-component of the top section `s`. -/
lemma topSectionToHom_app {X : TopCat.{u}}
    {F G : (TopologicalSpace.Opens X)ᵒᵖ ⥤ Ab.{u}}
    (s : (CategoryTheory.presheafHom F G).obj (op ⊤)) (W : (TopologicalSpace.Opens X)ᵒᵖ) :
    (topSectionToHom s).app W = s.app (op (Over.mk (homOfLE (le_top) : W.unop ⟶ ⊤))) := by
  obtain ⟨W⟩ := W
  exact CategoryTheory.presheafHom_map_app_op_mk_id (homOfLE le_top) s

open Opposite TopologicalSpace in
/-- **Down-set image identity.**  For `V ≤ W` (opens of a scheme `X`), the image under the
open immersion `W.ι` of the preimage of `V` is `V` again: `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V`.  This is
the equality powering the `eqToHom`-conjugations in `homLocalSection`. -/
lemma image_preimage_of_le {X : Scheme.{u}} (W : X.Opens) {V : X.Opens} (hV : V ≤ W) :
    W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V := by
  simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
  exact inf_eq_right.mpr hV

set_option backward.isDefEq.respectTransparency false in
open Opposite TopologicalSpace in
/-- **A-bridge: compatible local `𝒪_X`-module morphisms glue to a global morphism.**

Blueprint `lem:sheafofmodules_hom_of_local_compat` (~L5592).  Let `X` be a scheme,
`M N : X.Modules`, and `{U i}` an indexed open cover of `X`.  If for each `i` we have a
morphism `f i : M.restrict (U i).ι ⟶ N.restrict (U i).ι` in `Scheme.Modules (U i)` such
that the underlying section maps of `f i` and `f j` agree, *sectionwise*, on every open
`V ≤ U i ⊓ U j` (each conjugated into the fixed abelian-group hom-type `M(V) ⟶ N(V)` by the
canonical `eqToHom`s from the down-set identity `ι(ι⁻¹V) = V`), then there is a unique global
morphism `M ⟶ N` in `X.Modules` whose restriction to each `U i` is `f i`.

The compatibility hypothesis `hf` is the **sectionwise** overlap-agreement (iter-254 re-sign;
this `def` is NOT in `archon-protected.yaml` and has no compiling caller, so the prover owns its
signature).  The earlier `HEq` form — comparing the two `Scheme.Modules.pullback`-images of
`f i`, `f j` along the two slice-restrictions — was *unsatisfiable*: those images live in
sheafifications of pullback presheaves along *different* morphisms, hence in only-isomorphic
(not propositionally equal) objects, so no `HEq`-elimination applies and no caller can produce
the datum.  The sectionwise form compares only the section maps, which live in the fixed group
`M(V) ⟶ N(V)`, and is exactly the data a caller (two local morphisms literally agreeing on
overlaps) has at hand.  See blueprint `lem:sheafofmodules_hom_of_local_compat` sub-step (a).

/- Planner strategy:
   Blueprint label: lem:sheafofmodules_hom_of_local_compat (~L5592).
   Uses (all CLOSED):
     def:scheme_modules_homMk → `Scheme.Modules.homMk` (TensorObjSubstrate.lean ~L598)
     lem:open_immersion_slice_sheaf_equiv → `Vestigial.overSliceSheafEquiv`
                                            (TensorObjSubstrate/Vestigial.lean ~L715)

   Proof-sketch (blueprint §5.4, two-step):

   Step (i) — Glue the underlying ab-sheaf morphism:
   Forget M, N to their underlying sheaves of abelian groups.  The presheaf
   `H(W) = Hom_{Ab-preshvs}(M.val.presheaf|_W, N.val.presheaf|_W)` is a sheaf of TYPES:
   this is `Presheaf.IsSheaf.hom` (Mathlib), consuming the sheaf condition of N.
   Convert each `f i` to a local section `s i ∈ H(U i)` via the open-immersion slice
   transport `overSliceSheafEquiv` (Vestigial.lean):
     - `s i` at a pair `(V, h : V ≤ U i)` is `(f i).val.app` at the corresponding open of
       `(U i : Scheme)`, conjugated by `eqToHom` identifications from the down-set identity
       `ι_i(ι_i⁻¹(V)) = V` for `V ≤ U i`.  The naturality of `s i` in V is the
       section-direction slice of `overSliceSheafEquiv` and is automatic on the thin poset
       `Opens X` by `Subsingleton.elim`.
   Apply `TopCat.Sheaf.existsUnique_gluing` (or `Presheaf.IsSheaf.existsUnique_gluing`) to
   amalgamate the compatible family `(s i)_i` into a unique global section
   `s ∈ H(⊤) = (M.val.presheaf ⟶ N.val.presheaf)`.
   Convert the amalgamated `s` to an ab-presheaf morphism `g : M.val.presheaf ⟶ N.val.presheaf`
   via `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv`.

   Step (ii) — Promote to `𝒪_X`-linear via `homMk`:
   The linearity `g(r • m) = r • g(m)` holds on each `U i` (since `g|_{U i}` comes from
   the module morphism `f i`), and the two sides agree globally because the ambient presheaf
   is separated.  Apply `Scheme.Modules.homMk g (sectionwise-linearity proof)` to produce
   `M ⟶ N` in `X.Modules`.

   Key sub-lemma to build first (most fragile piece):
   The naturality field of `s i` — that the `eqToHom`-conjugated components of `f i` commute
   across morphisms of the slice `Over (U i)` — is dominated by `overSliceSheafEquiv` and
   should be extracted as a standalone axiom-clean lemma before the full gluing assembly.

   Named CLOSED base lemmas:
   - `Scheme.Modules.homMk` (TensorObjSubstrate.lean ~L598).
   - `Vestigial.overSliceSheafEquiv` (TensorObjSubstrate/Vestigial.lean ~L715).
   - `TopCat.Presheaf.IsSheaf.hom` (Mathlib) — hom into a sheaf is a sheaf.
   - `TopCat.Sheaf.existsUnique_gluing` (Mathlib) — gluing of compatible sections.
   - `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv` (Mathlib) — top-section ↔ morphism.

   Implementation note: this is a MULTI-PIECE BUILD dominated by the `s i` naturality field.
   Build `s i` (and its naturality) as a standalone verified lemma FIRST, before assembling
   the full gluing.  The step does NOT invoke any tensor stalk — it is purely about gluing
   morphisms of sheaves.
-/
-/
noncomputable def homOfLocalCompat {X : Scheme.{u}} {M N : X.Modules}
    {ι : Type*} (U : ι → X.Opens) (hU : ∀ x : X, ∃ i, x ∈ U i)
    (f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι)
    (hf : ∀ (i j : ι) (V : X.Opens) (hVi : V ≤ U i) (hVj : V ≤ U j),
        M.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U i) hVi).symm)) ≫
          ((PresheafOfModules.toPresheaf _).map (f i).val).app (op ((U i).ι ⁻¹ᵁ V)) ≫
            N.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U i) hVi)))
          = M.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U j) hVj).symm)) ≫
              ((PresheafOfModules.toPresheaf _).map (f j).val).app (op ((U j).ι ⁻¹ᵁ V)) ≫
                N.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U j) hVj)))) :
    M ⟶ N := by
  -- Step (i): glue the underlying ab-sheaf morphism.  The morphisms-presheaf
  -- `presheafHom M.val.presheaf N.val.presheaf` (`Mathlib.CategoryTheory.Sites.SheafHom`) is a
  -- sheaf of types because `N` is a sheaf (`Presheaf.IsSheaf.hom`, consuming `N.isSheaf`).
  let H : TopCat.Sheaf (Type u) (X : TopCat) :=
    ⟨CategoryTheory.presheafHom M.val.presheaf N.val.presheaf,
      Presheaf.IsSheaf.hom M.val.presheaf N.val.presheaf N.isSheaf⟩
  -- The cover `{U i}` exhausts `X`, so `iSup U = ⊤`.
  have hsup : iSup U = ⊤ := by
    rw [eq_top_iff]
    intro x _
    obtain ⟨i, hi⟩ := hU x
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨i, hi⟩
  -- The compatible family `homLocalSection U f` (its naturality is the load-bearing field,
  -- proved axiom-clean above) glues via `existsUnique_gluing` to a unique global section of `H`
  -- over `iSup U = ⊤`.  `hglue` records the unique-gluing engine fed with these local sections;
  -- it still requires the `IsCompatible` datum, which is exactly the assumed overlap agreement
  -- `hf` (transported through `Vestigial.overSliceSheafEquiv`).
  have hglue := H.existsUnique_gluing U (fun i => homLocalSection U f i)
  -- (a) The cocycle / `IsCompatible` condition: the two restrictions of `homLocalSection i`
  -- and `homLocalSection j` to the overlap `U i ⊓ U j` agree as sections of `H`.
  have hcompat : TopCat.Presheaf.IsCompatible
      (CategoryTheory.presheafHom M.val.presheaf N.val.presheaf) U
      (fun i => homLocalSection U f i) := by
    intro i j
    refine NatTrans.ext (funext fun Z => ?_)
    obtain ⟨W⟩ := Z
    erw [presheafHom_map_app W.hom (TopologicalSpace.Opens.infLELeft (U i) (U j)) _ rfl,
        presheafHom_map_app W.hom (TopologicalSpace.Opens.infLERight (U i) (U j)) _ rfl]
    -- Unfold `homLocalSection` so the goal becomes the explicit sectionwise core equation:
    -- at the overlap open `V := W.left ≤ U i ⊓ U j`,
    --   LHS = `M.map (eqToHom ..) ≫ (f i).val.app (op ((U i).ι ⁻¹ᵁ V)) ≫ N.map (eqToHom ..)`
    --   RHS = `M.map (eqToHom ..) ≫ (f j).val.app (op ((U j).ι ⁻¹ᵁ V)) ≫ N.map (eqToHom ..)`,
    -- both in the FIXED `Ab` hom-type `M.val(V) ⟶ N.val(V)`.  With the sectionwise `hf` this is
    -- exactly `hf i j W.left _ _` (the `eqToHom`-conjugations match by definitional proof
    -- irrelevance; `(Over.mk (W.hom ≫ infLE_))​.left ≡ W.left` defeq).
    simp only [homLocalSection]
    exact hf i j W.left (W.hom.le.trans inf_le_left) (W.hom.le.trans inf_le_right)
  -- (b) Glue and convert the amalgamated `op ⊤`-section to an ab-presheaf morphism `g`.
  -- `∃!` is a `Prop`, so the glued section is extracted as a term via `.choose`; `hsup`
  -- transports it from `op (iSup U)` to the terminal `op ⊤` that `topSectionToHom` consumes.
  refine homMk (topSectionToHom (hsup ▸ (hglue hcompat).choose)) ?_
  -- (c) sectionwise `𝒪_X`-linearity of `g = topSectionToHom (glued section)`.  On each `U i`
  -- the glued section restricts to `homLocalSection U f i` (the `IsGluing` datum `_hs`), whose
  -- components come from the module morphism `f i`, so `g` is `𝒪_X`-linear on opens `≤ U i`;
  -- since `{U i}` covers `X` and `N.val.presheaf` is separated (`section_ext`), linearity
  -- propagates to every section.  CLOSED (iter-256), axiom-clean: the `section_ext` separatedness
  -- reduction, the naturality + `map_smul` reduction to local linearity, the `hconn` connection
  -- lemma identifying `g|_{U i}` with `homLocalSection i`, and the inner ring-bridge (native↔
  -- `restrictScalars 𝟙` smul bridge `hbridge`, from `Scheme.Opens.ι_appIso` +
  -- `ModuleCat.restrictScalars.smul_def'`) feeding the native f-leg linearity `hfl_native` are all
  -- in place below — no `sorry` remains in this declaration.
  have _hs := (hglue hcompat).choose_spec.1
  intro V r m
  -- Abbreviate the glued ab-presheaf morphism `g`.
  set g : M.val.presheaf ⟶ N.val.presheaf :=
    topSectionToHom (hsup ▸ (hglue hcompat).choose) with hg
  -- **Connection lemma.**  On every open `W' ≤ U i`, the glued morphism `g` agrees with the
  -- local section `homLocalSection U f i` manufactured from `f i` — this is the content of the
  -- `IsGluing` datum `_hs`, transported through the `iSup U = ⊤` identification and the
  -- `presheafHom`-restriction calculus.
  have hconn : ∀ (i : ι) (W' : X.Opens) (hWi : W' ≤ U i),
      g.app (op W') = (homLocalSection U f i).app (op (Over.mk (homOfLE hWi))) := by
    intro i W' hWi
    have htr : ∀ {a : X.Opens} (h : a = ⊤) (y : H.obj.obj (op a)),
        (h ▸ y : H.obj.obj (op ⊤)) = H.obj.map (eqToHom (congrArg op h)) y := by
      intro a h y; subst h; simp
    rw [hg, topSectionToHom_app, htr hsup]
    have hop : eqToHom (congrArg op hsup) = (eqToHom hsup.symm).op := Subsingleton.elim _ _
    have hgl : TopCat.Presheaf.IsGluing H.obj U (fun i => homLocalSection U f i)
        (hglue hcompat).choose := _hs
    have hsi : (ConcreteCategory.hom (H.obj.map (Opens.leSupr U i).op)) (hglue hcompat).choose
        = homLocalSection U f i := hgl i
    rw [hop, presheafHom_map_app (homOfLE le_top) (eqToHom hsup.symm)
        (homOfLE le_top ≫ eqToHom hsup.symm) rfl, ← hsi,
      presheafHom_map_app (homOfLE hWi) (Opens.leSupr U i)
        (homOfLE hWi ≫ Opens.leSupr U i) rfl]
    rw [show (homOfLE le_top ≫ eqToHom hsup.symm : W' ⟶ iSup U)
        = (homOfLE hWi ≫ Opens.leSupr U i) from Subsingleton.elim _ _]
  -- It suffices, by separatedness of the sheaf `N`, to check the linearity equation on a
  -- neighbourhood of each point; we use the cover member `U i` through the point.
  refine N.isSheaf.section_ext ?_
  intro x hx
  obtain ⟨i, hi⟩ := hU x
  refine ⟨V.unop ⊓ U i, inf_le_left, ⟨hx, hi⟩, ?_⟩
  -- Reduce both sides via naturality of `g` (so the outer `N`-restriction is absorbed into
  -- `g.app (op W)`) and the semilinearity of the `M`, `N` restriction maps (`map_smul`) to
  -- local linearity of `g` at `W := V.unop ⊓ U i ≤ U i`.
  set W : X.Opens := V.unop ⊓ U i with hWdef
  have hWV : W ≤ V.unop := inf_le_left
  erw [← NatTrans.naturality_apply g (homOfLE hWV).op (r • m),
      PresheafOfModules.map_smul M.val (homOfLE hWV).op r m,
      PresheafOfModules.map_smul N.val (homOfLE hWV).op r ((g.app V).hom m),
      ← NatTrans.naturality_apply g (homOfLE hWV).op m]
  -- `g` agrees on `W ≤ U i` with the local section manufactured from the module morphism `f i`;
  -- it remains to prove the `homLocalSection`-component is `X.ringCatSheaf(W)`-linear.
  rw [hconn i W inf_le_right]
  -- The component is the triple composite `M.map (eqToHom e₁) ≫ (f i).val.app P ≫ N.map (eqToHom e₂)`
  -- (`P = (U i).ι ⁻¹ᵁ W`).  Decompose it into the three legs.
  simp only [homLocalSection]
  -- The `homLocalSection`-component at `W` is the triple composite
  --   `Φ = M.val.map (eqToHom e₁) ≫ (f i).val.app P ≫ N.val.map (eqToHom e₂)`  (`P = (U i).ι ⁻¹ᵁ W`),
  -- an `Ab`-morphism `M(W) ⟶ N(W)`.  We must show `Φ (r' • m') = r' • Φ m'` for the structure
  -- scalar `r' = X.ringCatSheaf.map (homOfLE hWV).op r : X.ringCatSheaf(W)`.  Expose the three legs.
  erw [ConcreteCategory.comp_apply, ConcreteCategory.comp_apply,
       ConcreteCategory.comp_apply, ConcreteCategory.comp_apply,
       PresheafOfModules.toPresheaf_map_app_apply,
       PresheafOfModules.toPresheaf_map_app_apply]
  -- Push the scalar through the three legs.  We use the *Γ-level* `Scheme.Modules.map_smul`
  -- (which keeps the native `Γ(M, ·)`-module structure) rather than `PresheafOfModules.map_smul`
  -- (whose semilinear codomain introduces a `restrictScalars`-along-`eqToHom` module that does not
  -- match the `f`-leg's `restrictScalars 𝟙` action — `(U i).ι.appIso = Iso.refl`).
  -- (a) `M`-leg semilinearity (CLOSED): `M.map e₁ (r' • m') = (X.ring.map e₁ r') • M.map e₁ m'`,
  -- with the native `Γ(M, image)`-action on the right (no `restrictScalars` artifact).
  erw [Scheme.Modules.map_smul M]
  -- (b) `f`-leg `(U i)`-linearity is available as the term `hfl`: `(f i).val.app P` is
  -- `(U i).ringCatSheaf(P)`-linear.  Since `(U i).ι.appIso = Iso.refl`
  -- (`AlgebraicGeometry.Scheme.Opens.ι_appIso`), `(U i).ringCatSheaf(P) = Γ(X, image)` and the
  -- `(U i)`-action on `M.restrict (U i).ι` is `ModuleCat.restrictScalars 𝟙` of the native action.
  have hfl := ((f i).val.app (op ((U i).ι ⁻¹ᵁ
    (Over.mk (homOfLE (inf_le_right : W ≤ U i))).left))).hom.map_smul
  -- **Native↔`restrictScalars 𝟙` smul bridge** for any `K : X.Modules`.  The `(U i)`-action
  -- on `K.restrict (U i).ι` is `ModuleCat.restrictScalars` of the native `Γ(X, image)`-action
  -- along the structure-ring map `(forget₂ …).map ((U i).ι.appIso _).inv`, which is the identity
  -- because `(U i).ι.appIso = Iso.refl` (`AlgebraicGeometry.Scheme.Opens.ι_appIso`).
  have hbridge : ∀ (K : X.Modules) (c : Γ(X, (U i).ι ''ᵁ (U i).ι ⁻¹ᵁ W))
      (y : Γ(K, (U i).ι ''ᵁ (U i).ι ⁻¹ᵁ W)),
      (c • y : Γ(K, (U i).ι ''ᵁ (U i).ι ⁻¹ᵁ W))
        = (c • (show ↑((K.restrict (U i).ι).val.obj (op ((U i).ι ⁻¹ᵁ W))) from y)) := by
    intro K c y
    erw [ModuleCat.restrictScalars.smul_def']
    simp [AlgebraicGeometry.Scheme.Opens.ι_appIso]
    rfl
  -- **Native `Γ(X, image)`-linearity of the `f`-leg**, bridged from `hfl` via `hbridge`.
  have hfl_native : ∀ (c : Γ(X, (U i).ι ''ᵁ (U i).ι ⁻¹ᵁ W))
      (y : Γ(M, (U i).ι ''ᵁ (U i).ι ⁻¹ᵁ W)),
      (ConcreteCategory.hom ((f i).val.app (op ((U i).ι ⁻¹ᵁ W)))) (c • y)
        = c • (ConcreteCategory.hom ((f i).val.app (op ((U i).ι ⁻¹ᵁ W)))) y := by
    intro c y
    rw [hbridge M c y]
    erw [hfl]
    rfl
  -- (c) `N`-leg semilinearity (native), pulling the structure scalar back out.
  erw [hfl_native, Scheme.Modules.map_smul N]
  -- (d) reconcile the `eqToHom`-transported scalars: the two down-set comparison maps `e₁, e₂`
  -- compose (through the identity `(U i).ι.appIso`) to `𝟙` on `Γ(X, image)`, since
  -- `(U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ W) = W`; on the thin poset `Opens X` this is `Subsingleton.elim`.
  congr 1
  simp only [homOfLE_leOfHom, Over.forget_obj, Over.mk_left, Functor.op_obj, sheafCompose_obj_obj,
    Functor.comp_obj, CommRingCat.forgetToRingCat_obj, ObjectProperty.ι_obj, op_unop,
    Opens.ι_appIso, Iso.refl_inv, Functor.whiskerRight_app, CommRingCat.forgetToRingCat_map_hom,
    RingHom.toMonoidHom_eq_coe, OneHom.toFun_eq_coe, MonoidHom.toOneHom_coe, MonoidHom.coe_coe,
    Functor.comp_map, ZeroHom.coe_mk]
  rw [← X.presheaf.map_id (op ((U i).ι ''ᵁ (U i).ι ⁻¹ᵁ W))]
  erw [← ConcreteCategory.comp_apply, ← Functor.map_comp, ← ConcreteCategory.comp_apply,
    ← Functor.map_comp]
  refine (ConcreteCategory.congr_hom (congrArg X.presheaf.map
    (Subsingleton.elim _ (𝟙 (op W)))) _).trans ?_
  rw [X.presheaf.map_id]
  rfl

end Modules

end Scheme

end AlgebraicGeometry
