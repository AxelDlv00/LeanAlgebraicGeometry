/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.CechAcyclic
import AlgebraicJacobian.Cohomology.FreePresheafComplex

/-!
# Sub-brick A: identifying the evaluated augmented Čech section complex
  (blueprint `lem:cech_backbone_left_sigma` … `lem:cechSection_contractible`)

This file is the shared "Sub-brick A" chain that

1. identifies the degree-`p` Čech-nerve backbone `(coverCechNerveOver 𝒰).obj [p]` with
   the coproduct `∐_σ Over.mk j_σ` in `Over X` (`cechBackbone_left_sigma`);
2. decomposes the push-pull object `pushPullObj F Y_p` as a product in `X.Modules`
   (`pushPull_sigma_iso`) — the single new-infra leaf;
3. identifies the sections of each leg over an open `V` with `Γ(U_σ ∩ V, F)`
   (`pushPull_leg_sections`);
4. assembles the degreewise section isomorphism `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(U_σ ∩ V, F)`
   (`pushPull_eval_prod_iso`);
5. promotes these degreewise isos to a complex isomorphism
   `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`
   (`cechSection_complex_iso`); and
6. produces the contracting homotopy on the augmented concrete complex whenever
   `V ≤ coverOpen 𝒰 i_fix` (`cechSection_contractible`).

The result is consumed by `CechAugmentedResolution.lean` to close the residual `hSec`.

Blueprint: §Sub-brick A decomposition, `Cohomology_CechHigherDirectImage.tex`,
lemmas `lem:cech_backbone_left_sigma` through `lem:cechSection_contractible`.
-/

universe u

open CategoryTheory Limits Opposite

/-! ## Project-local Mathlib supplement — abstract wide-fibre-power ↔ slice-product

These `CategoryTheory`-namespace declarations are the abstract categorical core of the Stub-1
geometric backbone decomposition (`cechBackbone_left_sigma`).  They are stated for an arbitrary
category (and, downstream, an arbitrary `FinitaryPreExtensive` category) and instantiated at
`Scheme` only at the assembly site, so they are reusable and Mathlib-aligned.
-/

namespace CategoryTheory

/-- The wide pullback over `S` of a family `(g k : Z k ⟶ S)`, viewed in `Over S`, is a limit fan of
the legs `Over.mk (g k)`: i.e. the wide fibre power over `S` is the product of the legs in the slice
`Over S`.  Project-local: Mathlib has `WidePullbackCone.isLimitOfFan` (wide pullback over a terminal
base = product of legs) but not this direct slice-product identification of the fibre power. -/
noncomputable def widePullback_overX_isLimit {C : Type*} [Category C] {S : C}
    {ι : Type*} {Z : ι → C} (g : (k : ι) → Z k ⟶ S) [HasWidePullback S Z g] :
    IsLimit (Fan.mk (C := Over S) (f := fun k => Over.mk (g k))
      (Over.mk (WidePullback.base g))
      (fun k => Over.homMk (WidePullback.π g k) (WidePullback.π_arrow g k))) :=
  mkFanLimit _
    (fun s => Over.homMk
      (WidePullback.lift s.pt.hom (fun k => (s.proj k).left) (fun k => Over.w (s.proj k)))
      (WidePullback.lift_base _ _ _ _))
    (fun s k => by
      apply Over.OverMorphism.ext
      change (WidePullback.lift _ _ _ ≫ WidePullback.π g k) = (s.proj k).left
      exact WidePullback.lift_π _ _ _ _ _)
    (fun s m hm => by
      apply Over.OverMorphism.ext
      change m.left = WidePullback.lift _ _ _
      apply WidePullback.hom_ext
      · intro k
        rw [WidePullback.lift_π]
        exact congrArg CommaMorphism.left (hm k)
      · rw [WidePullback.lift_base]
        exact Over.w m)

/-- The wide fibre power over `S` is the iterated product in the slice: in `Over S` the object
`Over.mk (WidePullback.base g)` carrying the wide pullback over `S` is the product
`∏ᶜ fun k => Over.mk (g k)` of the legs.  Project-local foundational step of the Stub-1 backbone
decomposition (blueprint `lem:widePullback_overX_eq_prod`). -/
noncomputable def widePullback_overX_eq_prod {C : Type*} [Category C] {S : C}
    {ι : Type*} {Z : ι → C} (g : (k : ι) → Z k ⟶ S) [HasWidePullback S Z g]
    [HasProduct (fun k => Over.mk (g k))] :
    Over.mk (WidePullback.base g) ≅ ∏ᶜ fun k => Over.mk (g k) :=
  (widePullback_overX_isLimit g).conePointUniqueUpToIso (productIsProduct _)

/-- The cofan exhibiting `Over.mk (Sigma.desc f)` as the coproduct of the legs `Over.mk (f i)` in
`Over S`.  Abstract version of `AlgebraicGeometry.coverArrowOverCofan`. -/
noncomputable def overSigmaDescCofan {C : Type*} [Category C] {S : C} {ι : Type*}
    {Z : ι → C} (f : (i : ι) → Z i ⟶ S) [HasCoproduct Z] :
    Cofan (fun i => Over.mk (f i)) :=
  Cofan.mk (Over.mk (Limits.Sigma.desc f))
    (fun i => Over.homMk (Limits.Sigma.ι Z i) (by simp [Limits.Sigma.ι_desc]))

/-- `overSigmaDescCofan` is a colimit: in `Over S` the object `Over.mk (Sigma.desc f)` is the
coproduct of the legs `Over.mk (f i)`.  Abstract version of
`AlgebraicGeometry.coverArrowOverIsColimit`. -/
noncomputable def overSigmaDescIsColimit {C : Type*} [Category C] {S : C} {ι : Type*}
    {Z : ι → C} (f : (i : ι) → Z i ⟶ S) [HasCoproduct Z] :
    IsColimit (overSigmaDescCofan f) := by
  haveI : HasCoproduct (fun i => (Over.mk (f i)).left) := (inferInstanceAs (HasCoproduct Z))
  refine mkCofanColimit _
    (fun t => Over.homMk (Limits.Sigma.desc (fun i => (t.inj i).left)) ?_)
    (fun t j => ?_) (fun t m hm => ?_)
  · change Limits.Sigma.desc (fun i => (t.inj i).left) ≫ t.pt.hom = Limits.Sigma.desc f
    refine Limits.Sigma.hom_ext _ _ (fun i => ?_)
    rw [Limits.Sigma.ι_desc_assoc, Over.w]
    exact (Limits.Sigma.ι_desc f i).symm
  · apply Over.OverMorphism.ext
    simp [overSigmaDescCofan, Limits.Sigma.ι_desc]
  · apply Over.OverMorphism.ext
    refine Limits.Sigma.hom_ext _ _ (fun i => ?_)
    have h := congrArg CommaMorphism.left (hm i)
    simp only [overSigmaDescCofan, Cofan.inj, Cofan.mk,
      Discrete.natTrans_app, Over.homMk_left, Limits.Sigma.ι_desc] at h ⊢
    exact h

/-- In `Over S`, the object `Over.mk (Sigma.desc f)` carrying the descent map is the coproduct of
the legs `Over.mk (f i)`.  Abstract version of `AlgebraicGeometry.coverArrowOverSigmaIso`; used to
rewrite the inner `∐ᵢ Z i` of the Stub-1 fibre power inside the slice. -/
noncomputable def overSigmaDescIso {C : Type*} [Category C] {S : C} {ι : Type*}
    {Z : ι → C} (f : (i : ι) → Z i ⟶ S) [HasCoproduct Z]
    [HasCoproduct (fun i => Over.mk (f i))] :
    (∐ fun i => Over.mk (f i)) ≅ Over.mk (Limits.Sigma.desc f) :=
  (coproductIsCoproduct _).coconePointUniqueUpToIso (overSigmaDescIsColimit f)

namespace FinitaryPreExtensive

/-- Splitting a finite product off its head: `∏ᶜ X ≅ X 0 ⨯ ∏ᶜ (fun i => X i.succ)` for
`X : Fin (n+1) → C`.  Built directly as a limit fan (`mkFanLimit`) — Mathlib has no `Fin`-succ
categorical product split.  This is the recursion that lets the wide fibre power
`∏ᶜ (Fin(p+2) copies)` be peeled into `head ×_S ∏ᶜ (Fin(p+1) copies)` in the slice during the
induction of `widePullback_coproduct_iso`.  Project-local. -/
noncomputable def prodFinSuccIso {C : Type*} [Category C] [HasFiniteProducts C] {n : ℕ}
    (X : Fin (n + 1) → C) :
    (∏ᶜ X) ≅ X 0 ⨯ (∏ᶜ fun i : Fin n => X i.succ) := by
  refine (productIsProduct X).conePointUniqueUpToIso (mkFanLimit
    (Fan.mk (X 0 ⨯ (∏ᶜ fun i : Fin n => X i.succ))
      (fun j => Fin.cases prod.fst (fun i => prod.snd ≫ Pi.π (fun i : Fin n => X i.succ) i) j))
    (fun s => prod.lift (s.proj 0) (Pi.lift (fun i : Fin n => s.proj i.succ)))
    (fun s j => ?_) (fun s m hm => ?_))
  · refine Fin.cases ?_ ?_ j
    · change prod.lift (s.proj 0) _ ≫ prod.fst = s.proj 0
      rw [prod.lift_fst]
    · intro i
      change prod.lift _ _ ≫ (prod.snd ≫ Pi.π (fun i : Fin n => X i.succ) i) = s.proj i.succ
      rw [← Category.assoc, prod.lift_snd, Pi.lift_π]
  · apply prod.hom_ext
    · rw [prod.lift_fst]
      have := hm 0; change m ≫ prod.fst = s.proj 0 at this; exact this
    · rw [prod.lift_snd]
      apply Pi.hom_ext; intro i
      rw [Pi.lift_π]
      have := hm i.succ
      change m ≫ (prod.snd ≫ Pi.π (fun i : Fin n => X i.succ) i) = s.proj i.succ at this
      rw [← Category.assoc] at this; exact this

/-- One-sided distributivity of the fibre product over a coproduct in `C`:
`∐ᵢ (A ×_S Y i) ≅ A ×_S (∐ᵢ Y i)`.  Derived from `isIso_sigmaDesc_fst` (universality of finite
coproducts in a finitary pre-extensive category) by pulling the coproduct injections back along the
second projection of `A ×_S ∐Y` (pasting via `pullbackLeftPullbackSndIso`).  Blueprint
`lem:prod_coproduct_distrib` (the `C`-level fibre-product form of the one-sided distributivity used
in the induction of `widePullback_coproduct_iso`). -/
noncomputable def prod_coproduct_distrib {C : Type*} [Category C] [HasPullbacks C]
    [FinitaryPreExtensive C] {ι : Type} [Finite ι] {S : C} (A : C) (a : A ⟶ S)
    {Y : ι → C} (g : (i : ι) → Y i ⟶ S) :
    (∐ fun i => pullback a (g i)) ≅ pullback a (Limits.Sigma.desc g) := by
  have hπ : IsIso (Limits.Sigma.desc (Limits.Sigma.ι Y)) := by
    rw [show Limits.Sigma.desc (Limits.Sigma.ι Y) = 𝟙 _ from
      Limits.Sigma.hom_ext _ _ (fun i => by rw [Limits.Sigma.ι_desc, Category.comp_id])]
    infer_instance
  have key := FinitaryPreExtensive.isIso_sigmaDesc_fst (Limits.Sigma.ι Y)
    (pullback.snd a (Limits.Sigma.desc g)) hπ
  let e : (i : ι) → pullback (pullback.snd a (Limits.Sigma.desc g)) (Limits.Sigma.ι Y i)
      ≅ pullback a (g i) := fun i =>
    pullbackLeftPullbackSndIso a (Limits.Sigma.desc g) (Limits.Sigma.ι Y i) ≪≫
      pullback.congrHom rfl (by rw [Limits.Sigma.ι_desc])
  exact (Limits.Sigma.mapIso e).symm ≪≫ asIso (Limits.Sigma.desc
    (fun i => pullback.fst (pullback.snd a (Limits.Sigma.desc g)) (Limits.Sigma.ι Y i)))

/-- Nested-coproduct flatten + `Fin.cons` reindex: `∐ᵢ ∐_τ F(cons i τ) ≅ ∐_σ F σ` over the
`(p+2)`-fold multi-indices.  Pure reindexing (`sigmaSigmaIso` collapses the nested coproduct; the
`Fin.consEquiv` reindexes the resulting pairs `(i, τ) ↦ Fin.cons i τ`).  Blueprint
`lem:coproduct_fibrePower_reindex`.  The identification of the component `F (Fin.cons i τ)` with the
`(p+2)`-fold fibre power lives in the inductive step that consumes this lemma. -/
noncomputable def coproduct_fibrePower_reindex {C : Type*} [Category C] {ι : Type} [Finite ι]
    [HasFiniteCoproducts C] (p : ℕ) (F : (Fin (p + 2) → ι) → C) :
    (∐ fun i : ι => ∐ fun τ : Fin (p + 1) → ι => F (Fin.cons i τ))
      ≅ ∐ fun σ : Fin (p + 2) → ι => F σ :=
  sigmaSigmaIso (fun _ : ι => (Fin (p + 1) → ι)) (fun i τ => F (Fin.cons i τ)) ≪≫
  Sigma.whiskerEquiv
    ((Equiv.sigmaEquivProd ι (Fin (p + 1) → ι)).trans (Fin.consEquiv (fun _ => ι)))
    (fun _ => Iso.refl _)

/-- Base case of the wide-fibre-power decomposition (`p = 0`): the `1`-fold wide fibre power of the
descent map `∐ᵢ Z i ⟶ S` over `S` is, in `Over S`, the coproduct over `σ : Fin 1 → ι` of the
`1`-fold fibre powers (here written as products in the slice).  Pure reindexing — no extensivity
needed — chaining `widePullback_overX_eq_prod`, `productUniqueIso` (over `Fin 1`), `overSigmaDescIso`
and the coproduct reindex along `(Fin 1 → ι) ≃ ι`.  Blueprint `lem:coproduct_distrib_fibrePower_zero`.

