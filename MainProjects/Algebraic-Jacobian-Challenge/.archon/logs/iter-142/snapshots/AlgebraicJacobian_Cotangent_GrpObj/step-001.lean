/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Differentials
import Mathlib.Algebra.Category.ModuleCat.ChangeOfRings
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback
import Mathlib.AlgebraicGeometry.Group.Smooth
import Mathlib.AlgebraicGeometry.Morphisms.Proper
import Mathlib.AlgebraicGeometry.Geometrically.Irreducible
import Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced

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

This file contains the definition `cotangentSpaceAtIdentity` below, the
structural-shape acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars`
below, and the companion rank lemma `cotangentSpaceAtIdentity_finrank_eq`
below (rank = relative dimension `n` from
`[SmoothOfRelativeDimension n G.hom]`, closed iter-132).

## Status (iter-132 close: rank lemma)

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
binder), is preserved. The iter-131 body shape is witnessed by
`cotangentSpaceAtIdentity_eq_extendScalars` below.

The **iter-132 prover lane** closed the companion rank lemma
`cotangentSpaceAtIdentity_finrank_eq` (line 244 below) against the
iter-131 body via a parallel `Classical.choose`-chain extraction on
`Scheme.smooth_locally_free_omega`, reducing through
`Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq` to pin the
`k`-finrank of the cotangent space at the identity to the relative
dimension `n` from the `[SmoothOfRelativeDimension n G.hom]` instance.

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
iter-132 companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (at
line 244 below) pins the rank to `n` from the
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
the iter-132 rank lemma `cotangentSpaceAtIdentity_finrank_eq` (line 244
below) rewrites against. For the live consumer
(rigidity over `k`, via `rigidity_over_kbar`), the existence of a
rank-`n` free `k`-module is the only structural content needed, so
chart-canonicity is not load-bearing. A canonical (chart-independent)
presentation via the stalk-side cotangent `𝔪 / 𝔪²` is the content of
the blueprint's `lem:GrpObj_cotangent_bridge` (deferred to iter-130+).

This compiles to a `ModuleCat k` with no `sorry`. The rank (`= n`) is
now pinned by `cotangentSpaceAtIdentity_finrank_eq` (line 244 below;
closed iter-132). The free/finite structural properties
(`Module.Free k`, `Module.Finite k`) are content for follow-up companion
lemmas (not yet in this file); the structural-shape accessibility needed
by those lemmas is witnessed here by
`cotangentSpaceAtIdentity_eq_extendScalars` (line 198 below). -/
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

/-- **Rank lemma for the cotangent space at the identity.**

For a smooth proper geometrically irreducible group scheme `G` over `k` of
relative dimension `n`, the `k`-vector space `cotangentSpaceAtIdentity G` has
`finrank` equal to `n`.

**Proof strategy (per `blueprint/src/chapters/RigidityKbar.tex` §
`lem:GrpObj_lieAlgebra_finrank`, Steps 1+2 live closure path).**

* **Step 1 (chart-side Kähler rank).** Reproduce the iter-131 body's
  `Classical.choose`-chain on `Scheme.smooth_locally_free_omega` to extract
  the same chart witnesses `U`, `V`, `e` plus `hfree : Module.Free Γ(G, V)
  Ω[Γ(G, V) ⁄ Γ(Spec k, U)]` and `hrank : Module.rank ... = n`. Apply
  `Module.finrank_eq_of_rank_eq hrank` to get
  `Module.finrank Γ(G, V) Ω[…] = n`.

* **Step 2 (base-change preserves finrank).** The body of
  `cotangentSpaceAtIdentity` is by construction the `extendScalars ψ_V`
  base change of `Ω[Γ(G, V) ⁄ Γ(Spec k, U)]` from `Γ(G, V)` to `k`. Apply
  `Module.finrank_baseChange` to push `Module.finrank Γ(G, V) Ω[…]` to
  `Module.finrank k (k ⊗_{Γ(G,V)} Ω[…])`, discharging the `Module.Free`
  hypothesis via `hfree` and the `Nontrivial Γ(G, V)` hypothesis from the
  existence of the ring map `ψ_V : Γ(G, V) → k` into the field `k`. -/
theorem cotangentSpaceAtIdentity_finrank_eq (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    Module.finrank k (cotangentSpaceAtIdentity (n := n) G) = n := by
  -- Reproduce the same `Classical.choose`-chain as the body of `cotangentSpaceAtIdentity`.
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  let x₀ : G.left := (ConcreteCategory.hom ηleft.base) default
  let h := Scheme.smooth_locally_free_omega (n := n) G.hom x₀
  let U : (Spec (.of k)).Opens := h.choose
  let V : G.left.Opens := h.choose_spec.choose
  let e : V ≤ G.hom ⁻¹ᵁ U := h.choose_spec.choose_spec.choose
  have hxV : x₀ ∈ V := h.choose_spec.choose_spec.choose_spec.1
  -- Algebra structure on `Γ(G.left, V)` over `Γ(Spec k, U)` (matches the body's `letI`).
  letI algGV : Algebra ↥Γ(Spec (.of k), U) ↥Γ(G.left, V) :=
    (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
  -- Freeness + rank witnesses from the existential.
  have hfree : Module.Free ↥Γ(G.left, V) Ω[↥Γ(G.left, V) ⁄ ↥Γ(Spec (.of k), U)] :=
    h.choose_spec.choose_spec.choose_spec.2.2.2.1
  have hrank : Module.rank ↥Γ(G.left, V) Ω[↥Γ(G.left, V) ⁄ ↥Γ(Spec (.of k), U)] = (n : Cardinal) :=
    h.choose_spec.choose_spec.choose_spec.2.2.2.2
  -- ψV ring map (matches the body's `ψV`).
  have htop : (⊤ : (Spec (.of k)).Opens) ≤ ηleft ⁻¹ᵁ V := fun s _ => by
    rw [Scheme.Hom.mem_preimage, show s = default from Subsingleton.elim _ _]
    exact hxV
  let ψV : Γ(G.left, V) ⟶ CommRingCat.of k :=
    ηleft.appLE V ⊤ htop ≫ (Scheme.ΓSpecIso (.of k)).hom
  letI algGVk : Algebra ↥Γ(G.left, V) k := ψV.hom.toAlgebra
  -- The Γ(G, V) algebra is Nontrivial because it maps to the field `k`.
  haveI : Nontrivial ↥Γ(G.left, V) := ψV.hom.domain_nontrivial
  -- The body of `cotangentSpaceAtIdentity` is `(extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`,
  -- whose carrier is `TensorProduct Γ(G, V) k Ω[…]` (under `algGVk`). Definitional equality
  -- of the carriers reduces the goal to `Module.finrank k (TensorProduct ...) = n`.
  change Module.finrank k (TensorProduct ↥Γ(G.left, V) k
      (Ω[↥Γ(G.left, V) ⁄ ↥Γ(Spec (.of k), U)])) = n
  -- Step 2: Base-change preserves finrank.
  rw [Module.finrank_baseChange (R := k) (S := ↥Γ(G.left, V))
        (M' := Ω[↥Γ(G.left, V) ⁄ ↥Γ(Spec (.of k), U)])]
  -- Step 1: Apply rank=n ⇒ finrank=n.
  exact Module.finrank_eq_of_rank_eq hrank

/-! ## Piece (i.b) — shear-iso globalisation of the cotangent

The next three declarations support the iter-134+ piece (i.b) lane (see
`blueprint/src/chapters/RigidityKbar.tex` § Piece (i.b)). Their goal is the
main lemma `mulRight_globalises_cotangent`:

  `relativeDifferentialsPresheaf G.hom  ≅
      pullback_along_str_map (pullback_along_η_G (relativeDifferentialsPresheaf G.hom))`

stated at the **presheaf-of-modules level** (sheaf-level RHS per the iter-133
mathlib-analogist Decision 4 + iter-134 plan-agent pre-commitment). The proof
chain has three structural pieces:

* Step 1 (`shearMulRight`): build the binary-product shear iso
  `σ = ⟨pr₁, μ⟩ : G ⊗ G ≅ G ⊗ G` in `Over (Spec k)` from `GrpObj` data only.
  This is a categorical statement (no scheme-side content); modelled on
  `CategoryTheory.GrpObj.mulRight` (one-input version,
  `Mathlib.CategoryTheory.Monoidal.Grp_.lean:277-281`).

* Step 2 (`relativeDifferentialsPresheaf_basechange_along_proj_two`):
  the load-bearing presheaf-of-modules base-change identity
  `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` on `(G ⊗ G).left`.
  NEEDS_MATHLIB_GAP_FILL (~150–300 LOC); chains
  `KaehlerDifferential.tensorKaehlerEquiv` (algebra side) with
  `PresheafOfModules.pullback` / `TopCat.Presheaf.pullback` (presheaf side).

* Step 3 (`relativeDifferentialsPresheaf_restrict_along_identity_section`):
  the section-restriction identity bridging `s^* pr_2^* Ω_{G/k}` to
  `π_G^* η_G^* Ω_{G/k}` via `PresheafOfModules.pullbackComp` and the
  categorical identity `pr_2 ∘ s = η_G ∘ π_G` for `s = ⟨𝟙_G, η_G⟩`.
-/

section ShearIso

variable {C : Type*} [Category C] [CartesianMonoidalCategory C]

/-- **Binary-product shear isomorphism** for a group object `G` in a Cartesian
monoidal category: the map
`σ = lift (fst G G) μ : G ⊗ G ⟶ G ⊗ G`, informally `(a, b) ↦ (a, a · b)`,
is an isomorphism. The inverse is
`σ⁻¹ = lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ)`, informally
`(a, b) ↦ (a, a⁻¹ · b)`.

This is the binary-product upgrade of
`CategoryTheory.GrpObj.mulRight` (`Mathlib.CategoryTheory.Monoidal.Grp_.lean:277-281`),
which packages only the one-input version `(· · f)` for a fixed global element
`f : 𝟙_ ⟶ G`. Here both factors of `G ⊗ G` are free.

Piece (i.b) Step 1 (per `blueprint/src/chapters/RigidityKbar.tex` Step 1 of
`lem:GrpObj_mulRight_globalises`). NEEDS_MATHLIB_GAP_FILL (no packaged shear
iso for binary products in Mathlib; the iter-133 mathlib-analogist verdict
Decision 1 prescribes this exact construction). -/
@[simps]
def shearMulRight (G : C) [GrpObj G] : G ⊗ G ≅ G ⊗ G where
  hom := lift (fst G G) μ
  inv := lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ)
  hom_inv_id := by
    -- `(a, b) ↦ (a, a · b) ↦ (a, a⁻¹ · (a · b)) = (a, b)`.
    apply CartesianMonoidalCategory.hom_ext
    · simp
    · -- Goal: `(σ.hom ≫ σ.inv) ≫ snd G G = 𝟙 (G ⊗ G) ≫ snd G G`
      rw [Category.id_comp, Category.assoc, lift_snd]
      -- Goal: `σ.hom ≫ (lift (fst G G ≫ ι) (snd G G) ≫ μ) = snd G G`
      rw [← Category.assoc, comp_lift]
      -- Goal: `lift (σ.hom ≫ (fst G G ≫ ι)) (σ.hom ≫ snd G G) ≫ μ = snd G G`
      rw [← Category.assoc, lift_fst, lift_snd]
      -- Goal: `lift (fst G G ≫ ι) μ ≫ μ = snd G G`
      -- Trick: use `lift_lift_assoc` with f := fst ≫ ι, g := fst, h := snd, then
      -- close by `lift_comp_inv_left` and `lift_comp_one_left`.
      rw [show (lift (fst G G ≫ ι) μ ≫ μ : G ⊗ G ⟶ G) =
          lift (lift (fst G G ≫ ι) (fst G G) ≫ μ) (snd G G) ≫ μ from by
            rw [MonObj.lift_lift_assoc, lift_fst_snd, Category.id_comp],
        CategoryTheory.GrpObj.lift_comp_inv_left, MonObj.lift_comp_one_left]
  inv_hom_id := by
    -- `(a, b) ↦ (a, a⁻¹ · b) ↦ (a, a · (a⁻¹ · b)) = (a, b)`.
    apply CartesianMonoidalCategory.hom_ext
    · simp
    · -- Goal: `(σ.inv ≫ σ.hom) ≫ snd G G = 𝟙 (G ⊗ G) ≫ snd G G`
      rw [Category.id_comp, Category.assoc, lift_snd]
      -- Goal: `lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ) ≫ μ = snd G G`
      -- Apply `lift_lift_assoc` (← direction): the RHS form `lift f (lift g h ≫ μ) ≫ μ`
      -- rewrites to `lift (lift f g ≫ μ) h ≫ μ` with f := fst, g := fst ≫ ι, h := snd.
      rw [show (lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ) ≫ μ :
          G ⊗ G ⟶ G) =
          lift (lift (fst G G) (fst G G ≫ ι) ≫ μ) (snd G G) ≫ μ from
          (MonObj.lift_lift_assoc (fst G G) (fst G G ≫ ι) (snd G G)).symm,
        CategoryTheory.GrpObj.lift_comp_inv_right,
        MonObj.lift_comp_one_left]

@[reassoc (attr := simp)]
lemma shearMulRight_hom_fst (G : C) [GrpObj G] :
    (shearMulRight G).hom ≫ fst G G = fst G G := by
  simp [shearMulRight]

@[reassoc (attr := simp)]
lemma shearMulRight_hom_snd (G : C) [GrpObj G] :
    (shearMulRight G).hom ≫ snd G G = μ := by
  simp [shearMulRight]

end ShearIso

/-! ### Helpers / main lemma for piece (i.b)

The remaining declarations of this section state the helper sub-lemmas
and main lemma of piece (i.b) at the presheaf-of-modules level. Their
bodies are work-in-progress for iter-134+; the proofs decompose
along the closure path documented in
`blueprint/src/chapters/RigidityKbar.tex` § Piece (i.b) +
`analogies/mulright-globalises-cotangent.md`.
-/

/-- **Compatibility morphism of structure presheaves of rings** along a scheme
morphism `f`. This is the `φ' = ((adj).homEquiv _ _).symm f.c` shape used by
`relativeDifferentialsPresheaf`; we package it once here so the
`PresheafOfModules.pullback`-based statements below can refer to it
uniformly.

