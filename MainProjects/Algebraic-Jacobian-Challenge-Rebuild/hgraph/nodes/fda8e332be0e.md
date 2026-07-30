---
author: sync
content_type: theorem
created: '2026-07-17T16:57:11'
decl: AlgebraicGeometry.Scheme.RationalMap.selfDiag_comp_toPartialMap_hom
docstring: '**Diagonal triviality, morphism level.** Any factorisation `dj` of the

  diagonal `Dom f₀ ⟶ X ×_{k̄} X` through the domain of the maximal representative

  `Φ₀` composes with `Φ₀` to the constant unit morphism:

  `Φ(x, x) = f(x)·f(x)⁻¹ = e` (Milne, *Abelian Varieties*, §I.3 p. 17).'
file: AlgebraicJacobian/Albanese/Milne33Diagonal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.RationalMap.selfDiag_comp_toPartialMap_hom
type: lean
updated: '2026-07-30T15:45:59'
---
theorem selfDiag_comp_toPartialMap_hom
    (dj : (↑f.toPartialMap.domain : Scheme.{u}) ⟶
      ↑(differenceRationalMap f hover).toPartialMap.domain)
    (hdj : dj ≫ (differenceRationalMap f hover).toPartialMap.domain.ι
      = f.toPartialMap.domain.ι ≫ selfDiag X) :
    dj ≫ (differenceRationalMap f hover).toPartialMap.hom
      = f.toPartialMap.domain.ι ≫ X.hom ≫ grpObjUnitPoint G := by
  have hj : dj ≫ (differenceRationalMap f hover).toPartialMap.domain.ι
      = pullback.lift (𝟙 _ ≫ f.toPartialMap.domain.ι) (𝟙 _ ≫ f.toPartialMap.domain.ι)
          rfl := by
    rw [hdj, domainι_comp_selfDiag]
  have heval := comp_toPartialMap_hom_eq_diff f hover (𝟙 _) (𝟙 _) rfl dj hj
  rw [heval, pullback_lift_diff_self G (f.toPartialMap.domain.ι ≫ X.hom)
    (𝟙 _ ≫ f.toPartialMap.hom)
    (by rw [Category.id_comp, toPartialMap_hom_comp_hom f hover]), Category.assoc]