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
  **(not yet built — the degreewise chain iso `cechFreeEvalEngineIso` to the combinatorial engine
  model is now complete and axiom-clean, together with the engine acyclicity and augmentation; the
  remaining step is the nonempty-case `QuasiIso` of `cechEngineComplexAug` and its transfer.)**

The quasi-isomorphism is proved objectwise (`quasiIso_of_evaluation`): for each open `V`,
the evaluated augmented complex is the augmented combinatorial Čech complex of the full
simplex on `I₁(V) = {i : V ≤ U_i}` with constant coefficients `O_X(V)`, which is
contractible when `I₁(V) ≠ ∅` (via the prepend-`i_fix` homotopy
`FreeCechEngine.combHomotopy`) and zero when `I₁(V) = ∅`.  This file owns the
combinatorial engine (`FreeCechEngine`) supplying that contracting homotopy and the
per-`V` sectionwise reductions building toward `cechFreeComplex_quasiIso`.
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
  -- elaborated fresh at the `cechFreeSimplicial.obj` types — matching
  -- `cechFreeSimplicial_δ_comp_aug`. Rewriting `hd` into the goal first would pin the composition
  -- at the `.X` types of the chain complex, which are only definitionally (not syntactically)
  -- equal and block the rewrites.
  have main : AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰) 0
      ≫ cechFreeAug 𝒰 = 0 := by
    rw [AlgebraicTopology.AlternatingFaceMapComplex.objD, Fin.sum_univ_two,
      Preadditive.add_comp, Preadditive.zsmul_comp, Preadditive.zsmul_comp,
      cechFreeSimplicial_δ_comp_aug, cechFreeSimplicial_δ_comp_aug]
    simp only [Fin.isValue, Fin.val_zero, Fin.val_one, pow_zero, pow_one, one_zsmul, neg_one_zsmul]
    abel
  rw [hd]; exact main

