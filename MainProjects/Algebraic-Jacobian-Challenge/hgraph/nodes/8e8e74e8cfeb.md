---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.modules_res_res
docstring: Composition collapse for section restrictions of a sheaf of modules.
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.modules_res_res
type: lean
updated: '2026-07-16T21:14:27'
---
private lemma modules_res_res {Y : Scheme.{u}} (N : Y.Modules) {W₁ W₂ W₃ : Y.Opens}
    (i₁ : W₁ ≤ W₂) (i₂ : W₂ ≤ W₃) (i₃ : W₁ ≤ W₃) (ξ : Γ(N, W₃)) :
    (N.presheaf.map (homOfLE i₁).op).hom ((N.presheaf.map (homOfLE i₂).op).hom ξ) =
      (N.presheaf.map (homOfLE i₃).op).hom ξ := by
  rw [← AddCommGrpCat.comp_apply, ← Functor.map_comp, ← op_comp]
  exact (congrArg (fun (i : W₁ ⟶ W₃) =>
    (AddCommGrpCat.Hom.hom (N.presheaf.map i.op)) ξ) (Subsingleton.elim _ _)).symm

set_option backward.isDefEq.respectTransparency false in