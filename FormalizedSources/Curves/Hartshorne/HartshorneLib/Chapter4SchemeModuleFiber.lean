/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import Mathlib.Algebra.Category.ModuleCat.Stalk
import Mathlib.AlgebraicGeometry.Modules.Sheaf
import Mathlib.AlgebraicGeometry.ResidueField
import Mathlib.LinearAlgebra.TensorProduct.Quotient
import Mathlib.LinearAlgebra.TensorProduct.Tower

/-!
# Fibers of scheme modules

This file packages the ordinary fiber of an `O_X`-module at a point:
`kappa(x) tensor_{O_{X,x}} M_x`.  The construction uses only germs and the
canonical residue map.  In particular, it does not choose a local parameter
or a basis of the fiber.
-/

set_option autoImplicit false

universe u

open scoped TensorProduct
open CategoryTheory TopologicalSpace TopCat.Presheaf Opposite
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

/-! ## Linear maps on module stalks -/

/-- The linear map on stalks induced by a morphism of presheaves of modules. -/
noncomputable def presheafStalkLinearMap
    {T : TopCat.{u}} {R : T.Presheaf CommRingCat.{u}}
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (x : T) :
    (↑(TopCat.Presheaf.stalk M.presheaf x) : Type u) →ₗ[↑(R.stalk x)]
      (↑(TopCat.Presheaf.stalk N.presheaf x) : Type u) where
  toFun := ConcreteCategory.hom
    ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map
      ((PresheafOfModules.toPresheaf _).map g))
  map_add' a b := map_add _ a b
  map_smul' r s := by
    dsimp only [RingHom.id_apply]
    obtain ⟨U, hxU, r₀, rfl⟩ := TopCat.Presheaf.exists_germ_eq R r
    obtain ⟨V, hxV, s₀, rfl⟩ := TopCat.Presheaf.exists_germ_eq M.presheaf s
    let W : Opens T := U ⊓ V
    have hxW : x ∈ W := ⟨hxU, hxV⟩
    let iWU : W ⟶ U := homOfLE inf_le_left
    let iWV : W ⟶ V := homOfLE inf_le_right
    have hr : ConcreteCategory.hom (R.germ U x hxU) r₀ =
        ConcreteCategory.hom (R.germ W x hxW)
          (ConcreteCategory.hom (R.map iWU.op) r₀) :=
      (TopCat.Presheaf.germ_res_apply R iWU x hxW r₀).symm
    have hs : ConcreteCategory.hom
          (TopCat.Presheaf.germ M.presheaf V x hxV) s₀ =
        ConcreteCategory.hom
          (TopCat.Presheaf.germ M.presheaf W x hxW)
            (ConcreteCategory.hom (M.presheaf.map iWV.op) s₀) :=
      (TopCat.Presheaf.germ_res_apply M.presheaf iWV x hxW s₀).symm
    have key : ∀ z : (↑(M.obj (op W)) : Type u),
        ConcreteCategory.hom
            ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map
              ((PresheafOfModules.toPresheaf _).map g))
          (ConcreteCategory.hom
            (TopCat.Presheaf.germ M.presheaf W x hxW) z) =
        ConcreteCategory.hom
            (TopCat.Presheaf.germ N.presheaf W x hxW)
          (ConcreteCategory.hom (g.app (op W)) z) := by
      intro z
      rw [show ConcreteCategory.hom (g.app (op W)) z =
          ConcreteCategory.hom
            (((PresheafOfModules.toPresheaf _).map g).app (op W)) z from
        (PresheafOfModules.toPresheaf_map_app_apply g (op W) z).symm]
      exact TopCat.Presheaf.stalkFunctor_map_germ_apply
        (F := M.presheaf) (G := N.presheaf)
        W x hxW ((PresheafOfModules.toPresheaf _).map g) z
    rw [hr, hs, ← PresheafOfModules.germ_smul M x W hxW, key, map_smul,
      PresheafOfModules.germ_smul N x W hxW, key]

