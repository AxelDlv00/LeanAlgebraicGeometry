/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate

/-!
# D3′ composition coherence of `pullbackTensorMap` (A.1.c.SubT split)

This file contains the D3′ tail of the substrate file:

- The private helper block `toRingCatSheafHom_comp_hom_reconcile` through
  `forget_map_pushforward_map` (L2183–L2569 of the original `TensorObjSubstrate.lean`).
- The Sq1 sub-lemma `sheafificationCompPullback_comp` (CLOSED axiom-clean iter-314: the `key`
  pushforwardComp cocycle is discharged via `conjugateEquiv_leftAdjointCompIso_inv` +
  `conjugateEquiv_comm`, both presheaf/sheaf `pushforwardComp` being `Iso.refl`).
- The Sq4 chain `pullbackValIso_eq_sheafCompPb` / `sheafCompPb_counit_comp_coherence` /
  `pullbackValIso_comp` (all CLOSED axiom-clean iter-319).
- The outer D3′ lemma `pullbackTensorMap_restrict` (carries the remaining sorry: the 4-square
  interleaved paste Sq1∘Sq2b∘Sq3∘Sq4. All four square coherences are now in-file — Sq1
  `sheafificationCompPullback_comp`, Sq2b `pullbackComp_δ`, Sq4 `pullbackValIso_comp` CLOSED; Sq3
  `sheafifyTensorUnitIso` through `pullbackComp` wired inline. iter-320 landed the first four
  assembly moves (Sq1 expansion, Sq2b rewrite, pullbackComp cancellation, `comp_δ` decomposition);
  the residual sorry is the naturality SLIDE + S3/S4 region, blocked by the giant-term whnf wall
  under `respectTransparency false`).

Extracted from `TensorObjSubstrate.lean` (iter-313 split) so that the LSP can
elaborate the `key` sorry without timing out on the upstream million-heartbeat lemmas.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

section LocTrivPullbackTensor

/-- **Sq2 prerequisite — ring-map reconciliation.** For composable `h : Z ⟶ Y`, `f : Y ⟶ X`,
the structure ring-presheaf map of the composite factors through the whiskered ring maps of `f`
and `h`. This is the presheaf-level identity needed to feed `PresheafOfModules.pullbackComp` into
the oplax `comp_δ` decomposition (Sq2 of `pullbackTensorMap_restrict`). -/
private lemma toRingCatSheafHom_comp_hom_reconcile {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X) :
    (Hom.toRingCatSheafHom (h ≫ f)).hom =
      (Hom.toRingCatSheafHom f).hom ≫
        (TopologicalSpace.Opens.map f.base).op.whiskerLeft (Hom.toRingCatSheafHom h).hom := by
  rfl

/-- **Sectionwise value of the presheaf `restrictScalars` lax tensorator.** The lax μ of
`PresheafOfModules.restrictScalars α`, evaluated at a section `W`, is by definition the `ModuleCat`
lax μ of `restrictScalars (α.app W).hom`. Exposed as a `rfl`-lemma so the heavy ambient term need not
be `whnf`-ed: rewriting with it turns `(μ (restrictScalars α) M₁ M₂).app W` into a `ModuleCat` μ on
which `ModuleCat.restrictScalars_μ_tmul` matches syntactically (a direct `erw` on the presheaf form
`whnf`-explodes). -/
private lemma restrictScalars_μ_app
    {C : Type u} [Category.{u} C] {R S : Cᵒᵖ ⥤ CommRingCat.{u}}
    (α : (R ⋙ forget₂ CommRingCat RingCat) ⟶ (S ⋙ forget₂ CommRingCat RingCat))
    (M₁ M₂ : _root_.PresheafOfModules (S ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ) :
    (Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars α) M₁ M₂).app W
      = Functor.LaxMonoidal.μ (ModuleCat.restrictScalars (α.app W).hom)
          (M₁.obj W) (M₂.obj W) := rfl

