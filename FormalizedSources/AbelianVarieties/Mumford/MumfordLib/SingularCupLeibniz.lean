/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCupProductGeneral
import MumfordLib.SingularCupFaces
import MumfordLib.CupSignedSum

/-!
# The signed Leibniz identity for singular cups

The boundary sum splits at the shared vertex of the Alexander--Whitney
product. The two occurrences of that vertex have opposite signs.
This gives the cochain identity needed to descend cups to cohomology in
Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat} {p q n m : ℕ}

private def restrictedEval (φ : IntegralSingularCochain X p)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌)) (f : ⦋p⦌ ⟶ ⦋n⦌) : ℤ :=
  (singularSimplexChain ((TopCat.toSSet.obj X).map f.op σ) ≫ φ).hom 1

private theorem restrictedEval_comp (φ : IntegralSingularCochain X p)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌))
    (f : ⦋p⦌ ⟶ ⦋m⦌) (g : ⦋m⦌ ⟶ ⦋n⦌) :
    restrictedEval φ ((TopCat.toSSet.obj X).map g.op σ) f =
      restrictedEval φ σ (f ≫ g) := by
  simp only [restrictedEval, op_comp, Functor.map_comp_apply]

private theorem restrictedEval_coboundary (φ : IntegralSingularCochain X p)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n⦌)) (f : ⦋p + 1⦌ ⟶ ⦋n⦌) :
    restrictedEval (singularCochainCoboundary φ) σ f =
      ∑ i : Fin (p + 2), (-1 : ℤ) ^ i.val *
        restrictedEval φ σ (SimplexCategory.δ i ≫ f) := by
  unfold restrictedEval
  rw [singularCochainCoboundary_eval]
  simp only [SimplicialObject.δ, op_comp, Functor.map_comp_apply]

private theorem singularCochainCup_face_eval (φ : IntegralSingularCochain X p)
    (ψ : IntegralSingularCochain X q) (h : p + q = n)
    (σ : (TopCat.toSSet.obj X).obj (op ⦋n + 1⦌)) (i : Fin (n + 2)) :
    (singularSimplexChain ((TopCat.toSSet.obj X).δ i σ) ≫
      singularCochainCup φ ψ h).hom 1 =
      restrictedEval φ σ
        (SimplexCategory.subinterval 0 p (by omega) ≫ SimplexCategory.δ i) *
      restrictedEval ψ σ
        (SimplexCategory.subinterval p q (by omega) ≫ SimplexCategory.δ i) := by
  rw [singularCochainCup_eval]
  exact congrArg₂ (· * ·)
    (restrictedEval_comp φ σ _ _) (restrictedEval_comp ψ σ _ _)

