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

## Declarations

- `cechComplex_hom_identification` (**proved**, line ~241): the per-degree `Ab`-isomorphism
  `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)` intertwining the differentials, assembled cosimplicially
  via `homCechSectionCosimplicialIso` and `(alternatingCofaceMapComplex Ab).mapIso`.

- `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` /
  `quasiIso_map_preadditiveYoneda_of_injective` (**proved**, project-local Mathlib
  supplement below): the categorical bridge step. For an injective object `I` of an abelian
  category, the contravariant `Hom(-, I) = preadditiveYoneda.obj I` is exact (preserves
  finite colimits, hence homology), so it carries a quasi-isomorphism of chain complexes to
  a quasi-isomorphism of the `Hom`-cochain complex. This is the ingredient that turns the
  free-complex resolution `cechFreeComplex_quasiIso` (Lane 1) and
  `cechComplex_hom_identification` into the positive-degree vanishing below.

- `injective_cech_acyclic` (planned, gated on Lane-1 `cechFreeComplex_quasiIso`): Čech
  cohomology vanishes in positive degrees for injective sheaves — a one-step assembly of the
  bridge step here with `cechComplex_hom_identification` once Lane 1 lands.

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

/-- **The hom cochain complex `Hom(K(𝒰)_•, F)`** — the left-hand side of the Čech
hom-identification.

The alternating-coface-map cochain complex of `homCechCosimplicial 𝒰 F`. Built the same way as
`sectionCechComplex` (PresheafCech.lean) so that the planned identification
`cechComplex_hom_identification : homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F` is just
`(alternatingCofaceMapComplex Ab).mapIso` of the cosimplicial natural isomorphism.

Project-local: the hom-complex of the free Čech resolution has no Mathlib counterpart. -/
noncomputable def homCechComplex (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) : CochainComplex Ab.{u} ℕ :=
  (AlgebraicTopology.alternatingCofaceMapComplex Ab.{u}).obj (homCechCosimplicial 𝒰 F)

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
cosimplicial abelian groups. The naturality square reduces, via `homCechSectionIsoApp_hom_π`
in both degrees, to the single naturality square `freeYonedaHomAddEquiv_naturality` of the
free–Yoneda section identification.

Project-local: the cosimplicial comparison of the hom-complex with the section complex has no
Mathlib counterpart. -/
noncomputable def homCechSectionCosimplicialIso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) :
    homCechCosimplicial 𝒰 F ≅ sectionCechCosimplicial (coverOpen 𝒰) F :=
  NatIso.ofComponents (homCechSectionIsoApp 𝒰 F) (by
    intro n m f
    apply Limits.Pi.hom_ext
    intro σ
    dsimp only [sectionCechCosimplicial]
    rw [Category.assoc, Category.assoc, Pi.lift_π]
    erw [homCechSectionIsoApp_hom_π 𝒰 F m σ]
    conv_rhs => rw [← Category.assoc]
    erw [homCechSectionIsoApp_hom_π 𝒰 F n (σ ∘ ⇑(SimplexCategory.Hom.toOrderHom f))]
    erw [Category.assoc]
    erw [← freeYonedaHomAddEquiv_naturality
        (homOfLE (coverInterOpen_comp_le 𝒰 ⇑(SimplexCategory.Hom.toOrderHom f) σ)) F]
    dsimp only [homCechCosimplicial, Functor.comp_map, Functor.rightOp_map]
    erw [← Category.assoc, ← Functor.map_comp, ← Category.assoc, ← Functor.map_comp]
    congr 1
    congr 1
    apply Quiver.Hom.unop_inj
    simp only [unop_comp]
    dsimp only [cechFreeSimplicial]
    erw [Limits.Sigma.ι_desc]
    rfl
    )

/-- **The Čech hom-identification** (blueprint `lem:cech_complex_hom_identification`).

The cochain-complex isomorphism `Hom_{PMod}(K(𝒰)_•, F) ≅ Č•(𝒰, F)` identifying the
hom-complex of the free Čech resolution with the section Čech complex of `F`. Obtained by
applying the alternating-coface-map complex functor to the cosimplicial natural isomorphism
`homCechSectionCosimplicialIso`, so the differential intertwining is automatic from the
cosimplicial naturality.

Project-local: the comparison of the free-resolution hom-complex with the section complex has
no Mathlib counterpart. -/
noncomputable def cechComplex_hom_identification (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) :
    homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F :=
  (AlgebraicTopology.alternatingCofaceMapComplex Ab.{u}).mapIso (homCechSectionCosimplicialIso 𝒰 F)

/-! ## Project-local Mathlib supplement — hom-complex as contravariant transport

