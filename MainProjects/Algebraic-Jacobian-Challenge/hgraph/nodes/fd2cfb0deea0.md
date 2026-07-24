---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.restrictScalarsLax
docstring: 'The lax-monoidal tensorator `μ` of `restrictScalars α`, assembled sectionwise

  from `ModuleCat.restrictScalars (α.app X)`''s lax-monoidal tensorator.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.restrictScalarsLax
type: lean
updated: '2026-07-24T14:32:34'
---
noncomputable def restrictScalarsLaxμ
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat)
    (M₁ M₂ : PresheafOfModules.{u} (S ⋙ forget₂ _ _)) :
    (restrictScalars α).obj M₁ ⊗ (restrictScalars α).obj M₂ ⟶
      (restrictScalars α).obj (M₁ ⊗ M₂) where
  app X := by
    exact Functor.LaxMonoidal.μ (ModuleCat.restrictScalars (α.app X).hom) (M₁.obj X) (M₂.obj X)
  naturality {X Y} f := by
    refine ModuleCat.MonoidalCategory.tensor_ext (fun m₁ m₂ ↦ ?_)
    dsimp
    erw [PresheafOfModules.Monoidal.tensorObj_map_tmul, ModuleCat.restrictScalars_μ_tmul,
      ModuleCat.restrictScalars_μ_tmul, PresheafOfModules.Monoidal.tensorObj_map_tmul]
    rfl

set_option backward.isDefEq.respectTransparency false in