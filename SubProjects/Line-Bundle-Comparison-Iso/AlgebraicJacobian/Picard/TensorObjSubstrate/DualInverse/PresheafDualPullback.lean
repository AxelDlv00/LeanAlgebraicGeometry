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
     { app := fun U => (f.appIso U.unop).inv }
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
      { app := fun U => (f.appIso U.unop).inv }
    let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    (PresheafOfModules.pullback φR).obj (PresheafOfModules.dual (R₀ := X.presheaf) M.val) ≅
    PresheafOfModules.dual (R₀ := Y.presheaf)
      ((PresheafOfModules.pushforward β).obj M.val) := by
  -- Rebuild the local context from `dual_restrict_iso` Step 4.
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
           { app := fun U => (f.appIso U.unop).inv }
         letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
           Functor.whiskerRight α (forget₂ CommRingCat RingCat)
         (((PresheafOfModules.pushforward β).obj
            (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).obj V))
    (s : letI α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv }
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
      { app := fun U => (f.appIso U.unop).inv }
    letI β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    PresheafOfModules.evalLin ((PresheafOfModules.pushforward β).obj M.val) V
        ((sliceDualTransport f M V).hom φ) s
      = (Scheme.Hom.appIso f V.unop).hom.hom
          (PresheafOfModules.evalLin M.val (op (f.opensFunctor.obj V.unop)) φ s) := by
  -- The forward `sliceDualTransport` app at the terminal slice is, by the def,
  -- `(restrictScalars β_V).map (φ.app (op (Over.mk 𝟙))) ≫ dualUnitRingSwap f V.unop`; evaluating at
  -- `s` and rewriting the swap via `dualUnitRingSwap_apply` (= `(appIso).hom.hom`) gives the RHS.
  -- BLOCKER (recorded for the next prover pass): `evalLin _ V ((sliceDualTransport f M V).hom φ) s`
  -- does NOT expose `dualUnitRingSwap` for `rw [dualUnitRingSwap_apply]` — the swap is buried in the
  -- unevaluated `(sliceDualTransport f M V).hom` app.  Exposing it needs a *forward*
  -- `sliceDualTransport_app_apply` lemma (only the inverse `sliceDualTransportInv_app_apply`
  -- exists, SliceTransport.lean:563); `change`/`simp [sliceDualTransport]` here would whnf the
  -- heavy `maxHeartbeats 1600000` def inline.  FIX: add `sliceDualTransport_app_apply` to
  -- `SliceTransport.lean` (NOT owned by this lane), then this closes by `rw [that, dualUnitRingSwap_apply]`.
  sorry

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

