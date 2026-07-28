/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.SchemeKrullDimStalk

/-!
# Krull dimension is at most embedding dimension — the `≤` half in cotangent currency

## What this changes, and the measurement it corrects

`Picard/Pic0Dimension.lean` states `dim Pic⁰_{C/k} = g` against a hypothesis

```
hle : ∀ z, ringKrullDim (stalk z) ≤ (genus C : WithBot ℕ∞)
```

and its docstring records that direction as **genuinely absent**, having measured
`Albanese/StandardSmoothDimension.lean` and found "only *lower* bounds, and only
at *maximal* ideals". That measurement was of the wrong quantity. It looked for a
bound on `ringKrullDim` in terms of a presentation; what the tangent-space leg of
this chapter actually produces is a **cotangent** dimension, and the passage from
one to the other is unconditional:

```
ringKrullDim R ≤ dim_{κ} (m/m²)      for every Noetherian local ring R
```

with **no regularity hypothesis and no condition on the residue field**. Both
halves are already in the pinned mathlib and neither was used in this project
(`spanFinrank` appears in exactly one AJC file, for an unrelated purpose):

* `ringKrullDim_le_spanFinrank_maximalIdeal` — Krull's height theorem, in the form
  `dim R ≤ (minimal number of generators of m)`;
* `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace` — Nakayama,
  identifying that generator count with `dim_{κ(R)} (m/m²)`.

Equality is the regular case (`IsRegularLocalRing.iff_finrank_cotangentSpace`), and
that is the *only* form the project had. The inequality is what a dimension **upper**
bound needs, and it holds everywhere.

## Why this matters for the `PerfectField` binder

`Pic0.genus_le_topologicalKrullDim_of_smooth` and
`Pic0.topologicalKrullDim_eq_genus_of_forall_ringKrullDim_stalk_le` both carry
`[PerfectField k]`, inherited from
`Scheme.isRegularLocalRing_stalk_of_smooth_of_perfectField` — the only route this
tree has from smoothness to a regular stalk, and its upstream input
`isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`
carries `[PerfectField k]` in its own signature, so the binder is not removable
there. Under the standing owner decision (inbox I-0491) the Jacobian headline is
stated over an **arbitrary** field, so any `PerfectField` on this leg is a real
gap and not a stylistic one.

The results below do **not** close that gap for the `≥` direction, and this file
claims nothing about it: `≥` genuinely needs regularity at the identity, because it
turns an embedding dimension into a *lower* bound on the Krull dimension and that
implication is false in general (a cusp has embedding dimension `2` and dimension
`1`). What they do is make the `≤` direction free of both `PerfectField` and
regularity — so of the two directions of `dim Pic⁰ = g`, the one previously called
"genuinely absent" is now the one with no side conditions at all.

## Main results

* `ringKrullDim_le_finrank_cotangentSpace` — the ring-level inequality.
* `Scheme.ringKrullDim_stalk_le_finrank_cotangentSpace` — at a scheme point.
* `Scheme.topologicalKrullDim_le_of_forall_finrank_cotangentSpace_le` — the `≤`
  half of a dimension computation, in cotangent currency, for any locally
  Noetherian scheme.
* `Scheme.topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_le_of_regular` —
  the two halves combined: a uniform cotangent bound at every point plus a
  regular point where the cotangent dimension is exactly `d`.
-/

universe u

open AlgebraicGeometry Order IsLocalRing CategoryTheory

/-- **The Krull dimension of a Noetherian local ring is at most its embedding
dimension** — `dim R ≤ dim_{κ(R)} (m/m²)`, with no regularity hypothesis and no
condition on the residue field.

Two mathlib facts, composed:

