/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.SectionsToDivisorsClass
import AlgebraicJacobian.Picard.LocalGenerators
import AlgebraicJacobian.Picard.DivisorFamilyAffAssemble

set_option autoImplicit false

universe u

open CategoryTheory TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule

namespace BasicOpenCocycleDatum

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

/-- Fibrewise injectivity of multiplication by a datum component gives the ring-theoretic
nonzerodivisor condition on its pure tensor. -/
theorem component_tmul_one_mem_nonZeroDivisors
    (D : BasicOpenCocycleDatum C B pi)
    (s : ↥(gluedSubmodule B D.pieces D.unit ⊤))
    (hfib : ∀ (j : D.index) (p : PrimeSpectrum B), Function.Injective
      ((Scheme.mulSectionEnd B (D.component s j)).rTensor p.asIdeal.ResidueField))
    (j : D.index) (p : PrimeSpectrum B) :
    letI : Algebra B Γ(relCurve C B, D.pieces j) :=
      ((relCurve C B).overAlgebraMap B (D.pieces j)).toAlgebra
    (D.component s j ⊗ₜ[B] (1 : p.asIdeal.ResidueField) :
      Γ(relCurve C B, D.pieces j) ⊗[B] p.asIdeal.ResidueField) ∈
        nonZeroDivisors
          (Γ(relCurve C B, D.pieces j) ⊗[B] p.asIdeal.ResidueField) := by
  letI : Algebra B Γ(relCurve C B, D.pieces j) :=
    ((relCurve C B).overAlgebraMap B (D.pieces j)).toAlgebra
  have hend : Scheme.mulSectionEnd B (D.component s j) =
      LinearMap.mulLeft B (D.component s j) := by
    ext t
    simp [Scheme.mulSectionEnd_apply]
  have hinj := hfib j p
  rw [hend, rTensor_mulLeft_eq_mulLeft_tmul p.asIdeal.ResidueField
    (D.component s j)] at hinj
  rw [mem_nonZeroDivisors_iff]
  constructor
  · intro z hz
    apply hinj
    rw [LinearMap.mulLeft_apply, LinearMap.mulLeft_apply, mul_zero]
    exact hz
  · intro z hz
    apply hinj
    rw [LinearMap.mulLeft_apply, LinearMap.mulLeft_apply, mul_zero, mul_comm]
    exact hz

end BasicOpenCocycleDatum

end AlgebraicGeometry