/-- The differential `K(𝒰)_1 ⟶ K(𝒰)_0` composed with the map onto the image presheaf
`O_𝒰 = image(cechFreeAug)` vanishes. Obtained from `cechFree_d_comp_aug` by cancelling the
mono `image.ι`. This is the cochain-map condition for the augmentation
`K(𝒰)_• ⟶ O_𝒰[0]` (`cechFreeComplexAug`). -/
private lemma cechFree_d_comp_factorThruImage (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    (cechFreePresheafComplex 𝒰).d 1 0 ≫ Limits.factorThruImage (cechFreeAug 𝒰) = 0 := by
  rw [← cancel_mono (Limits.image.ι (cechFreeAug 𝒰)), Category.assoc, Limits.image.fac,
    Limits.zero_comp]
  exact cechFree_d_comp_aug 𝒰

/-- **The augmentation chain map** `K(𝒰)_• ⟶ O_𝒰[0]` (`def:cover_structure_presheaf`).

The chain map from the free Čech complex to the cover structure presheaf concentrated in degree
`0`, whose degree-`0` component is the canonical map `K(𝒰)_0 ⟶ O_𝒰 = image(cechFreeAug)` onto the
image presheaf. The chain-map condition `d ≫ aug = 0` is `cechFree_d_comp_factorThruImage`. The
quasi-isomorphism claim `cechFreeComplex_quasiIso` asserts this map is a quasi-isomorphism.

Project-local: the augmented free Čech resolution of a cover is not in Mathlib. -/
noncomputable def cechFreeComplexAug (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    cechFreePresheafComplex 𝒰 ⟶
      (ChainComplex.single₀ X.PresheafOfModules).obj (coverStructurePresheaf 𝒰) :=
  ((cechFreePresheafComplex 𝒰).toSingle₀Equiv (coverStructurePresheaf 𝒰)).symm
    ⟨Limits.factorThruImage (cechFreeAug 𝒰), cechFree_d_comp_factorThruImage 𝒰⟩

/-- The degree-`0` component of the augmentation chain map is the canonical map onto the image
presheaf `O_𝒰`. -/
lemma cechFreeComplexAug_f_zero (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    (cechFreeComplexAug 𝒰).f 0 = Limits.factorThruImage (cechFreeAug 𝒰) := by
  rw [cechFreeComplexAug, ChainComplex.toSingle₀Equiv_symm_apply_f_zero]

/-! ## Project-local Mathlib supplement — objectwise detection of quasi-isomorphisms

Homology in `PresheafOfModules R` is computed objectwise: the evaluation functors
`PresheafOfModules.evaluation R V` are jointly conservative and preserve homology, so a
morphism of complexes of presheaves of modules is a quasi-isomorphism as soon as each of its
evaluations is.  These three lemmas package that reduction.  Mathlib has the single-functor
statement `HomologicalComplex.quasiIso_map_iff_of_preservesHomology` (which needs the functor to
reflect isomorphisms — false for a single evaluation), but not the joint-conservativity version
needed to reduce a quasi-isomorphism of presheaf-of-module complexes to its sectionwise checks. -/

open HomologicalComplex in
/-- For a functor `F` preserving homology, if the induced map on the homology of the mapped
complexes is an isomorphism, then `F` applied to the homology map is an isomorphism.  This is the
naturality square of `ShortComplex.mapHomologyIso` read off at a fixed degree. -/
private lemma isIso_Fmap_homologyMap {ι : Type*} {c : ComplexShape ι} {C₁ C₂ : Type*}
    [Category C₁] [Category C₂] [Preadditive C₁] [Preadditive C₂]
    {K L : HomologicalComplex C₁ c} (φ : K ⟶ L) (F : C₁ ⥤ C₂) [F.Additive] [F.PreservesHomology]
    (i : ι) [K.HasHomology i] [L.HasHomology i]
    [((F.mapHomologicalComplex c).obj K).HasHomology i]
    [((F.mapHomologicalComplex c).obj L).HasHomology i]
    (hiso : IsIso (HomologicalComplex.homologyMap ((F.mapHomologicalComplex c).map φ) i)) :
    IsIso (F.map (HomologicalComplex.homologyMap φ i)) := by
  have key := ShortComplex.mapHomologyIso_hom_naturality ((shortComplexFunctor C₁ c i).map φ) F
  haveI hmid : IsIso (ShortComplex.homologyMap
      (F.mapShortComplex.map ((shortComplexFunctor C₁ c i).map φ))) := hiso
  change IsIso (F.map (ShortComplex.homologyMap ((shortComplexFunctor C₁ c i).map φ)))
  haveI hcomp : IsIso (ShortComplex.homologyMap
      (F.mapShortComplex.map ((shortComplexFunctor C₁ c i).map φ)) ≫
      (((shortComplexFunctor C₁ c i).obj L).mapHomologyIso F).hom) := inferInstance
  haveI hcomp2 : IsIso ((((shortComplexFunctor C₁ c i).obj K).mapHomologyIso F).hom ≫
      F.map (ShortComplex.homologyMap ((shortComplexFunctor C₁ c i).map φ))) := key ▸ hcomp
  exact IsIso.of_isIso_comp_left
    (((shortComplexFunctor C₁ c i).obj K).mapHomologyIso F).hom _

/-- **Joint conservativity of evaluations.** A morphism of presheaves of `R`-modules is an
isomorphism as soon as each of its evaluations `(evaluation R V).map g` is, since the underlying
presheaf-of-abelian-groups functor reflects isomorphisms and a morphism of presheaves is an
isomorphism iff it is so objectwise.  Project-local: the joint-conservativity packaging is not in
Mathlib. -/
private lemma isIso_of_evaluation {C : Type*} [Category C] (R : Cᵒᵖ ⥤ RingCat)
    {M N : PresheafOfModules R} (g : M ⟶ N)
    (h : ∀ V, IsIso ((PresheafOfModules.evaluation R V).map g)) : IsIso g := by
  suffices hh : IsIso ((PresheafOfModules.toPresheaf R).map g) from
    isIso_of_reflects_iso g (PresheafOfModules.toPresheaf R)
  rw [NatTrans.isIso_iff_isIso_app]
  intro V
  have hV := h V
  rw [PresheafOfModules.evaluation_map] at hV
  haveI : IsIso (g.app V) := hV
  have e : ((PresheafOfModules.toPresheaf R).map g).app V
      = (forget₂ (ModuleCat (R.obj V)) Ab).map (g.app V) := rfl
  rw [e]
  exact Functor.map_isIso (forget₂ (ModuleCat (R.obj V)) Ab) (g.app V)

/-- **Objectwise reduction of quasi-isomorphisms.** A morphism `φ` of chain complexes of
presheaves of `R`-modules is a quasi-isomorphism if, for every object `V`, its evaluation
`(evaluation R V).mapHomologicalComplex |>.map φ` (a morphism of complexes of `R(V)`-modules) is a
quasi-isomorphism.  This is the formal core of the sectionwise argument that the free Čech complex
resolves the cover structure presheaf: homology of presheaves of modules is computed objectwise.

Project-local: combines `isIso_of_evaluation` (joint conservativity) with `isIso_Fmap_homologyMap`
(evaluation preserves homology). -/
lemma quasiIso_of_evaluation {C : Type*} [Category C] (R : Cᵒᵖ ⥤ RingCat) {ι : Type*}
    {c : ComplexShape ι} {K L : HomologicalComplex (PresheafOfModules R) c} (φ : K ⟶ L)
    [∀ i, K.HasHomology i] [∀ i, L.HasHomology i]
    (h : ∀ V, QuasiIso (((PresheafOfModules.evaluation R V).mapHomologicalComplex c).map φ)) :
    QuasiIso φ := by
  rw [quasiIso_iff]
  intro i
  rw [quasiIsoAt_iff_isIso_homologyMap]
  apply isIso_of_evaluation R
  intro V
  rw [PresheafOfModules.evaluation_map]
  haveI hqV : QuasiIsoAt (((PresheafOfModules.evaluation R V).mapHomologicalComplex c).map φ) i :=
    (h V).quasiIsoAt i
  rw [quasiIsoAt_iff_isIso_homologyMap] at hqV
  exact isIso_Fmap_homologyMap φ (PresheafOfModules.evaluation R V) i hqV

/-! ## Project-local Mathlib supplement — combinatorial contracting-homotopy engine

The objectwise reduction `quasiIso_of_evaluation` turns `cechFreeComplex_quasiIso` into a
per-open-`V` statement: the evaluation of the augmented free Čech complex at `V` is the
augmented combinatorial Čech complex of the full simplex on `I₁(V) = {i : V ≤ U_i}` with
constant coefficients the ring `O_X(V)`.  This section ports the constant-coefficient
combinatorial contracting homotopy — the prepend-`i_fix` map and its `d ∘ h + h ∘ d = id`
identity — into this file as a self-contained algebraic engine.

This is the free-side analogue of `CombinatorialCech.combHomotopy` in `CechAcyclic.lean`
(those declarations are `private` there, hence unavailable here); the proofs are the same
alternating-sum cancellation, specialised to the constant coefficient module.  Here `M` is
the constant coefficient module (to be `O_X(V)` in the application) and `ι` the index type
(to be `I₁(V)`). -/

namespace FreeCechEngine

variable {ι : Type*} {M : Type*} [AddCommGroup M] {n : ℕ}

/-- Alternating coface (Čech) differential with constant coefficients in `M`:
`(d t)(σ) = ∑ⱼ (-1)ʲ • t (σ ∘ j.succAbove)`, the alternating sum of the index-dropping
maps.  Free-side port of `CombinatorialCech.combDifferential`. -/
def combDifferential (t : (Fin n → ι) → M) : (Fin (n + 1) → ι) → M :=
  fun σ => ∑ j : Fin (n + 1), (-1 : ℤ) ^ (j : ℕ) • t (σ ∘ j.succAbove)

/-- The contracting homotopy: prepend the fixed index `r`.  `(h u)(τ) = u (Fin.cons r τ)`.
Free-side port of `CombinatorialCech.combHomotopy`. -/
def combHomotopy (r : ι) (u : (Fin (n + 1) → ι) → M) : (Fin n → ι) → M :=
  fun τ => u (Fin.cons r τ)

@[simp] lemma combHomotopy_zero (r : ι) :
    combHomotopy (M := M) (n := n) r 0 = 0 := by
  funext τ; simp [combHomotopy]

/-- Composing `Fin.cons r` with the `(k+1)`-th coface map is `Fin.cons r` of the `k`-th
coface map: the bookkeeping identity behind the homotopy computation. -/
lemma cons_comp_succAbove_succ (r : ι) (σ : Fin (n + 1) → ι) (k : Fin (n + 1)) :
    (Fin.cons r σ : Fin (n + 2) → ι) ∘ (k.succ).succAbove
      = Fin.cons r (σ ∘ k.succAbove) := by
  funext l
  refine Fin.cases ?_ ?_ l
  · simp
  · intro i; simp [Fin.succ_succAbove_succ]

/-- **Contracting-homotopy identity** `d ∘ h + h ∘ d = id` on the constant-coefficient
Čech complex (Stacks `lemma-homology-complex`, the `dh + hd = id` computation).  Free-side
port of `CombinatorialCech.combHomotopy_spec`. -/
lemma combHomotopy_spec (r : ι) (t : (Fin (n + 1) → ι) → M) :
    combDifferential (combHomotopy r t) + combHomotopy r (combDifferential t) = t := by
  funext σ
  simp only [combDifferential, combHomotopy, Pi.add_apply]
  rw [Fin.sum_univ_succ (f := fun j : Fin (n + 2) =>
    (-1 : ℤ) ^ (j : ℕ) • t ((Fin.cons r σ : Fin (n + 2) → ι) ∘ j.succAbove))]
  have h0 : (Fin.cons r σ : Fin (n + 2) → ι) ∘ (0 : Fin (n + 2)).succAbove = σ := by
    funext i; simp
  rw [h0]
  simp only [Fin.val_zero, pow_zero, one_smul, Fin.val_succ]
  rw [add_left_comm, ← Finset.sum_add_distrib]
  rw [Finset.sum_eq_zero (fun x _ => by
    rw [cons_comp_succAbove_succ, pow_succ, mul_comm, neg_one_mul, neg_smul]; abel), add_zero]

/-- Every cocycle is a coboundary in positive degree: if `d t = 0` then `t = d (h t)`. -/
lemma combDifferential_eq_of_cocycle (r : ι) (t : (Fin (n + 1) → ι) → M)
    (ht : combDifferential t = 0) : combDifferential (combHomotopy r t) = t := by
  have h := combHomotopy_spec r t
  rw [ht, combHomotopy_zero, add_zero] at h
  exact h

/-- Sign-cancellation behind `d² = 0`: under the index swap
`(j, i) ↦ (j.succAbove i, i.predAbove j)` the alternating sign flips. -/
lemma combSign_flip (j : Fin (n + 2)) (i : Fin (n + 1)) :
    ((-1 : ℤ) ^ (j : ℕ)) * ((-1) ^ (i : ℕ))
      = - (((-1 : ℤ) ^ ((j.succAbove i : Fin (n + 2)) : ℕ))
            * ((-1) ^ ((i.predAbove j : Fin (n + 1)) : ℕ))) := by
  rcases lt_or_ge (i.castSucc) j with h | h
  · rw [Fin.succAbove_of_castSucc_lt _ _ h, Fin.predAbove_of_castSucc_lt _ _ h,
        Fin.val_castSucc, Fin.val_pred]
    have hpos : 0 < (j : ℕ) := lt_of_le_of_lt (Nat.zero_le _) (by exact_mod_cast h)
    obtain ⟨m, hm⟩ : ∃ m, (j : ℕ) = m + 1 := ⟨(j : ℕ) - 1, by omega⟩
    rw [hm]; simp only [Nat.add_sub_cancel, pow_succ]; ring
  · rw [Fin.succAbove_of_le_castSucc _ _ h, Fin.predAbove_of_le_castSucc _ _ h,
        Fin.val_succ, Fin.coe_castPred]
    rw [pow_succ]; ring

/-- **`d² = 0`** for the constant-coefficient alternating Čech complex, via the
sign-reversing involution `(j, i) ↦ (j.succAbove i, i.predAbove j)`. -/
lemma combDifferential_comp (t : (Fin n → ι) → M) :
    combDifferential (combDifferential t) = 0 := by
  funext σ
  simp only [combDifferential, Pi.zero_apply, Finset.smul_sum, smul_smul]
  rw [← Fintype.sum_prod_type (f := fun p : Fin (n + 2) × Fin (n + 1) =>
    ((-1 : ℤ) ^ (p.1 : ℕ) * (-1) ^ (p.2 : ℕ)) • t ((σ ∘ p.1.succAbove) ∘ p.2.succAbove))]
  apply Finset.sum_involution (fun p _ => (p.1.succAbove p.2, p.2.predAbove p.1))
  · rintro ⟨j, i⟩ _
    have harg : (σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove
        = (σ ∘ j.succAbove) ∘ i.succAbove := by
      funext k
      simp only [Function.comp_apply]
      rw [Fin.succAbove_succAbove_succAbove_predAbove]
    simp only [harg]
    rw [← add_smul, combSign_flip j i]
    simp
  · rintro ⟨j, i⟩ _ _
    simp only [ne_eq, Prod.mk.injEq, not_and]
    intro hj
    exact absurd hj (Fin.succAbove_ne j i)
  · rintro ⟨j, i⟩ _
    simp only [Prod.mk.injEq]
    exact ⟨Fin.succAbove_succAbove_predAbove j i, Fin.predAbove_predAbove_succAbove j i⟩
  · intro a _; exact Finset.mem_univ _

/-- **Positive-degree exactness** of the constant-coefficient Čech complex
(`Function.Exact` form).  Free-side port of `CombinatorialCech.combDifferential_exact`. -/
lemma combDifferential_exact (r : ι) (n : ℕ) :
    Function.Exact (combDifferential : ((Fin (n + 1) → ι) → M) → ((Fin (n + 2) → ι) → M))
      (combDifferential : ((Fin (n + 2) → ι) → M) → ((Fin (n + 3) → ι) → M)) := by
  intro x
  constructor
  · intro hx
    exact ⟨combHomotopy r x, combDifferential_eq_of_cocycle r x hx⟩
  · rintro ⟨y, rfl⟩
    exact combDifferential_comp y

end FreeCechEngine

/-! ## Project-local Mathlib supplement — sectionwise reduction of the free Čech complex -/

/-- **Evaluation preserves the degreewise coproduct of the free Čech complex.**

The objectwise-reduction `quasiIso_of_evaluation` requires understanding the evaluation of
`cechFreePresheafComplex 𝒰` at an open `V`.  Since the degree-`p` term is the coproduct
`∐_{σ : Fin (p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)` and the evaluation functor
preserves finite colimits (`PresheafOfModules.Finite.evaluation_preservesFiniteColimits`,
with `Fin (p+1) → 𝒰.I₀` finite as `𝒰.I₀` is finite), evaluating commutes with the
coproduct:
`(evaluation V).obj (K(𝒰)_p) ≅ ∐_σ (evaluation V).obj (freeYoneda.obj (coverInterOpen 𝒰 σ))`.
This is the degree-`p` entry point for the sectionwise description
(blueprint `lem:cech_free_eval_sectionwise`); each evaluated summand
`(evaluation V).obj (freeYoneda.obj W) = (ModuleCat.free (O_X(V))).obj (V ⟶ W)` is the free
`O_X(V)`-module on the (subsingleton) hom-set `V ⟶ W`, i.e. `O_X(V)` if `V ≤ W` and `0`
otherwise.

Project-local: the assembly of evaluation-preserves-coproduct with the free Čech complex
has no Mathlib counterpart. -/
noncomputable def cechFreeEval_X (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : (TopologicalSpace.Opens ↥X)ᵒᵖ) (p : ℕ) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj V).obj ((cechFreePresheafComplex 𝒰).X p)
      ≅ ∐ fun σ : Fin (p + 1) → 𝒰.I₀ =>
          (PresheafOfModules.evaluation X.ringCatSheaf.obj V).obj
            (freeYoneda.obj (coverInterOpen 𝒰 σ)) := by
  haveI : Limits.PreservesColimitsOfShape (Discrete (Fin (p + 1) → 𝒰.I₀))
      (PresheafOfModules.evaluation X.ringCatSheaf.obj V) := by
    haveI := PresheafOfModules.Finite.evaluation_preservesFiniteColimits X.ringCatSheaf.obj V
    infer_instance
  exact Limits.PreservesCoproduct.iso _ _

/-- **Evaluating `freeYoneda W` at an open `V ⊄ W` gives the zero module.**

`(evaluation V).obj (freeYoneda.obj W) = (ModuleCat.free (O_X(V))).obj (V ⟶ W)` is the free
`O_X(V)`-module on the hom-set `V ⟶ W`.  When `V ≰ W` that hom-set is empty, so the module
is `0`.  This is the per-summand input to the empty case of the sectionwise reduction (and
kills the non-`I₁` summands in the nonempty case).

Project-local: a degreewise vanishing statement for the project's `freeYoneda`. -/
lemma freeYonedaEval_isZero_of_not_le {W V : TopologicalSpace.Opens ↥X} (h : ¬ V ≤ W) :
    Limits.IsZero ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
      (freeYoneda.obj W)) := by
  haveI : IsEmpty (V ⟶ W) := ⟨fun f => h (leOfHom f)⟩
  haveI : Subsingleton ↑((PresheafOfModules.evaluation X.ringCatSheaf.obj
      (Opposite.op V)).obj (freeYoneda.obj W)) :=
    ⟨fun a b => Finsupp.ext (fun x => (IsEmpty.false x).elim)⟩
  exact ModuleCat.isZero_of_subsingleton _

/-- **Evaluating `freeYoneda W` at an open `V ≤ W` gives `O_X(V)`.**

When `V ≤ W` the hom-set `V ⟶ W` is a singleton (`Unique`), so the free `O_X(V)`-module on it
is `O_X(V)` itself.  This is the per-summand identification of the surviving (`I₁`) summands in
the sectionwise reduction (blueprint `lem:cech_free_eval_sectionwise`): together with
`freeYonedaEval_isZero_of_not_le` it gives the description
`K(𝒰)_p(V) = ⊕_{σ : V ≤ U_σ} O_X(V)`.

Project-local: a degreewise identification for the project's `freeYoneda`. -/
noncomputable def freeYonedaEval_iso_of_le {W V : TopologicalSpace.Opens ↥X} (h : V ≤ W) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj (freeYoneda.obj W)
      ≅ ModuleCat.of (X.ringCatSheaf.obj.obj (Opposite.op V))
          (X.ringCatSheaf.obj.obj (Opposite.op V)) :=
  haveI : Unique (V ⟶ W) := ⟨⟨homOfLE h⟩, fun _ => Subsingleton.elim _ _⟩
  (Finsupp.LinearEquiv.finsuppUnique _ _ (V ⟶ W)).toModuleIso

/-- A coproduct of zero objects is a zero object: every coproduct injection out of a zero
object is zero, so the identity of the coproduct is zero. -/
lemma isZero_sigma_of_forall_isZero {C : Type*} [Category C] [Limits.HasZeroMorphisms C]
    {β : Type*} (f : β → C) [Limits.HasCoproduct f]
    (h : ∀ b, Limits.IsZero (f b)) : Limits.IsZero (∐ f) := by
  rw [Limits.IsZero.iff_id_eq_zero]
  apply Limits.Sigma.hom_ext
  intro b
  rw [Category.comp_id, Limits.comp_zero]
  exact (h b).eq_zero_of_src _

/-- **Empty case of the sectionwise reduction (object level).**

If no cover member `U_i` contains `V` (i.e. `I₁(V) = ∅`), then the degree-`p` term of the
free Čech complex evaluates to the zero module at `V`.  Indeed every multi-index intersection
`coverInterOpen 𝒰 σ ≤ coverOpen 𝒰 (σ 0)`, so `V ≤ coverInterOpen 𝒰 σ` would force `V` into a
cover member, contradiction; hence each summand vanishes by `freeYonedaEval_isZero_of_not_le`
and the coproduct is zero.  This is the object-level input to
`cech_free_eval_empty`. -/
lemma cechFreeEval_isZero_of_isEmpty (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) (hV : ∀ i, ¬ V ≤ coverOpen 𝒰 i) :
    Limits.IsZero ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
      ((cechFreePresheafComplex 𝒰).X p)) := by
  refine Limits.IsZero.of_iso ?_ (cechFreeEval_X 𝒰 (Opposite.op V) p)
  apply isZero_sigma_of_forall_isZero
  intro σ
  apply freeYonedaEval_isZero_of_not_le
  intro hle
  exact hV (σ 0) (le_trans hle (iInf_le (fun k => coverOpen 𝒰 (σ k)) 0))

/-- **Empty case — the cover structure presheaf evaluates to zero.**

If no cover member contains `V` (`I₁(V) = ∅`), then `O_𝒰(V) = 0`.  The cover structure
presheaf is the image of the augmentation `cechFreeAug`, so `O_𝒰` is an epimorphic image of
`K(𝒰)_0` via `factorThruImage`; evaluating at `V` (which preserves epimorphisms) gives an
epimorphism out of the zero module `(evaluation V).obj (K(𝒰)_0)`
(`cechFreeEval_isZero_of_isEmpty`), so its target is zero. -/
lemma coverStructurePresheaf_eval_isZero_of_isEmpty (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (hV : ∀ i, ¬ V ≤ coverOpen 𝒰 i) :
    Limits.IsZero ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
      (coverStructurePresheaf 𝒰)) := by
  change Limits.IsZero ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
      (Limits.image (cechFreeAug 𝒰)))
  haveI : Epi ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
      (Limits.factorThruImage (cechFreeAug 𝒰))) :=
    Functor.map_epi (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V))
      (Limits.factorThruImage (cechFreeAug 𝒰))
  exact Limits.IsZero.of_epi
    ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
      (Limits.factorThruImage (cechFreeAug 𝒰)))
    (cechFreeEval_isZero_of_isEmpty 𝒰 V 0 hV)

