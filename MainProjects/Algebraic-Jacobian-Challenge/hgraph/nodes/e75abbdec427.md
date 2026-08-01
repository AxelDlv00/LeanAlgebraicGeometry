---
author: sync
content_type: theorem
created: '2026-07-31T17:10:04'
decl: AlgebraicGeometry.Scheme.DivFamily.grassmannianEval_epi
docstring: The evaluation map is epi as soon as its two displayed factors are epi.
file: AlgebraicJacobian/Picard/DivGrassmannianClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.grassmannianEval_epi
type: lean
updated: '2026-08-01T12:39:19'
---
theorem grassmannianEval_epi (L : X.Modules) (x : DivFamily π T)
    (hbase : Epi (pushforwardBaseChangeMap π T.hom
      (pullback.snd π T.hom) (pullback.fst π T.hom) pullback.condition L))
    (hquot : Epi ((Modules.pushforward (pullback.snd π T.hom)).map
      (x.twistQuotientMap L))) :
    Epi (x.grassmannianEval L) := by
  letI := hbase
  letI := hquot
  dsimp [grassmannianEval]
  infer_instance