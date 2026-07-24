/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechSectionIdentification

/-!
# Contractibility of the concrete section Čech complex

This file constructs a contracting homotopy for the augmented concrete section Čech complex
over an open contained in one member of the cover.
-/

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

open Scheme.Modules

variable {X : Scheme.{u}}

/-! ## Contracting homotopy on the augmented concrete section Čech complex -/

/-! ### Restriction engine

The dependent-coefficient combinatorial Čech engine (`CombinatorialCech.depHomotopy_spec`,
CechAcyclic.lean) is instantiated with the augmentation node `Γ(V, F)` as level `0` and the
restricted Čech coefficients `Γ(⨅ₖ (U_{σ k} ⊓ V), F)` as levels `≥ 1`.  The coface maps `δ`
are the presheaf face restrictions (level `0 → 1` is the augmentation restriction), and the
prepend maps `c` are genuine restrictions because `V ≤ coverOpen 𝒰 i_fix` forces
`U'_{i_fix·σ} = U'_σ`.  The `hu`/`hsh` compatibilities collapse to "two parallel restriction
chains between the same opens agree". -/

section RestrictionEngine

variable (𝒰 : X.OpenCover) (F : X.Modules) (V : TopologicalSpace.Opens X)

/-- Composite of two presheaf restrictions is the direct restriction (local copy of the
`CechBridge` private helper `restr_trans`). -/
private lemma stubRestrTrans (P : (TopologicalSpace.Opens ↥X)ᵒᵖ ⥤ Ab.{u})
    {A B C : TopologicalSpace.Opens ↥X} (h1 : A ≤ B) (h2 : B ≤ C)
    (x : ToType (P.obj (Opposite.op C))) :
    ConcreteCategory.hom (P.map (homOfLE h1).op)
        (ConcreteCategory.hom (P.map (homOfLE h2).op) x)
      = ConcreteCategory.hom (P.map (homOfLE (h1.trans h2)).op) x := by
  rw [← ConcreteCategory.comp_apply, ← P.map_comp, ← op_comp]
  rfl

/-- Two parallel presheaf restrictions agree (poset-hom uniqueness; local copy of the
`CechBridge` private helper `restr_op_unique`). -/
private lemma stubRestrUnique (P : (TopologicalSpace.Opens ↥X)ᵒᵖ ⥤ Ab.{u})
    {A C : TopologicalSpace.Opens ↥X} (f g : Opposite.op C ⟶ Opposite.op A)
    (x : ToType (P.obj (Opposite.op C))) :
    ConcreteCategory.hom (P.map f) x = ConcreteCategory.hom (P.map g) x := by
  rw [show f = g from Quiver.Hom.unop_inj (Subsingleton.elim _ _)]

/-- A nonempty restricted Čech intersection is contained in `V`. -/
private lemma stubInterLeV {m : ℕ} (σ : Fin (m + 1) → 𝒰.I₀) :
    (⨅ k, (coverOpen 𝒰 (σ k) ⊓ V)) ≤ V :=
  le_trans (iInf_le _ 0) inf_le_right

/-- Prepending `i_fix` does not shrink the restricted intersection (positive levels). -/
private lemma stubConsLe {m : ℕ} (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix)
    (σ : Fin (m + 1) → 𝒰.I₀) :
    (⨅ k, (coverOpen 𝒰 (σ k) ⊓ V)) ≤
      ⨅ k, (coverOpen 𝒰 ((Fin.cons i_fix σ : Fin (m + 2) → 𝒰.I₀) k) ⊓ V) := by
  refine le_iInf fun k => ?_
  refine Fin.cases ?_ ?_ k
  · rw [Fin.cons_zero]
    exact le_trans (stubInterLeV 𝒰 V σ) (le_inf hiV le_rfl)
  · intro j
    rw [Fin.cons_succ]
    exact iInf_le _ j

/-- Prepending `i_fix` to the empty tuple yields an intersection containing `V`
(the augmentation node case). -/
private lemma stubConsLeZero (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix)
    (σ : Fin 0 → 𝒰.I₀) :
    V ≤ ⨅ k, (coverOpen 𝒰 ((Fin.cons i_fix σ : Fin 1 → 𝒰.I₀) k) ⊓ V) := by
  refine le_iInf fun k => ?_
  rw [Fin.fin_one_eq_zero k, Fin.cons_zero]
  exact le_inf hiV le_rfl

/-- The open underlying the level-`m` Stub-6 coefficient: level `0` is `V` (the
augmentation node), level `m+1` is the restricted intersection `⨅ₖ (U_{σ k} ⊓ V)`. -/
private def stubOpen : (m : ℕ) → (Fin m → 𝒰.I₀) → TopologicalSpace.Opens ↥X
  | 0, _ => V
  | _ + 1, σ => ⨅ k, (coverOpen 𝒰 (σ k) ⊓ V)

/-- The coface inclusion of the Stub-6 opens. -/
private lemma stubOpen_le_coface : ∀ {m : ℕ} (σ : Fin (m + 1) → 𝒰.I₀) (j : Fin (m + 1)),
    stubOpen 𝒰 V (m + 1) σ ≤ stubOpen 𝒰 V m (σ ∘ j.succAbove)
  | 0, σ, _ => stubInterLeV 𝒰 V σ
  | _ + 1, _, j => le_iInf fun l => iInf_le _ (j.succAbove l)

/-- The prepend inclusion of the Stub-6 opens (prepending `i_fix` does not shrink the
open, because `V ≤ coverOpen 𝒰 i_fix`). -/
private lemma stubOpen_le_prepend (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix) :
    ∀ {m : ℕ} (σ : Fin m → 𝒰.I₀),
      stubOpen 𝒰 V m σ ≤ stubOpen 𝒰 V (m + 1) (Fin.cons i_fix σ)
  | 0, σ => stubConsLeZero 𝒰 V i_fix hiV σ
  | _ + 1, σ => stubConsLe 𝒰 V i_fix hiV σ

/-- Dependent coefficient family for the Stub-6 engine: the sections of `F` over
`stubOpen m σ`.  Kept as a reducible abbreviation so the `AddCommGroup` instance is the
generic one on `Ab`-objects (no bespoke match-instance). -/
private noncomputable abbrev cechSectionCoeff (m : ℕ) (σ : Fin m → 𝒰.I₀) : Type u :=
  ToType (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
    (Opposite.op (stubOpen 𝒰 V m σ)))

