/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Stalk of a tensor product of presheaves of modules (ingredient d.2)

This file constructs the *comparison map* underlying the varying-ring stalk--tensor
commutation isomorphism

  `(A ⊗ᵖ B).stalk x ≅ A.stalk x ⊗_{R.stalk x} B.stalk x`

for presheaves of modules over the structure presheaf `R` of a scheme — the single
genuinely Mathlib-absent ingredient ("d.2") on which the unconditional associator of
the relative-Picard tensor substrate rests.

This iteration builds the forward additive comparison map `stalkTensorDesc` and its
germ characterisation (the colimit-descent of the sectionwise base-change maps). The
full isomorphism `PresheafOfModules.stalkTensorIso` (blueprint `lem:stalk_tensor_commutation`)
additionally requires the `R.stalk x`-linear packaging of this map, the reverse map, and
their mutual inversion on germs — see the handoff in `task_results`.

The construction proceeds bottom-up:

* `PresheafOfModules.stalkTensorBilin` — for a neighbourhood `U ∋ x`, the `R(U)`-balanced
  bilinear map `A(U) × B(U) → A_x ⊗_{R_x} B_x`, `(a,b) ↦ germ a ⊗ germ b`.
* `PresheafOfModules.stalkTensorDescU` — its descent through `TensorProduct.liftAddHom`
  to a map `(A ⊗ᵖ B)(U) = A(U) ⊗_{R(U)} B(U) → A_x ⊗_{R_x} B_x`.
* `PresheafOfModules.stalkTensorDesc` — the colimit descent to the comparison map
  `(A ⊗ᵖ B).stalk x → A_x ⊗_{R_x} B_x`.

Source: [Stacks Project], Modules on Ringed Spaces, Lemma `lemma-stalk-tensor-product`.

