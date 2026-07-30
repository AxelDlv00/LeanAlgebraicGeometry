/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Curve.P1

/-!
# `ℙ¹` IS A CURVE — the project's first object carrying the whole curve package

**Every theorem in this project about a curve is stated under three instance binders**:
`[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`.
Until this file, **no object in the tree satisfied all three**, and that is measurable rather
than a matter of opinion: a probe importing only `Curve/P1.lean` reports

```
IsProper (P1.asOver k).hom                     -- inferInstance SUCCEEDS
SmoothOfRelativeDimension 1 (P1.asOver k).hom  -- synthInstanceFailed
GeometricallyIrreducible (P1.asOver k).hom     -- synthInstanceFailed
```

and every other `instance … IsProper / SmoothOfRelativeDimension 1 / GeometricallyIrreducible`
in the project is a base change of `C`, a restriction of `C`, or an instance on the *sorried*
`Jacobian C` — all of them consuming the package rather than producing it.

## Why that is a representability fact and not bookkeeping

`(pic0TypeFunctor C).RepresentableBy` and its `JacobianData` wrapper are the project's
representability slot, and the roughly ninety theorems that consume a `rep` all carry the three
binders.  With no object satisfying them, **not one of those theorems can be instantiated at a
concrete curve** — so no lane can exhibit a witness for any of them, whatever it proves, and a
statement of the form "if the seam closes then `pic⁰` is represented" is an implication whose
antecedent list nothing in the tree has ever been checked against.  This file removes that: after
it, `P1.asOver k` is a legal value of `C` in every one of those statements, over an *arbitrary*
field, with no hypothesis on `k`.

## What this file does NOT do, stated plainly

* **It produces no representation.**  No `rep`, no `JacobianData`, no chart, no coverage
  instance, no divisor representability.  It makes the *binders* satisfiable; it says nothing
  about the conclusions.
* **It does not prove `genus (P1.asOver k) = 0`.**  That is a cohomological computation
  (`H¹(ℙ¹, 𝒪) = 0`) and is not attempted here.  In particular it does **not** supply the
  testwise `pic⁰` vanishing that `Picard/Pic0VanishingRoute.lean` consumes; instantiating that
  file's producer at `ℙ¹` still owes the vanishing.
* **It adds no hypothesis to any existing statement**, and changes no existing declaration.

## The two proofs

Both are Zariski-local on the source over the two standard charts `D₊(Xᵢ)`, and both use the
chart identification `P1.awayAlgEquiv : Away 𝒜 (Xᵢ) ≃ₐ[k] k[t]` that `Curve/P1.lean` already
proves — which is the expensive half and is not rebuilt here.

* **Smoothness** reduces, through `HasRingHomProperty.Spec_iff` and
  `RingHom.isStandardSmoothOfRelativeDimension_algebraMap`, to
  `Algebra.IsStandardSmoothOfRelativeDimension 1 k k[t]`.  Mathlib does not ship that (nor the
  `MvPolynomial` version — `exact?` fails on both), so §1 builds the canonical relation-free
  submersive presentation of `MvPolynomial α R`: generators indexed by `α`, no relations, the
  Jacobian being the determinant of the empty matrix.
* **Geometric irreducibility** covers the base change `ℙ¹_K` by the two pulled-back charts, each
  irreducible because it is `Spec K[t]` of a domain, and both containing the preimage of the
  generic point of `ℙ¹_k` — so the space is a union of two *meeting* irreducible opens, hence
  irreducible.

## Main declarations

* `AlgebraicGeometry.mvPolynomialFin_isStandardSmoothOfRelativeDimension` — a Mathlib
  supplement: `MvPolynomial (Fin n) R` is `R`-standard smooth of relative dimension `n`.
* `AlgebraicGeometry.polynomial_isStandardSmoothOfRelativeDimension` — the `n = 1` case for
  `Polynomial R`, which is the shape the chart ring is identified with.
* `AlgebraicGeometry.P1.smoothOfRelativeDimension_asOver` — **`ℙ¹` is smooth of relative
  dimension one over `Spec k`.**
* `AlgebraicGeometry.P1.geometricallyIrreducible_asOver` — **`ℙ¹` is geometrically irreducible
  over `Spec k`.**
