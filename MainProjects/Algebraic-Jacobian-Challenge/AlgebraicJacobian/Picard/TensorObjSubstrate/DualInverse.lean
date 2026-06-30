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
   dual (blueprint `lem:dual_restrict_iso`; the C-bridge).  **CLOSED** (iter-317, axiom-clean):
   Steps 1–3 (`restrictFunctorIsoPullback`/`sheafificationCompPullback`/strip) + H1
   (`pushforwardPushforwardAdj`∘`leftAdjointUniq`) + the Step-4 presheaf residual
   `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`
   are all in place.  Step-4 is assembled sectionwise from `sliceDualTransport` (see piece 1b
   below) via `isoMk`; its `Opens Y` V-naturality square closes by `rfl` after splitting the
   composites (the transport `.app`/`restrictionMap`/pushforward-`dual.map` reindexings are all
   defeq, so both legs land on `φ.app` at the same slice object).

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
   `invFun` is CLOSED (iter-265/271, extracted as `sliceDualTransportInv`), and `left_inv`/`right_inv`
   are CLOSED (iter-313, axiom-clean).  The forward `naturality` field is CLOSED (iter-316,
   axiom-clean) via the extracted standalone lemma `sliceDualTransport_toFun_naturality` (own
   heartbeat budget; leg-A `ψ`/`φ`-`naturality_apply` ∘ leg-B `appIso_hom_naturality_apply`, the
   verified `.hom'`-wall `erw` recipe).  The reverse `sliceDualTransportInv.naturality` is CLOSED
   (iter-317, axiom-clean): the reverse ε-telescope reduces (collapse-clears + `εInv` + `appIso`-swap
   reductions) to a 3-identity residual — the cross-fiber `M.val.map` alignment `harg`
   (parallel thin-poset paths via `congr_map_apply`+`Subsingleton.elim`), `PresheafOfModules.naturality_apply ψ`,
   and the leg-B `appIso_inv_naturality` relabel chase `keyB`.  **All `sliceDualTransport`/`Inv` fields and
   `dual_restrict_iso` are now sorry-free.**
2. `dual_isLocallyTrivial` — the dual of a locally-trivial module is locally trivial
   (blueprint `lem:dual_isLocallyTrivial`).  **CLOSED** (iter-317; `dual_restrict_iso` is now
   sorry-free): the three-step chart-chase
   `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` is assembled and compiles, no
   longer inheriting any residual.  The third leg `dual_unit_iso`
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
        (Over.homMk f.unop (Category.comp_id _) : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op
        (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
      have hrm : (restr X.unop
            (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).map
          (Over.homMk f.unop (Category.comp_id _) : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op
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

/-- **Element action of `inv ε` for a `restrictScalars` along a bijective ring hom.**  The
lax-monoidal unit `ε (restrictScalars g)` has underlying map `g` (`ModuleCat.restrictScalars_η`);
since `g` is bijective `ε` is invertible (`restrictScalars_isIso_ε_of_bijective`) and the underlying
map of `inv ε` is `g⁻¹` (`(RingEquiv.ofBijective g hg).symm`).  This is the reusable element-level
ingredient that powers the ε-swap cancellations in the `sliceDualTransport` round-trips and
naturality (`dualUnitRingSwap`/`dualUnitRingSwapHom`/`unitRelabelSwap` are all `inv ε`s). -/
lemma εInv_apply {R S : Type u} [CommRing R] [CommRing S] (g : R →+* S)
    (hg : Function.Bijective g) (s : S) :
    haveI := restrictScalars_isIso_ε_of_bijective g hg
    (CategoryTheory.ConcreteCategory.hom
        (CategoryTheory.inv (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars g)))) s
      = (RingEquiv.ofBijective g hg).symm s := by
  haveI := restrictScalars_isIso_ε_of_bijective g hg
  have key : (CategoryTheory.ConcreteCategory.hom
        (CategoryTheory.inv (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars g))))
        ((CategoryTheory.ConcreteCategory.hom (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars g)))
          ((RingEquiv.ofBijective g hg).symm s)) = (RingEquiv.ofBijective g hg).symm s := by
    rw [← CategoryTheory.ConcreteCategory.comp_apply, IsIso.hom_inv_id]; rfl
  rw [ModuleCat.restrictScalars_η] at key
  rw [show g ((RingEquiv.ofBijective g hg).symm s) = s from
    (RingEquiv.ofBijective g hg).apply_symm_apply s] at key
  exact key

open Opposite in
/-- **Two ε-swap cancellation on the unit carrier.**  The reverse transport `sliceDualTransportInv`
applies `inv ε (.hom-direction)` after the forward transport's `inv ε (.inv-direction)`; on the
shared section ring `𝒪_X(f''ᵁP)` the two `inv ε` (= `(RingEquiv.ofBijective (appIso).hom).symm` and
`(RingEquiv.ofBijective (appIso).inv).symm`) cancel, because `(appIso f P).hom` and `(appIso f P).inv`
are mutually-inverse ring maps (`Iso.hom_inv_id`).  Stated at the plain `↑(X.presheaf.obj _)` carrier
(not the `restr`/`𝟙_` spelling) so the `RingEquiv`/`Mul` instance synthesis is native; the caller
bridges the unit-object spelling with `erw`. -/
lemma appIso_swap_cancel {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (P : TopologicalSpace.Opens ↥Y)
    (hh : Function.Bijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom))
    (hi : Function.Bijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).inv))
    (u : ↑(X.presheaf.obj (Opposite.op ((Scheme.Hom.opensFunctor f).obj P)))) :
    (RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom) hh).symm
        ((RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).inv) hi).symm u) = u := by
  have h1 : (RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).inv) hi).symm u
      = (RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom) hh) u := by
    rw [RingEquiv.symm_apply_eq, RingEquiv.ofBijective_apply, RingEquiv.ofBijective_apply]
    have hki := congrArg CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom_inv_id
    simp only [CommRingCat.hom_comp, CommRingCat.hom_id] at hki
    exact (RingHom.congr_fun hki u).symm
  rw [h1, RingEquiv.symm_apply_apply]

