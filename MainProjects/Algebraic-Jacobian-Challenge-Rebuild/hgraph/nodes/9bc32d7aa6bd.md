---
author: sync
content_type: theorem
created: '2026-08-04T14:08:52'
decl: AlgebraicGeometry.not_isOpenImmersion_abelSigmaChart_of_genus_lt_degree
docstring: '**Root route guard.** If the degree-`n` divisor space has a point after
  a field extension

  and `genus C < n`, the unrestricted degree-`n` Abel map is not an open immersion.


  The proof uses `riemann_inequality` to obtain `h⁰ ≥ 2`, replaces the divisor by
  an

  effective representative, and consumes `not_injective_chartValue_of_two_le_h0`.
  It is stronger

  than the positive-genus form required by the review: no positivity hypothesis is
  needed.'
file: AlgebraicJacobian/Picard/Pic0HighDegreeRouteGuard.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.not_isOpenImmersion_abelSigmaChart_of_genus_lt_degree
type: lean
updated: '2026-08-18T20:51:05'
---
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

include π