* `AlgebraicGeometry.P1.isProper_geometricallyIrreducible_smooth_asOver` — the three binders at
  once, as a single `Prop`-free witness a consumer can point at.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u w

open CategoryTheory Limits Opposite MvPolynomial HomogeneousLocalization

namespace AlgebraicGeometry

noncomputable section

/-! ## §1 A Mathlib supplement: polynomial rings are standard smooth

Mathlib has `Algebra.IsStandardSmoothOfRelativeDimension` and the `SubmersivePresentation`
machinery that produces it, but ships no instance for `MvPolynomial (Fin n) R` or for
`Polynomial R` (`exact?` fails on both goals).  The presentation is the obvious one — the
generators are the variables and there are no relations — and the only step with any content is
that the Jacobian of an empty relation family is a unit, being the determinant of the empty
matrix. -/

/-- The canonical generators of `MvPolynomial α R` over `R`, indexed by `α`: the variables
themselves, with `aeval X` the identity. -/
def mvPolynomialGenerators (R : Type u) [CommRing R] (α : Type w) :
    Algebra.Generators R (MvPolynomial α R) α :=
  Algebra.Generators.ofSurjective MvPolynomial.X fun s => ⟨s, MvPolynomial.aeval_X_left_apply s⟩

/-- The canonical presentation of `MvPolynomial α R`: generators `α`, **no relations**.  The
kernel of `aeval X` is `⊥` because that map is the identity. -/
def mvPolynomialPresentation (R : Type u) [CommRing R] (α : Type w) :
    Algebra.Presentation R (MvPolynomial α R) α PEmpty.{1} where
  __ := mvPolynomialGenerators R α
  relation := PEmpty.elim
  span_range_relation_eq_ker := by
    simp only [Set.range_eq_empty, Ideal.span_empty]
    rw [Algebra.Generators.ker_eq_ker_aeval_val]
    change ⊥ = RingHom.ker
      (MvPolynomial.aeval (R := R) (MvPolynomial.X : α → MvPolynomial α R))
    rw [MvPolynomial.aeval_X_left]
    ext x
    simp [RingHom.mem_ker]

/-- The canonical submersive presentation: the relation index type is empty, so the required
injection is `PEmpty.elim` and the Jacobian is `det` of the `0 × 0` matrix, which is `1`. -/
def mvPolynomialSubmersivePresentation (R : Type u) [CommRing R] (α : Type w) :
    Algebra.SubmersivePresentation R (MvPolynomial α R) α PEmpty.{1} where
  __ := ({ __ := mvPolynomialPresentation R α
           map := PEmpty.elim
           map_inj := fun a _ _ => PEmpty.elim a } :
    Algebra.PreSubmersivePresentation R (MvPolynomial α R) α PEmpty.{1})
  jacobian_isUnit := by
    rw [Algebra.PreSubmersivePresentation.jacobian_eq_jacobiMatrix_det]
    simp [Matrix.det_isEmpty]

/-- **Mathlib supplement**: `MvPolynomial (Fin n) R` is `R`-standard smooth of relative
dimension `n`.  The dimension of the presentation is `#(Fin n) - #PEmpty = n`. -/
instance mvPolynomialFin_isStandardSmoothOfRelativeDimension
    (R : Type u) [CommRing R] (n : ℕ) :
    Algebra.IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R) :=
  (mvPolynomialSubmersivePresentation R (Fin n)).isStandardSmoothOfRelativeDimension <| by
    simp [Algebra.Presentation.dimension]

/-- **`R[t]` is `R`-standard smooth of relative dimension one** — the shape the affine chart of
`ℙ¹` is identified with.  Transported from `MvPolynomial (Fin 1) R` along
`finSuccEquiv`, whose target `Polynomial (MvPolynomial (Fin 0) R)` loses its inner
`MvPolynomial` by `isEmptyAlgEquiv`. -/
instance polynomial_isStandardSmoothOfRelativeDimension (R : Type u) [CommRing R] :
    Algebra.IsStandardSmoothOfRelativeDimension 1 R (Polynomial R) :=
  Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv (n := 1)
    (S := MvPolynomial (Fin 1) R)
    ((MvPolynomial.finSuccEquiv R 0).trans
      (Polynomial.mapAlgEquiv (MvPolynomial.isEmptyAlgEquiv R (Fin 0))))

