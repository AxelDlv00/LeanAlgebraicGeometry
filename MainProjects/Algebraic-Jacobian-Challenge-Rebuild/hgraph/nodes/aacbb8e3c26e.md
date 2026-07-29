---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.transitionMap_comp_algHom
docstring: '`AlgHom`-level composition form: `θ_{I,J} ∘ (R^J →ₐ[k] R^J[1/P^J_I]) =
  θ̃_{I,J}`.'
file: AlgebraicJacobian/Picard/GrassmannianChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.transitionMap_comp_algHom
type: lean
updated: '2026-07-29T15:31:46'
---
theorem transitionMap_comp_algHom (k : Type u) [Field k] (d r : ℕ)
    (I J : Finset (Fin r)) (hI : I.card = d) (hJ : J.card = d) :
    (transitionMap k d r I J hI hJ).comp
        (Algebra.algHom k (ChartRing k d r J)
          (Localization.Away (minorDet k d r J I hJ hI)))
      = transitionPreMap k d r I J hI hJ :=
  AlgHom.coe_ringHom_injective (transitionMap_comp_algebraMap k d r I J hI hJ)