/-- **Pure-tensor value of the `ModuleCat` `restrictScalars` lax tensorator, in `ModuleCat.Hom.hom`
application form, with `forget₂`-carrier rings.** Bridges `ModuleCat.restrictScalars_μ_tmul` (stated
with the bundled coercion) to the `ModuleCat.Hom.hom`-applied form goals carry after
`ModuleCat.hom_comp`/`LinearMap.comp_apply`.  The source/target rings are `forget₂`-carriers of
presheaves of *commutative* rings (`Rc.obj W'`, `Sc.obj W'`), so the `CommRing` instances the goal's
`⊗ₜ` carries (coming from `CommRingCat`) are exactly the ones the statement uses — a generic
`Type`-level form fails to synthesise `CommRing` on a bare `RingCat` carrier.  Applied in context to
the goal's heavy objects as explicit arguments and discharged by `erw` (matching only the residual
defeq instance differences, no `whnf` of the heavy `pushforward₀` sections, which would explode). -/
private lemma forget₂_restrictScalars_μ_hom_tmul
    {C : Type u} [Category.{u} C] {Rc Sc : Cᵒᵖ ⥤ CommRingCat.{u}} {W' : Cᵒᵖ}
    (f : (Rc ⋙ forget₂ CommRingCat RingCat).obj W' ⟶ (Sc ⋙ forget₂ CommRingCat RingCat).obj W')
    (M₁ M₂ : ModuleCat.{u} ((Sc ⋙ forget₂ CommRingCat RingCat).obj W'))
    (m : M₁) (n : M₂) :
    ModuleCat.Hom.hom (Functor.LaxMonoidal.μ (ModuleCat.restrictScalars f.hom) M₁ M₂)
        (m ⊗ₜ[(Rc ⋙ forget₂ CommRingCat RingCat).obj W'] n) = m ⊗ₜ n :=
  ModuleCat.restrictScalars_μ_tmul f.hom M₁ M₂ m n

/-- **Pure-tensor value of the presheaf `restrictScalars` lax tensorator (full collapse).**
On a pure tensor, `(μ (restrictScalars α) M₁ M₂).app W` is the identity.  Combines
`restrictScalars_μ_app` (rfl, exposes the `ModuleCat` μ) with `ModuleCat.restrictScalars_μ_tmul`.
Stated with `M₁ M₂` as *atoms*, so the proof never `whnf`s heavy ambient objects; in context it is
`rw`-applied with `R`, `S` pinned (the `forget₂`-association the goal carries), so keyed matching
succeeds without `whnf`. -/
private lemma restrictScalars_μ_app_tmul
    {C : Type u} [Category.{u} C] {R S : Cᵒᵖ ⥤ CommRingCat.{u}}
    (α : (R ⋙ forget₂ CommRingCat RingCat) ⟶ (S ⋙ forget₂ CommRingCat RingCat))
    (M₁ M₂ : _root_.PresheafOfModules (S ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ)
    (m : (M₁.obj W)) (n : (M₂.obj W)) :
    ModuleCat.Hom.hom ((Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars α) M₁ M₂).app W)
        (m ⊗ₜ[(R ⋙ forget₂ CommRingCat RingCat).obj W] n) = m ⊗ₜ n := by
  rw [restrictScalars_μ_app]
  exact ModuleCat.restrictScalars_μ_tmul (α.app W).hom (M₁.obj W) (M₂.obj W) m n

/-- **Pure-tensor value of the `pushforward`-mapped `restrictScalars` lax tensorator.**  The "outer
leg" of `pushforwardComp_lax_μ`: `((pushforward φ).map (μ (restrictScalars ψ) N₁ N₂)).app W` applied
to a pure tensor is the identity.  Reindexes through `pushforward_map_app_apply` (`pushforward φ` is
`pushforward₀ ⋙ restrictScalars φ`, so the section map at `W` is the `μ` at `F.op.obj W`), then
collapses by `restrictScalars_μ_app_tmul`.  `N₁ N₂` are *atoms*; in context the lemma is applied to
the goal's heavy objects as explicit arguments and discharged by `erw` (which matches the residual
defeq instance differences without `whnf`-ing the heavy objects). -/
private lemma pushforward_map_restrictScalars_μ_app_tmul
    {C D E : Type u} [Category.{u} C] [Category.{u} D] [Category.{u} E]
    {F : C ⥤ D} {G : D ⥤ E}
    {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}} {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {T₀ : Eᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (ψ : (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      G.op ⋙ (T₀ ⋙ forget₂ CommRingCat RingCat))
    (N₁ N₂ : _root_.PresheafOfModules ((G.op ⋙ T₀) ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ)
    (m : (N₁.obj (F.op.obj W))) (n : (N₂.obj (F.op.obj W))) :
    ModuleCat.Hom.hom
        (((PresheafOfModules.pushforward φ).map
          (Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars
            (show (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
              ((G.op ⋙ T₀) ⋙ forget₂ CommRingCat RingCat) from ψ)) N₁ N₂)).app W)
        (m ⊗ₜ[(R₀ ⋙ forget₂ CommRingCat RingCat).obj (F.op.obj W)] n) = m ⊗ₜ n := by
  erw [PresheafOfModules.pushforward_map_app_apply]
  exact restrictScalars_μ_app_tmul _ N₁ N₂ (F.op.obj W) m n

/-- **Reduction of the `pushforward` lax tensorator to the `restrictScalars` μ (morphism level).**
The lax μ of a single `PresheafOfModules.pushforward φ` equals the lax μ of the change-of-rings
`restrictScalars φ'` on the (strongly-monoidal, `μIso = refl`) reindexed objects
`pushforward₀OfCommRingCat F R₀`. This unfolds the opaque `presheafPushforwardLaxMonoidal` μ (the
`Functor.LaxMonoidal.comp` of `pushforward₀`'s μ = identity and `restrictScalars`'s μ) to the
directly-computable `restrictScalars` μ — staying at the `PresheafOfModules` morphism level so the
`(presheaf-tensor).obj W` vs `ModuleCat`-tensor mismatch never surfaces. Mirrors the ε-twin
`epsilonPresheafToSheafUnit`. -/
private lemma pushforward_μ_eq
    {C D : Type u} [Category.{u} C] [Category.{u} D] {F : C ⥤ D}
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (A B : _root_.PresheafOfModules (R₀ ⋙ forget₂ CommRingCat RingCat)) :
    letI φ' : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
        (F.op ⋙ R₀) ⋙ forget₂ CommRingCat RingCat := φ
    Functor.LaxMonoidal.μ (PresheafOfModules.pushforward φ) A B
      = Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars φ')
          ((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj A)
          ((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj B) := by
  rfl

/-- **Sq2b residual — the lax-μ composition coherence of `PresheafOfModules.pushforward`
(monoidality of `pushforwardComp`).** Since `PresheafOfModules.pushforwardComp φ ψ = Iso.refl`,
the right-adjoint side of Sq2b reduces to the statement that the lax tensorator `μ` of the
*composite* pushforward `pushforward ψ ⋙ pushforward φ` (built by `Functor.LaxMonoidal.comp`)
agrees with the lax tensorator of the *single* pushforward `pushforward (φ ≫ F.op ◁ ψ)` (built by
`presheafPushforwardLaxMonoidal`).

**Status (iter-261): CLOSED, axiom-clean.** The equality is genuinely *not* `rfl`/`simp` at the
presheaf level (the `restrictScalars` μ on a pure tensor is real `ModuleCat` base-change content,
`ModuleCat.restrictScalars_μ_tmul`, not definitional).  The working route is sectionwise +
pure-tensor reduction: `Functor.LaxMonoidal.comp_μ` unfolds the composite μ, `pushforward_μ_eq`
lightens each `μ (pushforward _)` to a `restrictScalars` μ, and each leg is then collapsed to the
identity by the atomic-object helpers `forget₂_restrictScalars_μ_hom_tmul` (inner) and
`pushforward_map_restrictScalars_μ_app_tmul` (the `(pushforward φ).map …` leg, reindexed by
`pushforward_map_app_apply`).  Both helpers are applied to the goal's concrete objects as explicit
arguments and matched by `erw` — this is the only way to avoid the `whnf`-explosion that a direct
`rw`/`erw`/`simp` of `ModuleCat.restrictScalars_μ_tmul` triggers on the heavy `pushforward₀`
sections.  After both legs collapse, the LHS pure tensor is defeq to the RHS single-pushforward μ on
the same tensor, closing the goal. -/
private lemma pushforwardComp_lax_μ
    {C D E : Type u} [Category.{u} C] [Category.{u} D] [Category.{u} E]
    {F : C ⥤ D} {G : D ⥤ E}
    {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}} {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {T₀ : Eᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (ψ : (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      G.op ⋙ (T₀ ⋙ forget₂ CommRingCat RingCat))
    [(PresheafOfModules.pushforward φ).IsRightAdjoint]
    [(PresheafOfModules.pushforward ψ).IsRightAdjoint]
    (X Y : _root_.PresheafOfModules (T₀ ⋙ forget₂ CommRingCat RingCat)) :
    Functor.LaxMonoidal.μ
        (PresheafOfModules.pushforward ψ ⋙ PresheafOfModules.pushforward φ) X Y =
      Functor.LaxMonoidal.μ
        (PresheafOfModules.pushforward (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)) X Y := by
  -- PROOF (iter-261): the equality is checked sectionwise (`hom_ext`) and on pure tensors
  -- (`tensor_ext`).  `Functor.LaxMonoidal.comp_μ` unfolds the composite μ to
  --   `μ (pushforward φ) (..) (..)  ≫  (pushforward φ).map (μ (pushforward ψ) X Y)`,
  -- and `pushforward_μ_eq` (×2) reduces each `μ (pushforward _)` to the lighter
  -- `μ (restrictScalars _)` on the strong-monoidal `pushforward₀` objects.  On a pure tensor every
  -- `restrictScalars` μ is the identity (`ModuleCat.restrictScalars_μ_tmul`): the inner leg is
  -- collapsed by `forget₂_restrictScalars_μ_hom_tmul` (`hinner`) and the `(pushforward φ).map …`
  -- leg by `pushforward_map_restrictScalars_μ_app_tmul` (`houter`, which reindexes the section map to
  -- `F.op.obj W` via `pushforward_map_app_apply` and collapses there).  After both legs the LHS is
  -- `m ⊗ₜ n`, which is defeq to the RHS single-pushforward μ on the same pure tensor — so the final
  -- `erw [houter]` closes the goal by its trailing `rfl`.  The heavy `pushforward₀` sections never
  -- get `whnf`-ed: all collapse lemmas are stated with atomic objects and applied to the goal's
  -- concrete objects as explicit arguments, then matched by `erw` up to the residual defeq
  -- `forget₂`-association / instance differences only.
  refine PresheafOfModules.hom_ext (fun W => ?_)
  refine ModuleCat.MonoidalCategory.tensor_ext (fun m n => ?_)
  rw [Functor.LaxMonoidal.comp_μ]
  rw [pushforward_μ_eq, pushforward_μ_eq]
  rw [PresheafOfModules.comp_app]
  erw [ModuleCat.hom_comp, LinearMap.comp_apply]
  rw [restrictScalars_μ_app (R := S₀) (S := F.op ⋙ R₀)]
  have hinner := forget₂_restrictScalars_μ_hom_tmul (Rc := S₀) (Sc := F.op ⋙ R₀) (φ.app W)
    (((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj ((PresheafOfModules.pushforward ψ).obj X)).obj W)
    (((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj ((PresheafOfModules.pushforward ψ).obj Y)).obj W)
    m n
  erw [hinner]
  have houter := pushforward_map_restrictScalars_μ_app_tmul φ ψ
    ((PresheafOfModules.pushforward₀OfCommRingCat G T₀).obj X)
    ((PresheafOfModules.pushforward₀OfCommRingCat G T₀).obj Y) W m n
  erw [houter]

/-- **Sq2b — monoidality of `PresheafOfModules.pullbackComp` (the δ-transport across the
left-adjoint composition iso).** The presheaf-level core of D3′: the canonical oplax comparison
`δ` of the pullback for a composite ring map `φ ≫ F.op ◁ ψ` transports, through the pullback
pseudofunctor coherence `pullbackComp φ ψ`, into the `Functor.OplaxMonoidal.comp` comparison of
the composite `pullback φ ⋙ pullback ψ`.

This is the η→δ analogue of `pullbackObjUnitToUnit_comp`, proved at the `PresheafOfModules` level
(dissolving the `forget₂`-instance / associativity / reconcile frictions of working at the
`Scheme`/`forget₂` level). The proof is the adjunction-mate calculus: transpose under
`pullbackPushforwardAdjunction (φ ≫ F.op ◁ ψ)`, rewrite the oplax δ as the mate of the lax μ
(`Adjunction.unit_app_tensor_comp_map_δ`), and use the conjugate identity
`conjugateEquiv_leftAdjointCompIso_inv` (here `pushforwardComp = Iso.refl`, so the mate of
`pullbackComp.inv` is the identity). The sole residual is the lax-μ composition coherence of
`PresheafOfModules.pushforward` across `pushforwardComp` (`pushforwardComp_lax_μ`). -/
private lemma pullbackComp_δ
    {C D E : Type u} [Category.{u} C] [Category.{u} D] [Category.{u} E]
    {F : C ⥤ D} {G : D ⥤ E}
    {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}} {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {T₀ : Eᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (ψ : (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      G.op ⋙ (T₀ ⋙ forget₂ CommRingCat RingCat))
    [(PresheafOfModules.pushforward φ).IsRightAdjoint]
    [(PresheafOfModules.pushforward ψ).IsRightAdjoint]
    (M N : _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat)) :
    Functor.OplaxMonoidal.δ
        (PresheafOfModules.pullback (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)) M N =
      (PresheafOfModules.pullbackComp φ ψ).inv.app (M ⊗ N) ≫
        Functor.OplaxMonoidal.δ
          (PresheafOfModules.pullback φ ⋙ PresheafOfModules.pullback ψ) M N ≫
        ((PresheafOfModules.pullbackComp φ ψ).hom.app M ⊗ₘ
          (PresheafOfModules.pullbackComp φ ψ).hom.app N) := by
  -- MATE CALCULUS (iter-259 derivation; reduces Sq2b to `pushforwardComp_lax_μ`).
  -- Transpose both sides under `aχ.homEquiv` (`aχ := pullbackPushforwardAdjunction (φ ≫ F.op ◁ ψ)`):
  apply (PresheafOfModules.pullbackPushforwardAdjunction
    (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat)
    (φ ≫ F.op.whiskerLeft ψ)).homEquiv _ _ |>.injective
  -- Both sides become `aχ.unit (M⊗N) ≫ (pushforward χ).map (…)`:
  rw [Adjunction.homEquiv_unit, Adjunction.homEquiv_unit]
  -- The remaining reduction (verified on paper; the wiring `rw`s are mechanical but fragile, and
  -- the *only* genuine gap is `pushforwardComp_lax_μ`, which is `rfl`-FALSE — see below):
  --
  --   LHS = aχ.unit(M⊗N) ≫ (pushforward χ).map (δ (pullback χ) M N)
  --       = (aχ.unit M ⊗ₘ aχ.unit N) ≫ μ(pushforward χ) (pullback χ M) (pullback χ N)
  --                                          [Adjunction.unit_app_tensor_comp_map_δ (adj := aχ)]
  --
  --   RHS = aχ.unit(M⊗N) ≫ (pushforward χ).map (c.inv(M⊗N) ≫ comp_δ ≫ (c.hom M ⊗ₘ c.hom N))
  --       where c := pullbackComp φ ψ.  Expand `map_comp`, then:
  --   (MATE)   aχ.unit(M⊗N) ≫ (pushforward χ).map (c.inv(M⊗N)) = aC.unit(M⊗N)
  --                              [Adjunction.unit_conjugateEquiv + conjugateEquiv_leftAdjointCompIso_inv;
  --                               here pushforwardComp = Iso.refl ⇒ the conjugate of c.inv is 𝟙, so the
  --                               `pc.hom` factor vanishes]   (aC := aφ.comp aψ)
  --   (U-C)    aC.unit(M⊗N) ≫ (pushforward ψ ⋙ pushforward φ).map (comp_δ) =
  --              (aC.unit M ⊗ₘ aC.unit N) ≫ μ(pushforward ψ ⋙ pushforward φ) (LM) (LN)
  --                              [Adjunction.unit_app_tensor_comp_map_δ (adj := aC); aC.IsMonoidal via
  --                               Adjunction.isMonoidal_comp; (pushforward χ).map ≡ (G'⋙G).map defeq]
  --   (μ-NAT)  μ(pushforward χ) (LM)(LN) ≫ (pushforward χ).map (c.hom M ⊗ₘ c.hom N) =
  --              ((pushforward χ).map (c.hom M) ⊗ₘ (pushforward χ).map (c.hom N)) ≫
  --                μ(pushforward χ) (pullback χ M) (pullback χ N)   [Functor.LaxMonoidal.μ_natural]
  --   (TRI)    aC.unit P ≫ (pushforward χ).map (c.hom P) = aχ.unit P   [(MATE) + c.inv ≫ c.hom = 𝟙]
  --   tensorHom_comp_tensorHom merges the three ⊗ₘ legs; with (TRI) the RHS becomes
  --              (aχ.unit M ⊗ₘ aχ.unit N) ≫ μ(pushforward ψ ⋙ pushforward φ) (pullback χ M)(pullback χ N).
  --
  -- LHS = RHS then holds IFF
  --   μ(pushforward ψ ⋙ pushforward φ) X Y = μ(pushforward χ) X Y   (= `pushforwardComp_lax_μ`).
  -- This is the SOLE residual.  It is NOT `rfl` (the `d3sq2b258` recipe's "rfl/short ext" prediction
  -- is empirically false): it is a genuine `ModuleCat` change-of-rings base-change coherence
  -- (`ModuleCat.restrictScalarsComp` / `homEquiv_extendScalarsComp`), with NO analog in the
  -- `rfl`-closed unit twin `unitToPushforwardObjUnit_comp`.  Pinned as `pushforwardComp_lax_μ` above.
  -- The mate-`rw` wiring of the steps above is left for the follow-up (each step's Mathlib lemma is
  -- named); the reduction itself is complete.  The LHS step (U) is wired here:
  erw [Adjunction.unit_app_tensor_comp_map_δ
    (adj := PresheafOfModules.pullbackPushforwardAdjunction
      (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ))]
  -- (MATE): the conjugate/mate of `pullbackComp.inv` is `pushforwardComp.hom = 𝟙`.
  -- (MATE) — the conjugate of `pullbackComp.inv` is `pushforwardComp.hom = 𝟙`:
  have hconj : conjugateEquiv
        ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
          (PresheafOfModules.pullbackPushforwardAdjunction ψ))
        (PresheafOfModules.pullbackPushforwardAdjunction
          (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ))
        (PresheafOfModules.pullbackComp φ ψ).inv = 𝟙 _ := by
    simp only [PresheafOfModules.pullbackComp, Adjunction.conjugateEquiv_leftAdjointCompIso_inv,
      PresheafOfModules.pushforwardComp, Iso.refl_hom]
  have hmate : ∀ (P : _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat)),
      (PresheafOfModules.pullbackPushforwardAdjunction
          (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat)
          (φ ≫ F.op.whiskerLeft ψ)).unit.app P ≫
        (PresheafOfModules.pushforward (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)).map
          ((PresheafOfModules.pullbackComp φ ψ).inv.app P) =
      ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
        (PresheafOfModules.pullbackPushforwardAdjunction ψ)).unit.app P := by
    intro P
    have hu := unit_conjugateEquiv
      ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
        (PresheafOfModules.pullbackPushforwardAdjunction ψ))
      (PresheafOfModules.pullbackPushforwardAdjunction
        (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ))
      (PresheafOfModules.pullbackComp φ ψ).inv P
    rw [hconj] at hu
    simp only [NatTrans.id_app, Category.comp_id] at hu
    exact hu.symm
  -- Expand the RHS `map` of the composite and apply (MATE):
  rw [Functor.map_comp, Functor.map_comp]
  erw [reassoc_of% (hmate (M ⊗ N))]
  -- (U-C): rewrite `aC.unit(M⊗N) ≫ map(comp_δ)` via the mate of the composite adjunction `aC`:
  erw [reassoc_of% (Adjunction.unit_app_tensor_comp_map_δ
    (adj := (PresheafOfModules.pullbackPushforwardAdjunction φ).comp
      (PresheafOfModules.pullbackPushforwardAdjunction ψ)) M N)]
  -- (μ-COH): replace the composite-pushforward μ by the χ-pushforward μ (the genuine residual):
  rw [pushforwardComp_lax_μ φ ψ]
  -- (TRI): for any `P`, `aC.unit P ≫ (pushforward χ).map (c.hom P) = aχ.unit P`.
  have htri : ∀ (P : _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat)),
      ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
          (PresheafOfModules.pullbackPushforwardAdjunction ψ)).unit.app P ≫
        (PresheafOfModules.pushforward (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)).map
          ((PresheafOfModules.pullbackComp φ ψ).hom.app P) =
      (PresheafOfModules.pullbackPushforwardAdjunction
        (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat)
        (φ ≫ F.op.whiskerLeft ψ)).unit.app P := by
    intro P
    erw [← reassoc_of% (hmate P)]
    erw [← Functor.map_comp]
    erw [(PresheafOfModules.pullbackComp φ ψ).inv_hom_id_app P, CategoryTheory.Functor.map_id,
      Category.comp_id]
  -- (μ-NAT): slide μ past `map (c.hom ⊗ c.hom)`, merge the legs, then apply (TRI):
  erw [← Functor.LaxMonoidal.μ_natural]
  conv_lhs => rw [← htri M, ← htri N]
  erw [← MonoidalCategory.tensorHom_comp_tensorHom
    (C := _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat))]
  exact Category.assoc _ _ _

/-- **Mate compatibility of `homEquiv` (project-local copy of `GlueDescent`'s device).** For
adjunctions `adj₁ : L₁ ⊣ R₁`, `adj₂ : L₂ ⊣ R₂` and `α : L₂ ⟶ L₁`, transposing `α.app c ≫ f` under
`adj₂` equals transposing `f` under `adj₁` post-composed with the conjugate transformation
`conjugateEquiv adj₁ adj₂ α` at `d`. This is the anti-circularity device of the D3′ Sq1 mate
calculus: it lets the leading `pullbackComp` factor of the transposed `sheafificationCompPullback_comp`
goal be peeled while keeping `pullbackComp` OPAQUE (term-mode `.trans`, no `rw` on the iso). It is a
verbatim copy of `AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app`
(`GlueDescent.lean:367`), reproduced here because `GlueDescent` is not imported by this file.
Derived from `CategoryTheory.unit_conjugateEquiv` + naturality of the conjugate. Project-local. -/
private lemma homEquiv_conjugateEquiv_app' {𝒞 𝒟 : Type*} [CategoryTheory.Category 𝒞]
    [CategoryTheory.Category 𝒟] {L₁ L₂ : 𝒞 ⥤ 𝒟} {R₁ R₂ : 𝒟 ⥤ 𝒞}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (α : L₂ ⟶ L₁) {c : 𝒞} {d : 𝒟}
    (f : L₁.obj c ⟶ d) :
    adj₂.homEquiv c d (α.app c ≫ f)
      = adj₁.homEquiv c d f ≫ (CategoryTheory.conjugateEquiv adj₁ adj₂ α).app d := by
  have h1 := CategoryTheory.unit_conjugateEquiv adj₁ adj₂ α c
  have huA : adj₂.homEquiv c d (α.app c ≫ f)
      = adj₂.unit.app c ≫ R₂.map (α.app c ≫ f) :=
    Adjunction.homEquiv_unit adj₂ c d (α.app c ≫ f)
  have huB : adj₁.homEquiv c d f = adj₁.unit.app c ≫ R₁.map f :=
    Adjunction.homEquiv_unit adj₁ c d f
  have e1 : adj₂.homEquiv c d (α.app c ≫ f)
      = (adj₂.unit.app c ≫ R₂.map (α.app c)) ≫ R₂.map f :=
    huA.trans <| (CategoryTheory.whisker_eq (adj₂.unit.app c) (R₂.map_comp (α.app c) f)).trans
      (Category.assoc _ _ _).symm
  have e2 : adj₁.homEquiv c d f ≫ (CategoryTheory.conjugateEquiv adj₁ adj₂ α).app d
      = (adj₁.unit.app c ≫ (CategoryTheory.conjugateEquiv adj₁ adj₂ α).app (L₁.obj c))
          ≫ R₂.map f :=
    (CategoryTheory.eq_whisker huB
        ((CategoryTheory.conjugateEquiv adj₁ adj₂ α).app d)).trans <|
      (Category.assoc _ _ _).trans <|
        (CategoryTheory.whisker_eq (adj₁.unit.app c)
          ((CategoryTheory.conjugateEquiv adj₁ adj₂ α).naturality f)).trans
          (Category.assoc _ _ _).symm
  exact e1.trans ((CategoryTheory.eq_whisker h1.symm (R₂.map f)).trans e2.symm)

/-- **Sheaf-level conjugate/mate of `pullbackComp.inv` (the R0-peel building block for Sq1).**
For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and any `Q : X.Modules`, the unit of the
composite-pullback adjunction `pullbackPushforwardAdjunction (h ≫ f)`, post-composed with the
pushforward of `pullbackComp.inv`, equals the unit of the *composite* of the `f`- and `h`-adjunctions,
post-composed with `pushforwardComp.hom`.  This is the `Scheme.Modules` (sheaf-level) instance of
`unit_conjugateEquiv` combined with `conjugateEquiv_pullbackComp_inv` (the mate of `pullbackComp.inv`
is `pushforwardComp.hom`); it is the cheap, sheafification-free piece of the Sq1 mate calculus that
peels the leading `R0 = pullbackComp.inv` factor.  Extracted from the inline `conj` of
`pullbackObjUnitToUnit_comp` so the (expensive, sheafification-laden) Sq1 reassembly can cite it
directly.  Project-local. -/
private lemma sheaf_unit_comp_pushforward_pullbackComp_inv {X Y Z : Scheme.{u}}
    (h : Z ⟶ Y) (f : Y ⟶ X) (Q : X.Modules) :
    (SheafOfModules.pullbackPushforwardAdjunction (Scheme.Hom.toRingCatSheafHom (h ≫ f))).unit.app Q ≫
        (SheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom (h ≫ f))).map
          ((Scheme.Modules.pullbackComp h f).inv.app Q) =
      ((Scheme.Modules.pullbackPushforwardAdjunction f).comp
          (Scheme.Modules.pullbackPushforwardAdjunction h)).unit.app Q ≫
        (Scheme.Modules.pushforwardComp h f).hom.app
          ((Scheme.Modules.pullback f ⋙ Scheme.Modules.pullback h).obj Q) := by
  have conj := unit_conjugateEquiv
    ((Scheme.Modules.pullbackPushforwardAdjunction f).comp
      (Scheme.Modules.pullbackPushforwardAdjunction h))
    (Scheme.Modules.pullbackPushforwardAdjunction (h ≫ f))
    (Scheme.Modules.pullbackComp h f).inv Q
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv] at conj
  exact conj.symm

/-- **STEP-1 bridge (presheaf↔sheaf pushforward compatibility, the binding obligation of the D3′
Sq1 tail).** The forgetful functor `SheafOfModules.forget` intertwines the sheaf-level
`SheafOfModules.pushforward φ` with the presheaf-level `PresheafOfModules.pushforward φ.hom`:
for any morphism `g` of sheaves of modules over `R`,
`forget.map ((pushforward φ).map g) = (PresheafOfModules.pushforward φ.hom).map (forget.map g)`.

This is the compatibility named in the blueprint's `lem:pullback_tensor_map_basechange` Sq1-tail
binding-obligation paragraph: it is what lets the recovered sheaf-level `B_f`/`B_h` unit factors
(which live under `SheafOfModules.pushforward`) be slid across into the presheaf-level
`PresheafOfModules.pushforward` of the unit identity.  It is *definitional* — `SheafOfModules.pushforward`
is built sectionwise from `PresheafOfModules.pushforward` (`pushforward_map_val`) and `forget` is the
`.val` projection (`forget_map`), so the two sides are equal by `rfl`. -/
private lemma forget_map_pushforward_map
    {C : Type u} [Category.{u} C] {D : Type u} [Category.{u} D]
    {J : GrothendieckTopology C} {K : GrothendieckTopology D} {F : C ⥤ D}
    {S : Sheaf J RingCat.{u}} {R : Sheaf K RingCat.{u}} [Functor.IsContinuous F J K]
    (φ : S ⟶ (F.sheafPushforwardContinuous RingCat.{u} J K).obj R)
    {A B : SheafOfModules.{u} R} (g : A ⟶ B) :
    (SheafOfModules.forget S).map ((SheafOfModules.pushforward φ).map g) =
      (PresheafOfModules.pushforward φ.hom).map ((SheafOfModules.forget R).map g) := by
  rfl

-- The mate-calculus telescope (transpose under the composite adjunction `A_{h≫f}`, the R0-kill via
-- `homEquiv_conjugateEquiv_app'`, the adj₁ split, and the R1-peel `hnatL`) elaborates the heavy
-- sheafification-laden `homEquiv` composites, exceeding the default 200000 heartbeat budget.
-- iter-310 SHARED KEY (`analogies/pullback-spelling-310.md`): the back-compat isDefEq path re-runs the
-- expensive transparency-respecting unfold loop on the opaque `Lan`-built `leftAdjoint`
-- (`Scheme.Modules.pullback f = SheafOfModules.pullback f.toRingCatSheafHom`).  Mathlib applies this
-- knob to EXACTLY these pullback-cocycle lemmas (Sheaf.lean:244/261/275/289); it stops the monolithic
-- `Scheme.Modules.pullback f ≟ SheafOfModules.pullback (toRingCatSheafHom f)` defeq from detonating.
set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 3200000 in
/-- **Sq1 — composition coherence of `SheafOfModules.sheafificationCompPullback` (the S1 paste
square of D3′).** For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and any presheaf of
modules `P` over `X`, the sheafification–pullback comparison of the composite `h ≫ f` factors
through the comparisons of `f` and `h`, conjugated by the sheaf-level pullback pseudofunctor iso
`Scheme.Modules.pullbackComp h f` on the left and the presheaf-level pullback pseudofunctor iso
`PresheafOfModules.pullbackComp φ'_f φ'_h` (sheafified) on the right. Mathlib-absent at the pin;
the S1-foundational composition coherence consumed by `pullbackTensorMap_restrict`. It is the
`sheafificationCompPullback` twin of `pullbackObjUnitToUnit_comp`: both `sheafificationCompPullback`
isos are `leftAdjointUniq` of composite adjunctions (`sheafificationCompPullback_eq_leftAdjointUniq`),
so the coherence is proved by the adjunction-mate calculus, transposing under the composite
`A_{h≫f} = (sheafAdj_X).comp (pullbackPushforwardAdjunction (h≫f))`. -/
private lemma sheafificationCompPullback_comp {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (P : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app P).hom =
      (Scheme.Modules.pullbackComp h f).inv.app
          ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj P) ≫
        (Scheme.Modules.pullback h).map
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app P).hom ≫
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj P)).hom ≫
        (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.val)).map
          ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
            (Hom.toRingCatSheafHom h).hom).hom.app P) := by
  -- **iter-310 conjugate-calculus RECAST (replaces the walled homEquiv telescope).**
  -- The telescope (transpose under `A_{h≫f}`, R0-kill, R1-peel) reaches a residual whose h-comparison
  -- has NO sheafification partner free in a single transpose (`sheafAdj_Y` must be slid in by hand) —
  -- the iter-308 wall.  The recast (`analogies/d3-mate-recast-309.md`) sidesteps it: reduce to the
  -- NatTrans-level cocycle `key`, whose proof is the free-middle `conjugateEquiv_comp` fusion (the
  -- middle adjunction absorbs `sheafAdj_Y`).  Reducing the goal to `key` is the iter-309 wall
  -- (`NatTrans.congr_app` `isDefEq`-detonating on `Scheme.Modules.pullback ≟ SheafOfModules.pullback
  -- (toRingCatSheafHom ·)` at the whisker junctions); the iter-310 shared knob
  -- `backward.isDefEq.respectTransparency false` (now set on this lemma) is what lets it through.
  -- iter-309 TOOLING UNBLOCK: the `a_Z = sheafification (𝟙)` whisker needs `IsLocallyInjective (𝟙)`,
  -- which global synthesis misses (it finds only `IsLocallySurjective (𝟙)`); supply it (𝟙 is iso).
  haveI : Presheaf.IsLocallyInjective (Opens.grothendieckTopology ↥Z) (𝟙 (Sheaf.val Z.ringCatSheaf)) :=
    Presheaf.instIsLocallyInjectiveOfIsIsoFunctorOpposite _ _
  haveI : Presheaf.IsLocallySurjective (Opens.grothendieckTopology ↥Z) (𝟙 (Sheaf.val Z.ringCatSheaf)) :=
    Presheaf.isLocallySurjective_of_iso (Opens.grothendieckTopology ↥Z) (𝟙 (Sheaf.val Z.ringCatSheaf))
  have key : (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).hom
      = Functor.whiskerLeft (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val))
            (Scheme.Modules.pullbackComp h f).inv ≫
          Functor.whiskerRight
            (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom
            (Scheme.Modules.pullback h) ≫
          Functor.whiskerLeft (PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom)
            (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom ≫
          Functor.whiskerRight
            (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
              (Hom.toRingCatSheafHom h).hom).hom
            (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.val)) := by
    -- The free-middle conjugate fusion (`analogies/d3-mate-recast-309.md`, steps 1–5): pass to
    -- inverses where `(sheafCompPb φ).inv = (conjugateEquiv A_φ B_φ).symm (𝟙 R_φ)`
    -- (`sheafificationCompPullback_eq_leftAdjointUniq`, in-file L1603), apply the injective
    -- `conjugateEquiv A_{h≫f} B_{h≫f}` (LHS ↦ `𝟙` by `conjugateEquiv_id`), then expose the four
    -- whiskered RHS conjugates with `conjugateEquiv_whiskerLeft`/`conjugateEquiv_whiskerRight` and
    -- fuse with `conjugateEquiv_comp` (×3), whose FREE middle adjunctions M₁,M₂,M₃ carry the
    -- intermediate-scheme sheafifications.  The pullbackComp factors collapse via
    -- `Scheme.Modules.conjugateEquiv_pullbackComp_inv` (sheaf side) against the presheaf
    -- `PresheafOfModules.pullbackComp` cocycle; the two `sheafCompPb f`/`sheafCompPb h` factors are
    -- identity conjugates (`conjugateEquiv_id`).  The residual is the strict `pushforwardComp`
    -- presheaf cocycle (`rfl`).  This fusion is the genuine remaining mathematical work.
    -- STEP 1 (concrete, entry point for the bridge): put the LHS comparison into `leftAdjointUniq`
    -- form, on which `(leftAdjointUniq A B).inv = (conjugateEquiv A B).symm (𝟙 R)` (the `rfl` bridge).
    rw [sheafificationCompPullback_eq_leftAdjointUniq (h ≫ f)]
    -- Name the leaf adjunctions (keep the `.comp` structure visible so the conjugate-calculus
    -- whisker lemmas can fire).
    set aX := PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf)) with haX
    set aZ := PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val Z.ringCatSheaf)) with haZ
    set shf := SheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom (h ≫ f)) with hshf
    set prf := PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom (h ≫ f)).hom
      with hprf
    -- STEP 2: `(leftAdjointUniq A B).hom = (conjugateEquiv B A).symm (𝟙 R)` (the `rfl` bridge), then
    -- transpose the `𝟙` across the equiv (`Equiv.symm_apply_eq`) to land on the pushforward side.
    rw [show ((aX.comp shf).leftAdjointUniq (prf.comp aZ)).hom
          = (conjugateEquiv (prf.comp aZ) (aX.comp shf)).symm (𝟙 _) from rfl,
        Equiv.symm_apply_eq]
    symm
    -- Name the intermediate-scheme leaf adjunctions used by the conjugate telescope.
    set aY := PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val Y.ringCatSheaf)) with haY
    set shfF := SheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom f) with hshfF
    set shfH := SheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom h) with hshfH
    set prF := PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom f).hom with hprF
    set prH := PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom h).hom with hprH
    -- STEP 3: telescope `conjugateEquiv B A (R₁ ≫ R₂ ≫ R₃ ≫ R₄)` into four single-leg conjugates
    -- via `conjugateEquiv_comp` (×3), choosing the whiskerRight-friendly left-associated middles
    -- `M₀ = (aX∘shfF)∘shfH`, `M₁ = (prF∘aY)∘shfH`, `M₂ = (prF∘prH)∘aZ`.
    rw [← conjugateEquiv_comp (prf.comp aZ) ((aX.comp shfF).comp shfH) (aX.comp shf)]
    rw [← conjugateEquiv_comp (prf.comp aZ) ((prF.comp aY).comp shfH) ((aX.comp shfF).comp shfH)]
    rw [← conjugateEquiv_comp (prf.comp aZ) ((prF.comp prH).comp aZ) ((prF.comp aY).comp shfH)]
    -- `Adjunction.comp` is associative (`Adjunction.ext <;> rfl`); used to swing the whiskerLeft
    -- factors (F1, F3) into the `adj.comp _` shape their whisker lemma needs.
    have eassoc0 : (aX.comp shfF).comp shfH = aX.comp (shfF.comp shfH) := by
      apply Adjunction.ext <;> intros <;> rfl
    have eassoc1 : (prF.comp aY).comp shfH = prF.comp (aY.comp shfH) := by
      apply Adjunction.ext <;> intros <;> rfl
    have eassoc2 : (prF.comp prH).comp aZ = prF.comp (prH.comp aZ) := by
      apply Adjunction.ext <;> intros <;> rfl
    -- STEP 4: the two middle conjugates F2, F3 collapse to `𝟙`.  Each inner conjugate is the conjugate
    -- of `(sheafificationCompPullback _).hom = (leftAdjointUniq A B).hom = (conjugateEquiv B A).symm 𝟙`,
    -- hence `𝟙` by `Equiv.apply_symm_apply`; whiskering an identity is an identity.
    -- `erw` (not `rw`) is needed for the whisker lemmas: the whiskered functor is `Scheme.Modules.pullback`
    -- (over the topological-space site), defeq-but-not-syntactic to the `SheafOfModules.pullback` over the
    -- Grothendieck site that the leaf adjunctions carry (the iter-309 Scheme/Sheaf bridge).
    have hF2 : (conjugateEquiv ((prF.comp aY).comp shfH) ((aX.comp shfF).comp shfH))
        (Functor.whiskerRight (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom
          (pullback h)) = 𝟙 _ := by
      erw [conjugateEquiv_whiskerRight (prF.comp aY) (aX.comp shfF) shfH
          (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom,
        show (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom
          = (conjugateEquiv (prF.comp aY) (aX.comp shfF)).symm (𝟙 _) from rfl,
        Equiv.apply_symm_apply]
      simp
    have hF3 : (conjugateEquiv ((prF.comp prH).comp aZ) ((prF.comp aY).comp shfH))
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).whiskerLeft
          (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom) = 𝟙 _ := by
      rw [eassoc2, eassoc1]
      erw [conjugateEquiv_whiskerLeft (prH.comp aZ) (aY.comp shfH) prF
          (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom,
        show (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom
          = (conjugateEquiv (prH.comp aZ) (aY.comp shfH)).symm (𝟙 _) from rfl,
        Equiv.apply_symm_apply]
      rfl
    rw [hF2, hF3, Category.comp_id, Category.comp_id]
    -- STEP 5: collapse the two outer conjugates F4, F1 by their whisker lemmas.  `erw` (not `rw`)
    -- bridges the Scheme/Sheaf `pullback` defeq (iter-309).  F1's inner conjugate is
    -- `(Scheme.Modules.pushforwardComp h f).hom` (`conjugateEquiv_pullbackComp_inv`); F4's inner is
    -- the presheaf `pullbackComp.hom` conjugate.
    rw [eassoc0]
    erw [conjugateEquiv_whiskerLeft (shfF.comp shfH) shf aX (pullbackComp h f).inv,
      conjugateEquiv_whiskerRight prf (prF.comp prH) aZ
        (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).hom,
      Scheme.Modules.conjugateEquiv_pullbackComp_inv h f]
    -- RESIDUAL = the genuine pushforwardComp cocycle (recipe step 5):
    --   (forget_Z ⋙ restrict_Z) ◁ (conjugateEquiv prf (prF∘prH) (PresheafOfModules.pullbackComp …).hom)
    --     ≫ (Scheme.Modules.pushforwardComp h f).hom ▷ (forget_X ⋙ restrict_X) = 𝟙.
    -- The presheaf inner equals `(PresheafOfModules.pushforwardComp φ'_f φ'_h).inv`:
    -- `PresheafOfModules.pullbackComp` unfolds (verified by `simp only [PresheafOfModules.pullbackComp]`)
    -- to `(prF).leftAdjointCompIso prH prf (PresheafOfModules.pushforwardComp φ'_f φ'_h)`, whose
    -- conjugate is computed by `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` (the `_hom` form is
    -- Mathlib-absent — invert via `Iso`/`conjugateEquiv_comp`).  The Scheme-level
    -- `pushforwardComp h f` relates to the presheaf one through `forget_map_pushforward_map`
    -- (forget ∘ pushforward^sheaf = pushforward^pre ∘ forget, `rfl`).  Both pushforwardComps are
    -- componentwise identities (the engine's `pushforwardComp_hom_app_app = 𝟙` idiom), so the cocycle
    -- is strict.  Remaining work: the presheaf↔sheaf `pushforwardComp` identification through the
    -- forget/restrict whiskers + the final componentwise `rfl`.  (Tried: `rfl`, `simp`, `aesop_cat`,
    -- componentwise `NatTrans.ext` — none close, since the two pushforwardComps live on opposite
    -- whisker sides and must be bridged through `forget_map_pushforward_map` first.)
    -- iter-314 CLOSE: `PresheafOfModules.pullbackComp φ'_f φ'_h
    --   = Adjunction.leftAdjointCompIso prF prH prf (PresheafOfModules.pushforwardComp φ'_f φ'_h)`
    -- by def (`rfl`).  `conjugateEquiv_leftAdjointCompIso_inv` gives the `.inv` conjugate
    -- (`conjugateEquiv (prF∘prH) prf pullbackComp.inv = pushforwardComp.hom = 𝟙`, presheaf
    -- `pushforwardComp = Iso.refl`); the `.hom` conjugate we need is then `𝟙` by `conjugateEquiv_comm`
    -- (the two conjugates of `pullbackComp.hom`/`.inv` are mutually inverse).  Whiskering the resulting
    -- `𝟙` is `𝟙`, and the Scheme-level `(pushforwardComp h f).hom = 𝟙` (`Scheme.Modules.pushforwardComp`
    -- = `SheafOfModules.pushforwardComp` = `Iso.refl`, so `.hom = 𝟙` by `rfl`); `whiskerRight 𝟙 = 𝟙`.
    have h1 : conjugateEquiv (prF.comp prH) prf
        (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv = 𝟙 _ := by
      rw [show PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
              (Hom.toRingCatSheafHom h).hom
            = Adjunction.leftAdjointCompIso prF prH prf
                (PresheafOfModules.pushforwardComp (Hom.toRingCatSheafHom f).hom
                  (Hom.toRingCatSheafHom h).hom) from rfl,
          Adjunction.conjugateEquiv_leftAdjointCompIso_inv]
      rfl
    have hconj : conjugateEquiv prf (prF.comp prH)
        (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).hom = 𝟙 _ := by
      have hcomm := conjugateEquiv_comm prf (prF.comp prH)
        (α := (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).hom)
        (β := (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv) (by simp)
      rw [h1, Category.comp_id] at hcomm
      exact hcomm
    rw [hconj, show (pushforwardComp h f).hom = 𝟙 _ from rfl]
    simp only [Functor.whiskerLeft_id', Category.id_comp]
    exact Functor.whiskerRight_id' _
  -- Reduce the goal to `key` evaluated at `P`.  `NatTrans.congr_app` is the iter-309 wall; the knob
  -- (set on this lemma) tames the `Scheme.Modules.pullback ≟ SheafOfModules.pullback` defeq.
  have happ := NatTrans.congr_app key P
  simp only [NatTrans.comp_app, Functor.whiskerLeft_app, Functor.whiskerRight_app] at happ ⊢
  exact happ

/-- **`pullbackValIso` as the `sheafCompPb`/counit composite** (Sq4 chain,
`lem:pullbackValIso_eq_sheafCompPb`). By definition, the connecting iso `pullbackValIso f M` is the
inverse sheafification–pullback comparison at the underlying presheaf `M.val`, followed by the
pullback of the sheafification counit `ε^X_M : a_X(M.val) ≅ M` at the (already-sheaf) `M`. Holds by
`rfl` — it *is* this composite by the definition of `pullbackValIso` (`def:pullback_val_iso`). -/
lemma pullbackValIso_eq_sheafCompPb {X Y : Scheme.{u}} (f : Y ⟶ X) (M : X.Modules) :
    pullbackValIso f M =
      ((SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).app M.val).symm ≪≫
        (Scheme.Modules.pullback f).mapIso
          ((asIso (PresheafOfModules.sheafificationAdjunction
            (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit).app M) := rfl

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
/-- **Composition coherence of the `sheafCompPb`/counit composite** (Sq4 chain,
`lem:sheafCompPb_counit_comp_coherence`). For composable `h : Z ⟶ Y`, `f : Y ⟶ X` and
`M : X.Modules`, the altitude-`(h≫f)` composite `(sheafCompPb (h≫f)).symm.app(M.val) ≫
(pullback (h≫f)).map ε^X_M`, post-composed with `(pullbackComp h f).inv`, factors through the
presheaf-pullback pseudofunctor iso (sheafified) and the altitude-`h`/altitude-`f` comparisons.

Two ingredients combine. **Sheafified-presheaf half:** the closed Sq1 cocycle
`sheafificationCompPullback_comp` rewrites the altitude-`(h≫f)` comparison through `pullbackComp h f`
and the altitude-`f`/altitude-`h` comparisons; the resulting palindrome of comparison isos collapses
to the identity (assembled here as the explicit `Tiso`). **Counit half:** the `(h≫f)`-counit factor
`ε^X_M` is slid past `(pullbackComp h f)` by the naturality of the pseudofunctoriality iso
(`CategoryTheory.NatTrans.naturality`, `lem:pullbackComp_hom_naturality`). -/
lemma sheafCompPb_counit_comp_coherence {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (M : X.Modules) :
    (((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app M.val).inv ≫
      (Scheme.Modules.pullback (h ≫ f)).map
        ((asIso (PresheafOfModules.sheafificationAdjunction
          (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit).app M).hom) ≫
      (Scheme.Modules.pullbackComp h f).inv.app M
    = (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).map
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv.app M.val) ≫
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)).inv ≫
      (Scheme.Modules.pullback h).map
        (((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app M.val).inv ≫
          (Scheme.Modules.pullback f).map
            ((asIso (PresheafOfModules.sheafificationAdjunction
              (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit).app M).hom) := by
  set εhom := ((asIso (PresheafOfModules.sheafificationAdjunction
      (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit).app M).hom with hε
  set e1 := (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app M.val
    with he1
  set e1f := (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app M.val
    with he1f
  set shh := (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
    ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val) with hshh
  -- Sq1 (the closed `sheafificationCompPullback_comp`), at the presheaf `P := M.val`.
  have hSq1 : e1.hom =
      (Scheme.Modules.pullbackComp h f).inv.app
          ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj M.val) ≫
        (Scheme.Modules.pullback h).map e1f.hom ≫
        shh.hom ≫
        (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).map
          ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
            (Hom.toRingCatSheafHom h).hom).hom.app M.val) :=
    sheafificationCompPullback_comp h f M.val
  -- The palindrome of comparison isos, packaged as one iso `Tiso` so the cancellation of its `T`
  -- tail against the `T⁻¹` prefix is the clean `Iso.hom_inv_id` (no `a_Y.map (𝟙)` ever forms, which
  -- would detonate the Scheme/Sheaf-site defeq).
  set PCiso : (PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom ⋙
        PresheafOfModules.pullback (Hom.toRingCatSheafHom h).hom).obj M.val ≅
      (PresheafOfModules.pullback (Hom.toRingCatSheafHom (h ≫ f)).hom).obj M.val :=
    Iso.mk ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
              (Hom.toRingCatSheafHom h).hom).hom.app M.val)
           ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
              (Hom.toRingCatSheafHom h).hom).inv.app M.val) with hPC
  set Tiso := (Scheme.Modules.pullback h).mapIso e1f ≪≫ shh ≪≫
    (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).mapIso PCiso
    with hTiso
  have hThom : (Scheme.Modules.pullback h).map e1f.hom ≫ shh.hom ≫
      (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).map
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).hom.app M.val) = Tiso.hom := by
    simp only [hTiso, hPC, Iso.trans_hom, Functor.mapIso_hom, Category.assoc]
  -- Counit half: slide `ε^X_M` across `(pullbackComp h f).inv` by naturality.
  have hnat := (Scheme.Modules.pullbackComp h f).inv.naturality εhom
  simp only [Functor.id_obj, Functor.comp_map] at hnat
  rw [Category.assoc, hnat, ← Category.assoc]
  -- Sheafified-presheaf half: `e1.inv ≫ pbComp.inv = Tiso.inv` via Sq1.
  have hB : e1.inv ≫ (Scheme.Modules.pullbackComp h f).inv.app
        (((SheafOfModules.forget X.ringCatSheaf ⋙
            PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)) ⋙
            PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj M) = Tiso.inv := by
    rw [Iso.inv_comp_eq, hSq1, hThom, Category.assoc, Iso.hom_inv_id, Category.comp_id]
    rfl
  rw [hB, hTiso]
  simp only [Iso.trans_inv, Functor.mapIso_inv, hPC, Category.assoc,
    Functor.comp_map, ← Functor.map_comp]

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
/-- **Sq4 — composition coherence of `pullbackValIso`** (`lem:pullbackValIso_comp_coherence`). For
composable `h : Z ⟶ Y`, `f : Y ⟶ X` and `M : X.Modules`, the connecting iso `pullbackValIso`
satisfies the composition coherence relating its `(h≫f)`-instance to the `f`-instance (transported by
`h^*`) and the `h`-instance (on `f^*M`), conjugated by the pullback pseudofunctoriality iso
`pullbackComp h f`:
`(pullbackValIso (h≫f) M).hom ≫ (pullbackComp h f).inv.app M = Ψ ≫ (pullback h).map (pullbackValIso f M).hom`,
where the left vertical `Ψ` is the sheafified-presheaf connecting iso. A three-step corollary: unfold
each `pullbackValIso` via `pullbackValIso_eq_sheafCompPb`, apply `sheafCompPb_counit_comp_coherence`,
then refold the `f`-side. Consumed by `pullbackTensorMap_restrict` (Sq4). -/
lemma pullbackValIso_comp {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X) (M : X.Modules) :
    (pullbackValIso (h ≫ f) M).hom ≫ (Scheme.Modules.pullbackComp h f).inv.app M
    = (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).map
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv.app M.val) ≫
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)).inv ≫
      (Scheme.Modules.pullback h).map (pullbackValIso f M).hom := by
  rw [pullbackValIso_eq_sheafCompPb (h ≫ f) M]
  simp only [Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
  rw [sheafCompPb_counit_comp_coherence h f M, pullbackValIso_eq_sheafCompPb f M]
  simp only [Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 2000000 in
/-- **`cmp_leg` — the per-leg (M-leg) composition coherence of the sheafification-unit /
`pullbackValIso` comparison** (the step-(7) core of `pullbackTensorMap_restrict`; blueprint
`lem:pullback_tensor_map_basechange`, per-leg). Writing the per-altitude comparison
`cmp_g M := η.app (Fp_g M.val) ≫ forget ((pullbackValIso g M).hom)` (`η` = sheafification-adjunction
unit, `forget = SheafOfModules.forget`, `Fp_g = PresheafOfModules.pullback φ_g.hom`), the
composite-pullback comparison factors through the `f`- and `h`-instances conjugated by the
presheaf / sheaf pseudofunctoriality isos `PC = PresheafOfModules.pullbackComp` and
`pbc = Scheme.Modules.pullbackComp`:
`PC.hom M.val ≫ cmp_{h≫f} M = Fp_h.map (cmp_f M) ≫ cmp_h (f^*M) ≫ forget (pbc.hom.app M)`.
This is exactly the presheaf TRANSPOSE of the sheaf-level Sq4 coherence `pullbackValIso_comp`.

**iter-322 PARTIAL (axiom-clean verified prefix).** The proof reduces (cancel_mono `forget pbc.inv`,
the sheaf-level `pullbackValIso_comp`, the sheafification-unit naturality slide, and the
`PC.hom ≫ PC.inv` cancellation — all verified) the displayed per-leg identity to the **single residual
core coherence C** (the `sheafificationCompPullback`/`leftAdjointUniq` composite-adjunction-unit law):
`η.app (Fp_h (Fp_f M.val)) ≫ forget (scPb_h.app (Fp_f M.val)).inv ≫ forget ((pullback h).map (pvi_f M).hom)
  = Fp_h.map (cmp_f M) ≫ η.app (Fp_h ((f^*M).val)) ≫ forget ((pvi_h (f^*M)).hom)`.
Core C is the genuine ~100-LOC mate calculus: `scPb_h = Adjunction.leftAdjointUniq adjA adjB` for the
composite adjunctions `adjA = (sheafificationAdjunction _).comp (pullbackPushforwardAdjunction φ_h)`
and `adjB = (pullbackPushforwardAdjunction φ_h.hom).comp (sheafificationAdjunction _)`; the Mathlib
tools are `Adjunction.unit_leftAdjointUniq_hom_app` + `Adjunction.leftAdjointUniq_hom_app_counit`
(`Mathlib.CategoryTheory.Adjunction.Unique`), but the PLAIN sheafification unit `η` must first be
aligned with `adjB`'s composite-adjunction unit — `simp` with those `@[simp]` lemmas makes NO progress
(the units do not align syntactically). Consumed by the step-(7) per-leg slot of
`pullbackTensorMap_restrict`. -/
private lemma cmp_leg {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X) (M : X.Modules) :
    (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
        (Hom.toRingCatSheafHom h).hom).hom.app M.val ≫
      (PresheafOfModules.sheafificationAdjunction (R := Z.ringCatSheaf)
          (𝟙 Z.ringCatSheaf.val)).unit.app
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom (h ≫ f)).hom).obj M.val) ≫
      (SheafOfModules.forget Z.ringCatSheaf).map (pullbackValIso (h ≫ f) M).hom
    = (PresheafOfModules.pullback (Hom.toRingCatSheafHom h).hom).map
        ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val) ≫
        (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom) ≫
      (PresheafOfModules.sheafificationAdjunction (R := Z.ringCatSheaf)
          (𝟙 Z.ringCatSheaf.val)).unit.app
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom h).hom).obj
          ((Scheme.Modules.pullback f).obj M).val) ≫
      (SheafOfModules.forget Z.ringCatSheaf).map
        (pullbackValIso h ((Scheme.Modules.pullback f).obj M)).hom ≫
      (SheafOfModules.forget Z.ringCatSheaf).map
        ((Scheme.Modules.pullbackComp h f).hom.app M) := by
  -- (a) cancel the trailing `forget pbc.hom` against `forget pbc.inv` (iso mono).
  apply (CategoryTheory.cancel_mono ((SheafOfModules.forget Z.ringCatSheaf).map
      ((Scheme.Modules.pullbackComp h f).inv.app M))).mp
  -- (b) collapse the RHS `forget pbc.hom ≫ forget pbc.inv`; merge `forget pvi_{hf} ≫ forget pbc.inv`
  --     on the LHS and rewrite through the sheaf-level Sq4 coherence `pullbackValIso_comp`.
  rw [Category.assoc, Category.assoc, Category.assoc, Category.assoc, Category.assoc,
      ← Functor.map_comp (SheafOfModules.forget Z.ringCatSheaf)
        ((Scheme.Modules.pullbackComp h f).hom.app M)
        ((Scheme.Modules.pullbackComp h f).inv.app M),
      Iso.hom_inv_id_app, CategoryTheory.Functor.map_id,
      ← Functor.map_comp (SheafOfModules.forget Z.ringCatSheaf)
        (pullbackValIso (h ≫ f) M).hom ((Scheme.Modules.pullbackComp h f).inv.app M),
      pullbackValIso_comp h f M]
  erw [Category.comp_id]
  rw [Functor.map_comp, Functor.map_comp]
  -- (c) slide `PC.inv` left through the sheafification unit (`unit.naturality`), then cancel
  --     `PC.hom ≫ PC.inv = 𝟙`.  The LHS is now the clean core coherence C (see docstring).
  erw [← (PresheafOfModules.sheafificationAdjunction
        (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).unit.naturality_assoc
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv.app M.val)]
  simp only [CategoryTheory.Functor.id_map]
  rw [← Category.assoc, Iso.hom_inv_id_app, Category.id_comp]
  -- RESIDUAL = core coherence C (the `leftAdjointUniq` composite-adjunction-unit mate calculus).
  sorry

/-- **The `sheafificationCompPullback h` naturality SLIDE** (the standalone "small rewrite motive"
slide lemma the D3′ assembly needs — iter-321). `SheafOfModules.sheafificationCompPullback φ_h` is a
natural iso `a_Y ⋙ (pullback h) ≅ Fp_h ⋙ a_Z` (`a = sheafification`, `Fp_h = presheaf pullback`),
so for any presheaf map `g : P ⟶ P'` over `Y` its naturality square reads
`scPb_h.app P .hom ≫ a_Z.map (Fp_h.map g) = (pullback h).map (a_Y.map g) ≫ scPb_h.app P' .hom`.
This is the move that slides the leading `scPb_h` comparison past `(pullback h).map (a_Y.map δ_f)` in
`pullbackTensorMap_restrict` (and, reused on `g = sheafification-unit ⊗ₘ unit` and `g = forget(pvi)
⊗ₘ forget(pvi)`, brings the RHS `scPb_h` to the front).  Reductive motive: tiny goal, so its proof
does NOT whnf-explode under relaxed transparency — exactly the per-slide-standalone extraction the
planner prescribed (it is plain `NatTrans.naturality`, no `Scheme.Modules.pullback ≟ SheafOfModules`
defeq detonation). Project-local. -/
private lemma scPb_slide {X Y Z : Scheme.{u}} (h : Z ⟶ Y)
    {P P' : _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)} (g : P ⟶ P') :
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app P).hom ≫
      (PresheafOfModules.sheafification (𝟙 (Sheaf.val Z.ringCatSheaf))).map
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom h).hom).map g) =
    (Scheme.Modules.pullback h).map
        ((PresheafOfModules.sheafification (𝟙 (Sheaf.val Y.ringCatSheaf))).map g) ≫
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app P').hom :=
  ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom.naturality g).symm

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 3200000 in
/-- **D3′ — composition coherence of the sheaf-level pullback–tensor comparison `pullbackTensorMap`**
(blueprint `lem:pullback_tensor_map_basechange`).

