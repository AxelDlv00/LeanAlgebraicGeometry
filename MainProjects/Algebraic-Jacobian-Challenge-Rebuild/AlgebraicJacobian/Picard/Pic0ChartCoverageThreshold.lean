/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartCoverageIndexSlack
import AlgebraicJacobian.Picard.DivisorDatumRankOne
import AlgebraicJacobian.RiemannRoch.WindowFieldTransport

/-!
# B-5 step 3: the vanishing threshold at the splitting field is UNIFORM, and it is π-free

`Picard/Pic0ChartCoverageIndexSlack.lean` settles that at a chart index legal at parameter
`n` the coverage hypothesis `hb` of `mem_chartLocus_of_vanishing_bound` forces `b = n`, and
that `b = g` is false in general (`hb_forces_h0_eq_one`).  Its item 3 then names the residue:
*reconcile the chart parameter with the threshold*.  Both that file and
`Picard/Pic0ChartCoverageNoDrop.lean`'s retraction treat the threshold `b` — DAT-0a's bound
**at the splitting field `L`** — as a per-`L` quantity that has to be obtained before the
reconciliation can even be stated.

**That is where the pricing is wrong, and this file measures why.**  Two separate points:

* **DAT-0a itself is not instantiable at `L`, and that is not an obstruction.**
  `exists_bound_subsingleton_hModule_one_of_isFinite_toP1`
  (`RiemannRoch/UniformVanishing.lean:71`) carries `π : Y ⟶ ℙ¹` with `[IsFinite π]`,
  `[IsDominant π]` and `hπ`.  There is no `relCurve C L ⟶ P1 L` anywhere in this tree, so a
  lane trying to instantiate DAT-0a at a splitting field is trying to build a morphism the
  project does not have.  This is presumably why no coverage file ever cited a threshold at
  `L`.
* **The threshold does not need DAT-0a.**  `subsingleton_hModule_one_of_witness`
  (`RiemannRoch/WindowFieldTransport.lean:87`) is the **π-free peeling**: a *single* witness
  divisor with vanishing `H¹` gives vanishing for every divisor of degree
  `≥ deg W₀ + 1 − χ`.  And `windowN C L hπ g` (`:307`) is such a witness on `relCurve C L`
  for every field extension `L/k`, with `subsingleton_h1_windowN` and
  `deg_windowN = M·δ`.

## The consequence, and it is the point of the file

The bound that comes out is `windowM_choice π hπ g * windowδ π + g`, in which **`L` does not
occur**: `windowM_choice` and `windowδ` are ledger constants of the *base* field `k` (see
I-0204 — the per-field ledger constants do not transport, which is exactly why the window
lane transports window *facts* instead, and why the transported witness carries a `k`-level
degree).  So the threshold is **uniform across all splitting fields**, and the "which
threshold at which fibre" half of the reconciliation is not a residue at all.

What that buys, precisely: `index_of_threshold`
(`Picard/Pic0ChartCoverageIndexSlack.lean:147`) already realises *any* `b ≥ 0` as the ledger
value of a legal chart index at parameter `b.toNat`.  What it could not be composed with was a
`b` known to exist at the splitting field.  Now it can, at one `b` for all fibres.

## What this does NOT do, stated plainly

* **It closes no antecedent of `pic0RepresentableByOfCharts`.**  Coverage still owes the
  *existence of the chart point*, i.e. the pointwise datum of
  `chartsCoverLocally_of_pointwise`; this file supplies one hypothesis of one theorem on the
  route to the locus-membership half.
* **`hb_forces_h0_eq_one` stands.**  The threshold here is `M·δ + g`, which for `M ≥ 1` and
  `δ ≥ 1` is strictly above `g`; it is *not* a route to `b = g`, and nothing here weakens that
  refutation.  What it says is that the chart parameter has to be `(M·δ + g)`, not `g` — and
  since `n` is free throughout the chart layer (`Pic0ChartCoverageIndexSlack`'s own
  correction, `Pic0ChartAtlasParamFree`'s heterogeneity), that is a *statement about which
  parameter the atlas is indexed at*, which is addressed to the divRep lane.
* **It is not new geometry.**  Every ingredient was landed; `windowN` and
  `subsingleton_hModule_one_of_witness` have zero occurrences in any `Pic0Chart*` file, so
  this is a cross-layer citation that nobody had made.

## Main declarations

* `AlgebraicGeometry.subsingleton_h1_of_ledger_bound` — **the uniform threshold at an
  arbitrary field extension**: every divisor on `relCurve C L` of degree `≥ M·δ + g` has
  vanishing `H¹`, with `L` occurring in neither the bound nor any hypothesis but the tower.
* `AlgebraicGeometry.exists_uniform_bound_forall_baseChange` — the same read as DAT-0a's own
  `∃ b`-shape, with the `∃` **outside** the quantifier over `L`.  This is the statement the
  coverage layer's "per-fibre threshold" pricing assumed to be unavailable.
* `AlgebraicGeometry.mem_chartLocus_of_ledger_bound` — coverage's locus membership with the
  threshold hypothesis **discharged**, leaving `hdeg` (the calibration) as the only numeric
  input.
* `AlgebraicGeometry.exists_chartIndex_mem_chartLocus_of_ledger_bound` — the composite with
  `index_of_threshold`'s direction: at the ledger parameter there is a legal chart index whose
  locus contains the point.
-/

set_option autoImplicit false
/- Statements mix `relCurve C L` with the product spelling `(C ⊗ overSpec k L).left`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-- The standing `C.left`-over-`k` structure keyed on `C.hom`, the one the ledger's `hπ` and
the χ-normalization are phrased against. -/
noncomputable local instance instOverCleftCoverageThreshold :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]

