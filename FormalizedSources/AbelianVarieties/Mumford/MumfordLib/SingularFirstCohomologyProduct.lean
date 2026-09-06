/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.FirstCohomologyComparison
import MumfordLib.SingularCohomologyPullback
import Mathlib.Topology.Homotopy.Product

/-!
# First singular cohomology of a product

Restriction to the two axes identifies integral first cohomology of a product
of path-connected spaces with the product of their first cohomologies. The
inverse is the sum of pullbacks along the projections. The proof uses loop
evaluation and the decomposition of a product loop into its two coordinates.

This is the degree-one product decomposition used in Mumford, Chapter I,
Section 1, p. 3, in the proof of integral cohomology of a torus.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

variable {X Y : TopCat}

/-- Pullback evaluates on a loop by evaluating its image. -/
theorem singularFirstCohomologyLoopEval_pullback (f : X ⟶ Y) (x : X)
    (c : IntegralSingularCohomology Y 1) (p : Path x x) :
    singularFirstCohomologyLoopEval x (singularCohomologyPullback f 1 c) p =
      singularFirstCohomologyLoopEval (f x) c (p.map f.hom.continuous) := by
  obtain ⟨φ, rfl⟩ := singularCohomologyClass_surjective Y 1 c
  rw [singularCohomologyPullback_class]
  simp only [singularCohomologyClass_succ, singularPositiveCohomologyClass_zero]
  change singularFirstCohomologyLoopEval x
      (singularFirstCohomologyClass X
        (show singularOneCocycles X from singularCocyclePullback f 1 φ)) p =
    singularFirstCohomologyLoopEval (f x)
      (singularFirstCohomologyClass Y (show singularOneCocycles Y from φ))
      (p.map f.hom.continuous)
  rw [singularFirstCohomologyLoopEval_class x (singularCocyclePullback f 1 φ),
    singularFirstCohomologyLoopEval_class (f x) φ]
  change singularCochainPathEval (singularCochainPullback f 1 φ.1) p = _
  unfold singularCochainPathEval
  rw [singularCochainPullback_eval]
  rfl

/-- Equality in first cohomology can be tested on all loops at one basepoint. -/
theorem singularFirstCohomology_ext_loop [PathConnectedSpace X] (x : X)
    {c d : IntegralSingularCohomology X 1}
    (h : ∀ p : Path x x,
      singularFirstCohomologyLoopEval x c p = singularFirstCohomologyLoopEval x d p) :
    c = d := by
  apply singularFirstCohomologyToCharacters_injective x
  apply AddMonoidHom.ext
  intro p
  induction p using Path.Homotopic.Quotient.ind with
  | mk p => exact h p

/-- A product loop is homotopic to the concatenation of its two axis loops. -/
theorem productLoop_homotopic_axes (x : X) (y : Y)
    (p : Path (x, y) (x, y)) :
    p.Homotopic
      (((p.map continuous_fst).prod (Path.refl y)).trans
        ((Path.refl x).prod (p.map continuous_snd))) := by
  apply Path.Homotopic.Quotient.eq.mp
  symm
  rw [Path.Homotopic.Quotient.mk_trans, ← Path.Homotopic.prod_lift,
    ← Path.Homotopic.prod_lift, Path.Homotopic.comp_prod_eq_prod_comp]
  simp only [Path.Homotopic.Quotient.mk_refl, Path.Homotopic.Quotient.trans_refl,
    Path.Homotopic.Quotient.refl_trans]
  exact Path.Homotopic.prod_projLeft_projRight (Path.Homotopic.Quotient.mk p)

/-- Restriction of first cohomology to the two axes of a product. -/
def singularFirstCohomologyProdRestrict (x : X) (y : Y) :
    IntegralSingularCohomology (TopCat.of (X × Y)) 1 →ₗ[ℤ]
      IntegralSingularCohomology X 1 × IntegralSingularCohomology Y 1 where
  toFun c :=
    (singularCohomologyPullback
      (TopCat.ofHom ⟨fun a : X => (a, y), continuous_id.prodMk continuous_const⟩) 1 c,
     singularCohomologyPullback
      (TopCat.ofHom ⟨fun b : Y => (x, b), continuous_const.prodMk continuous_id⟩) 1 c)
  map_add' c d := by ext <;> simp [map_add]
  map_smul' z c := by ext <;> simp [← Int.cast_smul_eq_zsmul ℤ]

/-- The sum of the two projection pullbacks in first cohomology. -/
def singularFirstCohomologyProdPullback (X Y : TopCat) :
    (IntegralSingularCohomology X 1 × IntegralSingularCohomology Y 1) →ₗ[ℤ]
      IntegralSingularCohomology (TopCat.of (X × Y)) 1 where
  toFun c :=
    singularCohomologyPullback
      (TopCat.ofHom ⟨(Prod.fst : X × Y → X), continuous_fst⟩) 1 c.1 +
    singularCohomologyPullback
      (TopCat.ofHom ⟨(Prod.snd : X × Y → Y), continuous_snd⟩) 1 c.2
  map_add' c d := by simp [map_add, add_add_add_comm]
  map_smul' z c := by simp [← Int.cast_smul_eq_zsmul ℤ, smul_add]

@[simp]
theorem singularFirstCohomologyProdRestrict_apply (x : X) (y : Y)
    (c : IntegralSingularCohomology (TopCat.of (X × Y)) 1) :
    singularFirstCohomologyProdRestrict x y c =
      (singularCohomologyPullback
        (TopCat.ofHom ⟨fun a : X => (a, y), continuous_id.prodMk continuous_const⟩) 1 c,
       singularCohomologyPullback
        (TopCat.ofHom ⟨fun b : Y => (x, b), continuous_const.prodMk continuous_id⟩) 1 c) :=
  rfl