open Opposite in
/-- **`inv ε`-relabel as the reverse section restriction map.**  For an `eqToHom`-induced section
relabel `X.presheaf.map (eqToHom e)` (`e : a = b` of section opens), the inverse `RingEquiv`
(produced by `εInv_apply` at the unit-relabel swap `unitRelabelSwap`) is just the reverse relabel
`X.presheaf.map (eqToHom e.symm)`.  Lets the `unitRelabelSwap` `inv ε` in the `sliceDualTransport`
round-trips collapse to a plain presheaf restriction, exposing `φ.naturality`. -/
lemma presheafMap_ofBijective_symm {X : Scheme.{u}}
    {a b : (TopologicalSpace.Opens ↥X)ᵒᵖ} (e : a = b)
    (hb : Function.Bijective (CommRingCat.Hom.hom (X.presheaf.map (eqToHom e))))
    (s : ↑(X.presheaf.obj b)) :
    (RingEquiv.ofBijective (CommRingCat.Hom.hom (X.presheaf.map (eqToHom e))) hb).symm s
      = (CommRingCat.Hom.hom (X.presheaf.map (eqToHom e.symm))) s := by
  rw [RingEquiv.symm_apply_eq, RingEquiv.ofBijective_apply, ← CommRingCat.comp_apply,
    ← Functor.map_comp, eqToHom_trans, eqToHom_refl, X.presheaf.map_id, ConcreteCategory.id_apply]

