/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.PresheafCech
import AlgebraicJacobian.Cohomology.FreePresheafComplex

/-!
# Čech bridge — assembly layer

This file is the downstream assembly layer that consumes both:

- `AlgebraicGeometry.sectionCechComplex` (from `PresheafCech.lean`): the section Čech
  cochain complex `Č•(𝒰, F) : CochainComplex Ab ℕ` built cosimplicially from
  `alternatingCofaceMapComplex`.

- `AlgebraicGeometry.cechFreePresheafComplex` (from `FreePresheafComplex.lean`): the
  free-presheaf chain complex `K(𝒰)_• : ChainComplex X.PresheafOfModules ℕ` whose
  degree-`p` term is `∐_{σ : Fin(p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)`.

The reason this file must sit downstream of both is that `FreePresheafComplex.lean`
already imports `PresheafCech.lean`, so any file needing both must import
`FreePresheafComplex.lean` (which transitively brings in `PresheafCech.lean`).

## Declarations (to be filled by the prover)

- `cechComplex_hom_identification` (planned): a per-degree `Ab`-isomorphism
  `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)` intertwining the differentials, assembled with
  `HomologicalComplex.Hom.isoOfComponents`.

- `injective_cech_acyclic` (planned): Čech cohomology vanishes in positive degrees for
  injective sheaves, established via `cechComplex_hom_identification`.

- `ses_cech_h1` (planned): the short exact sequence in Čech H¹ induced by a short exact
  sequence of sheaves.

- `cech_eq_cohomology_of_basis` / `affine_serre_vanishing` (planned): the comparison
  isomorphism `Ȟ•(𝒰, F) ≅ H•(X, F)` on affine schemes / for acyclic covers, leading to
  Serre's vanishing theorem.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-
Planner strategy for `cechComplex_hom_identification`:
────────────────────────────────────────────────────────────────────────────────

Goal: construct a cochain-complex isomorphism
  `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)`
where:
  • `K(𝒰)_p = ∐_{σ : Fin(p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)`
    (the degree-`p` term of `cechFreePresheafComplex 𝒰`)
  • `Č^p(𝒰, F) = ∏_{σ : Fin(p+1) → 𝒰.I₀} F.obj (coverInterOpen 𝒰 σ)`
    (the degree-`p` term of `sectionCechComplex 𝒰 F`)
  Both complexes live in `Ab` after applying the global-sections functor.

Step 1 — per-degree hom-coproduct duality:
  For each `p`, the Yoneda/free-presheaf adjunction gives
    `Hom(freeYoneda.obj V, F) ≅ F.obj V`  (natural in `V`).
  This is exactly `AlgebraicGeometry.freeYonedaHomAddEquiv` from `PresheafCech.lean`.
  Combined with the coproduct-hom identity
    `Hom(∐_σ A_σ, F) ≅ ∏_σ Hom(A_σ, F)`
  (via `preadditiveYoneda` preservation of limits, or hand-rolled from
  `Limits.Sigma.desc` / `Limits.Sigma.ι`), we get a degree-wise `Ab`-iso
    `Hom(K(𝒰)_p, F) ≅ ∏_σ F.obj (coverInterOpen 𝒰 σ) = Č^p(𝒰, F)`.

Step 2 — differential intertwining:
  Show that the degree-wise isos commute with the differentials.  The differential on
  `Hom(K(𝒰)_•, F)` is precomposition with the Čech boundary `d_p : K(𝒰)_{p+1} → K(𝒰)_p`
  (the alternating sum of face maps of `cechFreeSimplicial`).  The differential on
  `Č•(𝒰, F)` is the alternating sum of restriction maps built by `sectionCechComplex`.
  These match under the per-degree iso by naturality of `freeYonedaHomAddEquiv`.

Step 3 — assemble:
  Use `HomologicalComplex.Hom.isoOfComponents` (or equivalent) to combine the per-degree
  isos into a full cochain-complex iso, supplying the naturality squares from Step 2.

