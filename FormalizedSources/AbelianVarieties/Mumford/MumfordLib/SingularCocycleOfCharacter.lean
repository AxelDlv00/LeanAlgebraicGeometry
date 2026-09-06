/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCochainExtension
import MumfordLib.SingularTrianglePaths
import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

/-!
# Singular cocycles from fundamental group characters

Choose a path from the basepoint to each point. An arrow in the fundamental
groupoid then determines a based loop by joining these paths at its endpoints.
An integer character evaluates this loop additively under composition.
Extending its values on singular one-simplices gives a cocycle, because the
three edges of every singular triangle satisfy the path composition relation.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory Opposite AlgebraicTopology
open scoped Simplicial

namespace Mumford.Analytic

variable {X : TopCat} [PathConnectedSpace X] {b x y z : X}

private def basepointConnector (b x : X) :
    FundamentalGroupoid.mk b ⟶ FundamentalGroupoid.mk x :=
  Path.Homotopic.Quotient.mk (PathConnectedSpace.somePath b x)

/-- An integer character evaluated on an arrow by joining its endpoints to
the basepoint. -/
def fundamentalCharacterArrowValue (χ : Additive (FundamentalGroup X b) →+ ℤ)
    (p : FundamentalGroupoid.mk x ⟶ FundamentalGroupoid.mk y) : ℤ :=
  χ (Additive.ofMul (FundamentalGroup.fromArrow
    (basepointConnector b x ≫ p ≫ Groupoid.inv (basepointConnector b y))))

theorem fundamentalCharacterArrowValue_comp
    (χ : Additive (FundamentalGroup X b) →+ ℤ)
    (p : FundamentalGroupoid.mk x ⟶ FundamentalGroupoid.mk y)
    (q : FundamentalGroupoid.mk y ⟶ FundamentalGroupoid.mk z) :
    fundamentalCharacterArrowValue χ (p ≫ q) =
      fundamentalCharacterArrowValue χ p + fundamentalCharacterArrowValue χ q := by
  have h : FundamentalGroup.fromArrow
      (basepointConnector b x ≫ (p ≫ q) ≫ Groupoid.inv (basepointConnector b z)) =
      FundamentalGroup.fromArrow
        (basepointConnector b y ≫ q ≫ Groupoid.inv (basepointConnector b z)) *
      FundamentalGroup.fromArrow
        (basepointConnector b x ≫ p ≫ Groupoid.inv (basepointConnector b y)) := by
    change basepointConnector b x ≫ (p ≫ q) ≫ Groupoid.inv (basepointConnector b z) =
      (basepointConnector b x ≫ p ≫ Groupoid.inv (basepointConnector b y)) ≫
        (basepointConnector b y ≫ q ≫ Groupoid.inv (basepointConnector b z))
    simp [Category.assoc]
  unfold fundamentalCharacterArrowValue
  rw [h]
  change χ (_ + _) = _
  rw [map_add]
  exact add_comm _ _

@[simp]
theorem fundamentalCharacterArrowValue_loop
    (χ : Additive (FundamentalGroup X b) →+ ℤ) (p : FundamentalGroup X b) :
    fundamentalCharacterArrowValue χ p.toArrow = χ (Additive.ofMul p) := by
  let c : FundamentalGroup X b := FundamentalGroup.fromArrow (basepointConnector b b)
  change χ (-Additive.ofMul c + Additive.ofMul p + Additive.ofMul c) = χ (Additive.ofMul p)
  simp only [map_add, map_neg]
  omega

/-- The value of an integer character on a path, with connectors to the
basepoint at its two endpoints. -/
def fundamentalCharacterPathValue (χ : Additive (FundamentalGroup X b) →+ ℤ)
    (p : Path x y) : ℤ :=
  fundamentalCharacterArrowValue χ (Path.Homotopic.Quotient.mk p)

theorem fundamentalCharacterPathValue_trans
    (χ : Additive (FundamentalGroup X b) →+ ℤ) (p : Path x y) (q : Path y z) :
    fundamentalCharacterPathValue χ (p.trans q) =
      fundamentalCharacterPathValue χ p + fundamentalCharacterPathValue χ q := by
  exact fundamentalCharacterArrowValue_comp χ
    (Path.Homotopic.Quotient.mk p) (Path.Homotopic.Quotient.mk q)