/-- The homology of a homological complex vanishes in any degree where the complex object
vanishes: the degree-`i` homology is a subquotient of `K.X i`. -/
lemma isZero_homology_of_isZero_X {C : Type*} [Category C] [Limits.HasZeroMorphisms C]
    {ι : Type*} {c : ComplexShape ι} (K : HomologicalComplex C c) (i : ι) [K.HasHomology i]
    (h : Limits.IsZero (K.X i)) : Limits.IsZero (K.homology i) := by
  rw [← K.exactAt_iff_isZero_homology i, HomologicalComplex.exactAt_iff,
    ShortComplex.exact_iff_isZero_homology]
  exact ShortComplex.isZero_homology_of_isZero_X₂ _ h

/-- **Empty case of the sectionwise reduction** (`lem:cech_free_eval_empty`).

If no cover member contains `V` (`I₁(V) = ∅`), the evaluation at `V` of the augmentation
chain map `cechFreeComplexAug` is a quasi-isomorphism: both the evaluated free complex
(`cechFreeEval_isZero_of_isEmpty`) and the evaluated target
(`coverStructurePresheaf_eval_isZero_of_isEmpty`) are objectwise zero, so all their homology
vanishes and the induced homology map is an isomorphism between zero objects. -/
lemma cechFreeEval_quasiIso_of_isEmpty (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (hV : ∀ i, ¬ V ≤ coverOpen 𝒰 i) :
    QuasiIso (((PresheafOfModules.evaluation X.ringCatSheaf.obj
      (Opposite.op V)).mapHomologicalComplex (ComplexShape.down ℕ)).map
        (cechFreeComplexAug 𝒰)) := by
  rw [quasiIso_iff]
  intro i
  rw [quasiIsoAt_iff_isIso_homologyMap]
  refine Limits.isIso_of_source_target_iso_zero _
    (Limits.IsZero.isoZero ?_) (Limits.IsZero.isoZero ?_)
  · exact isZero_homology_of_isZero_X _ i (cechFreeEval_isZero_of_isEmpty 𝒰 V i hV)
  · apply isZero_homology_of_isZero_X
    rcases i with _ | n
    · exact coverStructurePresheaf_eval_isZero_of_isEmpty 𝒰 V hV
    · exact Limits.IsZero.of_iso (Limits.isZero_zero _)
        ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).mapZeroObject)

