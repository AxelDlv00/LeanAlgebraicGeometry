---
author: sync
content_type: definition
created: '2026-07-21T21:31:59'
decl: AlgebraicGeometry.divUniversalFibreHighWindow
docstring: 'The canonical high-window fibre cut out by the universal divisor recovered
  from

  the first two Grassmannian windows.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowPersistence.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divUniversalFibreHighWindow
type: lean
updated: '2026-07-31T20:14:48'
---
noncomputable def divUniversalFibreHighWindow (n : ℕ) :
    Submodule K (relCurve C K).functionField :=
  Scheme.divisorSections K
    (windowN C K hpi g + n • windowS C K hpi g
      - divUniversalFibreDivisor C hpi g r1 r2 b1 b2 i j K hO hchi hker) ⊤

include hO hchi hker in