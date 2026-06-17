/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.PresheafCech

/-!
# Free-presheaf Čech complex (P3b bridge — free-complex side)

This file is the free-presheaf-complex side of the P3b bridge.  The section side lives in
`PresheafCech.lean`; this file owns the two free-complex declarations:

- `AlgebraicGeometry.cechFreePresheafComplex`  (`def:cech_free_presheaf_complex`)
  — the chain complex of free presheaves of `O_X`-modules whose degree-`p` term is
  `⨁_{σ : Fin(p+1) → ι} (PresheafOfModules.free X.ringCatSheaf.obj).obj`
  `  (yoneda.obj (⨅ k, U (σ k)))`.

- `AlgebraicGeometry.cechFreeComplex_quasiIso`  (`lem:cech_free_complex_quasi_iso`)
  — the free complex is a quasi-isomorphism / free resolution of `O_𝒰`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-
Planner strategy (P3b free-complex side; see analogies/p3b-presheafcech.md +
blueprint §Presheaf-level Čech machinery):

────────────────────────────────────────────────────────────────────────────────
`cechFreePresheafComplex`
────────────────────────────────────────────────────────────────────────────────
Goal: a `ChainComplex X.PresheafOfModules ℕ` whose degree-`p` term is
  `⨁_{σ : Fin(p+1) → ι} (PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj (⨅ k, U (σ k)))`
with the alternating-face differential.

Recommended build path — use the simplicial route so that d²=0 comes for free:
1. Construct a `SimplicialObject X.PresheafOfModules` whose `n`-simplices are the
   above direct sums.
2. Apply `AlgebraicTopology.alternatingFaceMapComplex` to obtain the chain complex.
   This gives d²=0 automatically via `SimplicialObject.boundarySquareZero`.

Key API:
- `PresheafOfModules.free X.ringCatSheaf.obj :`
  `  ((Opens ↥X)ᵒᵖ ⥤ Type u) ⥤ PresheafOfModules X.ringCatSheaf.obj`
  — the free-presheaf-of-modules functor.  Use it as `(PresheafOfModules.free _).obj` and
  `(PresheafOfModules.free _).map`.
- `yoneda.obj V : (Opens ↥X)ᵒᵖ ⥤ Type u` — the representable presheaf of sets at `V`.
  Do NOT introduce a bespoke `j_!`; `free ∘ yoneda` is the correct substitute.
- `AlgebraicTopology.alternatingFaceMapComplex` — turns a simplicial abelian group (or
  simplicial object in an abelian category) into a chain complex; d²=0 is a theorem.
- Direct sums: `⨁` is `DirectSum`; in `PresheafOfModules` use
  `Limits.biproduct` / `DirectSum.lof` / `DirectSum.desc`.

DEAD END — do NOT hand-roll the alternating-sum identity for d²=0.  Use the simplicial
path above.

────────────────────────────────────────────────────────────────────────────────
`cechFreeComplex_quasiIso`
────────────────────────────────────────────────────────────────────────────────
Goal: show that `cechFreePresheafComplex` → `O_𝒰[0]` is a quasi-isomorphism (i.e.,
the free complex is a free resolution of the structure sheaf restricted to the cover).

Recommended build path — objectwise contracting homotopy:
1. Homology in `X.PresheafOfModules` is computed objectwise (colimits are objectwise).
   So it suffices to exhibit, for each open `V : Opens ↥X`, a contracting homotopy on
   the sectionwise complex `cechFreePresheafComplex(V)`.
2. Sectionwise at `V`, degree `p` is `⨁_{σ : Fin(p+1) → ι} R(V)` for those multi-indices
   `σ` with `V ⊆ ⨅ k, U (σ k)`, and `0` otherwise.
3. Fix any `i_fix : ι` with `V ⊆ U i_fix` (if none exists, the complex is `0`).
   The homotopy `h : K_p(V) → K_{p+1}(V)` maps the `σ`-summand to the `(i_fix, σ)`-summand
   (prepend `i_fix`).  Check `dh + hd = id` at each degree.
4. Package as `HomologicalComplex.Homotopy`, then use `HomotopyEquiv.toQuasiIso`.

Key API:
- `HomologicalComplex.Homotopy` — `Mathlib.Algebra.Homology.Homotopy`.
- `HomotopyEquiv.toQuasiIso` (or `Homotopy.toQuasiIso`) — homotopy equivalence ⟹ quasi-iso.

