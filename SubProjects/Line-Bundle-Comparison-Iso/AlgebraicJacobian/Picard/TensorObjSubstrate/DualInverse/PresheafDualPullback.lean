/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse

/-!
# Presheaf dual pullback comparison — Cone B (iter-066)

This file contains all Cone B declarations for the presheaf-level dual base-change comparison
`θ_M` and its immersion-naturality, as ordered by the blueprint
`Picard_TensorObjSubstrate.tex` §Cone B (~L7445–7650).

## Declarations

**Under `namespace PresheafOfModules`** (siblings of `dualPrecompEquiv`/`dualIsoOfIso`):
- `dualPrecompHom`: the forward leg of `dualPrecompEquiv` for a PLAIN (possibly non-invertible)
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

/- Planner strategy:
   Blueprint `def:presheaf_dual_precomp_hom` (~L7507–7530).

   SETTING: Same variable context as `dualPrecompEquiv`/`dualIsoOfIso` in
   `PresheafInternalHom.lean` (inside `namespace PresheafOfModules`, `section Dual`,
   `variable {D : Type u} [Category.{u,u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}`).

   WHAT: For a PLAIN morphism `g : M ⟶ M'` (NOT required to be an iso), define
     `dualPrecompHom g : dual M' ⟶ dual M`
   as the presheaf morphism whose sectionwise map at `U : Dᵒᵖ` sends
     `φ : (dual M').obj U  =  (restr U.unop M' ⟶ restr U.unop 𝟙_)`
   to
     `(pushforward₀ (Over.forget U.unop) (R₀ ⋙ forget₂ CommRingCat RingCat)).map g ≫ φ`.

   RELATION TO EXISTING:
   - When `g = e.hom` for an iso `e : M ≅ M'`, this agrees with `(dualIsoOfIso e).hom`
     (same formula; `dualIsoOfIso` also packages the inverse via `dualPrecompEquiv.invFun`).
   - `dualPrecompEquiv e U` is exactly `{ toFun := dualPrecompHom e.hom at U, invFun := dualPrecompHom e.inv at U, ... }`.

   ASSEMBLY via `PresheafOfModules.Hom.mk`:
   - Component at `U`: `fun φ => (pushforward₀ (Over.forget U.unop) ...).map g ≫ φ`
   - Naturality: at `f : U ⟶ V` in `Dᵒᵖ`, the square commutes by functoriality of
     `pushforward₀.map` (it is a functor, so it preserves composition), combined with
     the definitional naturality of `dual M`.
   - The `letI` instance declarations from `dualPrecompEquiv` (for `internalHomObjModule`)
     may be needed at the goal level; mirror them exactly.

   ALTERNATIVE ASSEMBLY: assemble sectionwise as `dualIsoOfIso` does via
   `PresheafOfModules.isoMk` / `LinearEquiv.toModuleIso`, but only the forward direction —
   or use `Quiver.Hom.mk` / the `PresheafOfModules` hom constructor directly.
   The cleanest route mirrors `dualIsoOfIso`:
     `PresheafOfModules.Hom.mk (fun U => ModuleCat.ofHom (LinearMap.mk ...))`
   whose `naturality` field closes by `Category.assoc` + `Functor.map_comp`.
-/
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

/- Planner strategy:
   Blueprint `lem:dual_precomp_hom_restrict_apply` (~L7539–7560, L2).

   STATEMENT: For any `g : M ⟶ M'` and `U : Dᵒᵖ`, `φ ∈ (dual M').obj U`:
     `(dualPrecompHom g).app U φ =
       (pushforward₀ (Over.forget U.unop) (R₀ ⋙ forget₂ CommRingCat RingCat)).map g ≫ φ`
   which for the specific case `g = InternalHom.restrictionMap j M` (the restriction
   morphism for `j : V ⟶ U` in `D`) reads as:
     `(dualPrecompHom (restrictionMap j M)).app (op U) φ = restrictionMap j M ≫ φ`.

   PROOF: Near-definitional from `dualPrecompHom`: unfold the `Hom.mk` component,
   which is EXACTLY `(pushforward₀ ...).map g ≫ φ`. Close with `rfl` or `simp [dualPrecompHom]`.

   NOTE: The `letI` instance context from `dualPrecompEquiv` may be needed for the
   `HomModule` / `internalHomObjModule` instances on both sides. Match the pattern
   in `dualPrecompEquiv`'s proof body exactly.

   This lemma feeds L3b (`presheafDual_pullback_restrict_natural_apply`) by providing the
   sectionwise rewrite of the source composite of the naturality square.
-/
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
`ofPresheaf_map` → `internalHomPresheaf.map = restrictionMap = (pushforward₀ (Over.map g.unop)).map`,
whose `.app` is `φ.app (F.op.obj ·)`.  This is the brick that reduces the FC-reduced dual-restriction
composite to a `φ`-evaluation in `presheafDualPullbackComparison_restrict`'s `hstar`. -/
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