The injective-acyclicity assembly (`lem:injective_cech_acyclic`, gated on Lane-1's
`cechFreeComplex_quasiIso`) needs `homCechComplex 𝒰 F` — the alternating *coface* complex of
the hom-cosimplicial object `homCechCosimplicial 𝒰 F` — to be identified with the
contravariant transport `Hom(-, F) = preadditiveYoneda.obj F` of the *opposite* of the free
Čech chain complex `cechFreePresheafComplex 𝒰`.  Once this identification is in hand,
`quasiIso_map_preadditiveYoneda_of_injective` (applied to `(cechFreeComplexAug 𝒰).op`) and
`cechComplex_hom_identification` combine in a single step to turn the free resolution into
Čech acyclicity of injective sheaves.

Project-local: the comparison of the alternating-coface hom-complex with the mapped opposite
of the alternating-face free complex has no Mathlib counterpart. -/

/-- The `i`-th coface of `homCechCosimplicial 𝒰 F` is `Hom(-, F)` applied to the opposite of
the `i`-th face of `cechFreeSimplicial 𝒰`.  Holds definitionally (both unfold to
`(preadditiveYoneda.obj F).map ((cechFreeSimplicial 𝒰).map (SimplexCategory.δ i).op).op`);
isolated as a `rfl` lemma to drive the differential identification `homCechComplex_d_eq`. -/
private lemma homCechCosimplicial_δ (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) {n : ℕ} (i : Fin (n + 2)) :
    (homCechCosimplicial 𝒰 F).δ i
      = (preadditiveYoneda.obj F).map ((cechFreeSimplicial 𝒰).δ i).op :=
  rfl

/-- **Degreewise differential identification** of the hom-complex with the mapped opposite of
the free Čech complex.  Both differentials are alternating sums of (co)faces; pushing the
opposite and the additive functor `Hom(-, F)` through the alternating sum on the right and
using `homCechCosimplicial_δ` matches them term by term.  This is the naturality input for the
cochain-complex isomorphism `homCechComplexMapOpIso`. -/
private lemma homCechComplex_d_eq (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) (p : ℕ) :
    (homCechComplex 𝒰 F).d p (p + 1)
      = (((preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.up ℕ)).obj
          (HomologicalComplex.op (cechFreePresheafComplex 𝒰))).d p (p + 1) := by
  have hL : (homCechComplex 𝒰 F).d p (p + 1)
      = AlgebraicTopology.AlternatingCofaceMapComplex.objD (homCechCosimplicial 𝒰 F) p :=
    CochainComplex.of_d _ _ (AlgebraicTopology.AlternatingCofaceMapComplex.d_squared _) p
  have hR : (cechFreePresheafComplex 𝒰).d (p + 1) p
      = AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰) p :=
    ChainComplex.of_d _ _ (AlgebraicTopology.AlternatingFaceMapComplex.d_squared _) p
  rw [hL, AlgebraicTopology.AlternatingCofaceMapComplex.objD,
    Functor.mapHomologicalComplex_obj_d, HomologicalComplex.op_d, hR,
    AlgebraicTopology.AlternatingFaceMapComplex.objD]
  have hop := CategoryTheory.op_sum
    ((cechFreeSimplicial 𝒰).obj (Opposite.op (SimplexCategory.mk (p + 1))))
    ((cechFreeSimplicial 𝒰).obj (Opposite.op (SimplexCategory.mk p)))
    (Finset.univ : Finset (Fin (p + 2)))
    (fun i => (-1 : ℤ) ^ (i : ℕ) • (cechFreeSimplicial 𝒰).δ i)
  erw [hop, Functor.map_sum]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [homCechCosimplicial_δ, CategoryTheory.op_zsmul]
  erw [Functor.map_zsmul]
  rfl

/-- **Hom-complex as contravariant transport of the free Čech complex.**

The cochain-complex isomorphism `Hom(K(𝒰)_•, F) ≅ Hom(-, F)((K(𝒰)_•)ᵒᵖ)` identifying the
alternating-coface hom-complex `homCechComplex 𝒰 F` with the contravariant transport
`(preadditiveYoneda.obj F).mapHomologicalComplex` of the opposite of the free Čech chain
complex `cechFreePresheafComplex 𝒰`.  Degreewise the two complexes have the *same* term
(`Hom_{PMod}(K(𝒰)_p, F)`), so the components are identities; the differential squares are
`homCechComplex_d_eq`.

This is the bridge that turns Lane-1's free resolution into Čech acyclicity: applying
`quasiIso_map_preadditiveYoneda_of_injective` to `(cechFreeComplexAug 𝒰).op` produces a
quasi-isomorphism of mapped-opposite complexes, and this iso transports it onto
`homCechComplex 𝒰 F` (hence, via `cechComplex_hom_identification`, onto `sectionCechComplex`).

