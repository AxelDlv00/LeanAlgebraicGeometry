---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.pushforwardNatTrans_app_app_apply
file: AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.pushforwardNatTrans_app_app_apply
type: lean
updated: '2026-07-24T03:02:12'
---
@[simp] lemma pushforwardNatTrans_app_app_apply (α : F ⟶ G) (M : PresheafOfModules.{u} R)
    (U : Cᵒᵖ) (x) :
    ((pushforwardNatTrans φ α).app M).app U x = M.map (α.app U.unop).op x := rfl

end PushforwardNatTrans

section PushforwardCongr

universe v₁ v₂ uC uD

variable {C : Type uC} [Category.{v₁} C] {D : Type uD} [Category.{v₂} D]
  {F : C ⥤ D} {S : Cᵒᵖ ⥤ RingCat.{u}} {R : Dᵒᵖ ⥤ RingCat.{u}}