/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Albanese.CoheightBridge
import Mathlib

/-!
# Topological Krull dimension of a scheme from its stalks

This file supplies the bridge that the dimension leg of the Jacobian A.3 story
was recorded as *missing*: a way to compute `topologicalKrullDim X` for a scheme
`X` out of local data at the points of `X`.

The recorded price (see `Picard/IdentityComponent.lean`, `finrank_eq_genus`, and
the same analysis at `Jacobian.lean`) was that mathlib v4.31 has essentially no
API for `topologicalKrullDim` — only `IsHomeomorph.topologicalKrullDim_eq`,
`IsInducing.topologicalKrullDim_le`, `topologicalKrullDim_subspace_le`,
`topologicalKrullDim_zero_of_discreteTopology` and
`PrimeSpectrum.topologicalKrullDim_eq_ringKrullDim`, none of which connects the
invariant to a tangent-space dimension; the suggested route ran through
`Algebra.IsStandardSmoothOfRelativeDimension` and an affine-local presentation.

That analysis measured the wrong side of the problem. `topologicalKrullDim` is
*by definition* the order-theoretic `krullDim` of the poset of irreducible closed
subsets, and for a scheme that poset is order-isomorphic to the space itself
(`irreducibleSetEquivPoints`, since a scheme is sober and `T0`). Under that
isomorphism mathlib's `Order.krullDim_eq_iSup_coheight` turns the dimension into
a supremum of coheights, and this project already owns
`Scheme.ringKrullDim_stalk_eq_coheight` (`Albanese/CoheightBridge.lean`) which
identifies each coheight with the Krull dimension of a stalk. So the dimension of
a scheme is the supremum of the Krull dimensions of its stalks — and no
standard-smooth presentation is required.

## Main results

* `Scheme.topologicalKrullDim_eq_iSup_ringKrullDim_stalk` — the general identity
  `dim X = ⨆ z, dim 𝒪_{X,z}`, for **any** scheme.
* `Scheme.topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq` — the constant
  case, which is the one a homogeneous space (a group scheme) lands in.
* `Scheme.topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_eq` — the same
  with the stalk dimension replaced by the cotangent-space dimension, valid at
  regular points. This is the shape the tangent-space computation
  `dim_k T₀ = g` feeds.
-/

universe u

open AlgebraicGeometry Order TopologicalSpace CategoryTheory

namespace AlgebraicGeometry.Scheme

/-- **The topological Krull dimension of a scheme is the supremum of the Krull
dimensions of its stalks.**

Proof in three moves, none of them geometric:

* `topologicalKrullDim X` is `krullDim (IrreducibleCloseds X)` by definition;
* a scheme is sober and `T0`, so `irreducibleSetEquivPoints` is an order
  isomorphism `IrreducibleCloseds X ≃o X` (for the specialisation order), and
  `Order.krullDim_eq_of_orderIso` transports the dimension to the carrier;
* `Order.krullDim_eq_iSup_coheight` writes that as `⨆ z, coheight z`, and the
  project's `Scheme.ringKrullDim_stalk_eq_coheight` replaces each coheight by
  `ringKrullDim (X.presheaf.stalk z)`.

This is the missing bridge referred to at `Picard/IdentityComponent.lean`'s
`finrank_eq_genus`: it connects `topologicalKrullDim` to *local* data, which is
what any tangent-space computation produces. -/
theorem topologicalKrullDim_eq_iSup_ringKrullDim_stalk (X : Scheme.{u}) :
    topologicalKrullDim X = ⨆ (z : X), ringKrullDim (X.presheaf.stalk z) := by
  have h : topologicalKrullDim X = ⨆ (z : X), (Order.coheight z : WithBot ℕ∞) := by
    unfold topologicalKrullDim
    rw [Order.krullDim_eq_of_orderIso (irreducibleSetEquivPoints (α := X))]
    exact Order.krullDim_eq_iSup_coheight
  rw [h]
  exact iSup_congr fun z => (ringKrullDim_stalk_eq_coheight X z).symm

/-- **A scheme all of whose stalks have Krull dimension `d` has dimension `d`.**

The specialisation of `topologicalKrullDim_eq_iSup_ringKrullDim_stalk` to a
*constant* stalk dimension. `Nonempty X` is genuinely needed: over an empty
scheme the supremum is `⊥`, not `d`.

This is the case a group scheme lands in, since translation by a point is an
isomorphism, so all stalks of a group scheme over a field are isomorphic. -/
theorem topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq
    (X : Scheme.{u}) [Nonempty X] (d : WithBot ℕ∞)
    (h : ∀ z : X, ringKrullDim (X.presheaf.stalk z) = d) :
    topologicalKrullDim X = d := by
  rw [topologicalKrullDim_eq_iSup_ringKrullDim_stalk X]
  simp [h]

/-- **Dimension from the cotangent spaces, at regular points.**

If every stalk of `X` is a regular local ring of embedding dimension `d`, then
`dim X = d`. The step from the cotangent space to the Krull dimension of the
stalk is mathlib's `IsRegularLocalRing.iff_finrank_cotangentSpace`, which needs
the stalk Noetherian — supplied here by `[IsLocallyNoetherian X]`, which for a
scheme locally of finite type over a field is free
(`LocallyOfFiniteType.isLocallyNoetherian`).

This is the form the tangent-space identity `dim_k T₀ Pic⁰ = g` plugs into: the
cotangent space at a point is the linear dual of the tangent space there, and the
regularity hypothesis is exactly what smoothness supplies. -/
theorem topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_eq
    (X : Scheme.{u}) [Nonempty X] [IsLocallyNoetherian X] (d : ℕ)
    (hreg : ∀ z : X, IsRegularLocalRing (X.presheaf.stalk z))
    (h : ∀ z : X, Module.finrank (IsLocalRing.ResidueField (X.presheaf.stalk z))
      (IsLocalRing.CotangentSpace (X.presheaf.stalk z)) = d) :
    topologicalKrullDim X = (d : WithBot ℕ∞) := by
  refine topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq X _ fun z => ?_
  haveI := hreg z
  rw [← (IsRegularLocalRing.iff_finrank_cotangentSpace (R := X.presheaf.stalk z)).mp (hreg z),
    h z]

end AlgebraicGeometry.Scheme