@[simp]
theorem presheafStalkLinearMap_germ
    {T : TopCat.{u}} {R : T.Presheaf CommRingCat.{u}}
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (x : T)
    (U : Opens T) (hx : x ∈ U) (s : (↑(M.obj (op U)) : Type u)) :
    presheafStalkLinearMap g x
        (ConcreteCategory.hom (TopCat.Presheaf.germ M.presheaf U x hx) s) =
      ConcreteCategory.hom (TopCat.Presheaf.germ N.presheaf U x hx)
        (ConcreteCategory.hom (g.app (op U)) s) := by
  change ConcreteCategory.hom
        ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map
          ((PresheafOfModules.toPresheaf _).map g))
      (ConcreteCategory.hom (TopCat.Presheaf.germ M.presheaf U x hx) s) = _
  rw [show ConcreteCategory.hom (g.app (op U)) s =
      ConcreteCategory.hom
        (((PresheafOfModules.toPresheaf _).map g).app (op U)) s from
    (PresheafOfModules.toPresheaf_map_app_apply g (op U) s).symm]
  exact TopCat.Presheaf.stalkFunctor_map_germ_apply
    (F := M.presheaf) (G := N.presheaf)
    U x hx ((PresheafOfModules.toPresheaf _).map g) s

namespace Scheme.Modules

variable {X : Scheme.{u}}

/-- The underlying type of the stalk of a scheme module. -/
abbrev Stalk (M : X.Modules) (x : X) : Type u :=
  (↑(TopCat.Presheaf.stalk M.val.presheaf x) : Type u)

/-- The canonical `O_{X,x}`-module structure on the stalk of a scheme module. -/
noncomputable abbrev stalkModule (M : X.Modules) (x : X) :
    Module (X.presheaf.stalk x) (Stalk M x) :=
  PresheafOfModules.instModuleCarrierStalkCommRingCatCarrierAbPresheafOpensCarrier
    M.val x

/-- The `O_{X,x}`-linear map on stalks induced by a scheme-module morphism. -/
noncomputable def stalkLinearMap {M N : X.Modules} (f : M ⟶ N) (x : X) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
    Stalk M x →ₗ[X.presheaf.stalk x] Stalk N x := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
  exact Hartshorne.presheafStalkLinearMap f.val x

@[simp]
theorem stalkLinearMap_germ {M N : X.Modules} (f : M ⟶ N) (x : X)
    (U : X.Opens) (hx : x ∈ U) (s : (↑(M.val.obj (op U)) : Type u)) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
    stalkLinearMap f x
        (ConcreteCategory.hom (TopCat.Presheaf.germ M.val.presheaf U x hx) s) =
      ConcreteCategory.hom (TopCat.Presheaf.germ N.val.presheaf U x hx)
        (ConcreteCategory.hom (f.val.app (op U)) s) := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
  exact Hartshorne.presheafStalkLinearMap_germ f.val x U hx s

@[simp]
theorem stalkLinearMap_id (M : X.Modules) (x : X) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    stalkLinearMap (𝟙 M) x = LinearMap.id := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  apply LinearMap.ext
  intro m
  obtain ⟨U, hx, s, rfl⟩ :=
    TopCat.Presheaf.exists_germ_eq M.val.presheaf m
  rw [stalkLinearMap_germ]
  rfl

@[simp]
theorem stalkLinearMap_comp {M N P : X.Modules}
    (f : M ⟶ N) (g : N ⟶ P) (x : X) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
    letI : Module (X.presheaf.stalk x) (Stalk P x) := stalkModule P x
    stalkLinearMap (f ≫ g) x =
      (stalkLinearMap g x).comp (stalkLinearMap f x) := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
  letI : Module (X.presheaf.stalk x) (Stalk P x) := stalkModule P x
  apply LinearMap.ext
  intro m
  obtain ⟨U, hx, s, rfl⟩ :=
    TopCat.Presheaf.exists_germ_eq M.val.presheaf m
  change stalkLinearMap (f ≫ g) x
      (ConcreteCategory.hom
        (TopCat.Presheaf.germ M.val.presheaf U x hx) s) =
    stalkLinearMap g x
      (stalkLinearMap f x
        (ConcreteCategory.hom
          (TopCat.Presheaf.germ M.val.presheaf U x hx) s))
  rw [stalkLinearMap_germ, stalkLinearMap_germ, stalkLinearMap_germ]
  rfl

