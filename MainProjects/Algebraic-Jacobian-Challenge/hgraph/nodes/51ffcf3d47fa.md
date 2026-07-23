---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.sectionProdEquiv_symm_apply
docstring: 'Reading the inverse comparison coordinatewise: applying `sectionToModuleAddEquiv.symm`

  to a module tuple `z` and projecting recovers `φ_τ⁻¹ (z τ)`.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sectionProdEquiv_symm_apply
type: lean
updated: '2026-07-24T03:02:09'
---
private lemma sectionProdEquiv_symm_apply (q : ℕ) (z : ∀ σ : Fin (q + 1) → ι, dCoeff s M σ)
    (τ : Fin (q + 1) → ι) :
    sectionCechProductEquiv (tU s) (tP M) q ((sectionToModuleAddEquiv M s q).symm z) τ
      = (phi M s τ).symm (z τ) := by
  have h : sectionCechProductEquiv (tU s) (tP M) q ((sectionToModuleAddEquiv M s q).symm z)
      = sectionProdAddEquiv M s q ((sectionProdAddEquiv M s q).symm
          ((AddEquiv.piCongrRight (fun σ => phi M s σ)).symm z)) := rfl
  rw [h, AddEquiv.apply_symm_apply]
  rfl