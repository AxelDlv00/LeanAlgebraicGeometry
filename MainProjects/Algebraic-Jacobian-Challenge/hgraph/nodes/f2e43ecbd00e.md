---
author: sync
content_type: theorem
created: '2026-07-28T14:03:58'
decl: AlgebraicGeometry.etProbe_picSchemeEt_carriers
docstring: Local finiteness and separatedness of `Pic_{C/k}` over an arbitrary field.
file: scripts/axiom-frontier.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.etProbe_picSchemeEt_carriers
type: lean
updated: '2026-07-30T11:48:48'
---
theorem etProbe_picSchemeEt_carriers :
    LocallyOfFiniteType (PicSchemeEt C).hom ∧ IsSeparated (PicSchemeEt C).hom :=
  ⟨inferInstance, inferInstance⟩