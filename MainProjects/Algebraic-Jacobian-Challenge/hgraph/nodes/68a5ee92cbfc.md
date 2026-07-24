---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp
docstring: '**Sq1 — composition coherence of `SheafOfModules.sheafificationCompPullback`
  (the S1 paste

  square of D3′).** For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and any
  presheaf of

  modules `P` over `X`, the sheafification–pullback comparison of the composite `h
  ≫ f` factors

  through the comparisons of `f` and `h`, conjugated by the sheaf-level pullback pseudofunctor
  iso

  `Scheme.Modules.pullbackComp h f` on the left and the presheaf-level pullback pseudofunctor
  iso

  `PresheafOfModules.pullbackComp φ''_f φ''_h` (sheafified) on the right. Mathlib-absent
  at the pin;

  the S1-foundational composition coherence consumed by `pullbackTensorMap_restrict`.
  It is the

  `sheafificationCompPullback` twin of `pullbackObjUnitToUnit_comp`: both `sheafificationCompPullback`

  isos are `leftAdjointUniq` comparisons of composite adjunctions

  (`sheafificationCompPullback_eq_leftAdjointUniq`),

  so the coherence is proved by the adjunction-mate calculus, transposing under the
  composite

  `A_{h≫f} = (sheafAdj_X).comp (pullbackPushforwardAdjunction (h≫f))`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp
type: lean
updated: '2026-07-25T05:59:05'
---
lemma sheafificationCompPullback_comp {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (P : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app P).hom =
      (Scheme.Modules.pullbackComp h f).inv.app
          ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj P) ≫
        (Scheme.Modules.pullback h).map
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app P).hom ≫
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj P)).hom ≫
        (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
          ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
            (Hom.toRingCatSheafHom h).hom).hom.app P) := by
  -- Work at the natural-transformation level so the middle adjunction absorbs the
  -- sheafification adjunction over `Y`. The local identity instances below provide both
  -- local injectivity and surjectivity needed for the final sheafification whisker.
  haveI : Presheaf.IsLocallyInjective (Opens.grothendieckTopology ↥Z) (𝟙 (Z.ringCatSheaf.obj)) :=
    Presheaf.instIsLocallyInjectiveOfIsIsoFunctorOpposite _ _
  haveI : Presheaf.IsLocallySurjective (Opens.grothendieckTopology ↥Z) (𝟙 (Z.ringCatSheaf.obj)) :=
    Presheaf.isLocallySurjective_of_iso (Opens.grothendieckTopology ↥Z) (𝟙 (Z.ringCatSheaf.obj))
  have key : (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).hom
      = Functor.whiskerLeft (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj))
            (Scheme.Modules.pullbackComp h f).inv ≫
          Functor.whiskerRight
            (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom
            (Scheme.Modules.pullback h) ≫
          Functor.whiskerLeft (PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom)
            (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom ≫
          Functor.whiskerRight
            (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
              (Hom.toRingCatSheafHom h).hom).hom
            (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)) := by
    -- Express the mate cocycle through three instances of
    -- `Adjunction.leftAdjointCompNatTrans_assoc`. The first uses the sheaf pullback leg.
    let adj01 := PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
      (𝟙 X.ringCatSheaf.obj)
    let adj12 := SheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom f)
    let adj23 := SheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom h)
    let adj02 := (PresheafOfModules.pullbackPushforwardAdjunction
        (Hom.toRingCatSheafHom f).hom).comp
      (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.obj))
    let adj13 := SheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom (h ≫ f))
    let adj03 := (PresheafOfModules.pullbackPushforwardAdjunction
        (Hom.toRingCatSheafHom (h ≫ f)).hom).comp
      (PresheafOfModules.sheafificationAdjunction (R := Z.ringCatSheaf)
        (𝟙 Z.ringCatSheaf.obj))
    let τ012 :
        ((SheafOfModules.forget.{u} Y.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Y.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom) ⟶
          (SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f) ⋙
            (SheafOfModules.forget.{u} X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 X.ringCatSheaf.obj))) := 𝟙 _
    let τ123 :
        SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)) ⟶
          SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h) ⋙
            SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f) :=
      (SheafOfModules.pushforwardComp.{u} (Hom.toRingCatSheafHom f)
        (Hom.toRingCatSheafHom h)).inv
    let τ013 :
        ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)).hom) ⟶
          (SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)) ⋙
            (SheafOfModules.forget.{u} X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 X.ringCatSheaf.obj))) := 𝟙 _
    let τ023 :
        ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)).hom) ⟶
          (SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h) ⋙
            ((SheafOfModules.forget.{u} Y.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Y.ringCatSheaf.obj)) ⋙
              PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom)) :=
      Functor.whiskerLeft (SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj))
        (PresheafOfModules.pushforwardComp.{u} (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv
    have hτ :
        τ023 ≫ Functor.whiskerLeft
            (SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h)) τ012 =
          τ013 ≫ Functor.whiskerRight τ123
              (SheafOfModules.forget.{u} X.ringCatSheaf ⋙
                PresheafOfModules.restrictScalars.{u} (𝟙 X.ringCatSheaf.obj)) ≫
            (CategoryTheory.Functor.associator _ _ _).hom := by
      ext A
      rfl
    have E1 := Adjunction.leftAdjointCompNatTrans_assoc
      adj01 adj12 adj23 adj02 adj13 adj03 τ012 τ123 τ013 τ023 hτ
    -- The second instance: the same outer (02,23,03)-triangle, but resolved through the
    -- PRESHEAF pullback leg `adj01' = PrPbPushAdj φ'_f` instead of the sheaf leg.
    let adj01' := PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom f).hom
    let adj12' := PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
      (𝟙 Y.ringCatSheaf.obj)
    let adj13' := (PresheafOfModules.pullbackPushforwardAdjunction
        (Hom.toRingCatSheafHom h).hom).comp
      (PresheafOfModules.sheafificationAdjunction (R := Z.ringCatSheaf)
        (𝟙 Z.ringCatSheaf.obj))
    let τ012' :
        ((SheafOfModules.forget.{u} Y.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Y.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom) ⟶
          ((SheafOfModules.forget.{u} Y.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Y.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom) := 𝟙 _
    let τ123' :
        ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h).hom) ⟶
          (SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h) ⋙
            (SheafOfModules.forget.{u} Y.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Y.ringCatSheaf.obj))) := 𝟙 _
    let τ013' :
        ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)).hom) ⟶
          (((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h).hom) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom) :=
      Functor.whiskerLeft (SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj))
        (PresheafOfModules.pushforwardComp.{u} (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv
    have hτ' :
        τ023 ≫ Functor.whiskerLeft
            (SheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h)) τ012' =
          τ013' ≫ Functor.whiskerRight τ123'
              (PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom) ≫
            (CategoryTheory.Functor.associator _ _ _).hom := by
      ext A
      rfl
    have E2 := Adjunction.leftAdjointCompNatTrans_assoc
      adj01' adj12' adj23 adj02 adj13' adj03 τ012' τ123' τ013' τ023 hτ'
    -- Identify the four generic comparison transformations with the named project isos.
    have I1 : Adjunction.leftAdjointCompNatTrans adj12 adj23 adj13 τ123
        = (Scheme.Modules.pullbackComp h f).hom := rfl
    have I2 : Adjunction.leftAdjointCompNatTrans adj01 adj13 adj03 τ013
        = (SheafOfModules.sheafificationCompPullback
            (Hom.toRingCatSheafHom (h ≫ f))).hom := rfl
    have I3 : Adjunction.leftAdjointCompNatTrans adj01 adj12 adj02 τ012
        = (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom := rfl
    have I4 : Adjunction.leftAdjointCompNatTrans adj12' adj23 adj13' τ123'
        = (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom := rfl
    have I5 : Adjunction.leftAdjointCompNatTrans adj01' adj12' adj02 τ012' = 𝟙 _ :=
      conjugateEquiv_symm_id _
    -- ★3 via a THIRD assoc instance — the (f,h)-presheaf pair against the composite presheaf
    -- pullback adjunction.  Both outer comparison transformations trivialize
    -- (`conjugateEquiv_symm_id`), so the instance identifies the mixed `(01',13',03)`-comparison
    -- with the sheafified presheaf-`pullbackComp` coherence with NO conjugate manipulation.
    let adjh' := PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom h).hom
    let adjZ' := PresheafOfModules.sheafificationAdjunction (R := Z.ringCatSheaf)
      (𝟙 Z.ringCatSheaf.obj)
    let adjhf' := PresheafOfModules.pullbackPushforwardAdjunction
      (Hom.toRingCatSheafHom (h ≫ f)).hom
    let τ012'' :
        PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)).hom ⟶
          PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h).hom ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom :=
      (PresheafOfModules.pushforwardComp.{u} (Hom.toRingCatSheafHom f).hom
        (Hom.toRingCatSheafHom h).hom).inv
    let τ123'' :
        ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h).hom) ⟶
          ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom h).hom) := 𝟙 _
    let τ023'' :
        ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)).hom) ⟶
          ((SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) ⋙
            PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom (h ≫ f)).hom) := 𝟙 _
    have hτ'' :
        τ023'' ≫ Functor.whiskerLeft
            (SheafOfModules.forget.{u} Z.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars.{u} (𝟙 Z.ringCatSheaf.obj)) τ012'' =
          τ013' ≫ Functor.whiskerRight τ123''
              (PresheafOfModules.pushforward.{u} (Hom.toRingCatSheafHom f).hom) ≫
            (CategoryTheory.Functor.associator _ _ _).hom := by
      ext A
      rfl
    have E3 := Adjunction.leftAdjointCompNatTrans_assoc
      adj01' adjh' adjZ' adjhf' adj13' adj03 τ012'' τ123'' τ013' τ023'' hτ''
    have J1 : Adjunction.leftAdjointCompNatTrans adjh' adjZ' adj13' τ123'' = 𝟙 _ :=
      conjugateEquiv_symm_id _
    have J2 : Adjunction.leftAdjointCompNatTrans adjhf' adjZ' adj03 τ023'' = 𝟙 _ :=
      conjugateEquiv_symm_id _
    have J3 : Adjunction.leftAdjointCompNatTrans adj01' adjh' adjhf' τ012''
        = (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
            (Hom.toRingCatSheafHom h).hom).hom := rfl
    rw [I1, I2, I3] at E1
    simp only [I4, I5] at E2
    simp only [J1, J2, J3] at E3
    -- Evaluate the pasted identities at `P`, eliminate the mixed comparison, and peel the
    -- invertible `pullbackComp` whisker.
    apply NatTrans.ext
    funext P
    have e1 := congr_app E1 P
    have e2 := congr_app E2 P
    have e3 := congr_app E3 P
    simp only [NatTrans.comp_app, Functor.whiskerLeft_app, Functor.whiskerRight_app,
      Functor.associator_inv_app, NatTrans.id_app] at e1 e2 e3 ⊢
    -- Normalize the definitionally equal object spellings before removing identity factors.
    try dsimp only [Functor.comp_obj] at e1 e2 e3 ⊢
    simp only [CategoryTheory.Functor.map_id, Category.id_comp, Category.comp_id] at e1 e2 e3
    -- Remove the leading identities with definitional matching, eliminate the mixed
    -- comparison between `e1` and `e2`, then resolve it with `e3`.
    erw [Category.id_comp] at e2
    erw [Category.id_comp] at e3
    rw [← e2] at e1
    rw [e3] at e1
    -- Peel the invertible `pullbackComp`-component; `exact` closes the remaining
    -- `Scheme.Modules` vs `SheafOfModules` spelling differences by defeq.
    exact (Iso.eq_inv_comp ((Scheme.Modules.pullbackComp h f).app
      ((PresheafOfModules.sheafification (R := X.ringCatSheaf)
        (𝟙 X.ringCatSheaf.obj)).obj P))).mpr e1
  -- Evaluate `key` at `P`; the local transparency setting controls the comparison between
  -- the Scheme and sheaf pullback spellings.
  have happ := NatTrans.congr_app key P
  simp only [NatTrans.comp_app, Functor.whiskerLeft_app, Functor.whiskerRight_app] at happ ⊢
  exact happ