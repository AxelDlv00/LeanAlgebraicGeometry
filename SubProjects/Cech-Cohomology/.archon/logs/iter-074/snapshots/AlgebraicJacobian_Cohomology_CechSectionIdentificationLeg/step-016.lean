/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechSectionIdentificationBase

/-!
# Sub-brick A — Leg: the `coreIso_comm` chain

The `coreIso_comm` chain (`abHom_finsetSum_apply`, `coreIso_comm_leg`, `coreIso_comm_coface`,
`coreIso_comm_sum`, `coreIso_comm`) expressing naturality of the degreewise section iso
through the Čech differentials. Depends on `CechSectionIdentificationBase`.

Carries the residual sorry `coreIso_comm_leg`.
-/

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

open Scheme.Modules

variable {X : Scheme.{u}}

/-! ### The `coreIso_comm` chain (`lem:coreIso_comm_leg` → `lem:coreIso_comm_coface` →
`lem:coreIso_comm_sum` → `lem:coreIso_comm`), built bottom-up per the iter-072 effort-break. -/

/-- Application of a finite sum of `Ab`-morphisms distributes over the sum.  (Local copy of
the `CechAcyclic` private helper `ab_hom_finsetSum_apply`.) -/
private lemma abHom_finsetSum_apply {A B : Ab.{u}} {κ : Type*}
    (s : Finset κ) (f : κ → (A ⟶ B)) (t : ToType A) :
    ConcreteCategory.hom (∑ i ∈ s, f i) t = ∑ i ∈ s, ConcreteCategory.hom (f i) t := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | insert a s ha ih =>
      rw [Finset.sum_insert ha, Finset.sum_insert ha, AddCommGrpCat.hom_add_apply, ih]

/-! ### Geometric seam for `coreIso_comm_leg`

The per-leg coface naturality is proved by unwinding `coreIso_objIso` to the push–pull
map of the **backbone inclusion** `backboneIncl 𝒰 p τ : Over.mk j_τ ⟶ Y_p` (the morphism
produced by `pushPull_sigma_iso_π`), and then computing geometrically:

1. the backbone inclusion followed by the `l`-th wide-pullback projection is the
   canonical component map `interProj` (`backboneIncl_proj` — the Stub-1 unwinding);
2. hence the nerve coface `δ^nerve_k` restricts on the `σ'`-summand to the open
   inclusion `interLegHom : U_{σ'} ⊆ U_{σ'∘δᵏ}` (`backboneIncl_nerveδ`, by `hom_ext`
   through the projections);
3. the evaluated push–pull of that open inclusion acts on the identified leg sections
   as the plain `F`-restriction (`pushPull_interLegHom_sections`). -/

/-- The `τ`-summand inclusion `Over.mk j_τ ⟶ Y_p` of the degree-`p` Čech backbone:
the coproduct inclusion composed with the two backbone identifications read backwards.
By `pushPull_sigma_iso_π`, its push–pull map is the `τ`-projection of
`pushPull_sigma_iso`. -/
noncomputable def backboneIncl (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (p : ℕ)
    (τ : Fin (p + 1) → 𝒰.I₀) :
    Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 τ)) ⟶
      (coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p)) :=
  coprodOverIncl (fun σ : Fin (p + 1) → 𝒰.I₀ =>
      Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))) τ ≫
    (overSigmaDescIso (fun σ : Fin (p + 1) → 𝒰.I₀ =>
      (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).hom)).inv ≫
    (cechBackbone_left_sigma 𝒰 p).inv

/-- `pushPull_sigma_iso_π`, rephrased through `backboneIncl`. -/
lemma pushPull_sigma_iso_π_incl (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (p : ℕ)
    (τ : Fin (p + 1) → 𝒰.I₀) :
    (pushPull_sigma_iso 𝒰 F p).hom ≫
        Pi.π (fun σ : Fin (p + 1) → 𝒰.I₀ =>
          pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) τ =
      pushPullMap F (backboneIncl 𝒰 p τ) :=
  pushPull_sigma_iso_π 𝒰 F p τ

/-- The over-level `l`-th wide-pullback projection of the degree-`p` backbone, landing
in the cover-arrow object `Over.mk (Sigma.desc 𝒰.f)`. -/
noncomputable def backboneProj (𝒰 : X.OpenCover) (p : ℕ) (l : Fin (p + 1)) :
    (coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p)) ⟶
      Over.mk (Sigma.desc 𝒰.f) :=
  Over.homMk (WidePullback.π (fun _ : Fin (p + 1) => Sigma.desc 𝒰.f) l)
    (WidePullback.π_arrow _ l)