Key API:
  • `AlgebraicGeometry.freeYonedaHomAddEquiv` (PresheafCech.lean): the per-degree iso.
  • `Limits.Sigma.desc`, `Limits.Sigma.ι`: coproduct universal property in
    `X.PresheafOfModules`.
  • `HomologicalComplex.Hom.isoOfComponents`: assemble component-wise isos into a
    full complex iso.
  • `sectionCechComplex` (PresheafCech.lean): the target complex.
  • `cechFreePresheafComplex` / `cechFreePresheafComplex_X` (FreePresheafComplex.lean):
    the source complex and its degreewise unfolding lemma.
-/

/-! ## Project-local Mathlib supplement — Čech hom-identification -/

variable {X : Scheme.{u}}

/-- **The hom cosimplicial abelian group `Hom(K(𝒰)_•, F)`.**

The cosimplicial object in `Ab` obtained by applying the contravariant additive functor
`Hom_{PMod}(-, F) = preadditiveYoneda.obj F` to the free Čech simplicial object
`cechFreeSimplicial 𝒰`.  Its value in degree `p` is the hom-group
`Hom_{PMod}(K(𝒰)_p, F)`, and its alternating-coface-map cochain complex is the left-hand
side of the Čech hom-identification.  Defining it this way makes the differential of the
hom-complex literally the alternating sum of `Hom(faceᵢ, F)`, so the identification with
`sectionCechComplex` reduces to a cosimplicial natural isomorphism.

Project-local: Mathlib has neither `cechFreeSimplicial` nor this contravariant transport. -/
noncomputable def homCechCosimplicial (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) : CosimplicialObject Ab.{u} :=
  (cechFreeSimplicial 𝒰).rightOp ⋙ preadditiveYoneda.obj F

/-- **Per-degree component of the Čech hom-identification.**

For each simplicial degree `n`, the abelian-group isomorphism
`Hom_{PMod}(K(𝒰)_n, F) ≅ ∏_σ F(⨅ₖ U(σ k))` assembled from (i) the coproduct–hom duality
`Hom(∐_σ Aσ, F) ≅ ∏_σ Hom(Aσ, F)` (the additive functor `Hom(-, F)` preserves the limit,
so `piComparison` is an iso, combined with `opCoproductIsoProduct`), and (ii) the per-index
free–Yoneda section identification `freeYonedaHomAddEquiv`.

Project-local: this is the degreewise core of `lem:cech_complex_hom_identification`. -/
noncomputable def homCechSectionIsoApp (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) (n : SimplexCategory) :
    (homCechCosimplicial 𝒰 F).obj n ≅ (sectionCechCosimplicial (coverOpen 𝒰) F).obj n :=
  (preadditiveYoneda.obj F).mapIso
      (opCoproductIsoProduct
        (fun σ : Fin (n.len + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)))
    ≪≫ asIso (piComparison (preadditiveYoneda.obj F)
        (fun σ : Fin (n.len + 1) → 𝒰.I₀ => Opposite.op (freeYoneda.obj (coverInterOpen 𝒰 σ))))
    ≪≫ Limits.Pi.mapIso (fun σ : Fin (n.len + 1) → 𝒰.I₀ =>
        (freeYonedaHomAddEquiv (coverInterOpen 𝒰 σ) F).toAddCommGrpIso)

/-- `Pi.mapIso e` is by definition `Pi.map (fun b => (e b).hom)`. -/
private lemma pi_mapIso_hom_eq {β : Type*} {C : Type*} [Category C] {f g : β → C}
    [HasProductsOfShape β C] (e : ∀ b, f b ≅ g b) :
    (Limits.Pi.mapIso e).hom = Limits.Pi.map (fun b => (e b).hom) := rfl

