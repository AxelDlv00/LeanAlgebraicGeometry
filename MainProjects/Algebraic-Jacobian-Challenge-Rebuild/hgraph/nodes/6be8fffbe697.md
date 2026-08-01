---
author: sync
content_type: theorem
created: '2026-07-20T17:31:55'
decl: AlgebraicGeometry.germ_genericPoint_dvd_of_windowCompare_ne_zero
docstring: 'At the generic point, the nonzero compared reading divides every section
  of the pinned

  chart.  In particular this applies to every fibre reading coming from the universal
  window.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignGenericFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.germ_genericPoint_dvd_of_windowCompare_ne_zero
type: lean
updated: '2026-08-01T09:44:12'
---
theorem germ_genericPoint_dvd_of_windowCompare_ne_zero
    (b : Bool)
    (hη : genericPoint (relCurve C K) ∈ relPinnedChart C K π b)
    {x : R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)}
    (hx : windowCompare R K x ≠ 0)
    (t : Γ(relCurve C K, relPinnedChart C K π b)) :
    ((relCurve C K).presheaf.germ (relPinnedChart C K π b)
      (genericPoint (relCurve C K)) hη).hom
      (relPinnedSectionsMap C R K π b
        (relThetaResSide a b le_rfl (relThetaWindowEquiv C R π a hH1 x))) ∣
      ((relCurve C K).presheaf.germ (relPinnedChart C K π b)
        (genericPoint (relCurve C K)) hη).hom t :=
  (isUnit_germ_genericPoint_of_windowCompare_ne_zero C R K π a hH1 b hη hx).dvd