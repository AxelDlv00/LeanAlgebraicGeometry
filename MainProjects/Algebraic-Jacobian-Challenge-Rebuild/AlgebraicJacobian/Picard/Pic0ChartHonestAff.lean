/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0AtlasFromDivRepAff
import AlgebraicJacobian.Picard.Pic0ChartPlusFibreProducer

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
étale-sheafification question, and the absolute form of it is *refuted* in this tree:
`PicEtAff.unit_surjective_of_section` (`Picard/EffectivityClose.lean:141`) makes honesty
vacuously true over a field test admitting a curve point, so "honesty is the sheafification gap
asserted of any section" is false as stated.  What this file proves is the same *specific-class*
statement the chart-typed side already had, transported to the carrier the human decision
mandates.

## Why it was cheap, which is the reusable finding

`abelDiv_isPlusHonest` is four lines: exhibit `relPicMk` of the restricted family's class, then
rewrite by naturality and the affine collapse.  Every widened ingredient existed except the
collapse `abelDivAff'_overSpec`, whose chart-typed twin (`Picard/DivSchemeAbel.lean:245`) is
`picEtAffineEquiv.injective` applied to two collapse lemmas.  And the widened collapse was
already *inlined* inside the proof of `degAt_abelDivAff'`
(`Picard/DivisorFamilyAffClassDegree.lean:363-366`) as a `have`: not absent, merely not named.
Naming it is the whole port.

## Main declarations

* `AlgebraicGeometry.picEtAffineEquiv_abelDivAffPlus` — the affine collapse of the widened Abel
  value, extracted from the `have` inside `degAt_abelDivAff'`.
* `AlgebraicGeometry.abelDivAff'_overSpec` — on an affine test the vehicle-level widened Abel
  transformation is the affine one.
* `AlgebraicGeometry.abelDivAff'_isPlusHonest` — **the widened Abel value is honest at every
  test**, the widened twin of `abelDiv_isPlusHonest`.
* `AlgebraicGeometry.chartValueAff_isPlusHonest` — hence so is the widened chart value.
* `AlgebraicGeometry.isOpen_chartLocus_chartValueAff` — **CHART-U(b) on the R2 carrier**:
  the chart locus of a widened chart value is open, unconditionally in the section.
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

/-! ## The affine collapse of the widened Abel value -/

omit [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
  [GeometricallyReduced C.hom] in
/-- **The affine collapse of the widened Abel value**, the twin of `picEtAffineEquiv_abelDiv`
(`Picard/DivSchemeAbel.lean:236`).

This is not new mathematics and is deliberately stated rather than re-proved: the identical term
already appears as an anonymous `have hcollapse` inside the proof of `degAt_abelDivAff'`
(`Picard/DivisorFamilyAffClassDegree.lean:363-366`).  An inlined `have` is invisible to every
name-level search, which is exactly how the port below came to be priced as missing.

The three geometric instances are `omit`ted rather than inherited: the collapse is vehicle
bookkeeping and consumes only `[IsProper C.hom]`, through `abelDivAffPlus_mapAlgHom`. -/
theorem picEtAffineEquiv_abelDivAffPlus (A : Type u) [CommRing A] [Algebra k A]
    (s : divFamZarAff C n (overSpec k A)) :
    picEtAffineEquiv C A (abelDivAff' C n (overSpec k A) s)
      = abelDivAffPlus C A (divFamZarAffAffineEquiv C n A s) :=
  abelDivAffPlus_mapAlgHom (Over.overSpecΓTopAlgEquiv k A).toAlgHom
    (s.1 (overSpecTopAffine A))

/-! ## Honesty of the widened Abel value -/

set_option linter.unusedSectionVars false in
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

**On the suppressed linter, because the two tools genuinely disagree here.**
`linter.unusedSectionVars` reports `[SmoothOfRelativeDimension 1 C.hom]` as unused, and it is
right about the *proof term* — nothing below touches smoothness.  But `omit`ting it does not
compile: `IsPlusHonest` is itself declared under that instance in
`Picard/Pic0ChartPlusFibreProducer.lean`, so the instance is consumed by the **statement**, and
omitting it leaves `⊢ SmoothOfRelativeDimension 1 C.hom` as an unsolved goal at the predicate.
Both measured this session, in both directions.  The suppression is therefore local to this
declaration and not a blanket file option. -/
theorem abelDivAff'_isPlusHonest (T : Over (Spec (.of k))) (s : divFamZarAff C n T) :
    IsPlusHonest C T (abelDivAff' C n T s) := by
  intro U
  refine ⟨relPicMk C (overSpec k Γ(T.left, U.1))
    ((divFamZarAffAffineEquiv C n Γ(T.left, U.1)
      (divFamZarAff.map C n (Over.fromSpecAffine T U) s)).picClass), ?_⟩
  rw [picEtMap_abelDivAff']
  refine (picEtAffineEquiv C Γ(T.left, U.1)).injective ?_
  rw [picEtAffineEquiv_relPicToPicEt, picEtAffineEquiv_abelDivAffPlus, abelDivAffPlus]

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

end

end AlgebraicGeometry
