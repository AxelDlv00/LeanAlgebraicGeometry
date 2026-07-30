---
author: sync
content_type: theorem
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.Grassmannian.cocycleΘIK_comp_algebraMap
docstring: '`Θ_{I,K}` restricted along the structure map of `S_K` is `ι^R ∘ θ̃_{I,K}`.'
file: AlgebraicJacobian/Picard/GrassmannianCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.cocycleΘIK_comp_algebraMap
type: lean
updated: '2026-07-30T15:46:05'
---
theorem cocycleΘIK_comp_algebraMap (k : Type u) [Field k] (d r : ℕ)
    (I J K : Finset (Fin r)) (hI : I.card = d) (hJ : J.card = d) (hK : K.card = d) :
    (cocycleΘIK k d r I J K hI hJ hK).toRingHom.comp
        (algebraMap (ChartRing k d r K)
          (Localization.Away (minorDet k d r K I hK hI * minorDet k d r K J hK hJ)))
      = ((awayInclRight k (minorDet k d r I J hI hJ) (minorDet k d r I K hI hK)).comp
          (transitionPreMap k d r I K hI hK)).toRingHom :=
  IsLocalization.lift_comp _