Specifically, for a scheme morphism `f : Y ⟶ Z`, this is the adjunction
transpose of the structure-sheaf morphism `f.c : O_Z ⟶ f.base _* O_Y`,
delivering a morphism `f.base⁻¹ O_Z ⟶ O_Y` of presheaves of rings on
`Y`.

**Note**: this is **not** the φ for `PresheafOfModules.pullback`, which
expects a morphism of presheaves on the *codomain* `Y`
(`Y.ringCatSheaf ⟶ (Opens.map f.base).op ⋙ X.ringCatSheaf`) and is
obtained via `(Scheme.Hom.toRingCatSheafHom f).hom`. The two conventions
serve distinct downstream consumers. -/
noncomputable def schemeHomRingCompatibility {Y Z : Scheme.{u}} (f : Y ⟶ Z) :
    (TopCat.Presheaf.pullback (C := CommRingCat) f.base).obj Z.presheaf ⟶ Y.presheaf :=
  ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm f.c

/-! ### Helper sub-lemmas and main lemma of piece (i.b)

The three declarations below state the intended sheaf-level RHS
signatures for piece (i.b)'s closure chain (Step 2 base-change of
differentials, Step 3 section restriction, Compose main lemma).
Status: Step 3 closed iter-136 (no sorry); Step 2 PARTIAL iter-137 (body
remains `sorry`; inverse-direction-via-adjunction skeleton recorded in
`task_results/Cotangent_GrpObj.lean.md`); Compose main lemma body `sorry`
pending Step 2 closure (iter-138+ target). See
`blueprint/src/chapters/RigidityKbar.tex` § Piece (i.b) +
`analogies/mulright-globalises-cotangent.md` +
`analogies/phi-compatibility-morphisms.md` (iter-135 mathlib-analogist
on the `PresheafOfModules.pullback` compatibility-morphism shape) +
`analogies/kaehler-tensorequiv-presheafpullback.md` (iter-137
mathlib-analogist universal-property-at-presheaf-level recipe).