Blueprint: `chapters/Picard_TensorObjSubstrate.tex`, §`sec:tensorobj_stalk_tensor`
(`lem:stalk_tensor_commutation`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory TopologicalSpace TopCat.Presheaf Opposite

namespace PresheafOfModules

open PresheafOfModules.Monoidal

/-! ## Project-local Mathlib supplement — stalk of a tensor product (d.2) -/

section StalkTensor

variable {X : TopCat.{u}} {R : X.Presheaf CommRingCat.{u}}
  (A B : PresheafOfModules.{u} (R ⋙ forget₂ _ _)) (x : X)

local notation3 "Tgt" =>
  TensorProduct ↑(R.stalk x) ↑(TopCat.Presheaf.stalk A.presheaf x)
    ↑(TopCat.Presheaf.stalk B.presheaf x)

/-- **The `R(U)`-balanced bilinear comparison map.** For a neighbourhood `U ∋ x`, the
bilinear (additive-monoid-hom) map `A(U) × B(U) → A_x ⊗_{R_x} B_x` sending
`(a, b)` to `germ a ⊗ germ b`. Project-local: the building block of the d.2 stalk--tensor
comparison; Mathlib has no varying-ring stalk--tensor commutation. -/
noncomputable def stalkTensorBilin (U : Opens X) (hx : x ∈ U) :
    (↑(A.obj (op U)) : Type u) →+ (↑(B.obj (op U)) : Type u) →+ Tgt where
  toFun m :=
    ((TensorProduct.mk ↑(R.stalk x) _ _
      ((ConcreteCategory.hom (TopCat.Presheaf.germ A.presheaf U x hx)) m)).toAddMonoidHom).comp
      (ConcreteCategory.hom (TopCat.Presheaf.germ B.presheaf U x hx))
  map_zero' := by ext n; simp
  map_add' m m' := by ext n; simp

/-- The defining balancing identity making `stalkTensorBilin` descend through the
relative tensor product `A(U) ⊗_{R(U)} B(U)`: `(r • a) ⊗ b ↦ a ⊗ (r • b)`. -/
lemma stalkTensorBilin_balanced (U : Opens X) (hx : x ∈ U) (r : ↑(R.obj (op U)))
    (m : ↑(A.obj (op U))) (n : ↑(B.obj (op U))) :
    (stalkTensorBilin A B x U hx (r • m)) n = (stalkTensorBilin A B x U hx m) (r • n) := by
  simp only [stalkTensorBilin, AddMonoidHom.coe_mk, ZeroHom.coe_mk, AddMonoidHom.coe_comp,
    LinearMap.toAddMonoidHom_coe, Function.comp_apply, TensorProduct.mk_apply]
  rw [PresheafOfModules.germ_smul A x U hx]
  erw [PresheafOfModules.germ_smul B x U hx]
  exact TensorProduct.smul_tmul _ _ _

/-- **The per-neighbourhood descended comparison map** `(A ⊗ᵖ B)(U) → A_x ⊗_{R_x} B_x`,
obtained from `stalkTensorBilin` via `TensorProduct.liftAddHom`. The source object is
`(A ⊗ᵖ B).presheaf.obj (op U)`, definitionally `A(U) ⊗_{R(U)} B(U)`. -/
noncomputable def stalkTensorDescU (U : Opens X) (hx : x ∈ U) :
    (Monoidal.tensorObj A B).presheaf.obj (op U) ⟶ AddCommGrpCat.of Tgt :=
  AddCommGrpCat.ofHom
    (TensorProduct.liftAddHom (stalkTensorBilin A B x U hx) (stalkTensorBilin_balanced A B x U hx))

@[simp] lemma stalkTensorDescU_tmul (U : Opens X) (hx : x ∈ U)
    (a : ↑(A.obj (op U))) (b : ↑(B.obj (op U))) :
    (stalkTensorDescU A B x U hx) (a ⊗ₜ[R.obj (op U)] b)
      = (ConcreteCategory.hom (TopCat.Presheaf.germ A.presheaf U x hx)) a ⊗ₜ[↑(R.stalk x)]
        (ConcreteCategory.hom (TopCat.Presheaf.germ B.presheaf U x hx)) b := by
  change (TensorProduct.liftAddHom (stalkTensorBilin A B x U hx)
    (stalkTensorBilin_balanced A B x U hx)) (a ⊗ₜ[R.obj (op U)] b) = _
  rw [TensorProduct.liftAddHom_tmul]
  rfl

/-- **Scalar compatibility of the per-neighbourhood descent.** For `r : R(U)` and a
section `z` of `A ⊗ᵖ B` over `U`, the descent `stalkTensorDescU` carries the `R(U)`-scalar
action over to the `R.stalk x`-action by the germ of `r`. This is stage (iii)'s
section-level core; the carrier-duality between the `CommRingCat` scalar `r : R(U)` and the
`RingCat`-carrier module structure on `A(U) ⊗ B(U)` is absorbed by `germ_smul`/`smul_tmul'`. -/
lemma stalkTensorDescU_smul (U : Opens X) (hx : x ∈ U) (r : ↑(R.obj (op U)))
    (z : ↑((Monoidal.tensorObj A B).obj (op U))) :
    (stalkTensorDescU A B x U hx) (r • z)
      = (ConcreteCategory.hom (TopCat.Presheaf.germ R U x hx)) r •
          (stalkTensorDescU A B x U hx) z := by
  -- The section tensor `A(U) ⊗ B(U)` is a module over the `RingCat` carrier
  -- `S := (R ⋙ forget₂).obj (op U)`, which is defeq to the `CommRingCat` carrier `R(U)`.
  -- We pin `smul_tmul'`/`smul_add`/`smul_zero` to that ring so the scalar `r` slots in.
  induction z using TensorProduct.induction_on with
  | zero =>
      simp only [presheaf_obj_coe, Functor.comp_obj, CommRingCat.forgetToRingCat_obj,
        Monoidal.tensorObj_obj, map_zero, smul_zero]
      exact map_zero _
  | tmul a b =>
      erw [stalkTensorDescU_tmul, stalkTensorDescU_tmul, PresheafOfModules.germ_smul A x U hx]
      exact (TensorProduct.smul_tmul' _ _ _).symm
  | add p q hp hq =>
      erw [smul_add]
      refine (map_add _ _ _).trans ?_
      rw [hp, hq, ← smul_add]
      exact congrArg _ (map_add _ p q).symm

/-- **The d.2 comparison map** `(A ⊗ᵖ B).stalk x → A_x ⊗_{R_x} B_x`, obtained by descending
the per-neighbourhood maps `stalkTensorDescU` through the colimit defining the stalk. -/
noncomputable def stalkTensorDesc :
    TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x ⟶ AddCommGrpCat.of Tgt :=
  colimit.desc ((OpenNhds.inclusion x).op ⋙ (Monoidal.tensorObj A B).presheaf)
    ⟨AddCommGrpCat.of Tgt,
      fun U => stalkTensorDescU A B x (unop U).1 (unop U).2,
      by
        intro U V i
        apply AddCommGrpCat.hom_ext
        ext z
        induction z using TensorProduct.induction_on with
        | zero => exact (AddMonoidHom.map_zero _).trans (AddMonoidHom.map_zero _).symm
        | tmul a b =>
            simp only [CategoryTheory.comp_apply, Functor.const_obj_map]
            erw [tensorObj_map_tmul, stalkTensorDescU_tmul, stalkTensorDescU_tmul]
            erw [germ_res_apply, germ_res_apply]
            rfl
        | add p q hp hq =>
            exact (AddMonoidHom.map_add _ p q).trans
              ((congrArg₂ HAdd.hAdd hp hq).trans (AddMonoidHom.map_add _ p q).symm)⟩

/-- The comparison map `stalkTensorDesc` factors the per-neighbourhood map
`stalkTensorDescU` through the germ, by the colimit universal property. -/
@[reassoc]
lemma germ_stalkTensorDesc (U : Opens X) (hx : x ∈ U) :
    TopCat.Presheaf.germ (Monoidal.tensorObj A B).presheaf U x hx ≫ stalkTensorDesc A B x
      = stalkTensorDescU A B x U hx :=
  colimit.ι_desc _ (op (⟨U, hx⟩ : OpenNhds x))

/-- **Germ characterisation of the d.2 comparison map** on a simple tensor: the germ of
`a ⊗ b` over `U` maps to `germ a ⊗ germ b`. -/
@[simp]
lemma stalkTensorDesc_germ_tmul (U : Opens X) (hx : x ∈ U)
    (a : ↑(A.obj (op U))) (b : ↑(B.obj (op U))) :
    (stalkTensorDesc A B x)
        ((ConcreteCategory.hom (TopCat.Presheaf.germ (Monoidal.tensorObj A B).presheaf U x hx))
          (a ⊗ₜ[R.obj (op U)] b))
      = (ConcreteCategory.hom (TopCat.Presheaf.germ A.presheaf U x hx)) a ⊗ₜ[↑(R.stalk x)]
        (ConcreteCategory.hom (TopCat.Presheaf.germ B.presheaf U x hx)) b := by
  rw [← stalkTensorDescU_tmul, ← CategoryTheory.comp_apply, germ_stalkTensorDesc]

/-- **Element form of `germ_stalkTensorDesc`.** The comparison map sends the germ of a
section `w` over `U` to its per-neighbourhood descent `stalkTensorDescU`. -/
lemma stalkTensorDesc_germ (U : Opens X) (hx : x ∈ U)
    (w : ↑((Monoidal.tensorObj A B).presheaf.obj (op U))) :
    (stalkTensorDesc A B x)
        ((ConcreteCategory.hom (TopCat.Presheaf.germ (Monoidal.tensorObj A B).presheaf U x hx)) w)
      = (stalkTensorDescU A B x U hx) w := by
  rw [← CategoryTheory.comp_apply, germ_stalkTensorDesc]

/-- **The `R.stalk x`-linear d.2 comparison map** (stage (iii)). The additive comparison
map `stalkTensorDesc` is `R.stalk x`-linear for the stalk module structures of
`Mathlib.Algebra.Category.ModuleCat.Stalk`: linearity is checked on a germ `germ r` of a
scalar `r : R(U)` via the germ--scalar compatibility `germ_smul` and the section-level
scalar compatibility `stalkTensorDescU_smul`, after passing to a common neighbourhood.
This is the linear packaging the d.2 stalk--tensor isomorphism `stalkTensorIso` builds on. -/
noncomputable def stalkTensorLinearMap :
    (↑(TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x) : Type u)
      →ₗ[↑(R.stalk x)] Tgt where
  toFun := ConcreteCategory.hom (stalkTensorDesc A B x)
  map_add' a b := map_add _ a b
  map_smul' r ξ := by
    dsimp only [RingHom.id_apply]
    obtain ⟨U, hxU, r₀, rfl⟩ := TopCat.Presheaf.germ_exist R x r
    obtain ⟨V, hxV, z, rfl⟩ :=
      TopCat.Presheaf.germ_exist (Monoidal.tensorObj A B).presheaf x ξ
    set W : Opens X := U ⊓ V with hW
    have hxW : x ∈ W := ⟨hxU, hxV⟩
    set iWU : W ⟶ U := homOfLE inf_le_left
    set iWV : W ⟶ V := homOfLE inf_le_right
    have hr : (ConcreteCategory.hom (R.germ U x hxU)) r₀
        = (ConcreteCategory.hom (R.germ W x hxW)) ((ConcreteCategory.hom (R.map iWU.op)) r₀) :=
      (TopCat.Presheaf.germ_res_apply R iWU x hxW r₀).symm
    have hz : (ConcreteCategory.hom
          (TopCat.Presheaf.germ (Monoidal.tensorObj A B).presheaf V x hxV)) z
        = (ConcreteCategory.hom
            (TopCat.Presheaf.germ (Monoidal.tensorObj A B).presheaf W x hxW))
            ((ConcreteCategory.hom ((Monoidal.tensorObj A B).presheaf.map iWV.op)) z) :=
      (TopCat.Presheaf.germ_res_apply (Monoidal.tensorObj A B).presheaf iWV x hxW z).symm
    rw [hr, hz, ← PresheafOfModules.germ_smul (Monoidal.tensorObj A B) x W hxW,
      stalkTensorDesc_germ, stalkTensorDescU_smul, ← stalkTensorDesc_germ]

/-- **Germ characterisation of the linear comparison map** on a simple tensor: the germ of
`a ⊗ b` over `U` maps to `germ a ⊗ germ b`. The `R.stalk x`-linear repackaging
`stalkTensorLinearMap` agrees with `stalkTensorDesc` on germs. -/
@[simp]
lemma stalkTensorLinearMap_germ_tmul (U : Opens X) (hx : x ∈ U)
    (a : ↑(A.obj (op U))) (b : ↑(B.obj (op U))) :
    stalkTensorLinearMap A B x
        ((ConcreteCategory.hom (TopCat.Presheaf.germ (Monoidal.tensorObj A B).presheaf U x hx))
          (a ⊗ₜ[R.obj (op U)] b))
      = (ConcreteCategory.hom (TopCat.Presheaf.germ A.presheaf U x hx)) a ⊗ₜ[↑(R.stalk x)]
        (ConcreteCategory.hom (TopCat.Presheaf.germ B.presheaf U x hx)) b :=
  stalkTensorDesc_germ_tmul A B x U hx a b

end StalkTensor

end PresheafOfModules
