---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Scheme.moduleKSheaf_map_apply
file: AlgebraicJacobian/Cohomology/ModuleKSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.moduleKSheaf_map_apply
type: lean
updated: '2026-07-29T15:31:35'
---
lemma Scheme.moduleKSheaf_map_apply {U V : X.Opensᵒᵖ} (i : U ⟶ V)
    (s : Γ(X, U.unop)) :
    ((X.moduleKSheaf k).obj.map i).hom s = (X.presheaf.map i).hom s := rfl