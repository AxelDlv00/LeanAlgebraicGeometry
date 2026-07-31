---
author: sync
content_type: theorem
created: '2026-07-21T23:32:10'
decl: AlgebraicGeometry.resHom_relThetaFieldSection_thetaWindowMul_fst
docstring: Arbitrary-exponent multiplication for base-field relative theta sections,
  chart 0.
file: AlgebraicJacobian/Picard/DivSchemeWindowMulGeneral.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.resHom_relThetaFieldSection_thetaWindowMul_fst
type: lean
updated: '2026-07-31T20:14:51'
---
theorem resHom_relThetaFieldSection_thetaWindowMul_fst (p q : Nat)
    (a : ↥(divisorSections k (p • fiberWeilDivisor pi) ⊤))
    (m : ↥(divisorSections k (q • fiberWeilDivisor pi) ⊤)) :
    (relCurve C k).resHom (le_inf le_top le_rfl)
        ((relThetaFieldSection C pi (p + q)
          (thetaWindowMul (C := C) (pi := pi) p q a m)).val.1) =
      (relCurve C k).resHom (le_inf le_top le_rfl)
          ((relThetaFieldSection C pi p a).val.1) *
        (relCurve C k).resHom (le_inf le_top le_rfl)
          ((relThetaFieldSection C pi q m).val.1) := by
  rw [resHom_relThetaFieldSection_fst, resHom_relThetaFieldSection_fst,
    resHom_relThetaFieldSection_fst, thetaSectionPair_thetaWindowMul_fst, map_mul,
    sectionsCollapse_mul]