Note: the σ-component is the slice product `∏ᶜ fun k => Over.mk (f (σ k))`, which is identified with
the wide fibre power `Over.mk (WidePullback.base (fun k => f (σ k)))` via `widePullback_overX_eq_prod`
at the assembly site.  This is the project's chosen (slice-product) normal form for the components,
which minimizes the `HasWidePullback` instance bookkeeping in the induction. -/
noncomputable def widePullback_coproduct_iso_zero {C : Type*} [Category C] [HasPullbacks C]
    {S : C} {ι : Type*} [Finite ι] {Z : ι → C} (f : (i : ι) → Z i ⟶ S)
    [HasFiniteWidePullbacks C] [HasFiniteCoproducts C]
    [HasFiniteProducts (Over S)] [HasFiniteCoproducts (Over S)] :
    Over.mk (WidePullback.base (fun _ : Fin 1 => Limits.Sigma.desc f))
      ≅ ∐ (fun σ : Fin 1 → ι => ∏ᶜ (fun k : Fin 1 => Over.mk (f (σ k)))) :=
  widePullback_overX_eq_prod (fun _ : Fin 1 => Limits.Sigma.desc f) ≪≫
  productUniqueIso (fun _ : Fin 1 => Over.mk (Limits.Sigma.desc f)) ≪≫
  (overSigmaDescIso f).symm ≪≫
  Sigma.whiskerEquiv (Equiv.funUnique (Fin 1) ι).symm
    (fun i => productUniqueIso
      (fun k : Fin 1 => Over.mk (f (((Equiv.funUnique (Fin 1) ι).symm i) k))))


/-- One-sided distributivity in `Over S`'s underlying category, coproduct in the FIRST pullback
argument: `∐ᵢ pullback (gᵢ) b ≅ pullback (Sigma.desc g) b`.  Derived from the project's
`prod_coproduct_distrib` (coproduct-second form) by conjugating with `pullbackSymmetry`.
Project-local: consumed by `overProd_coproduct_distrib`'s structure-map compatibility. -/
noncomputable def coprodFirst_distrib {C : Type*} [Category C] [HasPullbacks C] [FinitaryPreExtensive C] {ι : Type} [Finite ι] {S : C}
    (B : C) (b : B ⟶ S) {Y : ι → C} (g : (i : ι) → Y i ⟶ S) :
    (∐ fun i => pullback (g i) b) ≅ pullback (Limits.Sigma.desc g) b :=
  asIso (Limits.Sigma.map (fun i => (pullbackSymmetry (g i) b).hom)) ≪≫
    prod_coproduct_distrib B b g ≪≫ pullbackSymmetry b (Limits.Sigma.desc g)


/-- `prod_coproduct_distrib` is compatible with the first projection to the base of `a`:
its hom followed by `pullback.fst` is the descent of the per-summand `pullback.fst`. Project-local
compatibility lemma used to verify the structure-map condition of `overProd_coproduct_distrib`. -/
lemma pcd_hom_fst {C : Type*} [Category C] [HasPullbacks C] [FinitaryPreExtensive C] {ι : Type} [Finite ι] {S : C} (A : C) (a : A ⟶ S) {Y : ι → C} (g : (i : ι) → Y i ⟶ S) :
    (prod_coproduct_distrib A a g).hom ≫ pullback.fst a (Limits.Sigma.desc g)
      = Limits.Sigma.desc (fun i => pullback.fst a (g i)) := by
  refine Limits.Sigma.hom_ext _ _ (fun i => ?_)
  rw [Limits.Sigma.ι_desc]
  have hstep : (prod_coproduct_distrib A a g).hom
      = (Limits.Sigma.map (fun i => (pullbackLeftPullbackSndIso a (Limits.Sigma.desc g) (Sigma.ι Y i) ≪≫
            pullback.congrHom rfl (by rw [Limits.Sigma.ι_desc])).inv)) ≫
          Limits.Sigma.desc (fun i => pullback.fst (pullback.snd a (Limits.Sigma.desc g)) (Sigma.ι Y i)) := by
    simp only [prod_coproduct_distrib, Iso.trans_hom, Iso.symm_hom, asIso_hom]
    congr 1
  rw [hstep]
  simp only [Category.assoc, Limits.Sigma.ι_map_assoc, Limits.Sigma.ι_desc_assoc]
  simp
  simp only [pullback.map]
  rw [pullback.lift_fst]
  simp

/-- `prod_coproduct_distrib` compatibility with the second projection (the coproduct side):
its hom followed by `pullback.snd` descends to the per-summand `pullback.snd ≫ Sigma.ι`.
Project-local compatibility lemma for `overProd_coproduct_distrib`. -/
lemma pcd_hom_snd {C : Type*} [Category C] [HasPullbacks C] [FinitaryPreExtensive C] {ι : Type} [Finite ι] {S : C} (A : C) (a : A ⟶ S) {Y : ι → C} (g : (i : ι) → Y i ⟶ S) :
    (prod_coproduct_distrib A a g).hom ≫ pullback.snd a (Limits.Sigma.desc g)
      = Limits.Sigma.desc (fun i => pullback.snd a (g i) ≫ Sigma.ι Y i) := by
  refine Limits.Sigma.hom_ext _ _ (fun i => ?_)
  rw [Limits.Sigma.ι_desc]
  have hstep : (prod_coproduct_distrib A a g).hom
      = (Limits.Sigma.map (fun i => (pullbackLeftPullbackSndIso a (Limits.Sigma.desc g) (Sigma.ι Y i) ≪≫
            pullback.congrHom rfl (by rw [Limits.Sigma.ι_desc])).inv)) ≫
          Limits.Sigma.desc (fun i => pullback.fst (pullback.snd a (Limits.Sigma.desc g)) (Sigma.ι Y i)) := by
    simp only [prod_coproduct_distrib, Iso.trans_hom, Iso.symm_hom, asIso_hom]
    congr 1
  rw [hstep]
  simp only [Category.assoc, Limits.Sigma.ι_map_assoc, Limits.Sigma.ι_desc_assoc]
  rw [pullback.condition]
  simp
  simp only [pullback.map]
  rw [pullback.lift_snd_assoc]
  simp

/-- `coprodFirst_distrib` compatibility with `pullback.fst` (the coproduct side): descends to the
per-summand `pullback.fst ≫ Sigma.ι`.  Project-local, used in `overProd_coproduct_distrib`. -/
lemma cf_hom_fst {C : Type*} [Category C] [HasPullbacks C] [FinitaryPreExtensive C] {ι : Type} [Finite ι] {S : C} (B : C) (b : B ⟶ S) {Y : ι → C} (g : (i : ι) → Y i ⟶ S) :
    (coprodFirst_distrib B b g).hom ≫ pullback.fst (Limits.Sigma.desc g) b
      = Limits.Sigma.desc (fun i => pullback.fst (g i) b ≫ Sigma.ι Y i) := by
  rw [coprodFirst_distrib]
  simp only [Iso.trans_hom, asIso_hom, Category.assoc]
  rw [pullbackSymmetry_hom_comp_fst, pcd_hom_snd]
  refine Limits.Sigma.hom_ext _ _ (fun j => ?_)
  rw [← Category.assoc, Limits.Sigma.ι_map, Category.assoc, Limits.Sigma.ι_desc,
    ← Category.assoc, pullbackSymmetry_hom_comp_snd, Limits.Sigma.ι_desc]

private lemma overSigma_hom_eq {C : Type*} [Category C] [HasPullbacks C] {S : C} {ι : Type} [Finite ι] [HasFiniteCoproducts C]
    (A : ι → Over S) :
    (∐ A).hom = (PreservesCoproduct.iso (Over.forget S) A).hom ≫
      Limits.Sigma.desc (fun i => (A i).hom) := by
  haveI : HasColimit (Discrete.functor A ⋙ Over.forget S) :=
    hasColimit_of_iso (F := Discrete.functor (fun i => (A i).left))
      (Discrete.natIso (fun i => Iso.refl _))
  refine (PreservesCoproduct.iso (Over.forget S) A).inv_comp_eq.mp ?_
  rw [PreservesCoproduct.inv_hom]
  refine Limits.Sigma.hom_ext _ _ (fun i => ?_)
  rw [ι_comp_sigmaComparison_assoc]
  show (Sigma.ι A i).left ≫ (∐ A).hom = _
  rw [Limits.Sigma.ι_desc]
  exact Over.w (Sigma.ι A i)

