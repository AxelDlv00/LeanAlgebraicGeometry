/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.PresheafCech
import AlgebraicJacobian.Cohomology.FreePresheafComplex
import AlgebraicJacobian.Cohomology.CechAcyclic

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

- `homCechComplexMapOpIso` / `sectionCechComplexMapOpIso` (**proved**, project-local Mathlib
  supplement below): the contravariant-transport bridge. `homCechComplexMapOpIso` identifies
  the alternating-coface hom-complex `homCechComplex 𝒰 F` with the mapped opposite
  `Hom(-, F)((K(𝒰)_•)ᵒᵖ)` of the free Čech complex (same degreewise terms; the differential
  squares are the degreewise identity `homCechComplex_d_eq`).  `sectionCechComplexMapOpIso`
  composes it with `cechComplex_hom_identification` to identify `Č•(coverOpen 𝒰, F)` with the
  mapped opposite of the free complex.  This is the precise bridge that lets
  `quasiIso_map_preadditiveYoneda_of_injective` turn Lane-1's free resolution into Čech
  acyclicity in a single step.

- `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` /
  `quasiIso_map_preadditiveYoneda_of_injective` (**proved**, project-local Mathlib
  supplement below): the categorical bridge step. For an injective object `I` of an abelian
  category, the contravariant `Hom(-, I) = preadditiveYoneda.obj I` is exact (preserves
  finite colimits, hence homology), so it carries a quasi-isomorphism of chain complexes to
  a quasi-isomorphism of the `Hom`-cochain complex. This is the ingredient that turns the
  free-complex resolution `cechFreeComplex_quasiIso` (Lane 1) and
  `cechComplex_hom_identification` into the positive-degree vanishing below.

- `injective_cech_acyclic` (planned, gated on Lane-1 `cechFreeComplex_quasiIso`): Čech
  cohomology vanishes in positive degrees for injective sheaves — now a one-step assembly of
  `quasiIso_map_preadditiveYoneda_of_injective` with `sectionCechComplexMapOpIso` once Lane 1
  lands.

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
    exact (Category.id_comp _).trans
      ((homCechComplex_d_eq 𝒰 F i).symm.trans (Category.comp_id _).symm))

/-- **Section Čech complex as contravariant transport of the free Čech complex.**

Composing `homCechComplexMapOpIso` with the Čech hom-identification
`cechComplex_hom_identification` gives a cochain-complex isomorphism between the mapped
opposite of the free Čech complex and the section Čech complex `Č•(coverOpen 𝒰, F)`.  This is
the single isomorphism needed for the injective-acyclicity assembly: once Lane 1 provides
`QuasiIso (cechFreeComplexAug 𝒰)`, mapping its opposite through `preadditiveYoneda.obj F`
(quasi-iso by `quasiIso_map_preadditiveYoneda_of_injective`) and transporting the source/target
across this iso identifies `sectionCechComplex` with the mapped opposite of a complex
concentrated in degree `0`, giving positive-degree vanishing.