The compatibility morphisms for `PresheafOfModules.pullback` are
obtained inline as `(Scheme.Hom.toRingCatSheafHom <morphism>).hom`,
the canonical Mathlib helper at
`Mathlib.AlgebraicGeometry.Modules.Presheaf`. This is structurally
different from `schemeHomRingCompatibility` above (which is the
adjunction transpose used by `relativeDifferentialsPresheaf` — see
that declaration's docstring).
-/

/-- The categorical identity at the underlying scheme level:
`s.left ≫ pr_2.left = G.hom ≫ η[G].left`, where
`s := lift (𝟙 G) (toUnit G ≫ η[G])` is the canonical section of the first
projection in `Over (Spec k)`. The proof is direct: `s ≫ snd = toUnit G ≫ η[G]`
by `lift_snd`, and `(toUnit G).left = G.hom` by `Over.toUnit_left`. -/
private lemma section_snd_eq_identity_struct
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] :
    (lift (𝟙 G) (toUnit G ≫ η[G])).left ≫ (snd G G).left =
      G.hom ≫ (CategoryTheory.CommaMorphism.left η[G]) := by
  rw [← Over.comp_left, lift_snd, Over.comp_left, Over.toUnit_left]
  rfl

/-! ### Piece (i.b) Step 2: base-change-along-`pr_2` iso (iter-138 PARTIAL skeleton)