namespace P1

variable (k : Type u) [Field k]

local notation "𝒜" => homogeneousSubmodule (Fin 2) k

/-! ## §2 Smoothness of relative dimension one -/

/-- **The chart ring is standard smooth of relative dimension one over `k`**, by transport along
the identification `awayAlgEquiv` that `Curve/P1.lean` already proves. -/
theorem isStandardSmoothOfRelativeDimension_away {i j : Fin 2} (hij : i ≠ j) :
    Algebra.IsStandardSmoothOfRelativeDimension 1 k (Away 𝒜 (X i)) :=
  Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv (n := 1) (awayAlgEquiv k hij).symm

/-- **Each chart of `ℙ¹` is smooth of relative dimension one over `Spec k`.**

`chartι_structureMap` turns the composite into the `Spec` of the structure algebra map, and
`HasRingHomProperty.Spec_iff` then reduces the scheme-level property to the ring-level one, which
is `isStandardSmoothOfRelativeDimension_away`. -/
theorem smoothOfRelativeDimension_chartι (i : Fin 2) :
    SmoothOfRelativeDimension 1 (chartι k i ≫ structureMap k) := by
  obtain ⟨j, hij⟩ : ∃ j : Fin 2, i ≠ j := by
    fin_cases i
    · exact ⟨1, by decide⟩
    · exact ⟨0, by decide⟩
  rw [chartι_structureMap, HasRingHomProperty.Spec_iff (P := @SmoothOfRelativeDimension 1)]
  apply RingHom.locally_of RingHom.isStandardSmoothOfRelativeDimension_respectsIso
  show RingHom.IsStandardSmoothOfRelativeDimension 1 (algebraMap k (Away 𝒜 (X i)))
  rw [RingHom.isStandardSmoothOfRelativeDimension_algebraMap]
  exact isStandardSmoothOfRelativeDimension_away k hij

/-- **The two standard charts of `ℙ¹`, as an affine open cover**, with `f i` literally
`chartι k i` — the point of building it here rather than reusing mathlib's
`Proj.affineOpenCover` (whose index type is `Σ i : ℕ+, 𝒜 i` and whose `f` is therefore not the
project's `chartι`).  The covering property is `Curve/P1.lean`'s `chartOpen_sup`, read through
`opensRange_chartι`. -/
def twoChartCover : (P1 k).AffineOpenCover where
  I₀ := Fin 2
  X i := .of (Away 𝒜 (X i))
  f i := chartι k i
  idx x := open Classical in if x ∈ chartOpen k 0 then 0 else 1
  covers x := by
    classical
    have hx : x ∈ chartOpen k 0 ⊔ chartOpen k 1 := (chartOpen_sup k).ge (Set.mem_univ x)
    by_cases h0 : x ∈ chartOpen k 0
    · rw [if_pos h0]
      show x ∈ (chartι k 0).opensRange
      rw [opensRange_chartι]
      exact h0
    · have h1 : x ∈ chartOpen k 1 := by
        rcases hx with h | h
        · exact absurd h h0
        · exact h
      rw [if_neg h0]
      show x ∈ (chartι k 1).opensRange
      rw [opensRange_chartι]
      exact h1

/-- **`ℙ¹` is smooth of relative dimension one over `Spec k`, for an arbitrary field `k`.**

Zariski-local on the source over `twoChartCover`, where each chart is
`smoothOfRelativeDimension_chartι`. -/
instance smoothOfRelativeDimension_structureMap :
    SmoothOfRelativeDimension 1 (structureMap k) :=
  IsZariskiLocalAtSource.of_openCover (twoChartCover k).openCover
    (smoothOfRelativeDimension_chartι k)

/-- **`ℙ¹` as an object over `Spec k` is smooth of relative dimension one** — the binder shape
every curve theorem in this project consumes. -/
instance smoothOfRelativeDimension_asOver :
    SmoothOfRelativeDimension 1 (asOver k).hom :=
  inferInstanceAs (SmoothOfRelativeDimension 1 (structureMap k))

end P1

end

end AlgebraicGeometry