Project-local: the identification of the alternating-coface hom-complex with the mapped
opposite of the alternating-face free complex has no Mathlib counterpart. -/
noncomputable def homCechComplexMapOpIso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) :
    homCechComplex 𝒰 F ≅
      ((preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (HomologicalComplex.op (cechFreePresheafComplex 𝒰)) :=
  HomologicalComplex.Hom.isoOfComponents (fun _ => Iso.refl _) (by
    rintro i j (rfl : i + 1 = j)
    simp only [Iso.refl_hom, Category.id_comp, Category.comp_id]
    exact homCechComplex_d_eq 𝒰 F i)

/-! ## Project-local Mathlib supplement — `Hom(-, I)` is exact for injective `I`

The presheaf-level Čech-acyclicity argument (`lem:injective_cech_acyclic`) needs the single
categorical fact that, for an injective object `I` of an abelian category, the contravariant
hom functor `Hom(-, I)` is exact — equivalently, the covariant functor
`preadditiveYoneda.obj I : Cᵒᵖ ⥤ Ab` preserves homology. Mathlib supplies the two pieces:
`preadditiveYoneda.obj I` always preserves finite limits (it is left exact), and injectivity
is equivalent to it preserving epimorphisms; we assemble these into preservation of finite
colimits (hence of homology), and feed the result through
`HomologicalComplex.quasiIsoAt_map_of_preservesHomology` to obtain quasi-isomorphism
preservation. These are stated for a general abelian category so they apply verbatim to
`X.PresheafOfModules` once the injectivity of `I` as a presheaf of modules is in hand.

Project-local: Mathlib has the ingredients but not the packaged exactness of `Hom(-, I)` as a
homology-preserving functor. -/

section InjectiveHomExact

open CategoryTheory Limits

variable {C : Type*} [Category C] [Abelian C]

/-- **`Hom(-, I)` preserves finite colimits for injective `I`.** For an injective object `I`
of an abelian category, the covariant functor `preadditiveYoneda.obj I : Cᵒᵖ ⥤ Ab`
preserves finite colimits: it is left exact (preserves finite limits) automatically, and
injectivity makes it preserve epimorphisms, which together with left exactness gives
exactness. Combined with the automatic `PreservesFiniteLimits` instance this yields
`(preadditiveYoneda.obj I).PreservesHomology` by `Functor.preservesHomologyOfExact`.

Project-local: the exactness of `Hom(-, I)` for injective `I` is the categorical engine of
`lem:injective_cech_acyclic`. -/
instance preadditiveYoneda_obj_preservesFiniteColimits_of_injective
    (I : C) [Injective I] : PreservesFiniteColimits (preadditiveYoneda.obj I) := by
  have hepi : (preadditiveYoneda.obj I).PreservesEpimorphisms :=
    (Injective.injective_iff_preservesEpimorphisms_preadditiveYoneda_obj I).mp inferInstance
  rw [Functor.preservesFiniteColimits_iff_forall_exact_map_and_epi]
  intro S hS
  have hg := hS.epi_g
  exact ⟨hS.exact.map_of_mono_of_preservesKernel _ hS.mono_f inferInstance,
    hepi.preserves S.g⟩

/-- **`Hom(-, I)` carries quasi-isomorphisms to quasi-isomorphisms for injective `I`.**
Since `preadditiveYoneda.obj I` preserves homology
(`preadditiveYoneda_obj_preservesFiniteColimits_of_injective`), applying it degreewise to a
quasi-isomorphism `φ` of chain complexes in `Cᵒᵖ` produces a quasi-isomorphism of the
`Hom`-cochain complexes. This is the form consumed by `injective_cech_acyclic`: the
augmentation `cechFreeComplexAug 𝒰` (a quasi-isomorphism once Lane 1 lands), taken opposite
and mapped through `preadditiveYoneda.obj F`, stays a quasi-isomorphism.

Project-local: packages `quasiIsoAt_map_of_preservesHomology` against the injective-hom
exactness instance above. -/
lemma quasiIso_map_preadditiveYoneda_of_injective (I : C) [Injective I]
    {ι : Type*} {c : ComplexShape ι} {K L : HomologicalComplex Cᵒᵖ c}
    (φ : K ⟶ L) [QuasiIso φ] :
    QuasiIso (((preadditiveYoneda.obj I).mapHomologicalComplex c).map φ) := by
  rw [quasiIso_iff]
  intro i
  exact HomologicalComplex.quasiIsoAt_map_of_preservesHomology φ (preadditiveYoneda.obj I) i
    (hφ := QuasiIso.quasiIsoAt (f := φ) i)

end InjectiveHomExact

end AlgebraicGeometry