/-! ## Project-local Mathlib supplement — degreewise engine model of the evaluated free complex

The nonempty-case analysis of the evaluated free Čech complex needs an explicit degreewise
identification of `(evaluation V).obj (K(𝒰)_p)` with the constant-coefficient combinatorial model
`∐_{σ : Fin (p+1) → I₁(V)} O_X(V)`, where `I₁(V) = {i : V ≤ U_i}`.  This section builds that
degreewise object isomorphism as the composite

  `(eval V)(K_p) ≅[cechFreeEval_X] ∐_{σ : Fin(p+1)→I₀} (eval V)(freeYoneda U_σ)`
  `           ≅[drop-zeros]      ∐_{σ : V ≤ U_σ} (eval V)(freeYoneda U_σ)`
  `           ≅[whiskerEquiv]    ∐_{τ : Fin(p+1)→I₁(V)} O_X(V),`

using `freeYonedaEval_isZero_of_not_le` to discard the summands with `V ≰ U_σ` and
`freeYonedaEval_iso_of_le` to identify each surviving summand with `O_X(V)`.  The differential
match turning this degreewise iso into an iso of chain complexes is the genuine remaining
bottleneck and is NOT discharged here. -/

/-- `V ≤ coverInterOpen 𝒰 σ` holds iff every value of `σ` indexes a cover member containing `V`;
i.e. `σ` factors through `I₁(V) = {i : V ≤ U_i}`.  This is the index-splitting criterion separating
the surviving summands of the evaluated free Čech complex from the vanishing ones. -/
lemma le_coverInterOpen_iff (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    {κ : Type} (σ : κ → 𝒰.I₀) :
    V ≤ coverInterOpen 𝒰 σ ↔ ∀ k, V ≤ coverOpen 𝒰 (σ k) := by
  simp only [coverInterOpen, le_iInf_iff]

/-- **Reindexing the surviving multi-indices.** The multi-indices `σ : Fin (p+1) → 𝒰.I₀` with
`V ≤ U_σ` are in bijection with the maps `Fin (p+1) → I₁(V)` into the subtype
`I₁(V) = {i : V ≤ U_i}` of cover members containing `V`.  This bijection feeds
`Limits.Sigma.whiskerEquiv` to collapse the
surviving coproduct onto the constant-coefficient combinatorial index `Fin (p+1) → I₁(V)`. -/
def survivingEquiv (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    (Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) ≃
      {σ : Fin (p + 1) → 𝒰.I₀ // V ≤ coverInterOpen 𝒰 σ} where
  toFun τ := ⟨fun k => (τ k).1, (le_coverInterOpen_iff 𝒰 V _).2 fun k => (τ k).2⟩
  invFun σ := fun k => ⟨σ.1 k, (le_coverInterOpen_iff 𝒰 V σ.1).1 σ.2 k⟩
  left_inv τ := by funext k; rfl
  right_inv σ := by ext k; rfl

/-- **Drop-zeros isomorphism.** Evaluating the degree-`p` free Čech term at `V` and splitting off
the vanishing summands: the full coproduct over all `σ : Fin (p+1) → 𝒰.I₀` is isomorphic to the
coproduct over the *surviving* multi-indices `{σ : V ≤ U_σ}`, because every non-surviving summand
`(eval V)(freeYoneda U_σ)` (with `V ≰ U_σ`) is a zero object
(`freeYonedaEval_isZero_of_not_le`).  This is the first of the two halves identifying the evaluated
term with the combinatorial model. -/
noncomputable def cechFreeEvalDropZeros (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    (∐ fun σ : Fin (p + 1) → 𝒰.I₀ =>
        (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
          (freeYoneda.obj (coverInterOpen 𝒰 σ))) ≅
      (∐ fun s : {σ : Fin (p + 1) → 𝒰.I₀ // V ≤ coverInterOpen 𝒰 σ} =>
        (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
          (freeYoneda.obj (coverInterOpen 𝒰 s.1))) where
  hom := Limits.Sigma.desc fun σ => by
    classical
    exact if h : V ≤ coverInterOpen 𝒰 σ then
      Limits.Sigma.ι (fun s : {σ : Fin (p + 1) → 𝒰.I₀ // V ≤ coverInterOpen 𝒰 σ} =>
        (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
          (freeYoneda.obj (coverInterOpen 𝒰 s.1))) ⟨σ, h⟩
    else 0
  inv := Limits.Sigma.desc fun s =>
    Limits.Sigma.ι (fun σ : Fin (p + 1) → 𝒰.I₀ =>
      (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
        (freeYoneda.obj (coverInterOpen 𝒰 σ))) s.1
  hom_inv_id := by
    apply Limits.Sigma.hom_ext; intro σ
    rw [Limits.Sigma.ι_desc_assoc, Category.comp_id]
    by_cases h : V ≤ coverInterOpen 𝒰 σ
    · rw [dif_pos h, Limits.Sigma.ι_desc]
    · rw [dif_neg h, Limits.zero_comp]
      exact ((freeYonedaEval_isZero_of_not_le h).eq_zero_of_src _).symm
  inv_hom_id := by
    apply Limits.Sigma.hom_ext; intro s
    rw [Limits.Sigma.ι_desc_assoc, Category.comp_id, Limits.Sigma.ι_desc, dif_pos s.2]

/-- **Degreewise engine model of the evaluated free Čech term.** The degree-`p` term of the
evaluated free Čech complex at `V` is isomorphic to the constant-coefficient combinatorial model
`∐_{τ : Fin (p+1) → I₁(V)} O_X(V)`, where `I₁(V) = {i : V ≤ U_i}`.  Built as the composite of
`cechFreeEval_X` (evaluation commutes with the coproduct), `cechFreeEvalDropZeros` (discard the
`V ≰ U_σ` summands), and `Limits.Sigma.whiskerEquiv` along `survivingEquiv` with the per-summand
identification `freeYonedaEval_iso_of_le`.  This is the object half of the engine iso
`cechFreeEvalEngineIso`; the differential match remains. -/
noncomputable def cechFreeEvalEngine_X (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
        ((cechFreePresheafComplex 𝒰).X p) ≅
      ∐ fun _ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} =>
        ModuleCat.of (X.ringCatSheaf.obj.obj (Opposite.op V))
          (X.ringCatSheaf.obj.obj (Opposite.op V)) :=
  cechFreeEval_X 𝒰 (Opposite.op V) p ≪≫ cechFreeEvalDropZeros 𝒰 V p ≪≫
    (Limits.Sigma.whiskerEquiv (survivingEquiv 𝒰 V p)
      (g := fun s : {σ : Fin (p + 1) → 𝒰.I₀ // V ≤ coverInterOpen 𝒰 σ} =>
        (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
          (freeYoneda.obj (coverInterOpen 𝒰 s.1)))
      (fun τ => freeYonedaEval_iso_of_le ((survivingEquiv 𝒰 V p τ).2))).symm

/-! ## Project-local Mathlib supplement — the engine chain complex `C•`

The degreewise model `∐_{τ : Fin (p+1) → I₁(V)} O_X(V)` assembles into an honest chain complex of
`O_X(V)`-modules, the **engine complex** `cechEngineComplex`.  Its differential `C_{p+1} ⟶ C_p` is
the alternating sum of the index-dropping coproduct reindexings `σ ↦ σ ∘ Fin.succAbove i` — this is
the
chain (insertion) form of the Stacks `lemma-homology-complex` differential, the chain dual of the
constant-coefficient `FreeCechEngine.combDifferential`.  `cechFreeEvalEngineIso` (next) identifies
the evaluated free Čech complex with `cechEngineComplex`; this section provides its target. -/

/-- The constant coefficient module `O_X(V)` viewed as a module over itself.  This is the
per-summand target of `freeYonedaEval_iso_of_le`, hence the coefficient of the engine complex. -/
abbrev coverSectionModule (V : TopologicalSpace.Opens ↥X) :
    ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V)) :=
  ModuleCat.of _ (X.ringCatSheaf.obj.obj (Opposite.op V))

/-- The degree-`p` object of the engine complex: `∐_{σ : Fin (p+1) → I₁(V)} O_X(V)`. -/
noncomputable abbrev cechEngineX (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V)) :=
  ∐ fun _ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} => coverSectionModule V

/-- The engine differential `C_{p+1} ⟶ C_p`: the alternating sum over `i : Fin (p+2)` of the
coproduct reindexing maps `ι_σ ↦ (-1)^i • ι_{σ ∘ Fin.succAbove i}` that drop the `i`-th index of
the multi-index `σ : Fin (p+2) → I₁(V)`.  Chain (insertion) dual of
`FreeCechEngine.combDifferential`. -/
noncomputable def cechEngineD (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    cechEngineX 𝒰 V (p + 1) ⟶ cechEngineX 𝒰 V p :=
  Limits.Sigma.desc fun σ => ∑ i : Fin (p + 2), (-1 : ℤ) ^ (i : ℕ) •
    Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} => coverSectionModule V)
      (σ ∘ i.succAbove)

/-- Action of the engine differential on a coproduct injection: `ι_σ ≫ cechEngineD = ∑_i (-1)^i •
ι_{σ ∘ succAbove i}`. -/
lemma cechEngineD_ι (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) (p : ℕ)
    (σ : Fin (p + 2) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) :
    Limits.Sigma.ι _ σ ≫ cechEngineD 𝒰 V p
      = ∑ i : Fin (p + 2), (-1 : ℤ) ^ (i : ℕ) •
          Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} =>
            coverSectionModule V) (σ ∘ i.succAbove) := by
  simp only [cechEngineD, Limits.Sigma.ι_desc]

/-- **`d² = 0` for the engine complex**, via the same sign-reversing involution
`(i, j) ↦ (i.succAbove j, j.predAbove i)` as `FreeCechEngine.combDifferential_comp`, transported to
the coproduct injections. -/
lemma cechEngineD_comp (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    cechEngineD 𝒰 V (p + 1) ≫ cechEngineD 𝒰 V p = 0 := by
  apply Limits.Sigma.hom_ext; intro σ
  rw [Limits.comp_zero, ← Category.assoc, cechEngineD_ι]
  rw [Preadditive.sum_comp]
  simp only [Preadditive.zsmul_comp, cechEngineD_ι, Finset.smul_sum, smul_smul]
  rw [← Fintype.sum_prod_type (f := fun q : Fin (p + 3) × Fin (p + 2) =>
    ((-1 : ℤ) ^ (q.1 : ℕ) * (-1) ^ (q.2 : ℕ)) •
      Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} =>
        coverSectionModule V) ((σ ∘ q.1.succAbove) ∘ q.2.succAbove))]
  apply Finset.sum_involution (fun q _ => (q.1.succAbove q.2, q.2.predAbove q.1))
  · rintro ⟨j, i⟩ _
    have harg : (σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove
        = (σ ∘ j.succAbove) ∘ i.succAbove := by
      funext k
      simp only [Function.comp_apply]
      rw [Fin.succAbove_succAbove_succAbove_predAbove]
    simp only [harg]
    rw [← add_smul, FreeCechEngine.combSign_flip j i]
    simp
  · rintro ⟨j, i⟩ _ _
    simp only [ne_eq, Prod.mk.injEq, not_and]
    intro hj
    exact absurd hj (Fin.succAbove_ne j i)
  · rintro ⟨j, i⟩ _
    simp only [Prod.mk.injEq]
    exact ⟨Fin.succAbove_succAbove_predAbove j i, Fin.predAbove_predAbove_succAbove j i⟩
  · intro a _; exact Finset.mem_univ _

/-- **The engine chain complex** `C•` of an open `V` meeting some cover member.

The chain complex of `O_X(V)`-modules with `C_p = ∐_{σ : Fin (p+1) → I₁(V)} O_X(V)` and the
alternating index-dropping differential `cechEngineD`.  It is the constant-coefficient combinatorial
model that `cechFreeEvalEngineIso` identifies with the evaluated free Čech complex; the nonempty
acyclicity of the evaluated complex reduces to the contractibility of `C•`.

Project-local: the constant-coefficient Čech model complex has no Mathlib counterpart. -/
noncomputable def cechEngineComplex (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) :
    ChainComplex (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V))) ℕ :=
  ChainComplex.of (cechEngineX 𝒰 V) (cechEngineD 𝒰 V) (cechEngineD_comp 𝒰 V)

/-! ## Project-local Mathlib supplement — contracting homotopy of the engine complex

Fixing an index `i_fix ∈ I₁(V)` (which exists exactly when `V` meets some cover member), the
prepend-`i_fix` map `ι_σ ↦ ι_{Fin.cons i_fix σ}` contracts the engine complex: `d ∘ s + s ∘ d = id`
in every positive degree.  This is the chain (coproduct) port of `FreeCechEngine.combHomotopy` /
`combHomotopy_spec`, and it yields the positive-degree exactness of `cechEngineComplex` feeding the
nonempty case of the free Čech quasi-isomorphism. -/

/-- The prepend-`i_fix` contracting map `C_p ⟶ C_{p+1}` of the engine complex: on the coproduct
injection `ι_σ` (`σ : Fin (p+1) → I₁(V)`) it returns `ι_{Fin.cons i_fix σ}`. -/
noncomputable def cechEnginePrepend (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) (p : ℕ) :
    cechEngineX 𝒰 V p ⟶ cechEngineX 𝒰 V (p + 1) :=
  Limits.Sigma.desc fun σ =>
    Limits.Sigma.ι (fun _ : Fin (p + 2) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} => coverSectionModule V)
      (Fin.cons i_fix σ)

/-- Action of the prepend map on a coproduct injection. -/
lemma cechEnginePrepend_ι (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) (p : ℕ)
    (σ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) :
    Limits.Sigma.ι _ σ ≫ cechEnginePrepend 𝒰 V i_fix p
      = Limits.Sigma.ι (fun _ : Fin (p + 2) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} =>
          coverSectionModule V) (Fin.cons i_fix σ) := by
  simp only [cechEnginePrepend, Limits.Sigma.ι_desc]

/-- **Contracting-homotopy identity** `d ∘ s + s ∘ d = id` for the engine complex in positive
degree: the coproduct port of `FreeCechEngine.combHomotopy_spec`.  The `i = 0` term of `s ≫ d`
returns the identity (dropping the just-prepended `i_fix`), and every higher term cancels in pairs
against the corresponding term of `d ≫ s` by `FreeCechEngine.cons_comp_succAbove_succ`. -/
lemma cechEnginePrepend_spec (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) (n : ℕ) :
    cechEnginePrepend 𝒰 V i_fix (n + 1) ≫ cechEngineD 𝒰 V (n + 1)
      + cechEngineD 𝒰 V n ≫ cechEnginePrepend 𝒰 V i_fix n
      = 𝟙 (cechEngineX 𝒰 V (n + 1)) := by
  apply Limits.Sigma.hom_ext; intro σ
  rw [Preadditive.comp_add, Category.comp_id]
  rw [← Category.assoc, cechEnginePrepend_ι, cechEngineD_ι]
  rw [← Category.assoc, cechEngineD_ι, Preadditive.sum_comp]
  simp only [Preadditive.zsmul_comp, cechEnginePrepend_ι]
  rw [Fin.sum_univ_succ (f := fun i : Fin (n + 3) => (-1 : ℤ) ^ (i : ℕ) •
    Limits.Sigma.ι (fun _ : Fin (n + 2) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} => coverSectionModule V)
      ((Fin.cons i_fix σ : Fin (n + 3) → _) ∘ i.succAbove))]
  have h0 : (Fin.cons i_fix σ : Fin (n + 3) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i})
      ∘ (0 : Fin (n + 3)).succAbove = σ := by funext k; simp
  rw [h0]
  simp only [Fin.val_zero, pow_zero, one_smul, Fin.val_succ]
  rw [add_assoc, ← Finset.sum_add_distrib]
  rw [Finset.sum_eq_zero (fun k _ => by
    rw [FreeCechEngine.cons_comp_succAbove_succ, pow_succ, mul_comm, neg_one_mul, neg_smul]
    abel), add_zero]

