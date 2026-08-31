/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/
import HartshorneLib.Chapter4TwoCoverFiniteness

/-!
# Finite-map Laurent-cover input

This file packages the input supplied by the standard finite-map-to-the-projective-line
argument.  Mathlib does not yet provide the required projective-line charts and their
Laurent coordinate comparison in this development, so the package deliberately records
those facts as explicit data rather than asserting their existence.

A concrete map `X ⟶ P¹` should instantiate `FiniteMapLaurentCover` with the two standard
affine charts.  The theorem below then feeds its four Laurent-window properties directly
to the proved two-cover finiteness engine.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

attribute [local instance] Scheme.overModule

variable (k : Type u) [Field k] (X : Scheme.{u})
  [X.Over (Spec (CommRingCat.of k))]

/-- Explicit Laurent-coordinate data on the pullback of a two-affine cover along a finite
morphism.  For the intended projective-line application, `Y` is `P¹`, `V₀` and `V₁` are its
standard charts, and the four final fields express the two localization directions. -/
structure FiniteMapLaurentCover where
  Y : Scheme.{u}
  π : X ⟶ Y
  [isFinite : IsFinite π]
  V₀ : Y.Opens
  V₁ : Y.Opens
  cover : V₀ ⊔ V₁ = ⊤
  affine₀ : IsAffineOpen V₀
  affine₁ : IsAffineOpen V₁
  [laurentModule : Module (LaurentPolynomial k) Γ(X, π ⁻¹ᵁ V₀ ⊓ π ⁻¹ᵁ V₁)]
  [scalarTower : IsScalarTower k (LaurentPolynomial k) Γ(X, π ⁻¹ᵁ V₀ ⊓ π ⁻¹ᵁ V₁)]
  [finiteOverlap : Module.Finite (LaurentPolynomial k) Γ(X, π ⁻¹ᵁ V₀ ⊓ π ⁻¹ᵁ V₁)]
  stable₀ : ∀ x ∈ LinearMap.range
      (CechTwoCover.leftRestriction k X (π ⁻¹ᵁ V₀) (π ⁻¹ᵁ V₁)),
      (LaurentPolynomial.T 1 : LaurentPolynomial k) • x ∈ LinearMap.range
        (CechTwoCover.leftRestriction k X (π ⁻¹ᵁ V₀) (π ⁻¹ᵁ V₁))
  stable₁ : ∀ x ∈ LinearMap.range
      (CechTwoCover.rightRestriction k X (π ⁻¹ᵁ V₀) (π ⁻¹ᵁ V₁)),
      (LaurentPolynomial.T (-1) : LaurentPolynomial k) • x ∈ LinearMap.range
        (CechTwoCover.rightRestriction k X (π ⁻¹ᵁ V₀) (π ⁻¹ᵁ V₁))
  localize₀ : ∀ n : Γ(X, π ⁻¹ᵁ V₀ ⊓ π ⁻¹ᵁ V₁), ∃ m : ℕ,
      ((LaurentPolynomial.T 1 : LaurentPolynomial k) ^ m) • n ∈ LinearMap.range
        (CechTwoCover.leftRestriction k X (π ⁻¹ᵁ V₀) (π ⁻¹ᵁ V₁))
  localize₁ : ∀ n : Γ(X, π ⁻¹ᵁ V₀ ⊓ π ⁻¹ᵁ V₁), ∃ m : ℕ,
      ((LaurentPolynomial.T (-1) : LaurentPolynomial k) ^ m) • n ∈ LinearMap.range
        (CechTwoCover.rightRestriction k X (π ⁻¹ᵁ V₀) (π ⁻¹ᵁ V₁))

namespace FiniteMapLaurentCover

/-- The finite-map Laurent-cover package gives finite degree-one cohomology of the structure
sheaf.  This is the precise downstream output of a finite-map-to-`P¹` construction. -/
theorem moduleFinite_hModule_one (data : FiniteMapLaurentCover k X) :
    Module.Finite k
      (Sheaf.HModule (Opens.grothendieckTopology (X : TopCat)) k
        (X.moduleKSheaf k) 1) := by
  letI : IsFinite data.π := data.isFinite
  letI : Module (LaurentPolynomial k) Γ(X, data.π ⁻¹ᵁ data.V₀ ⊓ data.π ⁻¹ᵁ data.V₁) :=
    data.laurentModule
  letI : IsScalarTower k (LaurentPolynomial k)
      Γ(X, data.π ⁻¹ᵁ data.V₀ ⊓ data.π ⁻¹ᵁ data.V₁) := data.scalarTower
  letI : Module.Finite (LaurentPolynomial k)
      Γ(X, data.π ⁻¹ᵁ data.V₀ ⊓ data.π ⁻¹ᵁ data.V₁) := data.finiteOverlap
  exact CechTwoCover.moduleFinite_hModule_one_of_isFinite_affineCover k X data.π
    data.V₀ data.V₁ data.cover data.affine₀ data.affine₁
    data.stable₀ data.stable₁ data.localize₀ data.localize₁

end FiniteMapLaurentCover
end Hartshorne
