/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.ModuleDescent

/-!
# Faithfully flat descent of commutative algebras

This file upgrades the existing effectivity theorem for module descent to
commutative algebras.  It is the affine-local algebraic input for effective
descent of schemes.

## Main declarations

* `Algebra.DescentDatum`: a module descent datum whose coaction preserves one
  and multiplication.
* `Algebra.DescentDatum.descended`: the equalizer subalgebra.
* `Algebra.DescentDatum.comparison_bijective`: effectivity of flat descent for
  commutative algebras.
* `Algebra.DescentDatum.descentEquiv`: the resulting algebra equivalence
  `B ⊗[A] R₀ ≃ₐ[B] R`.
-/

set_option autoImplicit false

universe u

open TensorProduct

namespace Algebra

variable (A B R : Type u) [CommRing A] [CommRing B] [CommRing R]
  [Algebra A B] [Algebra A R] [Algebra B R] [IsScalarTower A B R]

/-- A commutative-algebra descent datum over `A -> B`: a module descent datum
whose coaction preserves one and multiplication. -/
structure DescentDatum extends Module.DescentDatum A B R where
  coaction_one : coaction 1 = 1
  coaction_mul (x y : R) : coaction (x * y) = coaction x * coaction y

namespace DescentDatum

variable {A B R}

/-- The algebra homomorphism underlying an algebra descent coaction. -/
noncomputable def coactionAlgHom (D : DescentDatum A B R) :
    R →ₐ[B] B ⊗[A] R :=
  AlgHom.ofLinearMap D.coaction D.coaction_one D.coaction_mul

/-- The descended `A`-algebra, defined as the equalizer of the coaction and
the canonical map `r |-> 1 tensor r`. -/
noncomputable def descended (D : DescentDatum A B R) : Subalgebra A R :=
  AlgHom.equalizer (D.coactionAlgHom.restrictScalars A)
    Algebra.TensorProduct.includeRight

/-- Membership in the descended algebra is the same equalizer condition as
membership in the descended underlying module. -/
theorem mem_descended (D : DescentDatum A B R) {x : R} :
    x ∈ D.descended ↔ x ∈ D.toDescentDatum.descended := by
  rw [descended, AlgHom.mem_equalizer, Module.DescentDatum.mem_descended,
    Algebra.TensorProduct.includeRight_apply]
  rfl

/-- The underlying module of the descended algebra is exactly the module
descended by `Module.DescentDatum`. -/
theorem descended_toSubmodule (D : DescentDatum A B R) :
    D.descended.toSubmodule = D.toDescentDatum.descended := by
  ext x
  exact D.mem_descended

/-- The tautological linear equivalence between the two equalizer carriers. -/
noncomputable def descendedLinearEquiv (D : DescentDatum A B R) :
    D.descended ≃ₗ[A] D.toDescentDatum.descended :=
  LinearEquiv.ofEq _ _ D.descended_toSubmodule

/-- The comparison map from the base change of the descended algebra to the
original algebra. -/
noncomputable def comparison (D : DescentDatum A B R) :
    B ⊗[A] D.descended →ₐ[B] R :=
  Algebra.TensorProduct.lift (Algebra.ofId B R) D.descended.val
    (fun _ _ => Commute.all _ _)

@[simp]
theorem comparison_tmul (D : DescentDatum A B R) (b : B) (x : D.descended) :
    D.comparison (b ⊗ₜ x) = b • (x : R) := by
  simp [comparison, Algebra.smul_def]

/-- The algebra comparison has the same underlying function as the module
comparison, after identifying the two equalizer carriers. -/
theorem comparison_eq_moduleComparison (D : DescentDatum A B R)
    (x : B ⊗[A] D.descended) :
    D.comparison x =
      D.toDescentDatum.comparison (D.descendedLinearEquiv.lTensor B x) := by
  induction x with
  | zero => simp
  | tmul b x =>
      rw [comparison_tmul, LinearEquiv.lTensor_tmul,
        Module.DescentDatum.comparison_tmul]
      rfl
  | add x y hx hy => simp [hx, hy]

/-- Effectivity of flat descent for commutative algebras: the comparison from
the base change of the equalizer algebra is bijective. -/
theorem comparison_bijective (D : DescentDatum A B R) [Module.Flat A B] :
    Function.Bijective D.comparison := by
  have hfun :
      (D.comparison : B ⊗[A] D.descended → R) =
        D.toDescentDatum.comparison ∘ D.descendedLinearEquiv.lTensor B := by
    funext x
    exact D.comparison_eq_moduleComparison x
  rw [hfun]
  exact D.toDescentDatum.comparison_bijective.comp
    (D.descendedLinearEquiv.lTensor B).bijective

/-- The canonical algebra equivalence supplied by effective flat descent. -/
noncomputable def descentEquiv (D : DescentDatum A B R) [Module.Flat A B] :
    B ⊗[A] D.descended ≃ₐ[B] R :=
  AlgEquiv.ofBijective D.comparison D.comparison_bijective

@[simp]
theorem descentEquiv_tmul (D : DescentDatum A B R) [Module.Flat A B]
    (b : B) (x : D.descended) :
    D.descentEquiv (b ⊗ₜ x) = b • (x : R) :=
  D.comparison_tmul b x

end DescentDatum

end Algebra