/-- **Positive-degree exactness of the engine complex** (`Function.Exact` form), the coproduct port
of `FreeCechEngine.combDifferential_exact`.  When `I₁(V)` is nonempty (witnessed by `i_fix`), the
engine differential is exact at every positive degree: a cycle `x` with `cechEngineD n x = 0` is the
boundary `cechEngineD (n+1) (cechEnginePrepend (n+1) x)`, by the contracting identity
`cechEnginePrepend_spec`.  Feeds the nonempty-case homology vanishing via
`ModuleCat.shortComplex_exact`. -/
lemma cechEngineD_exact (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) (n : ℕ) :
    Function.Exact (cechEngineD 𝒰 V (n + 1)) (cechEngineD 𝒰 V n) := by
  intro x
  constructor
  · intro hx
    refine ⟨(cechEnginePrepend 𝒰 V i_fix (n + 1)) x, ?_⟩
    have hspec := congrArg ModuleCat.Hom.hom (cechEnginePrepend_spec 𝒰 V i_fix n)
    rw [ModuleCat.hom_add, ModuleCat.hom_comp, ModuleCat.hom_comp, ModuleCat.hom_id] at hspec
    have hx2 := DFunLike.congr_fun hspec x
    rw [LinearMap.add_apply, LinearMap.comp_apply, LinearMap.comp_apply, LinearMap.id_apply,
      hx, map_zero, add_zero] at hx2
    exact hx2
  · rintro ⟨y, rfl⟩
    have hcomp := congrArg ModuleCat.Hom.hom (cechEngineD_comp 𝒰 V n)
    rw [ModuleCat.hom_comp, ModuleCat.hom_zero] at hcomp
    have h2 := DFunLike.congr_fun hcomp y
    rw [LinearMap.comp_apply, LinearMap.zero_apply] at h2
    exact h2

