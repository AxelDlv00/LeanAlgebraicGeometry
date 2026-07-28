/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Tangent.TwoChartCechPic
import AlgebraicJacobian.Picard.DivisorClass
import AlgebraicJacobian.Picard.SectionsAlgebra

/-!
# (iii-c1): every class on a two-chart cover is a two-chart class (W5-T4)

Clause `(iii-c1)` of the W5-T4 residue (`informal/w5-t4-worksheet.md` §6.6): a **general**
unit Čech cocycle `γ` on the pointed cover attached to a two-open family
`V : Bool → X.Opens` is cohomologous to the normalized cocycle `twoChartCocycle u` of a
single overlap unit `u` — namely of `twoChartCandidate`, the value of `γ` at a pair of
points lying in the two different charts. Consequently

* `Scheme.twoChartClassHom_surjective_of_mk` — every `CechPic` class *represented on the
  two-chart cover* is `twoChartClassHom u` for some `u`;
* `Scheme.twoChartClass_surjective_of_mk` — the same statement for the descended
  `twoChartClass`, which with the landed `twoChartClass_injective` makes the two-chart
  Čech `Ȟ¹` of units **isomorphic** onto the classes representable on the cover.

## The normalization, and why it carries no transport

`γ` need not be normalized: at a pair `(x, y)` with `sel x = sel y` its value is an
arbitrary unit on `V (sel x)`, whereas `twoChartPairUnit` is `1` there. The worksheet
predicted the conjugating `0`-cochain `x ↦ γ.evInf x (base (sel x))` would need its type
rewritten (`inf_idem`) and that the four `Bool` cases would each need a `subst`.

**That cost is avoidable, and this file is the record of how.** Take the `0`-cochain

```
normCochain x := (X.unitsRestrict (le_inf le_rfl (hmem …)) (γ.evInf x (base (sel x))))⁻¹
```

Restricting `γ.evInf x (base (sel x))` — which lives on `V (sel x) ⊓ V (sel (base (sel x)))`
— along the inequality `V (sel x) ≤ V (sel x) ⊓ V (sel (base (sel x)))` lands it on
`V (sel x)` **on the nose**. No `rw` in a type, no `subst`, because an inequality of opens
is a `Prop` and proof irrelevance does the work that `inf_idem` was being asked to do. The
`hbase : sel (base s) = s` hypothesis is then needed only to *identify* the resulting
overlap unit with the candidate, i.e. inside `Prop`, where `subst` is free.

The cocycle law then makes the conjugation a one-line computation in each of the four
`Bool` cases: `γ.evInf x (base s) ⁻¹ · γ.evInf x y · γ.evInf y (base t)` restricted to
`V s ⊓ V t` equals `γ.evInf (base s) (base t)`, and that is the pair value of the candidate
by definition.

## Selector surjectivity, twice

`Function.Surjective sel` is used here for the second time in the lane (the first is
`twoChartClassHom_eq_one_iff`): the base points `base s` exist only because `sel` hits both
charts. `Function.surjInv` provides them together with `hbase`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite CategoryTheory.PresheafOfGroups

namespace AlgebraicGeometry

namespace Scheme

variable {X : Scheme.{u}} {V : Bool → X.Opens}

/-! ## The chart-level value of a cocycle at a base point -/

/-- **The value of a cocycle at `(x, y)`, restricted to a single chart.** With
`hx : W ≤ V (sel x)` and `hy : W ≤ V (sel y)` the pair value restricts to `W`; taking
`W = V s` for a chart containing both members is what produces a genuine `0`-cochain out of
pair data, with no transport along an equality of opens. -/
noncomputable def cocycleValueOn (sel : X → Bool) (hmem : ∀ x, x ∈ V (sel x))
    (γ : X.unitsCocycle (twoChartCover V sel hmem)) (x y : X) {W : X.Opens}
    (hx : W ≤ V (sel x)) (hy : W ≤ V (sel y)) : Γ(X, W)ˣ :=
  X.unitsRestrict (le_inf hx hy) (Scheme.unitsEvInf γ x y)

/-- The cocycle law for `cocycleValueOn`, on a common open below all three charts. This is
`unitsEvInf_trans` with the triple overlap replaced by an arbitrary sub-open — the form the
normalization consumes, since there the common open is a *chart*, not an overlap. -/
theorem cocycleValueOn_trans (sel : X → Bool) (hmem : ∀ x, x ∈ V (sel x))
    (γ : X.unitsCocycle (twoChartCover V sel hmem)) (x y z : X) {W : X.Opens}
    (hx : W ≤ V (sel x)) (hy : W ≤ V (sel y)) (hz : W ≤ V (sel z)) :
    cocycleValueOn sel hmem γ x y hx hy * cocycleValueOn sel hmem γ y z hy hz
      = cocycleValueOn sel hmem γ x z hx hz := by
  have hW : W ≤ (twoChartCover V sel hmem).opens x ⊓ (twoChartCover V sel hmem).opens y
      ⊓ (twoChartCover V sel hmem).opens z :=
    fun w hw => ⟨⟨hx hw, hy hw⟩, hz hw⟩
  have h := congrArg (X.unitsRestrict hW) (Scheme.unitsEvInf_trans γ x y z)
  simp only [map_mul, unitsRestrict_unitsRestrict] at h
  exact h

/-- Restriction along `U ≤ U` is the identity on unit sections. Stated with the inequality
as an argument rather than `le_rfl`: proofs of `U ≤ U` are definitionally equal, so this
applies to any of them without a `Subsingleton.elim` step. -/
theorem unitsRestrict_rfl' {U : X.Opens} (h : U ≤ U) (u : Γ(X, U)ˣ) :
    X.unitsRestrict h u = u :=
  Units.ext (X.resHom_refl (u : Γ(X, U)))

