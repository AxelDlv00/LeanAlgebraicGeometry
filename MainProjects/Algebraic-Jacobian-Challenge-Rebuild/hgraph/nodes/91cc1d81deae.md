---
author: sync
content_type: definition
created: '2026-08-03T13:09:51'
decl: AlgebraicGeometry.divRepAffAdmissibleScheme
docstring: 'The chosen scheme representing the widened divisor functor at the unconditional
  Picard

  coverage parameter.'
file: AlgebraicJacobian/Picard/DivRepAffChallenge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepAffAdmissibleScheme
type: lean
updated: '2026-08-07T05:01:47'
---
noncomputable def divRepAffAdmissibleScheme : Over (Spec (.of k)) :=
  (divFunctorAffAdmissibleRepresenter C).1