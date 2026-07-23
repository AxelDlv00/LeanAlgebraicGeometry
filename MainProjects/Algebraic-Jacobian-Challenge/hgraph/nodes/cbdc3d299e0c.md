---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.localStepQuot_injective
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.localStepQuot_injective
type: lean
updated: '2026-07-24T03:02:13'
---
theorem localStepQuot_injective {U : X.Opens} {P : X.PrimeDivisor}
    (hPU : P.point ∈ U) {D D' : X.WeilDivisor}
    (hstep : (show X.PrimeDivisor →₀ ℤ from D') P =
      (show X.PrimeDivisor →₀ ℤ from D) P + 1)
    (hle : ∀ Q : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D) Q ≤
      (show X.PrimeDivisor →₀ ℤ from D') Q)
    (hoff : ∀ Q : X.PrimeDivisor, Q ≠ P →
      (show X.PrimeDivisor →₀ ℤ from D) Q = (show X.PrimeDivisor →₀ ℤ from D') Q) :
    Function.Injective (localStepQuot hPU hstep) := by
  rw [injective_iff_map_eq_zero]
  intro q
  induction q using QuotientAddGroup.induction_on with
  | H g =>
    intro hq
    simp only [localStepQuot, QuotientAddGroup.map_mk, QuotientAddGroup.eq_zero_iff,
      AddSubgroup.mem_addSubgroupOf, AddSubgroup.coe_inclusion] at hq
    rw [QuotientAddGroup.eq_zero_iff, AddSubgroup.mem_addSubgroupOf]
    have hmem : (g : X.functionField) ∈
        sectionOfDivisor U D' ⊓ orderGe P (-(show X.PrimeDivisor →₀ ℤ from D) P) :=
      AddSubgroup.mem_inf.mpr ⟨g.2, hq⟩
    rwa [← sectionOfDivisor_inf_orderGe hPU hle hoff] at hmem

end LocalStep

/-! ## §N14b. The residue-degree bound on the local step

The `LocalStep` section reduced the local step quotient to the single-point
valuation quotient `orderGe P m ⧸ orderGe P (m+1)` (with `m = -n-1`).  We now
identify this target with the residue field `κ(P)` of the DVR stalk `𝒪_P` and
read off the numerical bound `dim_k ≤ deg P = [κ(P) : k]`.

The DVR bridges below connect the additive order `ord_P = -log ∘ v_P` to
integrality in the stalk `𝒪_P = 𝒪_{X,P}`: a nonzero rational function has
nonnegative order at `P` exactly when it is a section of the stalk. -/

section LocalDegree

variable {X : Scheme.{u}} [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X]