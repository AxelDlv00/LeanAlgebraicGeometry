/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartAbelNonInjective
import AlgebraicJacobian.Picard.Pic0ChartForkNegativeBranch
import AlgebraicJacobian.Picard.Pic0ChartOpenImmersionCriterion
import AlgebraicJacobian.RiemannRoch.ChiCurve

/-!
# The high-degree Abel route guard

The unrestricted Abel map at degree `n > genus C` cannot be the open chart used by the
rank-one strategy. A degree-`n` point over any field extension has at least two sections by
Riemann's inequality. After replacing it by an effective divisor of the same class, the
existing field dictionary gives two distinct divisor families with the same chart value.

The field-extension divisor in the final theorem is the precise nonemptiness input. It cannot
be omitted: an empty source can map by an open immersion. Coverage arguments provide exactly
this input, so the guard applies to the old high-degree direct-Abel route without assuming a
rational point on the curve.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

section Abel

variable [IsAffineHom π]
variable {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
variable (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
variable (hdeg : Scheme.CurveDivisor.deg k Z
  = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))

/-- Noninjectivity of `chartValue` at one test refutes open immersion of the actual Abel
natural transformation. The proof keeps the structure-morphism component of `abelSigmaChart`;
it is not merely a statement about the Picard-class projection. -/
theorem not_isOpenImmersion_abelSigmaChart_of_not_injective_chartValue
    {T : Over (Spec (.of k))}
    (hnot : ¬ Function.Injective (chartValue C π n m Z T)) :
    ¬ IsOpenImmersion.presheaf (abelSigmaChart C π n rep m Z hdeg) := by
  intro hopen
  apply hnot
  intro s₁ s₂ hval
  by_contra hne
  exact (not_injective_abelSigmaChart_of_divFamZar rep m Z hdeg s₁ s₂ hne hval)
    (injective_of_isOpenImmersion_presheaf hopen (op T.left))

end Abel

section HighDegree

variable [IsFinite π]
variable {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
variable (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
variable (hdeg : Scheme.CurveDivisor.deg k Z
  = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))

/- The base-change instances are keyed on the product spelling. Keep these bridges local so the
public guard uses the canonical `relCurve` spelling without exporting overlapping instances. -/
local instance routeGuardIntegral {K : Type u} [Field K] [Algebra k K] :
    IsIntegral (relCurve C K) :=
  instIsIntegralBaseChange C K

local instance routeGuardSmooth {K : Type u} [Field K] [Algebra k K] :
    SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K)) :=
  instSmoothOfRelativeDimensionBaseChange C K

local instance routeGuardQuasiCompact {K : Type u} [Field K] [Algebra k K] :
    QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K)) :=
  instQuasiCompactBaseChange C K

local instance routeGuardH0Finite {K : Type u} [Field K] [Algebra k K] :
    Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 0) :=
  instModuleFiniteHModuleZeroBaseChange C K

local instance routeGuardH1Finite {K : Type u} [Field K] [Algebra k K] :
    Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 1) :=
  instModuleFiniteHModuleOneBaseChange C K

/-- **Root route guard.** If the degree-`n` divisor space has a point after a field extension
and `genus C < n`, the unrestricted degree-`n` Abel map is not an open immersion.

The proof uses `riemann_inequality` to obtain `h⁰ ≥ 2`, replaces the divisor by an
effective representative, and consumes `not_injective_chartValue_of_two_le_h0`. It is stronger
than the positive-genus form required by the review: no positivity hypothesis is needed. -/
theorem not_isOpenImmersion_abelSigmaChart_of_genus_lt_degree
    {K : Type u} [Field K] [Algebra k K]
    (W : (relCurve C K).CurveDivisor)
    (hdegW : Scheme.CurveDivisor.deg K W = (n : ℤ))
    (hng : genus C < n) :
    ¬ IsOpenImmersion.presheaf (abelSigmaChart C π n rep m Z hdeg) := by
  haveI : IsProper (baseChangeBundle C K).hom := instIsProperSndLeft C K
  haveI : SmoothOfRelativeDimension 1 (baseChangeBundle C K).hom :=
    instSmoothOfRelativeDimensionSndLeft C K
  haveI : GeometricallyIrreducible (baseChangeBundle C K).hom :=
    instGeometricallyIrreducibleSndLeft C K
  have hO : Sheaf.h0 ((relCurve C K).moduleKSheaf K) = 1 :=
    h0_moduleKSheaf (baseChangeBundle C K)
  have hchi : Sheaf.chi ((relCurve C K).moduleKSheaf K) = 1 - (genus C : ℤ) := by
    have h := chi_moduleKSheaf (baseChangeBundle C K)
    rw [genus_baseField C K] at h
    exact h
  have hh0z := riemann_inequality K W
  rw [hdegW, hchi] at hh0z
  have hh0W : 2 ≤ Sheaf.h0 ((relCurve C K).divisorSheaf K W) := by
    omega
  obtain ⟨A, hA, hdegA, hh0A, -⟩ :=
    exists_effective_deg_two_le_h0_of_two_le_h0 (C := C) (π := π) (n := n)
      W hdegW hh0W
  exact not_isOpenImmersion_abelSigmaChart_of_not_injective_chartValue rep m Z hdeg
    (not_injective_chartValue_of_two_le_h0 (C := C) (π := π) (n := n)
      hO A hA hdegA hh0A m Z)

end HighDegree

end

end AlgebraicGeometry