/-- Morphisms into the degree-`p` backbone are determined by the `p + 1` over-level
wide-pullback projections: the backbone is the slice product of cover-arrow copies
(`widePullback_overX_isLimit`). -/
lemma backbone_hom_ext (𝒰 : X.OpenCover) (p : ℕ) {A : Over X}
    {u v : A ⟶ (coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p))}
    (h : ∀ l : Fin (p + 1), u ≫ backboneProj 𝒰 p l = v ≫ backboneProj 𝒰 p l) : u = v := by
  apply Over.OverMorphism.ext
  apply WidePullback.hom_ext (fun _ : Fin (p + 1) => Sigma.desc 𝒰.f)
  · intro l
    exact congrArg CommaMorphism.left (h l)
  · exact (Over.w u).trans (Over.w v).symm

/-- The Čech-nerve simplicial face intertwines the backbone projections: the geometric
coface followed by the `l`-th projection is the `δᵏ l`-th projection. -/
lemma nerveδ_backboneProj (𝒰 : X.OpenCover) (p : ℕ) (k : Fin (p + 2)) (l : Fin (p + 1)) :
    (coverCechNerveOver 𝒰).map ((SimplexCategory.δ k).op) ≫ backboneProj 𝒰 p l =
      backboneProj 𝒰 (p + 1) ((SimplexCategory.δ k).toOrderHom l) := by
  apply Over.OverMorphism.ext
  exact WidePullback.lift_π (fun _ : Fin (p + 1) => Sigma.desc 𝒰.f) _ _ _ l

-- The `rfl` unfolds the whiskered augmented-cosimplicial packaging of `CechNerve`, whose
-- kernel `whnf` exceeds the default budget.
set_option maxHeartbeats 1600000 in
/-- The evaluated Čech-nerve coface is the push–pull map of the geometric backbone
simplicial face (definitional unwinding of `CechNerve`). -/
lemma cechNerve_drop_δ (𝒰 : X.OpenCover) (F : X.Modules) {p : ℕ} (k : Fin (p + 2)) :
    (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ k =
      pushPullMap F ((coverCechNerveOver 𝒰).map ((SimplexCategory.δ k).op)) :=
  rfl

/-- The canonical lift of the intersection-open inclusion `U_τ ↪ X` against the
`τ l`-th cover member (an open immersion). -/
noncomputable def coverInterToMember (𝒰 : X.OpenCover) {p : ℕ}
    (τ : Fin (p + 1) → 𝒰.I₀) (l : Fin (p + 1)) :
    Scheme.Opens.toScheme (coverInterOpen 𝒰 τ) ⟶ 𝒰.X (τ l) :=
  IsOpenImmersion.lift (𝒰.f (τ l)) (Scheme.Opens.ι (coverInterOpen 𝒰 τ)) (by
    rw [Scheme.Opens.range_ι, ← Scheme.Hom.coe_opensRange]
    exact SetLike.coe_subset_coe.mpr (iInf_le (fun j => coverOpen 𝒰 (τ j)) l))

/-- Factorization property of `coverInterToMember`. -/
lemma coverInterToMember_fac (𝒰 : X.OpenCover) {p : ℕ} (τ : Fin (p + 1) → 𝒰.I₀)
    (l : Fin (p + 1)) :
    coverInterToMember 𝒰 τ l ≫ 𝒰.f (τ l) = Scheme.Opens.ι (coverInterOpen 𝒰 τ) :=
  IsOpenImmersion.lift_fac _ _ _

/-- The canonical `l`-th component of the `τ`-leg in the cover-arrow object: lift to the
`τ l`-th member, then include into the coproduct. -/
noncomputable def interProj (𝒰 : X.OpenCover) {p : ℕ} (τ : Fin (p + 1) → 𝒰.I₀)
    (l : Fin (p + 1)) :
    Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 τ)) ⟶ Over.mk (Sigma.desc 𝒰.f) :=
  Over.homMk (coverInterToMember 𝒰 τ l ≫ Sigma.ι 𝒰.X (τ l)) (by
    show (coverInterToMember 𝒰 τ l ≫ Sigma.ι 𝒰.X (τ l)) ≫ Sigma.desc 𝒰.f =
      Scheme.Opens.ι (coverInterOpen 𝒰 τ)
    rw [Category.assoc, Sigma.ι_desc]
    exact coverInterToMember_fac 𝒰 τ l)

