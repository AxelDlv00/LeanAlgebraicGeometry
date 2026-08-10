---
author: sync
content_type: definition
created: '2026-08-10T11:13:58'
decl: AlgebraicGeometry.PicRankOneFibrePresentationInput.fst
docstring: The map into the public locus is obtained from its universal element by
  Yoneda.
file: AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneFibrePresentationInput.fst
type: lean
updated: '2026-08-10T11:13:58'
---
noncomputable def fst (F : PicRankOneFibrePresentationInput pi g) :
    yoneda.obj (F.W : Scheme.{u}) ⟶ rankOneLocus (C := C) (pi := pi) :=
  yonedaEquiv.symm F.locusValue