/-- The engine coface maps: presheaf face restrictions (level `0 → 1` is the augmentation
restriction `Γ(V) → Γ(U'_σ)`). -/
private noncomputable def cechSectionCoface (m : ℕ) (σ : Fin (m + 1) → 𝒰.I₀)
    (j : Fin (m + 1)) :
    cechSectionCoeff 𝒰 F V m (σ ∘ j.succAbove) →+ cechSectionCoeff 𝒰 F V (m + 1) σ :=
  ConcreteCategory.hom (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
    (homOfLE (stubOpen_le_coface 𝒰 V σ j)).op)

/-- The engine prepend maps: genuine restrictions (level `1 → 0` is the restriction
`Γ(U'_{(i_fix)}) → Γ(V)` along `V ≤ U'_{i_fix}`). -/
private noncomputable def cechSectionPrepend (i_fix : 𝒰.I₀)
    (hiV : V ≤ coverOpen 𝒰 i_fix) (m : ℕ) (σ : Fin m → 𝒰.I₀) :
    cechSectionCoeff 𝒰 F V (m + 1) (Fin.cons i_fix σ) →+ cechSectionCoeff 𝒰 F V m σ :=
  ConcreteCategory.hom (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
    (homOfLE (stubOpen_le_prepend 𝒰 V i_fix hiV σ)).op)

/-- Transport of a Čech coefficient along an equality of index tuples is the canonical
restriction between the (equal) intersection opens. -/
private lemma cechSectionCoeff_transport {m : ℕ} {τ₁ τ₂ : Fin (m + 1) → 𝒰.I₀}
    (h : τ₁ = τ₂)
    (hle : stubOpen 𝒰 V (m + 1) τ₂ ≤ stubOpen 𝒰 V (m + 1) τ₁)
    (y : cechSectionCoeff 𝒰 F V (m + 1) τ₁) :
    (h ▸ y : cechSectionCoeff 𝒰 F V (m + 1) τ₂)
      = ConcreteCategory.hom
          (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map (homOfLE hle).op)
          y := by
  subst h
  rw [show homOfLE hle = 𝟙 _ from Subsingleton.elim _ _, op_id,
    CategoryTheory.Functor.map_id]
  rfl

/-- Unit compatibility `hu` for the Stub-6 engine: deleting the prepended `i_fix` and then
applying the prepend restriction is the identity transport (both sides are restriction
chains between the same opens). -/
private lemma cechSection_hu (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix)
    {m : ℕ} (σ : Fin (m + 1) → 𝒰.I₀)
    (y : cechSectionCoeff 𝒰 F V (m + 1)
      ((Fin.cons i_fix σ : Fin (m + 2) → 𝒰.I₀) ∘ (0 : Fin (m + 2)).succAbove)) :
    cechSectionPrepend 𝒰 F V i_fix hiV (m + 1) σ
        (cechSectionCoface 𝒰 F V (m + 1) (Fin.cons i_fix σ) 0 y)
      = (CombinatorialCech.cons_comp_zero_succAbove i_fix σ) ▸ y := by
  rw [cechSectionCoeff_transport 𝒰 F V (CombinatorialCech.cons_comp_zero_succAbove i_fix σ)
    (le_of_eq (by rw [CombinatorialCech.cons_comp_zero_succAbove i_fix σ]))]
  exact (stubRestrTrans _ _ _ y).trans (stubRestrUnique _ _ _ y)

/-- Shift compatibility `hsh` for the Stub-6 engine: prepend commutes with the later
cofaces (both sides are restriction chains between the same opens). -/
private lemma cechSection_hsh (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix)
    {m : ℕ} (σ : Fin (m + 1) → 𝒰.I₀) (k : Fin (m + 1))
    (y : cechSectionCoeff 𝒰 F V (m + 1)
      ((Fin.cons i_fix σ : Fin (m + 2) → 𝒰.I₀) ∘ (k.succ).succAbove)) :
    cechSectionPrepend 𝒰 F V i_fix hiV (m + 1) σ
        (cechSectionCoface 𝒰 F V (m + 1) (Fin.cons i_fix σ) k.succ y)
      = cechSectionCoface 𝒰 F V m σ k
          (cechSectionPrepend 𝒰 F V i_fix hiV m (σ ∘ k.succAbove)
            ((CombinatorialCech.cons_comp_succAbove_succ i_fix σ k) ▸ y)) := by
  have hle : stubOpen 𝒰 V (m + 1) (Fin.cons i_fix (σ ∘ k.succAbove)) ≤
      stubOpen 𝒰 V (m + 1) ((Fin.cons i_fix σ : Fin (m + 2) → 𝒰.I₀) ∘ (k.succ).succAbove) :=
    le_of_eq (by rw [CombinatorialCech.cons_comp_succAbove_succ i_fix σ k])
  rw [cechSectionCoeff_transport 𝒰 F V
    (CombinatorialCech.cons_comp_succAbove_succ i_fix σ k) hle]
  refine Eq.trans (stubRestrTrans _ (stubOpen_le_prepend 𝒰 V i_fix hiV σ)
    (stubOpen_le_coface 𝒰 V (Fin.cons i_fix σ) k.succ) y) ?_
  refine Eq.trans (stubRestrUnique _ _ (homOfLE ((stubOpen_le_coface 𝒰 V σ k).trans
    ((stubOpen_le_prepend 𝒰 V i_fix hiV (σ ∘ k.succAbove)).trans hle))).op y) ?_
  refine Eq.symm ?_
  refine Eq.trans (DFunLike.congr_arg (cechSectionCoface 𝒰 F V m σ k)
    (stubRestrTrans _ (stubOpen_le_prepend 𝒰 V i_fix hiV (σ ∘ k.succAbove)) hle y)) ?_
  exact stubRestrTrans _ (stubOpen_le_coface 𝒰 V σ k)
    ((stubOpen_le_prepend 𝒰 V i_fix hiV (σ ∘ k.succAbove)).trans hle) y

end RestrictionEngine

/-! ### Degree-0 augmentation seam — helper bricks for `sectionCechAugV_π`.

The seam unwinds `sectionCechAugV ≫ Pi.π σ` through the proved Base seams.  The Čech
augmentation composed with the push–pull of *any* `Over X`-morphism `g : Y ⟶ Y₀` into the
backbone collapses — through the terminal object `Over.mk (𝟙 X)` of `Over X` — to the
pullback–pushforward adjunction unit at `Y.hom` (`cechAugmentation_pushPullMap`); the unit, in
turn, reads through the per-leg section identification `pushPull_leg_sections` as the plain
presheaf restriction (`unit_pushPull_leg_sections`), because it is conjugate via
`Adjunction.leftAdjointUniq` to the restriction adjunction whose unit *is* the restriction on
sections (`Scheme.Modules.restrictAdjunction_unit_app_app`). -/

