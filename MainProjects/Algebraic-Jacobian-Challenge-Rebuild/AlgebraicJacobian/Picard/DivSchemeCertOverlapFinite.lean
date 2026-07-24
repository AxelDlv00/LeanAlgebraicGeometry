/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.SupportTubeFinite
import AlgebraicJacobian.Picard.DivisorThetaDatum
import AlgebraicJacobian.Picard.DivisorFamilyPullbackOverlap

/-!
# Finiteness of adaptation overlap colengths

If the support traces on adaptation pieces do not leak, then the trace on a pairwise
overlap is the intersection of two closed traces.  The overlap ideal is principal by
`DivisorAdaptation.ovlIdeal_eq_span_left`, so the proper affine finiteness engine applies
to every overlap colength and hence to their finite product.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom]
variable {R : Type u} [CommRing R] [Algebra k R]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

namespace DivisorAdaptation

variable {d : (relCurve C R).LocalEquations}
variable (A : DivisorAdaptation C R pi d)

set_option maxHeartbeats 800000 in
-- Normalizing the dependent overlap section ring requires the larger elaboration budget.
/-- Closed support traces on two pieces make their overlap colength finite over the
base. -/
theorem finite_ovlColength_of_isClosed_supportLocus_inter (i j : A.index)
    (hi : IsClosed (d.supportLocus ∩ (A.pieces i : Set (relCurve C R))))
    (hj : IsClosed (d.supportLocus ∩ (A.pieces j : Set (relCurve C R)))) :
    Module.Finite R (A.ovlColength i j) := by
  let V : (relCurve C R).Opens := A.pieces i ⊓ A.pieces j
  let f : Γ(relCurve C R, V) :=
    (relCurve C R).resHom
      (inf_le_left : A.pieces i ⊓ A.pieces j ≤ A.pieces i) (A.eqn i)
  have hclosed : IsClosed ((V : Set (relCurve C R)) \
      ((relCurve C R).basicOpen f : Set (relCurve C R))) := by
    have heq : ((V : Set (relCurve C R)) \
          ((relCurve C R).basicOpen f : Set (relCurve C R))) =
        (d.supportLocus ∩ (A.pieces i : Set (relCurve C R))) ∩
          (d.supportLocus ∩ (A.pieces j : Set (relCurve C R))) := by
      rw [show (relCurve C R).basicOpen f =
        V ⊓ (relCurve C R).basicOpen (A.eqn i) from
          Scheme.basicOpen_resHom inf_le_left (A.eqn i)]
      ext x
      have htrace := Set.ext_iff.mp (A.supportLocus_inter_pieces i) x
      simp only [Set.mem_sdiff, SetLike.mem_coe, Opens.mem_inf, Set.mem_inter_iff] at htrace ⊢
      constructor
      · rintro ⟨hxV, hxnot⟩
        have hsi : x ∈ d.supportLocus ∩ (A.pieces i : Set (relCurve C R)) :=
          htrace.mpr ⟨hxV.1, fun hxi => hxnot ⟨hxV, hxi⟩⟩
        exact ⟨hsi, hsi.1, hxV.2⟩
      · rintro ⟨hsi, _, hxj⟩
        have hdiff := htrace.mp hsi
        exact ⟨⟨hsi.2, hxj⟩, fun hx => hdiff.2 hx.2⟩
    rw [heq]
    exact hi.inter hj
  have hVaff : IsAffineOpen V := by
    rw [show V = (relCurve C R).basicOpen (A.toFinCoverData.ovlGen i j) from
      (A.toFinCoverData.basicOpen_ovlGen i j).symm]
    exact (A.toFinCoverData.isAffineOpen_preimage_chart_inf R i j).basicOpen _
  have hfin := hVaff.finite_quotient_span_singleton_of_isClosed (R := R) f hclosed
  have hideal := A.ovlIdeal_eq_span_left i j
  change A.ovlIdeal i j = Ideal.span {f} at hideal
  letI : Module.Finite R (Γ(relCurve C R, V) ⧸ Ideal.span {f}) := hfin
  exact Module.Finite.equiv
    ((Submodule.quotEquivOfEq _ _ hideal).symm.restrictScalars R)

/-- Fibrewise no-leak on the two pieces makes their overlap colength finite. -/
theorem finite_ovlColength_of_forall_fibre_closure_subset (i j : A.index)
    (hnoLeak : forall (l : A.index) (s : Spec (CommRingCat.of R)),
      ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces l : Set (relCurve C R)))
        ⊆ (A.pieces l : Set (relCurve C R))) :
    Module.Finite R (A.ovlColength i j) := by
  apply A.finite_ovlColength_of_isClosed_supportLocus_inter i j
  · exact (d.isClosed_supportLocus_inter_iff_supportLeak_eq_empty (A.pieces i)).mpr
      (d.supportLeak_eq_empty_of_forall_fibre
        ((relCurve C R) ↘ Spec (CommRingCat.of R)) (hnoLeak i))
  · exact (d.isClosed_supportLocus_inter_iff_supportLeak_eq_empty (A.pieces j)).mpr
      (d.supportLeak_eq_empty_of_forall_fibre
        ((relCurve C R) ↘ Spec (CommRingCat.of R)) (hnoLeak j))

/-- Fibrewise no-leak on every adaptation piece makes the finite product of all overlap
colengths finite over the base. -/
theorem finite_ovlProd_of_noLeak
    (hnoLeak : forall (j : A.index) (s : Spec (CommRingCat.of R)),
      ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces j : Set (relCurve C R)))
        ⊆ (A.pieces j : Set (relCurve C R))) :
    Module.Finite R A.ovlProd := by
  letI : forall p : A.index × A.index, Module.Finite R (A.ovlColength p.1 p.2) :=
    fun p => A.finite_ovlColength_of_forall_fibre_closure_subset p.1 p.2 hnoLeak
  exact Module.Finite.pi

end DivisorAdaptation

end AlgebraicGeometry
