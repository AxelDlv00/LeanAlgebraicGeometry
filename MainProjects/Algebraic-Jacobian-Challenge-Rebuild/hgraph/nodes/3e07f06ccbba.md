---
author: sync
content_type: definition
created: '2026-08-03T13:09:53'
decl: AlgebraicGeometry.universalDivFamAffAdmissible
docstring: 'The universal widened divisor family carried by the unconditional representer
  at the

  admissible coverage parameter.'
file: AlgebraicJacobian/Picard/Pic0AtlasFromDivRepAffChallenge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.universalDivFamAffAdmissible
type: lean
updated: '2026-08-18T20:51:04'
---
def universalDivFamAffAdmissible :
    divFamZarAff C (divRepAffAdmissibleParameter C) (divRepAffAdmissibleScheme C) :=
  (divFunctorAff_admissible_representableBy C).homEquiv (𝟙 _)