DEAD END — do NOT route through `SimplicialObject.Augmented.ExtraDegeneracy`.  That
interface has a different index convention and is not directly applicable here.
-/

/-! ## Project-local Mathlib supplement — free-presheaf Čech complex

This section builds the free-presheaf Čech complex `cechFreePresheafComplex` of a finite
open cover `𝒰 : X.OpenCover` as the alternating-face-map chain complex of an explicit
simplicial object `cechFreeSimplicial`.  Everything is project-local: Mathlib has the
free-presheaf-of-modules functor, the Yoneda embedding and `alternatingFaceMapComplex`,
but not their assembly into the Čech free resolution of a cover.

We require `[Finite 𝒰.I₀]` so that the index types `Fin (p+1) → 𝒰.I₀` of the degreewise
coproducts are finite (`HasCoproductsOfShape`); this matches the finiteness hypothesis of
the downstream protected theorem `cech_computes_higherDirectImage`. -/

variable {X : Scheme.{u}}

/-- **Free presheaf of modules on a representable open.**

The composite `Opens X --yoneda--> ((Opens X)ᵒᵖ ⥤ Type) --free--> X.PresheafOfModules`.
For an open `V`, `freeYoneda.obj V` is the extension-by-zero free presheaf of modules
`(j_V)_! O_X|_V` of the blueprint: on sections over `W` it is the free `O_X(W)`-module on
`Hom(W, V)`, i.e. `O_X(W)` if `W ⊆ V` and `0` otherwise.

Project-local because Mathlib provides `PresheafOfModules.free` and `yoneda` separately but
not this composite, which is the basic building block of the free Čech complex. -/
noncomputable def freeYoneda : TopologicalSpace.Opens ↥X ⥤ X.PresheafOfModules :=
  yoneda ⋙ PresheafOfModules.free X.ringCatSheaf.obj

/-- The open underlying the `i`-th member of an open cover, as `(𝒰.f i).opensRange`. -/
def coverOpen (𝒰 : X.OpenCover) (i : 𝒰.I₀) : TopologicalSpace.Opens ↥X := (𝒰.f i).opensRange

/-- The intersection open `⨅ k, U (σ k)` indexed by a tuple `σ : κ → 𝒰.I₀`.

For `κ = Fin (p+1)` this is the `(p+1)`-fold intersection `U_{σ(0)…σ(p)}` indexing the
degree-`p` term of the Čech complex. -/
def coverInterOpen (𝒰 : X.OpenCover) {κ : Type} (σ : κ → 𝒰.I₀) : TopologicalSpace.Opens ↥X :=
  ⨅ k, coverOpen 𝒰 (σ k)

/-- Reindexing along `α : κ' → κ` enlarges the intersection open: precomposing a tuple with
`α` keeps a subset of the indices, so the intersection grows. This `≤` supplies the
representable index-dropping maps that define the Čech differential. -/
lemma coverInterOpen_comp_le (𝒰 : X.OpenCover) {κ κ' : Type} (α : κ' → κ) (σ : κ → 𝒰.I₀) :
    coverInterOpen 𝒰 σ ≤ coverInterOpen 𝒰 (σ ∘ α) :=
  le_iInf fun k => iInf_le _ (α k)

/-- A coproduct injection transported along an equality of indices: `eqToHom` of the induced
object equality cancels the index change. A generic categorical helper used to discharge the
dependent-index bookkeeping in the simplicial identities of `cechFreeSimplicial`. -/
private lemma sigma_ι_eqToHom_transport {C : Type*} [Category C] {β : Type*} (B : β → C)
    [HasCoproduct B] {a b : β} (e : a = b) :
    eqToHom (congrArg B e) ≫ Limits.Sigma.ι B b = Limits.Sigma.ι B a := by
  subst e; simp

/-- **The free Čech simplicial object of a finite open cover.**

The simplicial object in `X.PresheafOfModules` whose degree-`p` term is the coproduct
`∐_{σ : Fin (p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)` and whose simplicial maps
reindex the multi-index `σ ↦ σ ∘ α` (along the order map of `α : [p] ⟶ [q]`) together with
the representable index-dropping inclusion `coverInterOpen 𝒰 σ ≤ coverInterOpen 𝒰 (σ ∘ α)`.

