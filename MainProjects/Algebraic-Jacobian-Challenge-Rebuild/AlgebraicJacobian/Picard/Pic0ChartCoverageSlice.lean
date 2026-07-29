/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartCoverageAffineTest
import AlgebraicJacobian.Picard.Pic0ChartCoverageAbel

/-!
# DAT-B B-5: the Σ-component of the coverage datum is absorbed by producing a SLICE morphism

`Picard/Pic0ChartCoverageAbel.lean:105` (`abelChartApp_eq`) records that the chart
application is a **pair**, and its header warns that a coverage producer must match *two*
equations rather than one — the Σ-components before the classes are even in the same type.
Two roadmap rows and the c9b thread price the coverage datum accordingly.

**That price is avoidable, and this file measures the exact discount.**  The Σ-component of
the section `s` is free data (`s.1 : Y ⟶ Spec k` is an arbitrary morphism, and it is *not*
definitionally `W.ι ≫ Y.hom`), so a producer handing over an unconstrained
`x : (W : Scheme) ⟶ D.left` genuinely owes the equation `x ≫ D.hom = W.ι ≫ s.1`.  But a
producer that works **in the slice over `Over.mk (W.ι ≫ s.1)`** — reading the arbitrary
Σ-component off the section instead of fighting it — gets that equation as `Over.w`, i.e.
for free, by construction.

So the datum reduces to a single class equation, and `datum_of_slice` below is that
statement.  `chartsCoverLocally_of_slice` then feeds it through the affine-test reduction of
`Pic0ChartCoverageAffineTest.lean` to `ChartsCoverLocally`, and `isLocallySurjective_of_slice`
to antecedent 2 of `pic0RepresentableByOfCharts` itself.

## What is genuinely bought, and what is only moved

Bought: the Σ-side, in full, as `Over.w`.  A producer citing `datum_of_slice` never mentions
the Σ-component again.  This is a real discount against the two-equation pricing, and it is
the point of the file.

Moved, not removed: the producer must now be indexed by the slice object
`Over.mk (W.ι ≫ s.1)` rather than by a bare scheme `W`.  Every divisor-side producer in this
project is stated over `overSpec k S`, so a route through them acquires the identification of
`Over.mk (W.ι ≫ s.1)` with `overSpec k Γ(Y, W)` at an affine `W`.  That seam is not written
here and is not free; it is named so the discount is not mistaken for a closure.

Not touched at all: the class equation itself.  It asks that the chart value of the divisor
family named by `g` **is** the given class restricted to the slice — which is B-5's geometry,
still open, and whose remaining cost is a producer of a divisor family over a *neighbourhood*
from data at a *point*.  That step is a spreading-out; it is absent from the tree for this
carrier (measured: every `DivFamZar` producer takes its base ring first, and the only
spreading lemmas in the tree — `exists_supportTube` and its `Confine` instance — act on the
support locus of an already-given local-equation system, not on a class).

## Main declarations

* `AlgebraicGeometry.sigmaComponent_of_slice` — the Σ-component, discharged: for a slice
  morphism `g`, the chart's Σ-component agrees with the section's by `Over.w`.
* `AlgebraicGeometry.datum_of_slice` — **the reduction**: the full datum equation of
  `chartsCoverLocally_of_affineLocal` follows from the class equation alone.
* `AlgebraicGeometry.chartsCoverLocally_of_slice` — `ChartsCoverLocally` from per-point slice
  data over affine tests.
* `AlgebraicGeometry.isLocallySurjective_of_slice` — antecedent 2, from the same.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

noncomputable section

/-! ## The Σ-component, discharged -/

/-- **The Σ-component of the coverage datum is `Over.w`.**

For a morphism `g` in the slice over `Over.mk (W.ι ≫ s.1)`, the Σ-component of the chart
applied at `g.left` is the Σ-component of the restricted section, by the defining property of
a slice morphism.  Recorded as a lemma because the two-equation pricing of the coverage datum
rests on this being an obligation, and it is not one for a producer of this shape. -/
theorem sigmaComponent_of_slice {D : Over (Spec (.of k))}
    (Y : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op Y)) (W : Y.Opens)
    (g : Over.mk (W.ι ≫ s.1) ⟶ D) :
    g.left ≫ D.hom = W.ι ≫ s.1 :=
  Over.w g

/-! ## The reduction: one class equation is the whole datum -/

/-- **THE DATUM FROM A SLICE MORPHISM PLUS ONE CLASS EQUATION.**

The hypothesis `hcl` is the class equation in the slice over `Over.mk (W.ι ≫ s.1)`: the chart
value of the divisor family that `g` names is the given class, restricted.  Given it, the full
pair equation that `chartsCoverLocally_of_affineLocal` consumes holds — the Σ-component is
`Over.w g` and the `Over.mkCongr` transport is handled by `Over.sigmaExtension_ext`.

