/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse

/-!
# Presheaf dual pullback comparison

This file contains the Cone B declarations for the presheaf-level dual base-change
comparison `θ_M` and its immersion naturality, as ordered by the blueprint
`Picard_TensorObjSubstrate.tex`.

## Declarations

**Under `namespace PresheafOfModules`** (siblings of `dualPrecompEquiv`/`dualIsoOfIso`):
- `dualPrecompHom`: the forward leg of `dualPrecompEquiv` for an arbitrary
  morphism `g : M ⟶ M'`; contravariant functoriality of the presheaf dual.
- `dualPrecompHom_restrict_apply`: sectionwise, `(dualPrecompHom g).app U φ` equals
  `(pushforward₀ (Over.forget U)).map g ≫ φ` — near-definitional.

**Under `namespace AlgebraicGeometry.Scheme.Modules`**:
- `presheafDualPullbackComparison` (θ_M, `def:presheafdual_pullback_comparison`): the presheaf
  iso `(pullback φ).obj (dual M.val) ≅ dual ((pullback φ).obj M.val)` (Step-4 residual of
  `dual_restrict_iso`, packaged as a named iso).
- `presheafDual_pullback_comparison_eval_apply` (L1): θ_M is sectionwise the internal-hom
  evaluation `internalHomEval` reindexed across `j.opensFunctor`.
- `presheafDual_eval_restrict_commute_apply` (L3a): the eval/restrict commutation
  `φ(s)|_V = (φ|_V)(s|_V)`; independent of θ/dualPrecompHom.
- `presheafDual_pullback_restrict_natural_apply` (L3b): pointwise naturality square,
  combining L1 + L2 + L3a.
- `presheafDual_pullback_restrict_natural`: Iso-level immersion-naturality of θ,
  mirroring `presheafDualUnitIso_naturality`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

noncomputable section

-- ============================================================
-- §0. Generic mate calculus — the `leftAdjointUniq`/`leftAdjointCompIso` cocycle
-- ============================================================

namespace CategoryTheory.Adjunction

universe v₀ v₁ v₂ w₀ w₁ w₂

variable {C₀ : Type w₀} {C₁ : Type w₁} {C₂ : Type w₂}
  [Category.{v₀} C₀] [Category.{v₁} C₁] [Category.{v₂} C₂]