/-- The Alexander--Whitney cup satisfies the signed Leibniz identity in all
bidegrees, including degree zero. -/
theorem singularCochainCup_coboundary (φ : IntegralSingularCochain X p)
    (ψ : IntegralSingularCochain X q) (h : p + q = n) :
    singularCochainCoboundary (singularCochainCup φ ψ h) =
      singularCochainCup (singularCochainCoboundary φ) ψ (by omega) +
        (-1 : ℤ) ^ p •
          singularCochainCup φ (singularCochainCoboundary ψ) (by omega) := by
  apply integralSingularCochain_ext
  intro σ
  let a : Fin (p + 2) → ℤ := fun i => restrictedEval φ σ
    (SimplexCategory.δ i ≫ SimplexCategory.subinterval 0 (p + 1) (by omega))
  let b : Fin (q + 2) → ℤ := fun i => restrictedEval ψ σ
    (SimplexCategory.δ i ≫ SimplexCategory.subinterval p (q + 1) (by omega))
  let c : Fin (n + 2) → ℤ := fun i =>
    restrictedEval φ σ
      (SimplexCategory.subinterval 0 p (by omega) ≫ SimplexCategory.δ i) *
    restrictedEval ψ σ
      (SimplexCategory.subinterval p q (by omega) ≫ SimplexCategory.δ i)
  let A := restrictedEval φ σ (SimplexCategory.subinterval 0 p (by omega))
  let B := restrictedEval ψ σ (SimplexCategory.subinterval (p + 1) q (by omega))
  have hleft (i : Fin (n + 2)) (hi : i.val ≤ p) :
      c i = a ⟨i.val, by omega⟩ * B := by
    dsimp only [c, a, B]
    rw [subinterval_comp_face_inside (by omega) i (by omega) (by omega),
      subinterval_comp_face_before (by omega) i hi]
    simp only [Nat.sub_zero]
  have hright (i : Fin (n + 2)) (hi : p < i.val) :
      c i = A * b ⟨i.val - p, by omega⟩ := by
    dsimp only [c, A, b]
    rw [subinterval_comp_face_after (by omega) i (by omega),
      subinterval_comp_face_inside (by omega) i (by omega) (by omega)]
  have ha : a (Fin.last (p + 1)) = A := by
    dsimp only [a, A]
    rw [face_last_comp_subinterval]
  have hb : b 0 = B := by
    dsimp only [b, B]
    rw [face_zero_comp_subinterval]
  calc
    _ = ∑ i : Fin (n + 2), (-1 : ℤ) ^ i.val * c i := by
      rw [singularCochainCoboundary_eval]
      apply Finset.sum_congr rfl
      intro i _
      rw [singularCochainCup_face_eval]
    _ = (∑ i : Fin (p + 2), (-1 : ℤ) ^ i.val * a i) * B +
        (-1 : ℤ) ^ p * A * (∑ i : Fin (q + 2), (-1 : ℤ) ^ i.val * b i) :=
      singularCup_signed_sum h a b c A B hleft hright ha hb
    _ = _ := by
      simp only [Preadditive.comp_add, Preadditive.comp_zsmul, ModuleCat.hom_add,
        ModuleCat.hom_zsmul, LinearMap.add_apply, LinearMap.smul_apply,
        smul_eq_mul]
      rw [singularCochainCup_eval, singularCochainCup_eval]
      change _ = restrictedEval (singularCochainCoboundary φ) σ
        (SimplexCategory.subinterval 0 (p + 1) (by omega)) * B +
        (-1 : ℤ) ^ p * (A * restrictedEval (singularCochainCoboundary ψ) σ
          (SimplexCategory.subinterval p (q + 1) (by omega)))
      rw [restrictedEval_coboundary, restrictedEval_coboundary]
      change _ = (∑ i : Fin (p + 2), (-1 : ℤ) ^ i.val * a i) * B +
        (-1 : ℤ) ^ p * (A * (∑ i : Fin (q + 2), (-1 : ℤ) ^ i.val * b i))
      ring

/-- Cups of integral singular cocycles are cocycles in every bidegree. -/
theorem singularCochainCup_cocycle (φ : IntegralSingularCocycle X p)
    (ψ : IntegralSingularCocycle X q) (h : p + q = n) :
    singularCochainCoboundary (singularCochainCup φ.1 ψ.1 h) = 0 := by
  rw [singularCochainCup_coboundary, φ.property, ψ.property]
  simp

/-- The cup itself is a primitive when its left factor is differentiated
and its right factor is a cocycle. -/
theorem singularCochainCup_coboundary_left (φ : IntegralSingularCochain X p)
    (ψ : IntegralSingularCocycle X q) (h : p + q = n) :
    singularCochainCoboundary (singularCochainCup φ ψ.1 h) =
      singularCochainCup (singularCochainCoboundary φ) ψ.1 (by omega) := by
  rw [singularCochainCup_coboundary, ψ.property]
  simp

/-- The signed cup is a primitive when the right factor is differentiated
and the left factor is a cocycle. -/
theorem singularCochainCup_coboundary_right (φ : IntegralSingularCocycle X p)
    (ψ : IntegralSingularCochain X q) (h : p + q = n) :
    singularCochainCoboundary ((-1 : ℤ) ^ p • singularCochainCup φ.1 ψ h) =
      singularCochainCup φ.1 (singularCochainCoboundary ψ) (by omega) := by
  change (-1 : ℤ) ^ p • singularCochainCoboundary (singularCochainCup φ.1 ψ h) = _
  rw [singularCochainCup_coboundary, φ.property]
  simp only [singularCochainCup_zero_left, zero_add, smul_smul]
  have hs : (-1 : ℤ) ^ p * (-1 : ℤ) ^ p = 1 := by
    rw [← mul_pow]
    simp
  rw [hs, one_smul]

end Mumford.Analytic
