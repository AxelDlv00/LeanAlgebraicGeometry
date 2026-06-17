/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Differentials
import Mathlib.Algebra.Category.ModuleCat.ChangeOfRings
import Mathlib.AlgebraicGeometry.Group.Smooth
import Mathlib.AlgebraicGeometry.Morphisms.Proper
import Mathlib.AlgebraicGeometry.Geometrically.Irreducible

/-!
# Lie algebra of a group scheme at the identity

The Lie algebra of a smooth proper geometrically irreducible group scheme
`G` over a base field `k`, defined as a `k`-vector space, via the pullback
of the relative cotangent presheaf `Ω_{G/k}` along the identity section
`η_G : 𝟙_ ⟶ G`.

This is piece (i.a) of the shared cotangent-vanishing pile (see
`blueprint/src/chapters/RigidityKbar.tex` § "Piece (i): sub-lemma
decomposition for iter-128+ build" and STRATEGY.md § M2.body-pile).

The companion rank lemma `lieAlgebra_finrank_eq_dim` (rank = relative
dimension `n` from `[SmoothOfRelativeDimension n G.hom]`) is deferred
to iter-129+ for blueprint-RHS-pinning work; not in this file.

## Status (iter-128 scaffold)

The declaration `AlgebraicGeometry.GrpObj.lieAlgebra` is scaffolded with
a single `sorry` body. The iter-128 prover lane attempts the body
construction; iter-129+ resolves any fallback per the iter-129 fallback
rule in `.archon/iter/iter-128/plan.md`.

## References

- Blueprint chapter: `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i)".
- Project infrastructure consumed:
  `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf`
  (in `AlgebraicJacobian.Differentials`).
- Mathlib `GrpObj` API: `Mathlib.CategoryTheory.Monoidal.Grp_`,
  `Mathlib.AlgebraicGeometry.Group.Smooth`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry.GrpObj

variable {k : Type u} [Field k]

/-- The Lie algebra of a smooth proper geometrically irreducible group scheme
`G` over `k`, as a `k`-vector space (returned as `ModuleCat k`).

Mathematically: the `k`-linear dual of `η_G^* Ω_{G/k}`, the cotangent space
at the identity section. By smoothness of `G` at `η_G`, the cotangent space
is a finitely-generated free `k`-module; the dual inherits the same
structure.

The bracket / Lie-algebra structure on `lieAlgebra G` is NOT packaged here
— only the underlying `k`-module is needed for the rigidity argument.

**Status**: iter-128 scaffold — body is `sorry`. The iter-128 prover lane
attempts the construction. See `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i)". -/
noncomputable def lieAlgebra (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] [SmoothOfRelativeDimension 1 G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
  sorry

end AlgebraicGeometry.GrpObj
