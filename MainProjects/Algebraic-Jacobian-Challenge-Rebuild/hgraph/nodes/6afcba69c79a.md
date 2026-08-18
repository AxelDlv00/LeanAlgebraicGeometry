---
author: sync
content_type: theorem
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.isProjective
docstring: A proper source with a finite map to `P1` is projective.
file: AlgebraicJacobian/Projective/FiniteMapToP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.isProjective
type: lean
updated: '2026-08-18T20:51:07'
---
theorem isProjective (hpi : pi ≫ P1.structureMap k = C.hom)
    [IsFinite pi] [IsProper C.hom] : C.hom.IsProjective := by
  exact Scheme.Hom.IsProjective.of_isProper_of_immersion
    (pi := C.hom) (by infer_instance) G.toProjectiveSpace
      (G.isImmersion_toProjectiveSpace hpi) G.toProjectiveSpace_over