/-! ## Project-local Mathlib supplement — naturality bridge for the engine differential match

The differential comm-square of `cechFreeEvalEngineIso` reduces, summand-by-summand, to the
naturality of the per-summand identification `freeYonedaEval_iso_of_le`.  The key observation is
that this identification iso is *exactly* the evaluation of the augmentation `freeYonedaAug`: both
are the `O_X(V)`-linear map out of the free module on the singleton hom-set `V ⟶ W` sending the
generator to `1`.  Hence the naturality of `freeYonedaEval_iso_of_le` is the already-proven
`freeYoneda_map_comp_aug`, evaluated at `V`. -/

/-- The identification iso `freeYonedaEval_iso_of_le h` (for `V ≤ W`) coincides with the
evaluation of the augmentation `freeYonedaAug W` at `V`.  Both are the unique `O_X(V)`-linear map
from the free module on the singleton hom-set `V ⟶ W` sending the generator `freeMk g` to
`1 ∈ O_X(V)`. -/
lemma freeYonedaEval_iso_of_le_hom_eq_aug {W V : TopologicalSpace.Opens ↥X} (h : V ≤ W) :
    (freeYonedaEval_iso_of_le h).hom = (freeYonedaAug W).app (Opposite.op V) := by
  haveI : Unique (V ⟶ W) := ⟨⟨homOfLE h⟩, fun _ => Subsingleton.elim _ _⟩
  apply ModuleCat.free_hom_ext
  intro g
  have hL : (ConcreteCategory.hom (freeYonedaEval_iso_of_le h).hom) (ModuleCat.freeMk g)
      = (1 : X.ringCatSheaf.obj.obj (Opposite.op V)) := by
    simp only [freeYonedaEval_iso_of_le, LinearEquiv.toModuleIso_hom]
    change (Finsupp.LinearEquiv.finsuppUnique _ _ (V ⟶ W)) (ModuleCat.freeMk g) = 1
    rw [Finsupp.LinearEquiv.finsuppUnique_apply]
    simp only [ModuleCat.freeMk, Unique.eq_default g, Finsupp.single_eq_same]
  exact hL.trans (freeYonedaAug_app_freeMk (g : V ⟶ W)).symm

/-- **Naturality of the per-summand identification `freeYonedaEval_iso_of_le`.** For
`A ≤ B` (representable index-dropping inclusion) and `V ≤ A`, evaluating the free-presheaf
restriction `freeYoneda.map (homOfLE h₁) : freeYoneda A ⟶ freeYoneda B` at `V` and then
identifying with `O_X(V)` is the same as identifying directly: the restriction acts as the
identity on the constant coefficient `O_X(V)`.  This is the summand-for-summand input to the
differential comm-square of `cechFreeEvalEngineIso`, obtained from the augmentation naturality
`freeYoneda_map_comp_aug` via the bridge `freeYonedaEval_iso_of_le_hom_eq_aug`. -/
lemma freeYonedaEval_iso_of_le_natural {A B V : TopologicalSpace.Opens ↥X} (h₁ : A ≤ B)
    (hVA : V ≤ A) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
        (freeYoneda.map (homOfLE h₁)) ≫ (freeYonedaEval_iso_of_le (le_trans hVA h₁)).hom
      = (freeYonedaEval_iso_of_le hVA).hom := by
  rw [freeYonedaEval_iso_of_le_hom_eq_aug, freeYonedaEval_iso_of_le_hom_eq_aug,
    PresheafOfModules.evaluation_map, ← freeYoneda_map_comp_aug h₁, PresheafOfModules.comp_app]
  rfl

/-- Action of `(cechFreeEval_X).inv` on a coproduct injection: it is `(eval V)` applied to the
corresponding injection of the unevaluated free Čech term.  This is the `PreservesCoproduct.iso`
naturality (`ι_comp_sigmaComparison`) specialised to `cechFreeEval_X`. -/
private lemma cechFreeEval_X_ι_inv (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) (σ : Fin (p + 1) → 𝒰.I₀) :
    Limits.Sigma.ι (fun σ : Fin (p + 1) → 𝒰.I₀ =>
        (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
          (freeYoneda.obj (coverInterOpen 𝒰 σ))) σ ≫ (cechFreeEval_X 𝒰 (Opposite.op V) p).inv
      = (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
          (Limits.Sigma.ι (fun σ : Fin (p + 1) → 𝒰.I₀ =>
            freeYoneda.obj (coverInterOpen 𝒰 σ)) σ) := by
  have hinv : (cechFreeEval_X 𝒰 (Opposite.op V) p).inv
      = Limits.sigmaComparison (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V))
          (fun σ : Fin (p + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)) := rfl
  rw [hinv]
  exact Limits.ι_comp_sigmaComparison _ _ σ

/-- **Reduced action of the engine identification on a surviving injection.** For a multi-index
`σ` with `V ≤ U_σ`, transporting the `σ`-injection through `(cechFreeEval_X).inv` and the engine
identification `cechFreeEvalEngine_X` lands on the engine injection of the lift
`k ↦ ⟨σ k, _⟩ : Fin (p+1) → I₁(V)`, precomposed by the augmentation `freeYonedaAug` at `V`.
This is the summand bookkeeping feeding the differential comm-square. -/
private lemma cechFreeEvalEngine_X_inv_hom_ι (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) (σ : Fin (p + 1) → 𝒰.I₀)
    (hσ : V ≤ coverInterOpen 𝒰 σ) :
    Limits.Sigma.ι (fun σ : Fin (p + 1) → 𝒰.I₀ =>
        (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
          (freeYoneda.obj (coverInterOpen 𝒰 σ))) σ
      ≫ (cechFreeEval_X 𝒰 (Opposite.op V) p).inv ≫ (cechFreeEvalEngine_X 𝒰 V p).hom
      = (freeYonedaEval_iso_of_le hσ).hom
        ≫ Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} =>
            coverSectionModule V) (fun k => ⟨σ k, (le_coverInterOpen_iff 𝒰 V σ).1 hσ k⟩) := by
  rw [cechFreeEvalEngine_X]
  simp only [Iso.trans_hom, Iso.symm_hom, Iso.inv_hom_id_assoc]
  rw [← Category.assoc]
  simp only [cechFreeEvalDropZeros, Limits.Sigma.ι_desc, dif_pos hσ, Limits.Sigma.whiskerEquiv,
    Limits.Sigma.ι_comp_map']
  congr 1

/-- Evaluated naturality of the augmentation: `(eval V)` applied to the free-presheaf restriction
`freeYoneda.map (homOfLE h₁)` followed by the augmentation over the larger open equals the
augmentation over the smaller open. The `.app`-level form of `freeYoneda_map_comp_aug`. -/
private lemma freeYonedaAug_app_comp {A B V : TopologicalSpace.Opens ↥X} (h₁ : A ≤ B) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
        (freeYoneda.map (homOfLE h₁)) ≫ (freeYonedaAug B).app (Opposite.op V)
      = (freeYonedaAug A).app (Opposite.op V) := by
  rw [PresheafOfModules.evaluation_map, ← freeYoneda_map_comp_aug h₁, PresheafOfModules.comp_app]
  rfl

/-- Action of the free Čech differential on a coproduct injection: the alternating sum of the
representable index-dropping maps `σ ↦ σ ∘ Fin.succAbove i`. Unfolds the `alternatingFaceMapComplex`
differential of `cechFreeSimplicial` on the `σ`-summand. -/
private lemma cechFree_d_ι (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (p : ℕ) (σ : Fin (p + 2) → 𝒰.I₀) :
    Limits.Sigma.ι (fun σ : Fin (p + 2) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)) σ
        ≫ (cechFreePresheafComplex 𝒰).d (p + 1) p
      = ∑ i : Fin (p + 2), (-1 : ℤ) ^ (i : ℕ) •
          (freeYoneda.map (homOfLE (coverInterOpen_comp_le 𝒰 i.succAbove σ))
            ≫ Limits.Sigma.ι (fun τ : Fin (p + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 τ))
                (σ ∘ i.succAbove)) := by
  have main : Limits.Sigma.ι _ σ
      ≫ AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰) p
      = ∑ i : Fin (p + 2), (-1 : ℤ) ^ (i : ℕ) •
          (freeYoneda.map (homOfLE (coverInterOpen_comp_le 𝒰 i.succAbove σ))
            ≫ Limits.Sigma.ι (fun τ : Fin (p + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 τ))
                (σ ∘ i.succAbove)) := by
    refine (Preadditive.comp_sum Finset.univ (Limits.Sigma.ι _ σ)
      (fun i : Fin (p + 2) => (-1 : ℤ) ^ (i : ℕ) • (cechFreeSimplicial 𝒰).δ i)).trans ?_
    apply Finset.sum_congr rfl
    intro i _
    refine (Preadditive.comp_zsmul _ _ _).trans ?_
    congr 1
    show Limits.Sigma.ι _ σ ≫ (cechFreeSimplicial 𝒰).δ i = _
    simp only [SimplicialObject.δ, cechFreeSimplicial, Limits.Sigma.ι_desc]
    rfl
  rw [show (cechFreePresheafComplex 𝒰).d (p + 1) p
      = AlgebraicTopology.AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰) p from
    AlgebraicTopology.alternatingFaceMapComplex_obj_d (cechFreeSimplicial 𝒰) p]
  exact main