/-- One-sided distributivity of the binary product over a finite coproduct in the slice category
`Over S` of a finitary pre-extensive category: `(∐ᵢ Aᵢ) ⨯ B ≅ ∐ᵢ (Aᵢ ⨯ B)`.  Built via
`Over.isoMk` from the `C`-level `prod_coproduct_distrib`, threading `Over.prodLeftIsoPullback`
and the coproduct-preservation of `Over.forget`.  This is the slice-product distributivity the
inductive step of `widePullback_coproduct_iso` consumes (blueprint `lem:overProd_coproduct_distrib`). -/
noncomputable def overProd_coproduct_distrib {C : Type*} [Category C] [HasPullbacks C] [FinitaryPreExtensive C] {ι : Type} [Finite ι] [HasFiniteCoproducts C]
    {S : C} [HasBinaryProducts (Over S)] (A : ι → Over S) (B : Over S) :
    (∐ A) ⨯ B ≅ ∐ fun i => A i ⨯ B := by
  set pA := PreservesCoproduct.iso (Over.forget S) A with hpA
  set pAB := PreservesCoproduct.iso (Over.forget S) (fun i => A i ⨯ B) with hpAB
  have hA : (∐ A).hom = pA.hom ≫ Limits.Sigma.desc (fun i => (A i).hom) := overSigma_hom_eq A
  have hAB : (∐ fun i => A i ⨯ B).hom
      = pAB.hom ≫ Limits.Sigma.desc (fun i => (A i ⨯ B).hom) := overSigma_hom_eq (fun i => A i ⨯ B)
  clear_value pA pAB
  have hAB' : pAB.inv ≫ (∐ fun i => A i ⨯ B).hom
      = Limits.Sigma.desc (fun i => (A i ⨯ B).hom) := by
    rw [hAB]; simp
  have hcond : (∐ A).hom ≫ 𝟙 S = pA.hom ≫ Limits.Sigma.desc (fun i => (A i).hom) := by
    rw [Category.comp_id]; exact hA
  refine Over.isoMk (Over.prodLeftIsoPullback (∐ A) B ≪≫
    asIso (pullback.map (∐ A).hom B.hom (Limits.Sigma.desc (fun i => (A i).hom)) B.hom
      pA.hom (𝟙 B.left) (𝟙 S) hcond (by simp)) ≪≫
    (coprodFirst_distrib B.left B.hom (fun i => (A i).hom)).symm ≪≫
    asIso (Limits.Sigma.map (fun i => (Over.prodLeftIsoPullback (A i) B).inv)) ≪≫
    pAB.symm) ?_
  show _ ≫ (∐ fun i => A i ⨯ B).hom = ((∐ A) ⨯ B).hom
  have hR : ((∐ A) ⨯ B).hom
      = (Over.prodLeftIsoPullback (∐ A) B).hom ≫ pullback.fst (∐ A).hom B.hom ≫ (∐ A).hom := by
    rw [← Over.w (prod.fst (X := ∐ A) (Y := B)), ← Over.prodLeftIsoPullback_hom_fst, Category.assoc]
  have e3eq : (coprodFirst_distrib B.left B.hom (fun i => (A i).hom)).inv ≫
      Limits.Sigma.desc (fun i => pullback.fst (A i).hom B.hom ≫ (A i).hom)
      = pullback.fst (Limits.Sigma.desc (fun i => (A i).hom)) B.hom ≫
          Limits.Sigma.desc (fun i => (A i).hom) := by
    rw [Iso.inv_comp_eq, ← Category.assoc, cf_hom_fst]
    refine Limits.Sigma.hom_ext _ _ (fun i => ?_)
    simp only [Limits.Sigma.ι_desc, Limits.Sigma.ι_desc_assoc, Category.assoc]
  have e4eq : Limits.Sigma.map (fun i => (Over.prodLeftIsoPullback (A i) B).inv) ≫
        Limits.Sigma.desc (fun i => (A i ⨯ B).hom)
        = Limits.Sigma.desc (fun i => pullback.fst (A i).hom B.hom ≫ (A i).hom) := by
    refine Limits.Sigma.hom_ext _ _ (fun i => ?_)
    rw [← Category.assoc, Limits.Sigma.ι_map, Category.assoc, Limits.Sigma.ι_desc,
      Limits.Sigma.ι_desc, ← Over.w (prod.fst (X := A i) (Y := B)),
      ← Over.prodLeftIsoPullback_inv_fst_assoc]
  rw [hR]
  simp only [Iso.trans_hom, asIso_hom, Category.assoc]
  simp only [Iso.symm_hom]
  erw [hAB']
  rw [e4eq, e3eq]
  congr 1
  rw [← Category.assoc]
  simp only [pullback.map]
  rw [pullback.lift_fst, Category.assoc]
  exact congrArg _ hA.symm


/-- Right-handed one-sided distributivity in `Over S`: `A ⨯ (∐ᵢ Yᵢ) ≅ ∐ᵢ (A ⨯ Yᵢ)`. -/
noncomputable def overProd_coproduct_distrib_right {C : Type*} [Category C] [HasPullbacks C]
    [FinitaryPreExtensive C] {ι : Type} [Finite ι] [HasFiniteCoproducts C]
    {S : C} [HasBinaryProducts (Over S)] (A : Over S) (Y : ι → Over S) :
    A ⨯ (∐ Y) ≅ ∐ fun i => A ⨯ Y i :=
  Limits.prod.braiding A (∐ Y) ≪≫ overProd_coproduct_distrib Y A ≪≫
    Limits.Sigma.mapIso (fun i => Limits.prod.braiding (Y i) A)

-- The inductive step chains six iso layers (`widePullback_overX_eq_prod`, `prodFinSuccIso`,
-- two distributivity isos, the reindex), whose combined `whnf` over the nested fibre powers
-- exceeds the default heartbeat budget.
set_option maxHeartbeats 1600000 in
/-- Coproduct distributes over the `(p+1)`-fold wide fibre power of the cover map `∐ᵢ Zᵢ ⟶ S`,
in slice-product normal form (blueprint `lem:coproduct_distrib_fibrePower`). -/
noncomputable def widePullback_coproduct_iso {C : Type*} [Category C] [HasPullbacks C]
    [FinitaryPreExtensive C] {S : C} {ι : Type} [Finite ι] {Z : ι → C}
    (f : (i : ι) → Z i ⟶ S) [HasFiniteWidePullbacks C] [HasFiniteCoproducts C]
    [HasFiniteProducts (Over S)] [HasFiniteCoproducts (Over S)] :
    (p : ℕ) → (Over.mk (WidePullback.base (fun _ : Fin (p + 1) => Limits.Sigma.desc f))
      ≅ ∐ (fun σ : Fin (p + 1) → ι => ∏ᶜ (fun k : Fin (p + 1) => Over.mk (f (σ k)))))
  | 0 => widePullback_coproduct_iso_zero f
  | (p+1) => by
      refine widePullback_overX_eq_prod (fun _ : Fin (p + 2) => Limits.Sigma.desc f) ≪≫
        prodFinSuccIso (fun _ : Fin (p + 2) => Over.mk (Limits.Sigma.desc f)) ≪≫ ?_
      refine Limits.prod.mapIso (overSigmaDescIso f).symm
        ((widePullback_overX_eq_prod (fun _ : Fin (p + 1) => Limits.Sigma.desc f)).symm ≪≫
          widePullback_coproduct_iso f p) ≪≫ ?_
      refine overProd_coproduct_distrib (fun i => Over.mk (f i))
        (∐ fun τ : Fin (p + 1) → ι => ∏ᶜ fun k => Over.mk (f (τ k))) ≪≫ ?_
      refine Limits.Sigma.mapIso (fun i => overProd_coproduct_distrib_right (Over.mk (f i))
        (fun τ : Fin (p + 1) → ι => ∏ᶜ fun k => Over.mk (f (τ k)))) ≪≫ ?_
      have e7 := Limits.Sigma.mapIso (fun i => Limits.Sigma.mapIso (fun τ : Fin (p + 1) → ι =>
        (prodFinSuccIso (fun k : Fin (p + 2) => Over.mk (f (Fin.cons i τ k)))).symm))
      exact e7 ≪≫ coproduct_fibrePower_reindex p (fun σ => ∏ᶜ fun k => Over.mk (f (σ k)))

end FinitaryPreExtensive

/-- A coproduct indexed by `Option α` splits off its `none` summand:
`∐ Z ≅ Z none ⨿ (∐ a, Z (some a))`.  Project-local: the coproduct reassociation that drives the
`Option`-step of the finite-index induction in `pushPull_coprod_prod` (Mathlib has `sigmaSigmaIso`
for nested coproducts but no `Option`-split). -/
noncomputable def sigmaOptionIso {C : Type*} [Category C] {α : Type*} (Z : Option α → C)
    [HasCoproduct Z] [HasCoproduct (fun a : α => Z (some a))]
    [HasBinaryCoproduct (Z none) (∐ fun a : α => Z (some a))] :
    (∐ Z) ≅ Z none ⨿ (∐ fun a : α => Z (some a)) where
  hom := Limits.Sigma.desc
    (fun o => Option.rec Limits.coprod.inl
      (fun a => Limits.Sigma.ι (fun a : α => Z (some a)) a ≫ Limits.coprod.inr) o)
  inv := Limits.coprod.desc (Limits.Sigma.ι Z none)
    (Limits.Sigma.desc (fun a => Limits.Sigma.ι Z (some a)))
  hom_inv_id := by
    apply Limits.Sigma.hom_ext
    rintro (_ | a)
    · simp [Limits.Sigma.ι_desc_assoc, Limits.coprod.inl_desc]
    · simp [Limits.Sigma.ι_desc_assoc, Limits.coprod.inr_desc, Limits.Sigma.ι_desc]
  inv_hom_id := by
    apply Limits.coprod.hom_ext
    · simp [Limits.coprod.inl_desc, Limits.Sigma.ι_desc]
    · rw [Category.comp_id]
      apply Limits.Sigma.hom_ext
      intro a
      simp [Limits.coprod.inr_desc, Limits.Sigma.ι_desc_assoc, Limits.Sigma.ι_desc]

end CategoryTheory

namespace AlgebraicGeometry

open Scheme.Modules

variable {X : Scheme.{u}}

/-! ## Project-local Mathlib supplement — Stub 1 geometric backbone

The degree-`p` Čech-nerve backbone `(coverCechNerveOver 𝒰).obj (op [p])` is the `(p+1)`-fold
fibre power of the cover map `q = Sigma.desc 𝒰.f` over `X`.  Identifying it with the coproduct
`∐_σ (coverInterOpen 𝒰 σ)` needs two geometric ingredients that Mathlib provides only in binary
form:

* `widePullback_openImm_inter` — the wide pullback over `X` of a *finite* family of open
  immersions is the intersection of their open ranges (built here from `IsOpenImmersion.lift`
  and the wide-pullback universal property);
* the wide/iterated coproduct-distributes-over-fibre-power step (extensivity), still open.
-/

open TopologicalSpace in
/-- Pointwise membership in a *finite* intersection of opens.  Project-local because Mathlib's
`Opens` infimum is interior-based, so the pointwise `mem_iInf` characterization only holds for
finite families. -/
private lemma mem_iInf_opens_of_finite {Y : Type*} [TopologicalSpace Y] {κ : Type}
    [Finite κ] (f : κ → Opens Y) (x : Y) :
    x ∈ (⨅ i, f i : Opens Y) ↔ ∀ i, x ∈ f i := by
  rw [← SetLike.mem_coe,
    show ((⨅ i, f i : Opens Y) : Set Y) = ⋂ i, (f i : Set Y) from ?_]
  · simp
  · apply le_antisymm
    · exact Set.subset_iInter fun i => SetLike.coe_subset_coe.mpr (iInf_le f i)
    · have hopen : IsOpen (⋂ i, (f i : Set Y)) := isOpen_iInter_of_finite fun i => (f i).2
      have hW : (⟨⋂ i, (f i : Set Y), hopen⟩ : Opens Y) ≤ ⨅ i, f i :=
        le_iInf fun i => by intro y hy; exact Set.mem_iInter.mp hy i
      exact hW

/-- The wide pullback over `X` of a finite family of open immersions `g k : Z k ⟶ X` is the
intersection open `⨅ k, (g k).opensRange`.  Project-local: Mathlib has the binary
`isPullback_opens_inf` but not this wide/iterated form, needed to identify each summand of the
distributed Čech-nerve backbone with a `coverInterOpen`.  (With `g k := 𝒰.f (σ k)` the target
open is exactly `coverInterOpen 𝒰 σ`.) -/
noncomputable def widePullback_openImm_inter {κ : Type} [Finite κ]
    {Z : κ → Scheme.{u}} (g : (k : κ) → Z k ⟶ X) [∀ k, IsOpenImmersion (g k)] :
    widePullback X Z g ≅ (⨅ k, (g k).opensRange).toScheme where
  hom := by
    refine IsOpenImmersion.lift (⨅ k, (g k).opensRange).ι (WidePullback.base g) ?_
    rw [Scheme.Opens.range_ι]
    rintro x ⟨w, rfl⟩
    rw [SetLike.mem_coe, mem_iInf_opens_of_finite]
    intro k
    have hcomp : WidePullback.base g w = (g k) (WidePullback.π g k w) := by
      rw [← Scheme.Hom.comp_apply, WidePullback.π_arrow]
    rw [hcomp, ← SetLike.mem_coe, Scheme.Hom.coe_opensRange]
    exact Set.mem_range_self _
  inv := WidePullback.lift (⨅ k, (g k).opensRange).ι
    (fun k => IsOpenImmersion.lift (g k) (⨅ k, (g k).opensRange).ι (by
      rw [Scheme.Opens.range_ι, ← Scheme.Hom.coe_opensRange]
      exact SetLike.coe_subset_coe.mpr (iInf_le _ k)))
    (fun k => IsOpenImmersion.lift_fac _ _ _)
  hom_inv_id := by
    apply WidePullback.hom_ext g
    · intro j
      rw [Category.assoc, Category.id_comp, WidePullback.lift_π,
        ← cancel_mono (g j), Category.assoc, IsOpenImmersion.lift_fac,
        IsOpenImmersion.lift_fac, WidePullback.π_arrow]
    · rw [Category.assoc, Category.id_comp, WidePullback.lift_base, IsOpenImmersion.lift_fac]
  inv_hom_id := by
    rw [← cancel_mono (⨅ k, (g k).opensRange).ι, Category.assoc, Category.id_comp,
      IsOpenImmersion.lift_fac, WidePullback.lift_base]

/-- The cofan exhibiting `Over.mk (Sigma.desc 𝒰.f)` as the coproduct of the member arrows
`Over.mk (𝒰.f i)` in `Over X`.  Project-local: the coproduct cocone of the cover arrow. -/
noncomputable def coverArrowOverCofan (𝒰 : X.OpenCover) :
    Cofan (fun i : 𝒰.I₀ => Over.mk (𝒰.f i)) :=
  Cofan.mk (Over.mk (Sigma.desc 𝒰.f))
    (fun i => Over.homMk (Sigma.ι 𝒰.X i) (by simp [Sigma.ι_desc]))

/-- `coverArrowOverCofan` is a colimit: in `Over X` the cover arrow `Over.mk (Sigma.desc 𝒰.f)`
is the coproduct of the member arrows.  Proved directly from the coproduct universal property in
`Scheme` (each leg is `Over.homMk (Sigma.ι …)`).  Project-local. -/
noncomputable def coverArrowOverIsColimit (𝒰 : X.OpenCover) :
    IsColimit (coverArrowOverCofan 𝒰) := by
  refine mkCofanColimit _
    (fun t => Over.homMk (Sigma.desc (fun i => (t.inj i).left)) ?_)
    (fun t j => ?_) (fun t m hm => ?_)
  · change Sigma.desc (fun i => (t.inj i).left) ≫ t.pt.hom = Sigma.desc 𝒰.f
    refine Sigma.hom_ext _ _ (fun i => ?_)
    rw [Sigma.ι_desc_assoc, Over.w]
    exact (Sigma.ι_desc 𝒰.f i).symm
  · apply Over.OverMorphism.ext
    simp [coverArrowOverCofan, Sigma.ι_desc]
  · apply Over.OverMorphism.ext
    refine Sigma.hom_ext _ _ (fun i => ?_)
    have h := congrArg CommaMorphism.left (hm i)
    simp only [coverArrowOverCofan, Cofan.inj, Cofan.mk,
      Discrete.natTrans_app, Over.homMk_left, Sigma.ι_desc] at h ⊢
    exact h

/-- In `Over X`, the cover arrow `Over.mk (Sigma.desc 𝒰.f)` is the coproduct of the member
arrows `Over.mk (𝒰.f i)`.  Project-local component of the Stub-1 distributivity step: the inner
`∐ᵢ Uᵢ` of the fibre power, transported into `Over X`. -/
noncomputable def coverArrowOverSigmaIso (𝒰 : X.OpenCover) :
    (∐ fun i : 𝒰.I₀ => Over.mk (𝒰.f i)) ≅ Over.mk (Sigma.desc 𝒰.f) :=
  (coproductIsCoproduct _).coconePointUniqueUpToIso (coverArrowOverIsColimit 𝒰)

/-- Transport of the `m`-fold wide fibre power (constant family) of a single map `q : A ⟶ X` along
an isomorphism `w : B ≅ A` of the apex with `w.hom ≫ q = q'`: in `Over X` the backbones
`Over.mk (WidePullback.base (fun _ => q))` and `Over.mk (WidePullback.base (fun _ => q'))` agree.
Specialized to `Scheme` (the hom-universe must be pinned for the `rw`/`simp` on composites to fire).
Used in `cechBackbone_left_sigma` to transport the cover-arrow fibre power across the
universe-reduction reindexing `∐ 𝒰.X ≅ ∐ (𝒰.X ∘ e.symm)`. -/
noncomputable def widePullbackBaseCongr {A B : Scheme.{u}} (q : A ⟶ X) (q' : B ⟶ X)
    (w : B ≅ A) (hw : w.hom ≫ q = q') (m : ℕ) :
    Over.mk (WidePullback.base (fun _ : Fin m => q)) ≅
    Over.mk (WidePullback.base (fun _ : Fin m => q')) := by
  have hinv : w.inv ≫ q' = q := by rw [← hw, ← Category.assoc, w.inv_hom_id, Category.id_comp]
  refine Over.isoMk ?_ ?_
  · refine
      { hom := WidePullback.lift (WidePullback.base _)
          (fun k => WidePullback.π (fun _ : Fin m => q) k ≫ w.inv)
          (fun k => by rw [Category.assoc, hinv]; exact WidePullback.π_arrow _ k)
        inv := WidePullback.lift (WidePullback.base _)
          (fun k => WidePullback.π (fun _ : Fin m => q') k ≫ w.hom)
          (fun k => by rw [Category.assoc, hw]; exact WidePullback.π_arrow _ k)
        hom_inv_id := ?_
        inv_hom_id := ?_ }
    · apply WidePullback.hom_ext
      · intro k
        simp only [Over.mk_left, Category.assoc, Category.id_comp, WidePullback.lift_π,
          WidePullback.lift_π_assoc, Iso.inv_hom_id, Category.comp_id]
      · simp only [Over.mk_left, Category.assoc, Category.id_comp, WidePullback.lift_base]
    · apply WidePullback.hom_ext
      · intro k
        simp only [Over.mk_left, Category.assoc, Category.id_comp, WidePullback.lift_π,
          WidePullback.lift_π_assoc, Iso.hom_inv_id, Category.comp_id]
      · simp only [Over.mk_left, Category.assoc, Category.id_comp, WidePullback.lift_base]
  · simp [WidePullback.lift_base]

/-! ## Stub 1 — Geometric backbone identification -/

/-- The degree-`p` Čech-nerve backbone object, in `Over X`, is `Over.mk` of the wide-pullback
base map of the `(p+1)`-fold fibre power of the cover map `q = Sigma.desc 𝒰.f`.  This is a pure
unfolding of `coverCechNerveOver = Over.lift …`, `coverCechNerve = augmentedCechNerve` and
`Arrow.cechNerve_obj`; all the identifications are definitional.  Project-local first step of
the Stub-1 geometric backbone identification. -/
noncomputable def cechBackbone_obj_widePullback (𝒰 : X.OpenCover) (p : ℕ) :
    (coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p)) ≅
    Over.mk (WidePullback.base (fun _ : Fin (p + 1) => Sigma.desc 𝒰.f)) :=
  Iso.refl _

/-- The slice-product of the cover legs over a multi-index `σ` is the intersection open
`coverInterOpen 𝒰 σ`, as objects of `Over X`: combine `widePullback_overX_eq_prod` (slice product =
wide fibre power) with `widePullback_openImm_inter` (wide fibre power of open immersions =
intersection open).  Project-local σ-component of the Stub-1 backbone decomposition. -/
noncomputable def coverInterProdIso (𝒰 : X.OpenCover) {p : ℕ} (σ : Fin (p + 1) → 𝒰.I₀) :
    (∏ᶜ fun k : Fin (p + 1) => Over.mk (𝒰.f (σ k))) ≅
    Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)) := by
  refine (widePullback_overX_eq_prod (fun k : Fin (p + 1) => 𝒰.f (σ k))).symm ≪≫
    Over.isoMk (widePullback_openImm_inter (fun k : Fin (p + 1) => 𝒰.f (σ k))) ?_
  exact IsOpenImmersion.lift_fac (Scheme.Opens.ι (coverInterOpen 𝒰 σ))
    (WidePullback.base (fun k : Fin (p + 1) => 𝒰.f (σ k))) _

/- Planner strategy:
Goal: `(coverCechNerveOver 𝒰).obj (op [p]) ≅ ∐ fun σ => Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))`
in `Over X`.

Route:
(a) UNPACK `coverCechNerveOver`: it is `Over.lift (coverCechNerve 𝒰).left (coverCechNerve 𝒰).hom`,
    so the degree-`p` object is `Over.mk ((coverCechNerve 𝒰).hom.app (mk p))`.
    The underlying scheme is `(coverCechNerve 𝒰).left.obj (op (mk p))` — the `(p+1)`-fold
    fibre power of `coverArrow 𝒰 = Arrow.mk (Sigma.desc 𝒰.f)` over `X`.

(b) DISTRIBUTE: coproducts distribute over finite fibre products in `Scheme`
    (`Sigma.fiberProduct_sigma` or similar Mathlib anchor):
    `(∐ᵢ Uᵢ) ×_X ⋯ ×_X (∐ᵢ Uᵢ) ≅ ∐_σ (U_{σ 0} ×_X ⋯ ×_X U_{σ p})`
    for `σ : Fin(p+1) → 𝒰.I₀`.

(c) INTERSECT: each factor `U_{σ 0} ×_X ⋯ ×_X U_{σ p}` is the scheme-level intersection
    (fibre product of open immersions over `X`), which is the open subscheme
    `coverInterOpen 𝒰 σ` with structure map `Scheme.Opens.ι (coverInterOpen 𝒰 σ)`.

(d) IDENTIFY: the structure map of the `σ`-component is the open immersion `j_σ`, and the
    universal map out of the coproduct is `Sigma.desc (fun σ => j_σ)`, making the LHS
    equal to `∐_σ Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))` as an `Over X` object.

Key Mathlib anchors:
- `Scheme.pullback_openCover_iSup` or sigma-fibre-product distribution in `Scheme`
- `Scheme.IsOpenImmersion.isPullback` (open immersions are pullback-stable)
- `ColimitCocone` machinery for the coproduct in `Over X`

Difficulty: MEDIUM — geometric bookkeeping, not sheaf theory. -/
noncomputable def cechBackbone_left_sigma (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (p : ℕ) :
    (coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p)) ≅
    ∐ fun σ : Fin (p + 1) → 𝒰.I₀ =>
      Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)) := by
  -- Universe reduction: reindex the cover index `𝒰.I₀ : Type u` to `Fin n : Type 0`, since the
  -- extensivity primitive `isIso_sigmaDesc_fst` (in `widePullback_coproduct_iso`) is Type-0-only.
  set n := Nat.card 𝒰.I₀
  let e : 𝒰.I₀ ≃ Fin n := Finite.equivFin 𝒰.I₀
  let f' : (j : Fin n) → 𝒰.X (e.symm j) ⟶ X := fun j => 𝒰.f (e.symm j)
  -- reindexing iso on the cover coproduct, and its compatibility with the descent maps
  let wZ : (∐ fun j : Fin n => 𝒰.X (e.symm j)) ≅ ∐ 𝒰.X :=
    Sigma.whiskerEquiv e.symm (fun j => Iso.refl _)
  have hwZ : wZ.hom ≫ Sigma.desc 𝒰.f = Sigma.desc f' := by
    refine Sigma.hom_ext _ _ (fun j => ?_)
    simp only [wZ, Sigma.whiskerEquiv, Iso.refl_inv, Sigma.ι_comp_map'_assoc, Category.id_comp,
      Sigma.ι_desc, f']
  -- reindex the σ-coproduct back from `Fin (p+1) → Fin n` to `Fin (p+1) → 𝒰.I₀`
  let reIdx : (∐ fun σ : Fin (p + 1) → Fin n => ∏ᶜ fun k => Over.mk (f' (σ k))) ≅
      ∐ fun τ : Fin (p + 1) → 𝒰.I₀ => ∏ᶜ fun k => Over.mk (𝒰.f (τ k)) :=
    Sigma.whiskerEquiv (f := fun σ : Fin (p + 1) → Fin n => ∏ᶜ fun k => Over.mk (f' (σ k)))
      (g := fun τ : Fin (p + 1) → 𝒰.I₀ => ∏ᶜ fun k => Over.mk (𝒰.f (τ k)))
      (Equiv.arrowCongr (Equiv.refl (Fin (p + 1))) e.symm) (fun σ => Iso.refl _)
  refine cechBackbone_obj_widePullback 𝒰 p ≪≫
    widePullbackBaseCongr (Sigma.desc 𝒰.f) (Sigma.desc f') wZ hwZ (p + 1) ≪≫
    FinitaryPreExtensive.widePullback_coproduct_iso f' p ≪≫ reIdx ≪≫
    Sigma.mapIso (fun σ => coverInterProdIso 𝒰 σ)

/-! ## Stub 2 — Push-pull over the Čech backbone is the product over intersection opens -/

/-- A morphism in `X.Modules` is an isomorphism as soon as its image under the forgetful functor
`Scheme.Modules.toPresheaf` to presheaves of abelian groups is one.  `toPresheaf` reflects
isomorphisms (it factors through fully faithful functors), so this is immediate.  Project-local L1
reflection wrapper for the Stub-2 disjoint-union chain (blueprint `lem:isIso_modules_of_toPresheaf`). -/
theorem isIso_modules_of_toPresheaf {M N : X.Modules} (φ : M ⟶ N)
    [IsIso ((Scheme.Modules.toPresheaf X).map φ)] : IsIso φ :=
  isIso_of_reflects_iso φ (Scheme.Modules.toPresheaf X)

/-- If `BinaryFan.mk α β` is a limit, then the canonical comparison map `prod.lift α β` into the
chosen binary product is an isomorphism.  Project-local categorical helper for the disjoint-cover
decomposition. -/
private lemma isIso_prodLift_of_isLimit {C : Type*} [Category C] {P Q T : C}
    [HasBinaryProduct P Q] {α : T ⟶ P} {β : T ⟶ Q}
    (h : IsLimit (BinaryFan.mk α β)) : IsIso (Limits.prod.lift α β) := by
  have heq : (h.conePointUniqueUpToIso (prodIsProd P Q)).hom = Limits.prod.lift α β := by
    apply Limits.prod.hom_ext
    · have := h.conePointUniqueUpToIso_hom_comp (prodIsProd P Q) ⟨WalkingPair.left⟩
      simpa [Limits.prod.lift_fst] using this
    · have := h.conePointUniqueUpToIso_hom_comp (prodIsProd P Q) ⟨WalkingPair.right⟩
      simpa [Limits.prod.lift_snd] using this
  rw [← heq]; infer_instance

/-- If a functor `G` preserves the binary product `P ⨯ Q` and the mapped binary fan
`BinaryFan.mk (G.map α) (G.map β)` is a limit, then `G.map (prod.lift α β)` is an isomorphism.
Project-local: combines `prodComparison` naturality with `isIso_prodLift_of_isLimit`. -/
private lemma isIso_map_prodLift_of_isLimit {C D : Type*} [Category C] [Category D]
    {P Q T : C} [HasBinaryProduct P Q] (G : C ⥤ D) [PreservesLimit (pair P Q) G]
    {α : T ⟶ P} {β : T ⟶ Q} [HasBinaryProduct (G.obj P) (G.obj Q)]
    (h : IsLimit (BinaryFan.mk (G.map α) (G.map β))) :
    IsIso (G.map (Limits.prod.lift α β)) := by
  have hcomp : G.map (Limits.prod.lift α β) ≫ prodComparison G P Q
      = Limits.prod.lift (G.map α) (G.map β) := by
    apply Limits.prod.hom_ext
    · rw [Category.assoc, prodComparison_fst, ← G.map_comp, Limits.prod.lift_fst,
        Limits.prod.lift_fst]
    · rw [Category.assoc, prodComparison_snd, ← G.map_comp, Limits.prod.lift_snd,
        Limits.prod.lift_snd]
  haveI : IsIso (Limits.prod.lift (G.map α) (G.map β)) := isIso_prodLift_of_isLimit h
  haveI : IsIso (G.map (Limits.prod.lift α β) ≫ prodComparison G P Q) := hcomp ▸ this
  exact IsIso.of_isIso_comp_right (G.map (Limits.prod.lift α β)) (prodComparison G P Q)

section BinaryDecomp

variable {A B : Scheme.{u}}

/-- The binary disjoint-cover decomposition comparison map of a module sheaf on a coproduct
scheme: the pair of restriction-to-component units. -/
private noncomputable def coprodDecompMap (M : (A ⨿ B).Modules) :
    M ⟶ (Scheme.Modules.pushforward (coprod.inl : A ⟶ A ⨿ B)).obj
          (M.restrict (coprod.inl : A ⟶ A ⨿ B)) ⨯
        (Scheme.Modules.pushforward (coprod.inr : B ⟶ A ⨿ B)).obj
          (M.restrict (coprod.inr : B ⟶ A ⨿ B)) :=
  prod.lift ((Scheme.Modules.restrictAdjunction (coprod.inl : A ⟶ A ⨿ B)).unit.app M)
    ((Scheme.Modules.restrictAdjunction (coprod.inr : B ⟶ A ⨿ B)).unit.app M)

/- **Status: L2 DONE.** The disjoint-cover leaf `isIso_coprodDecompMap`, the per-leg coherence
`pushPull_binary_leg_coherence` (★), and the canonical binary assembly `pushPull_binary_coprod_prod`
are all proved axiom-clean below; the finite-index generalization `pushPull_coprod_prod` and
Stub 2 `pushPull_sigma_iso` chain them.  All three `coprodToProd_isIso_*` induction steps
(empty / option / equiv) are now closed, so `pushPull_sigma_iso` and Stub 4
`pushPull_eval_prod_iso` are axiom-clean. -/

/-- The binary disjoint-cover decomposition comparison map `coprodDecompMap M` is an isomorphism:
a module sheaf on `A ⨿ B` is the product of its restrictions-to-component pushforwards.  This is the
binary disjoint-union sheaf decomposition (`TopCat.Sheaf.isProductOfDisjoint` on the underlying
abelian sheaf), reflected back to `(A ⨿ B).Modules`.  Project-local leaf of the Stub-2 chain. -/
private theorem isIso_coprodDecompMap (M : (A ⨿ B).Modules) :
    IsIso (coprodDecompMap M) := by
  rw [Scheme.Modules.Hom.isIso_iff_isIso_app]
  intro U
  set ι₀ : A ⟶ A ⨿ B := coprod.inl with hι₀
  set ι₁ : B ⟶ A ⨿ B := coprod.inr with hι₁
  set W₀ : (A ⨿ B).Opens := ι₀ ''ᵁ ι₀ ⁻¹ᵁ U with hW₀
  set W₁ : (A ⨿ B).Opens := ι₁ ''ᵁ ι₁ ⁻¹ᵁ U with hW₁
  have h₂ : W₀ ⊓ W₁ = ⊥ := by
    rw [hW₀, hW₁]
    simp_rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
    rw [← inf_inf_distrib_right, (isCompl_opensRange_inl_inr A B).inf_eq_bot, bot_inf_eq]
  have h₁ : W₀ ⊔ W₁ = U := by
    rw [hW₀, hW₁]
    simp_rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
    rw [← inf_sup_right, (isCompl_opensRange_inl_inr A B).sup_eq_top, top_inf_eq]
  -- the two restriction-unit legs at `U`, identified as presheaf restriction maps
  set u₀ := (Scheme.Modules.restrictAdjunction ι₀).unit.app M with hu₀
  set u₁ := (Scheme.Modules.restrictAdjunction ι₁).unit.app M with hu₁
  have hleg₀ : u₀.app U = M.presheaf.map (homOfLE (ι₀.image_preimage_le U)).op := by
    rw [hu₀, Scheme.Modules.restrictAdjunction_unit_app_app]
  have hleg₁ : u₁.app U = M.presheaf.map (homOfLE (ι₁.image_preimage_le U)).op := by
    rw [hu₁, Scheme.Modules.restrictAdjunction_unit_app_app]
  -- the disjoint-union limit on the underlying abelian sheaf of `M`, transported to `Γ(M, U)`
  have LimAb : IsLimit (BinaryFan.mk (u₀.app U) (u₁.app U)) := by
    have L := TopCat.Sheaf.isProductOfDisjoint
      (⟨M.presheaf, M.isSheaf⟩ : TopCat.Sheaf Ab _) W₀ W₁ h₂
    refine L.ofIsoLimit (Cone.ext (M.presheaf.mapIso (eqToIso (congrArg Opposite.op h₁))) ?_)
    rintro ⟨(_ | _)⟩
    · show M.presheaf.map (homOfLE le_sup_left).op
        = M.presheaf.map (eqToHom (congrArg Opposite.op h₁)) ≫ u₀.app U
      rw [hleg₀, show (homOfLE (le_sup_left : W₀ ≤ W₀ ⊔ W₁)).op
            = eqToHom (congrArg Opposite.op h₁) ≫ (homOfLE (ι₀.image_preimage_le U)).op
          from Subsingleton.elim _ _, M.presheaf.map_comp]
      rfl
    · show M.presheaf.map (homOfLE le_sup_right).op
        = M.presheaf.map (eqToHom (congrArg Opposite.op h₁)) ≫ u₁.app U
      rw [hleg₁, show (homOfLE (le_sup_right : W₁ ≤ W₀ ⊔ W₁)).op
            = eqToHom (congrArg Opposite.op h₁) ≫ (homOfLE (ι₁.image_preimage_le U)).op
          from Subsingleton.elim _ _, M.presheaf.map_comp]
      rfl
  -- reflect the limit up to `ModuleCat` through the evaluation functor
  set G := SheafOfModules.evaluation (R := (A ⨿ B).ringCatSheaf) (Opposite.op U) with hGdef
  have LimMod : IsLimit (BinaryFan.mk (G.map u₀) (G.map u₁)) := by
    refine isLimitOfReflectsOfMapIsLimit (forget₂ (ModuleCat _) AddCommGrpCat)
      (G.map u₀) (G.map u₁) ?_
    exact LimAb
  -- conclude isomorphy of the comparison map at `U`
  haveI key : IsIso (G.map (coprodDecompMap M)) :=
    isIso_map_prodLift_of_isLimit G LimMod
  have happ : (coprodDecompMap M).app U
      = (forget₂ (ModuleCat _) AddCommGrpCat).map (G.map (coprodDecompMap M)) := rfl
  rw [happ]
  exact Functor.map_isIso _ _

/-! ### L2 `q_*`-coherence chain: push–pull turns a coproduct into a product

The binary disjoint-cover decomposition `isIso_coprodDecompMap` is upgraded to a statement about
the push–pull object `pushPullObj F (Over.mk q)` (`q = coprod.desc pA pB`).  The single substantive
node is the per-leg coherence `pushPull_binary_leg_coherence` (★): the contravariant push–pull map of
the over-inclusion `Over.homMk c : Over.mk pC ⟶ Over.mk q` is, up to the canonical leg iso
`pushPullCoprodLegIso`, the pushforward of the disjoint-cover restriction unit.  This lets the
canonical comparison `prod.lift (pushPullMap F overInl) (pushPullMap F overInr)` be matched against
the manifestly-iso chain through `coprodDecompMap`. -/

/-- The canonical leg iso identifying `q_*(c_*(M.restrict c))` (a factor of `q_*(P ⨯ Q)`, where
`M = q^* F` and `c` is a coproduct inclusion `coprod.inl`/`coprod.inr`) with the push–pull object
`pushPullObj F (Over.mk pC)` along the over-triangle `wC : c ≫ q = pC`.  Project-local component of
the L2 `q_*`-coherence chain. -/
private noncomputable def pushPullCoprodLegIso {C : Scheme.{u}} (q : (A ⨿ B) ⟶ X)
    (c : C ⟶ A ⨿ B) [IsOpenImmersion c] (pC : C ⟶ X) (wC : c ≫ q = pC) (F : X.Modules) :
    (pushforward q).obj ((pushforward c).obj
        (((Scheme.Modules.pullback q).obj F).restrict c)) ≅
      pushPullObj F (Over.mk pC) :=
  (pushforward q).mapIso ((pushforward c).mapIso
    ((Scheme.Modules.restrictFunctorIsoPullback c).app ((Scheme.Modules.pullback q).obj F) ≪≫
      (Scheme.Modules.pullbackComp c q).app F ≪≫
      (Scheme.Modules.pullbackCongr wC).app F)) ≪≫
  eqToIso (congrArg (fun p => (pushforward p).obj ((Scheme.Modules.pullback pC).obj F)) wC)

-- The final `congr 1` discharges the proof-irrelevant `eqToHom` over-triangle transports against
-- concrete pushforward/pullback objects, whose `whnf` exceeds the default heartbeat budget.
set_option maxHeartbeats 800000 in
/-- (★) Per-leg coherence: the push–pull map of the over-inclusion `Over.homMk c : Over.mk pC ⟶
Over.mk q` is, through the canonical leg iso, the pushforward of the disjoint-cover restriction unit
`(restrictAdjunction c).unit`.  This is the bridge that converts the canonical comparison map
`prod.lift (pushPullMap F …)` into the manifestly-iso `coprodDecompMap` chain.  Project-local. -/
private lemma pushPull_binary_leg_coherence {C : Scheme.{u}} (q : (A ⨿ B) ⟶ X)
    (c : C ⟶ A ⨿ B) [IsOpenImmersion c] (pC : C ⟶ X) (wC : c ≫ q = pC) (F : X.Modules) :
    pushPullMap F (Over.homMk c wC : Over.mk pC ⟶ Over.mk q) =
      (pushforward q).map
          ((Scheme.Modules.restrictAdjunction c).unit.app ((Scheme.Modules.pullback q).obj F)) ≫
        (pushPullCoprodLegIso q c pC wC F).hom := by
  have hraw : pushPullMap F (Over.homMk c wC : Over.mk pC ⟶ Over.mk q)
      = rawPushPullMap c q pC wC F := rfl
  rw [hraw, rawPushPullMap_self_gen]
  have hLAU : (Scheme.Modules.restrictAdjunction c).unit.app ((Scheme.Modules.pullback q).obj F) ≫
        (pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback c).hom.app
            ((Scheme.Modules.pullback q).obj F)) =
      (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
        ((Scheme.Modules.pullback q).obj F) :=
    Adjunction.unit_leftAdjointUniq_hom_app _ _ _
  subst wC
  simp only [pushPullCoprodLegIso, Iso.trans_hom, Functor.mapIso_hom, eqToIso.hom,
    Iso.app_hom, Category.comp_id,
    Scheme.Modules.pullbackCongr, eqToIso_refl, Iso.refl_hom, NatTrans.id_app]
  rw [← hLAU]
  simp only [Functor.map_comp, Category.assoc]; rfl

end BinaryDecomp

/-- Push–pull on a binary coproduct of two legs is the binary product of the two leg push–pulls.
The forward map is the canonical `prod.lift` of the two push–pull maps of the coproduct inclusions
(the mandatory framing the downstream section-identification needs); it is shown to be an
isomorphism by matching it leg-by-leg, via the per-leg coherence
`pushPull_binary_leg_coherence` (★), against the manifestly-invertible reference chain through the
binary disjoint-union decomposition `coprodDecompMap`.  Project-local L2 assembly
(blueprint `lem:pushPull_binary_coprod_prod`). -/
noncomputable def pushPull_binary_coprod_prod (F : X.Modules) (Y₀ Y₁ : Over X) :
    pushPullObj F (Over.mk (Limits.coprod.desc Y₀.hom Y₁.hom)) ≅
      pushPullObj F Y₀ ⨯ pushPullObj F Y₁ := by
  set q : Y₀.left ⨿ Y₁.left ⟶ X := Limits.coprod.desc Y₀.hom Y₁.hom with hq
  set M := (Scheme.Modules.pullback q).obj F with hM
  have wInl : (Limits.coprod.inl : Y₀.left ⟶ _) ≫ q = Y₀.hom := Limits.coprod.inl_desc _ _
  have wInr : (Limits.coprod.inr : Y₁.left ⟶ _) ≫ q = Y₁.hom := Limits.coprod.inr_desc _ _
  set overInl : Y₀ ⟶ Over.mk q := Over.homMk Limits.coprod.inl wInl with hoverInl
  set overInr : Y₁ ⟶ Over.mk q := Over.homMk Limits.coprod.inr wInr with hoverInr
  haveI : IsIso (coprodDecompMap M) := isIso_coprodDecompMap M
  -- The per-leg identifications.  Their codomains are pinned to `pushPullObj F Y₀`/`Y₁`
  -- (defeq to the `pushPullObj F (Over.mk Y₀.hom)` produced by `pushPullCoprodLegIso`); the
  -- syntactic pin is essential so the `Category.assoc`/`prod.map_fst` rewrites below can match
  -- the trailing `prod.fst` on `pushPullObj F Y₀ ⨯ pushPullObj F Y₁`.
  set idiso₀ : (pushforward q).obj ((pushforward Limits.coprod.inl).obj (M.restrict Limits.coprod.inl))
      ≅ pushPullObj F Y₀ :=
    pushPullCoprodLegIso q Limits.coprod.inl Y₀.hom wInl F with hidiso0
  set idiso₁ : (pushforward q).obj ((pushforward Limits.coprod.inr).obj (M.restrict Limits.coprod.inr))
      ≅ pushPullObj F Y₁ :=
    pushPullCoprodLegIso q Limits.coprod.inr Y₁.hom wInr F with hidiso1
  have hcoh0 : pushPullMap F overInl
      = (pushforward q).map ((Scheme.Modules.restrictAdjunction Limits.coprod.inl).unit.app M)
          ≫ idiso₀.hom := by
    rw [hidiso0]; exact pushPull_binary_leg_coherence q Limits.coprod.inl Y₀.hom wInl F
  have hcoh1 : pushPullMap F overInr
      = (pushforward q).map ((Scheme.Modules.restrictAdjunction Limits.coprod.inr).unit.app M)
          ≫ idiso₁.hom := by
    rw [hidiso1]; exact pushPull_binary_leg_coherence q Limits.coprod.inr Y₁.hom wInr F
  set chainIso : (pushforward q).obj M ≅ pushPullObj F Y₀ ⨯ pushPullObj F Y₁ :=
    (pushforward q).mapIso (asIso (coprodDecompMap M)) ≪≫
      Limits.PreservesLimitPair.iso (pushforward q) _ _ ≪≫
      Limits.prod.mapIso idiso₀ idiso₁ with hchain
  -- Match the canonical comparison against the reference chain entirely through `prod.lift`
  -- identities (`prod.lift_map`, `prod.comp_lift`, and `prodComparison = prod.lift (q_* fst)
  -- (q_* snd)`), avoiding any `≫ prod.fst` projection that the surrounding pushforward objects
  -- make awkward to reassociate.
  have hcmp : Limits.prod.lift (pushPullMap F overInl) (pushPullMap F overInr) = chainIso.hom := by
    rw [hcoh0, hcoh1, hchain, Iso.trans_hom, Iso.trans_hom, Functor.mapIso_hom, asIso_hom,
      Limits.prod.mapIso_hom, Limits.PreservesLimitPair.iso_hom]
    show Limits.prod.lift _ _ =
      (pushforward q).map (coprodDecompMap M) ≫
        Limits.prod.lift ((pushforward q).map Limits.prod.fst) ((pushforward q).map Limits.prod.snd)
          ≫ Limits.prod.map idiso₀.hom idiso₁.hom
    rw [Limits.prod.lift_map, Limits.prod.comp_lift, ← Functor.map_comp_assoc,
      ← Functor.map_comp_assoc, coprodDecompMap, Limits.prod.lift_fst, Limits.prod.lift_snd]
    rfl
  haveI : IsIso (Limits.prod.lift (pushPullMap F overInl) (pushPullMap F overInr)) := by
    rw [hcmp]; infer_instance
  exact asIso (Limits.prod.lift (pushPullMap F overInl) (pushPullMap F overInr))

/-- The forward map of `pushPull_binary_coprod_prod` in its canonical `prod.lift`-of-push–pull-maps
form (the binary case of the canonical framing kept through the finite induction). -/
private lemma pushPull_binary_coprod_prod_hom (F : X.Modules) (Y₀ Y₁ : Over X) :
    (pushPull_binary_coprod_prod F Y₀ Y₁).hom =
      Limits.prod.lift
        (pushPullMap F (Over.homMk Limits.coprod.inl (Limits.coprod.inl_desc Y₀.hom Y₁.hom) :
          Y₀ ⟶ Over.mk (Limits.coprod.desc Y₀.hom Y₁.hom)))
        (pushPullMap F (Over.homMk Limits.coprod.inr (Limits.coprod.inr_desc Y₀.hom Y₁.hom) :
          Y₁ ⟶ Over.mk (Limits.coprod.desc Y₀.hom Y₁.hom))) := rfl

/-! ### Finite-index induction: push–pull turns a finite coproduct into a finite product

The binary `pushPull_binary_coprod_prod` is upgraded to an arbitrary finite index `ι` by
`Finite.induction_empty_option`.  The chain runs through four leaves:
* `pushPullObjCongr` — transport a push–pull object along a slice iso;
* `overSigmaOptionIso` — slice lift of the `Option`-coproduct split;
* `piOptionIso` — the dual `Option`-product split;
* `pushPull_coprod_prod_empty` — the empty base case.
-/

/-- Push–pull objects transport along a slice isomorphism `e : Y ≅ Y'` in `Over X`.  The
push–pull object is a contravariant functor of its slice argument, so the forward map is
`pushPullMap F e.inv` and the backward map `pushPullMap F e.hom`.  Project-local
(blueprint `lem:pushPullObjCongr`). -/
noncomputable def pushPullObjCongr (F : X.Modules) {Y Y' : Over X} (e : Y ≅ Y') :
    pushPullObj F Y ≅ pushPullObj F Y' where
  hom := pushPullMap F e.inv
  inv := pushPullMap F e.hom
  hom_inv_id := by rw [← pushPullMap_comp, e.hom_inv_id, pushPullMap_id]
  inv_hom_id := by rw [← pushPullMap_comp, e.inv_hom_id, pushPullMap_id]

/-- Slice lift of the `Option`-coproduct split (`sigmaOptionIso`): for a family of slice
objects `legs : Option α → Over X`, the coproduct slice object `Over.mk (Sigma.desc (·.hom))`
is isomorphic to the binary-split slice object.  Built as `Over.isoMk` of the underlying
`sigmaOptionIso` together with the structure-map compatibility.  Project-local
(blueprint `lem:over_sigmaOptionIso`). -/
noncomputable def overSigmaOptionIso {α : Type*} (legs : Option α → Over X)
    [HasCoproduct (fun o => (legs o).left)]
    [HasCoproduct (fun a : α => (legs (some a)).left)]
    [HasBinaryCoproduct (legs none).left (∐ fun a : α => (legs (some a)).left)] :
    Over.mk (Limits.Sigma.desc (fun o => (legs o).hom)) ≅
      Over.mk (Limits.coprod.desc (legs none).hom
        (Limits.Sigma.desc (fun a : α => (legs (some a)).hom))) :=
  Over.isoMk (sigmaOptionIso (fun o => (legs o).left)) (by
    refine Limits.Sigma.hom_ext _ _ (fun o => ?_)
    rcases o with _ | a
    · simp only [sigmaOptionIso, Over.mk_left, Over.mk_hom,
        Limits.Sigma.ι_desc_assoc, Limits.coprod.inl_desc, Limits.Sigma.ι_desc]
    · simp only [sigmaOptionIso, Over.mk_left, Over.mk_hom, Category.assoc,
        Limits.Sigma.ι_desc_assoc, Limits.coprod.inr_desc, Limits.Sigma.ι_desc])

/-- The dual `Option`-product split: for `W : Option α → C` the total product splits off its
`none` factor.  Project-local (blueprint `lem:piOptionIso`). -/
noncomputable def piOptionIso {C : Type*} [Category C] {α : Type*} (W : Option α → C)
    [HasProduct W] [HasProduct (fun a : α => W (some a))]
    [HasBinaryProduct (W none) (∏ᶜ fun a : α => W (some a))] :
    (∏ᶜ W) ≅ W none ⨯ (∏ᶜ fun a : α => W (some a)) where
  hom := Limits.prod.lift (Limits.Pi.π W none)
    (Limits.Pi.lift (fun a => Limits.Pi.π W (some a)))
  inv := Limits.Pi.lift (fun o => Option.rec Limits.prod.fst
    (fun a => Limits.prod.snd ≫ Limits.Pi.π (fun a : α => W (some a)) a) o)
  hom_inv_id := by
    apply Limits.Pi.hom_ext
    rintro (_ | a)
    · simp only [Category.assoc, Limits.Pi.lift_π, Limits.prod.lift_fst, Category.id_comp]
    · rw [Category.id_comp, Category.assoc, Limits.Pi.lift_π, ← Category.assoc,
        Limits.prod.lift_snd, Limits.Pi.lift_π]
  inv_hom_id := by
    apply Limits.prod.hom_ext
    · simp only [Category.assoc, Limits.prod.lift_fst, Limits.Pi.lift_π, Category.id_comp]
    · apply Limits.Pi.hom_ext
      intro a
      simp only [Category.assoc, Limits.prod.lift_snd, Limits.Pi.lift_π, Category.id_comp]

/-- The coproduct inclusion of leg `i`, viewed as an over-morphism into the descent object
`Over.mk (Sigma.desc (·.hom))`. -/
noncomputable def coprodOverIncl {ι : Type*} (legs : ι → Over X)
    [HasCoproduct (fun i => (legs i).left)] (i : ι) :
    legs i ⟶ Over.mk (Limits.Sigma.desc (fun i => (legs i).hom)) :=
  Over.homMk (Limits.Sigma.ι (fun i => (legs i).left) i) (by simp [Limits.Sigma.ι_desc])

/-- The canonical comparison map from the push–pull object on the coproduct of the legs to
the product of the per-leg push–pull objects: the `Pi.lift` of the push–pull maps of the
coproduct inclusions.  This is the canonical framing kept throughout the finite induction. -/
noncomputable def coprodToProdMap {ι : Type*} (F : X.Modules) (legs : ι → Over X)
    [HasCoproduct (fun i => (legs i).left)]
    [HasProduct (fun i => pushPullObj F (legs i))] :
    pushPullObj F (Over.mk (Limits.Sigma.desc (fun i => (legs i).hom))) ⟶
      ∏ᶜ fun i => pushPullObj F (legs i) :=
  Limits.Pi.lift (fun i => pushPullMap F (coprodOverIncl legs i))

/-- A sheaf of modules over an empty (initial) scheme is a zero object.  All its sections
vanish: the structure sheaf has subsingleton sections over every open (`IsEmpty ↥Z`), so every
module of sections is subsingleton, and the underlying abelian presheaf is pointwise zero.  We
reflect `𝟙 = 0` through the faithful `toPresheaf`. -/
private lemma isZero_modules_of_isEmpty {Z : Scheme} [IsEmpty ↥Z] (M : Z.Modules) :
    IsZero M := by
  rw [IsZero.iff_id_eq_zero]
  apply (Scheme.Modules.toPresheaf Z).map_injective
  rw [CategoryTheory.Functor.map_id, (Scheme.Modules.toPresheaf Z).map_zero]
  ext U x
  haveI : Subsingleton ↑(((Scheme.Modules.toPresheaf Z).obj M).obj (op U)) := by
    have h : Subsingleton ↑Γ(M, U) := Module.subsingleton ↑Γ(Z, U) _
    exact h
  exact Subsingleton.elim _ _

/-- Empty base case of the finite induction: for the empty index the comparison map
`coprodToProdMap` is an isomorphism (both source and target are terminal — the push–pull
of the initial scheme and the empty product).  Project-local
(blueprint `lem:pushPull_coprod_prod_empty`). -/
private theorem pushPull_coprod_prod_empty (F : X.Modules) (legs : PEmpty.{u + 1} → Over X) :
    IsIso (coprodToProdMap F legs) := by
  -- Target: the empty product is terminal.
  have hY : Limits.IsTerminal (∏ᶜ fun i : PEmpty.{u + 1} => pushPullObj F (legs i)) :=
    Limits.IsTerminal.ofUniqueHom (fun _ => Limits.Pi.lift (fun i => i.elim))
      (fun _ m => Limits.Pi.hom_ext _ _ (fun i => i.elim))
  -- Source: push–pull of the initial scheme.  `pushforward q` is a right adjoint, so it
  -- preserves the terminal object; and `(pullback q).obj F` is terminal over the initial
  -- scheme (its structure sheaf has zero sections, so every module sheaf is terminal).
  have hX : Limits.IsTerminal (pushPullObj F
      (Over.mk (Limits.Sigma.desc (fun i : PEmpty.{u + 1} => (legs i).hom)))) := by
    -- `pushPullObj F Y = (pushforward Y.hom).obj ((pullback Y.hom).obj F)`; pushforward preserves
    -- zero objects (it is additive), and the pulled-back module lives over the initial scheme
    -- `∐ PEmpty`, whose only sheaf of modules is zero.
    refine (CategoryTheory.Functor.map_isZero (Scheme.Modules.pushforward _) ?_).isTerminal
    -- The base scheme `∐ PEmpty` is the initial scheme, hence has empty carrier; every sheaf of
    -- modules over it is a zero object.
    haveI : IsEmpty ↥((Over.mk (Limits.Sigma.desc fun i : PEmpty.{u + 1} => (legs i).hom)).left) := by
      rw [← AlgebraicGeometry.isInitial_iff_isEmpty]
      exact ⟨Limits.isColimitEquivIsInitialOfIsEmpty Scheme _
        (Limits.colimit.isColimit (Discrete.functor (fun i : PEmpty.{u + 1} => (legs i).left)))⟩
    exact isZero_modules_of_isEmpty _
  exact Limits.isIso_of_isTerminal hX hY _

/-- Reindexing step of the finite induction: the comparison map's iso-status transports
along an equivalence `e : α ≃ β` of index types.  Project-local. -/
private theorem coprodToProd_isIso_of_equiv (F : X.Modules) {α β : Type u} (e : α ≃ β)
    (ih : ∀ (legs : α → Over X), IsIso (coprodToProdMap F legs))
    (legs : β → Over X) : IsIso (coprodToProdMap F legs) := by
  -- The induction hypothesis gives iso-status for the `α`-reindexed family `legs ∘ e`.
  haveI := ih (fun a => legs (e a))
  -- Source coproduct reindex (orientation chosen so the factor isos are literally `Iso.refl`):
  -- `∐_α (legs∘e).left ≅ ∐_β legs.left`.
  let u : (∐ fun a => (legs (e a)).left) ≅ (∐ fun b => (legs b).left) :=
    Sigma.whiskerEquiv (f := fun a => (legs (e a)).left) (g := fun b => (legs b).left)
      e (fun a => Iso.refl _)
  have hw : u.hom ≫ Limits.Sigma.desc (fun b => (legs b).hom)
      = Limits.Sigma.desc (fun a => (legs (e a)).hom) := by
    refine Limits.Sigma.hom_ext _ _ (fun a => ?_)
    simp only [u, Sigma.whiskerEquiv, Iso.refl_inv, Limits.Sigma.ι_comp_map'_assoc,
      Category.id_comp, Limits.Sigma.ι_desc]
  -- Slice iso between the two descent objects in `Over X`.
  let mIso : (Over.mk (Limits.Sigma.desc (fun a => (legs (e a)).hom)) : Over X)
      ≅ Over.mk (Limits.Sigma.desc (fun b => (legs b).hom)) := Over.isoMk u hw
  -- `pushPullMap F mIso.hom` is the inverse leg of `pushPullObjCongr`, hence an isomorphism.
  haveI : IsIso (pushPullMap F mIso.hom) := by
    show IsIso ((pushPullObjCongr F mIso).inv)
    infer_instance
  -- Target product reindex (via `whiskerEquiv`, keeping a clean lambda codomain so the projections
  -- match the canonical comparisons): `∏_α (pushPull (legs∘e)) ≅ ∏_β (pushPull legs)`.
  let prodIso : (∏ᶜ fun a => pushPullObj F (legs (e a))) ≅ ∏ᶜ fun b => pushPullObj F (legs b) :=
    Pi.whiskerEquiv (f := fun a => pushPullObj F (legs (e a)))
      (g := fun b => pushPullObj F (legs b)) e (fun a => Iso.refl _)
  -- KEY identity (checked projection-by-projection over `α`): the canonical comparison for `legs`
  -- transported back across the target reindex equals the slice-transported `α`-comparison.
  have key : coprodToProdMap F legs ≫ prodIso.inv
      = pushPullMap F mIso.hom ≫ coprodToProdMap F (fun a => legs (e a)) := by
    show coprodToProdMap F legs ≫
        (Pi.whiskerEquiv (f := fun a => pushPullObj F (legs (e a)))
          (g := fun b => pushPullObj F (legs b)) e (fun a => Iso.refl _)).inv = _
    refine Limits.Pi.hom_ext _ _ (fun a => ?_)
    simp only [Category.assoc, Pi.whiskerEquiv_inv, Iso.refl_hom, Limits.Pi.map'_comp_π,
      Category.comp_id, coprodToProdMap, Limits.Pi.lift_π]
    rw [← pushPullMap_comp]
    refine congrArg (fun g => pushPullMap F g) ?_
    apply Over.OverMorphism.ext
    simp only [coprodOverIncl, mIso, u, Over.isoMk_hom_left, Sigma.whiskerEquiv, Iso.refl_inv,
      Over.comp_left, Over.homMk_left]
    simp [Limits.Sigma.ι_comp_map']
  -- Conclude: `coprodToProdMap F legs` is the first factor of an iso composite, hence an iso.
  haveI : IsIso (coprodToProdMap F legs ≫ prodIso.inv) := by rw [key]; infer_instance
  exact IsIso.of_isIso_comp_right (coprodToProdMap F legs) prodIso.inv

/-- The forward map of `pushPullObjCongr` is the push–pull map of the inverse slice iso. -/
private lemma pushPullObjCongr_hom (F : X.Modules) {Y Y' : Over X} (e : Y ≅ Y') :
    (pushPullObjCongr F e).hom = pushPullMap F e.inv := rfl

/-- Projecting the canonical comparison `coprodToProdMap` onto a factor recovers the push–pull map
of the corresponding coproduct inclusion (the defining property of `coprodToProdMap`). -/
private lemma coprodToProdMap_comp_π {ι : Type*} (F : X.Modules) (legs : ι → Over X)
    [HasCoproduct (fun i => (legs i).left)] [HasProduct (fun i => pushPullObj F (legs i))]
    (i : ι) :
    coprodToProdMap F legs ≫ Limits.Pi.π (fun i => pushPullObj F (legs i)) i
      = pushPullMap F (coprodOverIncl legs i) := by
  simp only [coprodToProdMap, Limits.Pi.lift_π]

/-- Projecting `(piOptionIso W).inv` onto the `none` factor recovers the first binary projection. -/
private lemma piOptionIso_inv_π_none {C : Type*} [Category C] {α : Type*} (W : Option α → C)
    [HasProduct W] [HasProduct (fun a : α => W (some a))]
    [HasBinaryProduct (W none) (∏ᶜ fun a : α => W (some a))] :
    (piOptionIso W).inv ≫ Limits.Pi.π W none = Limits.prod.fst := by
  simp only [piOptionIso, Limits.Pi.lift_π]

/-- Projecting `(piOptionIso W).inv` onto a `some a` factor recovers the second projection followed
by the `a`-th projection of the inner product. -/
private lemma piOptionIso_inv_π_some {C : Type*} [Category C] {α : Type*} (W : Option α → C)
    [HasProduct W] [HasProduct (fun a : α => W (some a))]
    [HasBinaryProduct (W none) (∏ᶜ fun a : α => W (some a))] (a : α) :
    (piOptionIso W).inv ≫ Limits.Pi.π W (some a)
      = Limits.prod.snd ≫ Limits.Pi.π (fun a : α => W (some a)) a := by
  simp only [piOptionIso, Limits.Pi.lift_π]

-- The `erw` projection/fold steps run `whnf` on push–pull composites, exceeding the default budget.
set_option maxHeartbeats 1600000 in
/-- `Option`-adjoining step of the finite induction: given the result for `α`, deduce it for
`Option α`, via the slice `Option`-coproduct split (`overSigmaOptionIso`), the binary
decomposition (`pushPull_binary_coprod_prod`), the induction hypothesis, and the dual
product split (`piOptionIso`).  Project-local. -/
private theorem coprodToProd_isIso_option (F : X.Modules) {α : Type u}
    (ih : ∀ (legs : α → Over X), IsIso (coprodToProdMap F legs))
    (legs : Option α → Over X) : IsIso (coprodToProdMap F legs) := by
  -- The reference iso through: the slice `Option`-coproduct split, the binary decomposition,
  -- the induction hypothesis on the `some`-part, and the dual `Option`-product split.
  -- Bind the restricted family `ls := legs ∘ some` to a local definition so that the `none`-split
  -- binary leg `Y₁ = Over.mk (Sigma.desc (ls ·).hom)` and the induction-hypothesis comparison
  -- `coprodToProdMap F ls` share *syntactically identical* product objects (otherwise the unreduced
  -- `(fun a => legs (some a)) i` beta-redex blocks the `prod.lift`/`prod.map` projection rewrites).
  let ls : α → Over X := fun a => legs (some a)
  haveI := ih ls
  let refIso : pushPullObj F (Over.mk (Limits.Sigma.desc (fun o => (legs o).hom))) ≅
      ∏ᶜ fun o => pushPullObj F (legs o) :=
    pushPullObjCongr F (overSigmaOptionIso legs) ≪≫
      pushPull_binary_coprod_prod F (legs none)
        (Over.mk (Limits.Sigma.desc (fun a => (ls a).hom))) ≪≫
      Limits.prod.mapIso (Iso.refl _) (asIso (coprodToProdMap F ls)) ≪≫
      (piOptionIso (fun o => pushPullObj F (legs o))).symm
  -- It remains to identify the canonical comparison `coprodToProdMap F legs` with `refIso.hom`
  -- (both are `Pi.lift`s of push–pull maps); then `IsIso` is immediate.  This final coherence
  -- check — matching each projection via the per-leg push–pull coherence
  -- (`pushPull_binary_leg_coherence` for the `none`/`some` inclusions) — is the residual.
  have hcanon : coprodToProdMap F legs = refIso.hom := by
    show coprodToProdMap F legs =
      (pushPullObjCongr F (overSigmaOptionIso legs) ≪≫
        pushPull_binary_coprod_prod F (legs none)
          (Over.mk (Limits.Sigma.desc (fun a => (ls a).hom))) ≪≫
        Limits.prod.mapIso (Iso.refl _) (asIso (coprodToProdMap F ls)) ≪≫
        (piOptionIso (fun o => pushPullObj F (legs o))).symm).hom
    refine Limits.Pi.hom_ext _ _ (fun o => ?_)
    rw [coprodToProdMap, Limits.Pi.lift_π, Iso.trans_hom, Iso.trans_hom, Iso.trans_hom,
      pushPullObjCongr_hom, pushPull_binary_coprod_prod_hom, Iso.symm_hom,
      Limits.prod.mapIso_hom, Iso.refl_hom, asIso_hom]
    cases o with
    | none =>
      simp only [Category.assoc]
      rw [piOptionIso_inv_π_none, Limits.prod.map_fst, Category.comp_id]
      erw [Limits.prod.lift_fst, ← pushPullMap_comp]
      refine congrArg (fun g => pushPullMap F g) ?_
      apply Over.OverMorphism.ext
      simp only [coprodOverIncl, overSigmaOptionIso, Over.isoMk_inv_left, Over.comp_left,
        Over.homMk_left, sigmaOptionIso]
      erw [Limits.coprod.inl_desc]
    | some a =>
      -- Reassociate the LHS inclusion through the binary split and the `some` coproduct leg, then
      -- expand with the *forward* `pushPullMap_comp` (syntactic head-match — the reverse fold blows
      -- up `whnf` on the push–pull composites).
      have heq : coprodOverIncl legs (some a) =
          (coprodOverIncl ls a ≫ (Over.homMk Limits.coprod.inr
              (Limits.coprod.inr_desc (legs none).hom (Limits.Sigma.desc (fun a => (ls a).hom))) :
              (Over.mk (Limits.Sigma.desc (fun a => (ls a).hom)) : Over X) ⟶
                Over.mk (Limits.coprod.desc (legs none).hom
                  (Limits.Sigma.desc (fun a => (ls a).hom)))))
            ≫ (overSigmaOptionIso legs).inv := by
        apply Over.OverMorphism.ext
        simp only [coprodOverIncl, overSigmaOptionIso, Over.isoMk_inv_left, Over.comp_left,
          Over.homMk_left, sigmaOptionIso, Category.assoc]
        erw [Limits.coprod.inr_desc, Limits.Sigma.ι_desc]
      simp only [Category.assoc]
      rw [piOptionIso_inv_π_some, Limits.prod.map_snd_assoc]
      erw [Limits.prod.lift_snd_assoc, coprodToProdMap_comp_π F ls a]
      rw [heq, pushPullMap_comp, pushPullMap_comp]
      rfl
  rw [hcanon]
  infer_instance

/-- The comparison map `coprodToProdMap` is an isomorphism for every finite index, by
`Finite.induction_empty_option` through the three steps above. -/
private theorem isIso_coprodToProdMap (F : X.Modules) {ι : Type u} [Finite ι]
    (legs : ι → Over X) : IsIso (coprodToProdMap F legs) := by
  revert legs
  refine Finite.induction_empty_option
    (P := fun t : Type u => ∀ legs : t → Over X, IsIso (coprodToProdMap F legs)) ?_ ?_ ?_ ι
  · intro α β e ih legs
    exact coprodToProd_isIso_of_equiv F e ih legs
  · intro legs
    exact pushPull_coprod_prod_empty F legs
  · intro α _ ih legs
    exact coprodToProd_isIso_option F ih legs

/-- Push–pull on a finite coproduct of legs is the product of the per-leg push–pulls, in
canonical `Pi.lift`-of-push–pull-maps form.  Project-local (blueprint `lem:pushPull_coprod_prod`). -/
noncomputable def pushPull_coprod_prod (F : X.Modules) {ι : Type u} [Finite ι]
    (legs : ι → Over X) :
    pushPullObj F (Over.mk (Limits.Sigma.desc (fun i => (legs i).hom))) ≅
      ∏ᶜ fun i => pushPullObj F (legs i) :=
  haveI := isIso_coprodToProdMap F legs
  asIso (coprodToProdMap F legs)

/- Planner strategy:
Goal: `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))` in `X.Modules`.
where `Y_p = (coverCechNerveOver 𝒰).obj (op (mk p))`.

This is THE new-infra leaf. The key observation is that, although the opens `U_σ ⊆ X` OVERLAP
inside `X`, they are DISJOINT as components of the coproduct scheme `Y_p = ∐_σ U_σ`.

Route:
(a) TRANSPORT via `cechBackbone_left_sigma`: by the iso from Stub 1, we may work with the
    coproduct `∐_σ Over.mk j_σ` instead of `Y_p`.

(b) BUILD comparison map:
    `pushPullObj F Y_p ⟶ ∏_σ pushPullObj F (Over.mk j_σ)`
    from the projections `pushPullMap F (ι_σ) : pushPullObj F Y_p ⟶ pushPullObj F (Over.mk j_σ)`
    induced by the coproduct inclusions `ι_σ : Over.mk j_σ ⟶ Y_p` (going backwards via
    the pushPullFunctor, which is contravariant on `Over X`).

(c) CHECK iso via `Scheme.Modules.toPresheaf`:
    The forgetful functor `Scheme.Modules.toPresheaf = SheafOfModules.forget ⋙
    PresheafOfModules.toPresheaf ...` is faithful, reflects isos, and preserves limits
    (`Sheaf.lean:75–78`). So it suffices to verify the comparison is an iso at the
    `Ab`-presheaf level.

(d) PRESHEAF-LEVEL ISO: on `Ab`-presheaves, this is the indexed disjoint-union decomposition.
    Since the components of `∐_σ U_σ` are disjoint in the coproduct topology:
    * Iterate the binary `TopCat.Sheaf.isProductOfDisjoint` (Lean name: same) over the
      finite index set `{σ : Fin(p+1) → 𝒰.I₀}`.
    * Or use `Scheme.coprodPresheafObjIso` (sections over a binary coproduct scheme = product)
      as the binary building block and iterate.
    The result: for any open `W` in `Y_p`, `(q_p^* F).val.obj (op W) ≅ ∏_σ (j_σ^* F).val.obj (op (W_σ))`
    where `W_σ = (ι_σ)⁻¹W` is the trace on the σ-component.

(e) TRANSPORT back through `toPresheaf` to get the iso in `X.Modules`.

Key Mathlib anchors:
- `TopCat.Sheaf.isProductOfDisjoint` (Topology/Sheaves/SheafCondition/PairwiseIntersections.lean)
- `Scheme.coprodPresheafObjIso` (AlgebraicGeometry/Limits.lean)
- `SheafOfModules.forget` faithfulness and iso-reflection (`Sheaf.lean:75–78`)

Difficulty: HARD (genuine new sheaf infra — the single new-infra leaf of the chain). -/
-- Instance synthesis for the three chained `pushPullObjCongr`/`pushPull_coprod_prod` isos over the
-- Čech backbone (`HasProduct`/`HasCoproduct` on the `Fin (p+1) → 𝒰.I₀`-indexed slice families)
-- exceeds the default `synthInstance` budget; bump it for this assembly.
set_option synthInstance.maxHeartbeats 800000 in
noncomputable def pushPull_sigma_iso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (p : ℕ) :
    pushPullObj F ((coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p))) ≅
    ∏ᶜ fun σ : Fin (p + 1) → 𝒰.I₀ =>
      pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))) :=
  -- The backbone `Y_p` is the coproduct `∐_σ Over.mk j_σ` (Stub 1); transport the push–pull
  -- object across that iso and the `overSigmaDescIso` identification of `∐` with the descent
  -- object, then apply the finite coproduct→product decomposition `pushPull_coprod_prod`.
  let legs : (Fin (p + 1) → 𝒰.I₀) → Over X :=
    fun σ => Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))
  pushPullObjCongr F (cechBackbone_left_sigma 𝒰 p) ≪≫
    pushPullObjCongr F (overSigmaDescIso (fun σ => (legs σ).hom)) ≪≫
    pushPull_coprod_prod F legs

/-! ## Stub 3 — Per-leg section identification -/

/- Planner strategy:
Goal: `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ∩ V, F)` as `Ab` objects,
where `j_σ = Scheme.Opens.ι (coverInterOpen 𝒰 σ) : (coverInterOpen 𝒰 σ).toScheme ⟶ X`.

Three off-the-shelf identifications, chained:

(1) PUSHFORWARD SECTIONS = PREIMAGE SECTIONS (`pushforward_obj_obj`, `rfl`, Sheaf.lean:155):
    `Γ(V, (j_σ)_* N) = Γ(j_σ⁻¹V, N)` for any `N : (coverInterOpen 𝒰 σ).toScheme.Modules`.
    Apply to `N = (j_σ)^* F = Scheme.Modules.pullback j_σ |>.obj F`.

(2) PULLBACK ALONG OPEN IMMERSION = RESTRICTION (`restrictFunctorIsoPullback`, Sheaf.lean:371):
    `(j_σ)^* F ≅ F.restrict j_σ` as `(coverInterOpen 𝒰 σ).toScheme.Modules` objects.
    This is already used in `QcohRestrictBasicOpen.lean:113–114,248`.

(3) SECTIONS OF RESTRICTION = SECTIONS OF IMAGE-PREIMAGE (`restrict_obj`, `rfl`, Sheaf.lean:328):
    `Γ(W, F.restrict j_σ) = Γ(j_σ ''ᵁ W, F)` for any `W` in the source scheme.
    Applied to `W = j_σ⁻¹V`: `j_σ ''ᵁ (j_σ⁻¹V) = U_σ ∩ V` (since `j_σ` is an open
    immersion: image-of-preimage = intersection with image = `U_σ ∩ V`).

Compose (1)+(2)+(3): `Γ(V, (j_σ)_*(j_σ)^*F) = Γ(j_σ⁻¹V, (j_σ)^*F) ≅ Γ(j_σ⁻¹V, F.restrict j_σ)
= Γ(j_σ ''ᵁ (j_σ⁻¹V), F) = Γ(U_σ ∩ V, F)`.

Key Lean names:
- `Scheme.Modules.pushforward_obj_obj` (rfl)
- `Scheme.Modules.restrictFunctorIsoPullback`
- `Scheme.Modules.restrict_obj` (rfl)
- `Opens.image_preimage` or `IsOpenImmersion.image_preimage_eq_inf` for the final equality

Difficulty: LOW (three off-the-shelf steps, two of them rfl). -/
noncomputable def pushPull_leg_sections (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) {p : ℕ} (σ : Fin (p + 1) → 𝒰.I₀)
    (V : TopologicalSpace.Opens X) :
    ((SheafOfModules.forget X.ringCatSheaf).obj
          (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))).presheaf.obj
        (Opposite.op V) ≅
    ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op (coverInterOpen 𝒰 σ ⊓ V)) :=
  -- `j` is the open immersion of the intersection open `U_σ = coverInterOpen 𝒰 σ`.
  -- `Γ(V, j_*j^*F) = Γ(j⁻¹V, j^*F) ≅ Γ(j⁻¹V, F.restrict j) = Γ(j''ᵁj⁻¹V, F) = Γ(U_σ ⊓ V, F)`.
  let U := coverInterOpen 𝒰 σ
  let j : (Scheme.Opens.toScheme U) ⟶ X := Scheme.Opens.ι U
  -- pullback-along-open-immersion ≅ restriction, applied to `F`
  ((Scheme.Modules.toPresheaf (Scheme.Opens.toScheme U)).mapIso
      ((Scheme.Modules.restrictFunctorIsoPullback j).app F).symm).app
    (Opposite.op (j ⁻¹ᵁ V)) ≪≫
  eqToIso (by
    -- `Γ(F.restrict j, j⁻¹V) = Γ(F, j ''ᵁ j⁻¹V)` by `restrict_obj` (rfl); rewrite the open.
    change ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op (j ''ᵁ (j ⁻¹ᵁ V))) = _
    rw [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι])