section AugSeam

/-- An `eqToHom` between section groups of an abelian presheaf over (propositionally) equal
opens is the presheaf restriction along the induced inclusion.  Transport-killer for the
augmentation seam. -/
private lemma stubEqToHomRestr (P : (TopologicalSpace.Opens ↥X)ᵒᵖ ⥤ Ab.{u})
    {A B : TopologicalSpace.Opens ↥X} (hAB : A = B) (hle : B ≤ A)
    (h : P.obj (Opposite.op A) = P.obj (Opposite.op B)) :
    eqToHom h = P.map (homOfLE hle).op := by
  subst hAB
  refine Eq.trans (eqToHom_refl _ h) ?_
  refine Eq.trans (P.map_id (Opposite.op A)).symm ?_
  exact congrArg P.map (congrArg Quiver.Hom.op (Subsingleton.elim (𝟙 A) (homOfLE hle)))

/-- Precomposing the scheme-level push–pull comparison `rawPushPullMap` with the
pullback–pushforward adjunction unit at the source structure map yields the unit at the
target structure map (`η^{p₁} ≫ G(a) = η^{p₂}`, the mate-calculus collapse of the degree-`0`
augmentation leg). -/
private lemma rawPushPullMap_unit {Z₁ Z₂ : Scheme.{u}} (a : Z₂ ⟶ Z₁)
    (p₁ : Z₁ ⟶ X) (p₂ : Z₂ ⟶ X) (w : a ≫ p₁ = p₂) (F : X.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction p₁).unit.app F ≫
        rawPushPullMap a p₁ p₂ w F =
      (Scheme.Modules.pullbackPushforwardAdjunction p₂).unit.app F := by
  subst w
  rw [rawPushPullMap_self, pushPull_unit_comp a p₁ F]
  refine congrArg (fun m =>
    (Scheme.Modules.pullbackPushforwardAdjunction p₁).unit.app F ≫ m) ?_
  refine Eq.trans ((Scheme.Modules.pushforward p₁).map_comp _ _) ?_
  refine congrArg (fun m => (Scheme.Modules.pushforward p₁).map
    ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
      ((Scheme.Modules.pullback p₁).obj F)) ≫ m) ?_
  -- `pushforward` is strict: `p₁_*(a_* χ) = (pushforwardComp).hom ≫ (a ≫ p₁)_* χ`
  -- (the comparison cell is the identity on sections).
  apply Scheme.Modules.hom_ext
  intro U
  rfl

/-- The inverse of the Čech-nerve point identification is the pullback–pushforward
adjunction unit of the identity morphism. -/
private lemma cechNervePointIso_inv_eq_unit (𝒰 : X.OpenCover) (F : X.Modules) :
    (cechNervePointIso 𝒰 F).inv =
      (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 X)).unit.app F := by
  have star := unit_conjugateEquiv (Adjunction.id (C := X.Modules))
    (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 X)) (Scheme.Modules.pullbackId X).hom F
  rw [Scheme.Modules.conjugateEquiv_pullbackId_hom] at star
  simp only [Adjunction.id_unit, NatTrans.id_app, Functor.id_obj] at star
  have star2 : (Scheme.Modules.pushforwardId X).inv.app F =
      (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 X)).unit.app F ≫
        (Scheme.Modules.pushforward (𝟙 X)).map ((Scheme.Modules.pullbackId X).hom.app F) :=
    (Category.id_comp _).symm.trans star
  have hnat := (Scheme.Modules.pushforwardId X).inv.naturality
    ((Scheme.Modules.pullbackId X).inv.app F)
  simp only [Functor.id_obj, Functor.id_map] at hnat
  refine Eq.trans (hnat : (cechNervePointIso 𝒰 F).inv = _) ?_
  refine Eq.trans (congrArg (fun m => m ≫ (Scheme.Modules.pushforward (𝟙 X)).map
    ((Scheme.Modules.pullbackId X).inv.app F)) star2) ?_
  refine Eq.trans (Category.assoc _ _ _) ?_
  refine Eq.trans (congrArg (fun m =>
    (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 X)).unit.app F ≫ m)
    (((Scheme.Modules.pushforward (𝟙 X)).map_comp _ _).symm)) ?_
  refine Eq.trans (congrArg (fun m =>
    (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 X)).unit.app F ≫
      (Scheme.Modules.pushforward (𝟙 X)).map m) (Iso.hom_inv_id_app _ _)) ?_
  exact (congrArg (fun m =>
      (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 X)).unit.app F ≫ m)
      ((Scheme.Modules.pushforward (𝟙 X)).map_id _)).trans (Category.comp_id _)

