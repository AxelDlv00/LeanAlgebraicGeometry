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
updated: '2026-08-18T20:51:05'
---
lemma fst_comp_incl (F : PicRankOneFibrePresentationInput pi E g) :
    F.fst ≫ picRankOneOpenSigmaIncl pi = yoneda.map F.W.ι ≫ g := by
  apply yonedaEquiv.injective
  rw [yonedaEquiv_comp, fst, Equiv.apply_symm_apply, yonedaEquiv_apply,
    ← F.restrictedValue_eq]
  dsimp [locusValue, picRankOneOpenSigmaIncl,
    CategoryTheory.Over.sigmaExtensionNat]
  rfl