**Mathematical content (per `blueprint/src/chapters/RigidityKbar.tex` § Piece (i.b)
`lem:GrpObj_omega_basechange_proj`)**:

  `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` on `(G ⊗ G).left`

with `pr_1` (the first projection in `Over (Spec k)`) viewing `(G ⊗ G).left`
as a `G.left`-scheme on the LHS and `pr_2` (the second projection) yielding
the pullback presheaf on the RHS. The compatibility morphism for `pr_2`
is `(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`.

**Iter-135 honest scaffold; iter-137 PARTIAL; iter-138 PARTIAL with substantive
Route (b) skeleton landed.** Iter-138 prover (this iter) landed the
inverse-direction-via-adjunction-transpose Route (b) skeleton substantively
(Step 4 of the recipe: the derivation `D` is constructed pointwise via
`Derivation'.mk` / `ModuleCat.Derivation.mk`, with the additive and Leibniz
laws closed; the `d_app` zero-on-source-ring law and the `d_map` cross-open
naturality remain `sorry`-bodied as two concrete sub-pieces; see helpers
`basechange_along_proj_two_inv_derivation` and `basechange_along_proj_two_inv`
below). The main iso then materialises as `(asIso (… inv …)).symm`, with the
`IsIso` of the inverse map carried as the third concrete sorry. Net change
this iter: 1 hollow scaffold sorry → 3 narrowly-scoped concrete sorries (each
documented + each strictly smaller than the original load-bearing gap).

