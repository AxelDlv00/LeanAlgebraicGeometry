---
author: sync
content_type: theorem
created: '2026-07-17T18:01:32'
decl: AlgebraicGeometry.picEtMap_picEtPullback
docstring: '**Naturality of the curve transport in the test object**: curve transport
  commutes

  with restriction along an arbitrary morphism of test objects.  The glued value of

  `picEtMap` is pinned by its `IsPullbackValue` characterization, which the transported

  family satisfies through the `mapAlg` bilateral square.'
file: AlgebraicJacobian/Picard/PicEtCurveMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picEtMap_picEtPullback
type: lean
updated: '2026-07-31T20:15:27'
---
theorem picEtMap_picEtPullback (g : D ⟶ E) {T T' : Over (Spec (.of k))} (f : T' ⟶ T)
    (s : picEt E T) :
    picEtMap D f (picEtPullback g T s) = picEtPullback g T' (picEtMap E f s) := by
  refine picEt.ext fun W => ?_
  simp only [picEtMap_val, picEtPullback_val]
  refine picEtMapVal_eq_of D f (picEtPullback g T s) ?_
  intro W₀ hW₀ V hV
  rw [picEtPullback_val, ← PicEtAff.mapAlg_curveMap,
    picEtMapVal_spec E f s W W₀ hW₀ V hV, PicEtAff.mapAlg_curveMap]

/-! ## The functor-level bundling -/