/-! ## Ordinary fibers and evaluation -/

/-- The ordinary fiber `kappa(x) tensor_{O_{X,x}} M_x` of a scheme module. -/
noncomputable abbrev stalkFiber (M : X.Modules) (x : X) : Type u :=
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  IsLocalRing.ResidueField (X.presheaf.stalk x) ⊗[X.presheaf.stalk x] Stalk M x

/-- A scheme-module morphism induces a residue-field-linear map on ordinary fibers. -/
noncomputable def stalkFiberMap {M N : X.Modules} (f : M ⟶ N) (x : X) :
    stalkFiber M x →ₗ[IsLocalRing.ResidueField (X.presheaf.stalk x)]
      stalkFiber N x := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
  exact LinearMap.baseChange (IsLocalRing.ResidueField (X.presheaf.stalk x))
    (stalkLinearMap f x)

@[simp]
theorem stalkFiberMap_tmul {M N : X.Modules} (f : M ⟶ N) (x : X)
    (a : IsLocalRing.ResidueField (X.presheaf.stalk x)) (m : Stalk M x) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
    stalkFiberMap f x (a ⊗ₜ[X.presheaf.stalk x] m) =
      a ⊗ₜ[X.presheaf.stalk x] stalkLinearMap f x m := by
  rfl

@[simp]
theorem stalkFiberMap_id (M : X.Modules) (x : X) :
    stalkFiberMap (𝟙 M) x = LinearMap.id := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  change LinearMap.baseChange (IsLocalRing.ResidueField (X.presheaf.stalk x))
      (stalkLinearMap (𝟙 M) x) = LinearMap.id
  rw [stalkLinearMap_id, LinearMap.baseChange_id]

@[simp]
theorem stalkFiberMap_comp {M N P : X.Modules}
    (f : M ⟶ N) (g : N ⟶ P) (x : X) :
    stalkFiberMap (f ≫ g) x =
      (stalkFiberMap g x).comp (stalkFiberMap f x) := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
  letI : Module (X.presheaf.stalk x) (Stalk P x) := stalkModule P x
  change LinearMap.baseChange (IsLocalRing.ResidueField (X.presheaf.stalk x))
      (stalkLinearMap (f ≫ g) x) =
    (LinearMap.baseChange (IsLocalRing.ResidueField (X.presheaf.stalk x))
      (stalkLinearMap g x)).comp
    (LinearMap.baseChange (IsLocalRing.ResidueField (X.presheaf.stalk x))
      (stalkLinearMap f x))
  rw [stalkLinearMap_comp, LinearMap.baseChange_comp]

/-- The canonical scalar map from global functions to the residue field. -/
noncomputable def globalToResidue (X : Scheme.{u}) (x : X) :
    Γ(X, (⊤ : X.Opens)) →+* IsLocalRing.ResidueField (X.presheaf.stalk x) :=
  (IsLocalRing.residue (X.presheaf.stalk x)).comp
    (X.presheaf.germ (⊤ : X.Opens) x trivial).hom

/-- Evaluation of global sections in the ordinary residue fiber. -/
noncomputable def fiberEvaluation (M : X.Modules) (x : X) :
    Γ(M, (⊤ : X.Opens)) →ₛₗ[globalToResidue X x] stalkFiber M x := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  set_option backward.isDefEq.respectTransparency false in
    exact
      { toFun := fun s => 1 ⊗ₜ[X.presheaf.stalk x]
        ConcreteCategory.hom
          (TopCat.Presheaf.germ M.val.presheaf (⊤ : X.Opens) x trivial) s
        map_add' := by
          intro a b
          rw [map_add, TensorProduct.tmul_add]
        map_smul' := by
          intro r s
          rw [PresheafOfModules.germ_smul M.val]
          change 1 ⊗ₜ[X.presheaf.stalk x]
              (ConcreteCategory.hom
                (X.presheaf.germ (⊤ : X.Opens) x trivial) r •
                ConcreteCategory.hom
                  (TopCat.Presheaf.germ M.val.presheaf
                    (⊤ : X.Opens) x trivial) s) =
            globalToResidue X x r •
              (1 ⊗ₜ[X.presheaf.stalk x]
                ConcreteCategory.hom
                  (TopCat.Presheaf.germ M.val.presheaf
                    (⊤ : X.Opens) x trivial) s)
          rw [TensorProduct.tmul_smul]
          rfl }

