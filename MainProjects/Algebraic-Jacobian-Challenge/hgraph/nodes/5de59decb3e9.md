---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.gluedOverFamily
docstring: The glued family over the glued base object of `Over S`.
file: AlgebraicJacobian/Picard/GrassmannianZariskiSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.gluedOverFamily
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def gluedOverFamily :
    Scheme.LocallyFreeQuotient V d
      (Over.mk ((opensCover T.left W hW).fromGlued ≫ T.hom)) where
  F := gluedModule hcpt
  q := gluedQuot hcpt
  epi := gluedQuot_epi hcpt
  locFree := gluedModule_locFree hcpt