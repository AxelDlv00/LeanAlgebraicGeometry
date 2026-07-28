/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartCoverageDegreeStep2
import AlgebraicJacobian.Picard.Pic0ChartCoverageTest

/-!
# COVERAGE NEEDS NO DROP, NO ORACLE, AND NO STEP 6

A retraction of this lane's own account of B-5, and it removes a residue rather than adding one.

`Picard/Pic0ChartCoverageTest.lean`'s DEFECT section establishes — correctly — that the
`w4-datb` §1.2 argument as written runs the greedy drop at `Z := 0` and feeds the drop's
**output** `Σ` back as the chart index's `Z`, so that the two stages carry different `Z`, and
that this feedback ("step 6") is not discharged anywhere.  It records step 6 as one of B-5's
open residues.

**Step 6 is not a residue, because coverage does not need the drop at all.**

## Why: read what `chartLocus` actually asks for

`IsSplitWitness` (`Pic0ChartLocus.lean:151`) — and its own docstring says this at length, under
"A convention this predicate INHERITS" — asks for a divisor `W` in the presenting class with
`Subsingleton H¹(𝒪(W))`, and asks for **neither `0 ≤ W` nor `deg W = g`**.  Effectivity and the
degree normalisation are what the *chart map's injectivity* needs (GAP-2, `h⁰ = 1`), not what
*membership of the locus* needs.

The drop (`RiemannRoch/CoverageDrop.lean`) exists to manufacture exactly those two extra
properties: it takes a degree-`g+e` witness with `h¹ = 0` and produces an effective `S` with
`h⁰(W₀ − S) = 1`.  For membership, that work is thrown away — `mem_chartLocus_of_drop` returns
the `IsSplitWitness` half from `hW₀`/`h1` alone, and its own proof shows this: the split witness
comes from `isSplitWitness_of_witness_twistClass C μ m Z M₀ hM₀ W₀ hW₀ h1`, in which the drop,
the oracle `P`, `hdense`, `hPcl`, `hPdeg`, `g`, `e`, `hχ` and `hdeg` **do not appear**.

So the feedback of step 6 was an artefact of routing coverage through the drop.  Cut the drop
and there is one `Z` again — the chart index's — and nothing to feed back.

## What coverage then needs, in full

Exactly one input beyond the landed splitting: a divisor of the twisted fibre class over the
splitting field with vanishing `H¹`.  That is DAT-0a at the fibre field, and it is genuinely
per-fibre (I-0204, `w4-datb` §0.2.2): no uniform `m₀` exists, so the exponent `m` must be chosen
against `L`'s own threshold `b_L`.  `mem_chartLocus_of_vanishing_bound` below takes `b_L` in
exactly the shape `exists_bound_subsingleton_hModule_one_of_isFinite_toP1`
(`RiemannRoch/UniformVanishing.lean:71`) produces it, and *derives* the `m` — so what remains of
step 3 is instantiating DAT-0a at the base-changed curve, not choosing anything.

## Main declarations

* `AlgebraicGeometry.mem_chartLocus_of_witness_h1` — **coverage, drop-free**: a splitting plus a
  vanishing witness in the twisted class gives `t ∈ chartLocus`.  No `g`, no `e`, no `χ`, no
  oracle, no effectivity.
* `AlgebraicGeometry.mem_chartLocus_of_vanishing_bound` — the same with the witness *produced*
  from a DAT-0a-shaped degree threshold at the splitting field, with the twist exponent `m`
  derived rather than assumed.
* `AlgebraicGeometry.exists_mem_chartLocus_of_vanishing_bound` — the `∃ m` form: the coverage
  statement `w4-datb` §1.2 targets, at a fixed chart-index shape.
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

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## Coverage without the drop -/

variable (C) in
/-- **COVERAGE, DROP-FREE** — `w4-datb` §1.2 with steps 4, 5 and 6 deleted rather than
discharged.

For a point `t` of an arbitrary test `T` and a plus class `lam`: given a finite separable
`L/κ(t)` presenting the fibre class by `M₀`, and **any** divisor `W` of the twisted class over
`L` with `Subsingleton H¹(𝒪(W))`, the point `t` lies in `chartLocus C m Z lam`.

Compare `mem_chartLocus_of_drop`, whose membership half this strictly generalises: that theorem
additionally takes `g`, `e`, `hχ`, `hdeg` and a four-part point oracle, and uses none of them
for the membership conclusion.  Dropping them is what removes step 6's feedback — the drop's
output `Σ` was the only reason two different `Z`s were in play. -/
theorem mem_chartLocus_of_witness_h1 {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    (W : ((C ⊗ overSpec k L).left).CurveDivisor)
    (hW : Scheme.CurveDivisor.picClass L W
      = M₀ * Scheme.CechPic.map (relCurveMap C k L) (chartTwistClass C m Z))
    (h1 : Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)) :
    t ∈ chartLocus C m Z lam :=
  mem_chartLocus_of_isSplitWitness_fibre C m Z lam t
    (isSplitWitness_of_witness_twistClass C (picEtMap C (Over.testPoint t) lam) m Z M₀ hM₀
      W hW h1)

/-! ## Producing the witness from a degree threshold -/

variable (C) in
/-- **Coverage from a DAT-0a threshold at the splitting field**, with the twist exponent
*derived*.

