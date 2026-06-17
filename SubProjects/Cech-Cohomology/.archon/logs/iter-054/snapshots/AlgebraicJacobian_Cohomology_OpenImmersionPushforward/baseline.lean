/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf
import AlgebraicJacobian.Cohomology.AcyclicResolution

/-!
# Higher direct images along open immersions of affine opens

This file establishes `lem:open_immersion_pushforward_comp`:

1. `higherDirectImage_openImmersion_acyclic`: for an open immersion `j : U ↪ X` of an
   affine open `U` into a separated scheme `X`, the higher direct images `R^q j_* H` vanish
   for `q ≥ 1` and any quasi-coherent `O_U`-module `H`.

2. `higherDirectImage_openImmersion_comp` (pinned declaration): consequently, for any
   morphism `f : X ⟶ S` and quasi-coherent `H` on `U`, there is a canonical isomorphism
   `R^k f_*(j_* H) ≅ R^k (f ∘ j)_* H`.

Blueprint: `lem:open_immersion_pushforward_comp`.
Source: Stacks Project, Cohomology of Schemes, `lemma-relative-affine-vanishing`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {U X S : Scheme.{u}}

/- Planner strategy:
Part (1): `R^q j_* H` is the sheafification of `V ↦ H^q(j⁻¹V, H)` (presheaf description
`higher_direct_image_presheaf`, Stacks 01XJ); for affine `V`, `j⁻¹V = U ∩ V` is affine (U affine,
X separated), so `affine_serre_vanishing` kills `H^q` for `q ≥ 1`; affine opens are a basis ⇒
`R^q j_* H = 0`. Part (2): take an injective resolution `H → I•`; `j_* I•` is a resolution of
`j_* H` (each `j_* Iⁿ` is `j_*`-acyclic by (1)) and each `j_* Iⁿ` is `f_*`-acyclic (same presheaf
+ Serre-vanishing argument on `U ∩ f⁻¹V`); so `j_* I•` is an `f_*`-acyclic resolution of `j_* H`,
and the P4 acyclic-resolution comparison (`acyclic_resolution_computes_derived` /
`rightDerivedIsoOfAcyclicResolution`) with `G = f_*` gives `R^k f_*(j_* H) ≅ H^k(f_*(j_* I•)) =
H^k((f∘j)_* I•) = R^k (f∘j)_* H`, using `f_* ∘ j_* = (f∘j)_*`. Blueprint:
`lem:open_immersion_pushforward_comp`. Source: Stacks `lemma-relative-affine-vanishing`.
-/

/-- **Higher direct images of an affine open immersion vanish** (part (1) of blueprint
`lem:open_immersion_pushforward_comp`; Stacks `lemma-relative-affine-vanishing`).

For an open immersion `j : U ↪ X` where `U` is affine and `X` is separated, the morphism
`j` is affine (since for any affine open `V ⊆ X`, `j⁻¹V = U ∩ V` is affine by separatedness).
Therefore `R^q j_* H = 0` for every `q ≥ 1` and every quasi-coherent `O_U`-module `H`.

Proof route: by `higherDirectImage_iso_sheafify_presheafHomology`, `R^q j_* H` is the
sheafification of `V ↦ H^q(j⁻¹V, H)`. For affine `V`, `j⁻¹V = U ∩ V` is affine (`U` affine
+ `X` separated), and `affine_serre_vanishing` kills `H^q` for `q ≥ 1`. Since affine opens
form a basis, the presheaf homology is locally zero, and the site lemmas
`isZero_presheafToSheaf_obj_of_isLocallyBijective` (in `CechHigherDirectImage.lean`,
importable via `AffineSerreVanishing`) collapse the sheafification to zero. -/
private lemma isAffineHom_of_affine_separated (j : U ⟶ X) [IsAffine U] [X.IsSeparated] :
    IsAffineHom j := by
  have hg : IsSeparated (terminal.from X) := Scheme.IsSeparated.isSeparated_terminal_from
  have hcomp : IsAffineHom (j ≫ terminal.from X) := by
    have he : j ≫ terminal.from X = terminal.from U := terminal.hom_ext _ _
    rw [he]; infer_instance
  exact IsAffineHom.of_comp j (terminal.from X)