open Opposite in
/-- **Three-way `appIso` relabel cancellation (the `right_inv` analogue of `appIso_swap_cancel`).**
In `right_inv` the `εrel` section-relabel sits BETWEEN the two `appIso` swaps (unlike `left_inv`,
where they are adjacent and cancel via `appIso_swap_cancel`).  The composite
`(appIso W').hom ∘ (X-side relabel `X.presheaf.map (opensFunctor.op.map i)`) ∘ (appIso P).inv`
collapses to the Y-side section relabel `Y.presheaf.map i`, via the naturality of `appIso.inv`
against restriction (`Scheme.Hom.appIso_inv_naturality`) followed by `Iso.inv_hom_id` of `appIso`. -/
lemma appIso_relabel_cancel {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    {P W' : TopologicalSpace.Opens ↥Y} (i : (Opposite.op P : (TopologicalSpace.Opens ↥Y)ᵒᵖ) ⟶ op W')
    (u : ↑(Y.presheaf.obj (op P))) :
    (CommRingCat.Hom.hom (Scheme.Hom.appIso f W').hom)
        ((CommRingCat.Hom.hom (X.presheaf.map ((Hom.opensFunctor f).op.map i)))
          ((CommRingCat.Hom.hom (Scheme.Hom.appIso f P).inv) u))
      = (CommRingCat.Hom.hom (Y.presheaf.map i)) u := by
  -- Naturality of `appIso.inv` against the relabel `i`, packaged as a morphism identity.
  have hnat := Scheme.Hom.appIso_inv_naturality f i
  have key : (Scheme.Hom.appIso f P).inv ≫ X.presheaf.map ((Hom.opensFunctor f).op.map i) ≫
        (Scheme.Hom.appIso f W').hom = Y.presheaf.map i := by
    rw [← Category.assoc, ← hnat]
    erw [Category.assoc, Iso.inv_hom_id, Category.comp_id]
  have hu := ConcreteCategory.congr_hom key u
  erw [CommRingCat.comp_apply, CommRingCat.comp_apply] at hu
  exact hu

open Opposite in
/-- **`(ofBijective (appIso W').inv).symm = (appIso W').hom` at the element level.**  The inverse of
the `RingEquiv` built from `(appIso W').inv` is the underlying map of `(appIso W').hom`, by
`hom_inv_id` of `appIso`.  A spelling-bridge for the `right_inv`/`left_inv` round-trips. -/
lemma ofBijective_appIso_inv_symm {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y)
    (hi : Function.Bijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f W').inv))
    (x : ↑(X.presheaf.obj (op ((Hom.opensFunctor f).obj W')))) :
    (RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f W').inv) hi).symm x
      = (CommRingCat.Hom.hom (Scheme.Hom.appIso f W').hom) x := by
  rw [RingEquiv.symm_apply_eq, RingEquiv.ofBijective_apply]
  have h := congrArg CommRingCat.Hom.hom (Scheme.Hom.appIso f W').hom_inv_id
  simp only [CommRingCat.hom_comp, CommRingCat.hom_id] at h
  exact (RingHom.congr_fun h x).symm

open Opposite in
/-- **`(ofBijective (appIso P).hom).symm = (appIso P).inv` at the element level.**  Mirror of
`ofBijective_appIso_inv_symm` for the `.hom`-direction swap, by `inv_hom_id` of `appIso`. -/
lemma ofBijective_appIso_hom_symm {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (P : TopologicalSpace.Opens ↥Y)
    (hh : Function.Bijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom))
    (x : ↑(Y.presheaf.obj (op P))) :
    (RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom) hh).symm x
      = (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).inv) x := by
  rw [RingEquiv.symm_apply_eq, RingEquiv.ofBijective_apply]
  have h := congrArg CommRingCat.Hom.hom (Scheme.Hom.appIso f P).inv_hom_id
  simp only [CommRingCat.hom_comp, CommRingCat.hom_id] at h
  exact (RingHom.congr_fun h x).symm

open Opposite in
/-- **Three-way relabel cancellation, in the `RingEquiv.ofBijective ·.symm` spelling of the goal.**
Exactly the telescope appearing in the `right_inv` round-trip after `erw [εInv_apply ×3]`:
`(ofBij (appIso W').inv).symm ∘ (ofBij (X-relabel)).symm ∘ (ofBij (appIso P).hom).symm` applied to a
section `u : 𝒪_Y(P)` collapses to the `Y`-side section relabel `Y.presheaf.map (eqToHom (op hPW))`
(`hPW : P = W'`).  Proved by `subst hPW`, after which both relabels are identities and the two
`appIso` swaps cancel via `inv_hom_id`. -/
lemma appIso_relabel_cancel_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    {P W' : TopologicalSpace.Opens ↥Y} (hPW : P = W')
    (eX : (op ((Hom.opensFunctor f).obj W') : (TopologicalSpace.Opens ↥X)ᵒᵖ)
      = op ((Hom.opensFunctor f).obj P))
    (hi : Function.Bijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f W').inv))
    (hr : Function.Bijective (CommRingCat.Hom.hom (X.presheaf.map (eqToHom eX))))
    (hh : Function.Bijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom))
    (u : ↑(Y.presheaf.obj (op P))) :
    (RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f W').inv) hi).symm
        ((RingEquiv.ofBijective (CommRingCat.Hom.hom (X.presheaf.map (eqToHom eX))) hr).symm
          ((RingEquiv.ofBijective (CommRingCat.Hom.hom (Scheme.Hom.appIso f P).hom) hh).symm u))
      = (CommRingCat.Hom.hom (Y.presheaf.map (eqToHom (congrArg op hPW)))) u := by
  subst hPW
  rw [ofBijective_appIso_hom_symm, presheafMap_ofBijective_symm, ofBijective_appIso_inv_symm]
  -- both `eX`-relabels are now identities (`eqToHom` between equal opens)
  rw [eqToHom_refl, X.presheaf.map_id, eqToHom_refl, Y.presheaf.map_id]
  simp only [CommRingCat.id_apply]
  -- residual: `(appIso P).hom ((appIso P).inv u) = u`
  have h := congrArg CommRingCat.Hom.hom (Scheme.Hom.appIso f P).inv_hom_id
  simp only [CommRingCat.hom_comp, CommRingCat.hom_id] at h
  exact RingHom.congr_fun h u

/-- **The double-`restrictScalars` collapse legs act as the identity on elements.**  Both
`ModuleCat.restrictScalarsId'App` and `ModuleCat.restrictScalarsComp'App` are `AddEquiv.refl` on the
underlying carrier, so the `sliceDualTransportInv` `?collapse` morphism
`(restrictScalarsId'App (g∘f) ⋯ M).inv ≫ (restrictScalarsComp'App f g (g∘f) rfl M).hom` is the
identity at the element level (`rfl`).  Used to clear the collapse legs in `sliceDualTransport.left_inv`
(where, unlike `right_inv`, the absence of a pushforward means `PresheafOfModules.naturality_apply`
cannot absorb them by defeq).  Proof-irrelevance makes the concrete `Id'App` hypothesis match. -/
lemma restrictScalars_collapse_apply {R₁ R₂ : Type u} [Ring R₁] [Ring R₂]
    (f : R₁ →+* R₂) (g : R₂ →+* R₁) (hgf : g.comp f = RingHom.id R₁)
    (M : ModuleCat.{u} R₁) (x : ↑M) :
    (((ModuleCat.restrictScalarsId'App (g.comp f) hgf M).inv ≫
        (ModuleCat.restrictScalarsComp'App f g (g.comp f) rfl M).hom)).hom' x = x := rfl

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

set_option maxHeartbeats 800000 in
-- The reverse `app` 4-leg telescope (eqToHom/collapse/core/unitRelabelSwap) and its naturality
-- ε-paste overrun the default 200000-heartbeat budget during `whnf` on `restrictScalars`.
set_option backward.isDefEq.respectTransparency false in
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
    intro X1 Y1 f1
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    -- Strip the categorical scaffolding (keep the `restrictScalarsId'App`/`Comp'App` collapse legs
    -- as named isos for `restrictScalars_collapse_apply`), then collapse the `inv ε`s on both sides.
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply, dualUnitRingSwapHom, unitRelabelSwap]
    erw [Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply,
      Scheme.Modules.εInv_apply]
    all_goals try exact CategoryTheory.ConcreteCategory.bijective_of_isIso _
    -- The two outer `inv ε` per side are now `ofBijective …·.symm`: turn the `appIso.hom`-swap into
    -- `appIso.inv` and the `εrel` into the reverse presheaf relabel `X.presheaf.map (eqToHom he)`.
    erw [presheafMap_ofBijective_symm, ofBijective_appIso_hom_symm,
      presheafMap_ofBijective_symm, ofBijective_appIso_hom_symm]
    -- Peel the LHS `ψ`-reindex wrapper (`restrictScalars` is identity on the carrier) to `ψ.app A_Y1`.
    erw [ModuleCat.restrictScalars.map_apply]
    -- **REDUCED to the cross-fiber `ψ`-naturality residual (the genuine reverse-only difficulty).**
    -- Both sides are now `X.presheaf.map (eqToHom he) ∘ (appIso (f⁻¹W')).inv ∘ ψ.app A_W' ∘ collapse ∘
    -- M.val.map (eqToHom he)`, with `A_W' = op (Over.mk (homOfLE hPV))`, `collapse` the (carrier-identity)
    -- `restrictScalarsId'App.inv ≫ restrictScalarsComp'App.hom`, and the LHS additionally pre-composed by
    -- the slice restriction `(restr fV M.val).map f1`.  **CLOSE:** build the slice morphism
    -- `g'' : A_X1 ⟶ A_Y1` over `Over (unop V)` (from `f⁻¹(unop Y1).left ≤ f⁻¹(unop X1).left`, the preimage
    -- monotonicity of `hle`), then `hnatψ := PresheafOfModules.naturality_apply ψ g'' z` (`z`'s carrier
    -- `M.val(op (unop X1).left) ≡ M₁.obj A_X1` by `he_X`, exactly as in the CLOSED forward).
    -- UNLIKE the forward, `M₁.map g'' z` is only `Subsingleton.elim`-equal (NOT defeq) to the LHS inner
    -- `collapse (M.val.map (eqToHom he_Y) ((restr fV M.val).map f1 z))`: the two `M.val.map` legs are
    -- PARALLEL thin-poset `Opens X` morphisms differing by the cross-fiber `eqToHom` relabel.  So `erw
    -- [hnatψ]` needs a preceding `Subsingleton.elim`/`eqToHom`-functoriality alignment of those `M.val.map`
    -- legs (the move `homLocalSection.naturality` uses); then the residual is the SAME leg-B
    -- `Scheme.Hom.appIso_inv_naturality` + `X.presheaf.map (eqToHom) ∘ (restr fV 𝟙_X).map f1` relabel
    -- cancel as the forward's `appIso_hom_naturality_apply` close.  All infrastructure present; this
    -- thin-poset `M.val.map` alignment is the lone remaining fine-grained step.
    -- Clear the LHS collapse, peel the RHS `ψ`-reindex `restrictScalars` wrapper on the pristine
    -- `.hom'` form, then clear the (now-exposed) RHS collapse.
    erw [restrictScalars_collapse_apply ((Scheme.Hom.appIso f (f ⁻¹ᵁ (unop Y1).left)).hom.hom)
        (RingCat.Hom.hom (β.app (op (f ⁻¹ᵁ (unop Y1).left)))) (hβ (f ⁻¹ᵁ (unop Y1).left)) _]
    erw [ModuleCat.restrictScalars.map_apply
        (CommRingCat.Hom.hom (Scheme.Hom.appIso f (f ⁻¹ᵁ (unop X1).left)).hom)]
    erw [restrictScalars_collapse_apply ((Scheme.Hom.appIso f (f ⁻¹ᵁ (unop X1).left)).hom.hom)
        (RingCat.Hom.hom (β.app (op (f ⁻¹ᵁ (unop X1).left)))) (hβ (f ⁻¹ᵁ (unop X1).left)) _]
    -- Down-set data + the cross-fiber slice morphism `g''` for `ψ`-naturality.
    have he_X : f ''ᵁ (f ⁻¹ᵁ (unop X1).left) = (unop X1).left := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
      exact inf_eq_right.mpr ((unop X1).hom.le.trans (f.image_le_opensRange (unop V)))
    have he_Y : f ''ᵁ (f ⁻¹ᵁ (unop Y1).left) = (unop Y1).left := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
      exact inf_eq_right.mpr ((unop Y1).hom.le.trans (f.image_le_opensRange (unop V)))
    have hle : (unop Y1).left ≤ (unop X1).left := (f1.unop).left.le
    have hPV_X : f ⁻¹ᵁ (unop X1).left ≤ unop V :=
      le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop X1).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V)))
    have hPV_Y : f ⁻¹ᵁ (unop Y1).left ≤ unop V :=
      le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop Y1).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V)))
    have hpre : f ⁻¹ᵁ (unop Y1).left ≤ f ⁻¹ᵁ (unop X1).left :=
      (TopologicalSpace.Opens.map f.base).monotone hle
    let g'' : (op (Over.mk (homOfLE hPV_X)) : (Over (unop V))ᵒᵖ) ⟶ op (Over.mk (homOfLE hPV_Y)) :=
      (Over.homMk (homOfLE hpre) (by subsingleton)).op
    -- **Alignment (the reverse-only difficulty):** the LHS inner `M.val.map`-leg equals the
    -- `ψ`-domain restriction `M₁.map g''` of the RHS inner leg, because both are `M.val.map` of
    -- parallel thin-poset `Opens X` morphisms (`Subsingleton.elim`); the `restr`/`pushforward`
    -- restriction maps are `M.val.map` of opensFunctor-reindexed morphisms by `rfl`.
    have harg : (M.val.map (eqToHom (congrArg op he_Y.symm))).hom'
            ((ModuleCat.Hom.hom ((restr (f ''ᵁ (unop V)) M.val).map f1)) z)
          = (restr (unop V) ((PresheafOfModules.pushforward β).obj M.val)).map g''
              ((M.val.map (eqToHom (congrArg op he_X.symm))).hom' z) := by
      change (M.val.map (eqToHom (congrArg op he_Y.symm))).hom'
            ((M.val.map ((Over.forget (f ''ᵁ (unop V))).op.map f1)).hom' z)
          = (M.val.map (((Hom.opensFunctor f).map ((Over.forget (unop V)).op.map g'').unop).op)).hom'
              ((M.val.map (eqToHom (congrArg op he_X.symm))).hom' z)
      erw [← PresheafOfModules.map_comp_apply, ← PresheafOfModules.map_comp_apply]
      exact M.val.congr_map_apply (Subsingleton.elim _ _) z
    erw [harg, PresheafOfModules.naturality_apply ψ g''
        ((M.val.map (eqToHom (congrArg op he_X.symm))).hom' z)]
    -- **leg-B (the appIso-inv relabel chase).**  The two unit restriction maps `(restr · 𝟙_).map`
    -- are section relabels (`Y.presheaf.map jp`, `X.presheaf.map ipX` by `rfl`); the residual ring
    -- identity is `appIso_inv_naturality` + an `eqToHom`/`Subsingleton.elim` thin-poset relabel.
    let jp : (op (f ⁻¹ᵁ (unop X1).left) : (TopologicalSpace.Opens ↥Y)ᵒᵖ) ⟶ op (f ⁻¹ᵁ (unop Y1).left) :=
      (Over.forget (unop V)).op.map g''
    let ipX : (op (unop X1).left : (TopologicalSpace.Opens ↥X)ᵒᵖ) ⟶ op (unop Y1).left :=
      (Over.forget (f ''ᵁ (unop V))).op.map f1
    have keyB : Y.presheaf.map jp ≫ (Scheme.Hom.appIso f (f ⁻¹ᵁ (unop Y1).left)).inv ≫
          X.presheaf.map (eqToHom (congrArg op he_Y))
        = (Scheme.Hom.appIso f (f ⁻¹ᵁ (unop X1).left)).inv ≫
          X.presheaf.map (eqToHom (congrArg op he_X)) ≫ X.presheaf.map ipX := by
      rw [Scheme.Hom.appIso_inv_naturality_assoc f jp, Category.assoc, ← Functor.map_comp,
        ← Functor.map_comp]
      congr 2
    have hc := ConcreteCategory.congr_hom keyB
        ((ConcreteCategory.hom (ψ.app (op (Over.mk (homOfLE hPV_X)))))
          ((M.val.map (eqToHom (congrArg op he_X.symm))).hom' z))
    erw [CommRingCat.comp_apply, CommRingCat.comp_apply, CommRingCat.comp_apply,
      CommRingCat.comp_apply] at hc
    erw [hc, CommRingCat.comp_apply, CommRingCat.comp_apply]

set_option backward.isDefEq.respectTransparency false in
open Opposite in
/-- **Naturality of the `.hom` direction of the structure ring iso `appIso` against restriction.**
The `.hom` analogue of `Scheme.Hom.appIso_inv_naturality`: `appIso.hom` commutes with the section
restriction maps along `f.opensFunctor`.  Derived from `appIso_inv_naturality` by cancelling the
inverse iso. -/
lemma appIso_hom_naturality {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    {U V : TopologicalSpace.Opens ↥Y} (i : (op U : (TopologicalSpace.Opens ↥Y)ᵒᵖ) ⟶ op V) :
    X.presheaf.map ((Hom.opensFunctor f).op.map i) ≫ (Scheme.Hom.appIso f V).hom
      = (Scheme.Hom.appIso f U).hom ≫ Y.presheaf.map i := by
  have h := Scheme.Hom.appIso_inv_naturality f i
  rw [Iso.comp_inv_eq, Category.assoc] at h
  rw [h, ← Category.assoc, Iso.hom_inv_id, Category.id_comp]

open Opposite in
/-- **Element-level form of `appIso_hom_naturality`.**  Powers leg-B of the forward
`sliceDualTransport` naturality square (the `dualUnitRingSwap` underlying map IS `(appIso _).hom`
after the `εInv_apply`/`ofBijective_appIso_inv_symm` reduction). -/
lemma appIso_hom_naturality_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    {U V : TopologicalSpace.Opens ↥Y} (i : (op U : (TopologicalSpace.Opens ↥Y)ᵒᵖ) ⟶ op V)
    (w : ↑(X.presheaf.obj (op ((Hom.opensFunctor f).obj U)))) :
    (CommRingCat.Hom.hom (Scheme.Hom.appIso f V).hom)
        ((CommRingCat.Hom.hom (X.presheaf.map ((Hom.opensFunctor f).op.map i))) w)
      = (CommRingCat.Hom.hom (Y.presheaf.map i))
          ((CommRingCat.Hom.hom (Scheme.Hom.appIso f U).hom) w) := by
  have h := ConcreteCategory.congr_hom (appIso_hom_naturality f i) w
  erw [CommRingCat.comp_apply, CommRingCat.comp_apply] at h
  exact h

set_option maxHeartbeats 400000 in
-- The element-level ε-paste chase (`εInv_apply`/`naturality_apply`/`appIso_hom_naturality_apply`
-- through heavy `restrictScalars`/internal-hom `whnf`) overruns the default 200000-heartbeat budget.
set_option backward.isDefEq.respectTransparency false in
open PresheafOfModules InternalHom Opposite in
/-- **Standalone forward-slice naturality square (leg-A ∘ leg-B ε-paste), extracted for its own
heartbeat budget.**  The thin-poset naturality field of the forward `sliceDualTransport.toFun`
section: for `f1 : X1 ⟶ Y1` in `(Over (unop V))ᵒᵖ`, the family
`app W := (restrictScalars (β W'.left)).map (φ.app A_W) ≫ dualUnitRingSwap f W'.left`
commutes with restriction.  Two genuine ingredients pasted: (A) `φ.naturality` reindexes the
`φ.app` legs across `opensFunctor.map f1`; (B) `appIso_hom_naturality_apply` slides the
`dualUnitRingSwap` codomain swaps (whose underlying map is `(appIso _).hom`) through the
restriction maps.  Extracted top-level (own budget) per the iter-316 standalone-first discipline. -/
lemma sliceDualTransport_toFun_naturality {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ) :
    letI α : Y.presheaf ⟶ (Hom.opensFunctor f).op ⋙ X.presheaf :=
      { app := fun U ↦ (Hom.appIso f (Opposite.unop U)).inv,
        naturality := fun _ _ g => Scheme.Hom.appIso_inv_naturality f g }
    letI β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    ∀ (φ : (((PresheafOfModules.pushforward β).obj M.val.dual).obj V : Type u))
      {X1 Y1 : (Over (Opposite.unop V))ᵒᵖ} (f1 : X1 ⟶ Y1),
    (restr (Opposite.unop V) ((PresheafOfModules.pushforward β).obj M.val)).map f1 ≫
        (ModuleCat.restrictScalars
            (RingCat.Hom.hom
              ((((Over.forget (Opposite.unop V)).op ⋙
                    (sheafToPresheaf (Opens.grothendieckTopology ↥Y) CommRingCat).obj Y.sheaf) ⋙
                    forget₂ CommRingCat RingCat).map f1))).map
          ((ModuleCat.restrictScalars (RingCat.Hom.hom (β.app (op (Opposite.unop Y1).left)))).map
              (φ.app (op (Over.mk ((Hom.opensFunctor f).map (Opposite.unop Y1).hom)))) ≫
            dualUnitRingSwap f (Opposite.unop Y1).left) =
      ((ModuleCat.restrictScalars (RingCat.Hom.hom (β.app (op (Opposite.unop X1).left)))).map
            (φ.app (op (Over.mk ((Hom.opensFunctor f).map (Opposite.unop X1).hom)))) ≫
          dualUnitRingSwap f (Opposite.unop X1).left) ≫
        (restr (Opposite.unop V)
              (𝟙_ (_root_.PresheafOfModules
                ((sheafToPresheaf (Opens.grothendieckTopology ↥Y) CommRingCat).obj Y.sheaf ⋙
                  forget₂ CommRingCat RingCat)))).map f1 := by
  intro φ X1 Y1 f1
  apply ModuleCat.hom_ext
  refine LinearMap.ext fun z => ?_
  -- Down-set: `f1.unop : Y1 ⟶ X1` in `Over (unop V)`, so `(unop Y1).left ≤ (unop X1).left`.
  have hle : (Opposite.unop Y1).left ≤ (Opposite.unop X1).left := (f1.unop).left.le
  -- The X-side slice morphism `g : A_X1 ⟶ A_Y1` over `Over fV` and the Y-side restriction index `i`.
  let i : (op (Opposite.unop X1).left : (TopologicalSpace.Opens ↥Y)ᵒᵖ) ⟶ op (Opposite.unop Y1).left :=
    (homOfLE hle).op
  let g : (op (Over.mk ((Hom.opensFunctor f).map (Opposite.unop X1).hom)) :
        (Over (f ''ᵁ (Opposite.unop V)))ᵒᵖ) ⟶
      op (Over.mk ((Hom.opensFunctor f).map (Opposite.unop Y1).hom)) :=
    (Over.homMk ((Hom.opensFunctor f).map (homOfLE hle)) (by subsingleton)).op
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply, ModuleCat.restrictScalars.map_apply,
    dualUnitRingSwap]
  erw [Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply]
  all_goals try exact CategoryTheory.ConcreteCategory.bijective_of_isIso _
  erw [ofBijective_appIso_inv_symm, ofBijective_appIso_inv_symm]
  have hnat := PresheafOfModules.naturality_apply φ g z
  erw [ModuleCat.restrictScalars.map_apply]
  erw [hnat]
  erw [ModuleCat.restrictScalars.map_apply]
  -- leg-B: slide `dualUnitRingSwap`/`appIso.hom` through the unit-section restriction maps,
  -- the `.hom`-direction structure-ring-iso naturality `appIso_hom_naturality_apply f i w`.
  exact appIso_hom_naturality_apply f i _

set_option maxHeartbeats 800000 in
-- The `refine LinearEquiv.toModuleIso` carrier + the iter-307 `restrictScalarsLaxε.naturality`
-- (`hε`) term in the `naturality` field involve heavy `whnf` on `restrictScalars`/internal-hom
-- terms; the default 200000 heartbeats is insufficient for this single declaration.
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
      { app := fun U => (f.appIso U.unop).inv,
        naturality := fun _ _ g => Scheme.Hom.appIso_inv_naturality f g }
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
    Functor.whiskerRight ({ app := fun U ↦ (Hom.appIso f (Opposite.unop U)).inv, naturality := fun _ _ g => Scheme.Hom.appIso_inv_naturality f g } :
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
  -- (1) naturality of the leg-A∘leg-B family in `W`.  The square over `(Over (unop V))ᵒᵖ` pastes
  --     TWO genuine ingredients (the thin-poset `Subsingleton.elim` settles only the base maps):
  --       (a) leg-A: `φ.naturality` across `(opensFunctor.map f1)` reindexes the `φ.app` legs;
  --       (b) leg-B: the ε-naturality of `restrictScalars` commutes the `dualUnitRingSwap`
  --           codomain swaps through the restriction maps.
  --     CORRECTION (iter-307; the iter-306 "architectural wall" was FALSE): ingredient (b) IS the
  --     natural transformation `PresheafOfModules.restrictScalarsLaxε` — it EXISTS axiom-clean at
  --     `PresheafInternalHom.lean:290`, is imported here (line 7), and its `NatTrans.naturality`
  --     field is EXACTLY this ε-square.  Instantiated below at `α := whiskerRight {appIso.inv} ·`
  --     it typechecks and applies at this very goal (`dualUnitRingSwap = inv` of its component, the
  --     simp lemma `dualUnitRingSwap_comp_dualUnitRingSwapInv`).  No new monoidal infra is needed.
  --     The whole square is the pasting `key` (leg-A) ∘ `key2` (leg-B, from `hε`); see below.
  · intro X1 Y1 f1
    -- The leg-A∘leg-B ε-paste, discharged by the standalone `sliceDualTransport_toFun_naturality`
    -- (own heartbeat budget; `set`-β is defeq to the lemma's `letI`-β whiskerRight literal).
    exact sliceDualTransport_toFun_naturality f M V φ f1
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
    simp only [Functor.whiskerRight_app, CommRingCat.forgetToRingCat_map_hom,
      CommRingCat.hom_comp, CommRingCat.hom_id] at h ⊢
    exact h
  -- (5) left_inv: `invFun (toFun φ) = φ`, collapses via `Iso.inv_hom_id` of `f.appIso`
  --     (`dualUnitRingSwap`/`ε` round-trip) + the down-set bijection.
  --     STRUCTURAL REDUCTION (iter-306): `PresheafOfModules.hom_ext` drops the round-trip to a
  --     PER-COMPONENT equality at each `W'' : (Over fV)ᵒᵖ`, which sidesteps the ε-naturality wall
  --     blocking refine_1 (the `naturality` fields are proof-irrelevant under `hom_ext`).  The
  --     residual `(sliceDualTransportInv (toFun φ)).app W'' = φ.app W''` is the 4-leg telescope:
  --     `M.val.map (eqToHom he) ≫ restrictScalars(ρ).map (collapse ≫ core) ≫ unitRelabelSwap`,
  --     where `core` contains `(toFun φ).app = restrictScalars(β).map (φ.app …) ≫ dualUnitRingSwap`.
  --     It closes by the named ε cancellations `dualUnitRingSwap_comp_dualUnitRingSwapInv` /
  --     `Iso.inv_hom_id` of `f.appIso` against `dualUnitRingSwapHom`, plus `eqToHom`/`restrictScalarsId'App`
  --     collapse of the cross-fiber down-set relabel.  Per-component residual isolated below.
  · intro φ
    apply PresheafOfModules.hom_ext
    intro W''
    -- **left_inv — reduced to the concrete per-component element residual (iter-308).**
    -- `dsimp` unfolds the reverse component to the explicit 4-leg telescope, with
    -- `ψ = toFun φ` already substituted; `hom_ext`+`LinearMap.ext` drop to elements and the
    -- `simp only` strips the categorical scaffolding: the `collapse` legs (`restrictScalarsId'App`
    -- / `restrictScalarsComp'App`) become `AddEquiv.refl` (identity on the underlying type).
    -- WORKED-OUT CLOSE (the remaining `sorry`):  at the element level the LHS is
    --   `εrel⁻¹ ( ε_hom⁻¹ ( ε_inv⁻¹ ( φ.app A ( M.val.map (eqToHom he) z ) ) ) )`
    -- where `A = op (Over.mk (opensFunctor.map (homOfLE hPV)))`, `ε_inv = ε(restrictScalars
    -- (appIso P).inv)`, `ε_hom = ε(restrictScalars (appIso P).hom)`, `εrel = ε(restrictScalars
    -- (X.presheaf.map (eqToHom he)))`, `P = f⁻¹ᵁ W''.left`.  The two inner swaps cancel:
    -- `ε_inv⁻¹`/`ε_hom⁻¹` have underlying maps `(appIso P).inv⁻¹ = (appIso P).hom` and
    -- `(appIso P).hom⁻¹ = (appIso P).inv` (`ModuleCat.restrictScalars_η` for the underlying
    -- of `ε`, `Iso.hom_inv_id`/`inv_hom_id` of `appIso` for the composite), so
    -- `ε_hom⁻¹ (ε_inv⁻¹ x) = x`.  This leaves `εrel⁻¹ ( φ.app A ( M.val.map (eqToHom he) z ) )
    -- = φ.app W'' z`, which is `φ.naturality` across the slice morphism `A ⟶ W''` (the
    -- `homLocalSection`-style reindex used in the CLOSED `app` field), with the `eqToHom`/`εrel`
    -- relabel absorbed by the down-set identity `he : f''ᵁ(f⁻¹ᵁ W''.left) = W''.left`.
    -- The friction blocking the one-shot close is the `inv ε` element-action lemma + the
    -- precise `appIso` ring-map direction at the unit-object carriers (see task_result).
    dsimp only [sliceDualTransportInv]
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    -- Mirror of `right_inv` (iter-312): strip the categorical scaffolding, then collapse the three
    -- `inv ε` to `RingEquiv.ofBijective …·.symm` via `εInv_apply`.  Keep `restrictScalarsId'App`/
    -- `restrictScalarsComp'App` UN-unfolded (out of the simp set) so the double-`restrictScalars`
    -- collapse legs stay as named isos, killable below in element form.
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply, dualUnitRingSwap, dualUnitRingSwapHom,
      unitRelabelSwap]
    erw [Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply]
    all_goals try exact CategoryTheory.ConcreteCategory.bijective_of_isIso _
    -- **INNER TWO SWAPS CANCEL (iter-312).**  Unlike `right_inv`, here the two `appIso` swaps
    -- `ε_hom⁻¹ ∘ ε_inv⁻¹` are ADJACENT, so they cancel via the existing 2-way `appIso_swap_cancel`
    -- (`(appIso P).hom⁻¹ ((appIso P).inv⁻¹ u) = u`).  `Over.mk_left` first unifies the two `P` args.
    erw [appIso_swap_cancel f (f ⁻¹ᵁ (unop W'').left)]
    -- **RESIDUAL = `εrel⁻¹ (φ.app A (collapse (M.val.map (eqToHom) z))) = φ.app W'' z`**, the SAME
    -- `φ.naturality` crux as `right_inv`.  `presheafMap_ofBijective_symm` turns `εrel⁻¹` into the
    -- reverse relabel `X.presheaf.map (eqToHom)`; `restrictScalars.map_apply` peels the `β`-reindex
    -- wrapper on `φ.app A`.  CLOSED (iter-313): unlike `right_inv` (where the pushforward in `M₁` lets
    -- `naturality_apply` absorb the `restrictScalars` collapse legs by defeq), here `M₁ = restr M.val`
    -- has no pushforward, so the collapse is genuinely extra.  A `change` (defeq, robust against the
    -- `instances`-transparency goal corruption from `dsimp [sliceDualTransportInv]`) clears the
    -- defeq-identity collapse (`restrictScalars_collapse_apply`, by `rfl`) AND reshapes the source
    -- relabel `M.val.map (eqToHom)` into `(restr fV M.val).map g` for the thin-poset slice morphism
    -- `g : W'' ⟶ A`; then `naturality_apply` fires and the codomain relabel cancels by `eqToHom_trans`.
    erw [presheafMap_ofBijective_symm, ModuleCat.restrictScalars.map_apply]
    -- Reconstruct the down-set facts (mirror of `sliceDualTransportInv`): `he` is the preimage
    -- round-trip `f''ᵁ(f⁻¹ᵁ W'') = W''` (since `W'' ≤ fV ⊆ range f`), `g` the slice morphism it induces.
    have hWfV : (unop W'').left ≤ f ''ᵁ (unop V) := (unop W'').hom.le
    have hPV : f ⁻¹ᵁ (unop W'').left ≤ unop V :=
      le_trans ((TopologicalSpace.Opens.map f.base).monotone hWfV)
        (le_of_eq (f.preimage_image_eq (unop V)))
    have he : f ''ᵁ f ⁻¹ᵁ (unop W'').left = (unop W'').left := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
      exact inf_eq_right.mpr (hWfV.trans (f.image_le_opensRange (unop V)))
    let g : W'' ⟶ op (Over.mk ((Hom.opensFunctor f).map (Over.mk (homOfLE hPV)).hom)) :=
      (Over.homMk (homOfLE (le_of_eq he)) (by subsingleton)).op
    change (CommRingCat.Hom.hom (X.presheaf.map (eqToHom _)))
        ((ConcreteCategory.hom
            (φ.app (op (Over.mk ((Hom.opensFunctor f).map (Over.mk (homOfLE hPV)).hom)))))
          ((ModuleCat.Hom.hom ((restr (unop ((Hom.opensFunctor f).op.obj V)) M.val).map g)) z)) =
        (ModuleCat.Hom.hom (φ.app W'')) z
    erw [PresheafOfModules.naturality_apply]
    erw [← CommRingCat.comp_apply, ← Functor.map_comp, eqToHom_trans, eqToHom_refl, X.presheaf.map_id]
    · rfl
    · exact congrArg op he.symm
  -- (6) right_inv: `toFun (invFun ψ) = ψ`, the `Iso.hom_inv_id` mirror of (5).  Same structural
  --     reduction: `hom_ext` drops it to a per-component equality at each `W : (Over V)ᵒᵖ`,
  --     `(toFun (invFun ψ)).app W = ψ.app W`, the mirror telescope closing by the reverse ε
  --     cancellation `dualUnitRingSwapInv_comp_dualUnitRingSwap` + `Iso.hom_inv_id` of `f.appIso`.
  · intro ψ
    apply PresheafOfModules.hom_ext
    intro W
    -- **right_inv — reduced to the concrete per-component element residual (iter-308).**
    -- Mirror of `left_inv`: the forward component `(toFun (invFun ψ)).app W` is
    -- `restrictScalars(β.app W').map ((invFun ψ).app A) ≫ dualUnitRingSwap f W'`, with
    -- `(invFun ψ) = sliceDualTransportInv … ψ` the 4-leg telescope.  `dsimp` unfolds it,
    -- `hom_ext`+`LinearMap.ext` drop to elements, the `simp only` strips the categorical
    -- scaffolding (collapse legs → `AddEquiv.refl`).  CLOSE (the remaining `sorry`): the same
    -- two-swap cancellation as `left_inv` but the OTHER way (`dualUnitRingSwapInv_comp_
    -- dualUnitRingSwap` + `Iso.hom_inv_id` of `appIso`), leaving the `ψ.naturality` reindex back
    -- across the down-set identity.  Same `inv ε` element-action friction (see task_result).
    dsimp only [sliceDualTransportInv]
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply, dualUnitRingSwap, dualUnitRingSwapHom,
      unitRelabelSwap, ModuleCat.restrictScalarsId'App, ModuleCat.restrictScalarsComp'App,
      LinearEquiv.toModuleIso_inv, LinearEquiv.toModuleIso_hom]
    erw [Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply]
    all_goals try exact CategoryTheory.ConcreteCategory.bijective_of_isIso _
    -- REDUCED (mirror of `left_inv`, iter-311): the three `inv ε` are now
    -- `(RingEquiv.ofBijective …).symm`.  Residual (outer→inner):
    --   `ε_inv⁻¹ ( εrel⁻¹ ( ε_hom⁻¹ ( ψ-reindex (collapse (M.val.map (eqToHom) z)) ) ) ) = ψ.app W z`
    -- with `ε_inv = (appIso f W').inv`, `ε_hom = (appIso f P).hom` (`P = f⁻¹ᵁ(f''ᵁW') = W'`),
    -- `εrel = X.presheaf.map (eqToHom)` the section relabel `f''ᵁP ↔ f''ᵁW'`.
    -- UNLIKE `left_inv` (where the two `appIso` swaps were ADJACENT and cancelled via
    -- `appIso_swap_cancel`), here `εrel` sits BETWEEN `ε_inv⁻¹` and `ε_hom⁻¹`, so the cancellation
    -- is not the 2-way `appIso_swap_cancel`: after `presheafMap_ofBijective_symm` turns `εrel⁻¹`
    -- into `X.presheaf.map (eqToHom e.symm)`, the residual is
    --   `(appIso W').hom ( X.presheaf.map (eqToHom e.symm) ( (appIso P).inv u ) ) = u`,
    -- which is the `appIso`-naturality square across the relabel (`Scheme.Hom.appIso_inv_naturality`)
    -- composed with `Iso.hom_inv_id` of `appIso`, i.e. a NEW 3-way helper
    -- `appIso_relabel_cancel` is needed (vs `left_inv`'s 2-way), then the same `ψ.naturality`
    -- close as `left_inv` (`PresheafOfModules.naturality_apply` + `map_comp_apply` + the
    -- thin-poset `Subsingleton.elim`).  The 2 reusable helpers (`appIso_swap_cancel`,
    -- `presheafMap_ofBijective_symm`) and the full `left_inv` close are the template.
    have hPW : f ⁻¹ᵁ (Over.mk ((Hom.opensFunctor f).map (unop W).hom)).left = (unop W).left := by
      simp only [Over.mk_left]; exact f.preimage_image_eq _
    -- **TELESCOPE COLLAPSED (iter-312).**  The three `inv ε` (= `ofBijective …·.symm`) cancel via
    -- the new 3-way helper `appIso_relabel_cancel_apply` (`(appIso W').hom ∘ X-relabel ∘ (appIso P).inv
    -- = Y.presheaf.map (eqToHom)` by `appIso_inv_naturality` + `inv_hom_id`, in the goal's
    -- `ofBijective·.symm` spelling, `subst`-proved).  `hPW : P = W'` is `f.preimage_image_eq`.
    erw [appIso_relabel_cancel_apply f hPW]
    -- **RESIDUAL = pure `ψ.naturality` across the `P = W'` slice morphism** (the SAME residual that
    -- closes `left_inv`).  Goal (collapse legs `R.symm ≫ R` are identities, `restrictScalars.map`
    -- keeps the underlying map):
    --   `Y.presheaf.map (eqToHom) ((ψ.app A).hom (M.val.map (eqToHom) z)) = (ψ.app W).hom z`
    -- with `A = op (Over.mk (homOfLE : P ≤ unop V))`, `P = f⁻¹ᵁ(f''ᵁW') = W'`.  Picking the thin-poset
    -- slice morphism `g : W ⟶ A` (from `P = W'`), `PresheafOfModules.naturality_apply ψ g z` gives
    -- `(ψ.app A) ((restr (pushforward β M.val)).map g z) = (restr 𝟙_Y).map g ((ψ.app W) z)`; the two
    -- remaining facts are (a) `(restr (pushforward β M.val)).map g z = collapse (M.val.map (eqToHom) z)`
    -- and (b) `Y.presheaf.map (eqToHom) ∘ (restr 𝟙_Y).map g = id` (the codomain relabel cancels),
    -- both `Subsingleton.elim`/`eqToHom`-collapse on the thin poset.
    -- **CLOSED (iter-313, `analogies/dualcoerce313.md`).**  The `.hom'`/`AddEquiv.refl.toLinearEquiv`
    -- scaffolding is punched through by `erw` against the `ConcreteCategory.hom`-form lemmas
    -- `ModuleCat.restrictScalars.map_apply` (peels the `restrictScalars`-reindex wrapper on `ψ.app A`)
    -- and `PresheafOfModules.naturality_apply` (fires up to defeq, absorbing the collapse-legs into
    -- `M₁.map g` and emitting the slice morphism `?g : W ⟶ A` as a goal).  `?g` is supplied CHEAPLY
    -- as the thin-poset `Over.homMk … |>.op` (mirror of the L143 template), and the residual unit
    -- cancellation closes by defeq.
    erw [ModuleCat.restrictScalars.map_apply, PresheafOfModules.naturality_apply]
    case g => exact (Over.homMk (homOfLE (le_of_eq hPW)) (by subsingleton)).op
    -- Residual unit cancellation `Y.presheaf.map (eqToHom) ∘ (restr V 𝟙_Y).map g = id`: the two
    -- relabels compose to `eqToHom rfl = 𝟙` (`eqToHom_trans`), the side equality of opens objects
    -- being `congrArg op hPW.symm` (the down-set round-trip `P = W'`).
    erw [← CommRingCat.comp_apply, ← Functor.map_comp, eqToHom_trans, eqToHom_refl, Y.presheaf.map_id]
    · rfl
    · exact congrArg op hPW.symm

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
    { app := fun U => (f.appIso U.unop).inv,
      naturality := fun _ _ g => Scheme.Hom.appIso_inv_naturality f g }
  let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight α (forget₂ CommRingCat RingCat)
  have hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φR :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φR
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let H1 := hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)
  refine (H1.app (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).symm ≪≫ ?_
  -- Residual: `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`.
  -- Assemble sectionwise from `sliceDualTransport` (now sorry-free: `.hom`/`naturality`/`invFun` and
  -- both round-trips are CLOSED).  The `isoMk` naturality square is the thin-poset `Opens Y`
  -- coherence of the `sliceDualTransport` family — the V-naturality of the leg-A∘leg-B transport.
  refine PresheafOfModules.isoMk (fun V => sliceDualTransport f M V) ?_
  intro V W g
  apply ModuleCat.hom_ext
  refine LinearMap.ext fun φ => ?_
  apply PresheafOfModules.hom_ext
  intro W''
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply, ModuleCat.restrictScalars.map_apply,
    PresheafOfModules.comp_app]
  rfl

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
   Uses (all deps CLOSED; dual_restrict_iso is now sorry-free, iter-317):
     lem:internal_hom_isSheaf  → `Scheme.Modules.dual` (TensorObjSubstrate.lean ~L207)
     lem:dual_restrict_iso     → `dual_restrict_iso` (this file, §A above — CLOSED iter-317)
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
    -- v4.31.0 RESTORE (iter-313): the original `rw [← Category.assoc, hML]` failed because the goal's
    -- `(Over.forget (U i)).op.map φ` spelling is only DEFEQ to `hML`'s `((Over.forget (U i)).map φ.unop).op`
    -- (the `dsimp [Functor.op_map]` above no longer normalizes it).  `erw` bridges that defeq, so the
    -- whole `hML → hm → hNR` paste goes through as a single `erw`-chain; the residual is a defeq
    -- `Functor.op_map` spelling of the last `N`-leg, closed by `rfl`.
    erw [← Category.assoc, hML, Category.assoc, reassoc_of% hm, hNR, Category.assoc]
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
