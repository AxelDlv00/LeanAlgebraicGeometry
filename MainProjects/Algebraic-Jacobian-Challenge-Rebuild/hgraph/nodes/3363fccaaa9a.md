---
author: sync
content_type: lemma
created: '2026-07-19T15:01:16'
decl: AlgebraicGeometry.DivisorAdaptation.component_canonSection
docstring: The components of the canonical section are the (piece-restricted) equations.
file: AlgebraicJacobian/Picard/DivisorDatumInverse.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.component_canonSection
type: lean
updated: '2026-07-30T15:27:58'
---
lemma component_canonSection (j : (A.thetaIdealDatum 0).index) :
    A.divisorDatum.component A.canonSection j
      = (relCurve C R).resHom (le_of_eq (A.thetaIdealDatum_pieces 0 j))
          (A.eqn (A.lowerIndex 0 j)) :=
  Scheme.resHom_resHom _ _ _