theorem higherDirectImage_openImmersion_acyclic [HasInjectiveResolutions U.Modules]
    (j : U ⟶ X) [IsOpenImmersion j] [IsAffine U] [X.IsSeparated]
    (H : U.Modules) (hH : H.IsQuasicoherent) (q : ℕ) (hq : 0 < q) :
    IsZero (higherDirectImage j q H) := by
  -- `j` is an affine morphism (open immersion of an affine into a separated scheme),
  -- so the preimage of every affine open `V ⊆ X` is the affine open `j⁻¹V = U ∩ V`.
  haveI : IsAffineHom j := isAffineHom_of_affine_separated j
  -- Presheaf description (Stacks 01XJ): `Rᵠ j_* H ≅ sheafify(V ↦ Hᵠ((j_* I•)(V)))`
  -- for any injective resolution `I` of `H`. Reduce to the vanishing of that sheafification.
  refine IsZero.of_iso ?_
    (higherDirectImage_iso_sheafify_presheafHomology j q (injectiveResolution H))
  -- RESIDUAL (genuine cohomological gap, handed off): the sheafification of the presheaf
  -- homology `V ↦ Hᵠ((j_* I•)(V)) = Hᵠ(j⁻¹V, H)` is zero. On the affine basis of `X`,
  -- `j⁻¹V` is affine (`IsAffineHom.isAffine_preimage`), so `affine_serre_vanishing` kills
  -- `Hᵠ` for `q ≥ 1` after transporting the affine `j⁻¹V` to its `Spec Γ`; affine opens
  -- being a basis, the presheaf homology is locally zero and its sheafification vanishes.
  sorry

/-- **Composition formula for higher direct images across an open immersion** (pinned
declaration; blueprint `lem:open_immersion_pushforward_comp`, part (2); Stacks
`lemma-relative-affine-vanishing`).

Let `j : U ↪ X` be an open immersion of an affine open `U` into a separated scheme `X`,
and `f : X ⟶ S` any morphism. For every quasi-coherent `O_U`-module `H` and every `k ≥ 0`:
```
  R^k f_*(j_* H) ≅ R^k (f ∘ j)_* H.
```
Proof route: choose an injective resolution `H → I•` in `U.Modules`; apply `j_*`
degreewise to get an `f_*`-acyclic resolution `j_* I•` of `j_* H`
(`higherDirectImage_openImmersion_acyclic` for `j_*`-acyclicity, extended to
`f_*`-acyclicity via the same Serre-vanishing argument on `U ∩ f⁻¹V`); then
`Functor.rightDerivedIsoOfAcyclicResolution` with `G = (pushforward f)` and the identity
`(pushforward f) ∘ (pushforward j) = pushforward (j ≫ f)` give the stated isomorphism. -/
theorem higherDirectImage_openImmersion_comp
    [HasInjectiveResolutions X.Modules] [HasInjectiveResolutions U.Modules]
    (j : U ⟶ X) [IsOpenImmersion j] [IsAffine U] [X.IsSeparated]
    (f : X ⟶ S) (H : U.Modules) (hH : H.IsQuasicoherent) (k : ℕ) :
    Nonempty (higherDirectImage f k ((pushforward j).obj H) ≅
              higherDirectImage (j ≫ f) k H) := by
  haveI : IsAffineHom j := isAffineHom_of_affine_separated j
  -- Structural plan (all categorical building blocks below are verified to exist):
  --   • `G := Scheme.Modules.pushforward f` is additive and preserves finite limits
  --     (`inferInstance`), so `Functor.rightDerivedIsoOfAcyclicResolution` applies to it.
  --   • The pushed-forward injective resolution `K := (pushforward j).mapHomologicalComplex I•`
  --     is a candidate acyclic resolution of `j_* H = (pushforward j).obj H`.
  --   • `pushforwardComp j f : pushforward j ⋙ pushforward f ≅ pushforward (j ≫ f)` turns
  --     `H^k(G(K))` into `H^k((j ≫ f)_* I•) = R^k (j ≫ f)_* H`.
  -- RESIDUAL (genuine cohomological gaps, handed off — each depends on Part (1)'s residual):
  --   (a) `K` is exact in positive degrees and resolves `j_* H` (i.e. `j_* I•` is a
  --       resolution of `j_* H`) — this is `j_*`-acyclicity, the content of
  --       `higherDirectImage_openImmersion_acyclic` applied to each `Iⁿ` and to `H`.
  --   (b) each term `(pushforward j).obj (Iⁿ)` is `(pushforward f)`-acyclic
  --       (`Functor.IsRightAcyclic`), i.e. `R^k f_*(j_* Iⁿ) = 0` for `k ≥ 1` — the same
  --       Serre-vanishing argument on the affine `U ∩ f⁻¹V` (generalises Part (1) from
  --       `j_*` to `f_*` via the presheaf description on `f⁻¹V`).
  -- Then `Functor.rightDerivedIsoOfAcyclicResolution (pushforward f) K (j_* H) e (a) k`
  -- composed with the `pushforwardComp` transport gives the stated iso.
  sorry

end AlgebraicGeometry
