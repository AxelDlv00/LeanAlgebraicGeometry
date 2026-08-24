---
author: sync
content_type: theorem
created: '2026-08-21T07:11:38'
decl: AlgebraicGeometry.rankOneAbel_isOpenImmersion
docstring: 'The canonical rank-one Abel isomorphism followed by the public rank-one-locus

  inclusion is an open immersion.'
file: AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rankOneAbel_isOpenImmersion
type: lean
updated: '2026-08-21T07:11:38'
---
theorem rankOneAbel_isOpenImmersion
    (hopen : PicRankOneOpen.IsOpen (divRepAffP1Map C)) :
    IsOpenImmersion.presheaf
      ((canonicalRankOneAbelIso (C := C)).hom ≫
        picRankOneOpenSigmaIncl (divRepAffP1Map C)) := by
  apply MorphismProperty.IsStableUnderComposition.comp_mem
  · exact MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) _
  · exact hopen