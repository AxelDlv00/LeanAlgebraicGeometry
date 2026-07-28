/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Tangent.TwoChartQuotientNaturality
import AlgebraicJacobian.Picard.AffineTwoCover

/-!
# The `Bool`-indexed family and selector of an affine two-chart cover (W5-T4, item (3a))

Everything in `Tangent/TwoChartCechPic.lean` and its successors is stated for a family
`V : Bool → X.Opens` together with a selector `sel : X → Bool` satisfying `x ∈ V (sel x)`, and the
quotient-level results additionally need `Function.Surjective sel`. The Wave-5 consumer, by
contrast, holds a `Scheme.AffineTwoCover` (two named affine opens with affine overlap), which is
what `Cohomology/RelativeTwoCover.lean`'s `relCover` produces. This file is the bridge.

## The finding: `hsel` is a real side condition, and it is exactly non-triviality

`informal/w5-t4-worksheet.md` §6.20(3a) flagged that selector surjectivity "is a real side
condition, not bookkeeping". Measured here, it is sharper than that: for the canonical selector
`sel x = if x ∈ V₀ then false else true`,

```
Function.Surjective sel  ↔  V₀ ≠ ⊥ ∧ V₀ ≠ ⊤
```

(`Scheme.AffineTwoCover.surjective_selector_iff`). Both directions are *genuine* content rather than
an artefact of this particular selector:

* `V₀ = ⊥` makes `sel` constantly `true` — and then the "two-chart" cover is the one-chart cover
  `V₁ = ⊤`, whose Čech `Ȟ¹` is trivial for a different reason;
* `V₀ = ⊤` makes `sel` constantly `false`, i.e. `X` is covered by one *affine* chart, so `X` is
  affine.

So a two-chart argument that needs `hsel` is asking for the cover to be **honestly two-chart**, and
that is the right hypothesis to carry rather than to hide. For the Wave-5 curve both conditions hold
— a curve is non-empty, and a proper positive-dimensional scheme over a field is not affine — but
neither is free, and neither is proved here: they are supplied by the consumer as
`h0 : V₀ ≠ ⊥` and `h1 : V₀ ≠ ⊤`.

## Implementation notes

The selector is defined by `Classical.dec`-backed `if x ∈ V₀`, so `hmem` is a two-case `split_ifs`
using `sup_eq_top` for the `x ∉ V₀` branch: a point of `⊤ = V₀ ⊔ V₁` outside `V₀` lies in `V₁`
(`TopologicalSpace.Opens.mem_sup`).

The family is `boolFamily D := fun s ↦ bif s then D.V₁ else D.V₀`, chosen over a `match` so that
`boolFamily D false` and `boolFamily D true` reduce by `rfl` and the `⊓` of the two is *syntactically*
`D.V₀ ⊓ D.V₁` — which is what lets the landed affineness field `isAffineOpen_inf` be used at the
overlap with no transport. That reduction is the whole reason this file is short.

## Main declarations

* `AlgebraicGeometry.Scheme.AffineTwoCover.boolFamily` — the `Bool`-indexed family, with
  `boolFamily_false`, `boolFamily_true` and `boolFamily_inf` (all `rfl`).
* `AlgebraicGeometry.Scheme.AffineTwoCover.selector` — the canonical selector, with
  `selector_mem` (the `hmem` clause).
* `AlgebraicGeometry.Scheme.AffineTwoCover.surjective_selector_iff` — **the side condition,
  characterized**: surjectivity is `V₀ ≠ ⊥ ∧ V₀ ≠ ⊤`.
* `AlgebraicGeometry.Scheme.AffineTwoCover.isAffineOpen_boolFamily` — each chart of the family is
  affine, and `isAffineOpen_boolFamily_inf` for the overlap.

Reference: `informal/w5-t4-worksheet.md` §6.20(3a).
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite

namespace AlgebraicGeometry

namespace Scheme

namespace AffineTwoCover

variable {Y : Scheme.{u}} (D : Y.AffineTwoCover)

/-! ## The `Bool`-indexed family -/

/-- **The two charts as a `Bool`-indexed family.** Spelled with `cond` so that both values, and
their `⊓`, reduce by `rfl` — see the module docstring. -/
def boolFamily : Bool → Y.Opens := fun s ↦ bif s then D.V₁ else D.V₀

@[simp] theorem boolFamily_false : D.boolFamily false = D.V₀ := rfl

@[simp] theorem boolFamily_true : D.boolFamily true = D.V₁ := rfl

/-- The overlap of the family **is** the overlap of the cover, syntactically. -/
@[simp] theorem boolFamily_inf : D.boolFamily false ⊓ D.boolFamily true = D.V₀ ⊓ D.V₁ := rfl

/-- Each chart of the family is affine. -/
theorem isAffineOpen_boolFamily (s : Bool) : IsAffineOpen (D.boolFamily s) := by
  cases s
  · exact D.isAffineOpen₀
  · exact D.isAffineOpen₁

/-- The overlap of the family is affine. -/
theorem isAffineOpen_boolFamily_inf :
    IsAffineOpen (D.boolFamily false ⊓ D.boolFamily true) :=
  D.isAffineOpen_inf

/-! ## The selector -/

open Classical in
/-- **The canonical chart selector**: send `x` to the first chart if it lies there, else to the
second. -/
noncomputable def selector : Y → Bool := fun x ↦ if x ∈ D.V₀ then false else true

/-- The selector selects a chart containing the point — the `hmem` clause every two-chart
declaration takes. The `x ∉ V₀` branch is where `sup_eq_top` is spent. -/
theorem selector_mem (x : Y) : x ∈ D.boolFamily (D.selector x) := by
  classical
  rw [selector]
  split_ifs with h
  · exact h
  · have hx : x ∈ (⊤ : Y.Opens) := trivial
    rw [← D.sup_eq_top] at hx
    exact (TopologicalSpace.Opens.mem_sup.mp hx).resolve_left h

end AffineTwoCover

end Scheme

end AlgebraicGeometry
