/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RigidityChain
import Mathlib.CategoryTheory.Monoidal.Cartesian.Grp

/-!
# Additive consequences of Form-I rigidity

These are the two standard group-variety corollaries: a pointed map out of a
product is the sum of its axis restrictions, and a pointed morphism of group
objects preserves multiplication.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
open AlgebraicGeometry

namespace Mumford.GroupScheme

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]

/-- A pointed map out of a product is the sum of its two axis restrictions. -/
theorem hom_additive_decomp_of_rigidity
    {V W : Over (Spec (.of kbar))}
    [IsProper V.hom]
    [GeometricallyIrreducible (V ⊗ W).hom]
    [LocallyOfFiniteType (V ⊗ W).hom]
    [IsReduced (V ⊗ W).left]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsSeparated A.hom]
    (v₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ V)
    (w₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ W)
    (h : V ⊗ W ⟶ A)
    (hh : lift v₀ w₀ ≫ h = η[A]) :
    h = (fst V W ≫ (lift (𝟙 V) (toUnit V ≫ w₀) ≫ h)) *
        (snd V W ≫ (lift (toUnit W ≫ v₀) (𝟙 W) ≫ h)) := by
  set f : V ⟶ A := lift (𝟙 V) (toUnit V ≫ w₀) ≫ h with hf
  set g : W ⟶ A := lift (toUnit W ≫ v₀) (𝟙 W) ≫ h with hg
  have hsVfst : lift (𝟙 V) (toUnit V ≫ w₀) ≫ fst V W = 𝟙 V := by simp
  have hsVsnd : lift (𝟙 V) (toUnit V ≫ w₀) ≫ snd V W = toUnit V ≫ w₀ := by simp
  have hsWfst : lift (toUnit W ≫ v₀) (𝟙 W) ≫ fst V W = toUnit W ≫ v₀ := by simp
  have hsWsnd : lift (toUnit W ≫ v₀) (𝟙 W) ≫ snd V W = 𝟙 W := by simp
  have hwsW : w₀ ≫ lift (toUnit W ≫ v₀) (𝟙 W) = lift v₀ w₀ := by
    rw [comp_lift, Category.comp_id, ← Category.assoc,
      toUnit_unique (w₀ ≫ toUnit W) (𝟙 _), Category.id_comp]
  have hvsV : v₀ ≫ lift (𝟙 V) (toUnit V ≫ w₀) = lift v₀ w₀ := by
    rw [comp_lift, Category.comp_id, ← Category.assoc,
      toUnit_unique (v₀ ≫ toUnit V) (𝟙 _), Category.id_comp]
  have hwg : w₀ ≫ g = η[A] := by rw [hg, ← Category.assoc, hwsW, hh]
  have hvf : v₀ ≫ f = η[A] := by rw [hf, ← Category.assoc, hvsV, hh]
  set φ : V ⊗ W ⟶ A := h / ((fst V W ≫ f) * (snd V W ≫ g)) with hφ
  have hcolV : lift (𝟙 V) (toUnit V ≫ w₀) ≫ φ = toUnit V ≫ η[A] := by
    rw [← Hom.one_def, hφ, GrpObj.comp_div, ← hf, MonObj.comp_mul,
      ← Category.assoc, hsVfst, Category.id_comp,
      ← Category.assoc, hsVsnd, Category.assoc, hwg, ← Hom.one_def,
      _root_.mul_one, div_self']
  have hcolW : lift (toUnit W ≫ v₀) (𝟙 W) ≫ φ = (1 : W ⟶ A) := by
    rw [hφ, GrpObj.comp_div, ← hg, MonObj.comp_mul,
      ← Category.assoc, hsWfst, Category.assoc, hvf, ← Hom.one_def,
      ← Category.assoc, hsWsnd, Category.id_comp, _root_.one_mul, div_self']
  obtain ⟨g', hg'⟩ := rigidity_lemma φ v₀ w₀ η[A] hcolV
  have hg'1 : g' = 1 := by
    have hsec : lift (toUnit W ≫ v₀) (𝟙 W) ≫ φ = g' := by
      rw [hg', ← Category.assoc, hsWsnd, Category.id_comp]
    rw [← hsec, hcolW]
  have hφ1 : φ = 1 := by rw [hg', hg'1, MonObj.comp_one]
  have hdiv : h / ((fst V W ≫ f) * (snd V W ≫ g)) = 1 := by rw [← hφ]; exact hφ1
  exact div_eq_one.mp hdiv

/-- A pointed morphism of group objects is a monoid homomorphism. -/
theorem isMonHom_of_pointed
    {A B : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom]
    [GeometricallyIrreducible (A ⊗ A).hom]
    [LocallyOfFiniteType (A ⊗ A).hom]
    [IsReduced (A ⊗ A).left]
    [GrpObj B] [IsSeparated B.hom]
    (α : A ⟶ B) (hα : η[A] ≫ α = η[B]) : IsMonHom α := by
  have h1 : (η[A] : 𝟙_ (Over (Spec (.of kbar))) ⟶ A) = 1 := by
    rw [Hom.one_def, toUnit_unique (toUnit _) (𝟙 _), Category.id_comp]
  have hbase : lift η[A] η[A] ≫ μ[A] = η[A] := by
    rw [← Hom.mul_def, h1, _root_.mul_one]
  have key := hom_additive_decomp_of_rigidity (V := A) (W := A) (A := B)
    η[A] η[A] (μ[A] ≫ α) (by rw [← Category.assoc, hbase, hα])
  rw [show lift (𝟙 A) (toUnit A ≫ η[A]) ≫ μ[A] ≫ α = α by
        rw [← Category.assoc, lift_comp_one_right, Category.id_comp],
      show lift (toUnit A ≫ η[A]) (𝟙 A) ≫ μ[A] ≫ α = α by
        rw [← Category.assoc, lift_comp_one_left, Category.id_comp]] at key
  exact { one_hom := hα, mul_hom := by rw [key, Hom.mul_def, lift_fst_comp_snd_comp] }

end Mumford.GroupScheme
