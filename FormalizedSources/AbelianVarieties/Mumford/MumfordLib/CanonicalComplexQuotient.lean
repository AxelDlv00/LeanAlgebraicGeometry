/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.CompactKernelLattice

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

end Analytic
end Mumford
