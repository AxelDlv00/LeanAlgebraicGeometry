/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.CompactKernelLattice
import Mathlib.Topology.IsLocalHomeomorph

/-!
# The canonical candidate quotient

This file packages the quotient of the tangent model by the kernel of the
canonical real-flow exponential candidate.  The resulting equivalence is an
additive and topological certificate only.  It does not identify the candidate
with Mumford's source-level holomorphic exponential, nor does it supply a
complex-manifold or Lie-group structure on the quotient.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Topology Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [CommGroup G]
  [LieGroup I ω G]
  [CompleteSpace E] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

/-- The additive quotient certificate carried by the canonical real-flow
exponential candidate and its named integral period lattice.

This is a model-level certificate: its exponential is the canonical candidate
constructed from real integral curves, not a source-level holomorphic
uniformization theorem.
-/
def canonicalComplexExponentialPeriodLatticeQuotient :
    Uniformization.PeriodLatticeQuotient E (Additive G) where
  periodLattice :=
    (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup
  exponential := canonicalComplexExponentialAddHom (G := G) I
  exponential_surjective :=
    canonicalComplexExponentialAddHom_surjective (G := G) I
  kernel_exponential := by
    change (canonicalComplexExponentialAddHom (G := G) I).ker =
      (AddSubgroup.toIntSubmodule
        (canonicalComplexExponentialAddHom (G := G) I).ker).toAddSubgroup
    exact (AddSubgroup.toIntSubmodule_toAddSubgroup
      ((canonicalComplexExponentialAddHom (G := G) I).ker)).symm

/-- The lattice quotient is homeomorphic to `Additive G` through the canonical
real-flow exponential candidate.
-/
noncomputable def canonicalComplexExponentialQuotientHomeomorph :
    E ⧸
        (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup
      ≃ₜ Additive G :=
  (canonicalComplexExponentialPeriodLatticeQuotient (G := G) I).quotientHomeomorph
    (canonicalComplexExponential_isOpenQuotientMap (G := G) I)

@[simp]
theorem canonicalComplexExponentialQuotientHomeomorph_mk (v : E) :
    canonicalComplexExponentialQuotientHomeomorph (G := G) I
        (QuotientAddGroup.mk'
          (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v) =
      Additive.ofMul (canonicalComplexExponential (G := G) I v) := by
  exact Uniformization.PeriodLatticeQuotient.quotientHomeomorph_mk
    (canonicalComplexExponentialPeriodLatticeQuotient (G := G) I)
    (canonicalComplexExponential_isOpenQuotientMap (G := G) I) v

/- The quotient relation is exactly the equality relation induced by the
   canonical exponential.  This representative criterion is used when
   passing between local branches and the global lattice quotient. -/
theorem canonicalComplexExponentialQuotient_mk_eq_mk_iff (v w : E) :
    QuotientAddGroup.mk'
        (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v =
      QuotientAddGroup.mk'
        (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup w ↔
      canonicalComplexExponential (G := G) I v =
        canonicalComplexExponential (G := G) I w := by
  change (↑v : E ⧸
      (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup) =
      (↑w : E ⧸
        (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup) ↔ _
  rw [QuotientAddGroup.eq_iff_sub_mem]
  rw [canonicalComplexExponentialPeriodLattice_toAddSubgroup (G := G) I]
  rw [AddMonoidHom.mem_ker]
  change canonicalComplexExponentialAddHom (G := G) I (v - w) = 0 ↔ _
  rw [map_sub]
  constructor
  · intro h
    have hmul :
        Additive.ofMul (canonicalComplexExponential (G := G) I v) -
            Additive.ofMul (canonicalComplexExponential (G := G) I w) = 0 := by
      simpa [canonicalComplexExponentialAddHom_apply] using h
    have hmul' :
        Additive.ofMul (canonicalComplexExponential (G := G) I v) =
            Additive.ofMul (canonicalComplexExponential (G := G) I w) :=
      sub_eq_zero.mp hmul
    exact Additive.ofMul.injective hmul'
  · intro h
    change Additive.ofMul (canonicalComplexExponential (G := G) I v) -
      Additive.ofMul (canonicalComplexExponential (G := G) I w) = 0
    rw [h]
    exact sub_self _

/-! The local-homeomorphism bridge gives canonical inverse branches on the
    additive target.  These are topological model-level branches, not the
    holomorphic charts of the source uniformization theorem. -/

/-- A chosen local inverse branch of the canonical additive exponential at a
given tangent representative. -/
noncomputable def canonicalComplexExponentialAddHomBranchAt (x : E) :
    OpenPartialHomeomorph (Additive G) E :=
  (canonicalComplexExponentialAddHom_isLocalHomeomorph (G := G) I).localInverseAt x

@[simp]
theorem canonicalComplexExponentialAddHomBranchAt_apply (x : E) :
    canonicalComplexExponentialAddHomBranchAt (G := G) I x
        (canonicalComplexExponentialAddHom (G := G) I x) = x :=
  IsLocalHomeomorph.localInverseAt_apply_self
    (canonicalComplexExponentialAddHom_isLocalHomeomorph (G := G) I)

theorem canonicalComplexExponentialAddHomBranchAt_symm (x : E) :
    ((canonicalComplexExponentialAddHomBranchAt (G := G) I x).symm :
      E → Additive G) =
      canonicalComplexExponentialAddHom (G := G) I :=
  IsLocalHomeomorph.localInverseAt_symm
    (canonicalComplexExponentialAddHom_isLocalHomeomorph (G := G) I) x

theorem canonicalComplexExponentialAddHomBranchAt_source_mem (x : E) :
    canonicalComplexExponentialAddHom (G := G) I x ∈
      (canonicalComplexExponentialAddHomBranchAt (G := G) I x).source :=
  IsLocalHomeomorph.apply_self_mem_localInverseAt_source
    (canonicalComplexExponentialAddHom_isLocalHomeomorph (G := G) I)

theorem canonicalComplexExponentialAddHomBranchAt_apply_of_mem
    (x : E) {y : Additive G}
    (hy : y ∈ (canonicalComplexExponentialAddHomBranchAt (G := G) I x).source) :
    canonicalComplexExponentialAddHom (G := G) I
        (canonicalComplexExponentialAddHomBranchAt (G := G) I x y) = y := by
  exact IsLocalHomeomorph.apply_localInverseAt_of_mem
    (canonicalComplexExponentialAddHom_isLocalHomeomorph (G := G) I) hy

theorem canonicalComplexExponentialAddHomBranchAt_source_iUnion_eq_univ :
    (⋃ x : E,
      (canonicalComplexExponentialAddHomBranchAt (G := G) I x).source) =
      Set.univ := by
  apply Set.eq_univ_of_forall
  intro y
  obtain ⟨x, hx⟩ :=
    canonicalComplexExponentialAddHom_surjective (G := G) I y
  refine Set.mem_iUnion.2 ⟨x, ?_⟩
  rw [← hx]
  exact canonicalComplexExponentialAddHomBranchAt_source_mem (G := G) I x

/-- The topological quotient map has the same underlying function as the
algebraic first-isomorphism equivalence. -/
theorem canonicalComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv
    (q : E ⧸
      (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup) :
    canonicalComplexExponentialQuotientHomeomorph (G := G) I q =
      (canonicalComplexExponentialPeriodLatticeQuotient (G := G) I).quotientAddEquiv q := by
  refine QuotientAddGroup.induction_on q ?_
  intro v
  change canonicalComplexExponentialQuotientHomeomorph (G := G) I
      (QuotientAddGroup.mk'
        (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v) =
    (canonicalComplexExponentialPeriodLatticeQuotient (G := G) I).quotientAddEquiv
      (QuotientAddGroup.mk'
        (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v)
  rw [canonicalComplexExponentialQuotientHomeomorph_mk]
  exact Uniformization.PeriodLatticeQuotient.quotientAddEquiv_mk
    (canonicalComplexExponentialPeriodLatticeQuotient (G := G) I) v

/-- The canonical candidate identifies its lattice quotient with `Additive G`
as a continuous additive equivalence.  This remains a model-level
topological statement, separate from source holomorphic uniformization.
-/
noncomputable def canonicalComplexExponentialQuotientContinuousAddEquiv :
    (E ⧸
        (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup)
      ≃ₜ+ Additive G := by
  apply ContinuousAddEquiv.mk'
    (canonicalComplexExponentialQuotientHomeomorph (G := G) I)
  intro q r
  rw [canonicalComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv,
    canonicalComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv,
    canonicalComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv]
  exact
    (canonicalComplexExponentialPeriodLatticeQuotient (G := G) I).quotientAddEquiv.map_add
      q r

@[simp]
theorem canonicalComplexExponentialQuotientContinuousAddEquiv_apply
    (q : E ⧸
      (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup) :
    canonicalComplexExponentialQuotientContinuousAddEquiv (G := G) I q =
      canonicalComplexExponentialQuotientHomeomorph (G := G) I q :=
  rfl

@[simp]
theorem canonicalComplexExponentialQuotientContinuousAddEquiv_mk (v : E) :
    canonicalComplexExponentialQuotientContinuousAddEquiv (G := G) I
        (QuotientAddGroup.mk'
          (canonicalComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v) =
      Additive.ofMul (canonicalComplexExponential (G := G) I v) := by
  rw [canonicalComplexExponentialQuotientContinuousAddEquiv_apply]
  exact canonicalComplexExponentialQuotientHomeomorph_mk (G := G) I v

/-! ### Intrinsic tangent-fibre transport

The following declarations expose the same candidate in the identity tangent
fibre `GroupLieAlgebra I G`.  `complexLieAlgebraEquiv` is only an
identity-on-vectors representation bridge, so these are additive and
topological consequences of the model-level candidate.  They do not provide a
source-level holomorphic exponential, a quotient complex-manifold structure,
or a global normed structure on the intrinsic tangent fibre.
-/

/-- The canonical real-flow exponential candidate with an intrinsic tangent
parameter. -/
def intrinsicComplexExponential : GroupLieAlgebra I G → G :=
  fun v => canonicalComplexExponential (G := G) I
    ((complexLieAlgebraEquiv (G := G) I).symm v)

/-- Additive-target presentation of the intrinsic candidate. -/
def intrinsicComplexExponentialAddHom :
    GroupLieAlgebra I G →+ Additive G :=
  (canonicalComplexExponentialAddHom (G := G) I).comp
    (((complexLieAlgebraEquiv (G := G) I).symm.restrictScalars ℤ).toAddMonoidHom)

@[simp]
theorem intrinsicComplexExponentialAddHom_apply (v : GroupLieAlgebra I G) :
    intrinsicComplexExponentialAddHom (G := G) I v =
      Additive.ofMul (intrinsicComplexExponential (G := G) I v) := rfl

@[simp]
theorem intrinsicComplexExponential_zero :
    intrinsicComplexExponential (G := G) I 0 = 1 := by
  unfold intrinsicComplexExponential
  rw [(complexLieAlgebraEquiv (G := G) I).symm.map_zero]
  exact canonicalComplexExponential_zero (G := G) I

theorem intrinsicComplexExponential_add (v w : GroupLieAlgebra I G) :
    intrinsicComplexExponential (G := G) I (v + w) =
      intrinsicComplexExponential (G := G) I v *
        intrinsicComplexExponential (G := G) I w := by
  unfold intrinsicComplexExponential
  rw [(complexLieAlgebraEquiv (G := G) I).symm.map_add]
  exact canonicalComplexExponential_add (G := G) I _ _

theorem intrinsicComplexExponential_neg (v : GroupLieAlgebra I G) :
    intrinsicComplexExponential (G := G) I (-v) =
      (intrinsicComplexExponential (G := G) I v)⁻¹ := by
  unfold intrinsicComplexExponential
  have hneg :
      (complexLieAlgebraEquiv (G := G) I).symm (-v) =
        -((complexLieAlgebraEquiv (G := G) I).symm v) :=
    (complexLieAlgebraEquiv (G := G) I).symm.map_neg v
  rw [hneg]
  exact canonicalComplexExponential_neg (G := G) I
    ((complexLieAlgebraEquiv (G := G) I).symm v)

theorem intrinsicComplexExponential_surjective :
    Function.Surjective (intrinsicComplexExponential (G := G) I) := by
  intro x
  obtain ⟨v, hv⟩ :=
    canonicalComplexExponential_surjective (G := G) I x
  refine ⟨complexLieAlgebraEquiv (G := G) I v, ?_⟩
  change canonicalComplexExponential (G := G) I
    ((complexLieAlgebraEquiv (G := G) I).symm
      (complexLieAlgebraEquiv (G := G) I v)) = x
  simpa using hv

theorem intrinsicComplexExponentialAddHom_surjective :
    Function.Surjective (intrinsicComplexExponentialAddHom (G := G) I) := by
  intro x
  obtain ⟨v, hv⟩ :=
    canonicalComplexExponentialAddHom_surjective (G := G) I x
  refine ⟨complexLieAlgebraEquiv (G := G) I v, ?_⟩
  change Additive.ofMul
    (canonicalComplexExponential (G := G) I
      ((complexLieAlgebraEquiv (G := G) I).symm
        (complexLieAlgebraEquiv (G := G) I v))) = x
  simpa using hv

theorem intrinsicComplexExponentialAddHom_continuous :
    Continuous (intrinsicComplexExponentialAddHom (G := G) I) := by
  apply (canonicalComplexExponentialAddHom_continuous (G := G) I).comp
  change Continuous ((complexLieAlgebraEquiv (G := G) I).symm :
    GroupLieAlgebra I G → E)
  exact continuous_id

/-- Period kernel of the intrinsic candidate, in its integral-submodule form. -/
def intrinsicComplexExponentialPeriodLattice :
    Submodule ℤ (GroupLieAlgebra I G) :=
  AddSubgroup.toIntSubmodule
    (intrinsicComplexExponentialAddHom (G := G) I).ker

theorem intrinsicComplexExponentialPeriodLattice_comap :
    intrinsicComplexExponentialPeriodLattice (G := G) I =
      (canonicalComplexExponentialPeriodLattice (G := G) I).comap
        ((complexLieAlgebraEquiv (G := G) I).symm.restrictScalars ℤ).toLinearMap := by
  ext v
  change intrinsicComplexExponentialAddHom (G := G) I v = 0 ↔ _
  rw [← AddMonoidHom.mem_ker]
  change Additive.ofMul (canonicalComplexExponential (G := G) I
      ((complexLieAlgebraEquiv (G := G) I).symm v)) = 0 ↔ _
  change canonicalComplexExponential (G := G) I
      ((complexLieAlgebraEquiv (G := G) I).symm v) = 1 ↔ _
  change ((complexLieAlgebraEquiv (G := G) I).symm v) ∈
      canonicalComplexExponentialPeriodLattice (G := G) I ↔ _
  rfl

theorem intrinsicComplexExponential_eq_one_iff_mem_periodLattice
    (v : GroupLieAlgebra I G) :
    intrinsicComplexExponential (G := G) I v = 1 ↔
      v ∈ intrinsicComplexExponentialPeriodLattice (G := G) I := by
  change intrinsicComplexExponentialAddHom (G := G) I v = 0 ↔ _
  rw [← AddMonoidHom.mem_ker]
  rfl

theorem intrinsicComplexExponentialPeriodLattice_discreteTopology :
    DiscreteTopology (intrinsicComplexExponentialPeriodLattice (G := G) I) := by
  rw [intrinsicComplexExponentialPeriodLattice_comap (G := G) I]
  letI : DiscreteTopology (canonicalComplexExponentialPeriodLattice (G := G) I) :=
    canonicalComplexExponentialPeriodLattice_discreteTopology (G := G) I
  apply DiscreteTopology.preimage_of_continuous_injective
    (canonicalComplexExponentialPeriodLattice (G := G) I : Set E)
  · change Continuous ((complexLieAlgebraEquiv (G := G) I).symm :
      GroupLieAlgebra I G → E)
    exact continuous_id
  · exact (complexLieAlgebraEquiv (G := G) I).symm.injective

theorem intrinsicComplexExponentialPeriodLattice_span_eq_top :
    Submodule.span ℝ
        (intrinsicComplexExponentialPeriodLattice (G := G) I :
          Set (GroupLieAlgebra I G)) =
      (⊤ : Submodule ℝ (GroupLieAlgebra I G)) := by
  rw [intrinsicComplexExponentialPeriodLattice_comap (G := G) I]
  let L : Submodule ℤ E := canonicalComplexExponentialPeriodLattice (G := G) I
  let f : GroupLieAlgebra I G →ₗ[ℝ] E :=
    (complexLieAlgebraEquiv (G := G) I).symm.restrictScalars ℝ
  have hnonempty : (L : Set E).Nonempty := ⟨0, L.zero_mem⟩
  have hsubset : (L : Set E) ⊆ LinearMap.range f := by
    intro x hx
    refine ⟨complexLieAlgebraEquiv (G := G) I x, ?_⟩
    simp [f]
  have hspan :
      Submodule.span ℝ (f ⁻¹' (L : Set E)) =
        Submodule.comap f (Submodule.span ℝ (L : Set E)) :=
    Submodule.span_preimage_eq hnonempty hsubset
  change Submodule.span ℝ (f ⁻¹' (L : Set E)) =
    (⊤ : Submodule ℝ (GroupLieAlgebra I G))
  rw [hspan]
  have htop : Submodule.span ℝ (L : Set E) = (⊤ : Submodule ℝ E) :=
    (canonicalComplexExponentialPeriodLattice_isZLattice (G := G) I).span_top
  rw [htop]
  exact Submodule.comap_top (f := f)

/-- Topological identification of the intrinsic tangent fibre with the model
space.  This is the identity-on-vectors bridge used by the quotient proof. -/
def intrinsicComplexLieAlgebraHomeomorph :
    GroupLieAlgebra I G ≃ₜ E :=
  { toEquiv := (complexLieAlgebraEquiv (G := G) I).symm.toEquiv
    continuous_toFun := by
      change Continuous ((complexLieAlgebraEquiv (G := G) I).symm :
        GroupLieAlgebra I G → E)
      exact continuous_id
    continuous_invFun := by
      change Continuous ((complexLieAlgebraEquiv (G := G) I) :
        E → GroupLieAlgebra I G)
      exact continuous_id }

theorem intrinsicComplexExponentialAddHom_isOpenQuotientMap :
    IsOpenQuotientMap (intrinsicComplexExponentialAddHom (G := G) I) := by
  apply IsOpenQuotientMap.comp
    (canonicalComplexExponential_isOpenQuotientMap (G := G) I)
  exact (intrinsicComplexLieAlgebraHomeomorph (G := G) I).isOpenQuotientMap

/-- The intrinsic additive quotient certificate for the canonical candidate. -/
def intrinsicComplexExponentialPeriodLatticeQuotient :
    Uniformization.PeriodLatticeQuotient
      (GroupLieAlgebra I G) (Additive G) where
  periodLattice :=
    (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup
  exponential := intrinsicComplexExponentialAddHom (G := G) I
  exponential_surjective := intrinsicComplexExponentialAddHom_surjective (G := G) I
  kernel_exponential := by
    exact AddSubgroup.toIntSubmodule_toAddSubgroup _ |>.symm

noncomputable def intrinsicComplexExponentialQuotientHomeomorph :
    GroupLieAlgebra I G ⧸
        (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup
      ≃ₜ Additive G :=
  (intrinsicComplexExponentialPeriodLatticeQuotient (G := G) I).quotientHomeomorph
    (intrinsicComplexExponentialAddHom_isOpenQuotientMap (G := G) I)

@[simp]
theorem intrinsicComplexExponentialQuotientHomeomorph_mk
    (v : GroupLieAlgebra I G) :
    intrinsicComplexExponentialQuotientHomeomorph (G := G) I
        (QuotientAddGroup.mk'
          (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v) =
      intrinsicComplexExponentialAddHom (G := G) I v := by
  exact Uniformization.PeriodLatticeQuotient.quotientHomeomorph_mk
    (intrinsicComplexExponentialPeriodLatticeQuotient (G := G) I)
    (intrinsicComplexExponentialAddHom_isOpenQuotientMap (G := G) I) v

theorem intrinsicComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv
    (q : GroupLieAlgebra I G ⧸
      (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup) :
    intrinsicComplexExponentialQuotientHomeomorph (G := G) I q =
      (intrinsicComplexExponentialPeriodLatticeQuotient (G := G) I).quotientAddEquiv q := by
  refine QuotientAddGroup.induction_on q ?_
  intro v
  change intrinsicComplexExponentialQuotientHomeomorph (G := G) I
      (QuotientAddGroup.mk'
        (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v) =
    (intrinsicComplexExponentialPeriodLatticeQuotient (G := G) I).quotientAddEquiv
      (QuotientAddGroup.mk'
        (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v)
  rw [intrinsicComplexExponentialQuotientHomeomorph_mk]
  exact Uniformization.PeriodLatticeQuotient.quotientAddEquiv_mk
    (intrinsicComplexExponentialPeriodLatticeQuotient (G := G) I) v

noncomputable def intrinsicComplexExponentialQuotientContinuousAddEquiv :
    (GroupLieAlgebra I G ⧸
        (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup)
      ≃ₜ+ Additive G := by
  apply ContinuousAddEquiv.mk'
    (intrinsicComplexExponentialQuotientHomeomorph (G := G) I)
  intro q r
  rw [intrinsicComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv,
    intrinsicComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv,
    intrinsicComplexExponentialQuotientHomeomorph_eq_quotientAddEquiv]
  exact (intrinsicComplexExponentialPeriodLatticeQuotient (G := G) I).quotientAddEquiv.map_add q r

@[simp]
theorem intrinsicComplexExponentialQuotientContinuousAddEquiv_mk
    (v : GroupLieAlgebra I G) :
    intrinsicComplexExponentialQuotientContinuousAddEquiv (G := G) I
        (QuotientAddGroup.mk'
          (intrinsicComplexExponentialPeriodLattice (G := G) I).toAddSubgroup v) =
      intrinsicComplexExponentialAddHom (G := G) I v := by
  rw [intrinsicComplexExponentialQuotientContinuousAddEquiv]
  exact intrinsicComplexExponentialQuotientHomeomorph_mk (G := G) I v

end Analytic
end Mumford
