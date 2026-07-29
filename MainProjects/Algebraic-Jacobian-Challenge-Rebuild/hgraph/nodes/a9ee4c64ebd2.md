---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Scheme.isSheaf_moduleKPresheaf
file: AlgebraicJacobian/Cohomology/ModuleKSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isSheaf_moduleKPresheaf
type: lean
updated: '2026-07-29T15:31:35'
---
lemma Scheme.isSheaf_moduleKPresheaf :
    Presheaf.IsSheaf (Opens.grothendieckTopology (X : TopCat)) (X.moduleKPresheaf k) := by
  have h : TopCat.Presheaf.IsSheaf (C := ModuleCat.{u} k) (X := (X : TopCat))
      (X.moduleKPresheaf k) := by
    rw [TopCat.Presheaf.isSheaf_iff_isSheaf_comp' (CategoryTheory.forget (ModuleCat.{u} k))
      (X.moduleKPresheaf k)]
    change Presheaf.IsSheaf (Opens.grothendieckTopology (X : TopCat)) _
    rw [Presheaf.isSheaf_of_iso_iff (X.moduleKPresheafCompForgetIso k)]
    exact (TopCat.Presheaf.isSheaf_iff_isSheaf_comp'
      (CategoryTheory.forget CommRingCat) X.presheaf).mp X.toSheafedSpace.IsSheaf
  exact h