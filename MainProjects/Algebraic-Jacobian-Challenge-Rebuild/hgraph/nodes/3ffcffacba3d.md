---
author: sync
content_type: lemma
created: '2026-08-10T11:13:58'
decl: AlgebraicGeometry.PicRankOneFibrePresentationInput.fst_comp_incl
file: AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneFibrePresentationInput.fst_comp_incl
type: lean
updated: '2026-08-10T11:13:58'
---
lemma fst_comp_incl (F : PicRankOneFibrePresentationInput pi g) :
    F.fst ≫ picRankOneOpenSigmaIncl pi = yoneda.map F.W.ι ≫ g := by
  apply yonedaEquiv.injective
  change (picRankOneOpenSigmaIncl pi).app (op (F.W : Scheme.{u})) F.locusValue =
    (yoneda.map F.W.ι ≫ g).app (op (F.W : Scheme.{u})) (𝟙 (F.W : Scheme.{u}))
  dsimp [locusValue, picRankOneOpenSigmaIncl,
    CategoryTheory.Over.sigmaExtensionNat]
  rw [← F.restrictedValue_eq]