Project-local: assembled from two project-local isomorphisms. -/
noncomputable def sectionCechComplexMapOpIso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) :
    ((preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (HomologicalComplex.op (cechFreePresheafComplex 𝒰))
      ≅ sectionCechComplex (coverOpen 𝒰) F :=
  (homCechComplexMapOpIso 𝒰 F).symm ≪≫ cechComplex_hom_identification 𝒰 F

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

/-! ## Project-local Mathlib supplement — Čech `H¹` vanishing ⟹ cocycles are coboundaries

The surjectivity-on-sections step `ses_cech_h1` (blueprint `lem:ses_cech_h1`, Stacks
`lemma-ses-cech-h1`) consumes the {\v C}ech-algebra fact that a covering with
`Ȟ¹(𝒰, F) = 0` has *every* {\v C}ech `1`-cocycle equal to a coboundary. This is the
`\uses{def:cech_complex}` content of that lemma, isolated here as a self-contained
statement about the section {\v C}ech complex `sectionCechComplex` (no sheaf gluing or
local-surjectivity input). It is the converse direction of
`sectionCech_isZero_homology_of_objD_exact` (CechAcyclic), packaged in section
coordinates via `sectionCechProductEquiv` / `sectionCech_objD_apply`.

Project-local: Mathlib has no {\v C}ech complex of sections of a presheaf of modules, so
neither the homology-to-exactness reduction nor its coordinate form exist there. -/

section CechH1Coboundary

open AlgebraicTopology

/-- **Homology vanishing ⟹ coface-differential exactness** (converse of
`sectionCech_isZero_homology_of_objD_exact`). If the degree-`(q+1)` homology of the
section {\v C}ech complex vanishes, the underlying group homomorphisms of the two
consecutive coface differentials `objD q`, `objD (q+1)` form an exact sequence. Pure
homological algebra: the same `exactAt_iff_isZero_homology` / `exactAt_iff'` /
`ShortComplex.ab_exact_iff_function_exact` chain, run in the extraction direction.

Project-local: extraction form of the `Ab`-side homology bridge of
`lem:section_cech_homology_exact`, needed by the `ses_cech_h1` coboundary step. -/
theorem sectionCech_objD_exact_of_isZero_homology {ι : Type u}
    (U : ι → TopologicalSpace.Opens X) (F : X.PresheafOfModules) (q : ℕ)
    (h : IsZero ((sectionCechComplex U F).homology (q + 1))) :
    Function.Exact
      (ConcreteCategory.hom (AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U F) q))
      (ConcreteCategory.hom
        (AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U F) (q + 1))) := by
  have hf : (sectionCechComplex U F).d q (q + 1)
      = AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U F) q :=
    CochainComplex.of_d _ _ (AlternatingCofaceMapComplex.d_squared _) q
  have hg : (sectionCechComplex U F).d (q + 1) (q + 2)
      = AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U F) (q + 1) :=
    CochainComplex.of_d _ _ (AlternatingCofaceMapComplex.d_squared _) (q + 1)
  have key : Function.Exact
      (ConcreteCategory.hom ((sectionCechComplex U F).d q (q + 1)))
      (ConcreteCategory.hom ((sectionCechComplex U F).d (q + 1) (q + 2))) := by
    have hh := h
    rw [← HomologicalComplex.exactAt_iff_isZero_homology,
        (sectionCechComplex U F).exactAt_iff' q (q + 1) (q + 2) (by simp) (by simp),
        ShortComplex.ab_exact_iff_function_exact] at hh
    exact hh
  rw [hf, hg] at key
  exact key

/-- **Čech `1`-cocycles are coboundaries when `Ȟ¹(𝒰, F) = 0`** — the
`\uses{def:cech_complex}` heart of `ses_cech_h1`.

Working in the section coordinates of `sectionCechCosimplicial` (a family of sections
`c σ ∈ F(⨅ₖ U (σ k))` indexed by double-indices `σ : Fin 2 → ι`), if the family
satisfies the {\v C}ech `1`-cocycle identity (the alternating sum of its restrictions
over each triple-index `σ : Fin 3 → ι` vanishes) and the degree-`1` homology of the
section {\v C}ech complex vanishes, then `c` is a coboundary: there is a `0`-cochain
`t` (sections `t σ ∈ F(U (σ 0))` over single-indices) with `c σ` the alternating sum
of the face restrictions of `t`, i.e. `c σ = t_{σ 1}|_{σ} - t_{σ 0}|_{σ}` once the
two-term sum is expanded. The restriction maps are `sectionCechFaceRestr`, exactly the
{\v C}ech coface restrictions appearing in `sectionCech_objD_apply`.

