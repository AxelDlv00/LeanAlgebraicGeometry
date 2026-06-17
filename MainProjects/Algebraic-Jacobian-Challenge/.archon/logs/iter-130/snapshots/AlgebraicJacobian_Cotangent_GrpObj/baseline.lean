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
# Cotangent space at the identity of a group scheme

The cotangent space at the identity of a smooth proper geometrically
irreducible group scheme `G` over a base field `k`, defined as a
`k`-vector space, via the pullback of the relative cotangent presheaf
`Ω_{G/k}` along the identity section `η_G : 𝟙_ ⟶ G`.

This is piece (i.a) of the shared cotangent-vanishing pile (see
`blueprint/src/chapters/RigidityKbar.tex` § "Piece (i): sub-lemma
decomposition for iter-128+ build" and STRATEGY.md § M2.body-pile).

The companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (rank =
relative dimension `n` from `[SmoothOfRelativeDimension n G.hom]`) is
deferred to iter-129+ for blueprint-RHS-pinning work; not in this file.

## Status (iter-129 fix-up: signature relaxed + renamed; iter-128 body preserved)

`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (renamed from the
iter-128 `lieAlgebra`) is fully constructed (no `sorry`) via the
pullback-along-section bridge described in the declaration's
docstring. The signature has been relaxed from a hardcoded relative
dimension `1` to a free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`
binder, so the same definition serves any group scheme (including the
abelian-variety consumer `rigidity_over_kbar` of arbitrary relative
dimension `g`). The iter-129+ rank lemma
`cotangentSpaceAtIdentity_finrank_eq` lives in a follow-up declaration
(not in this file).

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
open TopologicalSpace Opposite

namespace AlgebraicGeometry.GrpObj

variable {k : Type u} [Field k]

/-- The **cotangent space at the identity** of a smooth proper geometrically
irreducible group scheme `G` over `k`, as a `k`-vector space (returned as
`ModuleCat k`).

Mathematically: `η_G^* Ω_{G/k}`, the pullback of the relative cotangent
sheaf along the identity section. By smoothness of `G` at `η_G` this is
a finitely-generated free `k`-module of rank equal to the relative
dimension of `G.hom`; the iter-129+ companion rank lemma
`cotangentSpaceAtIdentity_finrank_eq` (in a follow-up declaration) pins
the rank to `n` from the `[SmoothOfRelativeDimension n G.hom]` instance.

The Lie algebra `𝔤` of `G` (the tangent space at the identity) is the
`k`-linear dual of this module; downstream consumers that need `𝔤` may
take `Module.Dual k (cotangentSpaceAtIdentity G)`. We do not dualise here
because the rigidity argument is symmetric under dualisation (only the
finite-rank-free claim is consumed) and the un-dualised form is the
direct output of the pullback-along-section construction.

The bracket / Lie-algebra structure is NOT packaged here — only the
underlying `k`-module is needed for the rigidity argument.

**Construction (iter-128 prover lane; signature relaxed iter-129).**
The body uses the pullback-along-section bridge:
1. The identity section `η_G : 𝟙_ ⟶ G` of the `GrpObj` structure gives
   a scheme morphism `η_G.left : Spec k ⟶ G.left` (using the definitional
   identification `(𝟙_ (Over (Spec (.of k)))).left = Spec (.of k)`).
2. Sections on the top open give a commutative ring map
   `Γ(G.left, ⊤) ⟶ Γ(Spec k, ⊤)`; composing with the canonical iso
   `Γ(Spec k, ⊤) ≅ k` (`Scheme.ΓSpecIso`) yields
   `ψ : Γ(G.left, ⊤) ⟶ CommRingCat.of k`.
3. `relativeDifferentialsPresheaf G.hom` evaluated at the top open
   yields a `Γ(G.left, ⊤)`-module, the module of global relative
   differentials of `G/k`.
4. Extension of scalars along `ψ` to `k` (i.e. tensoring with `k`
   over `Γ(G.left, ⊤)`) gives the cotangent space at the identity
   section as a `k`-module.

This compiles to a `ModuleCat k` with no `sorry`. The structural
properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are
content for the iter-129+ rank lemma. -/
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
  -- Identity section `η_G : 𝟙_ ⟶ G`; on schemes this is `Spec k ⟶ G.left`.
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  -- Ring map `Γ(G.left, ⊤) ⟶ k` from sections of the identity section,
  -- composed with the `Γ(Spec k, ⊤) ≅ k` adjunction iso.
  let ψ : Γ(G.left, ⊤) ⟶ CommRingCat.of k :=
    ηleft.appTop ≫ (Scheme.ΓSpecIso (.of k)).hom
  -- Relative cotangent presheaf evaluated at the top open of `G`.
  let M := Scheme.relativeDifferentialsPresheaf G.hom
  -- Extend scalars from `Γ(G.left, ⊤)` to `k` along `ψ`; this is the
  -- global-sections form of `η_G^* Ω_{G/k}`.
  (ModuleCat.extendScalars ψ.hom).obj (M.obj (op ⊤))

end AlgebraicGeometry.GrpObj
