/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0AtlasFromDivRepAff
import AlgebraicJacobian.Picard.Pic0ChartPlusFibreProducer
import AlgebraicJacobian.Picard.Pic0ChartUnivReduce

/-!
# CHART-U(b) ON THE R2 CARRIER: the widened Abel value is plus-honest

## The gap this closes

`Picard/Pic0AtlasFromDivRepAff.lean` gives `abelSigmaChartAff` exactly the type
`pic0RepresentableByOfCharts` consumes for its `f i`, so the carrier that human decision
`I-0492` mandates now reaches the representability seam's *input*.  It does not reach the
seam's **openness** antecedent, and that is what this file repairs.

CHART-U(b) at a general test is `isOpen_chartLocus_of_isPlusHonest`
(`Picard/Pic0ChartPlusFibreProducer.lean:316`), whose single non-instance hypothesis is
`IsPlusHonest C T lam` (`:200`).  Measured at HEAD before writing this file, case-insensitively
so that producers in suffix position are not missed (the mechanism recorded at `I-1005`, and the
census error the reviewer made on this very predicate): `IsPlusHonest` has four producers —
`thetaFamily_isPlusHonest`, `sigmaFamily_isPlusHonest`, `abelDiv_isPlusHonest`,
`chartTwist_isPlusHonest` — and **all four are stated at the chart-typed carrier**.  Zero
declarations related `IsPlusHonest` to `abelDivAff'`, `chartValueAff` or `divFamZarAff`.

So the widened Σ-chart could be built and its locus could not be shown open: the same
carrier-target defect as the Abel hook itself (memory `census-the-carrier-target-pair`), one
level up, and re-opened by the commit that closed the level below.

## What is landed here, and what is NOT

Landed: honesty of the widened Abel value at an arbitrary test and an arbitrary widened
section, and hence openness of `chartLocus` at a widened chart value — the widened twin of
`isOpen_chartLocus_of_isPlusHonest`, with no hypothesis on the section.

**NOT landed, and none of it is weakened by the above.**  `IsChartUniv` for the widened family
is not stated here; Zariski-local surjectivity of `Sigma.desc` is untouched; and
`(divFunctorAff C n).RepresentableBy` still has no producer anywhere in the tree, so this file
supplies openness *of a locus of a chart shape*, not a chart.  In particular no antecedent of
`pic0RepresentableByOfCharts` is discharged.

**Honesty at an ARBITRARY `picEt` class remains open and is NOT approached here.**  That is the
étale-sheafification question.  Its *absolute* form is reportedly refuted elsewhere in this tree
by `PicEtAff.unit_surjective_of_section` (`Picard/EffectivityClose.lean:141`), which is said to
make honesty vacuously true over a field test admitting a curve point — flagged as a citation
rather than asserted, because `EffectivityClose` is **outside this file's import closure**, so
that name does not `#check` here and nothing below depends on it.  (A first version of this
header stated the refutation flatly on the strength of a grep; the distinction is the recurring
failure recorded at `I-1073`.)  What this file proves is the same *specific-class* statement the
chart-typed side already had, transported to the carrier the human decision mandates.

## Why it was cheap, and the correction a fresh-context audit forced

`abelDiv_isPlusHonest` is four lines: exhibit `relPicMk` of the restricted family's class, then
rewrite by naturality and the affine collapse.  Every widened ingredient existed, and the one I
took to be missing — the widened affine collapse — was **not** missing in either of the two
senses a first version of this header claimed.

That first version said the collapse existed only as an anonymous `have hcollapse` inside the
proof of `degAt_abelDivAff'`, and stated it here under a new name.  Both halves were wrong, and
the second is the expensive one: `picEtAffineEquiv_abelDivAff'`
(`Picard/DivisorFamilyAffClassDegree.lean:340`) is that lemma, named and landed by another lane
in the *same round*, in the very file this header cited by line number — and byte-identical in
statement and proof term to the duplicate this file briefly carried.  Verified interchangeable
before the duplicate was deleted.  So the honest finding is narrower than "an inlined `have` is
invisible to search" (true in general, and still worth the memory item it got): here the term
had already been named one commit earlier, and the miss was mine for pricing against a stale
read of a file that was moving under me.  What remains of the original observation is that the
port is a transcription — `picEtMap_abelDivAff'` for `picEtMap_abelDiv`, p1's collapse for
`picEtAffineEquiv_abelDiv`, and nothing else changes.

