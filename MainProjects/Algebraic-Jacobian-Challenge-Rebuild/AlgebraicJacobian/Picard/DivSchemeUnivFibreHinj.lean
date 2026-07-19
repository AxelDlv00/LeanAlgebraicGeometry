/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeUnivFibreKerSpan

/-!
# G-4 — the induced-map fibre injectivity (`hinj`) and its span equivalence

The sound seed-close capstone `isGenerator_of_fibrewise_ker_span_of_field_vanishing`
(`Picard/DivSchemeSeedUnivClose.lean`) consumes the **span** clause

`hspan z p : ker (f_z ⊗ κ(p)) ≤ range ((ker f_z).subtype ⊗ κ(p))`,

`f_z = kColengthMap z ∘ K.subtype`.  The reduction lemma
`hspan_of_forall_liftQ_rTensor_injective` (`Picard/DivSchemeUnivFibreKerSpan.lean`)
produces `hspan` from the **induced-map fibre injectivity**

`hinj z p : Function.Injective ((L.liftQ f_z le_rfl) ⊗ κ(p))`,  `L = ker f_z`

— injectivity of the residue fibre of the injectivization `K ⧸ ker f_z → colength z`.

This file records the *converse* implication, so that `hinj` and `hspan` are
**equivalent** and either may discharge the capstone:

* `ThetaGeneratorSeed.liftQ_rTensor_injective_of_ker_rTensor_le` — `hspan ⟹ hinj`.

The genuine carve rank-`g` content (the proof of `hspan`/`hinj` at the universal seed
`seedUniv`, where the induced-map fibre kernel is trivial because the carve pins the fibre
rank exactly `g`) is the residual; see the seam machinery
`divUniversal_carve_residueField` (`Picard/DivSchemeFamilyUniv.lean`), the fibre-window
identification `divUniversalFibreKM_eq_span` (`Picard/DivSchemeSeedUnivRes.lean`), and the
base-change-kernel commutation `ker_baseChange_mkQ` (`Picard/DivCarveKit.lean`).
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] {a : ℕ}
variable {K : Submodule R (relThetaSections C R π a)}

namespace ThetaGeneratorSeed

variable (D : ThetaGeneratorSeed C R π a K)

/-! ## The `hspan ⟹ hinj` converse: `hinj` and `hspan` are equivalent -/

set_option maxHeartbeats 1600000 in
-- the heavy relCurve section-ring colength drives the `rTensor` factorisation defeq past
-- the default budget (matched to `hspan_of_forall_liftQ_rTensor_injective`)
set_option synthInstance.maxHeartbeats 400000 in
/-- **`hspan ⟹ hinj`**: the induced-map fibre injectivity `hinj` follows from the
fibrewise-kernel-spanning law `hspan`.  Together with the reduction
`hspan_of_forall_liftQ_rTensor_injective` (`hinj ⟹ hspan`) this shows `hinj` and `hspan`
are **equivalent** — either discharges the `hspan` clause of
`isGenerator_of_fibrewise_ker_span_of_field_vanishing`.

Proof: `f_z ⊗ κ = (f̄_z ⊗ κ) ∘ (mkQ ⊗ κ)` with `mkQ ⊗ κ` surjective, so any `w` in the
target with `(f̄_z ⊗ κ) w = 0` lifts to some `u` with `w = (mkQ ⊗ κ) u`; then
`(f_z ⊗ κ) u = 0`, so `u ∈ ker (f_z ⊗ κ) ≤ range (subtype ⊗ κ) = ker (mkQ ⊗ κ)`
(`rTensor_exact` on `ker f_z ↪ K ↠ K ⧸ ker f_z`), whence `w = (mkQ ⊗ κ) u = 0`. -/
theorem liftQ_rTensor_injective_of_ker_rTensor_le
    (hspan : ∀ (z : relCurve C R) (p : PrimeSpectrum R),
      LinearMap.ker (((D.kColengthMap z).comp K.subtype).rTensor p.asIdeal.ResidueField)
        ≤ LinearMap.range
          ((LinearMap.ker ((D.kColengthMap z).comp K.subtype)).subtype.rTensor
            p.asIdeal.ResidueField)) :
    ∀ (z : relCurve C R) (p : PrimeSpectrum R),
      Function.Injective
        (((LinearMap.ker ((D.kColengthMap z).comp K.subtype)).liftQ
            ((D.kColengthMap z).comp K.subtype) le_rfl).rTensor p.asIdeal.ResidueField) := by
  intro z p
  set f := (D.kColengthMap z).comp K.subtype with hf
  set L := LinearMap.ker f with hL
  have hcomp : f.rTensor p.asIdeal.ResidueField
      = (L.liftQ f le_rfl).rTensor p.asIdeal.ResidueField ∘ₗ
          L.mkQ.rTensor p.asIdeal.ResidueField := by
    rw [← LinearMap.rTensor_comp, Submodule.liftQ_mkQ]
  have hex := rTensor_exact (R := R) p.asIdeal.ResidueField
    (LinearMap.exact_subtype_mkQ L) (Submodule.mkQ_surjective L)
  rw [injective_iff_map_eq_zero]
  intro w hw
  obtain ⟨u, rfl⟩ := LinearMap.rTensor_surjective p.asIdeal.ResidueField
    (Submodule.mkQ_surjective L) w
  have hfu : f.rTensor p.asIdeal.ResidueField u = 0 := by
    rw [hcomp, LinearMap.comp_apply]; exact hw
  have hmem : u ∈ LinearMap.ker (f.rTensor p.asIdeal.ResidueField) :=
    LinearMap.mem_ker.mpr hfu
  have hu := hspan z p hmem
  rw [← LinearMap.exact_iff.mp hex, LinearMap.mem_ker] at hu
  exact hu

end ThetaGeneratorSeed

end AlgebraicGeometry
