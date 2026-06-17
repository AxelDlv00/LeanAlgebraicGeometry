/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Jacobian

/-!
# Rigidity for morphisms of group schemes (Mumford §4)

A self-contained Phase E helper: a morphism between proper smooth geometrically
irreducible group schemes that agrees with another on a non-empty open subscheme
of the source agrees everywhere. Independent of `AlgebraicGeometry.Jacobian C`
and provable from current Mathlib alone (Stacks 0BFD plus standard
properness/separatedness/irreducibility lemmas).

See `blueprint/src/chapters/Rigidity.tex`.

## Status (iteration 002 — refactor scaffold)

This file is a scaffold. The body of `eq_of_eqOnOpen` is `sorry`. Subsequent
prover iterations are responsible for filling this sorry (Phase E of
`STRATEGY.md`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {k : Type u} [Field k]

/-!
## Hypothesis correction (iter 003 prover)

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

The unused `[GrpObj X]`, `[GrpObj Y]`, `[SmoothOfRelativeDimension n X.hom]`,
`[SmoothOfRelativeDimension m Y.hom]`, `[IsProper X.hom]`,
`[GeometricallyIrreducible Y.hom]` hypotheses are kept to preserve the
declaration's "abelian-variety" intent and forward-compatibility with the
informal Mumford-rigidity statement; they are now redundant with the
strengthened hypothesis.

See `task_results/Rigidity.lean.md` for the full discussion.
-/

/-- Rigidity for morphisms of (group) schemes (corrected, scheme-level form):
two morphisms `g₁, g₂ : X ⟶ Y` between schemes over `Spec k` whose restrictions
to a non-empty open `U ⊆ X` agree as scheme morphisms — and where `X` is
reduced and irreducible and `Y` is separated over `Spec k` — agree everywhere.

The standard Mumford statement (a morphism vanishing on a non-empty open is
zero) is interderivable using the group law on the target. -/
theorem GrpObj.eq_of_eqOnOpen
    {n m : ℕ}
    {X Y : Over (Spec (.of k))}
    [SmoothOfRelativeDimension n X.hom] [IsProper X.hom]
    [GeometricallyIrreducible X.hom] [GrpObj X]
    [SmoothOfRelativeDimension m Y.hom] [IsProper Y.hom]
    [GeometricallyIrreducible Y.hom] [GrpObj Y]
    [IsReduced X.left]
    (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
    (h : (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₁.left =
      (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₂.left) :
    g₁ = g₂ := by
  -- (1) `Y.hom` is separated, since `IsProper` extends `IsSeparated`.
  haveI : IsSeparated Y.hom := IsProper.toIsSeparated
  -- (2) `X.left` is irreducible: `Spec k` is a single point (`Unique`,
  --     hence `Subsingleton + Nonempty`), and `GeometricallyIrreducible`
  --     over a subsingleton base implies `IrreducibleSpace`.
  haveI : IrreducibleSpace X.left :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton X.hom
  -- (3) `U.ι : U.toScheme ⟶ X.left` is dominant: its set-theoretic range
  --     equals `U`, which is a non-empty open in an irreducible space.
  haveI : IsDominant (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) := by
    rw [isDominant_iff]
    have hrange : Set.range (U.ι : (U : X.left.Opens).toScheme ⟶ X.left).base.hom =
        (U : Set X.left) := by
      simpa using U.range_ι
    rw [hrange]
    exact IsOpen.dense U.isOpen hU
  -- (4) Promote `g₁ = g₂` from the underlying scheme equality.
  --     The `Scheme.Over` and `IsOver` instances for `X.left`, `Y.left`,
  --     `g₁.left`, `g₂.left` over `Spec (.of k)` are inferred globally
  --     from the `Over (Spec (.of k))` category structure
  --     (`OverClass.fromOver`).
  refine Over.OverMorphism.ext ?_
  exact ext_of_isDominant_of_isSeparated' (S := Spec (.of k))
    (X := X.left) (Y := Y.left) (f := g₁.left) (g := g₂.left) U.ι h

end AlgebraicGeometry