## Main declarations

* `AlgebraicGeometry.abelDivAff'_isPlusHonest` — **the widened Abel value is honest at every
  test**, the widened twin of `abelDiv_isPlusHonest`.
* `AlgebraicGeometry.chartValueAff_isPlusHonest` — hence so is the widened chart value.
* `AlgebraicGeometry.isOpen_chartLocus_chartValueAff` — **CHART-U(b) on the R2 carrier**:
  the chart locus of a widened chart value is open, unconditionally in the section.
* `AlgebraicGeometry.chartLocusAffineLocal_chartValueAff` — the `haff` residue **discharged**
  for the widened chart value, and `chartLocusOpensChartValueAff` the resulting `T.left.Opens`.
  Added after the audit pointed out that this file's first version *understated* itself: three
  sites still price `haff` as owed at a general test, and for this carrier it is not.
-/

set_option autoImplicit false
/- Statements mix `Γ(relCurve C R, ·)` with opens produced on the product spelling; see
`AlgebraicJacobian.Cohomology.RelativeSectionsLinear`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161), so the pinned synthesis depth
must be set in-file for the faithful per-file check. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsFinite π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
variable {n : ℕ}

noncomputable section

/-! ## Honesty of the widened Abel value

The affine collapse this section consumes is `picEtAffineEquiv_abelDivAff'`
(`Picard/DivisorFamilyAffClassDegree.lean:340`), landed by another lane in the same round.  A
first version of this file carried a byte-identical duplicate of it under a different name; the
duplicate is deleted and the original consumed. -/

omit [SmoothOfRelativeDimension 1 C.hom] in
variable (C n) in
/-- **THE WIDENED ABEL VALUE IS PLUS-HONEST AT EVERY TEST** — the widened twin of
`abelDiv_isPlusHonest` (`Picard/Pic0ChartPlusFibreProducer.lean:275`), and the declaration whose
absence kept CHART-U(b) from reaching the R2 carrier.

Unconditional in the section: no chart-typed preimage is assumed, which matters because the
classes the widening exists to admit are exactly those that have none.

The witness on the affine piece `U` is the relative Picard class of the *restricted* widened
family, and the proof is the chart-typed one with `picEtMap_abelDivAff'` in place of
`picEtMap_abelDiv`: honesty compares `relPicToPicEt` with `abelDivAffPlus`, both of which are
`PicEtAff.unit` of a `relPic` class, so after the collapse the two sides are the same term.