* `ringKrullDim_le_spanFinrank_maximalIdeal` (Krull's height theorem) bounds the
  dimension by the minimal number of generators of the maximal ideal;
* `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace` (Nakayama)
  identifies that count with the `κ(R)`-dimension of the cotangent space.

Regularity is exactly the case of *equality*
(`IsRegularLocalRing.iff_finrank_cotangentSpace`), which is the only form this
project had; the inequality holds always, and it is the direction an upper bound on
dimension needs. The converse inequality is **false** without regularity — a cusp
`k[x,y]/(y²-x³)` localised at the origin has embedding dimension `2` and dimension
`1` — which is why the `≥` half of a dimension computation still needs a regular
point and this one does not. -/
theorem ringKrullDim_le_finrank_cotangentSpace
    (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R] :
    ringKrullDim R ≤ ((Module.finrank (ResidueField R) (CotangentSpace R) : ℕ) : WithBot ℕ∞) := by
  rw [← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace R]
  exact ringKrullDim_le_spanFinrank_maximalIdeal R

namespace AlgebraicGeometry.Scheme

/-- **At a point of a locally Noetherian scheme, the stalk's Krull dimension is at
most its embedding dimension.** The scheme-level form of
`ringKrullDim_le_finrank_cotangentSpace`; the stalk of a locally Noetherian scheme
is a Noetherian local ring, which is the only instance input. -/
theorem ringKrullDim_stalk_le_finrank_cotangentSpace
    (X : Scheme.{u}) [IsLocallyNoetherian X] (z : X) :
    ringKrullDim (X.presheaf.stalk z)
      ≤ ((Module.finrank (ResidueField (X.presheaf.stalk z))
            (CotangentSpace (X.presheaf.stalk z)) : ℕ) : WithBot ℕ∞) :=
  ringKrullDim_le_finrank_cotangentSpace _

/-- **The `≤` half of a dimension computation, in cotangent currency.** If the
cotangent space at every point of a locally Noetherian scheme has dimension at most
`d`, then `dim X ≤ d`.

This is the statement `Pic0.topologicalKrullDim_eq_genus_of_forall_ringKrullDim_stalk_le`
wanted and could not get from a presentation: it asks for a bound on the *same*
invariant the tangent-space leg computes, rather than on `ringKrullDim` directly, and
it needs no regularity anywhere. -/
theorem topologicalKrullDim_le_of_forall_finrank_cotangentSpace_le
    (X : Scheme.{u}) [IsLocallyNoetherian X] (d : ℕ)
    (h : ∀ z : X, Module.finrank (ResidueField (X.presheaf.stalk z))
      (CotangentSpace (X.presheaf.stalk z)) ≤ d) :
    topologicalKrullDim X ≤ (d : WithBot ℕ∞) :=
  topologicalKrullDim_le_of_forall_ringKrullDim_stalk_le X _ fun z =>
    le_trans (ringKrullDim_stalk_le_finrank_cotangentSpace X z)
      (by exact_mod_cast Nat.cast_le.mpr (h z))

/-- **A dimension computation entirely in cotangent currency.** A uniform bound
`dim_κ (m_z/m_z²) ≤ d` at every point, together with **one** point `z₀` that is
regular and has cotangent dimension exactly `d`, gives `dim X = d`.

The asymmetry between the two hypotheses is the mathematics, not an artefact:

* the `≤` half is unconditional (`ringKrullDim_le_finrank_cotangentSpace`);
* the `≥` half needs `z₀` **regular**, since it converts an embedding dimension into
  a lower bound on the Krull dimension, and without regularity that is false — at a
  cusp the embedding dimension exceeds the dimension.

For `Pic⁰_{C/k}` the distinguished point is the identity, where the tangent-space
identity of this chapter supplies `d = g(C)`. -/
theorem topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_le_of_regular
    (X : Scheme.{u}) [IsLocallyNoetherian X] (d : ℕ)
    (h : ∀ z : X, Module.finrank (ResidueField (X.presheaf.stalk z))
      (CotangentSpace (X.presheaf.stalk z)) ≤ d)
    (z₀ : X) (hreg : IsRegularLocalRing (X.presheaf.stalk z₀))
    (hz₀ : Module.finrank (ResidueField (X.presheaf.stalk z₀))
      (CotangentSpace (X.presheaf.stalk z₀)) = d) :
    topologicalKrullDim X = (d : WithBot ℕ∞) :=
  le_antisymm (topologicalKrullDim_le_of_forall_finrank_cotangentSpace_le X d h)
    (le_topologicalKrullDim_of_finrank_cotangentSpace X d z₀ hreg hz₀)

end AlgebraicGeometry.Scheme
