---
author: sync
content_type: lemma
created: '2026-08-10T13:01:39'
decl: AlgebraicGeometry.modules_res_res
file: AlgebraicJacobian/Cohomology/NativePushforwardBaseChangeMate.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.modules_res_res
type: lean
updated: '2026-08-18T20:50:51'
---
private lemma modules_res_res
    {Y : Scheme.{u}} (N : Y.Modules) {W₁ W₂ W₃ : Y.Opens}
    (i₁ : W₁ ≤ W₂) (i₂ : W₂ ≤ W₃) (i₃ : W₁ ≤ W₃) (x : Γ(N, W₃)) :
    (N.presheaf.map (homOfLE i₁).op).hom ((N.presheaf.map (homOfLE i₂).op).hom x) =
      (N.presheaf.map (homOfLE i₃).op).hom x := by
  rw [← AddCommGrpCat.comp_apply, ← Functor.map_comp, ← op_comp]
  exact (congrArg (fun (i : W₁ ⟶ W₃) =>
    (AddCommGrpCat.Hom.hom (N.presheaf.map i.op)) x) (Subsingleton.elim _ _)).symm

set_option backward.isDefEq.respectTransparency false in