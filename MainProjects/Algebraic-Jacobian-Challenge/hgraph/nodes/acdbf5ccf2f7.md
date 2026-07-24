---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorObjWhiskerLeftIso_eq
docstring: 'Bridge: the hand-built left-whiskering `tensorObjWhiskerLeftIso F e` is
  the canonical left

  whiskering `F ◁ e` transported along the bridge `tensorObjIso`.  Mirror of `tensorBraiding_eq`,

  using `μ`-naturality in the right variable (`Localization.Monoidal.μ_natural_right`).'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.tensorObjWhiskerLeftIso_eq
type: lean
updated: '2026-07-25T06:32:31'
---
private lemma tensorObjWhiskerLeftIso_eq (F : X.Modules) {G G' : X.Modules} (e : G ≅ G') :
    tensorObjWhiskerLeftIso F e
      = (tensorObjIso F G).symm ≪≫ MonoidalCategory.whiskerLeftIso F e ≪≫ tensorObjIso F G' := by
  apply Iso.ext
  rw [Iso.trans_hom, Iso.symm_hom, Iso.trans_hom, Iso.eq_inv_comp]
  -- `hwnat`: the canonical whisker `F ◁ e.hom` equals the sheaf-level whisker conjugated by
  -- counits.
  have hwnat : (F.sheafificationCounitIso.inv ⊗ₘ G.sheafificationCounitIso.inv) ≫
        (sheafification.obj ((toPresheafOfModules X).obj F) ◁
          sheafification.map ((toPresheafOfModules X).map e.hom)) ≫
        (F.sheafificationCounitIso.hom ⊗ₘ G'.sheafificationCounitIso.hom)
      = F ◁ e.hom := by
    rw [← MonoidalCategory.id_tensorHom, ← MonoidalCategory.id_tensorHom,
      MonoidalCategory.tensorHom_comp_tensorHom, MonoidalCategory.tensorHom_comp_tensorHom]
    refine congrArg₂ MonoidalCategory.tensorHom ?_ ?_
    · rw [Category.id_comp, Iso.inv_hom_id]
    · rw [show sheafification.map ((toPresheafOfModules X).map e.hom) ≫
            G'.sheafificationCounitIso.hom = G.sheafificationCounitIso.hom ≫ e.hom from
          (PresheafOfModules.sheafificationAdjunction
            (𝟙 X.ringCatSheaf.obj)).counit.naturality e.hom,
        ← Category.assoc, Iso.inv_hom_id, Category.id_comp]
  -- `hwμ`: the sheaf-level whisker is the descended presheaf whisker conjugated by `μ`
  -- (analogue of `hβ`, via `μ_natural_right`).
  have hwμ : sheafification.obj ((toPresheafOfModules X).obj F) ◁
        sheafification.map ((toPresheafOfModules X).map e.hom)
      = (Localization.Monoidal.μ (sheafificationMon X) (sheafificationW X)
          (localizationUnitIso X) ((toPresheafOfModules X).obj F)
          ((toPresheafOfModules X).obj G)).hom ≫
        sheafification.map (MonoidalCategory.whiskerLeft (C := MonoidalPresheaf X)
          ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).map e.hom)) ≫
        (Localization.Monoidal.μ (sheafificationMon X) (sheafificationW X)
          (localizationUnitIso X) ((toPresheafOfModules X).obj F)
          ((toPresheafOfModules X).obj G')).inv := by
    rw [← Category.assoc]
    exact (Iso.eq_comp_inv _).2 (Localization.Monoidal.μ_natural_right (sheafificationMon X)
      (sheafificationW X) (localizationUnitIso X) ((toPresheafOfModules X).obj F)
      ((toPresheafOfModules X).map e.hom))
  dsimp only [tensorObjWhiskerLeftIso, tensorObjIso, Iso.trans_hom, Functor.mapIso_hom,
    MonoidalCategory.tensorIso_hom, Iso.symm_hom, MonoidalCategory.whiskerLeftIso_hom]
  -- v4.31: use `change` to expose the `⊗ₘ`/`≫` heads (cf. `tensorObjUnitIso_eq`).
  change ((F.sheafificationCounitIso.inv ⊗ₘ G.sheafificationCounitIso.inv) ≫
      (Localization.Monoidal.μ (sheafificationMon X) (sheafificationW X) (localizationUnitIso X)
        ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G)).hom) ≫
      sheafification.map (MonoidalCategory.whiskerLeft (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).map e.hom))
    = F ◁ e.hom ≫
      ((F.sheafificationCounitIso.inv ⊗ₘ G'.sheafificationCounitIso.inv) ≫
      (Localization.Monoidal.μ (sheafificationMon X) (sheafificationW X) (localizationUnitIso X)
        ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G')).hom)
  rw [← hwnat, hwμ]
  simp only [Category.assoc, MonoidalCategory.tensorHom_comp_tensorHom_assoc, Iso.hom_inv_id,
    MonoidalCategory.id_tensorHom_id, Category.id_comp, Iso.inv_hom_id, Category.comp_id]

set_option backward.isDefEq.respectTransparency false in