noncomputable section

/-! ## The uniform threshold -/

/-- **THE THRESHOLD AT AN ARBITRARY SPLITTING FIELD, PI-FREE AND UNIFORM.**

Every divisor on `relCurve C L` whose degree is at least
`windowM_choice π hπ g * windowδ π + g` has vanishing `H¹` — for **every** field extension
`L/k`, with the same bound.

Read the bound: `windowM_choice π hπ g` and `windowδ π` are ledger constants of the *base*
field, so `L` occurs nowhere in it.  That is what makes this uniform, and it is the fact the
coverage layer's pricing of its own residue assumed to be unavailable
(`Pic0ChartCoverageIndexSlack.lean` item 3, `Pic0ChartCoverageNoDrop.lean`'s retraction: both
treat DAT-0a's threshold at `L` as a per-`L` quantity still to be obtained).

The route uses **no** `π` at the extension, which is why it exists at all: DAT-0a
(`exists_bound_subsingleton_hModule_one_of_isFinite_toP1`) needs a finite dominant
`relCurve C L ⟶ P1 L` and this tree has none.  Instead
`subsingleton_hModule_one_of_witness` peels from a single witness, and the witness is the
transported window divisor `windowN C L hπ g` whose vanishing is `subsingleton_h1_windowN`
and whose degree is `M·δ` (`deg_windowN`).  The χ at `L` is the base normalization
transported by `chi_relCurve`. -/
theorem subsingleton_h1_of_ledger_bound {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (L : Type u) [Field L] [Algebra k L]
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (D : (relCurve C L).CurveDivisor)
    (hD : (windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ)
      ≤ Scheme.CurveDivisor.deg L D) :
    Subsingleton (Sheaf.HModule ((relCurve C L).divisorSheaf L D) 1) := by
  refine subsingleton_hModule_one_of_witness L (windowN C L hπ g) D
    (subsingleton_h1_windowN C L hπ g) ?_
  rw [deg_windowN, chi_relCurve (n := g) hχ L]
  linarith

/-- **The threshold in DAT-0a's own `∃ b` shape, with the `∃` OUTSIDE the quantifier over
the field.**

`exists_bound_subsingleton_hModule_one_of_isFinite_toP1` reads
`∃ b, ∀ D, b ≤ deg D → H¹ = 0` at *one* curve over *one* field.  The coverage layer needs it
at the splitting field of each test point, and the pricing in
`Picard/Pic0ChartCoverageIndexSlack.lean` reasons about "the threshold `b_L`" as though the
`∃` had to sit inside the choice of `L`.  It does not: this is the same shape with the
quantifiers in the order that makes the calibration a single equation rather than a family of
them.

Stated separately from `subsingleton_h1_of_ledger_bound` because *this* is the statement the
residue was priced against, and having it as an `∃` makes the comparison mechanical rather
than a reading of two docstrings.  The witness is the ledger value, which is why it does not
depend on `L`. -/
theorem exists_uniform_bound_forall_baseChange {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)) :
    ∃ b : ℤ, ∀ (L : Type u) (_ : Field L) (_ : Algebra k L),
      ∀ (_ : IsIntegral (relCurve C L))
        (_ : SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)))
        (_ : QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)))
        (_ : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0))
        (_ : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)),
      ∀ D : (relCurve C L).CurveDivisor, b ≤ Scheme.CurveDivisor.deg L D →
        Subsingleton (Sheaf.HModule ((relCurve C L).divisorSheaf L D) 1) :=
  ⟨(windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ),
    fun L _ _ _ _ _ _ _ D hD => subsingleton_h1_of_ledger_bound hπ g hχ L D hD⟩

/-! ## Coverage with the threshold discharged

`mem_chartLocus_of_vanishing_bound` (`Picard/Pic0ChartCoverageNoDrop.lean:154`) takes `hb`
(the threshold) and `hdeg` (the calibration).  The threshold is now available at the
splitting field, so the composite below carries only the calibration — which is what
`Pic0ChartCoverageIndexSlack`'s `index_of_threshold` is about. -/

/-- **Coverage's locus membership with the threshold hypothesis DISCHARGED.**

Verbatim `mem_chartLocus_of_vanishing_bound` with `hb` supplied by
`subsingleton_h1_of_ledger_bound` at the ledger bound, so the only numeric input left is
`hdeg` — the calibration equating the twisted presenting class's degree with the bound.

