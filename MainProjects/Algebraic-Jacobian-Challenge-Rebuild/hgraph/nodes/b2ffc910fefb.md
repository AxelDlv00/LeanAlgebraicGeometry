---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.abelElement_map_point
docstring: '**The pointing law** (the `comp_ofCurve` input, design §4.6): restriction
  of the Abel

  element along the rational point `P` itself is the trivial class — both graph factors

  become the graph class of the same point of the unit test, so the Čech class is
  already

  `1`.'
file: AlgebraicJacobian/Picard/AbelElement.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.abelElement_map_point
type: lean
updated: '2026-07-31T20:15:19'
---
theorem abelElement_map_point (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    (pic0Functor C).map P.op (abelElement C P) = 1 := by
  have h1 : Over.graphPicClass C P
        * (Over.graphPicClass C (toUnit (𝟙_ (Over (Spec (.of k)))) ≫ P))⁻¹ = 1 := by
    rw [toUnit_unique (toUnit (𝟙_ (Over (Spec (.of k))))) (𝟙 _), Category.id_comp,
      mul_inv_cancel]
  refine Subtype.ext ?_
  change picEtMap C P (abelPicEt C P) = 1
  rw [abelPicEt_map P P, h1, map_one, map_one]