---
author: sync
content_type: definition
created: '2026-08-11T12:56:17'
decl: AlgebraicGeometry.pullbackOpenImmersionSectionsEquiv
docstring: Top sections of a pullback along an open immersion are sections over its
  image.
file: AlgebraicJacobian/Cohomology/NativePushforwardBaseChangeOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pullbackOpenImmersionSectionsEquiv
type: lean
updated: '2026-08-11T12:56:17'
---
noncomputable def pullbackOpenImmersionSectionsEquiv
    {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f] (N : Y.Modules) :
    Γ((Scheme.Modules.pullback f).obj N, ⊤) ≃+ Γ(N, f.opensRange) := by
  let isoSheaf : (Scheme.Modules.pullback f).obj N ≅ N.restrict f :=
    ((Scheme.Modules.restrictFunctorIsoPullback f).app N).symm
  have hImg : (f ''ᵁ (⊤ : X.Opens) : Y.Opens) = f.opensRange := by
    rw [Scheme.Hom.image_top_eq_opensRange]
  let toFun : Γ((Scheme.Modules.pullback f).obj N, ⊤) → Γ(N, f.opensRange) := fun x =>
    (N.presheaf.map (eqToHom hImg.symm).op).hom
      ((Scheme.Modules.Hom.app isoSheaf.hom ⊤).hom x)
  let invFun : Γ(N, f.opensRange) → Γ((Scheme.Modules.pullback f).obj N, ⊤) := fun y =>
    (Scheme.Modules.Hom.app isoSheaf.inv ⊤).hom
      ((N.presheaf.map (eqToHom hImg).op).hom y)
  refine
    { toFun := toFun
      invFun := invFun
      left_inv := ?_
      right_inv := ?_
      map_add' := ?_ }
  · intro x
    simp only [invFun, toFun, ← AddCommGrpCat.comp_apply, ← Functor.map_comp, ← op_comp,
      eqToHom_trans, eqToHom_refl, op_id, CategoryTheory.Functor.map_id,
      AddCommGrpCat.hom_id, AddMonoidHom.id_apply, ← Scheme.Modules.Hom.comp_app,
      isoSheaf.hom_inv_id, Scheme.Modules.Hom.id_app]
  · intro y
    simp only [invFun, toFun, ← AddCommGrpCat.comp_apply, ← Scheme.Modules.Hom.comp_app,
      isoSheaf.inv_hom_id, Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id,
      AddMonoidHom.id_apply, ← Functor.map_comp, ← op_comp, eqToHom_trans,
      eqToHom_refl, op_id, CategoryTheory.Functor.map_id]
  · intro x y
    change (AddCommGrpCat.Hom.hom (N.presheaf.map (eqToHom hImg.symm).op))
      ((AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) (x + y)) = _
    rw [show ((AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) (x + y)) =
      (AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) x +
      (AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) y from
      AddMonoidHom.map_add _ _ _]
    exact AddMonoidHom.map_add _ _ _

set_option backward.isDefEq.respectTransparency false in