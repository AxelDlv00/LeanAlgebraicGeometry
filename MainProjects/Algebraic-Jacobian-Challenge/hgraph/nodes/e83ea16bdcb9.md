---
author: sync
content_type: theorem
created: '2026-08-01T07:20:39'
decl: AlgebraicGeometry.Scheme.DivFamily.twist_isQuasicoherent
docstring: Quasi-coherence of the D2 twist, obtained from its finite presentation.
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.twist_isQuasicoherent
type: lean
updated: '2026-08-01T07:20:39'
---
theorem twist_isQuasicoherent
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) :
    (x.twist L).IsQuasicoherent := by
  letI : (x.twist L).IsFinitePresentation := x.twist_isFinitePresentation L hL
  infer_instance