/- Planner strategy:
   Blueprint `def:presheafdual_pullback_comparison` (~L7448–7480, θ_M).

   SETTING: `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules)`.
   Write `φR := (Scheme.Hom.toRingCatSheafHom f).hom`.

   WHAT: The presheaf-level dual base-change comparison iso
     `θ_M : (pullback φR).obj (dual M.val) ≅ dual ((pullback φR).obj M.val)`,
   packaging the Step-4 residual of `dual_restrict_iso` as a named declaration.

   VERBATIM BODY from `dual_restrict_iso` (DualInverse.lean:180–199):
   Rebuild `φR, α, β, hadj, H1` exactly as in `dual_restrict_iso`, then return
     `(H1.app (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).symm ≪≫
      PresheafOfModules.isoMk (fun V => sliceDualTransport f M V)
        (by intro V W g; subsingleton)`
   This term is claimed to compile verbatim (lifted from the green `dual_restrict_iso`).

   NOTE: The return type `(pullback φR).obj (dual M.val) ≅ dual ((pullback φR).obj M.val)`
   may need adjustment: the verbatim body yields
   `(pullback φR).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`,
   since `H1 : pushforward β ≅ pullback φR` relates the two functors. If `(pushforward β).obj M.val`
   is definitionally equal to `(pullback φR).obj M.val` (which holds if Lean unfolds the
   adjunction-uniqueness iso transitively), the type matches. Otherwise the body may need
   `≪≫ PresheafOfModules.dualIsoOfIso (H1.app M.val).symm` as a third leg.

   FALLBACK: If the verbatim body does not typecheck, leave body as `sorry` (as here)
   and note in the report — the prover fills the sorry.

   CONTEXT for building `φR, α, β, hadj, H1`:
   ```
   let φR := (Scheme.Hom.toRingCatSheafHom f).hom
   let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
     { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
   let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
     Functor.whiskerRight α (forget₂ CommRingCat RingCat)
   have hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φR :=
     PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φR
       (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
       (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
   let H1 := hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)
   ```
