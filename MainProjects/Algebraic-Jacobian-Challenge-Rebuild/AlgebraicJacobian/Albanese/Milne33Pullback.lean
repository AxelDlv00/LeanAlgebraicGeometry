/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Albanese.RationalMapFunctionField

/-!
# Milne Lemma 3.3, Substep 3: the spreading criterion for rational-map domains

Per `informal/m33-spec.md` (D4). The heart is the **abstract spreading
criterion** `Scheme.RationalMap.mem_domain_of_fromSpecStalk`: for a rational
map `F : Y ⤏ Z` of `S`-schemes out of an integral scheme with `Z` locally of
finite type over `S`, a point `P ∈ Y` lies in the domain of `F` as soon as
the generic morphism `Spec K(Y) ⟶ Z` of `F` factors through
`Spec 𝒪_{Y,P} ⟶ Z` compatibly with the structure morphisms. This rides on
Mathlib's spreading-out engine (`Scheme.PartialMap.ofFromSpecStalk`,
`spread_out_of_isGermInjective'`) and the germ-injectivity of integral
schemes.

Supporting API:

* `Scheme.isGermInjectiveAt_of_isIntegral` — integral schemes are
  germ-injective at every point (instance; feeds the spreading engine).
* `Scheme.Opens.fromSpecStalkOfMem_specializes`,
  `Scheme.PartialMap.fromSpecStalkOfMem_specializes` — the stalk-to-scheme
  morphisms of a partial map are compatible with specialisation inside the
  domain; this is what re-anchors the spread-out morphism at the generic
  point.

