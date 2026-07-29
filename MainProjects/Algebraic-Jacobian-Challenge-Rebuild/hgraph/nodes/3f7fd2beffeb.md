---
author: sync
content_type: theorem
created: '2026-07-19T10:01:15'
decl: AlgebraicGeometry.pullback_chartMap_compat
docstring: '**W3 conjugated onto the scheme-level double overlap**: the two chart
  morphisms

  of framed chart maps over `Away fa`, `Away fb` agree after the pullback projections
  —

  `pullbackSpecIso` identifies the overlap with `Spec` of the abstract tensor ring
  and

  `specMap_chart_overlap` closes.  Stated in the `Spec.map (algebraMap …)` spelling
  of

  the frame-cover legs; the cover-spelled obligations consume it by `exact` (defeq).'
file: AlgebraicJacobian/Picard/DivSchemeClassifyGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pullback_chartMap_compat
type: lean
updated: '2026-07-29T15:31:39'
---
theorem pullback_chartMap_compat (F : DivFam C S π g) (fa fb : S)
    {i i' : (glueData k g r₁).J} {j j' : (glueData k g r₂).J}
    (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] Localization.Away fa)
    (w' : PairChartRing k g r₁ g r₂ i' j' →ₐ[k] Localization.Away fb)
    (hw₁ : (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away fa) b₁.equivFun.toLinearMap)
          (divFamEps hπ g (DivFam.mapAlg (Localization.Away fa) g F)).1)
    (hw₂ : (Module.Grassmannian.map w (pairTautSnd k g r₁ r₂ i j)).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away fa) b₂.equivFun.toLinearMap)
          (divFamEps hπ g (DivFam.mapAlg (Localization.Away fa) g F)).2)
    (hw₁' : (Module.Grassmannian.map w' (pairTautFst k g r₁ r₂ i' j')).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away fb) b₁.equivFun.toLinearMap)
          (divFamEps hπ g (DivFam.mapAlg (Localization.Away fb) g F)).1)
    (hw₂' : (Module.Grassmannian.map w' (pairTautSnd k g r₁ r₂ i' j')).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away fb) b₂.equivFun.toLinearMap)
          (divFamEps hπ g (DivFam.mapAlg (Localization.Away fb) g F)).2) :
    pullback.fst (Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away fa))))
        (Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away fb))))
        ≫ Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j
      = pullback.snd
          (Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away fa))))
          (Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away fb))))
          ≫ Spec.map (CommRingCat.ofHom w'.toRingHom)
          ≫ pairChartMap k g r₁ g r₂ i' j' := by
  rw [← cancel_epi
      (pullbackSpecIso S (Localization.Away fa) (Localization.Away fb)).inv,
    pullbackSpecIso_inv_fst_assoc, pullbackSpecIso_inv_snd_assoc]
  exact specMap_chart_overlap hπ g hO hχ r₁ r₂ b₁ b₂ F fa fb w w' hw₁ hw₂ hw₁' hw₂'

set_option maxHeartbeats 800000 in
-- Reduces to the `divSchemeι` composites and the conjugated overlap; elaboration cost.
include hO hχ in