Note what remains and what does not.  Gone: the per-fibre existence of a threshold, which the
coverage prose treated as the blocker.  Still here: `hdeg`, and by `ledger_forces_b_eq_n` that
pins the chart parameter to `windowM_choice π hπ g * windowδ π + g`.  Since `n` is free
throughout the chart layer, that is admissible — but it is *not* `n = g`, and
`hb_forces_h0_eq_one` continues to show why it cannot be. -/
theorem mem_chartLocus_of_ledger_bound {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (hdeg : classDeg L (M₀ * Scheme.CechPic.map (relCurveMap C k L)
      (chartTwistClass C m Z))
      = (windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ)) :
    t ∈ chartLocus C m Z lam :=
  mem_chartLocus_of_vanishing_bound C lam t m Z M₀ hM₀
    ((windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ))
    (fun D hD => subsingleton_h1_of_ledger_bound hπ g hχ L D hD) hdeg

/-! ## The calibration is discharged by the chart-index constraint alone

`mem_chartLocus_of_ledger_bound` still carries `hdeg`.  But `hdeg` is not an independent
obligation: `classDeg_presenting_twist` (`Picard/Pic0ChartCoverageDegreeStep2.lean:124`)
computes the presenting class's degree as `m·d₁ − deg_k Z` from the degree-zero-ness of `λ` at
the point, so the constraint `deg_k Z = m·d₁ − (M·δ + g)` — a chart index legal at the ledger
parameter, in the sense of `index_of_threshold` — supplies it outright. -/

/-- **COVERAGE AT THE LEDGER PARAMETER, WITH BOTH NUMERIC INPUTS DISCHARGED.**

Given only: `λ` of fibre degree zero at the point, a splitting `M₀` of its fibre class, and a
chart index legal at the **ledger parameter** `M·δ + g` (i.e. `deg_k Z = m·d₁ − (M·δ + g)`),
the point lies in the chart locus.

Compare `mem_chartLocus_of_vanishing_bound`, whose two numeric hypotheses were `hb` (the
threshold) and `hdeg` (the calibration).  Both are gone: `hb` by
`subsingleton_h1_of_ledger_bound` — the uniform π-free threshold — and `hdeg` by
`classDeg_presenting_twist` from the index constraint.  What remains is *only* the splitting
and the degree-zero-ness, which coverage has (`exists_splitting_of_picEt`,
`Pic0ChartSplit.lean:143`, and the `pic0Subgroup` membership of the class).

**This is the reduction, and it is worth being exact about its scope.**  It is
locus-membership at a point of a test, at ONE chart parameter, and it says nothing about the
pointwise datum `chartsCoverLocally_of_pointwise` needs — that also wants a chart POINT over a
neighbourhood, i.e. the divisor family whose class is `λ`, which is the spreading-out
`Pic0ChartCoverageSlice.lean` records as absent for this carrier.  So antecedent 2 is not
closed and I claim nothing on it.  What is closed is that the *numeric* half of B-5 step 3 —
which two files and the `dat-b` row present as the open question — has no content left.

The parameter is `M·δ + g`, not `g`: `hb_forces_h0_eq_one` is untouched, and this route
deliberately does not go near `b = g`. -/
theorem mem_chartLocus_of_ledgerIndex {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (hlam : degAt lam (Over.testPoint t) = 0)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hZ : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C)
        - ((windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ)))
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
    t ∈ chartLocus C m Z lam := by
  refine mem_chartLocus_of_ledger_bound hπ g hχ lam t m Z M₀ hM₀ ?_
  -- `mem_chartLocus_of_vanishing_bound` states `hdeg` in the `relCurveMap` spelling while
  -- `classDeg_presenting_twist` delivers the E-iv-alg transition one; they are the same
  -- morphism (`relCurveMap_eq_overSpecMap_ofId`), but not syntactically.
  rw [relCurveMap_eq_overSpecMap_ofId]
  -- `.trans` rather than a second `rw`: the two spellings of the fibre curve
  -- (`relCurve C L` and the product `(C ⊗ overSpec k L).left`) are defeq but not at
  -- `instances` transparency, so `rw` reports no occurrence on a goal that displays the
  -- pattern.  Application-position unification uses default transparency and goes through.
  refine (classDeg_presenting_twist C lam (Over.testPoint t) hlam L M₀ hM₀ m Z).trans ?_
  rw [hZ]
  ring

/-- **The `∃`-form the DAT-B B-6 packaging consumes**, at the ledger parameter: the chart index
is exhibited rather than assumed.

`index_of_threshold` says the ledger parameter is realisable; this says the realisation feeds
coverage.  The witness is `⟨m, Z⟩` for any `(m, Z)` satisfying the ledger constraint, so the
statement is only as strong as the existence of such a pair — which is why the constraint stays
a hypothesis: `Z` of prescribed degree is a divisor-side existence statement this file does not
prove and does not claim. -/
theorem exists_chartIndex_mem_chartLocus_of_ledgerIndex
    {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (hlam : degAt lam (Over.testPoint t) = 0)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hZ : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C)
        - ((windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ)))
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
  ⟨m, Z, mem_chartLocus_of_ledgerIndex hπ g hχ lam t hlam m Z hZ M₀ hM₀⟩

end

end AlgebraicGeometry
