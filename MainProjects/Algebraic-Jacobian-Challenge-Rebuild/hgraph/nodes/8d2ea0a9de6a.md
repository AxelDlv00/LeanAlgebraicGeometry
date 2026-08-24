---
author: sync
content_type: definition
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.DivFamZarAff.trivSectionAff
docstring: The constant trivial class is a widened degree-zero section on every test.
file: AlgebraicJacobian/Picard/DivisorFamilyAffDegreeZeroRep.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivFamZarAff.trivSectionAff
type: lean
updated: '2026-08-18T20:51:00'
---
noncomputable def trivSectionAff (T : Over (Spec (.of k))) : divFamZarAff C 0 T :=
  ⟨fun _ => trivZarAff (C := C) (pi := pi),
    fun _ _ h => mapAlgHom_trivZarAff (C := C) (pi := pi) (Over.resAlgHom T h)⟩