Project-local: the section-coordinate coboundary extraction for the section {\v C}ech
complex has no Mathlib counterpart. -/
theorem sectionCech_one_coboundary_of_isZero_homology {ι : Type u}
    (U : ι → TopologicalSpace.Opens X) (F : X.PresheafOfModules)
    (h : IsZero ((sectionCechComplex U F).homology 1))
    (c : ∀ σ : Fin 2 → ι, F.presheaf.obj (Opposite.op (⨅ k, U (σ k))))
    (hcoc : ∀ σ : Fin 3 → ι,
      ∑ i : Fin 3, (-1 : ℤ) ^ (i : ℕ) •
        ConcreteCategory.hom (sectionCechFaceRestr U F σ i)
          (c (σ ∘ (SimplexCategory.δ i).toOrderHom)) = 0) :
    ∃ t : ∀ σ : Fin 1 → ι, F.presheaf.obj (Opposite.op (⨅ k, U (σ k))),
      ∀ σ : Fin 2 → ι, c σ = ∑ i : Fin 2, (-1 : ℤ) ^ (i : ℕ) •
        ConcreteCategory.hom (sectionCechFaceRestr U F σ i)
          (t (σ ∘ (SimplexCategory.δ i).toOrderHom)) := by
  have he := sectionCech_objD_exact_of_isZero_homology U F 0 h
  set c' : ToType ((sectionCechCosimplicial U F).obj (SimplexCategory.mk 1)) :=
    (sectionCechProductEquiv U F 1).symm c with hc'
  have hpe1 : sectionCechProductEquiv U F 1 c' = c :=
    (sectionCechProductEquiv U F 1).apply_symm_apply c
  have hzero : ConcreteCategory.hom
      (AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U F) 1) c' = 0 := by
    apply (sectionCechProductEquiv U F 2).injective
    funext σ
    rw [sectionCech_objD_apply U F 1 c' σ, hpe1]
    rw [show sectionCechProductEquiv U F 2 0 σ = 0 from by
      rw [sectionCechProductEquiv_apply]; exact map_zero _]
    exact hcoc σ
  obtain ⟨b, hb⟩ := (he c').mp hzero
  refine ⟨sectionCechProductEquiv U F 0 b, fun σ => ?_⟩
  rw [← hpe1, ← hb, sectionCech_objD_apply U F 0 b σ]

end CechH1Coboundary

/-! ## Project-local Mathlib supplement — surjectivity on sections from {\v C}ech-`H¹`
vanishing (`ses_cech_h1`)

This section assembles the {\v C}ech-`H¹` vanishing into the surjectivity statement
`ses_cech_h1` (blueprint `lem:ses_cech_h1`, Stacks `lemma-ses-cech-h1`).  The
{\v C}ech-algebra heart is `sectionCech_one_coboundary_of_isZero_homology` (the
cocycle-to-coboundary extraction proven above); the remaining content is the standard
sheaf theory — local lifting, left-exactness on sections, and gluing — which here is
supplied through Mathlib's `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` and a handful of
restriction-bookkeeping helpers.

Project-local: Mathlib has no {\v C}ech complex of sections of a presheaf of modules, so
the surjectivity criterion phrased through `sectionCechComplex` is new here. -/

section SesCechH1

open AlgebraicTopology TopologicalSpace Opposite

/-- **Composite of two presheaf restrictions is the direct restriction.**
For `A ≤ B ≤ C` the restriction `P(C) → P(B)` followed by `P(B) → P(A)` equals the direct
restriction `P(C) → P(A)`.  Holds definitionally for `Ab`-valued presheaves on opens
because the composite of the opposite `homOfLE`s is the opposite `homOfLE` of the
composite.  Used pervasively to collapse restriction chains in `ses_cech_h1`. -/
private lemma restr_trans (P : (Opens ↥X)ᵒᵖ ⥤ Ab.{u}) {A B C : Opens ↥X}
    (h1 : A ≤ B) (h2 : B ≤ C) (x : ToType (P.obj (op C))) :
    ConcreteCategory.hom (P.map (homOfLE h1).op)
        (ConcreteCategory.hom (P.map (homOfLE h2).op) x)
      = ConcreteCategory.hom (P.map (homOfLE (h1.trans h2)).op) x := by
  rw [← ConcreteCategory.comp_apply, ← P.map_comp, ← op_comp]
  rfl

/-- **Restriction between two equal opens is injective.**  When `V ≤ W` and `W ≤ V`
(i.e. `V = W`) the restriction `P(W) → P(V)` is injective: the reverse restriction is a
two-sided inverse (`restr_trans` collapses the round trip to the identity, by uniqueness of
poset morphisms).  Used to transport the {\v C}ech compatibility equation between the binary
intersection `U i ⊓ U j` and the {\v C}ech double-overlap `⨅ₖ U (![i,j] k)`. -/
private lemma restr_inj_of_eq (P : (Opens ↥X)ᵒᵖ ⥤ Ab.{u}) {V W : Opens ↥X}
    (h : V ≤ W) (h' : W ≤ V) :
    Function.Injective (ConcreteCategory.hom (P.map (homOfLE h).op)) := by
  intro a b hab
  have h2 := congrArg (ConcreteCategory.hom (P.map (homOfLE h').op)) hab
  rw [restr_trans, restr_trans] at h2
  rwa [Subsingleton.elim (homOfLE (h'.trans h)) (𝟙 _), op_id, P.map_id,
    ConcreteCategory.id_apply, ConcreteCategory.id_apply] at h2

/-- **Composite of two presheaf restrictions equals any direct restriction.**  A
name-agnostic variant of `restr_trans`: works for *any* opposite-opens morphisms (not only
syntactic `homOfLE`), using uniqueness of poset morphisms.  This is the robust form used to
collapse restriction chains involving `Opens.infLELeft`/`Opens.leSupr`/`sectionCechFaceRestr`,
none of which are syntactically `homOfLE`. -/
private lemma restr_comp_unique (P : (Opens ↥X)ᵒᵖ ⥤ Ab.{u}) {A B C : Opens ↥X}
    (f : Opposite.op B ⟶ Opposite.op A) (g : Opposite.op C ⟶ Opposite.op B)
    (h : Opposite.op C ⟶ Opposite.op A) (x : ToType (P.obj (Opposite.op C))) :
    ConcreteCategory.hom (P.map f) (ConcreteCategory.hom (P.map g) x)
      = ConcreteCategory.hom (P.map h) x := by
  rw [← ConcreteCategory.comp_apply, ← P.map_comp,
    show g ≫ f = h from Quiver.Hom.unop_inj (Subsingleton.elim _ _)]

/-- **Two parallel restrictions agree.**  Any two restriction maps `P(A) → P(C)` (opposite
opens morphisms) act identically, by uniqueness of poset morphisms.  Used to discharge the
final defeq-up-to-proof-irrelevance step after collapsing restriction chains with
`← ConcreteCategory.comp_apply, ← Functor.map_comp`. -/
private lemma restr_op_unique (P : (Opens ↥X)ᵒᵖ ⥤ Ab.{u}) {A C : Opens ↥X}
    (f g : Opposite.op C ⟶ Opposite.op A) (x : ToType (P.obj (Opposite.op C))) :
    ConcreteCategory.hom (P.map f) x = ConcreteCategory.hom (P.map g) x := by
  rw [show f = g from Quiver.Hom.unop_inj (Subsingleton.elim _ _)]

/-- **A morphism of presheaves of modules commutes with the {\v C}ech face restrictions.**
For `fι : F.presheaf ⟶ G.presheaf` the section-level map `fι.app` intertwines the
{\v C}ech face restriction `sectionCechFaceRestr` of `F` with that of `G`; this is just
the naturality of `fι`.  It is the single naturality input that pushes the cocycle and
coboundary identities of the heart between `F` and `G`. -/
private lemma fι_sectionCechFaceRestr {ι : Type u} (U : ι → Opens ↥X)
    (F G : X.PresheafOfModules) (fι : F.presheaf ⟶ G.presheaf)
    {q : ℕ} (σ : Fin (q + 2) → ι) (i : Fin (q + 2))
    (x : ToType (F.presheaf.obj
      (op (⨅ l, U ((σ ∘ (SimplexCategory.δ i).toOrderHom) l))))) :
    ConcreteCategory.hom (sectionCechFaceRestr U G σ i)
        (ConcreteCategory.hom (fι.app _) x)
      = ConcreteCategory.hom (fι.app _)
          (ConcreteCategory.hom (sectionCechFaceRestr U F σ i) x) := by
  unfold sectionCechFaceRestr
  rw [← ConcreteCategory.comp_apply, ← ConcreteCategory.comp_apply, fι.naturality]

/-- The single-index {\v C}ech intersection at a constant tuple is the cover member. -/
private lemma coverConst_iInf {ι : Type u} (U : ι → Opens ↥X) (i : ι) :
    (⨅ k : Fin 1, U ((fun _ => i) k)) = U i := by simp

/-- The double-index {\v C}ech intersection at `![i, j]` is the binary intersection. -/
private lemma coverPair_iInf {ι : Type u} (U : ι → Opens ↥X) (i j : ι) :
    (⨅ k : Fin 2, U (![i, j] k)) = U i ⊓ U j := by
  apply le_antisymm
  · exact le_inf (iInf_le _ 0) (iInf_le _ 1)
  · exact le_iInf (fun k => by fin_cases k <;> simp)

/-- The `0`-th face of `![i, j]` is the constant tuple `j`. -/
private lemma pair_comp_δ0 {ι : Type u} (i j : ι) :
    (![i, j] ∘ (SimplexCategory.δ (0 : Fin 2)).toOrderHom) = (fun _ => j) := by
  funext k; fin_cases k; simp [SimplexCategory.δ, Fin.succAbove]

/-- The `1`-st face of `![i, j]` is the constant tuple `i`. -/
private lemma pair_comp_δ1 {ι : Type u} (i j : ι) :
    (![i, j] ∘ (SimplexCategory.δ (1 : Fin 2)).toOrderHom) = (fun _ => i) := by
  funext k; fin_cases k; simp [SimplexCategory.δ, Fin.succAbove]

/-- **Surjectivity on sections from {\v C}ech-`H¹` vanishing** (blueprint `lem:ses_cech_h1`,
Stacks `lemma-ses-cech-h1`).

For a short exact sequence of presheaves of modules `0 → F → G → H → 0` on a scheme `X`
— presented through the underlying `Ab`-presheaf maps `fι`, `gπ`, with `fι` a monomorphism
on sections (`hmono`), `gπ ∘ fι = 0` (`hπι`), and every kernel section of `gπ` in the image
of `fι` (`hker`) — together with an open cover `U` of the open `⨆ᵢ Uᵢ` such that
`Ȟ¹(U, F) = 0` (`hH1`) and a family of local lifts `sLoc i ∈ G(Uᵢ)` of `s ∈ H(⨆ᵢ Uᵢ)`
(`hlift`), the section `s` lies in the image of `G(⨆ᵢ Uᵢ) → H(⨆ᵢ Uᵢ)`.

The differences `sⱼ|_{ij} − sᵢ|_{ij}` of the local lifts map to `0` in `H`, hence lift to a
{\v C}ech `1`-cocycle in `F` (`hker`); the {\v C}ech-`H¹` vanishing makes it a coboundary
(`sectionCech_one_coboundary_of_isZero_homology`); subtracting the coboundary makes the
corrected lifts agree on overlaps, and the sheaf condition on `G` glues them to a global
section of `G` over `⨆ᵢ Uᵢ` mapping to `s` (separatedness of `H` identifies its image with
`s`).  The "cofinal system of covers" of the Stacks statement is captured here by taking a
single cover satisfying both `Ȟ¹ = 0` and the local-lift property as hypotheses.

Project-local: the {\v C}ech surjectivity criterion phrased through `sectionCechComplex` is
new here (Mathlib has no {\v C}ech complex of sections of a presheaf of modules). -/
theorem ses_cech_h1 {ι : Type u} (U : ι → Opens ↥X)
    (F G H : X.PresheafOfModules)
    (fι : F.presheaf ⟶ G.presheaf) (gπ : G.presheaf ⟶ H.presheaf)
    (hGsh : TopCat.Presheaf.IsSheaf (X := X.toTopCat) G.presheaf)
    (hHsh : TopCat.Presheaf.IsSheaf (X := X.toTopCat) H.presheaf)
    (hπι : ∀ (V : (Opens ↥X)ᵒᵖ) (x : ToType (F.presheaf.obj V)),
      ConcreteCategory.hom (gπ.app V) (ConcreteCategory.hom (fι.app V) x) = 0)
    (hmono : ∀ (V : (Opens ↥X)ᵒᵖ), Function.Injective (ConcreteCategory.hom (fι.app V)))
    (hker : ∀ (V : (Opens ↥X)ᵒᵖ) (x : ToType (G.presheaf.obj V)),
      ConcreteCategory.hom (gπ.app V) x = 0 → ∃ y, ConcreteCategory.hom (fι.app V) y = x)
    (s : ToType (H.presheaf.obj (op (iSup U))))
    (hH1 : IsZero ((sectionCechComplex U F).homology 1))
    (sLoc : ∀ i, ToType (G.presheaf.obj (op (U i))))
    (hlift : ∀ i, ConcreteCategory.hom (gπ.app (op (U i))) (sLoc i)
      = ConcreteCategory.hom (H.presheaf.map (Opens.leSupr U i).op) s) :
    ∃ g : ToType (G.presheaf.obj (op (iSup U))),
      ConcreteCategory.hom (gπ.app (op (iSup U))) g = s := by
  classical
  -- single-index local sections, recast in ⨅-coordinates
  set sLoc'coord : (σ : Fin 1 → ι) → ToType (G.presheaf.obj (op (⨅ k, U (σ k)))) :=
    fun σ => ConcreteCategory.hom (G.presheaf.map (homOfLE (iInf_le _ 0)).op) (sLoc (σ 0))
    with hsLoc'coord
  set sLoc' : ToType ((sectionCechCosimplicial U G).obj (SimplexCategory.mk 0)) :=
    (sectionCechProductEquiv U G 0).symm sLoc'coord with hsLoc'
  have hpe0 : sectionCechProductEquiv U G 0 sLoc' = sLoc'coord :=
    (sectionCechProductEquiv U G 0).apply_symm_apply sLoc'coord
  -- the degree-1 cochain of G-differences
  set cyc1 := ConcreteCategory.hom
    (AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U G) 0) sLoc' with hcyc1
  set dGcoord : (σ : Fin 2 → ι) → ToType (G.presheaf.obj (op (⨅ k, U (σ k)))) :=
    fun σ => sectionCechProductEquiv U G 1 cyc1 σ with hdGcoord
  have hdG : ∀ σ : Fin 2 → ι, dGcoord σ
      = ∑ i : Fin 2, (-1 : ℤ) ^ (i : ℕ) •
          ConcreteCategory.hom (sectionCechFaceRestr U G σ i)
            (sLoc'coord (σ ∘ (SimplexCategory.δ i).toOrderHom)) := by
    intro σ
    have happ := sectionCech_objD_apply U G 0 sLoc' σ
    rw [hpe0] at happ
    exact happ
  -- `gπ` carries a single ⨅-coordinate local section to the restriction of `s`
  have hgπsLoc' : ∀ (ρ : Fin 1 → ι) (h : (⨅ k, U (ρ k)) ≤ iSup U),
      ConcreteCategory.hom (gπ.app (op (⨅ k, U (ρ k)))) (sLoc'coord ρ)
        = ConcreteCategory.hom (H.presheaf.map (homOfLE h).op) s := by
    intro ρ h
    rw [hsLoc'coord, ← ConcreteCategory.comp_apply, gπ.naturality,
      ConcreteCategory.comp_apply, hlift (ρ 0)]
    exact restr_trans H.presheaf (iInf_le _ 0) (le_iSup U (ρ 0)) s
  -- `gπ` kills the differences
  have hgπdG : ∀ σ : Fin 2 → ι,
      ConcreteCategory.hom (gπ.app (op (⨅ k, U (σ k)))) (dGcoord σ) = 0 := by
    intro σ
    rw [hdG, map_sum]
    have key : ∀ i : Fin 2,
        ConcreteCategory.hom (gπ.app (op (⨅ k, U (σ k))))
          ((-1 : ℤ) ^ (i : ℕ) • ConcreteCategory.hom (sectionCechFaceRestr U G σ i)
            (sLoc'coord (σ ∘ (SimplexCategory.δ i).toOrderHom)))
        = (-1 : ℤ) ^ (i : ℕ) • ConcreteCategory.hom (H.presheaf.map
            (homOfLE (le_trans (iInf_le (fun k => U (σ k)) (0 : Fin 2)) (le_iSup U (σ 0)))).op) s := by
      intro i
      rw [map_zsmul]; congr 1
      rw [← fι_sectionCechFaceRestr U G H gπ σ i,
        hgπsLoc' (σ ∘ (SimplexCategory.δ i).toOrderHom) (le_trans (iInf_le _ 0) (le_iSup U _))]
      simp only [sectionCechFaceRestr, ← ConcreteCategory.comp_apply, ← Functor.map_comp]
      exact restr_op_unique H.presheaf _ _ s
    rw [Finset.sum_congr rfl (fun i _ => key i), ← Finset.sum_smul,
      show (∑ i : Fin 2, (-1 : ℤ) ^ (i : ℕ)) = 0 by decide, zero_smul]
  -- lift each difference into `F`
  have hc : ∀ σ : Fin 2 → ι, ∃ y : ToType (F.presheaf.obj (op (⨅ k, U (σ k)))),
      ConcreteCategory.hom (fι.app _) y = dGcoord σ :=
    fun σ => hker _ _ (hgπdG σ)
  choose c hcspec using hc
  -- the `G`-side cocycle identity (`d² = 0`)
  have hGcoc : ∀ σ : Fin 3 → ι, ∑ i : Fin 3, (-1 : ℤ) ^ (i : ℕ) •
      ConcreteCategory.hom (sectionCechFaceRestr U G σ i)
        (dGcoord (σ ∘ (SimplexCategory.δ i).toOrderHom)) = 0 := by
    intro σ
    have happ := sectionCech_objD_apply U G 1 cyc1 σ
    simp only [hdGcoord]
    rw [← happ]
    have hzero : ConcreteCategory.hom
        (AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U G) 1) cyc1 = 0 := by
      rw [hcyc1, ← ConcreteCategory.comp_apply, AlternatingCofaceMapComplex.d_squared]
      simp
    rw [hzero, sectionCechProductEquiv_apply]; exact map_zero _
  -- the `F`-side cocycle identity for the lifted differences
  have hcoc : ∀ σ : Fin 3 → ι, ∑ i : Fin 3, (-1 : ℤ) ^ (i : ℕ) •
      ConcreteCategory.hom (sectionCechFaceRestr U F σ i)
        (c (σ ∘ (SimplexCategory.δ i).toOrderHom)) = 0 := by
    intro σ
    apply hmono (op (⨅ k, U (σ k)))
    rw [map_sum, map_zero]
    rw [show (0 : ToType (G.presheaf.obj (op (⨅ k, U (σ k))))) = _ from (hGcoc σ).symm]
    refine Finset.sum_congr rfl (fun i _ => ?_)
    rw [map_zsmul, ← fι_sectionCechFaceRestr U F G fι σ i, hcspec]
  -- coboundary extraction (the {\v C}ech-`H¹` heart)
  obtain ⟨t, ht⟩ := sectionCech_one_coboundary_of_isZero_homology U F hH1 c hcoc
  -- the corrected family in ⨅-coordinates
  set g'coord : (ρ : Fin 1 → ι) → ToType (G.presheaf.obj (op (⨅ k, U (ρ k)))) :=
    fun ρ => sLoc'coord ρ - ConcreteCategory.hom (fι.app _) (t ρ) with hg'coord
  have hg'coc : ∀ σ : Fin 2 → ι, ∑ i : Fin 2, (-1 : ℤ) ^ (i : ℕ) •
      ConcreteCategory.hom (sectionCechFaceRestr U G σ i)
        (g'coord (σ ∘ (SimplexCategory.δ i).toOrderHom)) = 0 := by
    intro σ
    simp only [hg'coord, map_sub, smul_sub, Finset.sum_sub_distrib, ← hdG]
    rw [← hcspec σ, ht σ, map_sum, sub_eq_zero]
    refine Finset.sum_congr rfl (fun i _ => ?_)
    rw [map_zsmul, ← fι_sectionCechFaceRestr U F G fι σ i]
  -- pairwise agreement of the corrected family on double overlaps
  have hagree2 : ∀ σ : Fin 2 → ι,
      ConcreteCategory.hom (sectionCechFaceRestr U G σ 0)
        (g'coord (σ ∘ (SimplexCategory.δ 0).toOrderHom))
      = ConcreteCategory.hom (sectionCechFaceRestr U G σ 1)
        (g'coord (σ ∘ (SimplexCategory.δ 1).toOrderHom)) := by
    intro σ
    have h := hg'coc σ
    rw [Fin.sum_univ_two] at h
    simp only [Fin.val_zero, Fin.val_one, pow_zero, one_smul, pow_one, neg_one_zsmul] at h
    rwa [add_neg_eq_zero] at h
  -- the `U`-indexed corrected family
  set gGlue : ∀ i, ToType (G.presheaf.obj (op (U i))) :=
    fun i => ConcreteCategory.hom
      (G.presheaf.map (homOfLE (le_of_eq (coverConst_iInf U i).symm)).op) (g'coord (fun _ => i))
    with hgGlue
  have hcompat : TopCat.Presheaf.IsCompatible (X := X.toTopCat) G.presheaf U gGlue := by
    intro i j
    apply restr_inj_of_eq G.presheaf (le_of_eq (coverPair_iInf U i j))
      (le_of_eq (coverPair_iInf U i j).symm)
    simp only [hgGlue, ← ConcreteCategory.comp_apply, ← Functor.map_comp]
    have key := hagree2 ![i, j]
    rw [pair_comp_δ0, pair_comp_δ1] at key
    simp only [sectionCechFaceRestr, ← ConcreteCategory.comp_apply, ← Functor.map_comp] at key
    exact key.symm
  -- glue the corrected family to a global section of `G`
  obtain ⟨g, hgluing, -⟩ := hGsh.isSheafUniqueGluing U gGlue hcompat
  refine ⟨g, ?_⟩
  -- `gπ g = s` by separatedness of `H`
  set sH : ∀ i, ToType (H.presheaf.obj (op (U i))) :=
    fun i => ConcreteCategory.hom (H.presheaf.map (Opens.leSupr U i).op) s with hsH
  have hcompatH : TopCat.Presheaf.IsCompatible (X := X.toTopCat) H.presheaf U sH := by
    intro i j
    simp only [hsH]
    rw [restr_comp_unique H.presheaf _ _ ((homOfLE (inf_le_left.trans (le_iSup U i))).op),
      restr_comp_unique H.presheaf _ _ ((homOfLE (inf_le_right.trans (le_iSup U j))).op)]
  have hg2 : TopCat.Presheaf.IsGluing (X := X.toTopCat) H.presheaf U sH s := fun i => rfl
  have hgπglue : ∀ i, ConcreteCategory.hom (gπ.app (op (U i))) (gGlue i) = sH i := by
    intro i
    simp only [hgGlue, hsH, hg'coord]
    rw [show Opens.leSupr U i = homOfLE (le_iSup U i) from rfl,
      ← ConcreteCategory.comp_apply, gπ.naturality, ConcreteCategory.comp_apply, map_sub,
      hπι, sub_zero, hgπsLoc' _ ((coverConst_iInf U i).le.trans (le_iSup U i)), restr_trans]
  have hg1 : TopCat.Presheaf.IsGluing (X := X.toTopCat) H.presheaf U sH
      (ConcreteCategory.hom (gπ.app (op (iSup U))) g) := by
    intro i
    have hn : ConcreteCategory.hom (H.presheaf.map (Opens.leSupr U i).op)
        (ConcreteCategory.hom (gπ.app (op (iSup U))) g)
      = ConcreteCategory.hom (gπ.app (op (U i)))
          (ConcreteCategory.hom (G.presheaf.map (Opens.leSupr U i).op) g) := by
      rw [← ConcreteCategory.comp_apply, ← gπ.naturality (Opens.leSupr U i).op,
        ConcreteCategory.comp_apply]
    show ConcreteCategory.hom (H.presheaf.map (Opens.leSupr U i).op)
        (ConcreteCategory.hom (gπ.app (op (iSup U))) g) = sH i
    rw [hn, hgluing i]
    exact hgπglue i
  exact (hHsh.isSheafUniqueGluing U sH hcompatH).unique hg1 hg2

end SesCechH1

end AlgebraicGeometry

#print axioms AlgebraicGeometry.ses_cech_h1