/-- Mono-target rigidity in the slice: two over-`X` morphisms into `Over.mk g` with `g`
a monomorphism agree.  (Used to absorb the reindexing isos of the Stub-1 chain.) -/
lemma over_hom_ext_mono {A : Over X} {B : Scheme.{u}} {g : B ⟶ X} [Mono g]
    (u v : A ⟶ Over.mk g) : u = v :=
  Over.OverMorphism.ext ((cancel_mono g).mp ((Over.w u).trans (Over.w v).symm))

/-- The face morphism between intersection-open legs: deleting the `k`-th index of `σ'`
enlarges the intersection, giving the open inclusion `U_{σ'} ⊆ U_{σ'∘δᵏ}`. -/
noncomputable def interLegHom (𝒰 : X.OpenCover) {p : ℕ} (σ' : Fin (p + 2) → 𝒰.I₀)
    (k : Fin (p + 2)) :
    Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ')) ⟶
      Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom))) :=
  Over.homMk (X.homOfLE (le_iInf (fun l => iInf_le (fun j => coverOpen 𝒰 (σ' j))
      ((SimplexCategory.δ k).toOrderHom l))))
    (Scheme.homOfLE_ι _ _)

/-- The face morphism intertwines the canonical component maps: projecting the `σ'`-leg
onto its `δᵏ l`-th component agrees with first including `U_{σ'} ⊆ U_{σ'∘δᵏ}` and then
projecting onto the `l`-th component.  Both lifts agree after the mono `𝒰.f _`. -/
lemma interLegHom_interProj (𝒰 : X.OpenCover) {p : ℕ} (σ' : Fin (p + 2) → 𝒰.I₀)
    (k : Fin (p + 2)) (l : Fin (p + 1)) :
    interLegHom 𝒰 σ' k ≫ interProj 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom) l =
      interProj 𝒰 σ' ((SimplexCategory.δ k).toOrderHom l) := by
  have hfac : X.homOfLE (le_iInf (fun l' => iInf_le (fun j => coverOpen 𝒰 (σ' j))
        ((SimplexCategory.δ k).toOrderHom l'))) ≫
        coverInterToMember 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom) l =
      coverInterToMember 𝒰 σ' ((SimplexCategory.δ k).toOrderHom l) := by
    haveI : IsOpenImmersion (𝒰.f (σ' ((SimplexCategory.δ k).toOrderHom l))) := inferInstance
    refine IsOpenImmersion.lift_uniq (𝒰.f (σ' ((SimplexCategory.δ k).toOrderHom l)))
      (Scheme.Opens.ι (coverInterOpen 𝒰 σ')) ?_ _ ?_
    refine (Category.assoc _ _ _).trans ?_
    refine (congrArg (fun w => X.homOfLE (le_iInf (fun l' => iInf_le
        (fun j => coverOpen 𝒰 (σ' j)) ((SimplexCategory.δ k).toOrderHom l'))) ≫ w)
      (coverInterToMember_fac 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom) l)).trans ?_
    exact Scheme.homOfLE_ι _ _
  apply Over.OverMorphism.ext
  exact (Category.assoc _ _ _).symm.trans
    (congrArg (fun w => w ≫ Sigma.ι 𝒰.X (σ' ((SimplexCategory.δ k).toOrderHom l))) hfac)

/-- **Backbone inclusion/projection characterization** (the Stub-1 unwinding): the
`τ`-summand inclusion of the backbone followed by the `l`-th wide-pullback projection is
the canonical component map `interProj 𝒰 τ l`. -/
lemma backboneIncl_proj (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (p : ℕ)
    (τ : Fin (p + 1) → 𝒰.I₀) (l : Fin (p + 1)) :
    backboneIncl 𝒰 p τ ≫ backboneProj 𝒰 p l = interProj 𝒰 τ l := by
  sorry

/-- **Per-leg coface factorization of the backbone inclusion** (★): the `σ'`-summand
inclusion of the degree-`(p+1)` backbone followed by the geometric nerve coface
factors as the open inclusion `U_{σ'} ⊆ U_{σ'∘δᵏ}` followed by the `σ'∘δᵏ`-summand
inclusion of the degree-`p` backbone.  Proved projection-by-projection
(`backbone_hom_ext`), where both sides become canonical component maps. -/
lemma backboneIncl_nerveδ (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (p : ℕ)
    (k : Fin (p + 2)) (σ' : Fin (p + 2) → 𝒰.I₀) :
    backboneIncl 𝒰 (p + 1) σ' ≫ (coverCechNerveOver 𝒰).map ((SimplexCategory.δ k).op) =
      interLegHom 𝒰 σ' k ≫ backboneIncl 𝒰 p (σ' ∘ (SimplexCategory.δ k).toOrderHom) := by
  apply backbone_hom_ext
  intro l
  rw [Category.assoc, nerveδ_backboneProj, backboneIncl_proj, Category.assoc,
    backboneIncl_proj, interLegHom_interProj]

/-! ### Section-level seam: projecting `coreIso_objIso` and the per-leg restriction. -/

/-- The section-at-`V` functor `Γ(V, ·) : X.Modules ⥤ Ab` (the `E` of
`pushPull_eval_prod_iso`). -/
noncomputable abbrev sectionFunctorV (V : TopologicalSpace.Opens ↥X) : X.Modules ⥤ Ab.{u} :=
  Scheme.Modules.toPresheaf X ⋙
    (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ Ab.{u}).obj (Opposite.op V)

/-- The statement-level evaluated adapter `G_V ∘ Ψ` agrees with `sectionFunctorV` on
morphisms of `X.Modules` (definitional: `restrictScalars (𝟙 _)` does not change the
underlying abelian presheaf map). -/
lemma GVΨ_map_eq (V : TopologicalSpace.Opens ↥X) {M N : X.Modules} (φ : M ⟶ N) :
    (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
        (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
      ((SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map φ) =
    (sectionFunctorV V).map φ :=
  rfl

/-- Projection of a `Pi.mapIso` onto a factor (the `limMap_π` instance for discrete
shapes, stated so it can be `rw`-applied against the bundled section products). -/
@[reassoc]
private lemma piMapIso_hom_π {β : Type u} {f g : β → Ab.{u}}
    (w : ∀ b, f b ≅ g b) (b : β) :
    (Pi.mapIso w).hom ≫ Pi.π g b = Pi.π f b ≫ (w b).hom :=
  limMap_π (Discrete.natIso fun j => w j.as).hom ⟨b⟩

-- The unfolding of `coreIso_objIso`/`pushPull_eval_prod_iso` is `whnf`-heavy on the
-- bundled section types.
set_option maxHeartbeats 1600000 in
/-- **Coordinate formula for the degreewise object iso** (`coreIso_objIso`): its
`τ`-projection is the evaluated push–pull map of the backbone inclusion `backboneIncl`,
followed by the per-leg section identification `pushPull_leg_sections` and the open-meet
reindex of `coverInterOpen_inf_eq_iInf_inf`. -/
lemma coreIso_objIso_π (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (p : ℕ)
    (V : TopologicalSpace.Opens ↥X) (τ : Fin (p + 1) → 𝒰.I₀) :
    (coreIso_objIso 𝒰 F p V).hom ≫
        Pi.π (fun σ : Fin (p + 1) → 𝒰.I₀ =>
          ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
            (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) τ =
      (sectionFunctorV V).map (pushPullMap F (backboneIncl 𝒰 p τ)) ≫
        (pushPull_leg_sections 𝒰 F τ V).hom ≫
        eqToHom (congrArg (fun W =>
            ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (Opposite.op W))
          (coverInterOpen_inf_eq_iInf_inf 𝒰 τ V)) := by
  simp only [coreIso_objIso, pushPull_eval_prod_iso, Iso.trans_hom, Functor.mapIso_hom,
    Category.assoc]
  rw [piMapIso_hom_π, piMapIso_hom_π_assoc, PreservesProduct.iso_hom,
    piComparison_comp_π_assoc, ← Functor.map_comp_assoc, pushPull_sigma_iso_π_incl]
  simp only [eqToIso.hom]

/-- **Per-leg restriction naturality** (the sheaf-theoretic seam): the evaluated push–pull
map of the face inclusion `interLegHom : U_{σ'} ⊆ U_{σ'∘δᵏ}` acts on the identified leg
sections as the plain `F`-restriction along `U_{σ'} ⊓ V ⊆ U_{σ'∘δᵏ} ⊓ V`. -/
lemma pushPull_interLegHom_sections (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens ↥X) {p : ℕ} (σ' : Fin (p + 2) → 𝒰.I₀) (k : Fin (p + 2)) :
    (sectionFunctorV V).map (pushPullMap F (interLegHom 𝒰 σ' k)) ≫
        (pushPull_leg_sections 𝒰 F σ' V).hom =
      (pushPull_leg_sections 𝒰 F (σ' ∘ (SimplexCategory.δ k).toOrderHom) V).hom ≫
        ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
          (homOfLE (inf_le_inf_right V (le_iInf (fun l =>
            iInf_le (fun j => coverOpen 𝒰 (σ' j))
              ((SimplexCategory.δ k).toOrderHom l))))).op := by
  sorry

/-- Thin-category fusion of presheaf restrictions against `eqToHom` reindexes: a
restriction map conjugated by object-equality transports equals any other restriction
map between the transported section groups (`Opens`-homs are subsingletons). -/
private lemma map_op_eqToHom_swap (P : (TopologicalSpace.Opens ↥X)ᵒᵖ ⥤ Ab.{u})
    {A B A' B' : TopologicalSpace.Opens ↥X} (hA : A = A') (hB : B = B')
    (f : A ⟶ B) (g : A' ⟶ B') :
    P.map f.op ≫ eqToHom (congrArg (fun W => P.obj (Opposite.op W)) hA) =
      eqToHom (congrArg (fun W => P.obj (Opposite.op W)) hB) ≫ P.map g.op := by
  subst hA
  subst hB
  rw [eqToHom_refl, eqToHom_refl, Category.comp_id, Category.id_comp]
  exact congrArg (fun u => P.map u) (congrArg Quiver.Hom.op (Subsingleton.elim f g))

set_option maxHeartbeats 1600000 in
/-- **Per-leg naturality of the core comparison coface** (`lem:coreIso_comm_leg`).
For a fixed coface index `k` and multi-index `σ'`, the `σ'`-coordinate (the projection
`Pi.π … σ'`) of the evaluated push–pull coface `G_V(Ψ(δ^nerve_k))` followed by the
degree-`(p+1)` object iso equals the presheaf face restriction `sectionCechFaceRestr σ' k`
applied to the `(σ' ∘ d_k)`-coordinate of the degree-`p` object iso.  This is the genuine
geometric unwinding of `coreIso_objIso` through `pushPull_eval_prod_iso`,
`pushPull_sigma_iso`, the product-leg projection, and `pushPull_leg_sections`. -/
lemma coreIso_comm_leg (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens X) (p : ℕ) (k : Fin (p + 2)) (σ' : Fin (p + 2) → 𝒰.I₀) :
    (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
          (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
        ((SheafOfModules.forget X.ringCatSheaf ⋙
            PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
          ((CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ k)) ≫
        (coreIso_objIso 𝒰 F (p + 1) V).hom ≫
        Pi.π (fun σ : Fin (p + 2) → 𝒰.I₀ =>
          ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
            (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) σ' =
      (coreIso_objIso 𝒰 F p V).hom ≫
        Pi.π (fun τ : Fin (p + 1) → 𝒰.I₀ =>
          ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
            (Opposite.op (⨅ l, (coverOpen 𝒰 (τ l) ⊓ V))))
          (σ' ∘ (SimplexCategory.δ k).toOrderHom) ≫
        sectionCechFaceRestr (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F) σ' k := by
  -- 1. Collapse the nerve coface to the push–pull map of the geometric face, and unwind
  --    both object isos through their coordinate formula `coreIso_objIso_π`.
  rw [cechNerve_drop_δ 𝒰 F k, GVΨ_map_eq, coreIso_objIso_π 𝒰 F (p + 1) V σ',
    ← Functor.map_comp_assoc, ← pushPullMap_comp, backboneIncl_nerveδ 𝒰 p k σ',
    pushPullMap_comp, Functor.map_comp_assoc,
    ← Category.assoc ((coreIso_objIso 𝒰 F p V).hom),
    coreIso_objIso_π 𝒰 F p V (σ' ∘ (SimplexCategory.δ k).toOrderHom)]
  simp only [Category.assoc]
  -- 2. Peel the common backbone-inclusion prefix.
  refine congrArg (fun w => (sectionFunctorV V).map
    (pushPullMap F (backboneIncl 𝒰 p (σ' ∘ (SimplexCategory.δ k).toOrderHom))) ≫ w) ?_
  -- 3. The evaluated face inclusion is the plain `F`-restriction on leg sections.
  rw [← Category.assoc, pushPull_interLegHom_sections 𝒰 F V σ' k, Category.assoc]
  refine congrArg (fun w =>
    (pushPull_leg_sections 𝒰 F (σ' ∘ (SimplexCategory.δ k).toOrderHom) V).hom ≫ w) ?_
  -- 4. Thin-category fusion of the residual restriction/reindex square.
  exact map_op_eqToHom_swap (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf)
    (coverInterOpen_inf_eq_iInf_inf 𝒰 σ' V)
    (coverInterOpen_inf_eq_iInf_inf 𝒰 (σ' ∘ (SimplexCategory.δ k).toOrderHom) V)
    (homOfLE (inf_le_inf_right V (le_iInf (fun l => iInf_le (fun j => coverOpen 𝒰 (σ' j))
      ((SimplexCategory.δ k).toOrderHom l)))))
    (homOfLE (le_iInf (fun l => iInf_le (fun j => coverOpen 𝒰 (σ' j) ⊓ V)
      ((SimplexCategory.δ k).toOrderHom l))))

set_option maxHeartbeats 6400000 in
/-- **Per-coface square of the core comparison** (`lem:coreIso_comm_coface`): for each
degree `p` and coface index `k`, the object isos intertwine the individual cofaces.
Coordinatewise extensionality (`Pi.hom_ext`); the `σ'`-coordinate of the left side is the
face restriction by the defining `Pi.lift_π` of the section-Čech cosimplicial map, and the
right side is `coreIso_comm_leg`. -/
lemma coreIso_comm_coface (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens X) (p : ℕ) (k : Fin (p + 2)) :
    (coreIso_objIso 𝒰 F p V).hom ≫
        (sectionCechCosimplicial (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F)).δ k =
      (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
            (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
          ((SheafOfModules.forget X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
            ((CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ k)) ≫
        (coreIso_objIso 𝒰 F (p + 1) V).hom := by
  ext x
  apply (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) (p + 1)).injective
  funext σ'
  have hπ : (sectionCechCosimplicial (fun a => coverOpen 𝒰 a ⊓ V)
        ((SheafOfModules.forget X.ringCatSheaf).obj F)).map (SimplexCategory.δ k) ≫
        Pi.π _ σ' =
      Pi.π _ (σ' ∘ (SimplexCategory.δ k).toOrderHom) ≫
        sectionCechFaceRestr (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F) σ' k :=
    Pi.lift_π _ σ'
  have hL := ConcreteCategory.congr_hom hπ (ConcreteCategory.hom (coreIso_objIso 𝒰 F p V).hom x)
  have hR := ConcreteCategory.congr_hom (coreIso_comm_leg 𝒰 F V p k σ') x
  exact ((sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (p + 1) _ σ').trans hL).trans
    (((sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (p + 1) _ σ').trans hR).symm)

set_option maxHeartbeats 6400000 in
/-- **Alternating-sum assembly of the core comparison square** (`lem:coreIso_comm_sum`):
the full alternating-coface differentials are intertwined by the object isos.  Proved
ELEMENTWISE (per the iter-067 dead-end note: no `Preadditive.comp_sum` against the bundled
`AddCommGrpCat`-hom `objD`): both sides, evaluated at an element and a coordinate `σ'`, are
the same finite alternating sum, matched summand-by-summand by `coreIso_comm_leg`. -/
lemma coreIso_comm_sum (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens X) (p : ℕ) :
    (coreIso_objIso 𝒰 F p V).hom ≫
        AlgebraicTopology.AlternatingCofaceMapComplex.objD
          (sectionCechCosimplicial (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F)) p =
      (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
            (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
          ((SheafOfModules.forget X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
            (AlgebraicTopology.AlternatingCofaceMapComplex.objD
              (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)) p)) ≫
        (coreIso_objIso 𝒰 F (p + 1) V).hom := by
  haveI : (SheafOfModules.forget X.ringCatSheaf ⋙
      PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).Additive := inferInstance
  haveI : (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).Additive :=
    inferInstance
  -- (1) Element-level decomposition of the evaluated nerve differential.  All steps are
  -- term-chained (`Eq.trans`/`congrArg`) — no `rw` of a `have` against the goal, dodging the
  -- instance-path mismatch on the `Finset.sum` of the `Preadditive` hom group.
  have hpush : ∀ x : ToType (((SheafOfModules.forget X.ringCatSheaf).obj
        (pushPullObj F
          ((coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p))))).presheaf.obj
        (Opposite.op V)),
      ConcreteCategory.hom
          ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
              (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
            ((SheafOfModules.forget X.ringCatSheaf ⋙
                PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
              (AlgebraicTopology.AlternatingCofaceMapComplex.objD
                (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)) p))) x =
        ∑ i : Fin (p + 2), (-1 : ℤ) ^ (i : ℕ) •
          ConcreteCategory.hom
            ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
                (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
              ((SheafOfModules.forget X.ringCatSheaf ⋙
                  PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
                ((CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ i))) x := by
    intro x
    have h1 : (SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
          (AlgebraicTopology.AlternatingCofaceMapComplex.objD
            (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)) p) =
        ∑ i : Fin (p + 2), (SheafOfModules.forget X.ringCatSheaf ⋙
            PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
          ((-1 : ℤ) ^ (i : ℕ) • (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ i) :=
      Functor.map_sum _ _ _
    have h2 : (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
          (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
          ((SheafOfModules.forget X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
            (AlgebraicTopology.AlternatingCofaceMapComplex.objD
              (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)) p)) =
        ∑ i : Fin (p + 2),
          (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
              (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
            ((SheafOfModules.forget X.ringCatSheaf ⋙
                PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
              ((-1 : ℤ) ^ (i : ℕ) •
                (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ i)) :=
      (congrArg (fun m => (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
          (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj
            (Opposite.op V)).map m) h1).trans
        (Functor.map_sum _ _ _)
    refine (ConcreteCategory.congr_hom h2 x).trans ?_
    rw [abHom_finsetSum_apply]
    refine Finset.sum_congr rfl fun i _ => ?_
    have h3 : (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
          (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
          ((SheafOfModules.forget X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
            ((-1 : ℤ) ^ (i : ℕ) •
              (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ i)) =
        (-1 : ℤ) ^ (i : ℕ) •
          (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
              (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
            ((SheafOfModules.forget X.ringCatSheaf ⋙
                PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
              ((CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ i)) :=
      (congrArg (fun m => (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
          (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj
            (Opposite.op V)).map m)
        (Functor.map_zsmul _)).trans (Functor.map_zsmul _)
    exact (ConcreteCategory.congr_hom h3 x).trans rfl
  -- (2) Elementwise comparison through the product equivalence, coordinate by coordinate.
  ext x
  apply (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) (p + 1)).injective
  funext σ'
  refine Eq.trans (sectionCech_objD_apply (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) p
    (ConcreteCategory.hom (coreIso_objIso 𝒰 F p V).hom x) σ') (Eq.symm ?_)
  refine Eq.trans (sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) (p + 1) _ σ') ?_
  refine Eq.trans (congrArg
      (ConcreteCategory.hom (Pi.π (fun σ : Fin (p + 2) → 𝒰.I₀ =>
        ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
          (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) σ'))
      (ConcreteCategory.comp_apply _ ((coreIso_objIso 𝒰 F (p + 1) V).hom) x)) ?_
  refine Eq.trans (congrArg
      (ConcreteCategory.hom (Pi.π (fun σ : Fin (p + 2) → 𝒰.I₀ =>
        ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
          (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) σ'))
      (congrArg (ConcreteCategory.hom (coreIso_objIso 𝒰 F (p + 1) V).hom) (hpush x))) ?_
  refine Eq.trans (congrArg
      (ConcreteCategory.hom (Pi.π (fun σ : Fin (p + 2) → 𝒰.I₀ =>
        ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
          (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) σ'))
      (map_sum (ConcreteCategory.hom (coreIso_objIso 𝒰 F (p + 1) V).hom) _ Finset.univ)) ?_
  refine Eq.trans (map_sum (ConcreteCategory.hom (Pi.π (fun σ : Fin (p + 2) → 𝒰.I₀ =>
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) σ')) _ Finset.univ) ?_
  refine Finset.sum_congr rfl fun i _ => ?_
  refine Eq.trans (congrArg
      (ConcreteCategory.hom (Pi.π (fun σ : Fin (p + 2) → 𝒰.I₀ =>
        ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
          (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) σ'))
      (map_zsmul (ConcreteCategory.hom (coreIso_objIso 𝒰 F (p + 1) V).hom) _ _)) ?_
  refine Eq.trans (map_zsmul (ConcreteCategory.hom (Pi.π (fun σ : Fin (p + 2) → 𝒰.I₀ =>
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op (⨅ l, (coverOpen 𝒰 (σ l) ⊓ V)))) σ')) _ _) ?_
  congr 1
  have hleg := ConcreteCategory.congr_hom (coreIso_comm_leg 𝒰 F V p i σ') x
  simp only [ConcreteCategory.comp_apply] at hleg
  rw [sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) p
    (ConcreteCategory.hom (coreIso_objIso 𝒰 F p V).hom x)
    (σ' ∘ (SimplexCategory.δ i).toOrderHom)]
  exact hleg

set_option maxHeartbeats 1600000 in
/-- **The core comparison intertwines the Čech differentials** (`lem:coreIso_comm`).  Under the
degreewise object isos `coreIso_objIso`, the alternating-coface differential of the evaluated
backbone complex `(G_V ∘ Ψ) Č•(𝒰, F)` matches the alternating-coface differential of the
concrete restricted section complex `Č•(𝒰', F)`.  The square is exactly the alternating-sum
assembly `coreIso_comm_sum` (built from the per-coface squares `coreIso_comm_coface`, in turn
from the per-leg naturality `coreIso_comm_leg`). -/
lemma coreIso_comm (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens X) (i j : ℕ) (hij : (ComplexShape.up ℕ).Rel i j) :
    (coreIso_objIso 𝒰 F i V).hom ≫ (sectionCechComplexV 𝒰 F V).d i j =
      (((PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
            (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj
              (Opposite.op V)).mapHomologicalComplex (ComplexShape.up ℕ)).obj
          (((SheafOfModules.forget X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).mapHomologicalComplex
            (ComplexShape.up ℕ)).obj (cechComplexOnX 𝒰 F))).d i j ≫
        (coreIso_objIso 𝒰 F j V).hom := by
  obtain rfl : i + 1 = j := hij
  rw [Functor.mapHomologicalComplex_obj_d, Functor.mapHomologicalComplex_obj_d]
  have hsec : (sectionCechComplexV 𝒰 F V).d i (i + 1) =
      AlgebraicTopology.AlternatingCofaceMapComplex.objD
        (sectionCechCosimplicial (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F)) i :=
    CochainComplex.of_d _ _ (AlgebraicTopology.AlternatingCofaceMapComplex.d_squared _) i
  have hX : (cechComplexOnX 𝒰 F).d i (i + 1) =
      AlgebraicTopology.AlternatingCofaceMapComplex.objD
        (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)) i :=
    CochainComplex.of_d _ _ (AlgebraicTopology.AlternatingCofaceMapComplex.d_squared _) i
  rw [hsec, hX]
  exact coreIso_comm_sum 𝒰 F V i

end AlgebraicGeometry