BLOCKER (recorded for the next prover pass): the clean route
```
  have key := PresheafOfModules.naturality_apply (PresheafOfModules.internalHomEval N) j.op
    (s ⊗ₜ[(R₀.obj (op U) : Type u)] φ)
  erw [PresheafOfModules.Monoidal.tensorObj_map_tmul,
    PresheafOfModules.internalHomEvalApp_tmul, PresheafOfModules.internalHomEvalApp_tmul] at key
  exact key.symm
```
whnf-bombs at the `erw` even at `maxHeartbeats 1600000` (the `tensorObj.map`-on-`tmul` rewrite
forces whnf of the `TensorProduct.lift` monoidal machinery).  The `φ`-naturality route used inside
`internalHomEval`'s own `naturality` field (`naturality_apply φ (Over.homMk f.unop).op s` +
`restr_map_homMk` + `hom_app_heq`-based `hdt`) avoids the tensor whnf, but `restr_map_homMk` and
`hom_app_heq` are `private` in `PresheafInternalHom.lean` — they must be re-exposed (or re-proven
inline; both are `rfl`/`subst`) to land this without the bomb. -/
private lemma evalLin_restrict_commute_aux {D : Type u} [Category.{u, u} D]
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}
    (N : _root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) {U V : D} (j : V ⟶ U)
    (φ : (PresheafOfModules.dual N).obj (op U)) (s : (N.obj (op U) : Type u)) :
    ((R₀ ⋙ forget₂ CommRingCat RingCat).map j.op).hom
        (PresheafOfModules.evalLin N (op U) φ s)
      = PresheafOfModules.evalLin N (op V)
          ((PresheafOfModules.dual N).map j.op φ) (N.map j.op s) :=
  sorry

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
            { app := fun U => (f.appIso U.unop).inv }
          let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
            Functor.whiskerRight α (forget₂ CommRingCat RingCat)
          (PresheafOfModules.pushforward β).obj M.val).obj (Opposite.op V)) :
    PresheafOfModules.evalLin
        (let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
           { app := fun U => (f.appIso U.unop).inv }
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
             { app := fun U => (f.appIso U.unop).inv }
           let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
             Functor.whiskerRight α (forget₂ CommRingCat RingCat)
           (PresheafOfModules.pushforward β).obj M.val)
          (Opposite.op V)
          -- source side: θ applied at U, then the dual section restricted along `j`
          ((PresheafOfModules.dual (R₀ := Y.presheaf)
              ((let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
                  { app := fun U => (f.appIso U.unop).inv }
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
         { app := fun U => (f.appIso U.unop).inv }
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
         { app := fun U => (f.appIso U.unop).inv }
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
      { app := fun U => (f.appIso U.unop).inv }
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
    let αf : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf := { app := fun U => (f.appIso U.unop).inv }
    let βf : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight αf (forget₂ CommRingCat RingCat)
    let φRh := (Scheme.Hom.toRingCatSheafHom h).hom
    let αh : Z.presheaf ⟶ h.opensFunctor.op ⋙ Y.presheaf := { app := fun U => (h.appIso U.unop).inv }
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
set_option maxHeartbeats 3200000 in
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
  simp only [presheafDualPullbackComparison, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom,
    PresheafOfModules.comp_app]
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
        (Functor.whiskerRight ({ app := fun U => (f.appIso U.unop).inv } :
          Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf) (forget₂ CommRingCat RingCat)) ⊣
      PresheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom f).hom :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction _ _
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let hadjh : PresheafOfModules.pushforward
        (Functor.whiskerRight ({ app := fun U => (h.appIso U.unop).inv } :
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
  -- ── iter-071 CLEAN FACTORISATION of c.2 (supersedes iter-070 "interleaved merge, doesn't factor"). ─
  -- The three `let`-bound adjunctions above reconstruct (transparently) the exact adjunctions
  -- `presheafDualPullbackComparison` builds internally, so `hcoc`'s `H1`/`FC` terms are DEFEQ to those
  -- in the goal.  Writing `dM := M.val.dual`, `sDT_g := isoMk (sliceDualTransport g _) .hom`,
  -- `pf := pullback φR_f`, `pushβ_h := pushforward β_h`, and `FC := leftAdjointCompIso` of the
  -- pushforward adjunctions, the goal (after `apply Iso.ext` + the `simp only` above) is
  --   (H1_{h≫f}.app dM).inv ≫ sDT_{h≫f}
  --     = pbComp.symm.app dM .hom ≫ (pullback φR_h).map(θ_f.hom) ≫ (H1_h.app d(M|f)).inv ≫ sDT_h(M|f)
  --         ≫ dualIsoOfIso(rfc).hom.
  -- It factors (paper proof in `coneb-c2-clean-factorization`) by: multiply on the left by
  -- `(H1_{h≫f}.app dM).hom` (`Iso.inv_comp_eq`) and by `FC.hom.app dM` (an iso); substitute the H1
  -- cocycle `hcoc` (evaluated at dM: `FC.hom.app dM ≫ H1_{h≫f}.hom.app dM = pushβ_h.map(H1_f.hom.app dM)
  -- ≫ H1_h.hom.app(pf dM) ≫ pbComp.hom.app dM`); cancel `pbComp.hom ≫ pbComp.inv`; slide `H1_h.hom`
  -- past `θ_f.hom` by ONE naturality of the NatTrans `H1_h.hom`; the two `H1_f`/`H1_h` `hom_inv_id`s
  -- then collapse the goal to the PUSHFORWARD-flank identity (**):
  --   (**)  FC.hom.app dM ≫ sDT_{h≫f}
  --           = pushβ_h.map(sDT_f) ≫ sDT_h(M|f) ≫ dualIsoOfIso(rfc).hom.
  -- EVERY step except (**) is pure category/naturality algebra (NO `sliceDualTransport` internals), so
  -- the SOLE genuine residual is (**) — the pushforward-flank `sliceDualTransport` pseudofunctoriality
  -- law.  Closing (**) needs a FORWARD `sliceDualTransport_app_apply` lemma in `SliceTransport.lean`
  -- (only the INVERSE `sliceDualTransportInv_app_apply` exists there) → CROSS-FILE blocked (this lane
  -- owns only `PresheafDualPullback.lean`).  See `task_results/…PresheafDualPullback.lean.md`.
  --
  -- IMPLEMENTATION NOTE (iter-071, verified by `lake build`): the abstract H1-cancellation CANNOT be
  -- run by `rw`/`erw`/`cancel_epi`/`set`/`show` — each does heavy defeq across the `PresheafOfModules`-
  -- over-`Z` defeq-but-not-syntactic `≫` seam and whnf-BOMBS at `maxHeartbeats 3200000` (even
  -- `rw [Iso.inv_comp_eq]` and `set FC` bomb).  The proven cure is the tensor-side device of
  -- `pullbackTensorMap_restrict` (`TensorObjSubstrate.lean:3451`): local copies of the generic
  -- single-`[Category C]` bricks `comp_cancel_mid`/`comp_slide_nested`/`comp_cancel_three_lr`, applied
  -- by `exact`/`refine` (assignment-only unification crosses the seam without whnf).  The next iter
  -- transcribes that brick scaffold here.  `hcoc` is in scope and instantiates cleanly (verified).
  sorry

end Modules

end Scheme

end AlgebraicGeometry

end -- noncomputable section