@[simp]
theorem singularFirstCohomologyProdPullback_apply
    (c : IntegralSingularCohomology X 1) (d : IntegralSingularCohomology Y 1) :
    singularFirstCohomologyProdPullback X Y (c, d) =
      singularCohomologyPullback (TopCat.ofHom ⟨Prod.fst, continuous_fst⟩) 1 c +
        singularCohomologyPullback (TopCat.ofHom ⟨Prod.snd, continuous_snd⟩) 1 d :=
  rfl

/-- Every degree-one class on a product is the sum of its axis restrictions
pulled back along the projections. -/
theorem singularFirstCohomologyProdPullback_restrict
    [PathConnectedSpace X] [PathConnectedSpace Y] (x : X) (y : Y)
    (c : IntegralSingularCohomology (TopCat.of (X × Y)) 1) :
    singularFirstCohomologyProdPullback X Y (singularFirstCohomologyProdRestrict x y c) = c := by
  letI : PathConnectedSpace (X × Y) :=
    { nonempty := ⟨(x, y)⟩
      joined := fun a b => ⟨(PathConnectedSpace.somePath a.1 b.1).prod
        (PathConnectedSpace.somePath a.2 b.2)⟩ }
  apply singularFirstCohomology_ext_loop (X := TopCat.of (X × Y)) (x, y)
  intro p
  rw [singularFirstCohomologyProdRestrict_apply, singularFirstCohomologyProdPullback_apply,
    map_add]
  simp only [Pi.add_apply]
  rw [singularFirstCohomologyLoopEval_pullback,
    singularFirstCohomologyLoopEval_pullback,
    singularFirstCohomologyLoopEval_pullback,
    singularFirstCohomologyLoopEval_pullback]
  change singularFirstCohomologyLoopEval (x, y) c
      ((p.map continuous_fst).prod (Path.refl y)) +
    singularFirstCohomologyLoopEval (x, y) c
      ((Path.refl x).prod (p.map continuous_snd)) =
    singularFirstCohomologyLoopEval (x, y) c p
  rw [← singularFirstCohomologyLoopEval_trans]
  exact (singularFirstCohomologyLoopEval_homotopic (x, y) c
    (productLoop_homotopic_axes x y p)).symm

/-- Restricting the sum of projection pullbacks recovers the original classes. -/
theorem singularFirstCohomologyProdRestrict_pullback
    [PathConnectedSpace X] [PathConnectedSpace Y] (x : X) (y : Y)
    (c : IntegralSingularCohomology X 1) (d : IntegralSingularCohomology Y 1) :
    singularFirstCohomologyProdRestrict x y
      (singularFirstCohomologyProdPullback X Y (c, d)) = (c, d) := by
  rw [singularFirstCohomologyProdRestrict_apply, singularFirstCohomologyProdPullback_apply]
  apply Prod.ext
  · apply singularFirstCohomology_ext_loop x
    intro p
    rw [singularFirstCohomologyLoopEval_pullback, map_add]
    simp only [Pi.add_apply]
    rw [singularFirstCohomologyLoopEval_pullback, singularFirstCohomologyLoopEval_pullback]
    change singularFirstCohomologyLoopEval x c p +
      singularFirstCohomologyLoopEval y d (Path.refl y) =
        singularFirstCohomologyLoopEval x c p
    rw [singularFirstCohomologyLoopEval_refl, add_zero]
  · apply singularFirstCohomology_ext_loop y
    intro p
    rw [singularFirstCohomologyLoopEval_pullback, map_add]
    simp only [Pi.add_apply]
    rw [singularFirstCohomologyLoopEval_pullback, singularFirstCohomologyLoopEval_pullback]
    change singularFirstCohomologyLoopEval x c (Path.refl x) +
      singularFirstCohomologyLoopEval y d p =
        singularFirstCohomologyLoopEval y d p
    rw [singularFirstCohomologyLoopEval_refl, zero_add]

/-- Integral first cohomology of a product is the product of the first
cohomologies, by restriction to the two axes. -/
def singularFirstCohomologyProdEquiv [PathConnectedSpace X] [PathConnectedSpace Y]
    (x : X) (y : Y) :
    IntegralSingularCohomology (TopCat.of (X × Y)) 1 ≃ₗ[ℤ]
      IntegralSingularCohomology X 1 × IntegralSingularCohomology Y 1 :=
  { singularFirstCohomologyProdRestrict x y with
    invFun := singularFirstCohomologyProdPullback X Y
    left_inv := singularFirstCohomologyProdPullback_restrict x y
    right_inv := fun c => singularFirstCohomologyProdRestrict_pullback x y c.1 c.2 }

@[simp]
theorem singularFirstCohomologyProdEquiv_apply
    [PathConnectedSpace X] [PathConnectedSpace Y] (x : X) (y : Y)
    (c : IntegralSingularCohomology (TopCat.of (X × Y)) 1) :
    singularFirstCohomologyProdEquiv x y c = singularFirstCohomologyProdRestrict x y c :=
  rfl

/-- The product comparison has the sum of projection pullbacks as its inverse. -/
@[simp]
theorem singularFirstCohomologyProdEquiv_symm_apply
    [PathConnectedSpace X] [PathConnectedSpace Y] (x : X) (y : Y)
    (c : IntegralSingularCohomology X 1) (d : IntegralSingularCohomology Y 1) :
    (singularFirstCohomologyProdEquiv x y).symm (c, d) =
      singularCohomologyPullback (TopCat.ofHom ⟨Prod.fst, continuous_fst⟩) 1 c +
        singularCohomologyPullback (TopCat.ofHom ⟨Prod.snd, continuous_snd⟩) 1 d :=
  rfl

end Mumford.Analytic
