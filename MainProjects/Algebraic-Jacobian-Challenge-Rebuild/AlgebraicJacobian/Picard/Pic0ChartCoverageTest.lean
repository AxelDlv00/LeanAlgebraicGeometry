/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartCoverageFibre

/-!
# B-5 assembly: from the fibre step to `chartLocus` membership over a GENERAL test

`Picard/Pic0ChartCoverageFibre.lean` runs `w4-datb` §1.2 steps 4–6 at a splitting field and
produces `IsSplitWitness` of a twisted class over `overSpec k L`.  The coverage theorem
(§1.2's `pic0_chartLocus_cover`) is a statement about a point `t` of a **general test** `T`:

```
∃ c : ChartIndex C, t ∈ chartLocus c lam
```

This file closes the gap between the two, which is one substitution and one collapse:

* the fibre class at `t` is `picEtMap C (Over.testPoint t) lam`, a class over the field
  `κ(t)` — so the fibre step applies at `K := κ(t)` with no change;
* `chartLocus` is *defined* as the split-witness predicate of the twisted class at that field
  point, and the twist commutes with restriction (`picEtMap_chartTwist`), so
  "`IsSplitWitness` of the twisted fibre class" **is** membership, by `Iff.rfl`.

The second point is worth stating as a lemma rather than inlining: `chartTwist` is applied to
`lam` over `T` and then restricted, whereas the fibre step produces the twist of the
*restricted* class over `κ(t)`.  Those are equal, but not syntactically — `picEtMap_chartTwist`
is the law, and `mem_chartLocus_of_isSplitWitness_fibre` is the resulting membership rule.

## What remains of B-5 after this file

Exactly the two per-fibre choices `w4-datb` §1.2 makes and this lane cannot make generically:

* **step 3, the twist exponent `m`.**  Chosen against the fibre's OWN DAT-0a bound `b_L`.  No
  uniform `m₀` exists (§0.2.2, I-0204), so this is a genuine `∃ m` produced inside the
  coverage proof, at the fibre.
* **step 5's oracle instantiation.**  `Curve/SepPointsDense.lean`'s density keystone at
  `P :=` the base-changed `K_s`-points, whose `residueDeg = 1` comes from
  `rationalPointBaseChange_snd`.

Both are `L`-level statements; neither is `divRep`- or certificate-gated.  Everything between
them and `chartLocus` membership is now landed.

## Main declarations

* `AlgebraicGeometry.mem_chartLocus_of_isSplitWitness_fibre` — the membership rule: a split
  witness for the twisted *fibre* class puts `t` in `chartLocus`.
* `AlgebraicGeometry.mem_chartLocus_of_drop` — **the B-5 assembly**: the fibre step's
  hypotheses, at `K := κ(t)`, give `t ∈ chartLocus`.
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

/-! ## The membership rule -/

variable (C) in
/-- **A split witness for the twisted FIBRE class puts the point in `chartLocus`.**

`chartLocus` twists over `T` and then restricts to `κ(t)`; the fibre step produces the twist of
the already-restricted class.  `picEtMap_chartTwist` says those agree, and
`chartTwist_eq_mul_thetaFamily_chartTwistClass` puts both in the collapsed spelling the fibre
step uses.

Stated as a named rule because the two sides differ syntactically and a lane that inlines the
substitution will meet the mismatch inside a proof about degrees, where it is least welcome. -/
theorem mem_chartLocus_of_isSplitWitness_fibre (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor) {T : Over (Spec (.of k))}
    (lam : picEt C T) (t : T.left)
    (h : IsSplitWitness C
      (picEtMap C (Over.testPoint t) lam
        * thetaFamily C (chartTwistClass C m Z) (overSpec k (Over.testPointField t)))) :
    t ∈ chartLocus C m Z lam := by
  rw [mem_chartLocus_iff, picEtMap_chartTwist,
    chartTwist_eq_mul_thetaFamily_chartTwistClass]
  exact h

/-! ## The assembly -/

variable (C) in
/-- **THE B-5 ASSEMBLY** (`w4-datb` §1.2, everything except the two per-fibre choices).

For a point `t` of a general test `T` and a plus class `lam` over `T`: given a finite separable
`L/κ(t)` presenting the fibre class, and a divisor `W₀` in the twisted class over `L` of degree
`g + e` with vanishing `H¹`, the point `t` lies in `chartLocus C m Z lam` — and the drop at `L`
additionally yields the `h⁰ = 1` normalisation.

Reading this against `w4-datb` §1.2: steps 1, 2, 4, 5, 6 are all discharged (step 1 by the
`hM₀` hypothesis, which `exists_splitting_of_picEt` supplies unconditionally; step 2/4 by the
degree ledger of `Picard/Pic0ChartCoverageDegree.lean`; step 5 by the oracle; step 6 by graph
classes at the base, `Picard/Pic0ChartRationalGraph.lean`).  **Step 3 — the choice of `m` at
the fibre's own vanishing bound — is the residue**, and it appears here as the fact that `m`,
`W₀` and `hdeg` are *inputs*: a caller must produce a `W₀` of degree `g + e` with `h¹ = 0`,
which is exactly DAT-0a at `L`.

That is the honest shape of what remains, and it is deliberately not hidden: the bound `b_L` is
per-fibre and does not transport (I-0204), so no formulation of this theorem can produce `m`
for the caller. -/
theorem mem_chartLocus_of_drop {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L] [Algebra.IsSeparable (Over.testPointField t) L]
    (g e : ℕ) (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    (W₀ : ((C ⊗ overSpec k L).left).CurveDivisor)
    (hW₀ : Scheme.CurveDivisor.picClass L W₀
      = M₀ * Scheme.CechPic.map (relCurveMap C k L) (chartTwistClass C m Z))
    (hdeg : Scheme.CurveDivisor.deg L W₀ = (g : ℤ) + e)
    (h1 : Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L W₀) 1))
    (P : Set ((C ⊗ overSpec k L).left))
    (hdense : ∀ U : ((C ⊗ overSpec k L).left).Opens,
      (U : Set ((C ⊗ overSpec k L).left)).Nonempty → (P ∩ U).Nonempty)
    (hPcl : ∀ x ∈ P, x ≠ genericPoint ((C ⊗ overSpec k L).left))
    (hPdeg : ∀ x ∈ P, ((C ⊗ overSpec k L).left).residueDeg L x = 1) :
    t ∈ chartLocus C m Z lam
      ∧ ∃ S : ((C ⊗ overSpec k L).left).CurveDivisor, 0 ≤ S ∧
        Scheme.CurveDivisor.deg L S = (e : ℤ) ∧
        Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L (W₀ - S)) = 1 ∧
        Subsingleton (Sheaf.HModule
          ((C ⊗ overSpec k L).left.divisorSheaf L (W₀ - S)) 1) := by
  obtain ⟨hsplit, S, hS0, hSdeg, -, hSh0, hSh1⟩ :=
    exists_isSplitWitness_of_drop C (picEtMap C (Over.testPoint t) lam) m Z g e hχ M₀ hM₀
      W₀ hW₀ hdeg h1 P hdense hPcl hPdeg
  exact ⟨mem_chartLocus_of_isSplitWitness_fibre C m Z lam t hsplit,
    S, hS0, hSdeg, hSh0, hSh1⟩

end

end AlgebraicGeometry