This is the *tensorator* analog of the unit composition coherence
`pullbackObjUnitToUnit_comp`: for composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and
arbitrary `M N : X.Modules`, the comparison `δ_sheaf = pullbackTensorMap (h ≫ f)` of the composite
factors through the comparisons of `f` and `h` and the pullback pseudofunctor coherence
`pullbackComp`:
`pullbackTensorMap (h≫f) M N = (pullbackComp h f).inv ≫ (pullback h).map (pullbackTensorMap f) ≫
  pullbackTensorMap h (f^*M) (f^*N) ≫ tensorObjIsoOfIso (pullbackComp h f) (pullbackComp h f)`.

The base-change-square form of the blueprint (`f ∘ j' = j ∘ g` with `j, j'` open immersions) is the
specialisation `h := j'`, `f`, applied to the two factorisations `j' ≫ f = g ≫ j` of the equal
underlying morphisms; the displayed identity of the restricted comparisons follows by equating the
two instances of this coherence. Consumed by D4′ `pullbackTensorIsoOfLocallyTrivial`.

Mathlib-absent at the pinned commit; NOT a sectionwise statement (the left-adjoint pullback exposes
no sectionwise value). Proved by the mate calculus through the oplax comparison `δ` of a composite of
left adjoints (`Functor.OplaxMonoidal.comp_δ`) and the adjunction-mate identity
`conjugateEquiv_pullbackComp_inv` (`pullbackComp` for the left adjoints ↔ `pushforwardComp` for the
right adjoints), exactly mirroring `pullbackObjUnitToUnit_comp`. -/
lemma pullbackTensorMap_restrict {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (M N : X.Modules) :
    pullbackTensorMap (h ≫ f) M N =
      (Scheme.Modules.pullbackComp h f).inv.app (tensorObj M N) ≫
      (Scheme.Modules.pullback h).map (pullbackTensorMap f M N) ≫
      pullbackTensorMap h ((Scheme.Modules.pullback f).obj M)
        ((Scheme.Modules.pullback f).obj N) ≫
      (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp h f).app M)
        ((Scheme.Modules.pullbackComp h f).app N)).hom := by
  -- ROADMAP (iter-256 handoff). Unfolding `pullbackTensorMap` on both sides (verified) exposes the
  -- four-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4` with
  --   S1 = (sheafificationCompPullback φ_{·}).app (M.val ⊗ₚ N.val) .hom,
  --   S2 = a_·.map (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ'_{·}) M.val N.val),
  --   S3 = (sheafifyTensorUnitIso (Fp M.val) (Fp N.val)).hom,
  --   S4 = a_·.map (forget(pullbackValIso · M).hom ⊗ₘ forget(pullbackValIso · N).hom).
  -- Unlike D1′ (naturality, a 4-square *paste*), this is a 4-square *composition*-coherence: the LHS
  -- is the composite-morphism `· = h ≫ f` instance, the RHS interleaves the `f` instance (pushed
  -- forward by `(pullback h).map`) with the `h` instance (on the pulled-back modules `(pullback f).obj`),
  -- all conjugated by the pseudofunctoriality iso `pullbackComp h f`.
  --
  -- **Why the unit-analog mirror does NOT transfer.** `pullbackObjUnitToUnit_comp` (L907) works because
  -- `pullbackObjUnitToUnit` is BY DEFINITION an adjunction transpose, so its composition coherence is
  -- obtained by transposing through `pullbackPushforwardAdjunction.homEquiv` and invoking the bridge
  -- `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`. `pullbackTensorMap` is NOT a
  -- transpose — it is the hand-built 4-fold composite above — and there is NO analogous
  -- `…homEquiv_pullbackTensorMap` bridge. Hence the mirror's very first move
  -- (`(pullbackPushforwardAdjunction (h≫f)).homEquiv.injective`) leaves an un-evaluable transpose of a
  -- concrete composite and stalls. This is the planner's anticipated "genuinely new obstacle beyond the
  -- unit-analog pattern" — per the iter-256 reversing signal, the scaffolded statement is retained with
  -- this typed `sorry` rather than forcing a non-applicable device.
  --
  -- **The genuine route (four composition-coherence squares; each its own sub-lemma).**
  --  • Sq2 (the δ core): `δ (PresheafOfModules.pullback φ'_{h≫f})` decomposes via
  --    `CategoryTheory.Functor.OplaxMonoidal.comp_δ` once `pullback φ'_{h≫f}` is identified with
  --    `pullback φ'_f ⋙ pullback φ'_h` through the Mathlib presheaf coherence
  --    `PresheafOfModules.pullbackComp φ'_f ψ` (verified to exist; composite ring map
  --    `φ'_f ≫ F.op.whiskerLeft ψ`), which requires the ring-map reconciliation
  --    `(toRingCatSheafHom (h≫f)).hom = φ'_f ≫ (Opens.map f.base).op.whiskerLeft φ'_h` (functoriality
  --    of `toRingCatSheafHom` under `≫`).  `PresheafOfModules.{pullbackId, pullback_assoc}` are the
  --    coherence-bookkeeping lemmas.
  --  • Sq1 (sheafification ↔ pullback): the composition coherence of
  --    `SheafOfModules.sheafificationCompPullback` across `h≫f` (analog of `pullbackComp` for the
  --    `sheafification ⋙ pullback` natural iso) — Mathlib-absent, a project sub-lemma.
  --  • Sq3: `sheafifyTensorUnitIso` carried through the same `pullbackComp` identification.
  --  • Sq4 (the connecting iso): a Scheme-level `pullbackValIso` composition coherence relating
  --    `pullbackValIso (h≫f) M` to `(pullback h).map (pullbackValIso f M)`, `pullbackValIso h (f^*M)`
  --    and `(pullbackComp h f).app M` — Mathlib-absent, the second project sub-lemma; it is the
  --    bookkeeping that produces the final `tensorObjIsoOfIso (pullbackComp h f) (pullbackComp h f)`.
  -- The two project sub-lemmas (Sq1, Sq4 composition coherences) + the Sq2 ring-map reconciliation are
  -- the missing ingredients; they are the iter-257 work items (each ~40-120 LOC, mate-calculus style).
  --
  -- ITER-257 FINDINGS (prover):
  --  (1) The Sq2 RING-MAP RECONCILIATION IS DEFINITIONAL — `toRingCatSheafHom_comp_hom_reconcile`
  --      (just above) closes by `rfl`: `(toRingCatSheafHom (h≫f)).hom =
  --      (toRingCatSheafHom f).hom ≫ (Opens.map f.base).op.whiskerLeft (toRingCatSheafHom h).hom`.
  --      The blueprint's "non-trivial because the two sides live in functor categories that agree only
  --      up to Opens.map_comp" is in fact a `rfl` (the `Opens.map`/`Scheme` comp defeqs hold). This
  --      means `PresheafOfModules.pullbackComp φ'_f φ'_h` lands in `pullback φ'_{h≫f}` ON THE NOSE.
  --  (2) The genuine Sq2 content is "Sq2b": the MONOIDALITY of `pullbackComp` — that `δ` of the single
  --      `pullback φ'_{h≫f}` (leftAdjoint-oplax of the composite adjunction) transports, through
  --      `pullbackComp`, to `δ` of the composite functor `pullback φ'_f ⋙ pullback φ'_h`
  --      (`Functor.OplaxMonoidal.comp_δ`). Mathlib has NO ready lemma for the δ-transport of
  --      `Adjunction.leftAdjointCompIso` (searched: no `leftAdjointOplaxMonoidal`-of-composite lemma).
  --      It must be proved by the mate calculus (mirror `Adjunction.isMonoidal_comp`, Functor.lean:990).
  --  (3) STATEMENT-LEVEL FRICTION to budget for: (a) `Functor.OplaxMonoidal.δ (pullback φ')` needs the
  --      CommRingCat/forget₂ monoidal-instance pinning (the D1′ `show … from`/`let φ' : … ⋙ forget₂`
  --      device — bare `δ (pullback (toRingCatSheafHom f).hom)` leaves `MonoidalCategory` metavars
  --      stuck); (b) `pullbackComp φ'_f φ'_h` pins `(F := Opens.map f.base ⋙ Opens.map h.base)` with the
  --      morphism `φ'_f ≫ whiskerLeft (Opens.map f.base).op φ'_h`, and unifying the standalone δ's
  --      pullback against that codomain needs explicit `(F := …)` + the associativity defeq
  --      `(F⋙G).op⋙T = F.op⋙(G.op⋙T)` — write the LHS δ over `pullback (F := _ ⋙ _) (toRingCatSheafHom
  --      (h≫f)).hom` (typechecks) and bridge the RHS connecting object by `eqToHom` via finding (1).
  -- ITER-261 (prover): the proof is now OPENED to the paste-ready form.  `simp only` unfolds
  -- `pullbackTensorMap` on BOTH sides into the four-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4`; the RHS
  -- `(pullback h).map (S1_f ≫ … ≫ S4_f)` is distributed by `Functor.map_comp` and everything
  -- right-associated.  The goal is then the explicit 4-vs-10 factor identity
  --   S1_{hf} ≫ a_Z.map δ_{hf} ≫ S3_{hf} ≫ S4_{hf}
  --     = R0 ≫ (pullback h).map S1_f ≫ (pullback h).map (a_Y.map δ_f) ≫ (pullback h).map S3_f
  --        ≫ (pullback h).map S4_f ≫ S1_h ≫ a_Z.map δ_h ≫ S3_h ≫ S4_h ≫ a_Z.mapIso(pbComp ⊗ pbComp).hom
  -- with R0 = (pullbackComp h f).inv.app (M⊗N).  This is the four-square *composition* paste:
  --   • Sq1 (the S1 connecting iso):  `sheafificationCompPullback_comp` (stated+opened just above —
  --     the foundational Mathlib-absent coherence; LHS already reduced to the unit identity).
  --   • Sq2b (the δ core):           `pullbackComp_δ` (CLOSED, axiom-clean) under `a_Z.map`.
  --   • Sq3 (the unit iso):          `sheafifyTensorUnitIso` carried through `pullbackComp`.
  --   • Sq4 (the connecting iso):    a `pullbackValIso` composition coherence (Mathlib-absent; it
  --     factors through Sq1 since `pullbackValIso = sheafCompPb.symm ≪≫ pullback.mapIso counit`).
  -- The squares INTERLEAVE (e.g. `S1_h` here acts on `tensorObj ((pullback f).obj M) …`, NOT on
  -- `PrPb_f (M⊗N)`), so the paste slides factors past each other by `δ_natural` / NatTrans naturality
  -- exactly as the D1′ naturality paste (`pullbackTensorMap_natural`, L2007) does — merging
  -- `a.map δ ≫ S3 ≫ S4` into a single `a.map Ψ` to move S1 by its mate coherence.
  --
  -- ITER-319 STATUS: three of the four square coherences exist as in-file lemmas (the planner's Sq4
  -- chain); Sq3 is wired inline in this paste (not a standalone lemma):
  --   • Sq1 = `sheafificationCompPullback_comp h f (M.val ⊗ₚ N.val)` (CLOSED, above).
  --   • Sq2b = `pullbackComp_δ φ'_f φ'_h M.val N.val` (CLOSED, above) — the δ-core decomposition
  --     (needs the `χ' = φ'_f ≫ F.op ◁ φ'_h` reconcile + monoidal-instance pin per the iter-257
  --     statement-friction notes; `toRingCatSheafHom_comp_hom_reconcile` makes the ring-map `rfl`).
  --   • Sq3 = `sheafifyTensorUnitIso` carried through `pullbackComp` (wired INLINE, in the residual).
  --   • Sq4 = `pullbackValIso_comp h f M`/`… N` (CLOSED, above) — `(pullbackValIso (h≫f) ·).hom ≫
  --     (pullbackComp h f).inv.app · = Ψ ≫ (pullback h).map (pullbackValIso f ·).hom`; this is the
  --     coherence that matches the trailing `L4 = a_Z.map (forget(pullbackValIso (h≫f) M).hom ⊗ₘ …)`
  --     of the LHS against `Rh4 ≫ S4comp` of the RHS once the paste brings the `pullbackComp` factors
  --     of `S4comp` adjacent to `L4` (via `tensorHom`-bifunctoriality + `forget`/`a_Z`-functoriality).
  -- REMAINING WORK = the interleaved ASSEMBLY only: the goal (obtained below) is the explicit
  -- 4-vs-13 factor identity `L1≫L2≫L3≫L4 = R0 ≫ (f-block ×4) ≫ (h-block ×4) ≫ S4comp`.  The squares
  -- do NOT paste row-by-row (e.g. `Rh1 = sheafCompPb h .app (((pullback f)M).val ⊗ ((pullback f)N).val)`
  -- acts on the abstract-pullback `.val`, NOT on `Ppb φ'_f (M.val⊗N.val)` where Sq1 leaves the h-comparison),
  -- so each square's output must be slid past the next by `δ_natural`/`NatTrans.naturality`/
  -- `MonoidalCategory.tensorHom_comp_tensorHom` before the four coherences line up.  This assembly
  -- needs interactive goal tracking (LSP times out on this file ⇒ build-blind only); the first four
  -- moves are now landed below (iter-320), the slide + S3/S4 region is the retained residual sorry
  -- (race-safe: file compiles; `DualInverse.lean` imports it).
  -- ITER-320 ASSEMBLY (verified in scratch-loop, transplanted): the first four conceptual moves of
  -- the interleaved paste now land in-file (Sq1 expansion, Sq2b δ-rewrite, the pullbackComp
  -- hom∘inv cancellation, and the `comp_δ` decomposition of the composite-pullback oplax δ).
  -- After these the goal is the explicit residual identity (see the trace below); the remaining
  -- work = the `sheafificationCompPullback h` NATURALITY SLIDE (move the leading `scPb_h` comparison
  -- past `(pullback h).map (a_Y.map δ_f)` so the common `(pullback h).map(a_Y.map δ_f)` peels) plus the
  -- S3/S4 region (the `sheafifyTensorUnitIso` carried through `pullbackComp`, via the `change`-defeq
  -- `sheafifyTensorUnitIso.hom ≡ a.map(η ▷ _) ≫ a.map(_ ◁ η)`, then `pullbackValIso_comp` Sq4).
  -- ENVIRONMENTAL WALL (iter-320, reconfirmed): every giant-term operation past this point
  -- (`slice_lhs`/`erw`/`rw` of the naturality slide) whnf-explodes under
  -- `backward.isDefEq.respectTransparency false` (REQUIRED for the Sq1 rewrite, which leaves the goal
  -- type-correct only under relaxed transparency) — a single slide times out at 6.4M heartbeats
  -- (~9 min) on the `Scheme.Modules.pullback ≟ SheafOfModules.pullback` defeq. The four landed moves
  -- complete in ~26 s (< 1.6M heartbeats); the slide is the next-iter effort-break target (extract
  -- each slide as a SMALL standalone lemma so its rewrite motive is tiny, then compose).
  simp only [pullbackTensorMap, tensorObjIsoOfIso]
  rw [Functor.map_comp, Functor.map_comp, Functor.map_comp]
  simp only [Category.assoc]
  -- Step A — expand `L1 = (scPb_{h≫f}).hom` via Sq1 (`sheafificationCompPullback_comp`); peel the two
  -- now-common leading factors `R0 = (pullbackComp h f).inv.app (M⊗N)` and `(pullback h).map L1_f`.
  rw [sheafificationCompPullback_comp h f (PresheafOfModules.Monoidal.tensorObj M.val N.val)]
  simp only [Category.assoc]
  refine congr_arg₂ (· ≫ ·) rfl ?_
  refine congr_arg₂ (· ≫ ·) rfl ?_
  -- Step B — rewrite `δ_{h≫f}` via Sq2b (`pullbackComp_δ`); the composite-ring-map of the LHS δ is
  -- defeq to `φ'_f ≫ (Opens.map f.base).op ◁ φ'_h` (the `toRingCatSheafHom_comp_hom_reconcile` rfl),
  -- so `erw` bridges.
  erw [pullbackComp_δ (Hom.toRingCatSheafHom f).hom (Hom.toRingCatSheafHom h).hom M.val N.val]
  -- Step C — split the `a_Z.map` composite and cancel `pullbackComp.hom ≫ pullbackComp.inv = 𝟙`
  -- (kept off `a_Z.map 𝟙` until the final `Functor.map_id`, which fires cleanly via `erw`).
  rw [Functor.map_comp, Functor.map_comp]
  simp only [Category.assoc]
  rw [← Functor.map_comp_assoc]
  erw [Iso.hom_inv_id_app, CategoryTheory.Functor.map_id, Category.id_comp]
  -- Step D — decompose `δ (Fp_f ⋙ Fp_h)` via `Functor.OplaxMonoidal.comp_δ` and split the `a_Z.map`.
  rw [Functor.OplaxMonoidal.comp_δ, Functor.map_comp]
  simp only [Category.assoc]
  -- ─────────────────────────────────────────────────────────────────────────────────────────────
  -- ITER-321 — EXACT post-Step-D goal captured by `trace_state` (build-blind), giving the precise
  -- 7-step assembly roadmap.  Abbreviations: a = sheafification, Fp_g = PresheafOfModules.pullback
  -- φ_g.hom, Pb_g = Scheme.Modules.pullback g, scPb_g = sheafificationCompPullback φ_g, η = sheaf
  -- unit, PC = PresheafOfModules.pullbackComp φ_f.hom φ_h.hom, pbc = Scheme.Modules.pullbackComp h f,
  -- pvi = pullbackValIso, δ_g = Functor.OplaxMonoidal.δ Fp_g.
  --   LHS = scPb_h.app(Fp_f(M⊗N)).hom ≫ a_Z.map(Fp_h.map δ_f^{M,N}) ≫ a_Z.map(δ_h^{Fp_f M,Fp_f N})
  --         ≫ a_Z.map(PC.hom M.val ⊗ₘ PC.hom N.val) ≫ suiso_{hf}.hom ≫ a_Z.map(pvi_{hf} tensor)
  --   RHS = Pb_h.map(a_Y.map δ_f^{M,N}) ≫ Pb_h.map(suiso_f.hom) ≫ Pb_h.map(a_Y.map(pvi_f tensor))
  --         ≫ scPb_h.app(tensorObj (Pb_f M).val (Pb_f N).val).hom ≫ a_Z.map(δ_h^{(Pb_f M),(Pb_f N)})
  --         ≫ suiso_h'.hom ≫ a_Z.map(pvi_h tensor) ≫ (a_Z.mapIso(forget(pbc M) ⊗ᵢ forget(pbc N))).hom
  -- where suiso_f.hom = a_Y.map(η_{Fp_f M} ⊗ₘ η_{Fp_f N}) (`sheafifyTensorUnitIso_hom_eq'`), so EVERY
  -- RHS factor up to scPb_h is `Pb_h.map (a_Y.map (presheaf morph))` — the `scPb_slide` shape.
  -- ROADMAP (verified against the trace):
  --   (1) Slide-1: `scPb_slide h δ_f` turns the leading `scPb_h.app(..).hom ≫ a_Z.map(Fp_h.map δ_f)`
  --       into `Pb_h.map(a_Y.map δ_f) ≫ scPb_h.app(Fp_f M ⊗ Fp_f N).hom`; peel the now-common
  --       `Pb_h.map(a_Y.map δ_f) = Rα` (`congr_arg₂ (·≫·) rfl`).            [attempted below]
  --   (2,3) Slide RHS's `scPb_h` (Rδ) LEFT past `Pb_h.map(a_Y.map(pvi_f tensor)) = Rγ` and
  --       `Pb_h.map(suiso_f.hom) = Rβ` (after `sheafifyTensorUnitIso_hom_eq'` exposes Rβ as
  --       `Pb_h.map(a_Y.map(η⊗η))`), both via `scPb_slide`, landing it on `Fp_f M ⊗ Fp_f N`.
  --   (4) Peel the common leading `scPb_h.app(Fp_f M ⊗ Fp_f N).hom`; the remaining goal is now ENTIRELY
  --       `a_Z.map(_)`, so merge by `← Functor.map_comp` to a single `a_Z.map(BIG_L) = a_Z.map(BIG_R)`
  --       and `congr 1` to a PRESHEAF-level identity.
  --   (5) Push `δ_h` left across the two `Fp_h.map(..)` legs by `Functor.OplaxMonoidal.δ_natural` (×2);
  --       peel the common `δ_h^{Fp_f M, Fp_f N}`.
  --   (6) `tensorHom_comp_tensorHom` splits both sides into M- and N-legs.
  --   (7) PER-LEG core (`cmp_leg`, stated below): for the M-leg (and N symmetric),
  --       `PC.hom M.val ≫ η_Z.app(Fp_{hf} M.val) ≫ forget(pvi_{hf} M).hom =
  --        Fp_h.map(η_Y.app(Fp_f M.val) ≫ forget(pvi_f M).hom) ≫ η_Z.app(Fp_h(Pb_f M).val)
  --          ≫ forget(pvi_h(Pb_f M)).hom ≫ forget(pbc M).hom`.
  --       This is the presheaf TRANSPOSE of `sheafificationCompPullback_comp` (the Sq1 mate calculus);
  --       it is the genuine remaining mathematical work (≈100 LOC, mate-calculus style; an automation
  --       attempt `simp [pullbackValIso, ← NatTrans.naturality]` loops).
  -- ENV WALL (iter-320/321): step (1)'s `rw`/`erw`/`slice` on the giant goal whnf-explodes under
  -- `respectTransparency false` (the `Scheme.Modules.pullback ≟ SheafOfModules.pullback φ_h` defeq).
  -- The clean fix is to extract steps (1)–(7) into a continuation lemma WITHOUT the relaxed
  -- transparency (so the slides run like the D1′ `pullbackTensorMap_natural` `erw [reassoc_of% …]`
  -- which does NOT explode) and discharge the residual with a single `exact … h f M N`; transcribing
  -- that lemma's statement is blocked only by re-pinning each `⊗ₘ`'s `(C := PresheafOfModules
  -- (W.presheaf ⋙ forget₂ …))` carrier (the pretty-printer drops it, so a verbatim copy picks a
  -- failing `MonoidalCategory (Sheaf.val W.ringCatSheaf)` instance path).  ← the iter-322 entry point.
  -- Step (1) attempt (will whnf-explode under the active relaxed transparency; left as the documented
  -- stuck point — do NOT re-paste, extract the continuation lemma instead):
  sorry


end LocTrivPullbackTensor

end Modules

end Scheme

end AlgebraicGeometry
