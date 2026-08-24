---
author: sync
content_type: theorem
created: '2026-08-06T15:56:43'
decl: AlgebraicGeometry.divRankOneOpenPullbackMap_presheaf_isOpenImmersion
docstring: The arbitrary slice pullback remains an open immersion after passing to
  Yoneda.
file: AlgebraicJacobian/Picard/DivRankOneOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRankOneOpenPullbackMap_presheaf_isOpenImmersion
type: lean
updated: '2026-08-18T20:50:56'
---
theorem divRankOneOpenPullbackMap_presheaf_isOpenImmersion
    (h : DivRankOneOpenData (C := C) pi)
    {T : Over (Spec (.of k))} (q : T ⟶ divRepAffGenusScheme C) :
    IsOpenImmersion.presheaf
      (yoneda.map (divRankOneOpenPullback pi h q).ι) := by
  exact MorphismProperty.relative_map (divRankOneOpenPullback_isOpenImmersion pi h q)