**Three remaining concrete sub-goals (iter-139+ targets)**:

1. `d_app` (algebraic-coherence): for `a : ((G.hom.base⁻¹ O_{Spec k})).obj X`,
   the composite `(ψ.app X).hom (φ_G.app X a)` lies in the image of the
   source-presheaf morphism `φ_LHS.app (snd⁻¹ X)`, hence its universal
   Kähler differential vanishes. This factors through the commutativity
   `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` of `G ⊗ G ⟶ Spec k`
   in `Over (Spec k)`.

2. `d_map` (naturality across opens): for `f : X ⟶ Y` in `G.left.Opensᵒᵖ`,
   the pointwise derivations commute with the restriction maps of
   `(pushforward ψ).obj LHS` and `G.left.presheaf`. This is a chase of
   `Scheme.Hom.c.naturality` + `KaehlerDifferential.D.d_map`.

3. `IsIso` of `basechange_along_proj_two_inv G` (the load-bearing iso
   property). Two paths: (a) build the forward direction by Route (a)'s
   `pullbackObjEquivTensor` chart-unfolding helper (~30–60 LOC helper
   + ~250–500 LOC body); (b) check the iso property locally on a
   PresheafOfModules generator (e.g. via
   `PresheafOfModules.toPresheaf` reflecting isos +
   `NatTrans.isIso_iff_isIso_app` to localise to per-open ModuleCat,
   followed by a chart-by-chart `tensorKaehlerEquiv` comparison).

**Route (a) chart-unfolding helper status**: NOT BUILT this iter — the
iter-138 prover prioritised the Route (b) skeleton landing per the PROGRESS.md
"PRIMARY: build `pullbackObjEquivTensor` helper" suggested order *vs.* the
"FALLBACK: Route (b) Inverse-direction-via-adjunction-transpose" — the
fallback was chosen since the chart helper (a) hits the same opacity blocker
as iter-137 (no Mathlib pullback-on-obj rewrite), whereas Route (b) admits
typeable derivation construction without unfolding pullback.

Closure target retained: chain `KaehlerDifferential.tensorKaehlerEquiv`
(algebra-side, `Mathlib.RingTheory.Kaehler.TensorProduct`) with the sheaf-side
`PresheafOfModules.pullback` per `analogies/mulright-globalises-cotangent.md`
Decision 2 + `analogies/kaehler-tensorequiv-presheafpullback.md` 5-step
recipe (~360–710 LOC total; load-bearing piece (i.b) Step 2). -/

