# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
rigidity-hfib

## Design question
What is the Mathlib idiom for describing the **fibre of a pullback projection
`Limits.pullback.snd X.hom Y.hom` over a `k̄`-rational point of `Y`** — specifically, is there
an existing result (or a clean idiomatic assembly) showing that this fibre is exactly the image
of the canonical section `s : X → X ×_{Spec k̄} Y` induced by the rational point? Concretely we
need to close, for `X Y : Over (Spec k̄)` with `kbar` algebraically closed:

```
hfib : (snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base
```

where `y₀ : 𝟙_ ⟶ Y` is a morphism over `Spec k̄` (so `y₀.left` is a SECTION of `Y.hom`, making
`y₀pt := y₀.left.base ptk` a `k̄`-rational point with residue field `k̄`), and
`s := (lift (𝟙 X) (toUnit X ≫ y₀)).left : X.left ⟶ (X ⊗ Y).left` is the slice section
`x ↦ (x, y₀)`. (Equality `p₂⁻¹{y₀pt} = range s` in fact holds; we only need `⊆`.)

## Project artifact(s) under question
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:154` — the `hfib` sorry inside
  `rigidity_eqOn_dense_open`.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:111-181` — the enclosing lemma; `s`, `y₀pt`,
  `ptk`, `snd X Y` are defined at L131-149. Note `(snd X Y).left = Limits.pullback.snd X.hom Y.hom`
  via `CategoryTheory.Over.snd_left` (an exact rewrite; the monoidal `⊗` on `Over S` is the
  chosen pullback).

## Why now
The iter-158 prover lane reduced the entire non-emptiness of Mumford's open `V := Y∖G` to exactly
this fibre fact, genuinely consuming the collapse hypothesis `_hf`. The prover located the
pullback point-set machinery (`Scheme.Pullback.carrierEquiv`, `Scheme.Pullback.Triplet` /
`.tensor` / `.ext_iff` / `.carrierEquiv_eq_iff`, `Scheme.Pullback.exists_preimage_of_isPullback`,
`Scheme.Hom.fiber` in `Mathlib.AlgebraicGeometry.Fiber`) but found **no off-the-shelf lemma** that
the fibre of `pullback.snd` over a rational point is the source. The progress-critic bound a
fallback: a scoped analogist consult on this bridge BEFORE another prover round. I am about to
either (a) blueprint a precise buildable sub-lemma `fibre_pullback_snd_over_rational_point` and
hand it to a prover, or (b) if you find an existing Mathlib result, point the prover straight at it.

## Hints (optional)
The intended math: by `Scheme.Pullback.carrierEquiv`, a point of `X ×_{Spec k̄} Y` over `y₀pt` is
a `Triplet (x, y₀pt, pt∈Spec k̄)` plus a point of `Spec(κ(x) ⊗_{κ(s)} κ(y₀pt))`. Since
`κ(s) = κ(y₀pt) = k̄` (the latter because `y₀.left` is a section of `Y.hom`), the tensor is
`κ(x) ⊗_{k̄} k̄ ≅ κ(x)`, a field, so `Spec` of it is a single point — the fibre point is determined
by its `X`-coordinate `x`, and that point is `s x`. The three sub-questions:
(a) does Mathlib give `κ(y₀pt) = k̄` (residue field at a rational point / image of a section over
the base field) idiomatically? (b) `Subsingleton (Spec (κ(x) ⊗_{k̄} k̄))` from "tensoring a field
with the base field over itself stays a field/single point" — what's the idiom? (c) feeding that
through `carrierEquiv` to land `= s x`. Also: does Mathlib have any "base change of a scheme along
a field extension; fibre over a rational point = source" lemma in the `Scheme.Pullback` /
`Scheme.Hom.fiber` / `AlgebraicGeometry.Pullback` area, perhaps phrased via `Spec.map` of a
residue-field inclusion? Cross-check `AlgebraicGeometry.Scheme.Pullback`, `Mathlib.AlgebraicGeometry.Fiber`,
`AlgebraicGeometry.residueField`.

## Severity expectation
high-stakes