/-! ## Stub 4 — Degreewise section identification of the Čech backbone -/

/- Planner strategy:
Goal: `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(U_σ ∩ V, F)` as `Ab` objects.

Assemble three pieces in sequence:

(A) PRODUCT DECOMPOSITION (`pushPull_sigma_iso`, Stub 2):
    `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)`.

(B) EVALUATION PRESERVES PRODUCTS (`SheafOfModules.evaluationPreservesLimitsOfShape`,
    `Algebra/Category/ModuleCat/Sheaf/Limits.lean:85`):
    `Γ(V, ∏_σ N_σ) ≅ ∏_σ Γ(V, N_σ)`.
    Applied here: `Γ(V, ∏_σ pushPullObj F (Over.mk j_σ)) ≅ ∏_σ Γ(V, pushPullObj F (Over.mk j_σ))`.

(C) PER-LEG IDENTIFICATION (`pushPull_leg_sections`, Stub 3):
    `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ∩ V, F)` for each σ.

Chain (A)+(B)+(C) using natural isomorphisms + pointwise composition.

Key Lean names:
- `pushPull_sigma_iso` (Stub 2)
- `SheafOfModules.evaluationPreservesLimitsOfShape` (or `preservesLimitsOfShape_evaluation`)
- `pushPull_leg_sections` (Stub 3)
- `Functor.mapIso` to apply the evaluation functor to the iso from (A)

