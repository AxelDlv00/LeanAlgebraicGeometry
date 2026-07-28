---
author: sync
content_type: lemma
created: '2026-07-24T05:32:11'
decl: AlgebraicGeometry.iota_image_preimage_eq_inf
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLegTop.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.iota_image_preimage_eq_inf
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma iota_image_preimage_eq_inf (U V : TopologicalSpace.Opens X) :
    Scheme.Opens.ι U ''ᵁ (Scheme.Opens.ι U ⁻¹ᵁ V) = U ⊓ V := by
  rw [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]