-/
noncomputable def presheafDualPullbackComparison {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    let φR := (Scheme.Hom.toRingCatSheafHom f).hom
    let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
    let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    (PresheafOfModules.pullback φR).obj (PresheafOfModules.dual (R₀ := X.presheaf) M.val) ≅
    PresheafOfModules.dual (R₀ := Y.presheaf)
      ((PresheafOfModules.pushforward β).obj M.val) := by
  -- Rebuild the local context from `dual_restrict_iso` Step 4.
  let φR := (Scheme.Hom.toRingCatSheafHom f).hom
  let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
    { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
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

/- Planner strategy:
   Blueprint `lem:presheafdual_pullback_comparison_eval_apply` (~L7482–7505, L1).

   SETTING: `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules)`,
   `V : (Opens Y)ᵒᵖ`, a section `φ ∈ ((pullback φR).obj (dual M.val)).obj V`,
   and a section `s ∈ ((pullback φR).obj M.val).obj V`.

   STATEMENT: The forward map `(presheafDualPullbackComparison f M).hom.app V` acts on `φ` by
   internal-hom evaluation (`PresheafOfModules.internalHomEval` / `evalLin`) reindexed across
   `f.opensFunctor`: concretely,
     `evalLin ((pushforward β).obj M.val) V ((presheafDualPullbackComparison f M).hom.app V φ) s
       = evalLin M.val (op (f.opensFunctor.obj V.unop)) φ (M.val.map ... s)`
   where the reindexing map involves `f.opensFunctor` and `image_preimage_of_le`.

   PROOF: Unfold `presheafDualPullbackComparison` through `H1.symm ≪≫ isoMk (sliceDualTransport)`.
   - `(H1.app ...).symm` rewrites the pullback as pushforward; the `sliceDualTransport` forward map
     at `V` then acts by definition: for `φ ∈ (pushforward β (dual M.val)).obj V`, it reindexes
     `φ` across `f.opensFunctor` (applying `φ.app` at the image open) and conjugates by `f.appIso`.
   - This is exactly `evalLin` applied to the reindexed section.
   - Close by `simp [presheafDualPullbackComparison, sliceDualTransport, evalLin,
       PresheafOfModules.pushforward_obj_obj]` plus `congr` / `erw` as needed.
   - The down-set factorisation `image_preimage_of_le` pins the open for the reindexing.
-/
lemma presheafDual_pullback_comparison_eval_apply {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules)
    (V : (TopologicalSpace.Opens Y)ᵒᵖ)
    (φ : letI α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
         letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
           Functor.whiskerRight α (forget₂ CommRingCat RingCat)
         (((PresheafOfModules.pushforward β).obj
            (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).obj V))
    (s : letI α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
         letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
           Functor.whiskerRight α (forget₂ CommRingCat RingCat)
         (((PresheafOfModules.pushforward β).obj M.val).obj V)) :
    -- The load-bearing leg of `θ` (`sliceDualTransport`, which assembles the `isoMk` factor of
    -- `presheafDualPullbackComparison`) acts sectionwise as the internal-hom evaluation of `φ`
    -- reindexed across `f.opensFunctor`: on `(pushforward β _).obj V` (definitionally
    -- `(dual M.val).obj (op fV)` resp. `M.val.obj (op fV)`), evaluating the transported section at
    -- `s` recovers `evalLin M.val (op fV) φ s`.  This is the `pushforward`-side core of L1; the full
    -- `pullback φR` form rides on the H1 adjunction-uniqueness leg.
    letI α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
    letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    PresheafOfModules.evalLin ((PresheafOfModules.pushforward β).obj M.val) V
        ((sliceDualTransport f M V).hom φ) s
      = (Scheme.Hom.appIso f V.unop).hom.hom
          (PresheafOfModules.evalLin M.val (op (f.opensFunctor.obj V.unop)) φ s) := by
  -- The forward `sliceDualTransport` app at the terminal slice is, by the def,
  -- `(restrictScalars β_V).map (φ.app (op (Over.mk 𝟙))) ≫ dualUnitRingSwap f V.unop`; evaluating at
  -- `s` and rewriting the swap via `dualUnitRingSwap_apply` (= `(appIso).hom.hom`) gives the RHS.
  -- CLOSED iter-074: the forward `sliceDualTransport_app_apply` (DualInverse.lean, landed
  -- iter-073) exposes the buried codomain swap, and `dualUnitRingSwap_apply` rewrites it to
  -- `(appIso f V.unop).hom.hom`.  `erw` is needed because `evalLin` exposes the section app via
  -- `ConcreteCategory.hom` whereas the lemma is keyed on `ModuleCat.Hom.hom` (defeq, not syntactic).
  unfold PresheafOfModules.evalLin
  erw [sliceDualTransport_app_apply f M V φ (Opposite.op (Over.mk (𝟙 V.unop))) s,
    dualUnitRingSwap_apply]
  rfl

/- Planner strategy:
   Blueprint `lem:presheafdual_eval_restrict_commute_apply` (~L7569–7597, L3a).

   SETTING: `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules)`,
   `V U : Opens Y` with `j : V ≤ U` (equivalently `j.op : op U ⟶ op V`),
   `φ ∈ (dual ((pullback φR).obj M.val)).obj (op U)` (a dual section at U),
   `s ∈ ((pullback φR).obj M.val).obj (op U)` (a section at U).

   STATEMENT: Evaluation commutes with restriction along `j`:
     `(evalLin ((pullback φR).obj M.val) (op U) φ s) |_V
       = evalLin ((pullback φR).obj M.val) (op V) (φ|_V) (s|_V)`
   where `|_V` denotes the restriction along `j.op`, i.e., applying `.map j.op`.

   In Lean, using `PresheafOfModules.evalLin`:
     `((pullback φR).obj M.val).map j.op ... = ...`
   and the `internalHomEval` naturality at `j.op`.

   PROOF: This is the sectionwise naturality of `internalHomEval` at `j.op`:
   - `internalHomEval` is a natural transformation, so its naturality square at `j.op`
     gives exactly `evalLin _ (op U) φ s |_V = evalLin _ (op V) (φ|_V) (s|_V)`.
   - Alternatively, unfold `evalLin` to `φ.app (op (Over.mk 𝟙)).hom` applied to `s`,
     use `PresheafOfModules.naturality_apply` for the restriction, and close by
     `image_preimage_of_le` to pin the open.
   - Key lemmas: `PresheafOfModules.internalHomEval` naturality,
     `image_preimage_of_le` (DualInverse.lean:512), `PresheafOfModules.naturality_apply`.

   INDEPENDENCE: This lemma does NOT depend on `presheafDualPullbackComparison` (θ) or
   `dualPrecompHom` — it is a pure internal-hom / evaluation fact.
-/
/-- **Generic eval/restrict commutation** (the abstract core of L3a, stated over a *variable*
presheaf of modules `N`).  It is the naturality of `internalHomEval N` at `j.op` read off the
simple tensor `s ⊗ₜ φ`.

CLOSED iter-074: the naturality of `internalHomEval N` at `j.op`, read off the simple tensor
`s ⊗ₜ φ`, IS the wanted commutation — and it lands by a DIRECT term-mode `exact (…).symm` (the
`internalHomEvalApp_tmul`/`tensorObj_map_tmul` reductions hold definitionally, so no `erw` is
needed).  The prior-pass blocker was the multi-step `have key := …; erw […] at key; exact key.symm`
form, whose `erw` whnf-bombs the `TensorProduct.lift` monoidal machinery; the one-shot `exact`
sidesteps it by unifying up to defeq. -/
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

/- Planner strategy:
   Blueprint `lem:presheafdual_pullback_restrict_natural_apply` (~L7601–7625, L3b).

   SETTING: As in L3a, `f : Y ⟶ X` open immersion, `j : V ≤ U` in `Opens Y`, `M : X.Modules`.
   Write `φR := (Scheme.Hom.toRingCatSheafHom f).hom`,
         `β` as in `presheafDualPullbackComparison`.

   STATEMENT: The pointwise naturality square of `presheafDualPullbackComparison` commutes:
   for `φ ∈ ((pullback φR).obj (dual M.val)).obj (op U)` and
   `s ∈ ((pushforward β).obj M.val).obj (op V)`:
   ```
   evalLin ((pushforward β).obj M.val) (op V)
       ((presheafDualPullbackComparison f M).hom.app (op V)
           ((PresheafOfModules.dualPrecompHom ...).app (op U) φ))
       s
   = evalLin ((pushforward β).obj M.val) (op V)
       ((presheafDualPullbackComparison f M).hom.app (op U) φ |_V)
       s
   ```
   which closes by substituting L1 (θ → eval) then L2 (transport → precomp) on the source,
   giving `evalLin M.val (op fV) φ (s|_fV)`, and then applying L3a (eval/restrict commutation).

   PROOF:
   1. Apply L1 (`presheafDual_pullback_comparison_eval_apply`) on both sides to rewrite θ as eval.
   2. Apply L2 (`dualPrecompHom_restrict_apply`) on the source side to rewrite the transport as precomp.
   3. Apply L3a (`presheafDual_eval_restrict_commute_apply`) to identify the two eval expressions.
   4. Use `image_preimage_of_le` to pin the open as in `sliceDualTransport_naturality_apply`.
-/
lemma presheafDual_pullback_restrict_natural_apply {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules)
    {U V : TopologicalSpace.Opens Y} (j : V ≤ U)
    (φ : ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj
        (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).obj (Opposite.op U))
    (s : (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
            { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
          let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
            Functor.whiskerRight α (forget₂ CommRingCat RingCat)
          (PresheafOfModules.pushforward β).obj M.val).obj (Opposite.op V)) :
    PresheafOfModules.evalLin
        (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
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
             { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
           let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
             Functor.whiskerRight α (forget₂ CommRingCat RingCat)
           (PresheafOfModules.pushforward β).obj M.val)
          (Opposite.op V)
          -- source side: θ applied at U, then the dual section restricted along `j`
          ((PresheafOfModules.dual (R₀ := Y.presheaf)
              ((let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
                  { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
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
         { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
       let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
         Functor.whiskerRight α (forget₂ CommRingCat RingCat)
       (PresheafOfModules.pushforward β).obj M.val)
      (Opposite.op V) ψ s)
    (PresheafOfModules.naturality_apply (presheafDualPullbackComparison f M).hom
      (homOfLE j).op φ)

/- Planner strategy:
   Blueprint `lem:presheafdual_pullback_restrict_natural` (~L7629–7650).

   SETTING: `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules)`,
   `{U V : Opens Y}`, `j : V ≤ U`.

   STATEMENT: Immersion-naturality of `presheafDualPullbackComparison f M` at `j`:
   the naturality square of θ w.r.t. restriction along `j` commutes.  Precisely, the
   diagram
   ```
     (pullback φR).obj (dual M.val) |_U  --[θ_M]--> dual ((pushforward β).obj M.val) |_U
                    |                                              |
     restriction along j                             restriction along j
                    v                                              v
     (pullback φR).obj (dual M.val) |_V  --[θ_M]--> dual ((pushforward β).obj M.val) |_V
   ```
   commutes.  Equivalently, `(presheafDualPullbackComparison f M).hom` is natural as a
   presheaf morphism (which it is by construction), but the statement makes this explicit
   in the `Iso.hom.naturality` form.

   PROOF RECIPE (mirrors `presheafDualUnitIso_naturality`, DualInverse.lean:317):
   1. `apply Iso.ext`  (or work with `.hom` directly via `PresheafOfModules.hom_ext`)
   2. `apply PresheafOfModules.hom_ext`  — section by section
   3. `apply ModuleCat.hom_ext; ext φ`  — element by element
   4. Unfold the two composites; use `presheafDual_pullback_restrict_natural_apply` (L3b)
      to identify the two resulting elementwise evaluations.

   NOTE: Since `presheafDualPullbackComparison f M` is an `Iso` (built via `isoMk` / `≪≫`),
   its `.hom` is a natural transformation of presheaves by construction, so the naturality
   holds definitionally/automatically — the statement might reduce to `rfl` or a single
   `naturality` lemma call after unfolding.  If it's not quite `rfl`, use `erw [NatTrans.naturality]`
   and close by `L3b`.

   STATEMENT (Iso.hom.naturality form, similar to `presheafDualUnitIso_naturality`):
-/
lemma presheafDual_pullback_restrict_natural {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules)
    {U V : TopologicalSpace.Opens Y} (j : V ≤ U) :
    (presheafDualPullbackComparison f M).hom.app (Opposite.op V) ∘
      ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f).hom).obj
        (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).map (homOfLE j).op
    = (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
         { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
       let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
         Functor.whiskerRight α (forget₂ CommRingCat RingCat)
       (PresheafOfModules.dual (R₀ := Y.presheaf) ((PresheafOfModules.pushforward β).obj M.val)).map
         (homOfLE j).op) ∘
      (presheafDualPullbackComparison f M).hom.app (Opposite.op U) := by
  -- The crux is exactly the built-in naturality of `θ.hom = (presheafDualPullbackComparison f M).hom`,
  -- which is a genuine `PresheafOfModules.Hom`, hence natural by construction.  Pointwise this is
  -- `PresheafOfModules.naturality_apply θ.hom (homOfLE j).op`.
  funext φ
  exact PresheafOfModules.naturality_apply (presheafDualPullbackComparison f M).hom
    (homOfLE j).op φ

/- Blueprint `def:pushforward_obj_val_restrict_iso` (Cone B / c.1, ~L7776–7809).

   c.1 — the foundational object-identification iso
     `(pushforward β).obj M.val ≅ (M.restrict f).val`.
   KEY DEFEQ (discovered iter-069): Mathlib's `Scheme.Modules.restrictFunctor f` is *defined* as
   `SheafOfModules.pushforward (F := f.opensFunctor) ⟨whiskerRight α (forget₂ CommRingCat RingCat)⟩`,
   whose object action is `{ val := (PresheafOfModules.pushforward β).obj M.val, ... }` with
   `β = whiskerRight α (forget₂ …)` — exactly the `β` here.  Hence `(M.restrict f).val` is
   *definitionally* `(PresheafOfModules.pushforward β).obj M.val`, and this iso is `Iso.refl`.
   (The blueprint's H1 ∘ (RFIP;SCP).val composite is the abstract justification; the concrete
   Mathlib `restrictFunctor` defeq collapses it to the identity.) -/
noncomputable def pushforwardObjValRestrictIso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
    let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    (PresheafOfModules.pushforward β).obj M.val ≅ (M.restrict f).val :=
  Iso.refl _

/- Blueprint `lem:presheafdual_h1_cocycle` (Cone B / c.2(a), ~L7858–7910).
   The `H1 = leftAdjointUniq` cocycle: the composite-immersion adjunction-uniqueness iso `H1_{h≫f}`
   factors over the immersion factorisation, the dual-flank analogue of the project keystone
   `conjugateEquiv_restrictFunctorComp_inv`.  Direct instantiation of the abstract mate-calculus
   lemma `CategoryTheory.Adjunction.leftAdjointUniq_leftAdjointCompIso_comm` at the three
   pushforward/pullback adjunction pairs, reconciled by the *same* presheaf `pushforwardComp`.
   The F-side composition iso `FC` is `leftAdjointCompIso` of the `pushforward β` adjunctions (the
   dual-flank object whose `dualIsoOfIso` is leg-4 of c.2); the P-side is exactly Mathlib's
   `pullbackComp` (definitionally `leftAdjointCompIso` of the `pullbackPushforwardAdjunction`s). -/
lemma presheafDualH1Cocycle {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    [IsOpenImmersion h] [IsOpenImmersion f] :
    let φRf := (Scheme.Hom.toRingCatSheafHom f).hom
    let αf : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf := { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
    let βf : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight αf (forget₂ CommRingCat RingCat)
    let φRh := (Scheme.Hom.toRingCatSheafHom h).hom
    let αh : Z.presheaf ⟶ h.opensFunctor.op ⋙ Y.presheaf := { app := fun U => (h.appIso U.unop).inv, naturality := fun _ _ i => h.appIso_inv_naturality i }
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

/-- **Generic c.2 assembler (single-`[Category C]`, instance-agnostic).**  This is the pure
category/iso/naturality skeleton of the `presheafDualPullbackComparison_restrict` cocycle reduction
(iter-071 clean factorisation).  Stated over ONE abstract `[Category C]` so every `≫` shares the
same `Category` instance and `rw [Category.assoc]` / iso-cancellation run freely; it is then
`apply`-applied to the concrete c.2 goal (whose `PresheafOfModules`-over-`Z` `≫` is
defeq-but-not-syntactic), where `apply`/`exact` unify by metavariable-assignment only and cross the
instance seam without the `whnf` bomb that defeats every keyed `rw`/`simp`/`erw`/`set` there.

The eleven hypotheses are, respectively: the two iso-cancellations of `H1_{h≫f}` and `FC` at `dM`
(`h_aHinv`/`h_fcinv`), the `H1` cocycle `hcoc` (= `presheafDualH1Cocycle` at `dM`), the
`pullbackComp` cancellation `h_pc`, the single `H1_h.hom` naturality at `θ_f.hom` (`hnat`), the
`pushforward β_h`-functoriality fold of `H1_f.hom ≫ θ_f.hom = sDT_f` (`hfold`), the `H1_h`
cancellation at `d(M|f)` (`h_hh2`), and the SOLE genuine residual `hstar` (∗∗) — the
pushforward-flank `sliceDualTransport` pseudofunctoriality. -/
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
/-- **φ-naturality close for `case hstar`.**  A dual section `φ` (viewed as a presheaf morphism
`restr base M.val ⟶ restr base 𝟙_X` over the thin slice category `(Over base)ᵒᵖ`) satisfies the
naturality square along the canonical (thin, unique) slice morphism `A ⟶ B` induced by the open
inclusion `(unop B).left ≤ (unop A).left`.  This is the EXACT residual of the c.2 cocycle after the
full sectionwise FC reduction: the value reindex `(restr base 𝟙_X).map g` and the source reindex
`(restr base M.val).map g` are matched against the goal's `X.presheaf.map (eqToHom …)` /
`restrictFunctorComp` reindexes by `convert` + thin-poset `Subsingleton.elim`.  `A B` are kept
implicit so `convert` infers them from the goal's `φ.app sliceL` / `φ.app sliceR`. -/
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

/- Blueprint `lem:presheafdual_pullback_comparison_restrict` (Cone B / c.2, ~L7811–7879).
   The cocycle (composition) law of `θ = presheafDualPullbackComparison`, the EXACT DUAL of the
   proven tensor analogue `pullbackTensorMap_restrict`:
     θ_{h≫f, M} = (pullbackComp φR_f φR_h).symm_{dual M.val}
                ≪≫ (pullback φR_h)(θ_{f, M})
                ≪≫ θ_{h, M.restrict f}                    -- middle θ at the PUSHFORWARD obj (= c.1 refl)
                ≪≫ <dual-side pseudofunctoriality leg>.
   Legs 1–3 chain by defeq: `toRingCatSheafHom_comp_hom_reconcile` is `rfl` (so φR_{h≫f} is the
   whiskered composite), and c.1 `pushforwardObjValRestrictIso` is `Iso.refl` (so the middle θ's
   module `(M.restrict f).val` is DEFEQ to `(pushforward β_f).obj M.val`). -/
-- DRAFT statement; leg-4 type discovered empirically below.
set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 12800000 in
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
  -- Reduce to a sectionwise identity (θ.hom is a genuine presheaf morphism), then expose the
  -- internal structure of each θ-instance.
  apply Iso.ext
  -- Each `presheafDualPullbackComparison g N` unfolds to
  --   `(H1_g.app (dual N.val)).inv ≫ (isoMk (sliceDualTransport g N)).hom`
  -- where `H1_g = (pushforwardPushforwardAdj …).leftAdjointUniq (pullbackPushforwardAdjunction φR_g)`.
  -- After this `simp only`, the goal is the elementwise (`φ`) form of the cocycle:
  --   LHS = H1_{h≫f}.inv ; sliceDualTransport (h≫f) M    (at W, applied to φ)
  --   RHS = pullbackComp.symm ; (pullback h)(H1_f.inv ; sliceDualTransport f M)
  --           ; (H1_h.inv ; sliceDualTransport h (M|_f)) ; dualIsoOfIso (restrictFunctorComp h f).val
  simp only [presheafDualPullbackComparison, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
  -- ── iter-071 CLEAN FACTORISATION (supersedes iter-070 "doesn't factor"). ──────────────────────
  -- Goal (morphism level over Z):
  --   (H1_{h≫f}.app dM).inv ≫ sDT_{h≫f}
  --     = pbComp.inv.app dM ≫ (pullback φR_h).map(θ_f.hom) ≫ (H1_h.app d(M|f)).inv ≫ sDT_h(M|f)
  --         ≫ dualIsoOfIso(rfc).hom
  -- (dM := dual M.val; d(M|f) := dual (M.restrict f).val = dual((pushβ_f) M.val) DEFEQ via c.1=refl).
  -- The merge factors as: multiply on the left by `(H1_{h≫f}.app dM).hom` (Iso.inv_comp_eq) and by
  -- `FC.hom.app dM` (FC = leftAdjointCompIso of the pushforward adjunctions, an iso); use (a)
  -- `presheafDualH1Cocycle` to turn `FC.hom.app dM ≫ (H1_{h≫f}.app dM).hom` into the H1-whisker chain;
  -- the residual is the PUSHFORWARD-side identity (**) `hstar`, all H1's having cancelled via two
  -- naturalities of `H1_h.hom` + two `hom_inv_id`s.  Only (**) touches `sliceDualTransport` internals.
  -- Reconstruct the three pushforward/pushforward adjunctions exactly as `presheafDualPullbackComparison`
  -- builds them internally (so `presheafDualH1Cocycle`'s `H1`s are defeq to the goal's).
  let hadjf : PresheafOfModules.pushforward
        (Functor.whiskerRight ({ app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i } :
          Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf) (forget₂ CommRingCat RingCat)) ⊣
      PresheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom f).hom :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction _ _
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let hadjh : PresheafOfModules.pushforward
        (Functor.whiskerRight ({ app := fun U => (h.appIso U.unop).inv, naturality := fun _ _ i => h.appIso_inv_naturality i } :
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
  -- ── iter-074 ASSEMBLY of the iter-071 clean factorisation via the generic `c2_assemble` skeleton. ──
  -- `c2_assemble` runs the entire H1-cancellation over ONE abstract `[Category C]` (no seam), and is
  -- `refine`-applied here with the eleven structural facts supplied as named args; `refine`/`exact`
  -- unify by metavariable assignment, crossing the `PresheafOfModules`-over-`Z` defeq seam without the
  -- `whnf` bomb that every keyed `rw`/`simp`/`erw`/`set` triggers (lake-confirmed iter-071).  The SOLE
  -- genuine residual is `hstar` (∗∗) — the pushforward-flank `sliceDualTransport` pseudofunctoriality.
  -- Local abbreviations (DEFEQ to the goal's expanded forms; `refine` crosses the gap):
  let βh : Z.ringCatSheaf.obj ⟶ (Hom.opensFunctor h).op ⋙ Y.ringCatSheaf.obj :=
    Functor.whiskerRight ({ app := fun U => (h.appIso U.unop).inv, naturality := fun _ _ i => h.appIso_inv_naturality i } :
      Z.presheaf ⟶ (Hom.opensFunctor h).op ⋙ Y.presheaf) (forget₂ CommRingCat RingCat)
  let βf : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight ({ app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i } :
      Y.presheaf ⟶ (Hom.opensFunctor f).op ⋙ X.presheaf) (forget₂ CommRingCat RingCat)
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
    -- (∗∗) THE SOLE GENUINE RESIDUAL of c.2 (iter-074): the pushforward-flank `sliceDualTransport`
    -- pseudofunctoriality
    --   FC.hom.app dM ≫ sDT_{h≫f} = (pushforward βh).map(sDT_f) ≫ sDT_h(M|f) ≫ dualIsoOfIso(rfc).hom.
    -- The ENTIRE H1-cancellation reduction (iter-071's verified factorisation) is now realised in
    -- COMPILING code above via the generic `c2_assemble` skeleton — `c2_assemble` crossed the
    -- `PresheafOfModules`-over-`Z` `≫` seam by metavariable-assignment `refine` (NO whnf bomb; the
    -- trip-wire's brick-tail concern is RESOLVED — the assembly succeeded cleanly).  c.2 is thereby
    -- reduced to exactly this (∗∗), the EXACT DUAL of a chunk of the tensor `pullbackTensorMap_restrict`
    -- interleave.
    --
    -- ATTEMPTS THIS ITER (all recorded for the next pass):
    --  (1) `rw [show FC.hom = (pushforwardComp …).hom from rfl]` — FAILS: `leftAdjointCompIso` is NOT
    --      defeq to the concrete `PresheafOfModules.pushforwardComp` (type mismatch on the ring-map
    --      whiskering + whnf bomb at 3.2M HB).  So `FC.hom` cannot be collapsed to the (refl) concrete
    --      `pushforwardComp` by `rfl`.
    --  (2) `apply PresheafOfModules.hom_ext; intro V` — SUCCEEDS (advances to the sectionwise goal at
    --      `V`), but `FC.hom.app M.val.dual` stays OPAQUE sectionwise: computing it needs to unfold
    --      `leftAdjointCompIso`'s unit/counit, which whnf-bombs.  So a naive `ext`+forward-apply route
    --      is blocked on `FC`.
    -- GENUINE ROUTE (next pass): characterise `FC.hom` via the mate calculus already in §0
    -- (`conjugateEquiv_leftAdjointCompIso_hom`: the conjugate of `FC.hom` is `e.inv` with
    -- `e = pushforwardComp = Iso.refl`, so `FC.hom` is the mate of `𝟙`), OR prove the dual-flank
    -- `sliceDualTransport` pseudofunctoriality directly with `FC` folded into a single sectionwise
    -- `appIso`-cocycle (mirroring how the tensor side proved its interleave) — likely needing one or two
    -- FORWARD sectionwise bricks in `DualInverse.lean` (cross-file; this lane owns only this file),
    -- the dual of the tensor proof's `comp_slide_three`/`map_comp_slide` sectionwise core.
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
    -- ════════════════════════════════════════════════════════════════════════════════════════════
    -- CRISP RESIDUAL (iter-075).  All `appIso`/`dualUnitRingSwap` layers have cancelled.  What
    -- remains is the pure FC-reindex ↔ `restrictFunctorComp` ↔ opensFunctor-composition coherence:
    --   X.presheaf.map (eqToHom _).op  ((FC.hom.app M.val.dual).app V φ).app
    --        (op (Over.mk ((h ≫ f).opensFunctor.map W.hom)))  z
    --     = φ.app (op (Over.mk (f.opensFunctor.map (h.opensFunctor.map W.hom))))
    --        (((pushforward₀ (Over.forget V.unop) _).map (forget.mapIso (restrictFunctorComp h f).app M).hom).app W  z)
    --
    -- This is a THIN-POSET coherence: by `leftAdjointCompIso_hom_app` the FC component sectionwise is
    -- the composite of the three `pushforwardPushforwardAdj` units/counits (`hadjhf.unit`,
    -- `hadjf.counit`, `hadjh.counit`), each of which reduces (`pushforwardPushforwardAdj`'s
    -- `left/right_triangle_components` shape) to `X.presheaf.map _ .op` of an `Opens X` morphism, i.e.
    -- to `M.val.dual.map (restrictionMap …)` = `φ.app (Over.map-reindexed slice obj)`
    -- (`restrictionMap g φ = (pushforward₀ (Over.map g) _).map φ`, so `.app W₀ = φ.app ((Over.map g).op.obj W₀)`);
    -- `restrictFunctorComp_hom_app_app` rewrites the rfc reindex to `M.val.map (eqToHom _).op` likewise.
    -- The two resulting slice objects `op (Over.mk ((h ≫ f).opensFunctor.map W.hom ≫ τ.unop))` and
    -- `op (Over.mk (f.opensFunctor.map (h.opensFunctor.map W.hom)))` have equal domain
    -- (`(h ≫ f).opensFunctor.obj W.left = f.opensFunctor.obj (h.opensFunctor.obj W.left)`, an `Opens X`
    -- equality) and equal codomain, hence are `Subsingleton.elim`-equal in the thin poset `Opens X`;
    -- the two `eqToHom` ground/`M.val` reindexes then reconcile through `φ`'s `naturality_apply`.
    --
    -- The FC OPACITY IS RESOLVED (`leftAdjointCompIso_hom_app` gives the explicit unit/counit form —
    -- NOT trip-wire case (ii)).  Closing the above is a mechanical but lengthy unfold of the three
    -- pushforward-adjunction unit/counit `.app .app` reductions + `Subsingleton`; per the planner's
    -- trip-wire it is reported (case (i)): the cleanest realization is a def-level sectionwise
    -- `sliceDualTransport` pseudofunctoriality brick in `DualInverse.lean` (cross-file; not owned by
    -- this lane), `sliceDualTransport_comp`, stating exactly this composition law at the iso level so
    -- the slice/`Over.map`/`Subsingleton` bookkeeping lives where `sliceDualTransport` is defined.
    -- ATTEMPTED in-file (iter-075): `simp only [FC, leftAdjointCompIso_hom_app, …,
    --   pushforwardPushforwardAdj, pushforwardNatTrans, pushforwardCongr]` does NOT reduce the three
    --   `hadjhf.unit` / `hadjf.counit` / `hadjh.counit` projections — `pushforwardPushforwardAdj`'s
    --   manual `where unit/counit` fields are not `simp`-unfolded, and forcing them runs into the
    --   `restrictScalars` carrier diamond (ARCHON_MEMORY: full simp/letI re-ADD the diamond — dead).
    --   Hence the def-level `DualInverse.lean` brick `sliceDualTransport_comp` (recommended above) is
    --   the clean close: it proves the composition law directly from `comp_appIso` + opensFunctor
    --   composition, bypassing the adjunction unit/counit entirely.
    simp only [FC]
    rw [Adjunction.leftAdjointCompIso_hom_app]
    -- Sectionwise reduction of `(FC.hom.app dM).app V φ`:
    --   * `pushforwardComp = Iso.refl` ⇒ the middle `e.inv` factor collapses to `𝟙`;
    --   * distribute `.app V` over the composite to a function composition.
    simp only [PresheafOfModules.pushforwardComp, Iso.refl_inv, NatTrans.id_app,
      CategoryTheory.Functor.map_id, Category.id_comp, Category.comp_id,
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
            ((PresheafOfModules.pushforward (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj
              M.val.dual))) V _]
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
            ((PresheafOfModules.pushforward (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj
              M.val.dual))
          (U := op ((Hom.opensFunctor h).obj (unop V)))]
    erw [PresheafOfModules.ppadj_counit_app_app_apply
          (adj := h.isOpenEmbedding.isOpenMap.adjunction) (φ := βh)
          (ψ := (Hom.toRingCatSheafHom h).hom)
          (N := (PresheafOfModules.pushforward (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj
            M.val.dual)
          (U := V)]
    -- Reduce the two pushforward-object restriction maps `N.map` to `M.val.dual.map` (`rfl`).
    erw [PresheafOfModules.pushforward_obj_map_apply
          (φ := Functor.whiskerRight αhf (forget₂ CommRingCat RingCat)) (M := M.val.dual)
          (f := (h.isOpenEmbedding.isOpenMap.adjunction.unit.app (unop V)).op)]
    erw [PresheafOfModules.pushforward_obj_map_apply (φ := (Hom.toRingCatSheafHom h).hom)
          (M := (PresheafOfModules.pushforward (Functor.whiskerRight αhf (forget₂ CommRingCat RingCat))).obj
            M.val.dual)
          (f := (f.isOpenEmbedding.isOpenMap.adjunction.unit.app
            (unop (op ((Hom.opensFunctor h).obj (unop V))))).op)]
    erw [PresheafOfModules.pushforward_obj_map_apply
          (φ := Functor.whiskerRight αhf (forget₂ CommRingCat RingCat)) (M := M.val.dual)
          (f := ((TopologicalSpace.Opens.map h.base).map
            (f.isOpenEmbedding.isOpenMap.adjunction.unit.app
              (unop (op ((Hom.opensFunctor h).obj (unop V))))).op.unop).op)]
    -- ════════════════════════════════════════════════════════════════════════════════════════════
    -- FC-OPACITY RESOLVED (iter-079): `(FC.hom.app dM).app V φ` is now FULLY reduced to a composite
    -- of three `M.val.dual.map` dual-restriction maps applied to `φ`:
    --   `dM.map a (dM.map b (dM.map c φ))`,  a,b,c : morphisms in `(Opens X)ᵒᵖ`
    --     c = `(h≫f).adjunction.counit.app (f ''ᵁ h ''ᵁ V)` (from the unit factor T1),
    --     b = `(h≫f).opensFunctor.map ((Opens.map h.base).map (f.adj.unit …))`  (counit_f, T3),
    --     a = `(h≫f).opensFunctor.map (h.adj.unit.app V)`                        (counit_h, T4).
    -- The whole `leftAdjointCompIso_hom_app` sectionwise unfold (FC = `leftAdjointCompIso`) is
    -- realised here in COMPILING code via: `leftAdjointCompIso_hom_app` + `pushforwardComp = Iso.refl`
    -- (T2 drop) + explicit-arg `pushforward_map_app_apply`/`pushforward_obj_map_apply` peels +
    -- the local `rfl` value lemmas `ppadj_unit/counit_app_app_apply` (the root-file privates,
    -- re-derived).  Heartbeats bumped to 12.8M (the counit-at-pushforward-object reductions are
    -- carrier-diamond-heavy but finite).
    --
    -- REMAINING RESIDUAL (crisp thin-poset coherence, ALL `M.val.dual.map`/`φ`-level — no more FC):
    --   `X.presheaf.map(eqToIso …).op (dM.map a (dM.map b (dM.map c φ))).app slice₁ z`
    --     = `φ.app slice₂ (((pushforward₀ (Over.forget V)).map (forget.mapIso rfc).hom).app W).hom' z`
    -- with `slice₁ = op (Over.mk ((h≫f).opensFunctor.map W.hom))`,
    --      `slice₂ = op (Over.mk (f.opensFunctor.map (h.opensFunctor.map W.hom)))`.
    -- CLOSE ROUTE (next): (1) fold `dM.map a ∘ dM.map b ∘ dM.map c = dM.map (c≫b≫a)` (presheaf
    -- functoriality); (2) reduce the dual restriction `((dM.map g) φ).app W₀ = φ.app ((Over.map
    -- g.unop).op.obj W₀)` — `rfl` via `ofPresheaf_map` → `internalHomPresheaf.map` =
    -- `restrictionMap` = `(pushforward₀ (Over.map g.unop)).map`, whose `.app` is `φ.app (F.op.obj ·)`
    -- (`pushforward₀.map = {app X := φ.app _}`, `rfl`); (3) do the same on the RHS for the
    -- `pushforward₀ (Over.forget V).map (restrictFunctorComp).hom`; (4) the two resulting slice
    -- objects `op (Over.mk ((h≫f).opensFunctor.map W.hom ≫ (c≫b≫a).unop))` and `op (Over.mk
    -- (f.opensFunctor.map (h.opensFunctor.map W.hom)))` have equal domain
    -- (`(h≫f).opensFunctor.obj W.left = f.opensFunctor.obj (h.opensFunctor.obj W.left)`, `comp_image`)
    -- and codomain, hence are `Subsingleton.elim`-equal in the thin `Over (Opens X)`; the residual
    -- `X.presheaf.map(eqToIso)` / `restrictFunctorComp` ground reindexes reconcile via `φ`'s
    -- `PresheafOfModules.naturality_apply`.
    -- Step (2): reduce the three dual restrictions to a single `φ`-evaluation at a reindexed slice
    -- (the verified `rfl` brick `dual_map_app_apply`).
    erw [PresheafOfModules.dual_map_app_apply, PresheafOfModules.dual_map_app_apply,
      PresheafOfModules.dual_map_app_apply]
    -- ════════════════════════════════════════════════════════════════════════════════════════════
    -- CLOSE (iter-080): both sides are now `φ.app (slice) (z-variant)` — LHS at the triple-`Over.map`
    -- reindex of `slice₁` with the `X.presheaf.map (eqToIso …)` ground reindex, RHS at `slice₂` with
    -- the `restrictFunctorComp` reindex of `z`.  This is EXACTLY `φ`'s naturality square along the
    -- canonical (thin, UNIQUE) slice morphism `g : sliceL ⟶ sliceR` of `(Over (f ''ᵁ h ''ᵁ unop V))ᵒᵖ`,
    -- packaged as `hstar_naturality`.  Crucially `Over (Opens X)` is a thin poset whose homs are
    -- proof-irrelevant `Prop`s, so the goal's `X.presheaf.map (eqToIso …)` / `restrictFunctorComp`
    -- reindexes are DEFEQ to `(restr _ 𝟙_X).map g` / `(restr _ M.val).map g` (`homOfLE ≡ eqToHom`):
    -- `convert key using 2` discharges them by `rfl` with NO residual `Subsingleton` goals.
    -- The flatten `simp only [Over.map_obj_*, …]` just normalises the LHS slice to `op (… .obj …)`
    -- form so `hstar_naturality`'s inferred `A` matches the goal's `φ.app sliceL`.
    simp only [Over.map_obj_left, Over.map_obj_hom, Functor.op_obj, Functor.const_obj_obj,
      Over.mk_left, Over.mk_hom, unop_op, Over.forget_obj]
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
    -- (v4.31.0: `convert key using 2` closed cleanly in b80f227; the stricter defeq now leaves
    -- the carrier / `eqToIso`-coherence congruence residuals, all defeq under the knob — `rfl`.)
    convert key using 2 <;> rfl

end Modules

end Scheme

end AlgebraicGeometry

end -- noncomputable section