/-- Action of the engine identification on an *evaluated* injection of a surviving multi-index:
`(eval V).map (Sigma.ι τ) ≫ (cechFreeEvalEngine_X p).hom = (freeYonedaEval_iso_of_le hτ).hom ≫
ι_{lift τ}`. Combines `cechFreeEval_X_ι_inv` (turning the evaluated injection into
`Sigma.ι ≫ inv`) with `cechFreeEvalEngine_X_inv_hom_ι`. -/
private lemma cechFreeEvalEngine_map_ι (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) (τ : Fin (p + 1) → 𝒰.I₀)
    (hτ : V ≤ coverInterOpen 𝒰 τ) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
        (Limits.Sigma.ι (fun σ : Fin (p + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)) τ)
      ≫ (cechFreeEvalEngine_X 𝒰 V p).hom
      = (freeYonedaEval_iso_of_le hτ).hom
        ≫ Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} =>
            coverSectionModule V) (fun k => ⟨τ k, (le_coverInterOpen_iff 𝒰 V τ).1 hτ k⟩) := by
  rw [← cechFreeEval_X_ι_inv 𝒰 V p τ]
  erw [Category.assoc, cechFreeEvalEngine_X_inv_hom_ι 𝒰 V p τ hτ]

/-- **Differential comm-square of the engine identification.** The degreewise object isos
`cechFreeEvalEngine_X` intertwine the evaluated free Čech differential with the engine
differential `cechEngineD`.  This is the single comm-square upgrading the degreewise object iso to
the chain iso `cechFreeEvalEngineIso`. -/
private lemma cechFreeEvalEngine_comm (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    (cechFreeEvalEngine_X 𝒰 V (p + 1)).hom ≫ cechEngineD 𝒰 V p
      = (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
          ((cechFreePresheafComplex 𝒰).d (p + 1) p) ≫ (cechFreeEvalEngine_X 𝒰 V p).hom := by
  refine (cancel_epi (cechFreeEval_X 𝒰 (Opposite.op V) (p + 1)).inv).mp ?_
  apply Limits.Sigma.hom_ext
  intro σ
  by_cases hσ : V ≤ coverInterOpen 𝒰 σ
  · slice_lhs 1 3 => rw [cechFreeEvalEngine_X_inv_hom_ι 𝒰 V (p + 1) σ hσ]
    slice_lhs 2 3 => rw [cechEngineD_ι]
    slice_rhs 1 2 => rw [cechFreeEval_X_ι_inv 𝒰 V (p + 1) σ]
    erw [← Functor.map_comp, cechFree_d_ι 𝒰 p σ]
    erw [Functor.map_sum]
    rw [Preadditive.comp_sum]
    erw [Preadditive.sum_comp]
    apply Finset.sum_congr rfl
    intro i _
    erw [Preadditive.comp_zsmul, Functor.map_zsmul, Preadditive.zsmul_comp]
    congr 1
    have hσi : V ≤ coverInterOpen 𝒰 (σ ∘ i.succAbove) :=
      le_trans hσ (coverInterOpen_comp_le 𝒰 i.succAbove σ)
    erw [Functor.map_comp, Category.assoc, cechFreeEvalEngine_map_ι 𝒰 V p (σ ∘ i.succAbove) hσi]
    erw [← Category.assoc,
      freeYonedaEval_iso_of_le_natural (coverInterOpen_comp_le 𝒰 i.succAbove σ) hσ]
    rfl
  · exact (freeYonedaEval_isZero_of_not_le hσ).eq_of_src _ _

/-! ## Project-local Mathlib supplement — the engine chain isomorphism

The differential comm-square `cechFreeEvalEngine_comm` upgrades the degreewise object isos
`cechFreeEvalEngine_X` to an isomorphism of chain complexes between the evaluation of the free Čech
complex at `V` and the constant-coefficient engine complex `cechEngineComplex`.  This is the chain
iso the nonempty-case quasi-isomorphism is transferred across. -/

/-- **The engine chain isomorphism** (`lem:cech_free_eval_engine_iso`).  For each open `V`, the
evaluation at `V` of the free Čech complex is isomorphic, as a chain complex, to the
constant-coefficient engine complex `cechEngineComplex 𝒰 V`.  Built from the degreewise object isos
`cechFreeEvalEngine_X` and the differential comm-square `cechFreeEvalEngine_comm`.

Project-local: the identification of the evaluated free Čech complex with its combinatorial
model has no Mathlib counterpart. -/
noncomputable def cechFreeEvalEngineIso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) :
    ((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).mapHomologicalComplex
        (ComplexShape.down ℕ)).obj (cechFreePresheafComplex 𝒰) ≅ cechEngineComplex 𝒰 V :=
  HomologicalComplex.Hom.isoOfComponents (fun p => cechFreeEvalEngine_X 𝒰 V p) (by
    intro i j hij
    rw [ComplexShape.down_Rel] at hij
    obtain rfl : i = j + 1 := hij.symm
    rw [Functor.mapHomologicalComplex_obj_d,
      show (cechEngineComplex 𝒰 V).d (j + 1) j = cechEngineD 𝒰 V j from ChainComplex.of_d _ _ _ j]
    exact cechFreeEvalEngine_comm 𝒰 V j)

/-! ## Project-local Mathlib supplement — positive-degree acyclicity of the engine complex

When `I₁(V) ≠ ∅` (witnessed by `i_fix`), the engine complex is exact in every positive degree.
This is the homology-vanishing input (transported across `cechFreeEvalEngineIso`) to the nonempty
case of the free Čech quasi-isomorphism. -/

/-- **Positive-degree exactness of the engine complex.** When `I₁(V)` is nonempty (witnessed by
`i_fix`), `cechEngineComplex 𝒰 V` is exact at every positive degree `n + 1`, from the
contracting-homotopy exactness `cechEngineD_exact` via `ModuleCat.shortComplex_exact`. -/
lemma cechEngineComplex_exactAt (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) (n : ℕ) :
    (cechEngineComplex 𝒰 V).ExactAt (n + 1) := by
  rw [HomologicalComplex.exactAt_iff' _ (n + 2) (n + 1) n (by simp [ChainComplex.prev])
    (by simp)]
  apply ModuleCat.shortComplex_exact
  have hf : (cechEngineComplex 𝒰 V).d (n + 2) (n + 1) = cechEngineD 𝒰 V (n + 1) :=
    ChainComplex.of_d _ _ _ (n + 1)
  have hg : (cechEngineComplex 𝒰 V).d (n + 1) n = cechEngineD 𝒰 V n := ChainComplex.of_d _ _ _ n
  change Function.Exact ⇑(ConcreteCategory.hom ((cechEngineComplex 𝒰 V).d (n + 2) (n + 1)))
    ⇑(ConcreteCategory.hom ((cechEngineComplex 𝒰 V).d (n + 1) n))
  rw [hf, hg]
  exact cechEngineD_exact 𝒰 V i_fix n

/-! ## Project-local Mathlib supplement — augmentation of the engine complex

The engine complex augments onto its degree-`0` coefficient `O_X(V)` via the codiagonal of the
constant summands.  Together with the positive-degree acyclicity `cechEngineComplex_exactAt` and the
degree-`0` contracting identity this exhibits `cechEngineComplex 𝒰 V` as a resolution of `O_X(V)`
in the nonempty case — the engine-side input to `cechFreeEval_quasiIso_of_nonempty`. -/

/-- **Degree-`0` augmentation of the engine complex**: the codiagonal `∐_{σ : Fin 1 → I₁(V)} O_X(V)
⟶ O_X(V)` sending every summand by the identity. -/
noncomputable def cechEngineAug0 (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) :
    cechEngineX 𝒰 V 0 ⟶ coverSectionModule V :=
  Limits.Sigma.desc fun _ => 𝟙 (coverSectionModule V)

/-- Action of the degree-`0` engine augmentation on an injection: `ι_σ ≫ aug = 𝟙`. -/
lemma cechEngineAug0_ι (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (σ : Fin 1 → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) :
    Limits.Sigma.ι _ σ ≫ cechEngineAug0 𝒰 V = 𝟙 (coverSectionModule V) := by
  simp only [cechEngineAug0, Limits.Sigma.ι_desc]

/-- The degree-`0` engine differential composed with the augmentation vanishes: the alternating
face sum `δ₀ − δ₁` is killed because both faces become the identity after augmenting.  The
cochain-map condition for the engine augmentation `cechEngineComplexAug`. -/
lemma cechEngineD_comp_aug (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) :
    cechEngineD 𝒰 V 0 ≫ cechEngineAug0 𝒰 V = 0 := by
  apply Limits.Sigma.hom_ext
  intro σ
  rw [Limits.comp_zero, ← Category.assoc, cechEngineD_ι, Preadditive.sum_comp, Fin.sum_univ_two]
  simp only [Preadditive.zsmul_comp]
  erw [cechEngineAug0_ι, cechEngineAug0_ι]
  simp only [Fin.val_zero, Fin.val_one, pow_zero, pow_one, one_zsmul, neg_one_zsmul]
  abel

/-- **The augmentation chain map** `cechEngineComplex 𝒰 V ⟶ O_X(V)[0]`, whose degree-`0` component
is the codiagonal `cechEngineAug0`.  The chain-map condition is `cechEngineD_comp_aug`. -/
noncomputable def cechEngineComplexAug (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) :
    cechEngineComplex 𝒰 V ⟶ (ChainComplex.single₀ _).obj (coverSectionModule V) :=
  ((cechEngineComplex 𝒰 V).toSingle₀Equiv (coverSectionModule V)).symm
    ⟨cechEngineAug0 𝒰 V, by
      rw [show (cechEngineComplex 𝒰 V).d 1 0 = cechEngineD 𝒰 V 0 from ChainComplex.of_d _ _ _ 0]
      exact cechEngineD_comp_aug 𝒰 V⟩

/-! ## Project-local Mathlib supplement — degree-`0` splitting and engine quasi-isomorphism -/

/-- **Degree-`0` contracting identity of the augmented engine complex.** Fixing
`i_fix ∈ I₁(V)`, the prepend map `s := cechEnginePrepend 0`, the differential `d := cechEngineD 0`,
the augmentation `g := cechEngineAug0` and the section `r := ι_{(fun _ => i_fix)}` of `g` satisfy
`s ≫ d + g ≫ r = 𝟙`.  Together with `r ≫ g = 𝟙` this exhibits `g` as the cokernel of `d` (and the
augmented complex `C₁ → C₀ → O_X(V)` as exact at `C₀`), the degree-`0` input to the engine
quasi-isomorphism. -/
lemma cechEngineAug0_split (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) :
    cechEnginePrepend 𝒰 V i_fix 0 ≫ cechEngineD 𝒰 V 0
      + cechEngineAug0 𝒰 V ≫ Limits.Sigma.ι
          (fun _ : Fin 1 → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} => coverSectionModule V)
          (fun _ => i_fix)
      = 𝟙 (cechEngineX 𝒰 V 0) := by
  apply Limits.Sigma.hom_ext
  intro σ
  rw [Preadditive.comp_add, Category.comp_id]
  rw [← Category.assoc, cechEnginePrepend_ι, cechEngineD_ι]
  rw [← Category.assoc, cechEngineAug0_ι, Category.id_comp]
  rw [Fin.sum_univ_two]
  have e0 : (Fin.cons i_fix σ : Fin 2 → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i})
      ∘ (0 : Fin 2).succAbove = σ := by funext k; simp
  have e1 : (Fin.cons i_fix σ : Fin 2 → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i})
      ∘ (1 : Fin 2).succAbove = (fun _ => i_fix) := by
    funext k; fin_cases k; simp
  rw [e0, e1]
  simp only [Fin.val_zero, Fin.val_one, pow_zero, pow_one, one_zsmul, neg_one_zsmul]
  abel

