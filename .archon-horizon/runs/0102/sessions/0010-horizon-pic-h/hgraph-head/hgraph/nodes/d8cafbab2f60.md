---
author: sync
content_type: theorem
created: '2026-07-17T16:57:11'
decl: AlgebraicGeometry.Scheme.RationalMap.mem_domain_of_forall_germ_mem_range
docstring: '**The germ-range spreading criterion (Milne 3.3, substep 3).** Let

  `F : Y ⤏ Z` be a rational map of schemes over an affine base `S`, with `Y`

  integral and `Z` locally of finite type over `S`, and let `V` be an affine

  open of `Z` containing the generic image `γ = F(η_Y)`. If every section

  `s ∈ Γ(Z, V)` has generic germ pullback `Λ s = germ_γ(s)|_η ∈ K(Y)` lying in

  the image of `𝒪_{Y,P} ⟶ K(Y)`, then `F` is defined at `P`.'
file: AlgebraicJacobian/Albanese/Milne33Pullback.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.RationalMap.mem_domain_of_forall_germ_mem_range
type: lean
updated: '2026-08-01T09:44:08'
---
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

/-! ## §3. The converse: definedness gives germ-range membership (3-easy)

If a representative `g` of `F` is defined at `Q` with value `g(Q) ∈ V`, the
generic germ pullback of every section of `V` is regular at `Q`: it factors
through `𝒪_{Y,Q}` by the germ-at-the-value pullback of `g` at `Q`. -/