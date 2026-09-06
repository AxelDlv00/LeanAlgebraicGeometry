/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexExponentialAtlas
import Mathlib.Geometry.Manifold.Algebra.LieGroup

/-!
# Additive Lie-group structure on a lattice quotient

The explicit branch atlas on a full complex lattice quotient is compatible
with the quotient addition and negation maps.  These declarations are
model-level certificates conditional on `ComplexVectorLatticeExponentialData`;
they do not identify an external abelian variety with the quotient or assert
the source-level holomorphic uniformization theorem.
-/

set_option autoImplicit false

open Filter
open scoped Topology Manifold ContDiff

namespace Mumford
namespace Uniformization

noncomputable section

namespace ComplexVectorLatticeExponentialData

private theorem quotientBranch_mem_source_of_rep
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g)
    (v : V) (q : V ⧸ d.ambientPeriodLattice)
    (hq : QuotientAddGroup.mk' d.ambientPeriodLattice v = q) :
    q ∈ (d.quotientLocalBranchAt v).source := by
  rw [← hq]
  exact d.quotientLocalBranchAt_quotient_mk_mem_source v

private theorem quotientBranch_mk_add_eq_add
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g)
    (v w : V) {p q : V ⧸ d.ambientPeriodLattice}
    (hp : p ∈ (d.quotientLocalBranchAt v).source)
    (hq : q ∈ (d.quotientLocalBranchAt w).source) :
    (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
        (d.quotientLocalBranchAt v p + d.quotientLocalBranchAt w q) = p + q := by
  calc
    (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
        (d.quotientLocalBranchAt v p + d.quotientLocalBranchAt w q) =
        (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
          (d.quotientLocalBranchAt v p) +
          (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
            (d.quotientLocalBranchAt w q) :=
      QuotientAddGroup.mk_add d.ambientPeriodLattice _ _
    _ = p + q := by
      rw [d.quotient_mk_apply_quotientLocalBranchAt v hp,
        d.quotient_mk_apply_quotientLocalBranchAt w hq]

private theorem quotientBranch_mk_neg_eq_neg
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g)
    (v : V) {q : V ⧸ d.ambientPeriodLattice}
    (hq : q ∈ (d.quotientLocalBranchAt v).source) :
    (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
        (-d.quotientLocalBranchAt v q) = -q := by
  calc
    (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
        (-d.quotientLocalBranchAt v q) =
        -(QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
          (d.quotientLocalBranchAt v q) :=
      QuotientAddGroup.mk_neg d.ambientPeriodLattice _
    _ = -q := by
      rw [d.quotient_mk_apply_quotientLocalBranchAt v hq]

/-- Addition is analytic at every point of the explicit quotient atlas. -/
theorem analyticQuotient_contMDiff_add
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
      analyticQuotientChartedSpace d
    letI : IsManifold (𝓘(ℂ, V)) ω
        (V ⧸ d.ambientPeriodLattice) := by
      exact analyticQuotient_isManifold d
    ContMDiff (𝓘(ℂ, V).prod 𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (fun p : (V ⧸ d.ambientPeriodLattice) ×
          (V ⧸ d.ambientPeriodLattice) => p.1 + p.2) := by
  letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
    analyticQuotientChartedSpace d
  letI : IsManifold (𝓘(ℂ, V)) ω
      (V ⧸ d.ambientPeriodLattice) := by
    exact analyticQuotient_isManifold d
  intro p
  obtain ⟨v, hv⟩ := QuotientAddGroup.mk'_surjective
    d.ambientPeriodLattice p.1
  obtain ⟨w, hw⟩ := QuotientAddGroup.mk'_surjective
    d.ambientPeriodLattice p.2
  have hpv : p.1 ∈ (d.quotientLocalBranchAt v).source :=
    quotientBranch_mem_source_of_rep d v p.1 hv
  have hpw : p.2 ∈ (d.quotientLocalBranchAt w).source :=
    quotientBranch_mem_source_of_rep d w p.2 hw
  have hbv : ContMDiffAt (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (d.quotientLocalBranchAt v) p.1 := by
    apply contMDiffAt_of_mem_maximalAtlas
      (IsManifold.subset_maximalAtlas (I := 𝓘(ℂ, V))
        (n := ω) (M := V ⧸ d.ambientPeriodLattice) ⟨v, rfl⟩)
    exact hpv
  have hbw : ContMDiffAt (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (d.quotientLocalBranchAt w) p.2 := by
    apply contMDiffAt_of_mem_maximalAtlas
      (IsManifold.subset_maximalAtlas (I := 𝓘(ℂ, V))
        (n := ω) (M := V ⧸ d.ambientPeriodLattice) ⟨w, rfl⟩)
    exact hpw
  have hsum : ContMDiffAt (𝓘(ℂ, V).prod 𝓘(ℂ, V))
      (𝓘(ℂ, V)) ω
      (fun z : (V ⧸ d.ambientPeriodLattice) ×
        (V ⧸ d.ambientPeriodLattice) =>
        d.quotientLocalBranchAt v z.1 + d.quotientLocalBranchAt w z.2) p := by
    exact (contMDiff_add (𝓘(ℂ, V)) ω).contMDiffAt.comp₂
      (hbv.comp p contMDiffAt_fst)
      (hbw.comp p contMDiffAt_snd)
  have hmk : ContMDiffAt (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
      (d.quotientLocalBranchAt v p.1 + d.quotientLocalBranchAt w p.2) := by
    exact (analyticQuotient_mk_contMDiff d) _
  have hmodel : ContMDiffAt (𝓘(ℂ, V).prod 𝓘(ℂ, V))
      (𝓘(ℂ, V)) ω
      (fun z : (V ⧸ d.ambientPeriodLattice) ×
        (V ⧸ d.ambientPeriodLattice) =>
        (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
          (d.quotientLocalBranchAt v z.1 + d.quotientLocalBranchAt w z.2)) p := by
    exact hmk.comp p hsum
  apply hmodel.congr_of_eventuallyEq
  have hprod : (d.quotientLocalBranchAt v).source ×ˢ
      (d.quotientLocalBranchAt w).source ∈ 𝓝 p := by
    exact prod_mem_nhds
      ((d.quotientLocalBranchAt v).open_source.mem_nhds hpv)
      ((d.quotientLocalBranchAt w).open_source.mem_nhds hpw)
  filter_upwards [hprod] with z hz
  exact (quotientBranch_mk_add_eq_add d v w hz.1 hz.2).symm

/-- Negation is analytic at every point of the explicit quotient atlas. -/
theorem analyticQuotient_contMDiff_neg
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
      analyticQuotientChartedSpace d
    letI : IsManifold (𝓘(ℂ, V)) ω
        (V ⧸ d.ambientPeriodLattice) := by
      exact analyticQuotient_isManifold d
    ContMDiff (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (fun q : V ⧸ d.ambientPeriodLattice => -q) := by
  letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
    analyticQuotientChartedSpace d
  letI : IsManifold (𝓘(ℂ, V)) ω
      (V ⧸ d.ambientPeriodLattice) := by
    exact analyticQuotient_isManifold d
  intro q
  obtain ⟨v, hv⟩ := QuotientAddGroup.mk'_surjective
    d.ambientPeriodLattice q
  have hq : q ∈ (d.quotientLocalBranchAt v).source :=
    quotientBranch_mem_source_of_rep d v q hv
  have hb : ContMDiffAt (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (d.quotientLocalBranchAt v) q := by
    apply contMDiffAt_of_mem_maximalAtlas
      (IsManifold.subset_maximalAtlas (I := 𝓘(ℂ, V))
        (n := ω) (M := V ⧸ d.ambientPeriodLattice) ⟨v, rfl⟩)
    exact hq
  have hmk : ContMDiffAt (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
      (-d.quotientLocalBranchAt v q) := by
    exact (analyticQuotient_mk_contMDiff d) _
  have hmodel : ContMDiffAt (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω
      (fun z : V ⧸ d.ambientPeriodLattice =>
        (QuotientAddGroup.mk : V → V ⧸ d.ambientPeriodLattice)
          (-d.quotientLocalBranchAt v z)) q := by
    exact hmk.comp q ((contMDiff_neg (𝓘(ℂ, V)) ω).contMDiffAt.comp q hb)
  apply hmodel.congr_of_eventuallyEq
  have hopen : (d.quotientLocalBranchAt v).source ∈ 𝓝 q :=
    (d.quotientLocalBranchAt v).open_source.mem_nhds hq
  filter_upwards [hopen] with z hz
  exact (quotientBranch_mk_neg_eq_neg d v hz).symm

/-- The explicit quotient atlas carries a conditional analytic Lie-additive
group certificate.  It is a value rather than a global instance, so callers
must choose the quotient charted space explicitly. -/
@[reducible]
noncomputable def analyticQuotientLieAddGroup
    {V X : Type*} [NormedAddCommGroup V] [NormedSpace ℂ V]
    [AddCommGroup X] [TopologicalSpace X] {g : ℕ}
    (d : ComplexVectorLatticeExponentialData V X g) :
    letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
      analyticQuotientChartedSpace d
    LieAddGroup (𝓘(ℂ, V)) ω (V ⧸ d.ambientPeriodLattice) := by
  letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
    analyticQuotientChartedSpace d
  letI : IsManifold (𝓘(ℂ, V)) ω
      (V ⧸ d.ambientPeriodLattice) := by
    exact analyticQuotient_isManifold d
  exact {
    contMDiff_add := analyticQuotient_contMDiff_add d
    contMDiff_neg := analyticQuotient_contMDiff_neg d }

end ComplexVectorLatticeExponentialData

end
end Uniformization
end Mumford
