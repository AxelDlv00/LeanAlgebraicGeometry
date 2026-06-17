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

## Status (iter-130 fix-up: body replaced with chart-base-change Replacement (B))

`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` is fully constructed
(no `sorry`). The iter-128 body (presheaf evaluated at the top open then
extended scalars to `k`) was found in iter-129 to compute the zero
`k`-module for every `G` in the target class with `n ≥ 1` (`Spec` of a
field is a single point, so the pulled-back presheaf collapses to `k`
and the Kähler module of the identity `k → k` is zero). The iter-130
fix-up replaces it with **Replacement (B): affine-chart base change** —
extract an affine chart `V ⊆ G.left` around the identity-section image
on which the algebraic Kähler module is free of rank `n` (via
`Scheme.smooth_locally_free_omega`), then base-change to `k` along the
identity section restricted to `V`. The signature, set in iter-129
(free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder), is preserved.
The iter-129+ rank lemma `cotangentSpaceAtIdentity_finrank_eq` lives in
a follow-up declaration (not in this file).

## References

- Blueprint chapter: `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i)".
- Analogist source-of-truth: `analogies/lieAlgebra-rank-bridge.md`
  (Replacement (B) construction; iter-130 prover lane closure chain).
- Project infrastructure consumed:
  `AlgebraicGeometry.Scheme.smooth_locally_free_omega`
  (in `AlgebraicJacobian.Differentials`).
- Mathlib `GrpObj` API: `Mathlib.CategoryTheory.Monoidal.Grp_`,
  `Mathlib.AlgebraicGeometry.Group.Smooth`.
- Mathlib Kähler / standard-smooth pieces (consumed via
  `smooth_locally_free_omega`):
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
  `Algebra.IsStandardSmooth.free_kaehlerDifferential`.
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

Mathematically: the base change to `k` of the algebraic Kähler module
`Ω[Γ(G, V) / Γ(Spec k, U)]` of a smooth affine chart `V ⊆ G.left` around
the identity-section image. By the forward Jacobian criterion
(`Scheme.smooth_locally_free_omega`, consuming
`Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`),
this Kähler module is free of rank `n` over `Γ(G, V)`, hence its base
change is a finitely-generated free `k`-module of rank `n`; the
iter-129+ companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (in
a follow-up declaration) pins the rank to `n` from the
`[SmoothOfRelativeDimension n G.hom]` instance.

The bracket / Lie-algebra structure is NOT packaged here — only the
underlying `k`-module is needed for the rigidity argument. Downstream
consumers that need the dual tangent space `𝔤` may take
`Module.Dual k (cotangentSpaceAtIdentity G)`.

**Construction (iter-130 prover lane; Replacement (B), affine-chart base
change).** The body is built as follows:
1. The identity section `η_G : 𝟙_ ⟶ G` of the `GrpObj` structure gives
   a scheme morphism `ηleft : Spec k ⟶ G.left` (using the definitional
   identification `(𝟙_ (Over (Spec (.of k)))).left = Spec (.of k)`).
2. Take `x₀ := ηleft default ∈ G.left`, the image of the unique point of
   `Spec (.of k)` (which is a singleton because `k` is a field, so
   `PrimeSpectrum k` is `Unique`).
3. By `Scheme.smooth_locally_free_omega` (forward Jacobian criterion,
   project lemma in `AlgebraicJacobian.Differentials`), there exists an
   affine open `V ⊆ G.left` containing `x₀`, an affine open `U ⊆ Spec k`
   with `V ≤ G.hom⁻¹U`, and the `appLE` algebra
   `Γ(Spec k, U) → Γ(G, V)` exhibits `Ω[Γ(G, V) / Γ(Spec k, U)]` as a
   free `Γ(G, V)`-module of rank `n`.
4. Restricting `ηleft` to `V` yields a ring map
   `ηleft.appLE V ⊤ _ : Γ(G, V) → Γ(Spec k, ⊤)`; composing with the
   canonical iso `Γ(Spec k, ⊤) ≅ k` (`Scheme.ΓSpecIso`) gives
   `ψV : Γ(G, V) ⟶ CommRingCat.of k`.
5. Extension of scalars from `Γ(G, V)` to `k` along `ψV` of the algebraic
   Kähler module gives the cotangent space at the identity as a
   `k`-module.

**Caveat on canonicity.** The body depends on a chart `V` extracted via
`Classical.choice` from the existential statement of
`smooth_locally_free_omega`; it is therefore not canonically attached to
`G` in the strictest sense. For the live consumer (rigidity over `k`,
via `rigidity_over_kbar`), the existence of a rank-`n` free `k`-module
is the only structural content needed, so canonicity is not load-bearing.
A canonical (chart-independent) presentation via the stalk-side cotangent
`𝔪 / 𝔪²` is the content of the blueprint's
`lem:GrpObj_cotangent_bridge` (deferred to iter-130+).

This compiles to a `ModuleCat k` with no `sorry`. The structural
properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are content
for the iter-129+ rank lemma. -/
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom] :
    ModuleCat k := by
  classical
  -- Identity section `η_G : 𝟙_ ⟶ G`; on schemes this is `Spec k ⟶ G.left`.
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  -- Image in `G.left` of the unique point of `Spec (.of k)` (`Spec` of a field).
  let x₀ : G.left := (ConcreteCategory.hom ηleft.base) default
  -- The Prop-level existential `smooth_locally_free_omega` cannot be
  -- `obtain`-destructured directly inside a `Type`-valued definition, so we
  -- pass through `Classical.choice` on a `Nonempty (ModuleCat k)` witness.
  refine Classical.choice (α := ModuleCat k) ?_
  -- Extract a smooth affine chart `V ⊆ G.left` around `x₀` on which `Ω` is
  -- free of rank `n` over the algebra `Γ(Spec k, U) → Γ(G.left, V)`
  -- (forward Jacobian criterion, project lemma `smooth_locally_free_omega`).
  obtain ⟨U, V, e, hxV, _hU, _hV, _hfree, _hrank⟩ :=
    Scheme.smooth_locally_free_omega (n := n) G.hom x₀
  -- The pre-image of `V` under `ηleft` is all of `Spec (.of k)`, since
  -- `Spec` of a field has a unique point and that point lies in `V`.
  have htop : (⊤ : (Spec (.of k)).Opens) ≤ ηleft ⁻¹ᵁ V := by
    intro s _
    rw [Scheme.Hom.mem_preimage]
    rw [show s = default from Subsingleton.elim _ _]
    exact hxV
  -- Ring map `ψV : Γ(G.left, V) ⟶ k` from the identity section restricted to
  -- `V`, composed with the canonical iso `Γ(Spec k, ⊤) ≅ k`.
  let ψV : Γ(G.left, V) ⟶ CommRingCat.of k :=
    ηleft.appLE V ⊤ htop ≫ (Scheme.ΓSpecIso (.of k)).hom
  -- Equip `Γ(G.left, V)` with the `Γ(Spec k, U)`-algebra structure from
  -- `appLE` on `G.hom`.
  letI : Algebra ↥Γ(Spec (.of k), U) ↥Γ(G.left, V) :=
    (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
  -- Body: base-change the algebraic Kähler module `Ω[Γ(G.left, V) / Γ(Spec k, U)]`
  -- from `Γ(G.left, V)` to `k` along `ψV`. By `smooth_locally_free_omega`
  -- (consuming `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`)
  -- this Kähler module is free of rank `n` over `Γ(G.left, V)`, hence its
  -- base change is free of rank `n` over `k`.
  exact ⟨(ModuleCat.extendScalars ψV.hom).obj
    (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])⟩

end AlgebraicGeometry.GrpObj