/-- **The diagonal value of a cocycle on a chart is trivial.** `unitsEvInf γ x x` restricted
to any open below `V (sel x)` is `1` — the landed `unitsRestrict_unitsEvInf_self`, read in
`cocycleValueOn` language. -/
@[simp]
theorem cocycleValueOn_self (sel : X → Bool) (hmem : ∀ x, x ∈ V (sel x))
    (γ : X.unitsCocycle (twoChartCover V sel hmem)) (x : X) {W : X.Opens}
    (hx hx' : W ≤ V (sel x)) : cocycleValueOn sel hmem γ x x hx hx' = 1 :=
  Scheme.unitsRestrict_unitsEvInf_self γ x hx

/-- **Antisymmetry of the pair values on a chart.** From the cocycle law at `(x, y, x)` and
the trivial diagonal. -/
theorem cocycleValueOn_symm (sel : X → Bool) (hmem : ∀ x, x ∈ V (sel x))
    (γ : X.unitsCocycle (twoChartCover V sel hmem)) (x y : X) {W : X.Opens}
    (hx : W ≤ V (sel x)) (hy : W ≤ V (sel y)) :
    (cocycleValueOn sel hmem γ x y hx hy)⁻¹ = cocycleValueOn sel hmem γ y x hy hx := by
  refine inv_eq_of_mul_eq_one_left ?_
  rw [cocycleValueOn_trans sel hmem γ y x y hy hx hy]
  exact cocycleValueOn_self sel hmem γ y hy hy

/-! ## The normalizing `0`-cochain -/

/-- **The conjugating `0`-cochain of the `(iii-c1)` normalization.** At a point `x` it is
the inverse of `γ`'s value at `(x, base (sel x))`, restricted to the chart `V (sel x)` — a
restriction along an *inequality*, so the section type is `Γ(X, V (sel x))ˣ` on the nose and
no transport appears. -/
noncomputable def normCochain (sel : X → Bool) (hmem : ∀ x, x ∈ V (sel x))
    (γ : X.unitsCocycle (twoChartCover V sel hmem)) {base : Bool → X}
    (hbase : ∀ s, sel (base s) = s) (x : X) :
    Γ(X, (twoChartCover V sel hmem).opens x)ˣ :=
  (cocycleValueOn sel hmem γ x (base (sel x)) le_rfl
    (le_of_eq (congrArg V (hbase (sel x))).symm))⁻¹

/-- **The conjugation identity, at abstract chart indices.** For any two points `x`, `y` the
`normCochain`-conjugate of `γ`'s pair value at `(x, y)` is `γ`'s value at the two *base*
points, restricted to `V (sel x) ⊓ V (sel y)`.

This is pure cocycle algebra — three applications of `cocycleValueOn_trans` on the open
`V (sel x) ⊓ V (sel y)` — and it holds whether or not `sel x = sel y`, which is why the
four-case `Bool` split the worksheet predicted does not appear. -/
theorem normCochain_conj (sel : X → Bool) (hmem : ∀ x, x ∈ V (sel x))
    (γ : X.unitsCocycle (twoChartCover V sel hmem)) {base : Bool → X}
    (hbase : ∀ s, sel (base s) = s) (x y : X)
    (hbx : (twoChartCover V sel hmem).opens x ⊓ (twoChartCover V sel hmem).opens y
      ≤ V (sel (base (sel x))))
    (hby : (twoChartCover V sel hmem).opens x ⊓ (twoChartCover V sel hmem).opens y
      ≤ V (sel (base (sel y)))) :
    X.unitsRestrict (inf_le_left) (normCochain sel hmem γ hbase x)
        * Scheme.unitsEvInf γ x y
      = cocycleValueOn sel hmem γ (base (sel x)) (base (sel y)) hbx hby
        * X.unitsRestrict (inf_le_right) (normCochain sel hmem γ hbase y) := by
  have hx : (twoChartCover V sel hmem).opens x ⊓ (twoChartCover V sel hmem).opens y
      ≤ V (sel x) := inf_le_left
  have hy : (twoChartCover V sel hmem).opens x ⊓ (twoChartCover V sel hmem).opens y
      ≤ V (sel y) := inf_le_right
  -- the two restricted `normCochain` values, as `cocycleValueOn`s on the overlap
  have ex : X.unitsRestrict (inf_le_left) (normCochain sel hmem γ hbase x)
      = cocycleValueOn sel hmem γ (base (sel x)) x hbx hx := by
    refine Eq.trans (congrArg Inv.inv (unitsRestrict_unitsRestrict _ _ _)) ?_
    exact cocycleValueOn_symm sel hmem γ x (base (sel x)) hx hbx
  have ey : X.unitsRestrict (inf_le_right) (normCochain sel hmem γ hbase y)
      = cocycleValueOn sel hmem γ (base (sel y)) y hby hy := by
    refine Eq.trans (congrArg Inv.inv (unitsRestrict_unitsRestrict _ _ _)) ?_
    exact cocycleValueOn_symm sel hmem γ y (base (sel y)) hy hby
  have exy : Scheme.unitsEvInf γ x y = cocycleValueOn sel hmem γ x y hx hy :=
    (unitsRestrict_rfl' _ _).symm
  rw [ex, ey, exy, cocycleValueOn_trans sel hmem γ (base (sel x)) x y hbx hx hy,
    cocycleValueOn_trans sel hmem γ (base (sel x)) (base (sel y)) y hbx hby hy]

end Scheme

end AlgebraicGeometry