Difficulty: LOW (assembly of Stubs 2 and 3 plus an off-the-shelf limits lemma). -/
noncomputable def pushPull_eval_prod_iso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (p : ℕ) (V : TopologicalSpace.Opens X) :
    ((SheafOfModules.forget X.ringCatSheaf).obj
          (pushPullObj F
            ((coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p))))).presheaf.obj
        (Opposite.op V) ≅
    ∏ᶜ fun σ : Fin (p + 1) → 𝒰.I₀ =>
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op (coverInterOpen 𝒰 σ ⊓ V)) :=
  -- The evaluation-at-`V` functor `X.Modules ⥤ Ab` (forget to a presheaf of abelian groups,
  -- then evaluate at `V`); it preserves the finite product.
  by
  let Ev := (CategoryTheory.evaluation (TopologicalSpace.Opens X)ᵒᵖ
    (Ab.{u})).obj (Opposite.op V)
  let E : X.Modules ⥤ Ab.{u} := Scheme.Modules.toPresheaf X ⋙ Ev
  haveI hT : Limits.PreservesLimitsOfShape
      (Discrete (Fin (p + 1) → 𝒰.I₀)) (Scheme.Modules.toPresheaf X) := inferInstance
  haveI : Limits.HasLimitsOfShape (Discrete (Fin (p + 1) → 𝒰.I₀)) (Ab.{u}) :=
    inferInstance
  haveI hE2 : Limits.PreservesLimitsOfShape (Discrete (Fin (p + 1) → 𝒰.I₀)) Ev :=
    Limits.evaluation_preservesLimitsOfShape _
  haveI : Limits.PreservesLimitsOfShape (Discrete (Fin (p + 1) → 𝒰.I₀)) E :=
    @Limits.comp_preservesLimitsOfShape _ _ _ _ (Discrete (Fin (p + 1) → 𝒰.I₀)) _ _ _
      (Scheme.Modules.toPresheaf X) Ev hT hE2
  exact E.mapIso (pushPull_sigma_iso 𝒰 F p) ≪≫
    Limits.PreservesProduct.iso E
      (fun σ : Fin (p + 1) → 𝒰.I₀ =>
        pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≪≫
    Limits.Pi.mapIso (fun σ => pushPull_leg_sections 𝒰 F σ V)

/-! ## Stub 5 — Complex-level iso: evaluated augmented Čech section complex ≅ augmented concrete complex -/

/-- The concrete (non-augmented) section Čech complex over `V` for the restricted cover.
Used as the base for the augmented complex in `cechSection_complex_iso` and
`cechSection_contractible`. -/
noncomputable abbrev sectionCechComplexV (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (V : TopologicalSpace.Opens X) : CochainComplex Ab.{u} ℕ :=
  sectionCechComplex (fun i : 𝒰.I₀ => coverOpen 𝒰 i ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F)

/-! ### Structural helpers reducing the augmented complex iso to a non-augmented one. -/

/-- Applying an additive functor `Φ` degreewise to a cochain complex commutes with
augmenting: `Φ(C.augment f) ≅ (Φ C).augment (Φ f)`, with identity components.  This peels
the augmentation node off the evaluated complex `D` so the remaining identification is between
the *non-augmented* complexes. -/
noncomputable def mapHC_augment_iso {V₁ V₂ : Type*} [Category V₁] [Category V₂]
    [Preadditive V₁] [Preadditive V₂] (Φ : V₁ ⥤ V₂) [Φ.Additive]
    (C : CochainComplex V₁ ℕ) {Y : V₁} (f : Y ⟶ C.X 0) (w : f ≫ C.d 0 1 = 0) :
    (Φ.mapHomologicalComplex (ComplexShape.up ℕ)).obj (C.augment f w) ≅
      ((Φ.mapHomologicalComplex (ComplexShape.up ℕ)).obj C).augment (Φ.map f)
        (by rw [← Φ.map_comp, w, Φ.map_zero]) :=
  HomologicalComplex.Hom.isoOfComponents
    (fun i => match i with | 0 => Iso.refl _ | _ + 1 => Iso.refl _)
    (fun i j hij => by
      obtain rfl : i + 1 = j := hij
      match i with
      | 0 => simp [HomologicalComplex.augment]
      | n + 1 => simp [HomologicalComplex.augment])

/- Planner strategy:
Goal: `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` as `CochainComplex AddCommGrpCat ℕ`, where
  - `D = (GV.mapHomologicalComplex cc).obj Kp` is the evaluated augmented Čech section complex
    (GV = `PresheafOfModules.toPresheaf ⋙ evaluation(op V)`,
     Kp = `(SheafOfModules.forget ⋙ PresheafOfModules.restrictScalars (𝟙 ·)).mapHC.obj K`,
     K = `cechAugmentedComplex 𝒰 F`);
  - `sectionCechComplexV 𝒰 F V = sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) Fp` is the
    non-augmented concrete section Čech complex (with `Fp = (SheafOfModules.forget X.ringCatSheaf).obj F`);
  - `ε : Fp.presheaf.obj (op V) ⟶ (sectionCechComplexV 𝒰 F V).X 0` is the augmentation map
    (the restriction `t ↦ (t|_{U'_i})_i`); and
  - `hε : ε ≫ (sectionCechComplexV 𝒰 F V).d 0 1 = 0`.

Route (promote degreewise isos to a complex iso):

(A) DEGREEWISE OBJECT ISO: `pushPull_eval_prod_iso` (Stub 4) gives, for each `p`,
    `D.X (p+1) ≅ (sectionCechComplexV 𝒰 F V).X p` as `Ab` objects — both equal `∏_σ Γ(U_σ ∩ V, F)`;
    and `D.X 0 = Fp.presheaf.obj (op V)` matches the augmentation object.

(B) DIFFERENTIAL MATCH: The differential of `D'` is, read through `sectionCechProductEquiv`
    (`CechAcyclic.lean:1438`), the alternating sum `∑_i (-1)^i • sectionCechFaceRestr(σ,i)`
    (`sectionCech_objD_apply`, `CechAcyclic.lean:1513`). The differential of `D` is the
    evaluation-at-`V` of the Čech-nerve coface maps; under the degreewise identification
    (A), each coface of `D` becomes the corresponding face restriction of `D'`. REUSE
    `sectionCech_objD_apply` rather than rebuilding the alternating-sum bookkeeping.

(C) ASSEMBLE: Build the `HomologicalComplex.mkIso` (or `HomologicalComplex.Hom` iso) from
    the degreewise components, checking the `comm` condition via the differential match.

AMBIGUITY FLAG: The type of `Kp` in the definition of `D` uses
`PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)` as a technical adapter between
`SheafOfModules.forget` landing in `PresheafOfModules X.ringCatSheaf.val` and the
`PresheafOfModules.toPresheaf X.ringCatSheaf.obj` that the evaluation uses. The prover
should verify this adapter type carefully; if the exact path differs from the scaffold,
adjust `Kp` accordingly. Checking how `hSec` in `CechAugmentedResolution.lean:185-205`
constructs `Kp` provides the canonical reference.

Key Lean names:
- `pushPull_eval_prod_iso` (Stub 4)
- `sectionCech_objD_apply` (CechAcyclic.lean:1513)
- `sectionCechProductEquiv` (CechAcyclic.lean:1438)
- `HomologicalComplex.mkIso` or `HomologicalComplex.Hom.isoOfComponents`

Difficulty: MEDIUM (assembly + differential bookkeeping via sectionCech_objD_apply). -/
noncomputable def cechSection_complex_iso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (V : TopologicalSpace.Opens X)
    (ε : ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (Opposite.op V) ⟶
         (sectionCechComplexV 𝒰 F V).X 0)
    (hε : ε ≫ (sectionCechComplexV 𝒰 F V).d 0 1 = 0) :
    let α : X.ringCatSheaf.obj ⟶ X.ringCatSheaf.obj := 𝟙 X.ringCatSheaf.obj
    let cc := ComplexShape.up ℕ
    let K := cechAugmentedComplex 𝒰 F
    let Kp := ((SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α).mapHomologicalComplex cc).obj K
    let GV :=
      PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)
    let D := (GV.mapHomologicalComplex cc).obj Kp
    D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε :=
  sorry

/-! ## Stub 6 — Contracting homotopy on the augmented concrete section Čech complex -/

/- Planner strategy:
Goal: `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`
assuming `V ≤ coverOpen 𝒰 i_fix`, where
  `sectionCechComplexV 𝒰 F V = sectionCechComplex (fun i : 𝒰.I₀ => coverOpen 𝒰 i ⊓ V) Fp`
is the non-augmented complex and `ε`, `hε` are the augmentation data.

This is PURELY COMBINATORIAL — no affine vanishing, no qcoh, no tilde.

Route:

(A) IDENTIFY THE FAMILY: `U'_σ := coverInterOpen 𝒰 σ ⊓ V = ⨅ k, (coverOpen 𝒰 (σ k) ⊓ V)`.
    `D'` is the alternating coface complex of the cosimplicial object
    `sectionCechCosimplicial (fun i => coverOpen 𝒰 i ⊓ V) Fp`.

(B) MAXIMUM PROPERTY: Since `V ≤ coverOpen 𝒰 i_fix`, we have
    `coverOpen 𝒰 i_fix ⊓ V = V`. Therefore `U'_{i_fix..σ} = U'_σ` for any `σ`
    (prepending `i_fix` does not shrink the open). Equivalently, the prepend map
    `σ ↦ Fin.cons i_fix σ` is the IDENTITY at the coefficient level:
    for each multi-index `σ : Fin m → 𝒰.I₀`:
      `⨅ k, (coverOpen 𝒰 (Fin.cons i_fix σ k) ⊓ V) = ⨅ k, (coverOpen 𝒰 (σ k) ⊓ V)`.
    This is because the `k=0` factor is `coverOpen 𝒰 i_fix ⊓ V = V`, which is ≥ every
    other factor (since `U'_j = coverOpen 𝒰 j ⊓ V ≤ V`); hence the iInf is unchanged.

(C) INSTANTIATE THE DEPENDENT ENGINE: Set
    `A m σ := Fp.presheaf.obj (op (⨅ k, (coverOpen 𝒰 (σ k) ⊓ V)))`
    `δ m σ j := F.presheaf.map (homOfLE (le_iInf ...)).op`  (face restriction)
    `c m σ := 𝟙` (or the identity map via the equality from (B))
    Then the Dependent engine hypotheses hold:
    * `hu`: unit identity `c ∘ δ₀ = id` — follows from (B) (prepending `i_fix` at position 0
      recovers the same open, so the restriction is the identity).
    * `hsh`: shift identity `c ∘ δ_{k+1} = δ_k ∘ c` — follows from `cons_comp_succAbove_succ`.
    Call `CombinatorialCech.depHomotopy i_fix δ c` to get the homotopy maps, and
    `CombinatorialCech.depHomotopy_spec` to obtain `d∘h + h∘d = id`.

(D) PACKAGE: Wrap the pointwise identity `depHomotopy_spec` as a `Homotopy (𝟙 D') 0` using
    `CochainComplex.homotopyOfEq` or by constructing the `Homotopy` directly from the maps.

Key Lean names:
- `CombinatorialCech.depDiff` (CechAcyclic.lean, namespace `CombinatorialCech`)
- `CombinatorialCech.depHomotopy`
- `CombinatorialCech.depHomotopy_spec`
- `sectionCechCosimplicial`, `sectionCechComplex` (PresheafCech.lean)
- `le_coverInterOpen_iff` (FreePresheafComplex.lean:729)

NOTE: The `\uses{lem:cech_acyclic_affine}` edge in the blueprint is ONLY the Lean home of
the `Dependent` engine — NOT a math dependency. Invoke no affine vanishing.

Difficulty: MEDIUM (combinatorial assembly; the Dependent engine does the heavy lifting). -/
noncomputable def cechSection_contractible (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (V : TopologicalSpace.Opens X)
    (i_fix : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i_fix)
    (ε : ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (Opposite.op V) ⟶
         (sectionCechComplexV 𝒰 F V).X 0)
    (hε : ε ≫ (sectionCechComplexV 𝒰 F V).d 0 1 = 0) :
    Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0 :=
  sorry

end AlgebraicGeometry
