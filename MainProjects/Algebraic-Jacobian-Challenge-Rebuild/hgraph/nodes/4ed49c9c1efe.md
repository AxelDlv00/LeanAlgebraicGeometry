---
author: sync
content_type: theorem
created: '2026-07-30T10:29:03'
decl: AlgebraicGeometry.ProbeP4R6.probeBij
docstring: 'A: from IsIso of the sheaf hom, the presheaf map is app-wise bijective.'
file: scratch_p4r6/probe4.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ProbeP4R6.probeBij
type: lean
updated: '2026-07-31T20:31:21'
---
theorem probeBij {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (h : IsIso (chartSheafHom (C := C) f)) (T : Scheme.{u}ᵒᵖ) :
    Function.Bijective (f.app T) := by
  haveI := h
  have hI : IsIso f := by
    have : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
        (chartSheafHom (C := C) f)) := inferInstance
    exact this
  rw [← isIso_iff_bijective]
  exact inferInstance