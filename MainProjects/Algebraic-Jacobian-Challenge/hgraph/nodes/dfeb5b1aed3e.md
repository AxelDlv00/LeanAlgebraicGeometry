---
author: sync
content_type: instance
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushforwardSectionsFunctor_additive
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushforwardSectionsFunctor_additive
type: lean
updated: '2026-07-24T03:02:10'
---
noncomputable instance pushforwardSectionsFunctor_additive
    (j : U ⟶ X) (W : TopologicalSpace.Opens X) : (pushforwardSectionsFunctor j W).Additive := by
  unfold pushforwardSectionsFunctor
  -- The flat 5-fold composite defeats instance search; build it as an explicit `instAdditiveComp`
  -- chain (every individual factor is additive).
  haveI hpf : (Scheme.Modules.pushforward j).Additive := inferInstance
  haveI i4 : (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens X)ᵒᵖ AddCommGrpCat).obj (Opposite.op W)).Additive :=
    Functor.instAdditiveComp _ _
  haveI i3 : (PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj) ⋙
      PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens X)ᵒᵖ AddCommGrpCat).obj (Opposite.op W)).Additive :=
    Functor.instAdditiveComp _ _
  haveI i2 : (SheafOfModules.forget X.ringCatSheaf ⋙
      PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj) ⋙
      PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens X)ᵒᵖ AddCommGrpCat).obj (Opposite.op W)).Additive :=
    Functor.instAdditiveComp _ _
  -- Instance search will not pick up `i2` automatically here, so we pass it explicitly.
  exact @CategoryTheory.Functor.instAdditiveComp _ _ _ _ _ _
    (Scheme.Modules.pushforward j) hpf _ _ _ _ i2