/-- Characterizing property of `homCechSectionIsoApp`: its `σ`-component is precomposition
with the coproduct injection `Sigma.ι σ` followed by the free–Yoneda section identification.
Reduces the naturality of the assembled iso to the naturality of `freeYonedaHomAddEquiv`. -/
private lemma homCechSectionIsoApp_hom_π (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) (n : SimplexCategory) (σ : Fin (n.len + 1) → 𝒰.I₀) :
    (homCechSectionIsoApp 𝒰 F n).hom ≫
        Pi.π (fun τ : Fin (n.len + 1) → 𝒰.I₀ =>
          F.presheaf.obj (Opposite.op (coverInterOpen 𝒰 τ))) σ =
      (preadditiveYoneda.obj F).map
          (Limits.Sigma.ι (fun τ : Fin (n.len + 1) → 𝒰.I₀ =>
            freeYoneda.obj (coverInterOpen 𝒰 τ)) σ).op ≫
        (freeYonedaHomAddEquiv (coverInterOpen 𝒰 σ) F).toAddCommGrpIso.hom := by
  rw [homCechSectionIsoApp, Iso.trans_hom, Iso.trans_hom, Functor.mapIso_hom, asIso_hom,
    pi_mapIso_hom_eq]
  simp only [Category.assoc]
  erw [Pi.map_π, piComparison_comp_π_assoc]
  rw [← Category.assoc]
  congr 1
  exact ((preadditiveYoneda.obj F).map_comp _ _).symm.trans
    (congrArg _ (opCoproductIsoProduct_hom_comp_π σ))

/-- **Naturality of the free–Yoneda section identification in the open.**

For an inclusion of opens `h : V ⟶ W`, precomposition with `freeYoneda.map h` on the hom-side
corresponds to restriction `F.presheaf.map h.op` on the section side.  This is the single
naturality square that powers the cosimplicial naturality of the Čech hom-identification. -/
private lemma freeYonedaHomAddEquiv_naturality {V W : TopologicalSpace.Opens ↥X}
    (h : V ⟶ W) (F : X.PresheafOfModules) :
    (preadditiveYoneda.obj F).map (freeYoneda.map h).op ≫
        (freeYonedaHomAddEquiv V F).toAddCommGrpIso.hom
      = (freeYonedaHomAddEquiv W F).toAddCommGrpIso.hom ≫ F.presheaf.map h.op := by
  ext ψ
  show freeYonedaHomEquiv V F (freeYoneda.map h ≫ ψ)
      = (ConcreteCategory.hom (F.presheaf.map h.op)) (freeYonedaHomEquiv W F ψ)
  show yonedaEquiv (PresheafOfModules.freeHomEquiv (freeYoneda.map h ≫ ψ))
      = (ConcreteCategory.hom (F.presheaf.map h.op))
          (yonedaEquiv (PresheafOfModules.freeHomEquiv ψ))
  rw [show PresheafOfModules.freeHomEquiv (freeYoneda.map h ≫ ψ)
        = yoneda.map h ≫ PresheafOfModules.freeHomEquiv ψ from
      (PresheafOfModules.freeAdjunction _).homEquiv_naturality_left (yoneda.map h) ψ,
    ← yonedaEquiv_naturality]
  rfl

/-- **The cosimplicial natural isomorphism `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)`.**

Assembles the per-degree isomorphisms `homCechSectionIsoApp` into a natural isomorphism of
cosimplicial abelian groups; the naturality squares reduce, via `homCechSectionIsoApp_hom_π`
and `freeYonedaHomAddEquiv_naturality`, to the index-dropping compatibility of the free Čech
simplicial maps with the section restriction maps. -/
noncomputable def homCechSectionCosimplicialIso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) :
    homCechCosimplicial 𝒰 F ≅ sectionCechCosimplicial (coverOpen 𝒰) F :=
  NatIso.ofComponents (fun n => homCechSectionIsoApp 𝒰 F n) (by
    intro m n f
    apply Limits.Pi.hom_ext
    intro σ
    sorry)

end AlgebraicGeometry
