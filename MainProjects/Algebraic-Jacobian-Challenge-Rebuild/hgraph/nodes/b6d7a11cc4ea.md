---
author: sync
content_type: theorem
created: '2026-08-10T17:36:32'
decl: AlgebraicGeometry.ProbeP4R6.probeLocInj
file: scratch_p4r6/probe2.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProbeP4R6.probeLocInj
type: lean
updated: '2026-08-10T18:39:23'
---
theorem probeLocInj {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hf : IsOpenImmersion.presheaf f) :
    Presheaf.IsLocallyInjective Scheme.zariskiTopology f :=
  Presheaf.isLocallyInjective_of_injective _ _
    (fun T => injective_of_isOpenImmersion_presheaf hf T)