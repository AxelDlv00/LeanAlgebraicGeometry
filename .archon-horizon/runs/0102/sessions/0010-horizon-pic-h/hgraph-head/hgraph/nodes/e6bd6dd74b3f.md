---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.JacobianData.uniqueUpToIso
docstring: 'Representing objects are unique up to isomorphism (mathlib

  `Functor.RepresentableBy.uniqueUpToIso`): any two Jacobian data for the same curve
  have

  canonically isomorphic `J`.  This is Wave-7''s `baseChangeIso` mechanism.'
file: AlgebraicJacobian/Picard/JacobianData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.JacobianData.uniqueUpToIso
type: lean
updated: '2026-08-01T09:44:15'
---
noncomputable def uniqueUpToIso (d d' : JacobianData C) : d.J ≅ d'.J :=
  d.rep.uniqueUpToIso d'.rep