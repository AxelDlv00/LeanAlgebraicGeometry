---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.sheafiso_iff_presheafiso
file: scratch_p4r6_audit/p04_isoequiv4.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sheafiso_iff_presheafiso
type: lean
updated: '2026-07-30T12:49:48'
---
theorem sheafiso_iff_presheafiso {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) :
    IsIso (chartSheafHom C f) ↔ IsIso f := by
  constructor
  · intro h
    haveI := h
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  · intro h
    haveI : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)) := h
    exact isIso_of_reflects_iso (chartSheafHom C f)
      (sheafToPresheaf Scheme.zariskiTopology (Type u))