@[simp]
theorem fiberEvaluation_apply (M : X.Modules) (x : X)
    (s : Γ(M, (⊤ : X.Opens))) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    fiberEvaluation M x s =
      1 ⊗ₜ[X.presheaf.stalk x]
        ConcreteCategory.hom
          (TopCat.Presheaf.germ M.val.presheaf
            (⊤ : X.Opens) x trivial) s := by
  rfl

/-- Evaluation commutes with a morphism of scheme modules. -/
@[simp]
theorem stalkFiberMap_fiberEvaluation {M N : X.Modules}
    (f : M ⟶ N) (x : X) (s : Γ(M, (⊤ : X.Opens))) :
    stalkFiberMap f x (fiberEvaluation M x s) =
      fiberEvaluation N x (ConcreteCategory.hom (f.val.app (op ⊤)) s) := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  letI : Module (X.presheaf.stalk x) (Stalk N x) := stalkModule N x
  rw [fiberEvaluation_apply, stalkFiberMap_tmul, stalkLinearMap_germ]
  rfl

/-! ## The quotient model of the fiber -/

/-- The ordinary fiber is canonically the stalk modulo its maximal-ideal action. -/
noncomputable def stalkFiberEquivQuotient (M : X.Modules) (x : X) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    stalkFiber M x ≃ₗ[X.presheaf.stalk x]
      Stalk M x ⧸
        (IsLocalRing.maximalIdeal (X.presheaf.stalk x) •
          (⊤ : Submodule (X.presheaf.stalk x) (Stalk M x))) := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  exact TensorProduct.quotTensorEquivQuotSMul
    (Stalk M x) (IsLocalRing.maximalIdeal (X.presheaf.stalk x))

@[simp]
theorem stalkFiberEquivQuotient_one_tmul (M : X.Modules) (x : X)
    (m : Stalk M x) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    stalkFiberEquivQuotient M x
        (1 ⊗ₜ[X.presheaf.stalk x] m) = Submodule.Quotient.mk m := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  change TensorProduct.quotTensorEquivQuotSMul
      (Stalk M x) (IsLocalRing.maximalIdeal (X.presheaf.stalk x))
        (Ideal.Quotient.mk (IsLocalRing.maximalIdeal (X.presheaf.stalk x)) 1
          ⊗ₜ[X.presheaf.stalk x] m) = Submodule.Quotient.mk m
  simpa only [one_smul] using
    TensorProduct.quotTensorEquivQuotSMul_mk_tmul
      (IsLocalRing.maximalIdeal (X.presheaf.stalk x)) 1 m

/-- A global section vanishes in the fiber exactly when its germ lies in
the maximal-ideal action on the stalk. -/
theorem fiberEvaluation_eq_zero_iff (M : X.Modules) (x : X)
    (s : Γ(M, (⊤ : X.Opens))) :
    letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
    fiberEvaluation M x s = 0 ↔
      ConcreteCategory.hom
          (TopCat.Presheaf.germ M.val.presheaf
            (⊤ : X.Opens) x trivial) s ∈
        IsLocalRing.maximalIdeal (X.presheaf.stalk x) •
          (⊤ : Submodule (X.presheaf.stalk x) (Stalk M x)) := by
  letI : Module (X.presheaf.stalk x) (Stalk M x) := stalkModule M x
  rw [← (stalkFiberEquivQuotient M x).map_eq_zero_iff,
    fiberEvaluation_apply, stalkFiberEquivQuotient_one_tmul,
    Submodule.Quotient.mk_eq_zero]

end Scheme.Modules

end

end Hartshorne
