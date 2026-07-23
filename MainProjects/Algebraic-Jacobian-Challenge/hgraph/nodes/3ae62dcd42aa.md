---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.objRestrict_apply
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.objRestrict_apply
type: lean
updated: '2026-07-24T03:02:11'
---
@[simp] private lemma objRestrict_apply (P : X.PresheafOfModules)
    {U V : (TopologicalSpace.Opens X)ᵒᵖ} (f : U ⟶ V) (x : ↥(P.obj U)) :
    objRestrict P f x = (P.presheaf.map f).hom x := rfl