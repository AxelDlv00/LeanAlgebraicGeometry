---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Scheme.Hom.functionFieldMap_germ
docstring: '**Germ naturality of the function-field map**: pulling back the germ at
  `η` of a section

  is the germ at `η` of the pulled-back section.  This is the seam through which the
  orders of

  pulled-back local equations are computed (E-iv-alg step 4).'
file: AlgebraicJacobian/Curve/BaseFieldTransition.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Hom.functionFieldMap_germ
type: lean
updated: '2026-07-30T15:28:03'
---
theorem Scheme.Hom.functionFieldMap_germ (f : X ⟶ Y)
    (h : f.base (genericPoint X) = genericPoint Y) (U : Y.Opens)
    (hη : genericPoint Y ∈ U) (hη' : genericPoint X ∈ f ⁻¹ᵁ U) (s : Γ(Y, U)) :
    (f.functionFieldMap h).hom ((Y.presheaf.germ U (genericPoint Y) hη).hom s)
      = (X.presheaf.germ (f ⁻¹ᵁ U) (genericPoint X) hη').hom ((f.app U).hom s) := by
  have hmem : f.base (genericPoint X) ∈ U := h ▸ hη
  have hgerm : (Y.presheaf.stalkCongr
        (Inseparable.of_eq h.symm)).hom.hom ((Y.presheaf.germ U (genericPoint Y) hη).hom s)
      = (Y.presheaf.germ U (f.base (genericPoint X)) hmem).hom s := by
    rw [TopCat.Presheaf.stalkCongr_hom, ← CommRingCat.comp_apply,
      Y.presheaf.germ_stalkSpecializes]
  rw [Scheme.Hom.functionFieldMap, CommRingCat.hom_comp, RingHom.comp_apply, hgerm]
  exact f.germ_stalkMap_apply U (genericPoint X) hmem s