Taking its `alternatingFaceMapComplex` produces `cechFreePresheafComplex` with `d² = 0` for
free (the simplicial route avoids hand-rolling the alternating-sum identity).

Project-local: this is the simplicial backbone of the free Čech resolution; it has no
Mathlib counterpart. -/
noncomputable def cechFreeSimplicial (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    SimplicialObject X.PresheafOfModules where
  obj n := ∐ fun σ : Fin (n.unop.len + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)
  map {n m} α := Limits.Sigma.desc fun σ =>
    freeYoneda.map (homOfLE (coverInterOpen_comp_le 𝒰 α.unop.toOrderHom σ)) ≫
      Limits.Sigma.ι (fun τ : Fin (m.unop.len + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 τ))
        (σ ∘ α.unop.toOrderHom)
  map_id n := by
    apply Limits.Sigma.hom_ext; intro σ
    simp only [Limits.Sigma.ι_desc, Category.comp_id]
    have e : σ ∘ ⇑(SimplexCategory.Hom.toOrderHom (𝟙 n).unop) = σ := by funext i; simp
    have eo : coverInterOpen 𝒰 (σ ∘ ⇑(SimplexCategory.Hom.toOrderHom (𝟙 n).unop))
        = coverInterOpen 𝒰 σ := by rw [e]
    rw [Subsingleton.elim (homOfLE
        (coverInterOpen_comp_le 𝒰 (SimplexCategory.Hom.toOrderHom (𝟙 n).unop) σ)) (eqToHom eo.symm),
      eqToHom_map]
    exact sigma_ι_eqToHom_transport
      (fun σ : Fin (n.unop.len + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)) e
  map_comp {n m k} f g := by
    apply Limits.Sigma.hom_ext; intro σ
    simp only [Category.assoc, Limits.Sigma.ι_desc, Limits.Sigma.ι_desc_assoc]
    have e : σ ∘ ⇑(SimplexCategory.Hom.toOrderHom (f ≫ g).unop)
        = (σ ∘ ⇑(SimplexCategory.Hom.toOrderHom f.unop))
            ∘ ⇑(SimplexCategory.Hom.toOrderHom g.unop) := by
      funext i; simp [unop_comp, SimplexCategory.comp_toOrderHom]
    rw [← sigma_ι_eqToHom_transport
          (fun τ : Fin (k.unop.len + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 τ)) e,
      show (eqToHom (congrArg (fun τ : Fin (k.unop.len + 1) → 𝒰.I₀ =>
              freeYoneda.obj (coverInterOpen 𝒰 τ)) e))
          = freeYoneda.map (eqToHom (congrArg (coverInterOpen 𝒰) e)) from (eqToHom_map _ _).symm]
    simp only [← Category.assoc, ← Functor.map_comp]
    congr 2

/-- **The free-presheaf Čech complex of a finite open cover** (`def:cech_free_presheaf_complex`).

The chain complex `K(𝒰)_•` in `X.PresheafOfModules` whose degree-`p` term is
`∐_{σ : Fin (p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)`
`= ⨁_σ (PresheafOfModules.free _).obj (yoneda.obj (⨅ k, U (σ k)))`, with the
alternating-sum index-dropping differential. Built as the `alternatingFaceMapComplex` of
`cechFreeSimplicial`, so `d² = 0` holds by the simplicial identities.

Project-local: the free Čech resolution of a cover is not in Mathlib. -/
noncomputable def cechFreePresheafComplex (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    ChainComplex X.PresheafOfModules ℕ :=
  (AlgebraicTopology.alternatingFaceMapComplex X.PresheafOfModules).obj (cechFreeSimplicial 𝒰)

/-- Degreewise unfolding of the free Čech complex: the degree-`p` term is the coproduct of
free presheaves over the `(p+1)`-fold multi-indices. Exposed (it holds by `rfl`) so that the
downstream hom-identification and quasi-isomorphism arguments can rewrite the degree-`p`
object without unfolding `alternatingFaceMapComplex` and `cechFreeSimplicial` by hand. -/
lemma cechFreePresheafComplex_X (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (p : ℕ) :
    (cechFreePresheafComplex 𝒰).X p
      = ∐ fun σ : Fin (p + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ) :=
  rfl

/-! ## Project-local Mathlib supplement — augmentation and cover structure presheaf -/

/-- **Augmentation of a representable free presheaf onto the structure presheaf.**

The canonical map `freeYoneda V ⟶ unit` (= `O_X`) corresponding under the free–Yoneda hom
bijection to the unit section `1 ∈ O_X(V)`. Concretely it sends the free generator over a
`W ⊆ V` to `1 ∈ O_X(W)`. This is the per-summand component of the Čech augmentation
`K(𝒰)_0 ⟶ O_𝒰`.

Project-local: Mathlib has neither `freeYoneda` nor its augmentation. -/
noncomputable def freeYonedaAug (V : TopologicalSpace.Opens ↥X) :
    freeYoneda.obj V ⟶ PresheafOfModules.unit X.ringCatSheaf.obj :=
  (freeYonedaHomEquiv V (PresheafOfModules.unit X.ringCatSheaf.obj)).symm
    (1 : (X.ringCatSheaf.obj.obj (Opposite.op V)))

/-- Value of the free–Yoneda hom bijection on the augmentation: it is the unit section `1`. -/
lemma freeYonedaHomEquiv_freeYonedaAug (V : TopologicalSpace.Opens ↥X) :
    freeYonedaHomEquiv V (PresheafOfModules.unit X.ringCatSheaf.obj) (freeYonedaAug V)
      = (1 : (X.ringCatSheaf.obj.obj (Opposite.op V))) := by
  simp only [freeYonedaAug, Equiv.apply_symm_apply]

/-- Value of the augmentation `freeYoneda V' ⟶ O_X` on a generator `freeMk g` (`g : V ⟶ V'`):
it is the unit section `1 ∈ O_X(V)` (the restriction of `1 ∈ O_X(V')`). -/
private lemma freeYonedaAug_app_freeMk {V V' : TopologicalSpace.Opens ↥X} (g : V ⟶ V') :
    (ConcreteCategory.hom ((freeYonedaAug V').app (Opposite.op V))) (ModuleCat.freeMk g)
      = (1 : X.ringCatSheaf.obj.obj (Opposite.op V)) := by
  have key := (freeYonedaHomEquiv_apply V' (PresheafOfModules.unit X.ringCatSheaf.obj)
      (freeYonedaAug V')).symm.trans (freeYonedaHomEquiv_freeYonedaAug V')
  have hmap : (ConcreteCategory.hom ((freeYoneda.obj V').map g.op))
      (ModuleCat.freeMk (𝟙 V')) = ModuleCat.freeMk g := by
    erw [PresheafOfModules.freeObj_map, ModuleCat.freeDesc_apply]
    change ModuleCat.freeMk ((ConcreteCategory.hom ((yoneda.obj V').map g.op)) (𝟙 V'))
      = ModuleCat.freeMk g
    congr 1
  have hnat := PresheafOfModules.naturality_apply (freeYonedaAug V') g.op
    (ModuleCat.freeMk (𝟙 V'))
  rw [hmap] at hnat
  rw [hnat]
  change (ConcreteCategory.hom (X.ringCatSheaf.obj.map g.op))
    ((ConcreteCategory.hom ((freeYonedaAug V').app (Opposite.op V'))) (ModuleCat.freeMk (𝟙 V'))) = 1
  exact (congrArg (ConcreteCategory.hom (X.ringCatSheaf.obj.map g.op)) key).trans (map_one _)

/-- **Naturality of the augmentation.** For `V ≤ V'` the restriction map of free presheaves
composed with the augmentation onto `O_X` equals the augmentation over the smaller open:
`freeYoneda.map (incl) ≫ freeYonedaAug V' = freeYonedaAug V`. This is the cocone condition
that turns the per-summand augmentations into a chain map `K(𝒰)_• ⟶ O_𝒰[0]`. -/
lemma freeYoneda_map_comp_aug {V V' : TopologicalSpace.Opens ↥X} (h : V ≤ V') :
    freeYoneda.map (homOfLE h) ≫ freeYonedaAug V' = freeYonedaAug V := by
  apply (freeYonedaHomEquiv V (PresheafOfModules.unit X.ringCatSheaf.obj)).injective
  rw [freeYonedaHomEquiv_freeYonedaAug, freeYonedaHomEquiv_apply, PresheafOfModules.comp_app]
  erw [ModuleCat.comp_apply, Functor.comp_map,
    PresheafOfModules.free_map_app, ModuleCat.free_map_apply, freeYonedaAug_app_freeMk]

/-- **Degree-`0` augmentation of the free Čech complex.** The map
`K(𝒰)_0 = ∐_{σ : Fin 1 → I} freeYoneda(U_σ) ⟶ O_X` assembled from the per-summand
augmentations `freeYonedaAug`. Its image presheaf is the cover structure presheaf `O_𝒰`. -/
noncomputable def cechFreeAug (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    (cechFreePresheafComplex 𝒰).X 0 ⟶ PresheafOfModules.unit X.ringCatSheaf.obj :=
  Limits.Sigma.desc fun σ : Fin (0 + 1) → 𝒰.I₀ => freeYonedaAug (coverInterOpen 𝒰 σ)

/-- **The cover structure presheaf** `O_𝒰` (`def:cover_structure_presheaf`).

The image (as a presheaf of `O_X`-modules) of the degree-`0` augmentation `K(𝒰)_0 ⟶ O_X`
(`cechFreeAug`). Concretely `O_𝒰(W) = O_X(W)` when `W` is contained in some cover member
`U_i`, and `0` otherwise. The free Čech complex `K(𝒰)_•` is a resolution of `O_𝒰`
(`cechFreeComplex_quasiIso`).

Project-local: the image presheaf of a cover's augmentation has no Mathlib counterpart. -/
noncomputable def coverStructurePresheaf (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    X.PresheafOfModules :=
  Limits.image (cechFreeAug 𝒰)

/-- Each face map `δ i : K(𝒰)_1 ⟶ K(𝒰)_0` composed with the augmentation is the same
multi-indexed augmentation `∐_{σ : Fin 2 → I} freeYoneda(U_σ) ⟶ O_X`, independent of `i`.
This is the cosimplicial-identity input to `d ≫ aug = 0`: the two faces become equal after
augmenting, by naturality of `freeYonedaAug`. -/
private lemma cechFreeSimplicial_δ_comp_aug (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (i : Fin 2) :
    (cechFreeSimplicial 𝒰).δ i ≫ cechFreeAug 𝒰
      = Limits.Sigma.desc (fun σ : Fin 2 → 𝒰.I₀ => freeYonedaAug (coverInterOpen 𝒰 σ)) := by
  apply Limits.Sigma.hom_ext
  intro σ
  simp only [SimplicialObject.δ, cechFreeSimplicial, cechFreeAug, Limits.Sigma.ι_desc,
    Limits.Sigma.ι_desc_assoc, Category.assoc]
  exact freeYoneda_map_comp_aug (coverInterOpen_comp_le 𝒰 _ σ)

/-- The differential `K(𝒰)_1 ⟶ K(𝒰)_0` composed with the augmentation vanishes: the
alternating face sum `δ_0 - δ_1` is killed because both faces agree after augmenting
(`cechFreeSimplicial_δ_comp_aug`). This is the cochain-map condition for the augmentation
`K(𝒰)_• ⟶ O_𝒰[0]`. -/
private lemma cechFree_d_comp_aug (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    (cechFreePresheafComplex 𝒰).d 1 0 ≫ cechFreeAug 𝒰 = 0 := by
  have hd : (cechFreePresheafComplex 𝒰).d 1 0
      = AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰) 0 :=
    AlgebraicTopology.alternatingFaceMapComplex_obj_d (cechFreeSimplicial 𝒰) 0
  -- Prove the simplicial-level identity as a standalone `have` so its composition `≫` is
  -- elaborated fresh at the `cechFreeSimplicial.obj` types — matching `cechFreeSimplicial_δ_comp_aug`.
  -- Rewriting `hd` into the goal first would pin the composition at the `.X` types of the
  -- chain complex, which are only definitionally (not syntactically) equal and block the rewrites.
  have main : AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰) 0
      ≫ cechFreeAug 𝒰 = 0 := by
    rw [AlgebraicTopology.AlternatingFaceMapComplex.objD, Fin.sum_univ_two,
      Preadditive.add_comp, Preadditive.zsmul_comp, Preadditive.zsmul_comp,
      cechFreeSimplicial_δ_comp_aug, cechFreeSimplicial_δ_comp_aug]
    simp only [Fin.isValue, Fin.val_zero, Fin.val_one, pow_zero, pow_one, one_zsmul, neg_one_zsmul]
    abel
  rw [hd]; exact main

end AlgebraicGeometry
