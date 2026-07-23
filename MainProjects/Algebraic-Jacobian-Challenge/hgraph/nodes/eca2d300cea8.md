---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.gammaResA_apply
file: AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gammaResA_apply
type: lean
updated: '2026-07-24T03:02:09'
---
@[simp] theorem gammaResA_apply {X : Scheme.{u}} (M : X.Modules) {U V : X.Opens} (h : V ≤ U)
    (x : gammaModA M U) :
    gammaResA M h x = (M.val.map (homOfLE h).op).hom x := by
  simp only [gammaResA, gammaResAHom, ModuleCat.hom_comp, LinearMap.comp_apply,
    ModuleCat.restrictScalars.map_apply, ModuleCat.restrictScalarsComp'App_inv_apply]