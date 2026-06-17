/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechAugmentedResolution
import AlgebraicJacobian.Cohomology.OpenImmersionPushforward
import AlgebraicJacobian.Cohomology.AcyclicResolution

/-! # Čech term acyclicity for the pushforward -/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {X S : Scheme.{u}}

/-! ## Auxiliary: finite products of acyclic objects -/

/- Planner strategy: lem:rightAcyclic_finite_prod ·
A finite categorical product (= finite biproduct in an abelian category) of right-G-acyclic
objects is right-G-acyclic.  Since `G.rightDerived (k+1)` is additive it preserves finite
biproducts; each factor `(G.rightDerived (k+1)).obj (X i)` is zero by the per-factor acyclicity
instance, so their finite product/biproduct is zero.
Proof route: `Functor.IsRightAcyclic.vanish` on the product reduces to
`IsZero (∏ᶜ i, (G.rightDerived (k+1)).obj (X i))` (additive right-derived preserves ∏ᶜ), then
each factor is zero by `Functor.IsRightAcyclic.vanish i`, and a finite product of zero objects is
zero (`IsZero.prod` / `Limits.IsZero.pi`). -/
/-- **A finite product of right-`G`-acyclic objects is right-`G`-acyclic**
(blueprint `lem:rightAcyclic_finite_prod`).

Let `G : 𝒜 ⥤ ℬ` be an additive functor between abelian categories with injective resolutions,
and let `(X i)_{i : ι}` be a finite family of objects each right `G`-acyclic.  Then the
categorical product `∏ᶜ i, X i` is also right `G`-acyclic. -/
lemma rightAcyclic_finite_prod
    {𝒜 ℬ : Type*} [Category 𝒜] [Abelian 𝒜] [HasInjectiveResolutions 𝒜]
    [HasFiniteProducts 𝒜] [Category ℬ] [Abelian ℬ]
    (G : 𝒜 ⥤ ℬ) [G.Additive] {ι : Type*} [Finite ι]
    (Xf : ι → 𝒜) [∀ i, G.IsRightAcyclic (Xf i)] :
    G.IsRightAcyclic (∏ᶜ i, Xf i) := by
  sorry

/-! ## Čech term acyclicity for the pushforward -/

/- Planner strategy: lem:cech_term_pushforward_acyclic ·
Each degree-`p` Čech term `(cechComplexOnX 𝒰 F).X p` decomposes (via `lem:pushPull_sigma_iso`)
as a finite product `∏_σ (j_σ)_*(F|_{U_σ})` over multi-indices `σ = (i₀,…,i_p)`, with each
`U_σ` affine (X separated + all U_i affine).  By `rightAcyclic_finite_prod` it suffices to treat
a single factor `(j_s)_*(F|_{U_s})`.
By `higherDirectImage_openImmersion_comp` (OpenImmersionPushforward.lean):
  `R^k f_*((j_s)_*(F|_{U_s})) ≅ R^k (f∘j_s)_*(F|_{U_s})`.
The composite `f∘j_s : U_s → S` is a morphism from the affine `U_s`; working locally over
affine `V ⊆ S`, the preimage `(f∘j_s)⁻¹(V) = U_s ∩ f⁻¹(V)` is affine (U_s affine, f separated).
Relative Serre vanishing (`affine_serre_vanishing` / `higherDirectImage_openImmersion_acyclic`)
kills `H^k` for `k ≥ 1` on this affine.  Assembling: `R^k f_*(Cᵖ) = 0` for all `k ≥ 1`. -/
/-- **Each Čech term is right-`(f_*)`-acyclic** (blueprint `lem:cech_term_pushforward_acyclic`;
Stacks `lemma-relative-affine-vanishing`).

For a quasi-compact separated morphism `f : X ⟶ S` with `X` separated and a finite affine open
cover `𝒰` of `X`, every term `(cechComplexOnX 𝒰 F).X p` of the un-augmented Čech complex on `X`
is right-acyclic for the pushforward functor `f_*`. -/
lemma cechTerm_pushforward_acyclic [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) :
    (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X p) := by
  sorry

end AlgebraicGeometry
