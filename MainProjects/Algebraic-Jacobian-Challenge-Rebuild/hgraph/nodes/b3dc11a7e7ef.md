---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonalChart_inf_diagonalComplement
docstring: '**The overlap of the diagonal member with the off-diagonal member is the
  basic open of

  the diagonal equation**: `𝔇(U) ⊓ Δᶜ = D(diagonalChartEqn)`.  Set-theoretically,

  `Δ ∩ 𝔇(U) = V(diagonalChartEqn) ∩ 𝔇(U)` by the D3 display and `Hom.support_ker`,
  and

  passing to complements inside `𝔇(U)` gives the claim.  Consequence for B5''s cocycle:
  on

  this overlap the restricted diagonal equation is a unit

  (`RingedSpace.isUnit_res_basicOpen`), so the ratio against the off-diagonal equation
  `1`

  is a unit.'
file: AlgebraicJacobian/Curve/DiagonalChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.diagonalChart_inf_diagonalComplement
type: lean
updated: '2026-07-30T15:28:02'
---
theorem diagonalChart_inf_diagonalComplement (C : Over (Spec (.of k)))
    [IsSeparated C.hom] {U : C.left.Opens} (hU : IsAffineOpen U)
    [Algebra (Polynomial k) Γ(C.left, U)] [IsScalarTower k (Polynomial k) Γ(C.left, U)]
    (elift : Γ(C.left, U) ⊗[k] Γ(C.left, U))
    (hidem : IsIdempotentElem (AlgebraicJacobian.Diagonal.baseChange elift))
    (hgen : RingHom.ker
        (Algebra.TensorProduct.lmul' (R := Polynomial k) (S := Γ(C.left, U)))
      = Ideal.span {AlgebraicJacobian.Diagonal.baseChange elift}) :
    diagonalChart C hU elift ⊓ diagonalComplement C
      = (C ⊗ C).left.basicOpen (diagonalChartEqn C hU elift) := by
  have hsupp := ((diagonal C).left.ker).coe_support_inter
    ⟨diagonalChart C hU elift, isAffineOpen_diagonalChart C hU elift⟩
  rw [diagonal_ker_ideal_diagonalChart C hU elift hidem hgen, coe_support_ker_diagonal,
    Scheme.zeroLocus_span, Scheme.zeroLocus_singleton] at hsupp
  -- hsupp : Δ ∩ 𝔇(U) = (D(eqn))ᶜ ∩ 𝔇(U)  (as sets)
  ext z
  have h := Set.ext_iff.mp hsupp z
  simp only [Set.mem_inter_iff, Set.mem_compl_iff, SetLike.mem_coe] at h
  constructor
  · rintro ⟨hz𝔇, hzc⟩
    by_contra hnb
    exact (mem_diagonalComplement_iff C).mp hzc (h.mpr ⟨hnb, hz𝔇⟩).1
  · intro hzb
    have hz𝔇 : z ∈ diagonalChart C hU elift :=
      (C ⊗ C).left.basicOpen_le (diagonalChartEqn C hU elift) hzb
    exact ⟨hz𝔇, fun hzr => (h.mp ⟨hzr, hz𝔇⟩).1 hzb⟩