`hb` is the conclusion of `exists_bound_subsingleton_hModule_one_of_isFinite_toP1`
(`RiemannRoch/UniformVanishing.lean:71`) instantiated at the base-changed curve `C_L`: every
divisor of degree `≥ b` has vanishing `H¹`.  `hdeg` is the degree ledger of the twisted
presenting class, which `classDeg_presenting_twist` (`Pic0ChartCoverageDegreeStep2.lean`)
computes as `m·d₁ − deg_k Z` for a degree-zero `lam` — so this hypothesis is *supplied*, not
assumed, once the chart index is fixed.

Every divisor of the class then has that degree (`classDeg_picClass`), so the threshold applies
to the representative `exists_picClass_eq` produces, and `mem_chartLocus_of_witness_h1` finishes.
No effectivity is needed at any point, which is why no drop appears. -/
theorem mem_chartLocus_of_vanishing_bound {T : Over (Spec (.of k))} (lam : picEt C T)
    (t : T.left) (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    -- The `classDeg L` of `hdeg` is applied to a `relCurve`-spelled class, and the
    -- `BaseChangeInstances` pack is keyed to the PRODUCT spelling `(C ⊗ overSpec k L).left`,
    -- so these three do not synthesise in the STATEMENT (a `haveI` in the proof is too late).
    -- They are not new assumptions: `instIsIntegralBaseChange`,
    -- `instSmoothOfRelativeDimensionBaseChange` and `instQuasiCompactBaseChange` discharge
    -- them at every instantiation, and the proof below re-derives the rest of the pack.
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (b : ℤ)
    (hb : ∀ D : ((C ⊗ overSpec k L).left).CurveDivisor,
      b ≤ Scheme.CurveDivisor.deg L D →
        Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L D) 1))
    (hdeg : classDeg L (M₀ * Scheme.CechPic.map (relCurveMap C k L)
      (chartTwistClass C m Z)) = b) :
    t ∈ chartLocus C m Z lam := by
  -- The instance pack of `BaseChangeInstances` is keyed to the PRODUCT spelling
  -- `(C ⊗ overSpec k L).left`, not to the `relCurve` alias, so the `relCurve`-spelled
  -- binders of `exists_picClass_eq` / `classDeg_picClass` do not synthesise without these
  -- re-keyings (the same pack `Pic0ChartCoverageFibre.lean:130` needs).  The `hdeg`/`M₀`
  -- binders are therefore stated in the PRODUCT spelling, so that the statement itself needs
  -- no re-keying — `relCurveMap C k L` is `(C ◁ overSpecMap (ofId k L)).left`
  -- (`relCurveMap_eq_overSpecMap_ofId`), which is also the spelling
  -- `classDeg_presenting_twist` delivers.
  haveI : IsIntegral (relCurve C L) := instIsIntegralBaseChange C L
  haveI : SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    instSmoothOfRelativeDimensionBaseChange C L
  haveI : QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    instQuasiCompactBaseChange C L
  haveI : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
    instModuleFiniteHModuleZeroBaseChange C L
  haveI : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
    instModuleFiniteHModuleOneBaseChange C L
  obtain ⟨W, hW⟩ := Scheme.CurveDivisor.exists_picClass_eq L
    (M₀ * Scheme.CechPic.map (relCurveMap C k L) (chartTwistClass C m Z))
  refine mem_chartLocus_of_witness_h1 C lam t m Z M₀ hM₀ W hW (hb W ?_)
  rw [show Scheme.CurveDivisor.deg L W
      = classDeg L (Scheme.CurveDivisor.picClass L W) from (classDeg_picClass L W).symm,
    hW, hdeg]

variable (C) in
/-- **The coverage statement in `∃`-form**, i.e. `w4-datb` §1.2's target shape at a fixed chart
index: at a point whose splitting is known and whose twisted class hits the threshold, there is
a chart the point belongs to.

Trivial given the previous theorem; recorded because it is the shape the DAT-B B-6 packaging
(`IsLocallySurjective`) consumes, and because keeping it separate makes visible that the only
`∃` coverage still owes is over the *index*, not over any witness or drop. -/
theorem exists_mem_chartLocus_of_vanishing_bound {T : Over (Spec (.of k))} (lam : picEt C T)
    (t : T.left) (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    -- The `classDeg L` of `hdeg` is applied to a `relCurve`-spelled class, and the
    -- `BaseChangeInstances` pack is keyed to the PRODUCT spelling `(C ⊗ overSpec k L).left`,
    -- so these three do not synthesise in the STATEMENT (a `haveI` in the proof is too late).
    -- They are not new assumptions: `instIsIntegralBaseChange`,
    -- `instSmoothOfRelativeDimensionBaseChange` and `instQuasiCompactBaseChange` discharge
    -- them at every instantiation, and the proof below re-derives the rest of the pack.
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (b : ℤ)
    (hb : ∀ D : ((C ⊗ overSpec k L).left).CurveDivisor,
      b ≤ Scheme.CurveDivisor.deg L D →
        Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L D) 1))
    (hdeg : classDeg L (M₀ * Scheme.CechPic.map (relCurveMap C k L)
      (chartTwistClass C m Z)) = b) :
    ∃ m' : ℕ, ∃ Z' : (C ⊗ overSpec k k).left.CurveDivisor, t ∈ chartLocus C m' Z' lam :=
  ⟨m, Z, mem_chartLocus_of_vanishing_bound C lam t m Z M₀ hM₀ b hb hdeg⟩

end

end AlgebraicGeometry
