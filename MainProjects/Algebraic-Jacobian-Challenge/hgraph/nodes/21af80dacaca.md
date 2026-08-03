---
author: sync
content_type: theorem
created: '2026-08-03T14:28:06'
decl: AlgebraicGeometry.Grassmannian.glueChart_preimage_opensRange
docstring: 'Inside one affine Grassmannian chart, the inverse image of another chart''s

  range is the overlap localization.'
file: AlgebraicJacobian/Projective/GrassmannianPluckerGlobalImmersion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.glueChart_preimage_opensRange
type: lean
updated: '2026-08-03T14:28:06'
---
theorem glueChart_preimage_opensRange (d r : ℕ)
    (I J : (theGlueData d r).J) :
    (theGlueData d r).ι J ⁻¹ᵁ ((theGlueData d r).ι I).opensRange =
      (chartIncl d r J.1 I.1 J.2 I.2).opensRange := by
  have hp := IsPullback.of_isLimit ((theGlueData d r).vPullbackConeIsLimit J I)
  change (theGlueData d r).ι J ⁻¹ᵁ ((theGlueData d r).ι I).opensRange =
    ((theGlueData d r).f J I).opensRange
  rw [← Scheme.Hom.opensRange_pullbackFst]
  have hfst := hp.isoPullback_hom_fst
  change hp.isoPullback.hom ≫
      pullback.fst ((theGlueData d r).ι J) ((theGlueData d r).ι I) =
    (theGlueData d r).f J I at hfst
  have hrange :
      (hp.isoPullback.hom ≫ pullback.fst ((theGlueData d r).ι J)
        ((theGlueData d r).ι I)).opensRange =
      (pullback.fst ((theGlueData d r).ι J)
        ((theGlueData d r).ι I)).opensRange := by
    rw [Scheme.Hom.opensRange_comp, Scheme.Hom.opensRange_of_isIso]
    simp
  rw [← hrange]
  congr 1

set_option backward.isDefEq.respectTransparency false in