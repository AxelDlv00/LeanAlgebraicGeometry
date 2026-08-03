---
author: sync
content_type: definition
created: '2026-08-04T00:08:09'
decl: AlgebraicGeometry.Scheme.Modules.unitEndSection'
file: AlgebraicJacobian/Projective/EffectiveCartierSupport.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.unitEndSection'
type: lean
updated: '2026-08-04T00:08:09'
---
private noncomputable def unitEndSection'
    {X : Scheme.{u}}
    (e : SheafOfModules.unit X.ringCatSheaf ⟶
      SheafOfModules.unit X.ringCatSheaf) : Γ(X, ⊤) :=
  e.val.app (op ⊤) (1 : X.ringCatSheaf.obj.obj (op (⊤ : X.Opens)))

set_option backward.isDefEq.respectTransparency false in