/-- **Iso-reflection bridge for `PresheafOfModules` morphisms** (iter-140 Route
(b'2) closure helper, per `analogies/isiso-basechange-along-proj-two-inv.md`
Decision 2). A morphism `f : M ⟶ N` of presheaves of modules over a presheaf
of rings `R` is an isomorphism iff its component `f.app X` is an iso in
`ModuleCat (R.obj X)` for every open `X`.

Chains two Mathlib facts: `PresheafOfModules.toPresheaf R` reflects isomorphisms
(via `Balanced` + `Faithful` ⇒ `ReflectsMonomorphisms` + `ReflectsEpimorphisms`
⇒ `ReflectsIsomorphisms`, from
`Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced`), and
`NatTrans.isIso_iff_isIso_app` localises iso-checks on natural transformations
to pointwise iso-checks.

Mirrors `AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_app`
(`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:132`) for the
`PresheafOfModules` (rather than `SheafOfModules`) category.
Upstream-PR candidate. -/
private theorem isIso_of_app_iso_module {C : Type*} [Category C]
    {R : Cᵒᵖ ⥤ RingCat} {M N : PresheafOfModules R}
    (f : M ⟶ N) (h : ∀ X, IsIso (f.app X)) : IsIso f := by
  rw [← isIso_iff_of_reflects_iso _ (PresheafOfModules.toPresheaf R),
      NatTrans.isIso_iff_isIso_app]
  intro X
  exact Functor.map_isIso (forget₂ (ModuleCat _) AddCommGrpCat) (f.app X)

/-- **Inverse-direction derivation** (Route (b) Step 4 of the iter-137
`analogies/kaehler-tensorequiv-presheafpullback.md` recipe).

Constructs the derivation
`D : ((pushforward ψ).obj LHS).Derivation' φ_G` (pointwise via
`Derivation'.mk` + `ModuleCat.Derivation.mk`) whose pointwise rule at each
open `X : G.left.Opensᵒᵖ` is
`d_X(b) := KaehlerDifferential.D ((ψ.app X).hom b)`,
i.e. take the section `b ∈ G.left.presheaf.obj X`, push it forward along
`ψ.app X : G.left.presheaf.obj X ⟶ (G ⊗ G).left.presheaf.obj (snd⁻¹ X)`
(coming from `Scheme.Hom.toRingCatSheafHom (snd G G).left`), and take its
universal Kähler differential in the source-side presheaf of relative
differentials of `(fst G G).left` (= `LHS`) over the pulled-back open.

**Status (iter-138 PARTIAL)**: the additive (`d_add`) and Leibniz (`d_mul`)
laws are closed (via the `RingHom`-ness of `ψ.app X` + the algebra-side
derivation laws of `KaehlerDifferential.D`). The `d_app` (zero on
`φ_G`-image) and the `d_map` (cross-open naturality) sub-goals remain
`sorry`-bodied; see the iter-138 docstring of
`relativeDifferentialsPresheaf_basechange_along_proj_two` for the sub-goal
breakdown. -/
noncomputable def basechange_along_proj_two_inv_derivation
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] :
    ((PresheafOfModules.pushforward
          (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
        (Scheme.relativeDifferentialsPresheaf (fst G G).left)).Derivation'
      (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
        G.hom.base).homEquiv _ _).symm G.hom.c) := by
  refine PresheafOfModules.Derivation'.mk
    (fun X =>
      ModuleCat.Derivation.mk
        (fun b =>
          (CommRingCat.KaehlerDifferential.D _).d
            (((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom b))
        (fun a b => by
          have h : ((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom (a + b)
                 = ((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom a
                 + ((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom b :=
            RingHom.map_add _ _ _
          change (CommRingCat.KaehlerDifferential.D _).d _ = _
          rw [h]
          exact ModuleCat.Derivation.d_add _ _ _)
        (fun a b => by
          have h : ((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom (a * b)
                 = ((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom a
                 * ((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom b :=
            RingHom.map_mul _ _ _
          change (CommRingCat.KaehlerDifferential.D _).d _ = _
          rw [h]
          exact ModuleCat.Derivation.d_mul _ _ _)
        (fun a => by
          -- d_app: KaehlerDifferential.D of (ψ.app X) ∘ (φ_G.app X) vanishes.
          -- This follows from (fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom in Over (Spec k),
          -- which makes (ψ.app X) ∘ (φ_G.app X) factor through the source presheaf of LHS.
          --
          -- Iter-140 prover lane partial: `change` succeeds (witnessed below); the
          -- remaining closure is the categorical chase to produce the factoring
          -- witness `h : Source ⟶ ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)`
          -- with `h ≫ (φ_LHS.app (snd⁻¹X)) = (φ_G.app X) ≫ (ψ.app X)` as ring maps.
          -- With such `h`, `D.d (f.hom a) = 0` follows from
          -- `Derivation.map_algebraMap` after setting up Algebra/Module/IsScalarTower
          -- instances via `f.hom.toAlgebra` (iter-140 prover validated this pattern
          -- on a stand-alone example: `D.d (g.hom (k.hom a)) = 0` when `k ≫ g = f`).
          --
          -- The categorical witness `h` requires unpacking the
          -- `pullbackPushforwardAdjunction.homEquiv.symm` action of the adjunction
          -- between presheaf pullback/pushforward on `(Spec k).presheaf` vs
          -- `G.left.presheaf`, applied to the categorical identity
          -- `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` lifted to the
          -- structure-sheaf level via `LocallyRingedSpace.comp_c_app`. Iter-141+
          -- target.
          change (CommRingCat.KaehlerDifferential.D _).d _ = 0
          sorry))
    (fun X Y f x => by
      -- d_map naturality (iter-142 closure): chain ψ-naturality with the
      -- universal-Kähler-derivation commutation `relativeDifferentials'_map_d`.
      --
      -- Goal after `change`:
      --   KD.d (ψ.app Y .hom (G.left.presheaf.map f .hom x))
      --   = ((pushforward ψ).obj LHS).map f .hom (KD.d (ψ.app X .hom x))
      --
      -- The RHS reduces by `pushforward_obj_map_apply'` (RHS unfolding); but
      -- since `pushforward₀` is annotated `respectTransparency false`, we
      -- avoid `change`/`whnf`-based unfolding and instead use an explicit
      -- substitution `hnat` from `NatTrans.naturality_apply` on ψ to rewrite
      -- the LHS, then close by `relativeDifferentials'_map_d`.
      have hnat :=
        NatTrans.naturality_apply (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom f x
      change (CommRingCat.KaehlerDifferential.D _).d _ = _
      rw [hnat]
      exact
        (PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d
          _ _ _).symm)

/-- **Inverse-direction morphism** (Route (b) Step 5 of the iter-137 recipe).

Builds the inverse map
`(pullback ψ).obj M_G ⟶ LHS`
by transposing the universal-property-derived
`M_G ⟶ (pushforward ψ).obj LHS`
(obtained from `basechange_along_proj_two_inv_derivation` via
`DifferentialsConstruction.isUniversal'.desc`) along the
`pullbackPushforwardAdjunction`. -/
noncomputable def basechange_along_proj_two_inv
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] :
    (PresheafOfModules.pullback
        (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
      (Scheme.relativeDifferentialsPresheaf G.hom) ⟶
    Scheme.relativeDifferentialsPresheaf (fst G G).left :=
  let ψ := (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom
  let LHS := Scheme.relativeDifferentialsPresheaf (fst G G).left
  let MG := Scheme.relativeDifferentialsPresheaf G.hom
  let φG := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
    G.hom.base).homEquiv _ _).symm G.hom.c
  let univStep :=
    (PresheafOfModules.DifferentialsConstruction.isUniversal' φG).desc
      (basechange_along_proj_two_inv_derivation G)
  ((PresheafOfModules.pullbackPushforwardAdjunction ψ).homEquiv MG LHS).symm univStep

noncomputable def relativeDifferentialsPresheaf_basechange_along_proj_two
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
      (PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
        (Scheme.relativeDifferentialsPresheaf G.hom) :=
  -- Iter-138 partial closure: build the iso via the inverse map +
  -- `IsIso`-of-inverse + `asIso ... |>.symm`. The `IsIso` fact is the
  -- third concrete sub-piece; see this declaration's docstring for the
  -- closure paths (Route (a) chart-unfolding-helper or local-iso check).
  -- Iter-140 structural refactor: Route (b'2) via the iso-reflection
  -- bridge `isIso_of_app_iso_module` localises the IsIso check to a
  -- per-open ModuleCat-iso check; the remaining per-open identification
  -- (against `KaehlerDifferential.tensorKaehlerEquiv.symm` modulo the
  -- chart-unfolding of `((pullback ψ).obj M_G).obj X`) is the residual
  -- iter-141+ closure target.
  letI : IsIso (basechange_along_proj_two_inv G) :=
    isIso_of_app_iso_module (basechange_along_proj_two_inv G) (fun _ => sorry)
  (asIso (basechange_along_proj_two_inv G)).symm

/-- **Restriction of the relative differentials presheaf along the canonical
section** `s := ⟨𝟙_G, η_G⟩ : G ⟶ G ⊗ G` of the first projection in
`Over (Spec k)` (piece (i.b) Step 3).

Signature is the intended sheaf-level section-restriction iso, per
`blueprint/src/chapters/RigidityKbar.tex` Step 3 of
`lem:GrpObj_mulRight_globalises` (`lem:GrpObj_omega_restrict_to_identity_section`):

  `s^*(pr_2^* Ω_{G/k}) ≅ π_G^*(η_G^* Ω_{G/k})`

obtained from the categorical identity `pr_2 ∘ s = η_G ∘ π_G` (where
`π_G : G ⟶ Spec k` is the structure map and `pr_2 : G ⊗ G ⟶ G` the second
projection). The compatibility morphisms for the four scheme morphisms
involved are spelled inline via `(Scheme.Hom.toRingCatSheafHom _).hom`.

**Iter-136 closure (Step 3)**: closed via the categorical identity
`s.left ≫ pr_2.left = G.hom ≫ η[G].left` (`section_snd_eq_identity_struct`
above) combined with `PresheafOfModules.pullbackComp` on both sides. -/
noncomputable def relativeDifferentialsPresheaf_restrict_along_identity_section
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    (PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom
            (lift (𝟙 G) (toUnit G ≫ η[G])).left).hom).obj
        ((PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
          (Scheme.relativeDifferentialsPresheaf G.hom)) ≅
      (PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
        ((PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom
              (CategoryTheory.CommaMorphism.left η[G])).hom).obj
          (Scheme.relativeDifferentialsPresheaf G.hom)) := by
  -- Step 1. Use `PresheafOfModules.pullbackComp` to merge each side's nested pullback
  -- into a single pullback along the composed compatibility morphism.
  -- Step 2. The composed compatibility morphisms on each side are *definitionally*
  -- equal to `(toRingCatSheafHom (lift.left ≫ snd.left)).hom` and
  -- `(toRingCatSheafHom (G.hom ≫ η[G].left)).hom` respectively (by Scheme c-composition
  -- `LocallyRingedSpace.comp_c` + commutation of `whiskerLeft`/`whiskerRight`).
  -- Step 3. `section_snd_eq_identity_struct` identifies the two single-morphism pullbacks.
  have iso1 := (PresheafOfModules.pullbackComp
    (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom
    (Scheme.Hom.toRingCatSheafHom (lift (𝟙 G) (toUnit G ≫ η[G])).left).hom).app
    (Scheme.relativeDifferentialsPresheaf G.hom)
  have iso2 := (PresheafOfModules.pullbackComp
    (Scheme.Hom.toRingCatSheafHom (CategoryTheory.CommaMorphism.left η[G])).hom
    (Scheme.Hom.toRingCatSheafHom G.hom).hom).app
    (Scheme.relativeDifferentialsPresheaf G.hom)
  refine iso1 ≪≫ ?_ ≪≫ iso2.symm
  refine eqToIso ?_
  -- After `pullbackComp` both sides reduce to single-morphism pullbacks; the c-composition
  -- rule lets us re-express them as `pullback (toRingCatSheafHom <composite>).hom`.
  change (PresheafOfModules.pullback
        (Scheme.Hom.toRingCatSheafHom
          ((lift (𝟙 G) (toUnit G ≫ η[G])).left ≫ (snd G G).left)).hom).obj
      (Scheme.relativeDifferentialsPresheaf G.hom) =
    (PresheafOfModules.pullback
        (Scheme.Hom.toRingCatSheafHom
          (G.hom ≫ (CategoryTheory.CommaMorphism.left η[G]))).hom).obj
      (Scheme.relativeDifferentialsPresheaf G.hom)
  rw [section_snd_eq_identity_struct]

/-- **Shear-iso globalisation of the relative cotangent** of a smooth proper
geometrically irreducible group scheme `G` over `k` (piece (i.b) main lemma).

Signature is the intended sheaf-level RHS, per
`blueprint/src/chapters/RigidityKbar.tex` § Piece (i.b)
`lem:GrpObj_mulRight_globalises` (iter-133 mathlib-analogist Decision 4
+ iter-134 plan-agent pre-commitment):

  `Ω_{G/k} ≅ π_G^*(η_G^* Ω_{G/k})` on `G`

i.e., the relative cotangent of `G` is canonically isomorphic to the
constant `O_G`-module with fibre `η_G^* Ω_{G/k}`, trivialised along the
structure map. The compatibility morphisms are obtained inline via
`(Scheme.Hom.toRingCatSheafHom G.hom).hom` (for π_G) and
`(Scheme.Hom.toRingCatSheafHom η[G].left).hom` (for η_G).

Stated at the **presheaf-of-modules level** (sheaf-level RHS): keeps the
lemma in the 210–440 LOC envelope and decouples the body from
chart-localisation, which is a separate piece-(i.c)-side artefact (the
chart-localisation bridge from this sheaf-level RHS to
`cotangentSpaceAtIdentity G` is consumed inside `omega_free`, not here).

**Proof outline (per `RigidityKbar.tex` § Piece (i.b)
`lem:GrpObj_mulRight_globalises`).**

* **Step 1**: shear iso `σ = lift (fst G G) μ : G ⊗ G ≅ G ⊗ G` in
  `Over (Spec k)` from `GrpObj` data (`shearMulRight G` above).
  Iso over `pr_1` since `σ ≫ pr_1 = pr_1` by `lift_fst` (`shearMulRight_hom_fst`).

* **Step 2**: base-change identity
  `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` on `(G ⊗ G).left`
  (`relativeDifferentialsPresheaf_basechange_along_proj_two`).

* **Step 3**: restrict along the section `s = ⟨𝟙_G, η_G⟩ : G ⟶ G ⊗ G`.
  The LHS `s^*(Ω_{(G ⊗ G)/G})` collapses to `Ω_{G/k}` by the pullback-along-section
  identity (combining `PresheafOfModules.pullbackComp` + `PresheafOfModules.pullbackId`
  on `pr_1 ∘ s = 𝟙_G`). The RHS `s^*(pr_2^* Ω_{G/k})` rewrites to
  `π_G^*(η_G^* Ω_{G/k})` via
  `relativeDifferentialsPresheaf_restrict_along_identity_section`.

* **Compose**: chain Step 2 (pulled back along `s`) with the two Step 3
  identifications to deliver the displayed iso.

**Iter-135 honest scaffold**: body is `sorry`. Step 1 (`shearMulRight`)
is fully closed; Step 3 (`_restrict_along_identity_section`) closed iter-136;
Step 2 (`_basechange_along_proj_two`) returned PARTIAL iter-137 (universal-
property-at-presheaf-level route confirmed feasible via adjunction transpose +
derivation on `(pushforward ψ).obj LHS`, but `PresheafOfModules.pullback`
chart-opacity blocks single-iter closure — see
`task_results/Cotangent_GrpObj.lean.md` for the inverse-direction skeleton).
The body composes the three pieces along the proof outline. -/
noncomputable def mulRight_globalises_cotangent
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    Scheme.relativeDifferentialsPresheaf G.hom ≅
      (PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
        ((PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom
              (CategoryTheory.CommaMorphism.left η[G])).hom).obj
          (Scheme.relativeDifferentialsPresheaf G.hom)) :=
  sorry

end AlgebraicGeometry.GrpObj
