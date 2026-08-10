---
author: sync
content_type: theorem
created: '2026-08-10T17:36:36'
decl: AlgebraicGeometry.ProbeP4R6.probeSheaf
file: scratch_p4r6/probe4.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProbeP4R6.probeSheaf
type: lean
updated: '2026-08-10T18:39:02'
---
theorem probeSheaf (X : Scheme.{u}) :
    Presheaf.IsSheaf Scheme.zariskiTopology (yoneda.obj X) :=
  (isSheaf_iff_isSheaf_of_type _ _).mpr
    (GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable (yoneda.obj X))