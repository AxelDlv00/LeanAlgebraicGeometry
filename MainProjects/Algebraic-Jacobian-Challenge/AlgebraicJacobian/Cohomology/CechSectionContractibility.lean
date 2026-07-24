/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechSectionContractibilitySucc

/-!
# Contractibility of the concrete section Čech complex

This file proves the augmentation-degree contracting identity and packages all degreewise
identities into a contracting homotopy.
-/

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

open Scheme.Modules

variable {X : Scheme.{u}}

section ContractingHomotopy

variable (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (V : TopologicalSpace.Opens X)
variable (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix)

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
  let E := sectionCechProductAddEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) 0
  ext t
  apply E.injective
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
  refine Eq.trans (congrArg (fun y => E y σ) hsplit) ?_
  refine Eq.trans (congrArg (fun y => y σ) (map_add E _ _)) ?_
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
