---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.degAffHom
docstring: The chosen refinement map into the chosen field refinement.
file: AlgebraicJacobian/Picard/DegreeZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.degAffHom
type: lean
updated: '2026-07-16T21:33:28'
---
private def degAffHom (E : Algebra.EtaleCover K) : E.Carrier →ₐ[K] degAffField E :=
  E.exists_finiteSeparableField_algHom.choose_spec.choose_spec.choose_spec.choose_spec
    |>.choose_spec.some