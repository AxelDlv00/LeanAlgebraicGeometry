---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Hom.baseSectionsRes
docstring: '**The bundled `Γ(S, ⊤)`-linear section restriction** of a module on the

  total space of the family `p : X ⟶ S`, for the `baseSectionsModule`

  structures.  (`restrictₗ` of `Picard/QuotScheme.lean` is the sibling over

  the section ring of the source open; this one is linear over the base.)'
file: AlgebraicJacobian/Picard/RigidPushforwardP1Engine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.baseSectionsRes
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def Hom.baseSectionsRes (p : X ⟶ S) (M : X.Modules) {W W' : X.Opens}
    (h : W' ≤ W) :
    letI := p.baseSectionsModule M W
    letI := p.baseSectionsModule M W'
    Γ(M, W) →ₗ[Γ(S, ⊤)] Γ(M, W') :=
  letI := p.baseSectionsModule M W
  letI := p.baseSectionsModule M W'
  { toFun := fun m => M.presheaf.map (homOfLE h).op m
    map_add' := map_add _
    map_smul' := fun r m => p.baseSections_res_smul M h r m }