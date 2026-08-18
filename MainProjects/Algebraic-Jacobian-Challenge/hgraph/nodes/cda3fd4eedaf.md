---
author: sync
content_type: theorem
created: '2026-08-03T14:28:06'
decl: AlgebraicGeometry.Grassmannian.pluckerToProj_preimage_basicOpen
docstring: 'The inverse image of a standard projective coordinate open under the

  global Plucker morphism is exactly the corresponding Grassmannian chart.'
file: AlgebraicJacobian/Projective/GrassmannianPluckerGlobalImmersion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.pluckerToProj_preimage_basicOpen
type: lean
updated: '2026-08-18T20:52:09'
---
theorem pluckerToProj_preimage_basicOpen (d r : ℕ)
    (I : PluckerIndex d r) :
    pluckerToProj d r ⁻¹ᵁ
        Proj.basicOpen (homogeneousSubmodule (PluckerIndex d r) (ULift ℤ)) (X I) =
      ((theGlueData d r).ι I).opensRange := by
  ext x
  obtain ⟨J, y, rfl⟩ := (theGlueData d r).ι_jointly_surjective x
  change ((theGlueData d r).ι J ≫ pluckerToProj d r) y ∈
      Proj.basicOpen (homogeneousSubmodule (PluckerIndex d r) (ULift ℤ)) (X I) ↔
    y ∈ (theGlueData d r).ι J ⁻¹ᵁ ((theGlueData d r).ι I).opensRange
  rw [ι_pluckerToProj]
  change y ∈ pluckerChart d r J ⁻¹ᵁ
      Proj.basicOpen (homogeneousSubmodule (PluckerIndex d r) (ULift ℤ)) (X I) ↔
    y ∈ (theGlueData d r).ι J ⁻¹ᵁ ((theGlueData d r).ι I).opensRange
  rw [pluckerChart_preimage_basicOpen,
    glueChart_preimage_opensRange, chartIncl_opensRange]

set_option backward.isDefEq.respectTransparency false in