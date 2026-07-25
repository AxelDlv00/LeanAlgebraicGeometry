---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.Modules.restrictScalars_laxMonoidal_ε_app
docstring: '**Sectionwise carrier value of the lax-monoidal unit `ε (restrictScalars
  α)`.**

  Abstract twin of `restrictScalars_oplaxMonoidal_η_app_one`, stated at the

  `CommRingCat`-valued base functors `R, S`, so the unit-object `CommRing` instances

  are native. The `ε` of `restrictScalars α` is sectionwise the `ModuleCat`-level

  `ε`, whose carrier action is the ring map `α.app W`

  (`ModuleCat.restrictScalars_η`).'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/PresheafDualUnitPullback.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.restrictScalars_laxMonoidal_ε_app
type: lean
updated: '2026-07-25T11:32:39'
---
lemma restrictScalars_laxMonoidal_ε_app {C : Type u} [Category.{u} C]
    {R S : Cᵒᵖ ⥤ CommRingCat.{u}}
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat) (W : Cᵒᵖ)
    (r : ((R ⋙ forget₂ CommRingCat RingCat).obj W : Type u)) :
    ((Functor.LaxMonoidal.ε (PresheafOfModules.restrictScalars α)).app W).hom r
      = (α.app W).hom r := by
  erw [ModuleCat.restrictScalars_η]

set_option backward.isDefEq.respectTransparency false in