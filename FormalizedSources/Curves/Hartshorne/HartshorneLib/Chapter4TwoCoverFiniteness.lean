/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2TwoCover
import HartshorneLib.Chapter4CechTwoCover

/-!
# Finiteness transport across a two-open Cech comparison

This file records the algebraic consumer needed by the curve finiteness argument.  The
Mayer--Vietoris construction presents `H¹` as a quotient by its restriction-difference map,
while the Laurent-window lemma is phrased for the explicit Cech quotient.  The comparison
between these presentations is retained as an explicit input: constructing it is the geometric
affine-cover step and should not be hidden behind definitional reduction.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne
namespace CechTwoCover

attribute [local instance] Scheme.overModule

variable (k : Type u) [Field k] (X : Scheme.{u})
  [X.Over (Spec (CommRingCat.of k))]
variable (U₀ U₁ : X.Opens)

/-! ### The finiteness consumer -/

/-- If the two pieces are affine (so their degree-one cohomology vanishes through the supplied
cokernel-section maps), and the overlap satisfies the Laurent-window hypotheses, then the
degree-one cohomology of the structure sheaf is a finite `k`-module.  The Cech comparison is
the only remaining geometric input and is deliberately an explicit linear equivalence. -/
theorem moduleFinite_hModule_one_of_twoCover
    (hcov : U₀ ⊔ U₁ = ⊤)
    (hsurj₀ : Function.Surjective
      ((cokernel.π (Injective.ι (X.moduleKSheaf k))).hom.app (op U₀)).hom)
    (hsurj₁ : Function.Surjective
      ((cokernel.π (Injective.ι (X.moduleKSheaf k))).hom.app (op U₁)).hom)
    (eCech :
      ((X.moduleKSheaf k).obj.obj (op (U₀ ⊓ U₁)) ⧸
        LinearMap.range ((X.twoCoverSquare U₀ U₁ hcov).moduleDiff (X.moduleKSheaf k))) ≃ₗ[k]
          schemeH1Cok k X U₀ U₁)
    [Module (LaurentPolynomial k) Γ(X, U₀ ⊓ U₁)]
    [IsScalarTower k (LaurentPolynomial k) Γ(X, U₀ ⊓ U₁)]
    [Module.Finite (LaurentPolynomial k) Γ(X, U₀ ⊓ U₁)]
    (hσ₀ : ∀ x ∈ LinearMap.range (leftRestriction k X U₀ U₁),
      (LaurentPolynomial.T 1 : LaurentPolynomial k) • x ∈
        LinearMap.range (leftRestriction k X U₀ U₁))
    (hσ₁ : ∀ x ∈ LinearMap.range (rightRestriction k X U₀ U₁),
      (LaurentPolynomial.T (-1) : LaurentPolynomial k) • x ∈
        LinearMap.range (rightRestriction k X U₀ U₁))
    (hσ₀loc : ∀ n : Γ(X, U₀ ⊓ U₁), ∃ m : ℕ,
      ((LaurentPolynomial.T 1 : LaurentPolynomial k) ^ m) • n ∈
        LinearMap.range (leftRestriction k X U₀ U₁))
    (hσ₁loc : ∀ n : Γ(X, U₀ ⊓ U₁), ∃ m : ℕ,
      ((LaurentPolynomial.T (-1) : LaurentPolynomial k) ^ m) • n ∈
        LinearMap.range (rightRestriction k X U₀ U₁)) :
    Module.Finite k
      (Sheaf.HModule (Opens.grothendieckTopology (X : TopCat)) k
        (X.moduleKSheaf k) 1) := by
  letI : Subsingleton (Sheaf.HModule' (X.moduleKSheaf k) U₀ 1) :=
    Sheaf.HModule'.subsingleton_one_of_cokernel_app_surjective
      (X.moduleKSheaf k) U₀ hsurj₀
  letI : Subsingleton (Sheaf.HModule' (X.moduleKSheaf k) U₁ 1) :=
    Sheaf.HModule'.subsingleton_one_of_cokernel_app_surjective
      (X.moduleKSheaf k) U₁ hsurj₁
  let eMV := Scheme.twoCoverH1LinearEquiv k X U₀ U₁
    (X.moduleKSheaf k) hcov
  have ecomp : Sheaf.HModule (Opens.grothendieckTopology (X : TopCat)) k
      (X.moduleKSheaf k) 1 ≃ₗ[k] schemeH1Cok k X U₀ U₁ := eMV.trans eCech
  letI : Module.Finite k (schemeH1Cok k X U₀ U₁) :=
    moduleFinite_H1Cok
      (leftRestriction k X U₀ U₁) (rightRestriction k X U₀ U₁)
      hσ₀ hσ₁ hσ₀loc hσ₁loc
  exact Module.Finite.equiv ecomp.symm

end CechTwoCover
end Hartshorne