/-- The Čech augmentation composed with the push–pull of *any* `Over X`-morphism into the
degree-`0` backbone is the pullback–pushforward adjunction unit at the structure map: the
composite `Y ⟶ Y₀ ⟶ Over.mk (𝟙 X)` is a morphism into the terminal object, so the
augmentation leg needs no unwinding. -/
private lemma cechAugmentation_pushPullMap (𝒰 : X.OpenCover) (F : X.Modules)
    {Y : Over X}
    (g : Y ⟶ (coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk 0))) :
    cechAugmentation 𝒰 F ≫ pushPullMap F g =
      (Scheme.Modules.pullbackPushforwardAdjunction Y.hom).unit.app F := by
  have happ : (CechNerve 𝒰 F).hom.app (SimplexCategory.mk 0) =
      pushPullMap F
        ((coverCechNerveOverAug 𝒰).hom.app (Opposite.op (SimplexCategory.mk 0))) :=
    Eq.trans rfl (Category.id_comp _)
  rw [cechAugmentation, Category.assoc]
  refine Eq.trans (congrArg (fun m => (cechNervePointIso 𝒰 F).inv ≫ m)
    (Eq.trans (congrArg (fun m => m ≫ pushPullMap F g) happ)
      ((pushPullMap_comp F _ g).symm))) ?_
  rw [cechNervePointIso_inv_eq_unit, pushPullMap_eq_raw]
  exact rawPushPullMap_unit _ _ _ _ F

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- Normalizing the adjunction unit through the pushforward comparison is kernel-intensive.
/-- The pullback–pushforward unit reads through the per-leg section identification as the
plain `F`-restriction `Γ(V, F) → Γ(U_σ ∩ V, F)`. -/
private lemma unit_pushPull_leg_sections (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    {p : ℕ} (σ : Fin (p + 1) → 𝒰.I₀) (V : TopologicalSpace.Opens X) :
    (Scheme.Modules.toPresheaf X ⋙
        (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
          (Opposite.op V)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction
          (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F) ≫
      (pushPull_leg_sections 𝒰 F σ V).hom =
    ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
      (homOfLE (inf_le_right : coverInterOpen 𝒰 σ ⊓ V ≤ V)).op := by
  have hW : Scheme.Opens.ι (coverInterOpen 𝒰 σ) ''ᵁ
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ) ⁻¹ᵁ V) = coverInterOpen 𝒰 σ ⊓ V := by
    rw [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
  -- (i) the leg iso, with its `eqToHom` transport canonicalised to the `congrArg` form
  -- (definitional: projections of `Iso.trans`/`eqToIso` plus proof irrelevance)
  have hdec : (pushPull_leg_sections 𝒰 F σ V).hom =
      (Scheme.Modules.toPresheaf X ⋙
          (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
            (Opposite.op V)).map
        ((Scheme.Modules.pushforward (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).map
          ((Scheme.Modules.restrictFunctorIsoPullback
            (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).inv.app F)) ≫
      eqToHom (congrArg
        (fun W => ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (Opposite.op W))
        hW) := rfl
  -- (ii) the pullback unit is conjugate to the restriction unit via `leftAdjointUniq`
  -- (`restrictFunctorIsoPullback` *is* the `leftAdjointUniq` iso, definitionally)
  have hLAU : (Scheme.Modules.pullbackPushforwardAdjunction
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F ≫
      (Scheme.Modules.pushforward (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).map
        ((Scheme.Modules.restrictFunctorIsoPullback
          (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).inv.app F) =
      (Scheme.Modules.restrictAdjunction
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F := by
    have h0 : (Scheme.Modules.restrictAdjunction
          (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F ≫
        (Scheme.Modules.pushforward (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).map
          ((Scheme.Modules.restrictFunctorIsoPullback
            (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).hom.app F) =
        (Scheme.Modules.pullbackPushforwardAdjunction
          (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F :=
      Adjunction.unit_leftAdjointUniq_hom_app _ _ F
    refine Eq.trans (congrArg (fun m => m ≫
      (Scheme.Modules.pushforward (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).map
        ((Scheme.Modules.restrictFunctorIsoPullback
          (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).inv.app F)) h0.symm) ?_
    refine Eq.trans (Category.assoc _ _ _) ?_
    refine Eq.trans (congrArg (fun m => (Scheme.Modules.restrictAdjunction
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F ≫ m)
      (((Scheme.Modules.pushforward (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).map_comp
        _ _).symm)) ?_
    refine Eq.trans (congrArg (fun m => (Scheme.Modules.restrictAdjunction
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F ≫
        (Scheme.Modules.pushforward (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).map m)
      (Iso.hom_inv_id_app _ _)) ?_
    exact (congrArg (fun m => (Scheme.Modules.restrictAdjunction
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F ≫ m)
      ((Scheme.Modules.pushforward (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).map_id _)).trans
      (Category.comp_id _)
  -- (iii) the restriction unit on sections is the plain restriction (definitional,
  -- `Scheme.Modules.restrictAdjunction_unit_app_app`)
  have hunit : (Scheme.Modules.toPresheaf X ⋙
        (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
          (Opposite.op V)).map
      ((Scheme.Modules.restrictAdjunction
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F) =
    ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
      (homOfLE ((Scheme.Opens.ι (coverInterOpen 𝒰 σ)).image_preimage_le V)).op := rfl
  -- assemble: fuse the unit with the comparison leg, read off the restriction, and
  -- collapse the two parallel restriction chains (term-chained: `rw` cannot re-match
  -- composites whose stored middle objects are defeq-but-not-syntactic).
  refine Eq.trans (congrArg (fun m => (Scheme.Modules.toPresheaf X ⋙
      (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
        (Opposite.op V)).map
      ((Scheme.Modules.pullbackPushforwardAdjunction
        (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).unit.app F) ≫ m) hdec) ?_
  refine Eq.trans (Category.assoc _ _ _).symm ?_
  refine Eq.trans (congrArg (fun m => m ≫ eqToHom (congrArg
      (fun W => ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (Opposite.op W))
      hW))
    (Eq.trans (((Scheme.Modules.toPresheaf X ⋙
        (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
          (Opposite.op V)).map_comp _ _).symm)
      (Eq.trans (congrArg (Scheme.Modules.toPresheaf X ⋙
        (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
          (Opposite.op V)).map hLAU) hunit))) ?_
  refine Eq.trans (congrArg (fun m =>
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
        (homOfLE ((Scheme.Opens.ι (coverInterOpen 𝒰 σ)).image_preimage_le V)).op ≫ m)
    (stubEqToHomRestr (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf) hW
      (le_of_eq hW.symm) _)) ?_
  refine Eq.trans
    ((((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map_comp _ _).symm) ?_
  refine Eq.trans (congrArg ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
    (op_comp (f := homOfLE (le_of_eq hW.symm))
      (g := homOfLE ((Scheme.Opens.ι (coverInterOpen 𝒰 σ)).image_preimage_le V))).symm) ?_
  exact congrArg (fun m => ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
    (Quiver.Hom.op m)) (Subsingleton.elim _ _)

end AugSeam

/-- **Coordinatewise identification of the canonical augmentation** (the degree-`0`
augmentation seam of `lem:cechSection_contractible`): the `σ`-coordinate of
`sectionCechAugV` is the plain restriction `Γ(V, F) → Γ(U'_σ, F)`.  This is the `p = 0`
leg unwinding of `coreIso_objIso` — through `pushPull_sigma_iso`'s `σ`-leg, the terminal
object of `Over X` (which collapses `a₀(σ) ≫ (augmentation)` to the canonical map
`Over.mk j_σ ⟶ Over.mk (𝟙 X)` with NO unwinding of `a₀`), and the section computation of
the push–pull adjunction unit. -/
lemma sectionCechAugV_π (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens X) (σ : Fin 1 → 𝒰.I₀) :
    sectionCechAugV 𝒰 F V ≫ Pi.π (fun τ : Fin 1 → 𝒰.I₀ =>
        ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
          (Opposite.op (⨅ l, (coverOpen 𝒰 (τ l) ⊓ V)))) σ =
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
        (homOfLE (stubInterLeV 𝒰 V σ)).op := by
  have hproj := coreIso_objIso_π 𝒰 F 0 V σ
  have hGE := GVΨ_map_eq V (cechAugmentation 𝒰 F)
  -- The augmentation collapses through the terminal object to the
  -- adjunction unit, which reads as the plain restriction; the residual transports are
  -- parallel restriction chains between the same opens.
  refine Eq.trans (congrArg (fun m => m ≫ _) (rfl :
    sectionCechAugV 𝒰 F V =
      (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
          (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
        ((SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map
            (cechAugmentation 𝒰 F)) ≫
        (coreIso_objIso 𝒰 F 0 V).hom)) ?_
  refine Eq.trans (Category.assoc _ _ _) ?_
  refine Eq.trans (congrArg (fun m => _ ≫ m) hproj) ?_
  refine Eq.trans (Category.assoc _ _ _).symm ?_
  refine Eq.trans (congrArg (fun m => m ≫ ((pushPull_leg_sections 𝒰 F σ V).hom ≫
      eqToHom (congrArg
        (fun W => ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
          (Opposite.op W))
        (coverInterOpen_inf_eq_iInf_inf 𝒰 σ V))))
    (Eq.trans (congrArg (fun m => m ≫ _) hGE)
      (Eq.trans (((Scheme.Modules.toPresheaf X ⋙
          (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
            (Opposite.op V)).map_comp _ _).symm)
        (congrArg (Scheme.Modules.toPresheaf X ⋙
            (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ (Ab.{u})).obj
              (Opposite.op V)).map
          (cechAugmentation_pushPullMap 𝒰 F (backboneIncl 𝒰 0 σ)))))) ?_
  refine Eq.trans (Category.assoc _ _ _).symm ?_
  refine Eq.trans (congrArg (fun m => m ≫ eqToHom (congrArg
      (fun W => ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op W))
      (coverInterOpen_inf_eq_iInf_inf 𝒰 σ V)))
    (unit_pushPull_leg_sections 𝒰 F σ V)) ?_
  refine Eq.trans (congrArg (fun m =>
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
        (homOfLE (inf_le_right : coverInterOpen 𝒰 σ ⊓ V ≤ V)).op ≫ m)
    (stubEqToHomRestr (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf)
      (coverInterOpen_inf_eq_iInf_inf 𝒰 σ V)
      (le_of_eq (coverInterOpen_inf_eq_iInf_inf 𝒰 σ V).symm) _)) ?_
  refine Eq.trans
    ((((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map_comp _ _).symm) ?_
  refine Eq.trans (congrArg ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
    (op_comp (f := homOfLE (le_of_eq (coverInterOpen_inf_eq_iInf_inf 𝒰 σ V).symm))
      (g := homOfLE (inf_le_right : coverInterOpen 𝒰 σ ⊓ V ≤ V))).symm) ?_
  exact congrArg (fun m => ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
    (Quiver.Hom.op m)) (Subsingleton.elim _ _)

section ContractingHomotopy

variable (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (V : TopologicalSpace.Opens X)
variable (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix)

/-- The augmented concrete section Čech complex of Stub 5/6, as a reducible abbreviation. -/
private noncomputable abbrev cechSectionAugComplex : CochainComplex Ab.{u} ℕ :=
  (sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V) (sectionCechAugV_comp_d 𝒰 F V)

/-- The bottom homotopy component `Č⁰ ⟶ Γ(V, F)`: project onto the `i_fix`-coordinate and
restrict along `V ≤ U'_{i_fix}` (the `π_{i_fix}` of the Stacks projection homotopy). -/
private noncomputable def cechSectionHomotopyZero :
    (cechSectionAugComplex 𝒰 F V).X 1 ⟶ (cechSectionAugComplex 𝒰 F V).X 0 :=
  Pi.π (fun τ : Fin 1 → 𝒰.I₀ =>
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op (⨅ l, (coverOpen 𝒰 (τ l) ⊓ V)))) (Fin.cons i_fix Fin.elim0) ≫
    ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
      (homOfLE (stubOpen_le_prepend 𝒰 V i_fix hiV Fin.elim0)).op

/-- The Čech-degree homotopy components `Čᵐ⁺¹ ⟶ Čᵐ`: prepend `i_fix` to the multi-index
and restrict (the identity on coefficients, since prepending does not shrink the open). -/
private noncomputable def cechSectionHomotopyComp (m : ℕ) :
    (cechSectionAugComplex 𝒰 F V).X (m + 2) ⟶ (cechSectionAugComplex 𝒰 F V).X (m + 1) :=
  Pi.lift fun τ : Fin (m + 1) → 𝒰.I₀ =>
    Pi.π (fun ρ : Fin (m + 2) → 𝒰.I₀ =>
        ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
          (Opposite.op (⨅ l, (coverOpen 𝒰 (ρ l) ⊓ V)))) (Fin.cons i_fix τ) ≫
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
        (homOfLE (stubOpen_le_prepend 𝒰 V i_fix hiV τ)).op

/-- Coordinatewise value of the homotopy component: the `τ`-coordinate of `h(t)` is the
engine prepend map applied to the `(i_fix :: τ)`-coordinate of `t`. -/
private lemma cechSectionHomotopyComp_coord (m : ℕ)
    (t : ToType ((sectionCechComplexV 𝒰 F V).X (m + 1))) (τ : Fin (m + 1) → 𝒰.I₀) :
    sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
        ((SheafOfModules.forget X.ringCatSheaf).obj F) m
        (ConcreteCategory.hom (cechSectionHomotopyComp 𝒰 F V i_fix hiV m) t) τ
      = cechSectionPrepend 𝒰 F V i_fix hiV (m + 1) τ
          (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) (m + 1) t (Fin.cons i_fix τ)) := by
  refine Eq.trans (sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) m _ τ) ?_
  refine Eq.trans (ConcreteCategory.comp_apply
    (cechSectionHomotopyComp 𝒰 F V i_fix hiV m) (Pi.π _ τ) t).symm ?_
  refine Eq.trans (ConcreteCategory.congr_hom (Pi.lift_π _ τ) t) ?_
  refine Eq.trans (ConcreteCategory.comp_apply _ _ t) ?_
  exact DFunLike.congr_arg (cechSectionPrepend 𝒰 F V i_fix hiV (m + 1) τ)
    (sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (m + 1) t (Fin.cons i_fix τ)).symm

/-- Coordinatewise value of the section Čech differential: the engine `depDiff`. -/
private lemma cechSectionD_coord (m : ℕ)
    (t : ToType ((sectionCechComplexV 𝒰 F V).X m)) (σ : Fin (m + 2) → 𝒰.I₀) :
    sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
        ((SheafOfModules.forget X.ringCatSheaf).obj F) (m + 1)
        (ConcreteCategory.hom ((sectionCechComplexV 𝒰 F V).d m (m + 1)) t) σ
      = CombinatorialCech.depDiff (A := cechSectionCoeff 𝒰 F V) (cechSectionCoface 𝒰 F V)
          (fun τ => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) m t τ) σ := by
  have hd : (sectionCechComplexV 𝒰 F V).d m (m + 1) =
      AlgebraicTopology.AlternatingCofaceMapComplex.objD
        (sectionCechCosimplicial (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F)) m :=
    CochainComplex.of_d
      (fun n => (sectionCechCosimplicial (fun a => coverOpen 𝒰 a ⊓ V)
        ((SheafOfModules.forget X.ringCatSheaf).obj F)).obj (SimplexCategory.mk n))
      (AlgebraicTopology.AlternatingCofaceMapComplex.objD
        (sectionCechCosimplicial (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F))) m
  refine Eq.trans (congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) (m + 1) y σ)
    (ConcreteCategory.congr_hom hd t)) ?_
  refine Eq.trans (sectionCech_objD_apply (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) m t σ) ?_
  exact Finset.sum_congr rfl fun j _ => rfl

omit [Finite 𝒰.I₀] in
/-- The `m = 0` engine differential is the single augmentation restriction. -/
private lemma cechSectionDepDiff_zero
    (u : ∀ ρ : Fin 0 → 𝒰.I₀, cechSectionCoeff 𝒰 F V 0 ρ) (σ : Fin 1 → 𝒰.I₀) :
    CombinatorialCech.depDiff (A := cechSectionCoeff 𝒰 F V) (cechSectionCoface 𝒰 F V) u σ
      = cechSectionCoface 𝒰 F V 0 σ 0 (u (σ ∘ (0 : Fin 1).succAbove)) := by
  simp only [CombinatorialCech.depDiff]
  refine Eq.trans (Fin.sum_univ_one _) ?_
  simp only [Fin.val_zero, pow_zero]
  exact one_zsmul _

/-- **(I0)** The degree-`0` contracting identity: `ε ≫ π_{i_fix} = 𝟙` on `Γ(V, F)`. -/
private lemma cechSection_comm_zero :
    𝟙 ((cechSectionAugComplex 𝒰 F V).X 0) =
      (cechSectionAugComplex 𝒰 F V).d 0 1 ≫ cechSectionHomotopyZero 𝒰 F V i_fix hiV := by
  refine Eq.symm ?_
  refine Eq.trans (Category.assoc _ _ _).symm ?_
  refine Eq.trans (congrArg
    (· ≫ ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
      (homOfLE (stubOpen_le_prepend 𝒰 V i_fix hiV Fin.elim0)).op)
    (sectionCechAugV_π 𝒰 F V (Fin.cons i_fix Fin.elim0))) ?_
  refine Eq.trans ((((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map_comp
    (homOfLE (stubInterLeV 𝒰 V (Fin.cons i_fix Fin.elim0))).op
    (homOfLE (stubOpen_le_prepend 𝒰 V i_fix hiV Fin.elim0)).op).symm) ?_
  refine Eq.trans (congrArg (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map)
    (op_comp (f := homOfLE (stubOpen_le_prepend 𝒰 V i_fix hiV Fin.elim0))
      (g := homOfLE (stubInterLeV 𝒰 V (Fin.cons i_fix Fin.elim0)))).symm) ?_
  refine Eq.trans (congrArg
    (fun m => ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map m.op)
    (Subsingleton.elim (homOfLE (stubOpen_le_prepend 𝒰 V i_fix hiV Fin.elim0) ≫
      homOfLE (stubInterLeV 𝒰 V (Fin.cons i_fix Fin.elim0))) (𝟙 V))) ?_
  exact (congrArg (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map)
    (op_id (X := V))).trans
    (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map_id (Opposite.op V))

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- Product extensionality and the dependent alternating-sum identity need the larger budget.
/-- **(In)** The positive-degree contracting identities, from the dependent engine
(`CombinatorialCech.depHomotopy_spec`). -/
private lemma cechSection_comm_succ (n : ℕ) :
    𝟙 ((cechSectionAugComplex 𝒰 F V).X (n + 2)) =
      cechSectionHomotopyComp 𝒰 F V i_fix hiV n ≫
          (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) +
        (cechSectionAugComplex 𝒰 F V).d (n + 2) (n + 3) ≫
          cechSectionHomotopyComp 𝒰 F V i_fix hiV (n + 1) := by
  ext t
  apply (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1)).injective
  funext σ
  refine Eq.symm ?_
  have hsplit : ConcreteCategory.hom
      (cechSectionHomotopyComp 𝒰 F V i_fix hiV n ≫
          (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) +
        (cechSectionAugComplex 𝒰 F V).d (n + 2) (n + 3) ≫
          cechSectionHomotopyComp 𝒰 F V i_fix hiV (n + 1)) t
      = ConcreteCategory.hom (cechSectionHomotopyComp 𝒰 F V i_fix hiV n ≫
          (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2)) t +
        ConcreteCategory.hom ((cechSectionAugComplex 𝒰 F V).d (n + 2) (n + 3) ≫
          cechSectionHomotopyComp 𝒰 F V i_fix hiV (n + 1)) t := by
    rw [AddCommGrpCat.hom_add_apply]
  refine Eq.trans (congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) y σ) hsplit) ?_
  have hco : ∀ (a b : ToType ((cechSectionAugComplex 𝒰 F V).X (n + 2))),
      sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) (a + b) σ
        = sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) a σ +
          sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) b σ := fun a b => by
    rw [sectionCechProductEquiv_apply, sectionCechProductEquiv_apply,
      sectionCechProductEquiv_apply]
    exact map_add _ a b
  refine Eq.trans (hco _ _) ?_
  -- piece 1: `h ≫ d` is `depDiff (depHomotopy t̃)`
  have hpiece1 : sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1)
      (ConcreteCategory.hom (cechSectionHomotopyComp 𝒰 F V i_fix hiV n ≫
        (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2)) t) σ
      = CombinatorialCech.depDiff (A := cechSectionCoeff 𝒰 F V) (cechSectionCoface 𝒰 F V)
          (CombinatorialCech.depHomotopy i_fix (cechSectionPrepend 𝒰 F V i_fix hiV)
            (fun τ => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
              ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) t τ)) σ := by
    refine Eq.trans (congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) y σ)
      (ConcreteCategory.comp_apply _ _ t)) ?_
    refine Eq.trans (cechSectionD_coord 𝒰 F V n _ σ) ?_
    exact congrArg (fun u => CombinatorialCech.depDiff (A := cechSectionCoeff 𝒰 F V)
      (cechSectionCoface 𝒰 F V) u σ)
      (funext fun τ => cechSectionHomotopyComp_coord 𝒰 F V i_fix hiV n t τ)
  -- piece 2: `d ≫ h` is `depHomotopy (depDiff t̃)`
  have hpiece2 : sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1)
      (ConcreteCategory.hom ((cechSectionAugComplex 𝒰 F V).d (n + 2) (n + 3) ≫
        cechSectionHomotopyComp 𝒰 F V i_fix hiV (n + 1)) t) σ
      = CombinatorialCech.depHomotopy i_fix (cechSectionPrepend 𝒰 F V i_fix hiV)
          (CombinatorialCech.depDiff (A := cechSectionCoeff 𝒰 F V) (cechSectionCoface 𝒰 F V)
            (fun τ => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
              ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) t τ)) σ := by
    refine Eq.trans (congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) y σ)
      (ConcreteCategory.comp_apply _ _ t)) ?_
    refine Eq.trans (cechSectionHomotopyComp_coord 𝒰 F V i_fix hiV (n + 1) _ σ) ?_
    exact DFunLike.congr_arg (cechSectionPrepend 𝒰 F V i_fix hiV (n + 2) σ)
      (cechSectionD_coord 𝒰 F V (n + 1) t (Fin.cons i_fix σ))
  refine Eq.trans (congrArg₂ (· + ·) hpiece1 hpiece2) ?_
  refine Eq.trans (CombinatorialCech.depHomotopy_spec i_fix (cechSectionCoface 𝒰 F V)
    (cechSectionPrepend 𝒰 F V i_fix hiV)
    (fun {m} σ' y => cechSection_hu 𝒰 F V i_fix hiV σ' y)
    (fun {m} σ' k y => cechSection_hsh 𝒰 F V i_fix hiV σ' k y)
    (fun τ => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) t τ) σ) ?_
  exact congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) (n + 1) y σ)
    (ConcreteCategory.id_apply t).symm

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- The augmentation-node identity expands two dependent product coordinates and their sums.
set_option maxRecDepth 4000 in
/-- **(I1)** The augmentation-node contracting identity:
`𝟙 = π_{i_fix} ≫ ε + d⁰ ≫ h₁` on `Č⁰`. -/
private lemma cechSection_comm_one :
    𝟙 ((cechSectionAugComplex 𝒰 F V).X 1) =
      cechSectionHomotopyZero 𝒰 F V i_fix hiV ≫ (cechSectionAugComplex 𝒰 F V).d 0 1 +
        (cechSectionAugComplex 𝒰 F V).d 1 2 ≫ cechSectionHomotopyComp 𝒰 F V i_fix hiV 0 := by
  ext t
  apply (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) 0).injective
  funext σ
  refine Eq.symm ?_
  have hsplit : ConcreteCategory.hom
      (cechSectionHomotopyZero 𝒰 F V i_fix hiV ≫ (cechSectionAugComplex 𝒰 F V).d 0 1 +
        (cechSectionAugComplex 𝒰 F V).d 1 2 ≫ cechSectionHomotopyComp 𝒰 F V i_fix hiV 0) t
      = ConcreteCategory.hom (cechSectionHomotopyZero 𝒰 F V i_fix hiV ≫
          (cechSectionAugComplex 𝒰 F V).d 0 1) t +
        ConcreteCategory.hom ((cechSectionAugComplex 𝒰 F V).d 1 2 ≫
          cechSectionHomotopyComp 𝒰 F V i_fix hiV 0) t := by
    rw [AddCommGrpCat.hom_add_apply]
  refine Eq.trans (congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 y σ) hsplit) ?_
  have hco : ∀ (a b : ToType ((cechSectionAugComplex 𝒰 F V).X 1)),
      sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
          ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 (a + b) σ
        = sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 a σ +
          sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 b σ := fun a b => by
    rw [sectionCechProductEquiv_apply, sectionCechProductEquiv_apply,
      sectionCechProductEquiv_apply]
    exact map_add _ a b
  refine Eq.trans (hco _ _) ?_
  -- piece 1: `π_{i_fix} ≫ ε` is `depDiff (depHomotopy t̃)` at the bottom level
  have hpiece1 : sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) 0
      (ConcreteCategory.hom (cechSectionHomotopyZero 𝒰 F V i_fix hiV ≫
        (cechSectionAugComplex 𝒰 F V).d 0 1) t) σ
      = CombinatorialCech.depDiff (A := cechSectionCoeff 𝒰 F V) (cechSectionCoface 𝒰 F V)
          (CombinatorialCech.depHomotopy i_fix (cechSectionPrepend 𝒰 F V i_fix hiV)
            (fun τ => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
              ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 t τ)) σ := by
    refine Eq.trans (sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 _ σ) ?_
    refine Eq.trans (ConcreteCategory.comp_apply _ (Pi.π _ σ) _).symm ?_
    refine Eq.trans (ConcreteCategory.congr_hom (Category.assoc
      (cechSectionHomotopyZero 𝒰 F V i_fix hiV)
      ((cechSectionAugComplex 𝒰 F V).d 0 1) (Pi.π _ σ)) t) ?_
    refine Eq.trans (ConcreteCategory.comp_apply _ _ t) ?_
    refine Eq.trans (ConcreteCategory.congr_hom (sectionCechAugV_π 𝒰 F V σ)
      (ConcreteCategory.hom (cechSectionHomotopyZero 𝒰 F V i_fix hiV) t)) ?_
    refine Eq.symm ?_
    refine Eq.trans (cechSectionDepDiff_zero 𝒰 F V _ σ) ?_
    have htuple : ∀ ρ : Fin 0 → 𝒰.I₀,
        cechSectionPrepend 𝒰 F V i_fix hiV 0 ρ
          (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 t (Fin.cons i_fix ρ))
        = cechSectionPrepend 𝒰 F V i_fix hiV 0 Fin.elim0
            (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
              ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 t
              (Fin.cons i_fix Fin.elim0)) := by
      intro ρ
      have hρ : ρ = Fin.elim0 := Subsingleton.elim _ _
      subst hρ
      rfl
    refine Eq.trans (DFunLike.congr_arg (cechSectionCoface 𝒰 F V 0 σ 0)
      (htuple (σ ∘ (0 : Fin 1).succAbove))) ?_
    refine DFunLike.congr_arg (cechSectionCoface 𝒰 F V 0 σ 0) ?_
    refine DFunLike.congr_arg (cechSectionPrepend 𝒰 F V i_fix hiV 0 Fin.elim0) ?_
    exact (sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 t (Fin.cons i_fix Fin.elim0))
  -- piece 2: `d⁰ ≫ h₁` is `depHomotopy (depDiff t̃)`
  have hpiece2 : sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) 0
      (ConcreteCategory.hom ((cechSectionAugComplex 𝒰 F V).d 1 2 ≫
        cechSectionHomotopyComp 𝒰 F V i_fix hiV 0) t) σ
      = CombinatorialCech.depHomotopy i_fix (cechSectionPrepend 𝒰 F V i_fix hiV)
          (CombinatorialCech.depDiff (A := cechSectionCoeff 𝒰 F V) (cechSectionCoface 𝒰 F V)
            (fun τ => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
              ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 t τ)) σ := by
    refine Eq.trans (congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 y σ)
      (ConcreteCategory.comp_apply _ _ t)) ?_
    refine Eq.trans (cechSectionHomotopyComp_coord 𝒰 F V i_fix hiV 0 _ σ) ?_
    exact DFunLike.congr_arg (cechSectionPrepend 𝒰 F V i_fix hiV 1 σ)
      (cechSectionD_coord 𝒰 F V 0 t (Fin.cons i_fix σ))
  refine Eq.trans (congrArg₂ (· + ·) hpiece1 hpiece2) ?_
  refine Eq.trans (CombinatorialCech.depHomotopy_spec i_fix (cechSectionCoface 𝒰 F V)
    (cechSectionPrepend 𝒰 F V i_fix hiV)
    (fun {m} σ' y => cechSection_hu 𝒰 F V i_fix hiV σ' y)
    (fun {m} σ' k y => cechSection_hsh 𝒰 F V i_fix hiV σ' k y)
    (fun τ => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 t τ) σ) ?_
  exact congrArg (fun y => sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 y σ)
    (ConcreteCategory.id_apply t).symm

/-- The coinductive step: given the previous homotopy condition, the corrected component
`h_{n+2} ≫ (𝟙 - p₂₁ ≫ d)` satisfies the next one (pure preadditive algebra from `(In)`
and `d ∘ d = 0`). -/
private lemma cechSection_succ_step (n : ℕ)
    {f : (cechSectionAugComplex 𝒰 F V).X (n + 1) ⟶ (cechSectionAugComplex 𝒰 F V).X n}
    {g : (cechSectionAugComplex 𝒰 F V).X (n + 2) ⟶ (cechSectionAugComplex 𝒰 F V).X (n + 1)}
    (hp : 𝟙 ((cechSectionAugComplex 𝒰 F V).X (n + 1)) =
      f ≫ (cechSectionAugComplex 𝒰 F V).d n (n + 1) +
        (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) ≫ g) :
    𝟙 ((cechSectionAugComplex 𝒰 F V).X (n + 2)) =
      g ≫ (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) +
        (cechSectionAugComplex 𝒰 F V).d (n + 2) (n + 3) ≫
          (cechSectionHomotopyComp 𝒰 F V i_fix hiV (n + 1) ≫
            (𝟙 ((cechSectionAugComplex 𝒰 F V).X (n + 2)) -
              g ≫ (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2))) := by
  have hIn := cechSection_comm_succ 𝒰 F V i_fix hiV n
  have hsub : (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) =
      (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) ≫ g ≫
        (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) := by
    have h₀ := congrArg (fun m => m ≫ (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2)) hp
    simpa only [Category.id_comp, Preadditive.add_comp, Category.assoc,
      HomologicalComplex.d_comp_d, comp_zero, zero_add] using h₀
  have hd1E : (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2) ≫
      (𝟙 ((cechSectionAugComplex 𝒰 F V).X (n + 2)) -
        g ≫ (cechSectionAugComplex 𝒰 F V).d (n + 1) (n + 2)) = 0 := by
    rw [Preadditive.comp_sub, Category.comp_id, sub_eq_zero]
    exact hsub
  have hdb := eq_sub_iff_add_eq.mpr ((add_comm _ _).trans hIn.symm)
  rw [← Category.assoc ((cechSectionAugComplex 𝒰 F V).d (n + 2) (n + 3))
    (cechSectionHomotopyComp 𝒰 F V i_fix hiV (n + 1)) _, hdb, Preadditive.sub_comp,
    Category.id_comp, Category.assoc, hd1E, comp_zero, sub_zero]
  abel

end ContractingHomotopy

set_option maxRecDepth 8000 in
set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- Coinductive homotopy packaging has deeply nested dependent degree equalities.
/-- The concrete augmented section Čech complex is contractible after choosing a cover member
that contains `V`. -/
noncomputable def cechSection_contractible (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (V : TopologicalSpace.Opens X)
    (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix) :
    Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V)
      (sectionCechAugV_comp_d 𝒰 F V))) 0 :=
  -- The prepend-`i_fix` contracting homotopy on the augmented concrete section complex,
  -- assembled by `Homotopy.mkCoinductive` from the explicit components (`π_{i_fix}` at the
  -- augmentation node, prepend-`i_fix` in the Čech degrees) and the three contracting
  -- identities (I0)/(I1)/(In) proved above via the dependent combinatorial engine.
  Homotopy.mkCoinductive _
    (cechSectionHomotopyZero 𝒰 F V i_fix hiV)
    ((HomologicalComplex.id_f _ _).trans (cechSection_comm_zero 𝒰 F V i_fix hiV))
    (cechSectionHomotopyComp 𝒰 F V i_fix hiV 0)
    ((HomologicalComplex.id_f _ _).trans (cechSection_comm_one 𝒰 F V i_fix hiV))
    (fun n p =>
      ⟨cechSectionHomotopyComp 𝒰 F V i_fix hiV (n + 1) ≫
          (𝟙 (((sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V)
              (sectionCechAugV_comp_d 𝒰 F V)).X (n + 2)) -
            p.2.1 ≫ ((sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V)
              (sectionCechAugV_comp_d 𝒰 F V)).d (n + 1) (n + 2)), by
        have hp := (HomologicalComplex.id_f _ _).symm.trans p.2.2
        exact (HomologicalComplex.id_f _ _).trans
          (cechSection_succ_step 𝒰 F V i_fix hiV n hp)⟩)

end AlgebraicGeometry
