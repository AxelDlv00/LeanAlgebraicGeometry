---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.isLocalization_awayElt
docstring: The section rings on the basic opens are `Away` models over `B` itself.
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.isLocalization_awayElt
type: lean
updated: '2026-08-01T09:44:17'
---
lemma isLocalization_awayElt (i : P.ι) :
    IsLocalization.Away (awayElt P i) Γ(XB, (XB).basicOpen (P.r i)) :=
  isLocalization_away_sections B (P.r i)