/-- The mate (conjugate) of a `leftAdjointUniq` comparison of two left adjoints of the *same* right
adjoint `G` is the identity of `G`.  This is the abstract content behind every `leftAdjointUniq`
cocycle: the comparison transports the unit of one adjunction to the other and is therefore mate to
`𝟙 G`.  Used to collapse the `H1` factors in `leftAdjointUniq_leftAdjointCompIso_comm`. -/
lemma conjugateEquiv_leftAdjointUniq_hom {F F' : C₀ ⥤ C₁} {G : C₁ ⥤ C₀}
    (adj1 : F ⊣ G) (adj2 : F' ⊣ G) :
    conjugateEquiv adj2 adj1 (leftAdjointUniq adj1 adj2).hom = 𝟙 G := by
  rw [leftAdjointUniq, Iso.symm_hom, conjugateIsoEquiv_symm_apply_inv, Iso.refl_inv,
    Equiv.apply_symm_apply]

variable {F₀₁ : C₀ ⥤ C₁} {F₁₂ : C₁ ⥤ C₂} {F₀₂ : C₀ ⥤ C₂}
  {G₁₀ : C₁ ⥤ C₀} {G₂₁ : C₂ ⥤ C₁} {G₂₀ : C₂ ⥤ C₀}

/-- The mate (conjugate) of the *hom* of `leftAdjointCompIso` is `e.inv` (the companion of
`conjugateEquiv_leftAdjointCompIso_inv`, which computes the conjugate of the `inv`). -/
lemma conjugateEquiv_leftAdjointCompIso_hom
    (adj₀₁ : F₀₁ ⊣ G₁₀) (adj₁₂ : F₁₂ ⊣ G₂₁) (adj₀₂ : F₀₂ ⊣ G₂₀) (e : G₂₁ ⋙ G₁₀ ≅ G₂₀) :
    conjugateEquiv adj₀₂ (adj₀₁.comp adj₁₂)
        (leftAdjointCompIso adj₀₁ adj₁₂ adj₀₂ e).hom = e.inv := by
  have hcomp : conjugateEquiv adj₀₂ (adj₀₁.comp adj₁₂)
        (leftAdjointCompIso adj₀₁ adj₁₂ adj₀₂ e).hom ≫ e.hom = 𝟙 _ := by
    conv_lhs => rw [show e.hom = conjugateEquiv (adj₀₁.comp adj₁₂) adj₀₂
      (leftAdjointCompIso adj₀₁ adj₁₂ adj₀₂ e).inv from
        (conjugateEquiv_leftAdjointCompIso_inv adj₀₁ adj₁₂ adj₀₂ e).symm]
    rw [conjugateEquiv_comp, Iso.inv_hom_id, conjugateEquiv_id]
  rw [← cancel_mono e.hom, hcomp, e.inv_hom_id]

/-- **Abstract `H1` cocycle.**  Two families of left adjoints `F•` and `P•`, sharing the right
adjoints `G••` level-by-level, and a single right-adjoint composition iso `e : G₂₁ ⋙ G₁₀ ≅ G₂₀`.
The `leftAdjointUniq` comparisons `H1 = leftAdjointUniq adjF adjP : F ≅ P` intertwine the two
`leftAdjointCompIso`s built from the *same* `e`:
`FC.hom ≫ H1₀₂.hom = (H1₀₁ ▷ F₁₂) ≫ (P₀₁ ◁ H1₁₂) ≫ PC.hom`.
This is the dual-flank analogue of the project keystone `conjugateEquiv_restrictFunctorComp_inv`:
both reduce a composite-immersion comparison to a chain over `pullbackComp`/`pushforwardComp`. -/
lemma leftAdjointUniq_leftAdjointCompIso_comm
    {P₀₁ : C₀ ⥤ C₁} {P₁₂ : C₁ ⥤ C₂} {P₀₂ : C₀ ⥤ C₂}
    (adjF01 : F₀₁ ⊣ G₁₀) (adjF12 : F₁₂ ⊣ G₂₁) (adjF02 : F₀₂ ⊣ G₂₀)
    (adjP01 : P₀₁ ⊣ G₁₀) (adjP12 : P₁₂ ⊣ G₂₁) (adjP02 : P₀₂ ⊣ G₂₀)
    (e : G₂₁ ⋙ G₁₀ ≅ G₂₀) :
    (leftAdjointCompIso adjF01 adjF12 adjF02 e).hom ≫ (leftAdjointUniq adjF02 adjP02).hom =
      Functor.whiskerRight (leftAdjointUniq adjF01 adjP01).hom F₁₂ ≫
        Functor.whiskerLeft P₀₁ (leftAdjointUniq adjF12 adjP12).hom ≫
        (leftAdjointCompIso adjP01 adjP12 adjP02 e).hom := by
  apply (conjugateEquiv adjP02 (adjF01.comp adjF12)).injective
  -- LHS mate: `FC.hom ≫ H1₀₂.hom ↦ (𝟙) ≫ e.inv = e.inv`.
  rw [← conjugateEquiv_comp adjP02 adjF02 (adjF01.comp adjF12),
    conjugateEquiv_leftAdjointUniq_hom adjF02 adjP02,
    conjugateEquiv_leftAdjointCompIso_hom, Category.id_comp]
  -- RHS mate: split the 3-fold composite, collapse the two `H1` whiskers, then `PC.hom ↦ e.inv`.
  rw [← conjugateEquiv_comp adjP02 (adjP01.comp adjF12) (adjF01.comp adjF12)
        (Functor.whiskerLeft P₀₁ (leftAdjointUniq adjF12 adjP12).hom ≫
          (leftAdjointCompIso adjP01 adjP12 adjP02 e).hom)
        (Functor.whiskerRight (leftAdjointUniq adjF01 adjP01).hom F₁₂),
    ← conjugateEquiv_comp adjP02 (adjP01.comp adjP12) (adjP01.comp adjF12)
        (leftAdjointCompIso adjP01 adjP12 adjP02 e).hom
        (Functor.whiskerLeft P₀₁ (leftAdjointUniq adjF12 adjP12).hom),
    conjugateEquiv_whiskerRight adjP01 adjF01 adjF12,
    conjugateEquiv_whiskerLeft adjP12 adjF12 adjP01,
    conjugateEquiv_leftAdjointUniq_hom adjF01 adjP01,
    conjugateEquiv_leftAdjointUniq_hom adjF12 adjP12,
    conjugateEquiv_leftAdjointCompIso_hom]
  simp

end CategoryTheory.Adjunction

-- ============================================================
-- §1. `PresheafOfModules` — morphism-level dual precomposition
-- ============================================================

namespace PresheafOfModules

open InternalHom Opposite

variable {D : Type u} [Category.{u, u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}

/-! ### Morphism-level dual transport (`dualPrecompHom`) -/

/-- Precomposition makes the presheaf dual contravariant in its module argument.
At a section `U`, `dualPrecompHom g` sends `φ` to
`(pushforward₀ (Over.forget U.unop) _).map g ≫ φ`. When `g` is the forward map
of an isomorphism, this is the forward map underlying `dualIsoOfIso`.

This is blueprint declaration `def:presheaf_dual_precomp_hom`. -/
noncomputable def dualPrecompHom
    {M M' : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)} (g : M ⟶ M') :
    dual M' ⟶ dual M where
  app U :=
    letI : Module (R₀.obj (op U.unop) : Type u) ((dual M').obj U : Type u) :=
      internalHomObjModule U.unop M'
        (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    letI : Module (R₀.obj (op U.unop) : Type u)
        ((InternalHom.internalHomPresheaf M'
          (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).obj U : Type u) :=
      internalHomObjModule U.unop M'
        (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    letI : Module (R₀.obj (op U.unop) : Type u) ((dual M).obj U : Type u) :=
      internalHomObjModule U.unop M
        (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    letI : Module (R₀.obj (op U.unop) : Type u)
        ((InternalHom.internalHomPresheaf M
          (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).obj U : Type u) :=
      internalHomObjModule U.unop M
        (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    ModuleCat.ofHom (R := (R₀.obj (op U.unop) : Type u))
      ({ toFun := fun φ =>
          (PresheafOfModules.pushforward₀ (Over.forget U.unop)
            (R₀ ⋙ forget₂ CommRingCat RingCat)).map g ≫ φ
         map_add' := fun φ ψ => Preadditive.comp_add _ _ _ _ φ ψ
         map_smul' := fun r φ => by
           simp only [RingHom.id_apply]
           exact (Category.assoc _ _ _).symm } :
        ((dual M').obj U : Type u) →ₗ[(R₀.obj (op U.unop) : Type u)] ((dual M).obj U : Type u))
  naturality {U U'} f := by
    -- Naturality of `dualPrecompHom`: precomposition by `g` commutes with the slice
    -- restriction maps of the dual (`restrictionMap`).  Same square that `isoMk` discharges
    -- by default for `dualIsoOfIso`, so `cat_disch` should close it.
    cat_disch

/-- Sectionwise, `dualPrecompHom g` is precomposition by the pushforward of `g` to
the slice over `U`. This is blueprint lemma `lem:dual_precomp_hom_restrict_apply`. -/
lemma dualPrecompHom_restrict_apply
    {M M' : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)} (g : M ⟶ M')
    (U : Dᵒᵖ) (φ : (dual M').obj U) :
    letI := internalHomObjModule U.unop M'
      (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    letI := internalHomObjModule U.unop M
      (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    (dualPrecompHom g).app U φ =
      (PresheafOfModules.pushforward₀ (Over.forget U.unop)
        (R₀ ⋙ forget₂ CommRingCat RingCat)).map g ≫ φ :=
  rfl

/-- Local re-statement of the (root-file `private`) sectionwise value of the
`pushforwardPushforwardAdj` unit; the body is `rfl`, so it re-derives here.  The unit, on a
section at `U`, is the presheaf restriction map of `M` along `adj.counit`. -/
lemma ppadj_unit_app_app_apply
    {A : Type u} [Category.{u} A] {B : Type u} [Category.{u} B]
    {F : A ⥤ B} {G : B ⥤ A} {S : Aᵒᵖ ⥤ RingCat.{u}} {Rr : Bᵒᵖ ⥤ RingCat.{u}}
    (adj : F ⊣ G) (φ : S ⟶ F.op ⋙ Rr) (ψ : Rr ⟶ G.op ⋙ S)
    (H₁ : Functor.whiskerRight (NatTrans.op adj.counit) Rr = ψ ≫ G.op.whiskerLeft φ)
    (H₂ : φ ≫ F.op.whiskerLeft ψ ≫ Functor.whiskerRight (NatTrans.op adj.unit) S = 𝟙 S)
    (M : _root_.PresheafOfModules Rr) (U : Bᵒᵖ) (x : M.obj U) :
    (((PresheafOfModules.pushforwardPushforwardAdj adj φ ψ H₁ H₂).unit.app M).app U).hom x
      = (M.map (adj.counit.app U.unop).op).hom x := rfl

/-- Local re-statement of the (root-file `private`) sectionwise value of the
`pushforwardPushforwardAdj` counit; the body is `rfl`.  The counit, on a section at `U`, is the
presheaf restriction map of `N` along `adj.unit`. -/
lemma ppadj_counit_app_app_apply
    {A : Type u} [Category.{u} A] {B : Type u} [Category.{u} B]
    {F : A ⥤ B} {G : B ⥤ A} {S : Aᵒᵖ ⥤ RingCat.{u}} {Rr : Bᵒᵖ ⥤ RingCat.{u}}
    (adj : F ⊣ G) (φ : S ⟶ F.op ⋙ Rr) (ψ : Rr ⟶ G.op ⋙ S)
    (H₁ : Functor.whiskerRight (NatTrans.op adj.counit) Rr = ψ ≫ G.op.whiskerLeft φ)
    (H₂ : φ ≫ F.op.whiskerLeft ψ ≫ Functor.whiskerRight (NatTrans.op adj.unit) S = 𝟙 S)
    (N : _root_.PresheafOfModules S) (U : Aᵒᵖ)
    (y : ((PresheafOfModules.pushforward ψ ⋙ PresheafOfModules.pushforward φ).obj N).obj U) :
    (((PresheafOfModules.pushforwardPushforwardAdj adj φ ψ H₁ H₂).counit.app N).app U).hom y
      = (N.map (adj.unit.app U.unop).op).hom y := rfl

/-- **Sectionwise value of the presheaf-dual restriction map.**  For `g : U ⟶ U'` in `Dᵒᵖ` and a
dual section `φ : (dual M).obj U`, evaluating the restricted section `(dual M).map g φ` at a slice
object `W₀` of `Over U'.unop` is `φ` evaluated at the `Over.map`-reindexed slice.  `rfl` via
`ofPresheaf_map` turns `internalHomPresheaf.map` into
`(pushforward₀ (Over.map g.unop)).map`, whose component is `φ.app (F.op.obj ·)`.
This reduces the dual-restriction composite in
`presheafDualPullbackComparison_restrict` to evaluation by `φ`. -/
lemma dual_map_app_apply {U U' : Dᵒᵖ} (g : U ⟶ U')
    (M : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))
    (φ : ((dual M).obj U : Type u))
    (W₀ : (Over (unop U'))ᵒᵖ) :
    (((dual M).map g).hom φ).app W₀ = φ.app ((Over.map g.unop).op.obj W₀) := rfl

end PresheafOfModules

-- ============================================================
-- §2. `AlgebraicGeometry.Scheme.Modules` — θ_M and naturality
-- ============================================================

namespace AlgebraicGeometry

open Opposite

namespace Scheme

namespace Modules

/-- The presheaf-level dual pullback comparison for an open immersion.
The adjunction-uniqueness isomorphism identifies pullback with the relevant
pushforward, after which `sliceDualTransport` compares the duals sectionwise.

This is blueprint declaration `def:presheafdual_pullback_comparison`. -/
noncomputable def presheafDualPullbackComparison {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    let φR := (Scheme.Hom.toRingCatSheafHom f).hom
    let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv
        naturality := fun _ _ i => f.appIso_inv_naturality i }
    let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    (PresheafOfModules.pullback φR).obj (PresheafOfModules.dual (R₀ := X.presheaf) M.val) ≅
    PresheafOfModules.dual (R₀ := Y.presheaf)
      ((PresheafOfModules.pushforward β).obj M.val) := by
  -- Rebuild the local context from `dual_restrict_iso` Step 4.
  let φR := (Scheme.Hom.toRingCatSheafHom f).hom
  let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
    { app := fun U => (f.appIso U.unop).inv
      naturality := fun _ _ i => f.appIso_inv_naturality i }
  let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight α (forget₂ CommRingCat RingCat)
  have hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φR :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φR
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let H1 := hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)
  -- Verbatim Step-4 body (known to compile in the `dual_restrict_iso` context):
  exact (H1.app (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).symm ≪≫
    PresheafOfModules.isoMk (fun V => sliceDualTransport f M V)
      (by intro V W g; subsingleton)

/-- The sectionwise evaluation formula for `sliceDualTransport`, the forward leg of
`presheafDualPullbackComparison`. Evaluation after transport is evaluation before
transport followed by the structure-ring isomorphism of the open immersion.

This is blueprint lemma `lem:presheafdual_pullback_comparison_eval_apply`. -/
lemma presheafDual_pullback_comparison_eval_apply {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules)
    (V : (TopologicalSpace.Opens Y)ᵒᵖ)
    (φ : letI α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv
             naturality := fun _ _ i => f.appIso_inv_naturality i }
         letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
           Functor.whiskerRight α (forget₂ CommRingCat RingCat)
         (((PresheafOfModules.pushforward β).obj
            (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).obj V))
    (s : letI α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv
             naturality := fun _ _ i => f.appIso_inv_naturality i }
         letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
           Functor.whiskerRight α (forget₂ CommRingCat RingCat)
         (((PresheafOfModules.pushforward β).obj M.val).obj V)) :
    -- The load-bearing leg of `θ` (`sliceDualTransport`, which assembles the `isoMk` factor of
    -- `presheafDualPullbackComparison`) acts sectionwise as the internal-hom evaluation of `φ`
    -- reindexed across `f.opensFunctor`: on `(pushforward β _).obj V` (definitionally
    -- `(dual M.val).obj (op fV)` resp. `M.val.obj (op fV)`), evaluating the transported section at
    -- `s` recovers `evalLin M.val (op fV) φ s`. This is the pushforward-side core;
    -- `pullback φR` form rides on the H1 adjunction-uniqueness leg.
    letI α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv
        naturality := fun _ _ i => f.appIso_inv_naturality i }
    letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    PresheafOfModules.evalLin ((PresheafOfModules.pushforward β).obj M.val) V
        ((sliceDualTransport f M V).hom φ) s
      = (Scheme.Hom.appIso f V.unop).hom.hom
          (PresheafOfModules.evalLin M.val (op (f.opensFunctor.obj V.unop)) φ s) := by
  -- The forward `sliceDualTransport` app at the terminal slice is, by the def,
  -- `(restrictScalars β_V).map (φ.app (op (Over.mk 𝟙))) ≫ dualUnitRingSwap f V.unop`; evaluating at
  -- `s` and rewriting the swap via `dualUnitRingSwap_apply` (= `(appIso).hom.hom`) gives the RHS.
  -- The first rewrite exposes the codomain swap; the second identifies its carrier
  -- map with `(appIso f V.unop).hom.hom`.
  unfold PresheafOfModules.evalLin
  erw [sliceDualTransport_app_apply f M V φ (Opposite.op (Over.mk (𝟙 V.unop))) s,
    dualUnitRingSwap_apply]
  rfl

/-- **Generic eval/restrict commutation** (the abstract core of L3a, stated over a *variable*
presheaf of modules `N`).  It is the naturality of `internalHomEval N` at `j.op` read off the
simple tensor `s ⊗ₜ φ`. -/
private lemma evalLin_restrict_commute_aux {D : Type u} [Category.{u, u} D]
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}
    (N : _root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) {U V : D} (j : V ⟶ U)
    (φ : (PresheafOfModules.dual N).obj (op U)) (s : (N.obj (op U) : Type u)) :
    ((R₀ ⋙ forget₂ CommRingCat RingCat).map j.op).hom
        (PresheafOfModules.evalLin N (op U) φ s)
      = PresheafOfModules.evalLin N (op V)
          ((PresheafOfModules.dual N).map j.op φ) (N.map j.op s) :=
  (PresheafOfModules.naturality_apply (PresheafOfModules.internalHomEval N) j.op
    (s ⊗ₜ[(R₀.obj (op U) : Type u)] φ)).symm

/-- Evaluation of a dual section commutes with restriction along an inclusion of
opens. This is the pullback specialization of `evalLin_restrict_commute_aux` and
blueprint lemma `lem:presheafdual_eval_restrict_commute_apply`. -/
lemma presheafDual_eval_restrict_commute_apply {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules)
    {U V : TopologicalSpace.Opens Y} (j : V ≤ U)
    (φ : (PresheafOfModules.dual (R₀ := Y.presheaf)
        ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj M.val)).obj
        (Opposite.op U))
    (s : ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj M.val).obj
        (Opposite.op U)) :
    letI N := (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj M.val
    -- Restricting the eval value `evalLin N (op U) φ s` along `j` (the ring/unit restriction map
    -- `Y.presheaf ⋙ forget₂`) equals evaluating the restricted dual section `(dual N).map j.op φ`
    -- at the restricted argument `N.map j.op s`.
    ((Y.presheaf ⋙ forget₂ CommRingCat RingCat).map (homOfLE j).op).hom
        (PresheafOfModules.evalLin N (Opposite.op U) φ s)
      = PresheafOfModules.evalLin N (Opposite.op V)
          ((PresheafOfModules.dual (R₀ := Y.presheaf) N).map (homOfLE j).op φ)
          (N.map (homOfLE j).op s) :=
  -- Instantiate the generic eval/restrict commutation at `N = (pullback φR).obj M.val`,
  -- `j = homOfLE j`.  The heavy `pullback`-object only appears as the *argument* (never whnf-ed),
  -- so this avoids the `isDefEq` heartbeat bomb of the inline form.
  evalLin_restrict_commute_aux
    ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj M.val)
    (homOfLE j) φ s

/-- Pointwise naturality of `presheafDualPullbackComparison` under restriction from
`U` to `V`. Both sides evaluate the dual sections related by the naturality square
of its forward map. This is blueprint lemma
`lem:presheafdual_pullback_restrict_natural_apply`. -/
lemma presheafDual_pullback_restrict_natural_apply {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules)
    {U V : TopologicalSpace.Opens Y} (j : V ≤ U)
    (φ : ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj
        (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).obj (Opposite.op U))
    (s : (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
            { app := fun U => (f.appIso U.unop).inv
              naturality := fun _ _ i => f.appIso_inv_naturality i }
          let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
            Functor.whiskerRight α (forget₂ CommRingCat RingCat)
          (PresheafOfModules.pushforward β).obj M.val).obj (Opposite.op V)) :
    PresheafOfModules.evalLin
        (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv
             naturality := fun _ _ i => f.appIso_inv_naturality i }
         let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
           Functor.whiskerRight α (forget₂ CommRingCat RingCat)
         (PresheafOfModules.pushforward β).obj M.val)
        (Opposite.op V)
        -- target side: θ applied then restricted
        ((presheafDualPullbackComparison f M).hom.app (Opposite.op V)
            ((PresheafOfModules.pullback
                (Scheme.Hom.toRingCatSheafHom f).hom).obj
              (PresheafOfModules.dual (R₀ := X.presheaf) M.val) |>.map (homOfLE j).op φ))
        s
      = PresheafOfModules.evalLin
          (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
             { app := fun U => (f.appIso U.unop).inv
               naturality := fun _ _ i => f.appIso_inv_naturality i }
           let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
             Functor.whiskerRight α (forget₂ CommRingCat RingCat)
           (PresheafOfModules.pushforward β).obj M.val)
          (Opposite.op V)
          -- source side: θ applied at U, then the dual section restricted along `j`
          ((PresheafOfModules.dual (R₀ := Y.presheaf)
              ((let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
                  { app := fun U => (f.appIso U.unop).inv
                    naturality := fun _ _ i => f.appIso_inv_naturality i }
                let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
                  Functor.whiskerRight α (forget₂ CommRingCat RingCat)
                (PresheafOfModules.pushforward β).obj M.val))).map (homOfLE j).op
            ((presheafDualPullbackComparison f M).hom.app (Opposite.op U) φ))
          s :=
  -- Both sides evaluate, at `s`, the two dual sections related by the naturality square of `θ.hom`:
  -- `θ.app (op V) (source.map j.op φ) = (dual _).map j.op (θ.app (op U) φ)`.
  congrArg
    (fun ψ => PresheafOfModules.evalLin
      (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
         { app := fun U => (f.appIso U.unop).inv
           naturality := fun _ _ i => f.appIso_inv_naturality i }
       let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
         Functor.whiskerRight α (forget₂ CommRingCat RingCat)
       (PresheafOfModules.pushforward β).obj M.val)
      (Opposite.op V) ψ s)
    (PresheafOfModules.naturality_apply (presheafDualPullbackComparison f M).hom
      (homOfLE j).op φ)

/-- Naturality of the forward map of `presheafDualPullbackComparison` under an
inclusion of opens. This exposes the ordinary presheaf naturality square in the
form used by the dual pullback construction. -/
lemma presheafDual_pullback_restrict_natural {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules)
    {U V : TopologicalSpace.Opens Y} (j : V ≤ U) :
    (presheafDualPullbackComparison f M).hom.app (Opposite.op V) ∘
      ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj
        (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).map (homOfLE j).op
    = (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
         { app := fun U => (f.appIso U.unop).inv
           naturality := fun _ _ i => f.appIso_inv_naturality i }
       let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
         Functor.whiskerRight α (forget₂ CommRingCat RingCat)
       (PresheafOfModules.dual (R₀ := Y.presheaf) ((PresheafOfModules.pushforward β).obj M.val)).map
         (homOfLE j).op) ∘
      (presheafDualPullbackComparison f M).hom.app (Opposite.op U) := by
  -- This is the built-in naturality of
  -- `θ.hom = (presheafDualPullbackComparison f M).hom`,
  -- which is a genuine `PresheafOfModules.Hom`, hence natural by construction.  Pointwise this is
  -- `PresheafOfModules.naturality_apply θ.hom (homOfLE j).op`.
  funext φ
  exact PresheafOfModules.naturality_apply (presheafDualPullbackComparison f M).hom
    (homOfLE j).op φ

/-- The presheaf underlying `M.restrict f` is definitionally the pushforward of
`M.val` along the inverse structure-ring comparison. The abstract comparison in
blueprint declaration `def:pushforward_obj_val_restrict_iso` therefore reduces to
the identity isomorphism. -/
noncomputable def pushforwardObjValRestrictIso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv
        naturality := fun _ _ i => f.appIso_inv_naturality i }
    let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    (PresheafOfModules.pushforward β).obj M.val ≅ (M.restrict f).val :=
  Iso.refl _

/-- The adjunction-uniqueness comparison for a composite open immersion factors
through the comparisons for its two factors. This is the dual-side `H1` cocycle
from blueprint lemma `lem:presheafdual_h1_cocycle`, obtained by instantiating
`Adjunction.leftAdjointUniq_leftAdjointCompIso_comm`. -/
lemma presheafDualH1Cocycle {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    [IsOpenImmersion h] [IsOpenImmersion f] :
    let φRf := (Scheme.Hom.toRingCatSheafHom f).hom
    let αf : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv
        naturality := fun _ _ i => f.appIso_inv_naturality i }
    let βf : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight αf (forget₂ CommRingCat RingCat)
    let φRh := (Scheme.Hom.toRingCatSheafHom h).hom
    let αh : Z.presheaf ⟶ h.opensFunctor.op ⋙ Y.presheaf :=
      { app := fun U => (h.appIso U.unop).inv
        naturality := fun _ _ i => h.appIso_inv_naturality i }
    let βh : Z.ringCatSheaf.obj ⟶ h.opensFunctor.op ⋙ Y.ringCatSheaf.obj :=
      Functor.whiskerRight αh (forget₂ CommRingCat RingCat)
    let φRhf := (Scheme.Hom.toRingCatSheafHom (h ≫ f)).hom
    let αhf : Z.presheaf ⟶ (h ≫ f).opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => ((h ≫ f).appIso U.unop).inv
        naturality := fun _ _ i => (h ≫ f).appIso_inv_naturality i }
    let βhf : Z.ringCatSheaf.obj ⟶ (h ≫ f).opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight αhf (forget₂ CommRingCat RingCat)
    ∀ (hadjf : PresheafOfModules.pushforward βf ⊣ PresheafOfModules.pushforward φRf)
      (hadjh : PresheafOfModules.pushforward βh ⊣ PresheafOfModules.pushforward φRh)
      (hadjhf : PresheafOfModules.pushforward βhf ⊣ PresheafOfModules.pushforward φRhf),
    (Adjunction.leftAdjointCompIso hadjf hadjh hadjhf
        (PresheafOfModules.pushforwardComp φRf φRh)).hom ≫
      (hadjhf.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φRhf)).hom =
    Functor.whiskerRight
        (hadjf.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φRf)).hom
        (PresheafOfModules.pushforward βh) ≫
      Functor.whiskerLeft (PresheafOfModules.pullback φRf)
        (hadjh.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φRh)).hom ≫
      (PresheafOfModules.pullbackComp φRf φRh).hom := by
  intro φRf αf βf φRh αh βh φRhf αhf βhf hadjf hadjh hadjhf
  exact Adjunction.leftAdjointUniq_leftAdjointCompIso_comm hadjf hadjh hadjhf
    (PresheafOfModules.pullbackPushforwardAdjunction φRf)
    (PresheafOfModules.pullbackPushforwardAdjunction φRh)
    (PresheafOfModules.pullbackPushforwardAdjunction φRhf)
    (PresheafOfModules.pushforwardComp φRf φRh)

/-- The category-theoretic cancellation skeleton used in the composition proof.
Keeping it over one abstract category lets associativity, naturality, and the four
isomorphism cancellations proceed without exposing implementation-specific
category instances of the presheaf module category. -/
private lemma c2_assemble {C : Type*} [Category C]
    {A1 A2 A3 A4 A5 A6 A7 A8 A9 : C}
    (aHinv : A1 ⟶ A2) (aH : A2 ⟶ A1) (s : A2 ⟶ A3)
    (fc : A4 ⟶ A2) (fcinv : A2 ⟶ A4)
    (p0 : A1 ⟶ A5) (pc : A5 ⟶ A1)
    (phf : A4 ⟶ A6) (hh : A6 ⟶ A5) (Pfhif : A5 ⟶ A7)
    (Hhinv : A7 ⟶ A8) (sDTh : A8 ⟶ A9) (p3 : A9 ⟶ A3)
    (pushSDTf : A4 ⟶ A8) (Pushhif : A6 ⟶ A8) (hhdmf : A8 ⟶ A7)
    (h_aHinv : aHinv ≫ aH = 𝟙 A1)
    (h_fcinv : fcinv ≫ fc = 𝟙 A2)
    (hcoc : fc ≫ aH = phf ≫ hh ≫ pc)
    (h_pc : pc ≫ p0 = 𝟙 A5)
    (hnat : hh ≫ Pfhif = Pushhif ≫ hhdmf)
    (hfold : phf ≫ Pushhif = pushSDTf)
    (h_hh2 : hhdmf ≫ Hhinv = 𝟙 A8)
    (hstar : fc ≫ s = pushSDTf ≫ sDTh ≫ p3) :
    aHinv ≫ s = p0 ≫ Pfhif ≫ (Hhinv ≫ sDTh) ≫ p3 := by
  have key : fc ≫ aH ≫ p0 ≫ Pfhif ≫ (Hhinv ≫ sDTh) ≫ p3 = fc ≫ s := by
    rw [hstar, ← Category.assoc fc aH, hcoc]
    simp only [Category.assoc]
    rw [← Category.assoc pc p0, h_pc, Category.id_comp,
        ← Category.assoc hh Pfhif, hnat]
    simp only [Category.assoc]
    rw [← Category.assoc hhdmf Hhinv, h_hh2, Category.id_comp,
        ← Category.assoc phf Pushhif, hfold]
  have hX : aH ≫ p0 ≫ Pfhif ≫ (Hhinv ≫ sDTh) ≫ p3 = s := by
    have h2 := congrArg (fcinv ≫ ·) key
    simp only [← Category.assoc, h_fcinv, Category.id_comp] at h2
    simpa using h2
  rw [← hX, ← Category.assoc aHinv aH, h_aHinv, Category.id_comp]

open PresheafOfModules InternalHom Opposite in
/-- Naturality of a dual section along a morphism in the thin slice category over
`base`. The slice objects are implicit so the composition proof can infer them
from the two evaluations of `φ`. -/
private lemma hstar_naturality {X : Scheme.{u}} (M : X.Modules)
    {base : TopologicalSpace.Opens ↥X}
    (φ : restr base M.val ⟶
         restr base
           (𝟙_ (_root_.PresheafOfModules.{u} (X.presheaf ⋙ forget₂ CommRingCat RingCat))))
    {A B : (Over base)ᵒᵖ} (g : A ⟶ B)
    (z : ((restr base M.val).obj A : Type u)) :
    (ModuleCat.Hom.hom
        ((restr base
            (𝟙_ (_root_.PresheafOfModules.{u} (X.presheaf ⋙ forget₂ CommRingCat RingCat)))).map g))
        (ModuleCat.Hom.hom (φ.app A) z)
      = (ModuleCat.Hom.hom (φ.app B))
          (ModuleCat.Hom.hom ((restr base M.val).map g) z) :=
  (PresheafOfModules.naturality_apply φ g z).symm

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 12800000 in
-- Expanding three adjunction comparisons creates a deep but terminating defeq problem.
/-- Composition law for `presheafDualPullbackComparison`, dual to
`pullbackTensorMap_restrict`. The comparison for `h ≫ f` factors through
`pullbackComp`, the comparisons for `f` and `h`, and the dual of
`restrictFunctorComp`. This is blueprint lemma
`lem:presheafdual_pullback_comparison_restrict`. -/
lemma presheafDualPullbackComparison_restrict {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    [IsOpenImmersion h] [IsOpenImmersion f] (M : X.Modules) :
    presheafDualPullbackComparison (h ≫ f) M =
      (PresheafOfModules.pullbackComp (Scheme.Hom.toRingCatSheafHom f).hom
          (Scheme.Hom.toRingCatSheafHom h).hom).symm.app
            (PresheafOfModules.dual (R₀ := X.presheaf) M.val)
      ≪≫ (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom h).hom).mapIso
            (presheafDualPullbackComparison f M)
      ≪≫ presheafDualPullbackComparison h (M.restrict f)
      ≪≫ PresheafOfModules.dualIsoOfIso
            ((SheafOfModules.forget Z.ringCatSheaf).mapIso
              ((Scheme.Modules.restrictFunctorComp h f).app M)) := by
  -- Reduce to the forward natural transformations and expose the three comparisons.
  apply Iso.ext
  simp only [presheafDualPullbackComparison, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
  -- Reconstruct the three adjunctions used by the comparison definitions.
  let hadjf : PresheafOfModules.pushforward
        (Functor.whiskerRight
          ({ app := fun U => (f.appIso U.unop).inv
             naturality := fun _ _ i => f.appIso_inv_naturality i } :
          Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf) (forget₂ CommRingCat RingCat)) ⊣
      PresheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom f).hom :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction _ _
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let hadjh : PresheafOfModules.pushforward
        (Functor.whiskerRight
          ({ app := fun U => (h.appIso U.unop).inv
             naturality := fun _ _ i => h.appIso_inv_naturality i } :
          Z.presheaf ⟶ h.opensFunctor.op ⋙ Y.presheaf) (forget₂ CommRingCat RingCat)) ⊣
      PresheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom h).hom :=
    PresheafOfModules.pushforwardPushforwardAdj h.isOpenEmbedding.isOpenMap.adjunction _ _
      (by ext U x; exact congr($((h.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(h.appIso_inv_app_presheafMap U.unop) x))
  let αhf : Z.presheaf ⟶ (h ≫ f).opensFunctor.op ⋙ X.presheaf :=
    { app := fun U => ((h ≫ f).appIso U.unop).inv
      naturality := fun _ _ i => (h ≫ f).appIso_inv_naturality i }
  let hadjhf : PresheafOfModules.pushforward
        (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat)) ⊣
      PresheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom (h ≫ f)).hom :=
    PresheafOfModules.pushforwardPushforwardAdj (h ≫ f).isOpenEmbedding.isOpenMap.adjunction _ _
      (by ext U x; exact congr($(((h ≫ f).app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($((h ≫ f).appIso_inv_app_presheafMap U.unop) x))
  have hcoc := presheafDualH1Cocycle h f hadjf hadjh hadjhf
  -- Package the H1 cancellations with `c2_assemble`; only the sectionwise
  -- `sliceDualTransport` compatibility remains in `hstar`.
  let βh : Z.ringCatSheaf.obj ⟶ (Hom.opensFunctor h).op ⋙ Y.ringCatSheaf.obj :=
    Functor.whiskerRight
      ({ app := fun U => (h.appIso U.unop).inv
         naturality := fun _ _ i => h.appIso_inv_naturality i } :
        Z.presheaf ⟶ (Hom.opensFunctor h).op ⋙ Y.presheaf)
      (forget₂ CommRingCat RingCat)
  let βf : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight
      ({ app := fun U => (f.appIso U.unop).inv
         naturality := fun _ _ i => f.appIso_inv_naturality i } :
        Y.presheaf ⟶ (Hom.opensFunctor f).op ⋙ X.presheaf)
      (forget₂ CommRingCat RingCat)
  let H1hf := hadjhf.leftAdjointUniq
    (PresheafOfModules.pullbackPushforwardAdjunction (Scheme.Hom.toRingCatSheafHom (h ≫ f)).hom)
  let H1f := hadjf.leftAdjointUniq
    (PresheafOfModules.pullbackPushforwardAdjunction (Scheme.Hom.toRingCatSheafHom f).hom)
  let H1h := hadjh.leftAdjointUniq
    (PresheafOfModules.pullbackPushforwardAdjunction (Scheme.Hom.toRingCatSheafHom h).hom)
  let FC := hadjf.leftAdjointCompIso hadjh hadjhf
    (PresheafOfModules.pushforwardComp (Scheme.Hom.toRingCatSheafHom f).hom
      (Scheme.Hom.toRingCatSheafHom h).hom)
  let pbC := PresheafOfModules.pullbackComp (Scheme.Hom.toRingCatSheafHom f).hom
    (Scheme.Hom.toRingCatSheafHom h).hom
  let iMf := PresheafOfModules.isoMk (fun V => sliceDualTransport f M V)
    (by intro V W g; subsingleton)
  let gf := (H1f.app M.val.dual).inv ≫ iMf.hom
  refine c2_assemble
    (aHinv := (H1hf.app M.val.dual).inv) (aH := (H1hf.app M.val.dual).hom)
    (s := (PresheafOfModules.isoMk (fun V => sliceDualTransport (h ≫ f) M V)
      (by intro V W g; subsingleton)).hom)
    (fc := FC.hom.app M.val.dual) (fcinv := FC.inv.app M.val.dual)
    (p0 := (pbC.symm.app M.val.dual).hom) (pc := pbC.hom.app M.val.dual)
    (phf := (PresheafOfModules.pushforward βh).map (H1f.hom.app M.val.dual))
    (hh := H1h.hom.app
      ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj M.val.dual))
    (Pfhif := (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom h).hom).map gf)
    (Hhinv := (H1h.app (M.restrict f).val.dual).inv)
    (sDTh := (PresheafOfModules.isoMk (fun V => sliceDualTransport h (M.restrict f) V)
      (by intro V W g; subsingleton)).hom)
    (p3 := (PresheafOfModules.dualIsoOfIso
      ((SheafOfModules.forget Z.ringCatSheaf).mapIso ((restrictFunctorComp h f).app M))).hom)
    (pushSDTf := (PresheafOfModules.pushforward βh).map iMf.hom)
    (Pushhif := (PresheafOfModules.pushforward βh).map gf)
    (hhdmf := H1h.hom.app (M.restrict f).val.dual)
    (h_aHinv := (H1hf.app M.val.dual).inv_hom_id)
    (h_fcinv := FC.inv_hom_id_app M.val.dual)
    (hcoc := NatTrans.congr_app hcoc M.val.dual)
    (h_pc := pbC.hom_inv_id_app M.val.dual)
    (hnat := (H1h.hom.naturality gf).symm)
    (hfold := ?hfold)
    (h_hh2 := H1h.hom_inv_id_app (M.restrict f).val.dual)
    (hstar := ?hstar)
  case hfold =>
    rw [← Functor.map_comp]
    refine congrArg (PresheafOfModules.pushforward βh).map ?_
    change H1f.hom.app M.val.dual ≫ gf = iMf.hom
    rw [← Category.assoc, show H1f.hom.app M.val.dual ≫ (H1f.app M.val.dual).inv = 𝟙 _ from
      (H1f.app M.val.dual).hom_inv_id, Category.id_comp]
  case hstar =>
    -- Prove the remaining pushforward-side compatibility sectionwise.
    apply PresheafOfModules.hom_ext
    intro V
    apply ModuleCat.hom_ext
    apply LinearMap.ext
    intro φ
    apply PresheafOfModules.hom_ext
    intro W
    apply ModuleCat.hom_ext
    apply LinearMap.ext
    intro z
    simp only [PresheafOfModules.comp_app, PresheafOfModules.isoMk_hom_app,
      ModuleCat.hom_comp, LinearMap.comp_apply]
    erw [sliceDualTransport_app_apply (h ≫ f) M V ((FC.hom.app M.val.dual).app V φ) W z]
    rw [dualUnitRingSwap_apply]
    -- RHS: reduce the inner pushforward.map + isoMk to `sliceDualTransport f M hV`
    erw [PresheafOfModules.pushforward_map_app_apply βh iMf.hom V φ]
    simp only [iMf, PresheafOfModules.isoMk_hom_app]
    -- LHS: split the composite structure-ring iso via the `appIso` cocycle `comp_appIso`,
    -- so the leading `(h ≫ f).appIso` matches the nested `h.appIso ∘ f.appIso` of the RHS.
    rw [Scheme.Hom.comp_appIso h f (unop W).left]
    simp only [Iso.trans_hom, CommRingCat.hom_comp, RingHom.comp_apply, Functor.mapIso_hom]
    -- RHS: reduce `dualIsoOfIso` (precomposition by the reindexed `rfc.hom`) and the two
    -- `sliceDualTransport`s to their `dualUnitRingSwap`/`appIso` forms.
    erw [sliceDualTransport_app_apply h (M.restrict f) V _ W]
    rw [dualUnitRingSwap_apply]
    erw [sliceDualTransport_app_apply f M (op ((Hom.opensFunctor h).obj (unop V))) φ
      (op (Over.mk ((Hom.opensFunctor h).map (unop W).hom)))]
    rw [dualUnitRingSwap_apply]
    -- cancel the two now-matching structure-ring iso layers (`h.appIso`, then `f.appIso`)
    refine congrArg (Hom.appIso h (unop W).left).hom.hom ?_
    refine congrArg (Hom.appIso f ((Hom.opensFunctor h).obj (unop W).left)).hom.hom ?_
    -- Expand the composition comparison into its unit and counit factors. After
    -- this reduction, the goal is naturality of `φ` in a thin slice category.
    simp only [FC]
    rw [Adjunction.leftAdjointCompIso_hom_app]
    -- Sectionwise reduction of `(FC.hom.app dM).app V φ`:
    --   * `pushforwardComp = Iso.refl` ⇒ the middle `e.inv` factor collapses to `𝟙`;
    --   * distribute `.app V` over the composite to a function composition.
    simp only [PresheafOfModules.pushforwardComp, Iso.refl_inv, NatTrans.id_app,
      PresheafOfModules.comp_app, ModuleCat.hom_comp, LinearMap.comp_apply]
    -- Peel the two `pushforward.map` wrappers of the `unit` factor (T1) with EXPLICIT args —
    -- the codebase pattern (cf. L868) that avoids the `restrictScalars` carrier-diamond `whnf`
    -- bomb that bare `erw`/`simp` matching triggers.
    erw [PresheafOfModules.pushforward_map_app_apply βh
          ((PresheafOfModules.pushforward βf).map (hadjhf.unit.app M.val.dual)) V φ,
        PresheafOfModules.pushforward_map_app_apply βf (hadjhf.unit.app M.val.dual)
          (op ((Hom.opensFunctor h).obj (unop V))) φ]
    -- peel the single `pushforward.map` wrapper of the `counit_f` factor (T3), explicit args.
    erw [PresheafOfModules.pushforward_map_app_apply βh
          (hadjf.counit.app ((PresheafOfModules.pushforward (Hom.toRingCatSheafHom h).hom).obj
            ((PresheafOfModules.pushforward
              (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj M.val.dual))) V _]
    -- expose `pushforwardPushforwardAdj` from the `let`s, then reduce the three unit/counit
    -- factors to presheaf restriction maps of the dual via the local `rfl` value lemmas
    -- (explicit `adj` anchors the counit higher-order unification).
    simp only [hadjf, hadjh, hadjhf]
    -- Reduce the three unit/counit factors to dual restriction maps. The value lemmas are `rfl`,
    -- but both `rw` (coercion-form mismatch `ConcreteCategory.hom`/`ModuleCat.Hom.hom`) and bare
    -- `erw` (carrier-diamond `whnf` bomb) fail; give FULLY EXPLICIT anchoring args so `erw`
    -- matching is cheap (the codebase pattern).
    erw [PresheafOfModules.ppadj_unit_app_app_apply
          (adj := (h ≫ f).isOpenEmbedding.isOpenMap.adjunction)
          (φ := Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))
          (ψ := (Hom.toRingCatSheafHom (h ≫ f)).hom) (M := M.val.dual)
          (U := op ((Hom.opensFunctor f).obj ((Hom.opensFunctor h).obj (unop V))))]
    erw [PresheafOfModules.ppadj_counit_app_app_apply
          (adj := f.isOpenEmbedding.isOpenMap.adjunction) (φ := βf)
          (ψ := (Hom.toRingCatSheafHom f).hom)
          (N := (PresheafOfModules.pushforward (Hom.toRingCatSheafHom h).hom).obj
            ((PresheafOfModules.pushforward
              (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj M.val.dual))
          (U := op ((Hom.opensFunctor h).obj (unop V)))]
    erw [PresheafOfModules.ppadj_counit_app_app_apply
          (adj := h.isOpenEmbedding.isOpenMap.adjunction) (φ := βh)
          (ψ := (Hom.toRingCatSheafHom h).hom)
          (N := (PresheafOfModules.pushforward
            (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj M.val.dual)
          (U := V)]
    -- Reduce the two pushforward-object restriction maps `N.map` to `M.val.dual.map` (`rfl`).
    erw [PresheafOfModules.pushforward_obj_map_apply
          (φ := Functor.whiskerRight αhf (forget₂ CommRingCat RingCat)) (M := M.val.dual)
          (f := (h.isOpenEmbedding.isOpenMap.adjunction.unit.app (unop V)).op)]
    erw [PresheafOfModules.pushforward_obj_map_apply (φ := (Hom.toRingCatSheafHom h).hom)
          (M := (PresheafOfModules.pushforward
            (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj M.val.dual)
          (f := (f.isOpenEmbedding.isOpenMap.adjunction.unit.app
            (unop (op ((Hom.opensFunctor h).obj (unop V))))).op)]
    erw [PresheafOfModules.pushforward_obj_map_apply
          (φ := Functor.whiskerRight αhf (forget₂ CommRingCat RingCat)) (M := M.val.dual)
          (f := ((TopologicalSpace.Opens.map h.base).map
            (f.isOpenEmbedding.isOpenMap.adjunction.unit.app
              (unop (op ((Hom.opensFunctor h).obj (unop V))))).op.unop).op)]
    -- Reduce the three dual restrictions to one evaluation of `φ` at the
    -- corresponding reindexed slice object.
    erw [PresheafOfModules.dual_map_app_apply, PresheafOfModules.dual_map_app_apply,
      PresheafOfModules.dual_map_app_apply]
    -- Normalize the slice and apply naturality along its unique comparison map.
    simp only [unop_op]
    -- `g`'s underlying open inclusion: the two slice domains agree by `comp_image`.
    have hle : ((Hom.opensFunctor f).obj ((Hom.opensFunctor h).obj (unop W).left))
        ≤ ((Hom.opensFunctor (h ≫ f)).obj (unop W).left) :=
      le_of_eq (Scheme.Hom.comp_image h f (unop W).left).symm
    -- `key` = φ-naturality at the canonical slice morphism `sliceL ⟶ sliceR`.
    have key := hstar_naturality M φ
      (Over.homMk (homOfLE hle) (Subsingleton.elim _ _) :
        (Over.mk ((Hom.opensFunctor f).map ((Hom.opensFunctor h).map (unop W).hom)) :
            Over (f ''ᵁ h ''ᵁ unop V)) ⟶
          (Over.map ((h ≫ f).isOpenEmbedding.isOpenMap.adjunction.counit.app
                (f ''ᵁ h ''ᵁ unop V))).obj
            ((Over.map ((Hom.opensFunctor (h ≫ f)).map ((TopologicalSpace.Opens.map h.base).map
                  (f.isOpenEmbedding.isOpenMap.adjunction.unit.app (h ''ᵁ unop V))))).obj
              ((Over.map ((Hom.opensFunctor (h ≫ f)).map
                    (h.isOpenEmbedding.isOpenMap.adjunction.unit.app (unop V)))).obj
                (Over.mk ((Hom.opensFunctor (h ≫ f)).map (unop W).hom))))).op z
    -- The remaining carrier and `eqToIso` congruences are definitional.
    convert key using 2 <;> rfl

end Modules

end Scheme

end AlgebraicGeometry

end -- noncomputable section