/-- The degree-`0` component of the engine augmentation chain map is the codiagonal
`cechEngineAug0`. -/
lemma cechEngineComplexAug_f_zero (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) :
    (cechEngineComplexAug 𝒰 V).f 0 = cechEngineAug0 𝒰 V := by
  rw [cechEngineComplexAug, ChainComplex.toSingle₀Equiv_symm_apply_f_zero]

/-- **The engine augmentation is a quasi-isomorphism** (nonempty case).  When `I₁(V)` is nonempty
(witnessed by `i_fix`), `cechEngineComplexAug 𝒰 V : cechEngineComplex 𝒰 V ⟶ O_X(V)[0]` is a
quasi-isomorphism: positive-degree exactness comes from the contracting homotopy
(`cechEngineComplex_exactAt`), and degree `0` from the splitting `cechEngineAug0_split` exhibiting
`cechEngineAug0` as the cokernel of the degree-`0` differential. -/
lemma cechEngineComplexAug_quasiIso (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) :
    QuasiIso (cechEngineComplexAug 𝒰 V) := by
  rw [quasiIso_iff]
  rintro (_ | n)
  · rw [ChainComplex.quasiIsoAt₀_iff]
    have hg₁ : ((HomologicalComplex.shortComplexFunctor'
        (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V))) (ComplexShape.down ℕ)
        1 0 0).obj (cechEngineComplex 𝒰 V)).g = 0 := rfl
    have hf₂ : ((HomologicalComplex.shortComplexFunctor'
        (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V))) (ComplexShape.down ℕ)
        1 0 0).obj ((ChainComplex.single₀ (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V)))).obj
          (coverSectionModule V))).f = 0 := rfl
    have hg₂ : ((HomologicalComplex.shortComplexFunctor'
        (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V))) (ComplexShape.down ℕ)
        1 0 0).obj ((ChainComplex.single₀ (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V)))).obj
          (coverSectionModule V))).g = 0 := rfl
    refine (ShortComplex.quasiIso_iff_isIso_descOpcycles _ hg₁ hf₂ hg₂).mpr ?_
    set S := (HomologicalComplex.shortComplexFunctor'
      (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V))) (ComplexShape.down ℕ) 1 0 0).obj
      (cechEngineComplex 𝒰 V) with hSdef
    change IsIso (S.descOpcycles _ _)
    have hτ : ((HomologicalComplex.shortComplexFunctor'
        (ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V))) (ComplexShape.down ℕ)
        1 0 0).map (cechEngineComplexAug 𝒰 V)).τ₂ = cechEngineAug0 𝒰 V :=
      cechEngineComplexAug_f_zero 𝒰 V
    have hSf : S.f = cechEngineD 𝒰 V 0 := by
      change (cechEngineComplex 𝒰 V).d 1 0 = cechEngineD 𝒰 V 0
      exact ChainComplex.of_d (cechEngineX 𝒰 V) (cechEngineD 𝒰 V) (cechEngineD_comp 𝒰 V) 0
    have hsplit := cechEngineAug0_split 𝒰 V i_fix
    refine ⟨⟨Limits.Sigma.ι
      (fun _ : Fin 1 → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} => coverSectionModule V)
      (fun _ => i_fix) ≫ S.pOpcycles, ?_, ?_⟩⟩
    · rw [← cancel_epi S.pOpcycles, Category.comp_id, ← Category.assoc]
      erw [S.p_descOpcycles]
      rw [hτ, ← Category.assoc]
      have hfp : cechEngineD 𝒰 V 0 ≫ S.pOpcycles = 0 := hSf ▸ S.f_pOpcycles
      have hkey : (cechEnginePrepend 𝒰 V i_fix 0 ≫ cechEngineD 𝒰 V 0) ≫ S.pOpcycles = 0 := by
        rw [Category.assoc, hfp, Limits.comp_zero]
      have h3 : (cechEnginePrepend 𝒰 V i_fix 0 ≫ cechEngineD 𝒰 V 0
            + cechEngineAug0 𝒰 V ≫ Limits.Sigma.ι
              (fun _ : Fin 1 → {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i} => coverSectionModule V)
              (fun _ => i_fix)) ≫ S.pOpcycles
          = 𝟙 (cechEngineX 𝒰 V 0) ≫ S.pOpcycles := by rw [hsplit]
      rwa [Preadditive.add_comp, hkey, zero_add, Category.id_comp] at h3
    · rw [Category.assoc]
      erw [S.p_descOpcycles]
      rw [hτ]
      exact cechEngineAug0_ι 𝒰 V (fun _ => i_fix)
  · rw [quasiIsoAt_iff_exactAt' _ _ (ChainComplex.exactAt_succ_single_obj _ n)]
    exact cechEngineComplex_exactAt 𝒰 V i_fix n

/-! ## Project-local Mathlib supplement — free Čech quasi-isomorphism (nonempty case + assembly) -/

/-- **Degree-`0` augmentation comm-square (engine identification).** Evaluating the free Čech
augmentation `cechFreeAug` at `V` and the engine codiagonal `cechEngineAug0` agree under the
degree-`0` object identification `cechFreeEvalEngine_X`.  This is the degree-`0` analogue of
`cechFreeEvalEngine_comm` and the key bridge for the nonempty quasi-isomorphism: it identifies the
evaluated free augmentation with the engine augmentation. -/
private lemma cechFreeAug_eval_eq (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (V : TopologicalSpace.Opens ↥X) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map (cechFreeAug 𝒰)
      = (cechFreeEvalEngine_X 𝒰 V 0).hom ≫ cechEngineAug0 𝒰 V := by
  refine (cancel_epi (cechFreeEval_X 𝒰 (Opposite.op V) 0).inv).mp ?_
  apply Limits.Sigma.hom_ext
  intro σ
  by_cases hσ : V ≤ coverInterOpen 𝒰 σ
  · have hsd : Limits.Sigma.ι
          (fun σ : Fin (0 + 1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)) σ ≫ cechFreeAug 𝒰
        = freeYonedaAug (coverInterOpen 𝒰 σ) := by
      simp only [cechFreeAug, Limits.Sigma.ι_desc]
    rw [reassoc_of% (cechFreeEval_X_ι_inv 𝒰 V 0 σ)]
    erw [← Functor.map_comp, hsd, PresheafOfModules.evaluation_map,
        ← freeYonedaEval_iso_of_le_hom_eq_aug hσ]
    erw [reassoc_of% (cechFreeEvalEngine_X_inv_hom_ι 𝒰 V 0 σ hσ)]
    erw [cechEngineAug0_ι]
    exact (Category.comp_id _).symm
  · exact (freeYonedaEval_isZero_of_not_le hσ).eq_of_src _ _

end AlgebraicGeometry

