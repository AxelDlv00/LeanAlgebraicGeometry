---
author: sync
content_type: lemma
created: '2026-08-11T14:50:58'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.pullbackCongrCompSectionsEquiv_baseMap
file: AlgebraicJacobian/Picard/Pic0RankOneNativeBaseChangeCartesian.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.pullbackCongrCompSectionsEquiv_baseMap
type: lean
updated: '2026-08-11T14:50:58'
---
private lemma pullbackCongrCompSectionsEquiv_baseMap
    {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z) (h : X ⟶ Z)
    (eq : h = f ≫ g) (N : Z.Modules)
    {V : Y.Opens} {W : Z.Opens}
    (eV : V ≤ g ⁻¹ᵁ W) (eT : (⊤ : X.Opens) ≤ f ⁻¹ᵁ V)
    (eTW : (⊤ : X.Opens) ≤ h ⁻¹ᵁ W) (x : Γ(N, W)) :
    pullbackCongrCompSectionsEquiv f g h eq N
        (pullback_app_isoTensor_baseMap h N eTW x) =
      pullback_app_isoTensor_baseMap f
        ((Scheme.Modules.pullback g).obj N) eT
          (pullback_app_isoTensor_baseMap g N eV x) := by
  apply (asIso (Scheme.Modules.Hom.app
    ((Scheme.Modules.pullbackComp f g).hom.app N) ⊤)).toEquiv.injective
  change (Scheme.Modules.Hom.app
      ((Scheme.Modules.pullbackComp f g).hom.app N) ⊤).hom
        ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackComp f g).inv.app N) ⊤).hom
          ((Scheme.Modules.Hom.app
            ((Scheme.Modules.pullbackCongr eq).hom.app N) ⊤).hom
            (pullback_app_isoTensor_baseMap h N eTW x))) = _
  rw [← AddCommGrpCat.comp_apply, ← Scheme.Modules.Hom.comp_app,
    Iso.inv_hom_id_app, Scheme.Modules.Hom.id_app,
    AddCommGrpCat.hom_id, AddMonoidHom.id_apply]
  rw [pullback_app_isoTensor_baseMap_congr eq N eTW
    (eT.trans (Scheme.Hom.preimage_mono f eV)) x]
  exact (pullback_app_isoTensor_baseMap_comp f g N eV eT
    (eT.trans (Scheme.Hom.preimage_mono f eV)) x).symm