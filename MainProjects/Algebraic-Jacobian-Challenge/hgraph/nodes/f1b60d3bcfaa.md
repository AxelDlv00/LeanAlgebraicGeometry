---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict
docstring: 'Composition coherence of the sheaf-level pullback tensorator.


  For composable scheme morphisms, `pullbackTensorMap` for the composite factors through
  the

  comparisons for the two morphisms and the pullback pseudofunctor coherence. Specializing
  this

  identity to the two factorizations of a base-change square gives the blueprint''s
  restricted

  comparison.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict
type: lean
updated: '2026-07-25T05:32:31'
---
lemma pullbackTensorMap_restrict {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (M N : X.Modules) :
    pullbackTensorMap (h ≫ f) M N =
      (Scheme.Modules.pullbackComp h f).inv.app (tensorObj M N) ≫
      (Scheme.Modules.pullback h).map (pullbackTensorMap f M N) ≫
      pullbackTensorMap h ((Scheme.Modules.pullback f).obj M)
        ((Scheme.Modules.pullback f).obj N) ≫
      (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp h f).app M)
        ((Scheme.Modules.pullbackComp h f).app N)).hom := by
  -- Expand each tensorator comparison into its four defining factors. The proof then pastes:
  -- sheafification-pullback coherence, the composite oplax tensorator, the tensor-unit
  -- comparison, and `pullbackValIso` coherence. The latter two squares must be interleaved because
  -- their arguments use different presentations of the pulled-back underlying presheaves.
  simp only [pullbackTensorMap, tensorObjIsoOfIso]
  rw [Functor.map_comp, Functor.map_comp, Functor.map_comp]
  simp only [Category.assoc]
  -- Keep the first comparison folded while assembling the adjacent inverse pair.
  have h1 := sheafificationCompPullback_comp h f (PresheafOfModules.Monoidal.tensorObj M.val N.val)
  letI instMSX :
      MonoidalCategoryStruct
        (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :=
    inferInstance
  letI instMSZ :
      MonoidalCategoryStruct
        (_root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat)) :=
    inferInstance
  -- Explicit functor spellings keep the cancellation factors syntactically aligned.
  let φfh := (Hom.toRingCatSheafHom (h ≫ f)).hom
  let φf := (Hom.toRingCatSheafHom f).hom
  let φh := (Hom.toRingCatSheafHom h).hom
  let pb := PresheafOfModules.pullbackComp φf φh
  let δfh := Functor.OplaxMonoidal.δ
    (F := PresheafOfModules.pullback
      (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map (h ≫ f).base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom (h ≫ f)).hom))
    M.val N.val
  let δcomp := Functor.OplaxMonoidal.δ
    (F := PresheafOfModules.pullback
      (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom f).hom) ⋙
      PresheafOfModules.pullback
        (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
            (TopologicalSpace.Opens.map h.base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
          from (Hom.toRingCatSheafHom h).hom))
    M.val N.val
  let tcomp :=
    MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat))
      (pb.hom.app M.val) (pb.hom.app N.val)
  have hδ :
      (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δfh =
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map
            ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
              (Hom.toRingCatSheafHom h).hom).inv.app
              (PresheafOfModules.Monoidal.tensorObj M.val N.val)) ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δcomp ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map tcomp := by
    -- Apply `pullbackComp_δ` under sheafification, folding mapped composites first.
    have hd := pullbackComp_δ
      (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom f).hom)
      (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map h.base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom h).hom) M.val N.val
    rw [← Functor.map_comp, ← Functor.map_comp]
    exact congrArg (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map hd
  -- Combine the first comparison and the composite tensorator in one canonical category instance.
  have hmain :
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app
          (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δfh =
      (SheafOfModules.pullbackComp (Hom.toRingCatSheafHom f) (Hom.toRingCatSheafHom h)).inv.app
          ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)) ≫
        (SheafOfModules.pullback (Hom.toRingCatSheafHom h)).map
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom ≫
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj
            (PresheafOfModules.Monoidal.tensorObj M.val N.val))).hom ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δcomp ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map tcomp := by
    -- Restate the coherence so its concrete category instance matches this local composite.
    have h1' :
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom =
          (SheafOfModules.pullbackComp (Hom.toRingCatSheafHom f) (Hom.toRingCatSheafHom h)).inv.app
              ((PresheafOfModules.sheafification (𝟙 (X.ringCatSheaf.obj))).obj
                (PresheafOfModules.Monoidal.tensorObj M.val N.val)) ≫
            (SheafOfModules.pullback (Hom.toRingCatSheafHom h)).map
              ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
                (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom ≫
            ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj
                (PresheafOfModules.Monoidal.tensorObj M.val N.val))).hom ≫
            (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map
              ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
                (Hom.toRingCatSheafHom h).hom).hom.app
                (PresheafOfModules.Monoidal.tensorObj M.val N.val)) := h1
    -- Expose the inverse pair and cancel it through the abstract categorical helper.
    rw [h1']
    erw [hδ]
    exact comp_cancel_mid _ _ _ _ _ _
      (sheafifyMap_pullbackComp_hom_inv_id h f (PresheafOfModules.Monoidal.tensorObj M.val N.val))
  -- Splice the cancelled prefix into the main composite.
  erw [reassoc_of% hmain]
  -- Split the composite oplax tensorator into the two pullback tensorators.
  erw [sheafifyMap_δcomp_split h f M N]
  -- Slide the second sheafification comparison past the first pullback tensorator by naturality.
  have hslide :
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj
              (PresheafOfModules.Monoidal.tensorObj M.val N.val))).hom ≫
          (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map
            ((PresheafOfModules.pullback
                (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
                    (TopologicalSpace.Opens.map h.base).op ⋙
                      (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
                  from (Hom.toRingCatSheafHom h).hom)).map
              (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback
                (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
                    (TopologicalSpace.Opens.map f.base).op ⋙
                      (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
                  from (Hom.toRingCatSheafHom f).hom)) M.val N.val))
        = (SheafOfModules.pullback (Hom.toRingCatSheafHom h)).map
              ((PresheafOfModules.sheafification (𝟙 (Y.ringCatSheaf.obj))).map
                (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback
                  (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
                      (TopologicalSpace.Opens.map f.base).op ⋙
                        (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
                    from (Hom.toRingCatSheafHom f).hom)) M.val N.val)) ≫
            ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
              (PresheafOfModules.Monoidal.tensorObj
                ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)
                ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val))).hom :=
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom.naturality
      (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback
        (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
            (TopologicalSpace.Opens.map f.base).op ⋙
              (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
          from (Hom.toRingCatSheafHom f).hom)) M.val N.val)).symm
  -- The explicit ring-map ascriptions make this equation definitionally match the nested slide.
  refine comp_slide_nested _ _ _ _ _ _ _ _ _ _ _ hslide ?_
  -- Cancel the common prefix, using definitional equality for its two presentations.
  refine comp_cancel_three_lr _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ rfl rfl rfl ?_
  -- Package the tensor-unit and `pullbackValIso` legs over `Y` as one presheaf morphism.
  set gg :
      PresheafOfModules.Monoidal.tensorObj
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val) ⟶
        PresheafOfModules.Monoidal.tensorObj ((pullback f).obj M).val ((pullback f).obj N).val :=
    MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
        ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val))
        ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val)) ≫
      MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)
    with hgg
  -- `a_Y.map gg = S3_f ≫ S4_f` (first factor by `sheafifyTensorUnitIso_hom_eq'`, second is `S4_f`).
  have hg :
      (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map gg
        = (sheafifyTensorUnitIso
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val)).hom ≫
          (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)) := by
    -- Split `a_Y.map (A ≫ B)` as a defeq `exact` (the `≫` in `gg` lives in the `forget₂`-carrier
    -- monoidal instance, defeq-but-not-syntactic to `a_Y`'s domain — bridged by `exact`, not `rw`).
    have hsplit :
        (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map gg
          = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
              (MonoidalCategory.tensorHom
                (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
                ((PresheafOfModules.sheafificationAdjunction
                  (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
                  ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val))
                ((PresheafOfModules.sheafificationAdjunction
                  (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
                  ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val))) ≫
            (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
              (MonoidalCategory.tensorHom
                (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)) := by
      rw [hgg]
      exact (PresheafOfModules.sheafification
        (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map_comp _ _
    rw [hsplit]
    congr 1
    exact (sheafifyTensorUnitIso_hom_eq' _ _).symm
  -- Splice the slide: `m3 ≫ m4 ≫ vv = v ≫ a_Z.map (Fp_h.map gg)` from `hg` + naturality of
  -- `sheafificationCompPullback h` at `gg`.
  refine comp_slide_three _ _ _ _ _ _ _ _ _ _ _ _
    ((PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.obj)).map
      ((PresheafOfModules.pullback (Hom.toRingCatSheafHom h).hom).map gg)) ?_ ?_
  · -- Merge the mapped factors, then use naturality at `gg`.
    exact map_comp_slide (Scheme.Modules.pullback h) _ _
      ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map gg)
      _ _ hg
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom.naturality gg)
  · -- Fold the remaining Sq3/Sq4 comparison into a presheaf equality over `Z`.
    rw [sheafifyTensorUnitIso_hom_eq', sheafifyTensorUnitIso_hom_eq']
    simp only [Functor.mapIso_hom, MonoidalCategory.tensorIso_hom]
    refine map_comp4_eq_comp5 _ _ _ _ _ _ _ _ _ _ ?_
    -- Expose `gg` as a tensor of its two legs before applying tensorator naturality.
    have hgg2 : gg =
        MonoidalCategory.tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
          ((PresheafOfModules.sheafificationAdjunction
              (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val) ≫
            (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
          ((PresheafOfModules.sheafificationAdjunction
              (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val) ≫
            (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom) := by
      rw [hgg]
      exact MonoidalCategory.tensorHom_comp_tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _
    rw [hgg2]
    -- Pin the pullback functor so tensorator naturality uses the intended monoidal instance.
    have hδnat := Functor.OplaxMonoidal.δ_natural
      (F := PresheafOfModules.pullback
        (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
            (TopologicalSpace.Opens.map h.base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
          from (Hom.toRingCatSheafHom h).hom))
      ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val) ≫
        (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
      ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val) ≫
        (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)
    erw [← reassoc_of% hδnat]
    -- Cancel the common tensorator and reduce the remaining tensor morphisms to their two legs.
    rw [show tcomp = MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat))
      (pb.hom.app M.val) (pb.hom.app N.val) from rfl]
    congr 1
    refine tensorHom_collapse_3_4
      (C := _root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat))
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ ?_ ?_
    · -- per-leg M (the `pullbackValIso` composition coherence, Sq4): the canonical "unit into the
      -- pullback's underlying presheaf" composes pseudofunctorially across `h ≫ f`.
      exact pullbackValIso_comp_leg h f M
    · exact pullbackValIso_comp_leg h f N


/-! ## Pure-tensor calculations for pushforward coherence -/

set_option backward.isDefEq.respectTransparency false in