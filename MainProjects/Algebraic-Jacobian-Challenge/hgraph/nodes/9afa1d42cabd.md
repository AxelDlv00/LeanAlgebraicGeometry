---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Adelic.homOfLE_chartMor₁
docstring: The second chart morphism is functorial in restriction.
file: AlgebraicJacobian/RiemannRoch/Adelic/NonconstantToP1.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Adelic.homOfLE_chartMor₁
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma homOfLE_chartMor₁ {U V : Y.Opens} (h : V ≤ U) (s : Γ(Y, U)) :
    Y.homOfLE h ≫ chartMor₁ U s = chartMor₁ V (Y.presheaf.map (homOfLE h).op s) := by
  rw [chartMor₁, chartMor₁, ← Scheme.Opens.toSpecΓ_SpecMap_presheaf_map_assoc V U h,
    ← Spec.map_comp_assoc, ← CommRingCat.ofHom_hom (Y.presheaf.map (homOfLE h).op),
    ← CommRingCat.ofHom_comp, comp_chartHom₁]