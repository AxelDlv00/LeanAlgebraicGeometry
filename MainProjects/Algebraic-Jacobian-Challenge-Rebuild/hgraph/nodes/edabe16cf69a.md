---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.Scheme.zero_le_coeffAt_presentationDivisor
docstring: '**Effectivity of the presentation divisor.** Each anchor equation of a
  local-equation

  system is a genuine section of the structure sheaf near the closed point `x`, hence
  integral at

  `x` (order `≤ 1`), so its order of vanishing is nonnegative: the divisor of a local-equation

  system is effective.'
file: AlgebraicJacobian/Picard/DivisorFamilyField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.zero_le_coeffAt_presentationDivisor
type: lean
updated: '2026-07-31T20:15:24'
---
theorem zero_le_coeffAt_presentationDivisor (E : X.LocalEquations) {x : X}
    (hx : x ≠ genericPoint X) :
    0 ≤ coeffAt hx (presentationDivisor K E.presentation) := by
  rw [coeffAt_presentationDivisor]
  -- the trivializing element is integral at `x`
  have hval : (E.presentation.elem x : X.functionField)
      = algebraMap (X.presheaf.stalk x) X.functionField
          ((X.presheaf.germ (E.cover.opens x) x (E.cover.mem_opens x)).hom (E.eqn x)) := by
    rw [LocalEquations.presentation_elem_val]
    exact germ_generic_eq_algebraMap_germ (E.cover.genericPoint_mem_opens x)
      (E.cover.mem_opens x) (E.eqn x)
  have hord : Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx
      (E.presentation.elem x : X.functionField) ≤ 1 := by
    rw [hval]; exact ord_algebraMap_stalk_le_one K hx _
  -- `ord ≤ 1` ⟺ `1 ≤ ordZ` ⟺ `0 ≤ toAdd (ordZ)`
  rw [ord_val_eq_ordZ K (E.presentation.elem x) hx] at hord
  rw [show (1 : WithZero (Multiplicative ℤ)) = ((1 : Multiplicative ℤ) : WithZero _) from rfl,
    WithZero.coe_le_coe] at hord
  have h1le : (1 : Multiplicative ℤ)
      ≤ Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hx (E.presentation.elem x) :=
    inv_le_one'.mp hord
  rw [show (0 : ℤ) = Multiplicative.toAdd (1 : Multiplicative ℤ) from rfl]
  exact h1le

end Scheme

/-! ## The forward map on `DivFam` over a field -/

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]
variable {π : C.left ⟶ P1 k} [IsAffineHom π]
variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
variable {n : ℕ}