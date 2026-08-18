---
author: sync
content_type: lemma
created: '2026-08-10T13:01:39'
decl: AlgebraicGeometry.modulesRestrictionPreimageTopEqId
file: AlgebraicJacobian/Cohomology/NativePushforwardBaseChangeTensor.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.modulesRestrictionPreimageTopEqId
type: lean
updated: '2026-08-18T20:50:51'
---
private lemma modulesRestrictionPreimageTopEqId {X Y : Scheme.{u}} (g : Y ⟶ X)
    (N : Y.Modules) (e : (⊤ : Y.Opens) ≤ g ⁻¹ᵁ ⊤) :
    N.presheaf.map (homOfLE e).op = 𝟙 _ :=
  (congrArg N.presheaf.map
    (show (homOfLE e).op = 𝟙 (Opposite.op (⊤ : Y.Opens)) from rfl)).trans
    (N.presheaf.map_id _)

set_option backward.isDefEq.respectTransparency false in