/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Jacobian

/-!
# Rigidity for morphisms of schemes (scheme-level form)

A self-contained Phase E helper: two morphisms `g₁, g₂ : X ⟶ Y` between
schemes over `Spec k` whose restrictions to a non-empty open `U ⊆ X` agree
as scheme morphisms — for `X` reduced and geometrically irreducible over
`Spec k` and `Y` separated over `Spec k` — agree everywhere. Independent of
`AlgebraicGeometry.Jacobian C` and provable from current Mathlib alone
(Stacks 0BFD plus standard separatedness/irreducibility lemmas).

The historical motivation is Mumford's §4 rigidity for morphisms of group
schemes; the formalized statement is the minimal-hypothesis scheme-level
form, which the Mumford group-scheme rigidity follows from by specialization.

See `blueprint/src/chapters/Rigidity.tex`.

## Status

`Scheme.Over.ext_of_eqOnOpen` — rigidity of morphisms agreeing as scheme
maps on a non-empty open of a reduced (geometrically) irreducible source
with separated target — is closed. See the "Hypothesis history" block below
for the discussion of why the original point-wise hypothesis was
strengthened to scheme-level equality on `U`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {k : Type u} [Field k]

/-!
## Hypothesis history

### Scheme-level hypothesis (iter 003)

The original scaffold from iter 002 had hypothesis
`h : ∀ x ∈ U, g₁.left.base x = g₂.left.base x`
(point-wise topological equality on `U`). This is too weak: in characteristic
`p`, the absolute Frobenius `F : X → X` of an elliptic curve over `𝔽_p` agrees
topologically with the identity on all of `X` (the identity on the underlying
topological space) but `F ≠ id` as scheme morphisms — they differ on stalks
(`a ↦ a` vs `a ↦ a^p`). Hence the symmetric-form rigidity statement
`g₁.base = g₂.base on U ⇒ g₁ = g₂` is mathematically false.

We strengthen the hypothesis to scheme-level equality on `U`:
`h : U.ι ≫ g₁.left = U.ι ≫ g₂.left`. This is the version that is actually
needed at the use site (uniqueness half of `exists_unique_ofCurve_comp`):
the application produces *scheme-level* agreement on a non-empty open
(through the symmetric-power surjection), not merely topological agreement.

We also add `[IsReduced X.left]` because Mathlib `b80f227` lacks the lemma
`Smooth ⇒ IsReduced` for schemes over a field (the closest is the perfect-base
case `Scheme.Hom.dense_smoothLocus_of_perfectField`). This is a small Mathlib
gap that the downstream consumer must satisfy via the smoothness + irreducibility
of the curve / Jacobian (e.g. via `IsIntegral`).

### Unused-hypothesis cleanup (iter 125)

Eight decorative hypotheses (`{n m : ℕ}`, `[SmoothOfRelativeDimension n X.hom]`,
`[IsProper X.hom]`, `[GrpObj X]`, `[SmoothOfRelativeDimension m Y.hom]`,
`[GeometricallyIrreducible Y.hom]`, `[GrpObj Y]`, and the strengthening of
`[IsSeparated Y.hom]` to `[IsProper Y.hom]`) were dropped per
`analogies/rigidity-refactor.md`. The declaration was also renamed from
`GrpObj.eq_of_eqOnOpen` to `Scheme.Over.ext_of_eqOnOpen`, mirroring
Mathlib's `ext_of_isDominant_of_isSeparated'` naming idiom
(`Mathlib.AlgebraicGeometry.Morphisms.Separated:319–322`).
-/

/-- Rigidity for morphisms of schemes (scheme-level form): two morphisms
`g₁, g₂ : X ⟶ Y` between schemes over `Spec k` whose restrictions to a
non-empty open `U ⊆ X` agree as scheme morphisms — for `X` reduced and
geometrically irreducible over `Spec k` and `Y` separated over `Spec k` —
agree everywhere.

This is the `Over (Spec (.of k))`-bundled specialization of Mathlib's
`ext_of_isDominant_of_isSeparated'`. The Mumford group-scheme rigidity
statement (a morphism vanishing on a non-empty open is zero) is
interderivable with this form using the group law on the target. -/
theorem Scheme.Over.ext_of_eqOnOpen
    {X Y : Over (Spec (.of k))}
    [IsSeparated Y.hom]
    [GeometricallyIrreducible X.hom]
    [IsReduced X.left]
    (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
    (h : (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₁.left =
      (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₂.left) :
    g₁ = g₂ := by
  -- (1) Provide the separatedness instance under the `OverClass.fromOver`
  --     form `Y.left ↘ Spec (.of k)` so that the downstream typeclass
  --     search at `ext_of_isDominant_of_isSeparated'` finds it.
  haveI : IsSeparated (Y.left ↘ Spec (CommRingCat.of k)) :=
    (‹IsSeparated Y.hom› : IsSeparated Y.hom)
  -- (2) `X.left` is irreducible: `Spec k` is a single point (`Unique`,
  --     hence `Subsingleton + Nonempty`), and `GeometricallyIrreducible`
  --     over a subsingleton base implies `IrreducibleSpace`.
  haveI : IrreducibleSpace X.left :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton X.hom
  -- (3) `U.ι : U.toScheme ⟶ X.left` is dominant: a non-empty open in an
  --     irreducible space is dense, and a dense open immersion is dominant.
  haveI : IsDominant (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) :=
    Scheme.PartialMap.Opens.isDominant_ι (IsOpen.dense U.isOpen hU)
  -- (4) Promote `g₁ = g₂` from the underlying scheme equality.
  --     The `Scheme.Over` and `IsOver` instances for `X.left`, `Y.left`,
  --     `g₁.left`, `g₂.left` over `Spec (.of k)` are inferred globally
  --     from the `Over (Spec (.of k))` category structure
  --     (`OverClass.fromOver`).
  refine Over.OverMorphism.ext ?_
  exact ext_of_isDominant_of_isSeparated' (S := Spec (.of k))
    (X := X.left) (Y := Y.left) (f := g₁.left) (g := g₂.left) U.ι h

end AlgebraicGeometry