`[SmoothOfRelativeDimension 1 C.hom]` is `omit`ted, and a first version of this file wrongly
claimed it could not be: it asserted that `IsPlusHonest` is declared under that instance, so the
statement consumes it and omitting leaves an unsolved goal — and suppressed the linter on that
basis.  `#check @IsPlusHonest` shows the predicate carries only `IsProper`,
`GeometricallyIrreducible` and `GeometricallyReduced`.  The unsolved goal I measured came from a
local collapse helper that did not itself omit the section instances, i.e. from the helper I had
rather than the statement I wrote; with p1's collapse consumed instead, `omit` compiles.  The
linter was right both times. -/
theorem abelDivAff'_isPlusHonest (T : Over (Spec (.of k))) (s : divFamZarAff C n T) :
    IsPlusHonest C T (abelDivAff' C n T s) := by
  intro U
  refine ⟨relPicMk C (overSpec k Γ(T.left, U.1))
    ((divFamZarAffAffineEquiv C n Γ(T.left, U.1)
      (divFamZarAff.map C n (Over.fromSpecAffine T U) s)).picClass), ?_⟩
  rw [picEtMap_abelDivAff']
  refine (picEtAffineEquiv C Γ(T.left, U.1)).injective ?_
  rw [picEtAffineEquiv_relPicToPicEt, picEtAffineEquiv_abelDivAff', abelDivAffPlus]

variable (C n) in
/-- **The widened chart value is plus-honest** — the widened twin of `chartTwist_isPlusHonest`
composed with the Abel witness.

`chartValueAff = abelDivAff' · Σ · (θᵐ)⁻¹` (`Picard/DivisorFamilyAffAbel.lean:266`) and honesty
is a subgroup condition (`IsPlusHonest.mul`/`.inv`/`.pow`), while `sigmaFamily` and `thetaFamily`
are honest at every test with no hypothesis on the curve.  So honesty of the widened chart value
reduces to honesty of its Abel factor, which is the theorem above. -/
theorem chartValueAff_isPlusHonest (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s : divFamZarAff C n T) :
    IsPlusHonest C T (chartValueAff C n m Z T s) :=
  ((abelDivAff'_isPlusHonest C n T s).mul C (sigmaFamily_isPlusHonest C Z T)).mul C
    ((thetaFamily_isPlusHonest C (thetaCechClass C) T).pow C m).inv

/-! ## CHART-U(b) on the R2 carrier -/

variable (C π n) in
/-- **CHART-U(b) ON THE R2 CARRIER**: the chart locus of a *widened* chart value is open, with no
hypothesis on the widened section.

This is `isOpen_chartLocus_of_isPlusHonest` (`Picard/Pic0ChartPlusFibreProducer.lean:316`) with
its residue discharged at the carrier human decision `I-0492` mandates.  Nothing about the
openness chain changes — engine, RE-5, iso-invariance, `haff`, the presentation and the
plus-fibre producer are all reused verbatim; what was missing was a producer of `IsPlusHonest`
for a widened class, and the four existing producers were chart-typed.

**This closes no antecedent of `pic0RepresentableByOfCharts`.**  `IsChartUniv` and Zariski-local
surjectivity are untouched, and `(divFunctorAff C n).RepresentableBy` still has no producer, so
`s` is available only where a widened representation is. -/
theorem isOpen_chartLocus_chartValueAff (hπ : π ≫ P1.structureMap k = C.hom)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s : divFamZarAff C n T) :
    IsOpen (chartLocus C m Z (chartValueAff C n m Z T s)) :=
  isOpen_chartLocus_of_isPlusHonest C π hπ m Z T _ (chartValueAff_isPlusHonest C n m Z T s)

/-! ## The `haff` residue, discharged for this carrier -/

variable (C π n) in
/-- **`ChartLocusAffineLocal` DISCHARGED for the widened chart value** — the `haff` argument that
`chartLocusOpens` (`Picard/Pic0ChartUnivReduce.lean:115`) takes, produced rather than passed
through.

`Pic0ChartUnivReduce.lean:104-114` says "nothing in the tree produces `haff` for a general test",
and `Pic0ChartAtlasCoupling.lean:53`/`:142` twice price the `chartLocusOpens` bridge at the cost
of `haff`.  For the widened chart value that is no longer so, and the step is two lines:
`picEtMap_chartValueAff` (`Picard/DivisorFamilyAffAbel.lean:295`) says a *restricted* widened
chart value is again a widened chart value — of the restricted family — so the openness theorem
above applies to each restriction directly.

This section exists because a fresh-context audit found the first version of this file
*understating* itself: it declared that it discharged no consumer's obligation, having checked
only the seam's three antecedents and not the `haff` sites.  Understated prose costs a lane a
round exactly as overstated prose does. -/
theorem chartLocusAffineLocal_chartValueAff (hπ : π ≫ P1.structureMap k = C.hom)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s : divFamZarAff C n T) :
    ∀ U : T.left.affineOpens,
      IsOpen (chartLocus C m Z (picEtMap C (Over.fromSpecAffine T U)
        (chartValueAff C n m Z T s))) := by
  intro U
  rw [picEtMap_chartValueAff]
  exact isOpen_chartLocus_chartValueAff C π n hπ m Z _ _

variable (C π n) in
/-- **The chart locus of a widened chart value as an OPEN OF THE TEST**, with no argument left
over — the shape the `W` field of a chart datum consumes (`chartLocusOpens`).

`chartLocusOpens` is where the openness obligation is actually spent, so this, rather than the
bare `IsOpen`, is what a consumer of the widened carrier can use. -/
def chartLocusOpensChartValueAff (hπ : π ≫ P1.structureMap k = C.hom)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s : divFamZarAff C n T) : T.left.Opens :=
  chartLocusOpens C m Z T (chartValueAff C n m Z T s)
    (chartLocusAffineLocal_chartValueAff C π n hπ m Z T s)

end

end AlgebraicGeometry
