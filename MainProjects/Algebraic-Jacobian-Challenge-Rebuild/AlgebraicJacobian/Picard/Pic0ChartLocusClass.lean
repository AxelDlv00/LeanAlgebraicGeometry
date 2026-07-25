/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartLocusOpen
import AlgebraicJacobian.Picard.Pic0ChartLocusFibreField

/-!
# `chartLocus`: the class-indexed chart locus and its openness (C9a)

`Picard/Pic0ChartLocusOpen.lean` proves openness of the witness locus of a *chosen*
basic-open cocycle datum `D`, and `Picard/Pic0ChartLocusFibreField.lean` proves that the
witness predicate is intrinsic to the *fibre class* of the datum.  Neither file defines
`chartLocus` — until this one, the name occurred only in doc comments across the tree
(one of which, `Pic0ChartLocusFibreField.lean:20`, calls it "the still-undefined
`chartLocus`").

This file defines it, at the carrier level the consumers need — a locus in the parameter
space `Spec B`, indexed by a **class**, not by a datum — and proves the two facts the C9
consumers ask for:

* `AlgebraicGeometry.chartLocus` — `{q | every datum with fibre class `c` has a witness
  divisor with vanishing `H¹` at `κ(q)`}`.  A datum-choice-free predicate on
  `PrimeSpectrum B`.
* `AlgebraicGeometry.mem_chartLocus_iff_exists` — the ∀-form and the ∃-form agree: since
  the witness predicate is class-intrinsic, quantifying over all data representing `c`
  and over some datum representing `c` give the same locus.  (Every class IS represented,
  by `BasicOpenCocycleDatum.exists_cechPicClass_eq`.)
* `AlgebraicGeometry.isOpen_chartLocus` — **the openness**, reduced to
  `BasicOpenCocycleDatum.isOpen_setOf_exists_witness_h1_vanishing` at any one
  representing datum.

Everything here is free of the DD-R certificate lane and of `divRep`: no
`DivFamZar`, no `IsCertified`, no `RepresentableBy` datum appears.  What is *not* here
is the C9 deliverable `f_c` (the chart morphism), which is genuinely gated on a
universal family; see the roadmap row `AJCR.w4-rep.datum.dat-c.c9-chartlocus`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {π : C.left ⟶ P1 k} [IsFinite π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

variable (π) in
/-- **The chart locus of a class** (C9, `w4-datc` §3.3): the set of points of the
parameter space `Spec B` at which the fibre of the class `c` admits an effective witness
divisor with vanishing `H¹` — i.e. at which `c` is "seen by the chart".

Stated over *classes*, not over data: a basic-open cocycle datum is a presentation, and
the campaign's consumers (dat-b B-6, dat-glue) index charts by the Picard class.  The
quantifier is harmless because the predicate is class-intrinsic
(`BasicOpenCocycleDatum.hasWitnessH1Vanishing_congr_of_cechPicClass_eq`) and every class
is presented (`BasicOpenCocycleDatum.exists_cechPicClass_eq`) — see
`mem_chartLocus_iff_exists`. -/
def chartLocus (c : (relCurve C B).CechPic) : Set (PrimeSpectrum B) :=
  {q : PrimeSpectrum B | ∀ D : BasicOpenCocycleDatum C B π,
    D.cechPicClass = c → D.HasWitnessH1Vanishing q.asIdeal.ResidueField}

theorem mem_chartLocus_iff (c : (relCurve C B).CechPic) (q : PrimeSpectrum B) :
    q ∈ chartLocus π c ↔ ∀ D : BasicOpenCocycleDatum C B π,
      D.cechPicClass = c → D.HasWitnessH1Vanishing q.asIdeal.ResidueField :=
  Iff.rfl

/-- **Membership is testable at any one presentation**: a datum `D` presenting `c` is a
sound and complete test for membership of the chart locus.  This is the class-intrinsicity
of the witness predicate, `hasWitnessH1Vanishing_congr_of_cechPicClass_eq`, in the form
the consumers use. -/
theorem mem_chartLocus_iff_of_datum {c : (relCurve C B).CechPic}
    (D : BasicOpenCocycleDatum C B π) (hD : D.cechPicClass = c) (q : PrimeSpectrum B) :
    q ∈ chartLocus π c ↔ D.HasWitnessH1Vanishing q.asIdeal.ResidueField := by
  refine ⟨fun h => h D hD, fun h D' hD' => ?_⟩
  refine (D'.hasWitnessH1Vanishing_congr_of_cechPicClass_eq D
    q.asIdeal.ResidueField ?_).mpr h
  exact congrArg (Scheme.CechPic.map (relCurveMap C B q.asIdeal.ResidueField))
    (hD'.trans hD.symm)

/-- **The ∀-form and the ∃-form of the chart locus agree**: every class is presented by
some datum, and the witness predicate does not depend on which. -/
theorem mem_chartLocus_iff_exists (c : (relCurve C B).CechPic) (q : PrimeSpectrum B) :
    q ∈ chartLocus π c ↔ ∃ D : BasicOpenCocycleDatum C B π,
      D.cechPicClass = c ∧ D.HasWitnessH1Vanishing q.asIdeal.ResidueField := by
  obtain ⟨D₀, hD₀⟩ := BasicOpenCocycleDatum.exists_cechPicClass_eq (C := C) (π := π) c
  refine ⟨fun h => ⟨D₀, hD₀, h D₀ hD₀⟩, fun ⟨D, hD, h⟩ => ?_⟩
  exact (mem_chartLocus_iff_of_datum D hD q).mpr h

/-- **The chart locus is open** (C9a, the keystone the consumers cite): the class-indexed
locus is the witness locus of any one presenting datum, and that is open by
`BasicOpenCocycleDatum.isOpen_setOf_exists_witness_h1_vanishing` (the audited,
Noetherian-free openness engine).

This is the first *datum-choice-free* openness statement of the C9 row — the earlier
engine output is stated for a chosen `D`, which is not what a chart indexed by a Picard
class may depend on. -/
theorem isOpen_chartLocus (hπ : π ≫ P1.structureMap k = C.hom)
    (c : (relCurve C B).CechPic) : IsOpen (chartLocus π c) := by
  obtain ⟨D₀, hD₀⟩ := BasicOpenCocycleDatum.exists_cechPicClass_eq (C := C) (π := π) c
  have hset : chartLocus π c
      = {q : PrimeSpectrum B |
          ∃ W : ((C ⊗ overSpec k q.asIdeal.ResidueField).left).CurveDivisor,
            Scheme.CurveDivisor.picClass q.asIdeal.ResidueField W
                = Scheme.CechPic.map (relCurveMap C B q.asIdeal.ResidueField)
                    D₀.cechPicClass
              ∧ Subsingleton (Sheaf.HModule
                  ((C ⊗ overSpec k q.asIdeal.ResidueField).left.divisorSheaf
                    q.asIdeal.ResidueField W) 1)} :=
    Set.ext fun q => mem_chartLocus_iff_of_datum D₀ hD₀ q
  rw [hset]
  exact D₀.isOpen_setOf_exists_witness_h1_vanishing hπ

end AlgebraicGeometry
