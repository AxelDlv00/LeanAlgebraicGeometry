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
`k`-vector space. Mathematically, this is the pullback of the relative
cotangent sheaf `Ω_{G/k}` along the identity section `η_G : 𝟙_ ⟶ G`;
the iter-130 Lean realisation (Replacement (B), per
`analogies/lieAlgebra-rank-bridge.md`) computes it as the base change to
`k` of the algebraic Kähler module `Ω[Γ(G, V) / Γ(Spec k, U)]` on a
smooth affine chart `V ⊆ G.left` around the identity-section image.

This is piece (i.a) of the shared cotangent-vanishing pile (see
`blueprint/src/chapters/RigidityKbar.tex` § "Piece (i): sub-lemma
decomposition for iter-128+ build" and STRATEGY.md § M2.body-pile).

The companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (rank =
relative dimension `n` from `[SmoothOfRelativeDimension n G.hom]`) is
deferred to iter-129+ for blueprint-RHS-pinning work; not in this file.

## Status (iter-131 fix-up: pure-term body refactor)

`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` is fully constructed
(no `sorry`). The iter-128 body (presheaf evaluated at the top open then
extended scalars to `k`) was found in iter-129 to compute the zero
`k`-module for every `G` in the target class with `n ≥ 1` (`Spec` of a
field is a single point, so the pulled-back presheaf collapses to `k`
and the Kähler module of the identity `k → k` is zero). The iter-130
fix-up replaced it with **Replacement (B): affine-chart base change** —
extract an affine chart `V ⊆ G.left` around the identity-section image
on which the algebraic Kähler module is free of rank `n` (via
`Scheme.smooth_locally_free_omega`), then base-change to `k` along the
identity section restricted to `V`. The iter-130 realisation passed
through `Classical.choice` to bridge `Prop` and `Type`, which left the
elaborated body with `Classical.choice` as its outermost head symbol —
opaque to downstream `unfold`/`whnf`. The **iter-131 fix-up** refactors
the body to a pure-term `noncomputable def`: `let`-bindings of
`Classical.choose`/`.choose_spec` on the `smooth_locally_free_omega`
existential expose `U, V, e, ψV` as named-but-opaque accessors, while
the outer expression is the explicit
`(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`. The
signature, set in iter-129 (free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`
binder), is preserved. The companion rank lemma
`cotangentSpaceAtIdentity_finrank_eq` lives in a follow-up declaration
(not in this file); the iter-131 body shape is the testable deliverable
witnessed by `cotangentSpaceAtIdentity_eq_extendScalars` below.

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

**Caveat on canonicity.** The chart `V` used in the body is extracted
via `Classical.choose` from `smooth_locally_free_omega`'s existential.
The resulting `k`-module is therefore non-canonical *as a value*. What
the iter-131 body refactor guarantees is that the body's **structural
shape** — a base change to `k` of the chart-level Kähler module — is
exposed to downstream consumers: after `unfold cotangentSpaceAtIdentity`
and delta-reduction of the `let`-bindings, the outer head symbol is
`(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])`. This is
formalized as `cotangentSpaceAtIdentity_eq_extendScalars` below, which
the iter-132+ rank lemma can rewrite against. For the live consumer
(rigidity over `k`, via `rigidity_over_kbar`), the existence of a
rank-`n` free `k`-module is the only structural content needed, so
chart-canonicity is not load-bearing. A canonical (chart-independent)
presentation via the stalk-side cotangent `𝔪 / 𝔪²` is the content of
the blueprint's `lem:GrpObj_cotangent_bridge` (deferred to iter-130+).

This compiles to a `ModuleCat k` with no `sorry`. The structural
properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are content
for the iter-132+ rank lemma `cotangentSpaceAtIdentity_finrank_eq`; the
structural-shape accessibility needed by that lemma is witnessed here by
`cotangentSpaceAtIdentity_eq_extendScalars`. -/
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
  -- Identity section `η_G : 𝟙_ ⟶ G`; on schemes this is `Spec k ⟶ G.left`.
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  -- Image in `G.left` of the unique point of `Spec (.of k)` (`Spec` of a field).
  let x₀ : G.left := (ConcreteCategory.hom ηleft.base) default
  -- `Classical.choose`-chain through the `Prop`-level existential output of
  -- `smooth_locally_free_omega`. Each `let` names one component (chart `U`,
  -- chart `V`, the appLE inclusion `e`, and `hxV : x₀ ∈ V`) so the outer
  -- expression below stays in a pure-term shape — no `Classical.choice`
  -- wrapper at the top level (iter-131 body-shape refactor).
  let h := Scheme.smooth_locally_free_omega (n := n) G.hom x₀
  let U : (Spec (.of k)).Opens := h.choose
  let h₁ := h.choose_spec
  let V : G.left.Opens := h₁.choose
  let h₂ := h₁.choose_spec
  let e : V ≤ G.hom ⁻¹ᵁ U := h₂.choose
  let hxV : x₀ ∈ V := h₂.choose_spec.1
  -- The pre-image of `V` under `ηleft` is all of `Spec (.of k)`, since
  -- `Spec` of a field has a unique point and that point lies in `V`.
  let htop : (⊤ : (Spec (.of k)).Opens) ≤ ηleft ⁻¹ᵁ V := fun s _ => by
    rw [Scheme.Hom.mem_preimage, show s = default from Subsingleton.elim _ _]
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
  (ModuleCat.extendScalars ψV.hom).obj
    (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])

/-- Defensive lemma: `cotangentSpaceAtIdentity G` is definitionally equal to its
explicit chart-base-changed Kähler module form. The chart `V`, the algebra
structure, and the Kähler module are opaque (`Classical.choose`-extracted) but
the outer `extendScalars`/`ModuleCat.of`-of-`Ω` form is exposed. This proves
that the iter-131 body refactor closed the iter-130 opacity defect: a
downstream rank lemma can `simp only [cotangentSpaceAtIdentity_eq_extendScalars]`
(combined with a `Classical.choose`-chain `obtain` on the same existential)
to rewrite the body to the explicit form. -/
theorem cotangentSpaceAtIdentity_eq_extendScalars (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ∃ (U : (Spec (.of k)).Opens) (V : G.left.Opens) (e : V ≤ G.hom ⁻¹ᵁ U)
        (htop : (⊤ : (Spec (.of k)).Opens) ≤
          (CategoryTheory.CommaMorphism.left η[G]) ⁻¹ᵁ V),
      letI : Algebra ↥Γ(Spec (.of k), U) ↥Γ(G.left, V) :=
        (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
      (cotangentSpaceAtIdentity (n := n) G : ModuleCat k) =
        (ModuleCat.extendScalars
          ((CategoryTheory.CommaMorphism.left η[G]).appLE V ⊤ htop ≫
            (Scheme.ΓSpecIso (.of k)).hom).hom).obj
          (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)]) := by
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  let x₀ : G.left := (ConcreteCategory.hom ηleft.base) default
  let h := Scheme.smooth_locally_free_omega (n := n) G.hom x₀
  let hxV : x₀ ∈ h.choose_spec.choose := h.choose_spec.choose_spec.choose_spec.1
  refine ⟨h.choose, h.choose_spec.choose, h.choose_spec.choose_spec.choose,
    fun s _ => ?_, rfl⟩
  change (ConcreteCategory.hom ηleft.base) s ∈ h.choose_spec.choose
  rw [show s = default from Subsingleton.elim _ _]
  exact hxV

end AlgebraicGeometry.GrpObj