Blueprint reference: `lem:milne_codim1_indeterminacy` (Milne, *Abelian
Varieties*, §I.3 Lemma 3.3, pp. 17–18; `abelian-varieties:page-0023/0024`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace IsLocalRing

namespace AlgebraicGeometry

/-- **Integral schemes are germ-injective at every point**: any affine open
`U ∋ x` has `Γ(Y, U)` a domain and `Γ(Y, U) ⟶ 𝒪_{Y,x}` a localization map,
hence injective (`germ_injective_of_isIntegral`). Feeds Mathlib's
spreading-out engine (`spread_out_of_isGermInjective'`). -/
instance (priority := 100) Scheme.isGermInjectiveAt_of_isIntegral
    {Y : Scheme.{u}} [IsIntegral Y] (P : ↥Y) : Y.IsGermInjectiveAt P := by
  obtain ⟨_, ⟨U, hU, rfl⟩, hPU, -⟩ :=
    Y.isBasis_affineOpens.exists_subset_of_mem_open (Set.mem_univ P) isOpen_univ
  exact ⟨⟨U, hPU, hU, germ_injective_of_isIntegral Y P hPU⟩⟩

/-- The stalk-to-subscheme morphisms of an open are compatible with
specialisation: `Spec 𝒪_Q ⟶ Spec 𝒪_P ⟶ U` is `Spec 𝒪_Q ⟶ U` for `Q ⤳ P`
both in `U`. -/
lemma Scheme.Opens.fromSpecStalkOfMem_specializes
    {Y : Scheme.{u}} (U : Y.Opens) {P Q : ↥Y} (hsp : Q ⤳ P)
    (hP : P ∈ U) (hQ : Q ∈ U) :
    Spec.map (Y.presheaf.stalkSpecializes hsp) ≫ U.fromSpecStalkOfMem P hP
      = U.fromSpecStalkOfMem Q hQ := by
  rw [← cancel_mono U.ι, Category.assoc, Scheme.Opens.fromSpecStalkOfMem_ι,
    Scheme.Opens.fromSpecStalkOfMem_ι, Scheme.SpecMap_stalkSpecializes_fromSpecStalk]

/-- The stalk-to-target morphisms of a partial map are compatible with
specialisation inside the domain. -/
lemma Scheme.PartialMap.fromSpecStalkOfMem_specializes
    {Y Z : Scheme.{u}} (g : Y.PartialMap Z) {P Q : ↥Y} (hsp : Q ⤳ P)
    (hP : P ∈ g.domain) (hQ : Q ∈ g.domain) :
    Spec.map (Y.presheaf.stalkSpecializes hsp) ≫ g.fromSpecStalkOfMem hP
      = g.fromSpecStalkOfMem hQ := by
  change Spec.map (Y.presheaf.stalkSpecializes hsp)
      ≫ g.domain.fromSpecStalkOfMem P hP ≫ g.hom
    = g.domain.fromSpecStalkOfMem Q hQ ≫ g.hom
  rw [← Category.assoc, Scheme.Opens.fromSpecStalkOfMem_specializes g.domain hsp hP hQ]

/-- **The abstract spreading criterion.** Let `F : Y ⤏ Z` be a rational map
of `S`-schemes with `Y` integral and `Z` locally of finite type over `S`. If
the generic morphism `Spec K(Y) ⟶ Z` of `F` factors through a morphism
`φ : Spec 𝒪_{Y,P} ⟶ Z` compatible with the structure morphisms, then
`P ∈ Dom F` — `φ` spreads out to a partial map defined at `P` representing
`F` (Milne's "`Φ` is defined at `P` as soon as `𝒪_{G,e}` pulls back into
`𝒪_{Y,P}`", substep 3 of Lemma 3.3). -/
theorem Scheme.RationalMap.mem_domain_of_fromSpecStalk
    {Y Z S : Scheme.{u}} [IsIntegral Y] (qY : Y ⟶ S) (qZ : Z ⟶ S)
    [LocallyOfFiniteType qZ] (F : Y.RationalMap Z) (P : ↥Y)
    (φ : Spec (Y.presheaf.stalk P) ⟶ Z)
    (hcomp : φ ≫ qZ = Y.fromSpecStalk P ≫ qY)
    (hgen : Spec.map (Y.presheaf.stalkSpecializes (genericPoint_specializes P)) ≫ φ
      = F.fromFunctionField) :
    P ∈ F.domain := by
  set ψP := Scheme.PartialMap.ofFromSpecStalk qY qZ φ hcomp with hψdef
  have hPψ : P ∈ ψP.domain := Scheme.PartialMap.mem_domain_ofFromSpecStalk qY qZ φ hcomp
  -- The generic point lies in both domains.
  have hηψ : genericPoint ↥Y ∈ ψP.domain :=
    (genericPoint_specializes _).mem_open ψP.domain.2
      ψP.dense_domain.nonempty.choose_spec
  obtain ⟨g, hg⟩ := F.exists_rep
  have hηg : genericPoint ↥Y ∈ g.domain :=
    (genericPoint_specializes _).mem_open g.domain.2
      g.dense_domain.nonempty.choose_spec
  -- Both restrict to the generic morphism of `F` at the generic point.
  have hψη : ψP.fromSpecStalkOfMem hηψ = F.fromFunctionField := by
    have hφ : ψP.fromSpecStalkOfMem hPψ = φ :=
      Scheme.PartialMap.fromSpecStalkOfMem_ofFromSpecStalk qY qZ φ hcomp
    rw [← Scheme.PartialMap.fromSpecStalkOfMem_specializes ψP
      (genericPoint_specializes P) hPψ hηψ, hφ, hgen]
  have hgη : g.fromSpecStalkOfMem hηg = F.fromFunctionField := by
    rw [← hg, Scheme.RationalMap.fromFunctionField_toRationalMap]
  -- Hence the spread-out partial map represents `F`, and `P` is in its domain.
  have hequiv : ψP.equiv g :=
    Scheme.PartialMap.equiv_of_fromSpecStalkOfMem_eq ψP g hηψ hηg
      (hψη.trans hgη.symm)
  exact Scheme.RationalMap.mem_domain.mpr
    ⟨ψP, hPψ, (Scheme.PartialMap.toRationalMap_eq_iff.mpr hequiv).trans hg⟩

/-! ## §2. The germ-range criterion

The concrete form of substep 3: the generic germ pullback
`Λ = germ_γ ≫ stalkPullback F : Γ(Z, V) ⟶ K(Y)` of an affine open `V`
containing the generic image `γ` lands in `𝒪_{Y,P} ⊆ K(Y)` for all sections
iff `F` is defined at `P` (we prove the substantive "if" direction). -/

/-- The generic morphism of a rational map factors through any affine open
containing the generic image: `Spec.map (germ_γ ≫ stalkPullback) ≫ V.fromSpec`
is `F.fromFunctionField`. -/
lemma Scheme.RationalMap.specMap_germ_stalkPullback_fromSpec
    {Y Z : Scheme.{u}} [IsIntegral Y] (F : Y.RationalMap Z)
    {V : Z.Opens} (hV : IsAffineOpen V)
    (hγV : F.fromFunctionField (closedPoint Y.functionField) ∈ V) :
    Spec.map (Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
        ≫ F.stalkPullback) ≫ hV.fromSpec
      = F.fromFunctionField := by
  have hSP : F.stalkPullback = Scheme.stalkClosedPointTo F.fromFunctionField := rfl
  rw [Spec.map_comp, Category.assoc,
    show Spec.map (Z.presheaf.germ V
        (F.fromFunctionField (closedPoint Y.functionField)) hγV) ≫ hV.fromSpec
      = hV.fromSpecStalk hγV from rfl,
    IsAffineOpen.fromSpecStalk_eq_fromSpecStalk, hSP,
    Scheme.Spec_stalkClosedPointTo_fromSpecStalk]

/-- Routing a `Spec`-shaped morphism through an affine base: composing
`Spec.map ρ ≫ hU.fromSpec` with a structure morphism `q : W ⟶ S` into an
affine scheme is again `Spec`-shaped, with ring map `q.appLE ⊤ U _ ≫ ρ`. -/
lemma specMap_fromSpec_comp {W S : Scheme.{u}} [IsAffine S] (q : W ⟶ S)
    {U : W.Opens} (hU : IsAffineOpen U) {R : CommRingCat.{u}} (ρ : Γ(W, U) ⟶ R) :
    (Spec.map ρ ≫ hU.fromSpec) ≫ q
      = Spec.map (q.appLE ⊤ U (by simp) ≫ ρ) ≫ (isAffineOpen_top S).fromSpec := by
  rw [Spec.map_comp, Category.assoc, Category.assoc,
    IsAffineOpen.SpecMap_appLE_fromSpec q (isAffineOpen_top S) hU]

/-- **The germ-range spreading criterion (Milne 3.3, substep 3).** Let
`F : Y ⤏ Z` be a rational map of schemes over an affine base `S`, with `Y`
integral and `Z` locally of finite type over `S`, and let `V` be an affine
open of `Z` containing the generic image `γ = F(η_Y)`. If every section
`s ∈ Γ(Z, V)` has generic germ pullback `Λ s = germ_γ(s)|_η ∈ K(Y)` lying in
the image of `𝒪_{Y,P} ⟶ K(Y)`, then `F` is defined at `P`. -/
theorem Scheme.RationalMap.mem_domain_of_forall_germ_mem_range
    {Y Z S : Scheme.{u}} [IsIntegral Y] [IsAffine S] (qY : Y ⟶ S) (qZ : Z ⟶ S)
    [LocallyOfFiniteType qZ] (F : Y.RationalMap Z)
    (hFover : F.fromFunctionField ≫ qZ
      = Y.fromSpecStalk (genericPoint ↥Y) ≫ qY)
    {V : Z.Opens} (hV : IsAffineOpen V)
    (hγV : F.fromFunctionField (closedPoint Y.functionField) ∈ V) (P : ↥Y)
    (H : ∀ s : Γ(Z, V),
      (Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
        ≫ F.stalkPullback) s
      ∈ (algebraMap (Y.presheaf.stalk P) Y.functionField).range) :
    P ∈ F.domain := by
  have hinj : Function.Injective (algebraMap (Y.presheaf.stalk P) Y.functionField) :=
    IsFractionRing.injective _ _
  -- The corestriction `α : Γ(Z, V) ⟶ 𝒪_{Y,P}` of the germ pullback through the
  -- stalk range, packaged existentially so that all later rewriting happens on
  -- an opaque variable.
  obtain ⟨α, hα⟩ : ∃ α : Γ(Z, V) ⟶ Y.presheaf.stalk P,
      α ≫ CommRingCat.ofHom (algebraMap (Y.presheaf.stalk P) Y.functionField)
        = Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
          ≫ F.stalkPullback := by
    let e : (Y.presheaf.stalk P) ≃+*
        ((algebraMap (Y.presheaf.stalk P) Y.functionField).range) :=
      RingEquiv.ofBijective
        (algebraMap (Y.presheaf.stalk P) Y.functionField).rangeRestrict
        ⟨fun a b h => hinj (by simpa using congrArg Subtype.val h),
          (algebraMap (Y.presheaf.stalk P) Y.functionField).rangeRestrict_surjective⟩
    refine ⟨CommRingCat.ofHom (e.symm.toRingHom.comp
      ((Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
        ≫ F.stalkPullback).hom.codRestrict _ H)), ?_⟩
    ext s
    exact congrArg Subtype.val (e.apply_symm_apply ⟨_, H s⟩)
  -- The canonical map `𝒪_{Y,P} ⟶ K(Y)` is the stalk-specialisation map.
  have hspec : Y.presheaf.stalkSpecializes (genericPoint_specializes P)
      = CommRingCat.ofHom (algebraMap (Y.presheaf.stalk P) Y.functionField) := by
    rw [RingHom.algebraMap_toAlgebra, CommRingCat.ofHom_hom]
  -- Property 1: the generic factorisation.
  have hgen : Spec.map (Y.presheaf.stalkSpecializes (genericPoint_specializes P))
      ≫ Spec.map α ≫ hV.fromSpec = F.fromFunctionField := by
    have e2 : α ≫ Y.presheaf.stalkSpecializes (genericPoint_specializes P)
        = Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
          ≫ F.stalkPullback := by
      rw [hspec]; exact hα
    calc Spec.map (Y.presheaf.stalkSpecializes (genericPoint_specializes P))
        ≫ Spec.map α ≫ hV.fromSpec
        = Spec.map (α ≫ Y.presheaf.stalkSpecializes (genericPoint_specializes P))
            ≫ hV.fromSpec := by
          rw [← Category.assoc, ← Spec.map_comp]
      _ = Spec.map (Z.presheaf.germ V
              (F.fromFunctionField (closedPoint Y.functionField)) hγV
            ≫ F.stalkPullback) ≫ hV.fromSpec :=
          congrArg (Spec.map · ≫ hV.fromSpec) e2
      _ = F.fromFunctionField :=
          Scheme.RationalMap.specMap_germ_stalkPullback_fromSpec F hV hγV
  -- Property 2: compatibility over the affine base.
  have hcomp : (Spec.map α ≫ hV.fromSpec) ≫ qZ = Y.fromSpecStalk P ≫ qY := by
    obtain ⟨_, ⟨U', hU', rfl⟩, hPU', -⟩ :=
      Y.isBasis_affineOpens.exists_subset_of_mem_open (Set.mem_univ P) isOpen_univ
    have hηU' : genericPoint ↥Y ∈ U' :=
      (genericPoint_specializes P).mem_open U'.2 hPU'
    -- The generic-point identity, from the over-compatibility of `F`.
    have h5 : Spec.map (qZ.appLE ⊤ V (by simp)
          ≫ (Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
            ≫ F.stalkPullback)) ≫ (isAffineOpen_top S).fromSpec
        = Spec.map (qY.appLE ⊤ U' (by simp)
            ≫ Y.presheaf.germ U' (genericPoint ↥Y) hηU')
          ≫ (isAffineOpen_top S).fromSpec := by
      rw [← specMap_fromSpec_comp qZ hV,
        ← specMap_fromSpec_comp qY hU' (Y.presheaf.germ U' (genericPoint ↥Y) hηU'),
        Scheme.RationalMap.specMap_germ_stalkPullback_fromSpec F hV hγV,
        show Spec.map (Y.presheaf.germ U' (genericPoint ↥Y) hηU') ≫ hU'.fromSpec
          = Y.fromSpecStalk (genericPoint ↥Y) from
          (show Spec.map (Y.presheaf.germ U' _ hηU') ≫ hU'.fromSpec
            = hU'.fromSpecStalk hηU' from rfl).trans
            (IsAffineOpen.fromSpecStalk_eq_fromSpecStalk hU' hηU'), hFover]
    have h6 : qZ.appLE ⊤ V (by simp)
          ≫ (Z.presheaf.germ V (F.fromFunctionField (closedPoint Y.functionField)) hγV
            ≫ F.stalkPullback)
        = qY.appLE ⊤ U' (by simp) ≫ Y.presheaf.germ U' (genericPoint ↥Y) hηU' :=
      Spec.map_injective ((cancel_mono _).mp h5)
    have hg2 : Y.presheaf.germ U' P hPU'
          ≫ Y.presheaf.stalkSpecializes (genericPoint_specializes P)
        = Y.presheaf.germ U' (genericPoint ↥Y) hηU' :=
      Y.presheaf.germ_stalkSpecializes hPU' (genericPoint_specializes P)
    -- The ring-level identity at `P`, by cancelling the injective `𝒪_P ⟶ K(Y)`.
    haveI : Mono (CommRingCat.ofHom
        (algebraMap (Y.presheaf.stalk P) Y.functionField)) :=
      ConcreteCategory.mono_of_injective _ hinj
    have hRG : qZ.appLE ⊤ V (by simp) ≫ α
        = qY.appLE ⊤ U' (by simp) ≫ Y.presheaf.germ U' P hPU' := by
      refine (cancel_mono (CommRingCat.ofHom
        (algebraMap (Y.presheaf.stalk P) Y.functionField))).mp ?_
      calc (qZ.appLE ⊤ V (by simp) ≫ α)
            ≫ CommRingCat.ofHom (algebraMap (Y.presheaf.stalk P) Y.functionField)
          = qZ.appLE ⊤ V (by simp) ≫ (α ≫ CommRingCat.ofHom
              (algebraMap (Y.presheaf.stalk P) Y.functionField)) :=
            Category.assoc _ _ _
        _ = qZ.appLE ⊤ V (by simp)
              ≫ (Z.presheaf.germ V
                  (F.fromFunctionField (closedPoint Y.functionField)) hγV
                ≫ F.stalkPullback) := whisker_eq _ hα
        _ = qY.appLE ⊤ U' (by simp)
              ≫ Y.presheaf.germ U' (genericPoint ↥Y) hηU' := h6
        _ = qY.appLE ⊤ U' (by simp)
              ≫ (Y.presheaf.germ U' P hPU'
                ≫ Y.presheaf.stalkSpecializes (genericPoint_specializes P)) :=
            whisker_eq _ hg2.symm
        _ = qY.appLE ⊤ U' (by simp)
              ≫ (Y.presheaf.germ U' P hPU'
                ≫ CommRingCat.ofHom
                  (algebraMap (Y.presheaf.stalk P) Y.functionField)) :=
            whisker_eq _ (whisker_eq _ hspec)
        _ = (qY.appLE ⊤ U' (by simp) ≫ Y.presheaf.germ U' P hPU')
              ≫ CommRingCat.ofHom
                (algebraMap (Y.presheaf.stalk P) Y.functionField) :=
            (Category.assoc _ _ _).symm
    -- Assemble.
    calc (Spec.map α ≫ hV.fromSpec) ≫ qZ
        = Spec.map (qZ.appLE ⊤ V (by simp) ≫ α)
            ≫ (isAffineOpen_top S).fromSpec := specMap_fromSpec_comp qZ hV α
      _ = Spec.map (qY.appLE ⊤ U' (by simp) ≫ Y.presheaf.germ U' P hPU')
            ≫ (isAffineOpen_top S).fromSpec :=
          congrArg (Spec.map · ≫ (isAffineOpen_top S).fromSpec) hRG
      _ = (Spec.map (Y.presheaf.germ U' P hPU') ≫ hU'.fromSpec) ≫ qY :=
          (specMap_fromSpec_comp qY hU' (Y.presheaf.germ U' P hPU')).symm
      _ = Y.fromSpecStalk P ≫ qY :=
          congrArg (· ≫ qY)
            ((show Spec.map (Y.presheaf.germ U' P hPU') ≫ hU'.fromSpec
                = hU'.fromSpecStalk hPU' from rfl).trans
              (IsAffineOpen.fromSpecStalk_eq_fromSpecStalk hU' hPU'))
  exact Scheme.RationalMap.mem_domain_of_fromSpecStalk qY qZ F P
    (Spec.map α ≫ hV.fromSpec) hcomp hgen

end AlgebraicGeometry