This is the discount `abelChartApp_eq`'s header asks a producer to pay and a producer of this
shape does not owe. -/
theorem datum_of_slice {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (Y : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op Y)) (W : Y.Opens)
    (g : Over.mk (W.ι ≫ s.1) ⟶ D)
    (hcl : (pic0TypeFunctor C).map (Over.mkCongr (Over.w g)).op
        ((pic0TypeFunctor C).map
          (Over.homMk W.ι rfl : Over.mk (W.ι ≫ s.1) ⟶ Over.mk s.1).op s.2)
      = ⟨chartValue C π n m Z (Over.mk (g.left ≫ D.hom))
          (rep.homEquiv (Over.homMk g.left rfl)),
        chartValue_mem_pic0Subgroup C π n m Z hdeg _ _⟩) :
    (abelSigmaChart C π n rep m Z hdeg).app (op (W : Scheme.{u})) g.left
      = (pic0SigmaSheaf C).1.map (W.ι).op s := by
  rw [abelChartApp_eq]
  rw [show ((pic0SigmaSheaf C).1.map (W.ι).op s)
      = ⟨W.ι ≫ s.1, (pic0TypeFunctor C).map
          (Over.homMk W.ι rfl : Over.mk (W.ι ≫ s.1) ⟶ Over.mk s.1).op s.2⟩ from rfl]
  exact Over.sigmaExtension_ext (pic0TypeFunctor C) (Over.w g) hcl

/-! ## Through to antecedent 2

The two composites, so the discount lands at the seam rather than in mid-air.  Both are
stated for the ONE-CHART family `fun _ : ι => abelSigmaChart …`: the slice reduction is about
the chart application, which does not see the index, and heterogeneity is orthogonal
(`Pic0ChartAtlasParamFree.lean`). -/

variable (C π n) in
/-- **`ChartsCoverLocally` from per-point slice data over affine tests.**

The hypothesis is the coverage obligation in its cheapest measured form: over an affine test
only (`Pic0ChartCoverageAffineTest.lean`), a slice morphism rather than a bare morphism (so
the Σ-component is `Over.w`), and one class equation.  Nothing else stands between it and the
sieve condition. -/
theorem chartsCoverLocally_of_slice {ι : Type u} [Nonempty ι] {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (h : ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (g : Over.mk (W.ι ≫ s.1) ⟶ D),
        (pic0TypeFunctor C).map (Over.mkCongr (Over.w g)).op
            ((pic0TypeFunctor C).map
              (Over.homMk W.ι rfl : Over.mk (W.ι ≫ s.1) ⟶ Over.mk s.1).op s.2)
          = ⟨chartValue C π n m Z (Over.mk (g.left ≫ D.hom))
              (rep.homEquiv (Over.homMk g.left rfl)),
            chartValue_mem_pic0Subgroup C π n m Z hdeg _ _⟩) :
    ChartsCoverLocally C (fun _ : ι => abelSigmaChart C π n rep m Z hdeg) := by
  refine chartsCoverLocally_of_affineLocal C _ fun Y _ s y => ?_
  obtain ⟨W, hyW, g, hcl⟩ := h Y s y
  exact ⟨W, hyW, Classical.arbitrary ι, g.left,
    datum_of_slice rep m Z hdeg Y s W g hcl⟩

variable (C π n) in
/-- **Antecedent 2 of `pic0RepresentableByOfCharts`, from slice data over affine tests.**

The composite with B-6 (`isLocallySurjective_sigmaDesc`).  This is the honest endpoint of the
reduction: the instance the DAT-glue seam consumes, from the cheapest form of the coverage
datum the tree can currently state.

**The class equation is still open**, and it is the whole of what is left here.  Its cost is a
divisor family over a *neighbourhood* produced from data at a *point* — a spreading-out, absent
from the tree for this carrier. -/
theorem isLocallySurjective_of_slice {ι : Type u} [Nonempty ι] {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (h : ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (g : Over.mk (W.ι ≫ s.1) ⟶ D),
        (pic0TypeFunctor C).map (Over.mkCongr (Over.w g)).op
            ((pic0TypeFunctor C).map
              (Over.homMk W.ι rfl : Over.mk (W.ι ≫ s.1) ⟶ Over.mk s.1).op s.2)
          = ⟨chartValue C π n m Z (Over.mk (g.left ≫ D.hom))
              (rep.homEquiv (Over.homMk g.left rfl)),
            chartValue_mem_pic0Subgroup C π n m Z hdeg _ _⟩) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : ι => abelSigmaChart C π n rep m Z hdeg)) :=
  isLocallySurjective_sigmaDesc _ (chartsCoverLocally_of_slice C π n rep m Z hdeg h)

end

end AlgebraicGeometry
