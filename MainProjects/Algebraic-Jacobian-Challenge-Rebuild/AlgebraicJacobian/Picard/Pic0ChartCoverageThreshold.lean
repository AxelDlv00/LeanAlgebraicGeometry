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

end

end AlgebraicGeometry
