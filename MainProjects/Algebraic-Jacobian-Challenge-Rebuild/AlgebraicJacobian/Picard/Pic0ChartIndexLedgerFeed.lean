/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartIndexAdmissible
import AlgebraicJacobian.Picard.Pic0ChartCoverageThreshold

/-!
# The chart-index reduction reaches the coverage consumer — so the residue is ONE arithmetic fact

`Picard/Pic0ChartIndexAdmissible.lean` reduces the chart layer's `hdeg` binder to
`IsDivisorDegree C c` ("`c` is the degree of some divisor on `C_k`").  That is a statement about
a group homomorphism's image, with no chart in it.  A reduction that no consumer can consume is
worth nothing, though (`I-1345`'s own lesson: price the *consumer's* carrier), so this file
plugs it in at the one place the tree actually needs it.

`exists_chartIndex_mem_chartLocus_of_ledgerIndex` (`Pic0ChartCoverageThreshold.lean:349`) takes
the constraint `deg_k Z = m·d₁ − (M·δ + g)` as a hypothesis, and its docstring says so
explicitly: *"`Z` of prescribed degree is a divisor-side existence statement this file does not
prove and does not claim."*  `mem_chartLocus_of_ledgerIndex_of_isDegree` below discharges
exactly that clause from `IsDivisorDegree`, with the twist exponent chosen for us (`m = 0`).

## What this buys, stated exactly

Coverage's locus membership at the ledger parameter now rests on **one arithmetic hypothesis**
about the base field — `IsDivisorDegree C (M·δ + g)` — in place of an unexhibited pair `(m, Z)`.
The splitting/degree-zero inputs are unchanged, and the following are **untouched**: antecedent 1
(`IsChartUniv`), the pointwise-to-neighbourhood spreading-out that `Pic0ChartCoverageSlice.lean`
records as absent, and `rep` at any parameter.  **No antecedent of `pic0RepresentableByOfCharts`
is discharged here.**

## And what the remaining hypothesis costs, honestly

`IsDivisorDegree C (M·δ + g)` is **not** known to hold.  Over an arbitrary base field `deg_k` is
weighted by residue degrees, so its image is a proper subgroup of `ℤ` in general; the multiples
of `d₁` are admissible unconditionally (`isDegree_mul_thetaDeg`) and `M·δ + g` is not visibly
one of them.  By `isDegree_add_mul_iff` the question is invariant under shifting the target by a
multiple of `d₁`, so what has to be decided is the residue of `M·δ + g` modulo the image — and
that is a question about the curve's arithmetic, not about charts.  This file names it and does
not pretend to answer it.

## The chart index this route produces is UNIFORM in the point — read against `I-1389`

`I-1389` warns that a coverage statement at a *fixed* chart index is strictly stronger than
DAT-B's antecedent 2, because the heterogeneous-atlas apparatus (`mixedParamChart`, the
index-by-`m` atlas of `Pic0ChartCoverageIndexSlack`) exists precisely so different points may use
different charts.  The warning applies to this file, so the position is stated rather than left
for a reader to work out:

* the `(m, Z)` produced below comes from `hadm`, which **does not mention the point** `t`.  So the
  chart index really is uniform in `t` — on this route the chart-index heterogeneity the atlas
  apparatus was built to absorb is not needed, because there is none to absorb;
* but this is **not** one-chart coverage in `I-1389`'s sense, and does not imply it.  The
  remaining inputs — the splitting field `L`, the presenting class `M₀` and `hM₀` — are per-point
  and stay per-point.  What is uniform is the chart index alone.

Neither observation is a refutation or a discharge of anything.  It locates the non-uniformity:
on this route it is in the **splitting data**, not in the chart parameter.  Whether that matters
to antecedent 2 is `I-1389`'s open question and is untouched here.

## Main declarations

* `AlgebraicGeometry.mem_chartLocus_of_ledgerIndex_of_isDegree` — locus membership at the ledger
  parameter from `IsDivisorDegree`, replacing the unexhibited `(m, Z)`.
* `AlgebraicGeometry.exists_chartIndex_mem_chartLocus_of_isDegree` — the `∃`-form DAT-B B-6
  packages, with the same replacement.
-/

set_option autoImplicit false
/- Statements mix `relCurve C L` with the product spelling `(C ⊗ overSpec k L).left`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-- The standing `C.left`-over-`k` structure keyed on `C.hom`, matching
`Pic0ChartCoverageThreshold.lean`'s. -/
noncomputable local instance instOverCleftLedgerFeed :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]

noncomputable section

/-- **Coverage's locus membership at the ledger parameter, with the chart index replaced by an
arithmetic hypothesis on the base field.**

`mem_chartLocus_of_ledgerIndex` needs a pair `(m, Z)` with `deg_k Z = m·d₁ − (M·δ + g)`, which
nothing in the tree produces.  `chartIndex_of_isDegree` produces it from
`IsDivisorDegree C (M·δ + g)` alone, taking `m = 0` — so the twist exponent is not a choice the
consumer has to make.

The chart index is `Z = −W` for `W` the divisor of degree `M·δ + g`, and the resulting locus is
`chartLocus C 0 (−W)`; the exponent is `0` because `hdeg` never constrained it. -/
theorem mem_chartLocus_of_ledgerIndex_of_isDegree
    {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hadm : IsDivisorDegree C ((windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ)))
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (hlam : degAt lam (Over.testPoint t) = 0)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (C ⊗ overSpec k L).left.CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)] :
    ∃ (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor), t ∈ chartLocus C m Z lam := by
  obtain ⟨m, Z, hZ⟩ := chartIndex_of_isDegree C hadm
  exact ⟨m, Z, mem_chartLocus_of_ledgerIndex hπ g hχ lam t hlam m Z hZ M₀ hM₀⟩

/-- **The B-6 packaging form**, identical statement to
`exists_chartIndex_mem_chartLocus_of_ledgerIndex` with its `(m, Z, hZ)` triple replaced by the
single arithmetic hypothesis.

Recorded separately from the theorem above because the two differ only in which of the
`∃`-witnesses is named, and a consumer citing the B-6 packaging should not have to look through
a differently-shaped lemma to find it. -/
theorem exists_chartIndex_mem_chartLocus_of_isDegree
    {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hadm : IsDivisorDegree C ((windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ)))
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (hlam : degAt lam (Over.testPoint t) = 0)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (C ⊗ overSpec k L).left.CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)] :
    ∃ (m' : ℕ) (Z' : (C ⊗ overSpec k k).left.CurveDivisor),
      t ∈ chartLocus C m' Z' lam :=
  mem_chartLocus_of_ledgerIndex_of_isDegree hπ g hχ hadm lam t hlam M₀ hM₀

end

end AlgebraicGeometry
