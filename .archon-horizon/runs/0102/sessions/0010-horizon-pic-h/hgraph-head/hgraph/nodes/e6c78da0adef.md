---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.Scheme.RationalMap.differenceRationalMap_compHom_over
docstring: '**The difference map is a `k̄`-rational map.** Right-composing `Φ` with
  the

  structure morphism `G.hom` recovers the structure morphism `pr₁ ≫ X.hom` of

  `X ×_{k̄} X`.'
file: AlgebraicJacobian/Albanese/DifferenceMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.RationalMap.differenceRationalMap_compHom_over
type: lean
updated: '2026-08-01T09:44:08'
---
theorem differenceRationalMap_compHom_over
    (f : X.left.RationalMap G.left)
    (hover : f.compHom G.hom = X.hom.toRationalMap)
    [IsIntegral (pullback X.hom X.hom)] :
    (differenceRationalMap f hover).compHom G.hom
      = (pullback.fst X.hom X.hom ≫ X.hom).toRationalMap := by
  simp only [differenceRationalMap]
  rw [RationalMap.compHom_compHom, grpObjDiffLeft_comp_hom]
  exact RationalMap.prod_compHom_over _ _ _ _ _ _ _