---
author: sync
content_type: theorem
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.divisorSections_add_nsmul_coordinateWeilDivisor_V1
docstring: 'Twisting by the coordinate divisor does not change sections over the inverse-coordinate

  chart.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateLattice.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.divisorSections_add_nsmul_coordinateWeilDivisor_V1
type: lean
updated: '2026-07-31T08:04:21'
---
theorem divisorSections_add_nsmul_coordinateWeilDivisor_V1 (A : Y.CurveDivisor) (n : ℕ) :
    divisorSections K (A + n • Q.coordinateWeilDivisor (K := K)) Q.V₁ =
      divisorSections K A Q.V₁ := by
  have hne : (Q.V₁ : Set Y).Nonempty := ⟨genericPoint Y, (Q.genericPoint_mem_inf).2⟩
  rw [divisorSections_of_nonempty K hne, divisorSections_of_nonempty K hne]
  have hbound : ∀ (x : Y) (hx : x ≠ genericPoint Y), x ∈ Q.V₁ →
      Scheme.divisorBound (A + n • Q.coordinateWeilDivisor (K := K)) hx =
        Scheme.divisorBound A hx :=
    fun x hx hxV1 => divisorBound_congr hx (coeffAt_add_nsmul_of_mem_V1 Q A n hx hxV1)
  refine Submodule.ext (fun g => ?_)
  rw [mem_boundedSections, mem_boundedSections]
  constructor
  · intro h x hx hxU
    rw [← hbound x hx hxU]
    exact h x hx hxU
  · intro h x hx hxU
    rw [hbound x hx hxU]
    exact h x hx hxU