theorem fundamentalCharacterPathValue_homotopic
    (χ : Additive (FundamentalGroup X b) →+ ℤ) {p q : Path x y}
    (h : p.Homotopic q) :
    fundamentalCharacterPathValue χ p = fundamentalCharacterPathValue χ q := by
  exact congrArg (fundamentalCharacterArrowValue χ) (Path.Homotopic.Quotient.eq.mpr h)

@[simp]
theorem fundamentalCharacterPathValue_cast
    (χ : Additive (FundamentalGroup X b) →+ ℤ) (p : Path x y)
    {x' y' : X} (hx : x' = x) (hy : y' = y) :
    fundamentalCharacterPathValue χ (p.cast hx hy) = fundamentalCharacterPathValue χ p := by
  subst x'
  subst y'
  rfl

@[simp]
theorem fundamentalCharacterPathValue_loop
    (χ : Additive (FundamentalGroup X b) →+ ℤ) (p : Path b b) :
    fundamentalCharacterPathValue χ p =
      χ (Additive.ofMul (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk p))) :=
  fundamentalCharacterArrowValue_loop χ _

/-- Extend a fundamental group character to singular one-simplices using
the chosen connectors from the basepoint. -/
def singularCochainOfCharacter (χ : Additive (FundamentalGroup X b) →+ ℤ) :
    IntegralSingularCochain X 1 :=
  singularCochainOfSimplexFunction
    (fun σ => fundamentalCharacterPathValue χ (singularSimplexPath σ))

@[simp]
theorem singularCochainOfCharacter_pathEval
    (χ : Additive (FundamentalGroup X b) →+ ℤ) (p : Path x y) :
    singularCochainPathEval (singularCochainOfCharacter χ) p =
      fundamentalCharacterPathValue χ p := by
  simp [singularCochainPathEval, singularCochainOfCharacter,
    singularSimplexPath_pathSingularSimplex]

@[simp]
theorem singularCochainOfCharacter_loopEval
    (χ : Additive (FundamentalGroup X b) →+ ℤ) (p : Path b b) :
    singularCochainPathEval (singularCochainOfCharacter χ) p =
      χ (Additive.ofMul (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk p))) := by
  simp

/-- The character cochain is closed: the three edges of each singular
triangle satisfy the additive cocycle relation. -/
theorem singularCochainOfCharacter_coboundary_eq_zero
    (χ : Additive (FundamentalGroup X b) →+ ℤ) :
    singularCochainCoboundary (singularCochainOfCharacter χ) = 0 := by
  apply (singularCochainOfSimplexFunction_coboundary_eq_zero_iff _).mpr
  intro σ
  simp only [singularSimplexPath_face, fundamentalCharacterPathValue_cast]
  change fundamentalCharacterPathValue χ (singularSimplexEdge σ 1 2) -
    fundamentalCharacterPathValue χ (singularSimplexEdge σ 0 2) +
      fundamentalCharacterPathValue χ (singularSimplexEdge σ 0 1) = 0
  have h := fundamentalCharacterPathValue_homotopic χ (singularSimplexEdge_triangle σ)
  rw [fundamentalCharacterPathValue_trans] at h
  omega

/-- The singular cocycle constructed from an integer character of the
fundamental group of a path-connected space. -/
def singularCocycleOfCharacter (χ : Additive (FundamentalGroup X b) →+ ℤ) :
    IntegralSingularCocycle X 1 :=
  ⟨singularCochainOfCharacter χ, singularCochainOfCharacter_coboundary_eq_zero χ⟩

@[simp]
theorem singularCocycleOfCharacter_loopEval
    (χ : Additive (FundamentalGroup X b) →+ ℤ) (p : Path b b) :
    singularCochainPathEval (singularCocycleOfCharacter χ).1 p =
      χ (Additive.ofMul (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk p))) :=
  singularCochainOfCharacter_loopEval χ p

end Mumford.Analytic
