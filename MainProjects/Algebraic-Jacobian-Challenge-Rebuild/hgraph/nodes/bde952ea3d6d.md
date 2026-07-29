---
author: sync
content_type: theorem
created: '2026-07-29T13:19:43'
decl: AlgebraicGeometry.Over.unitsAppLE_dualNumberSectionsUnits
docstring: '**§7.8''s section equation, units form** — the shape the Čech `Ȟ¹` quotients
  consume, since a

  two-chart `Ȟ¹` is a quotient of a group of *units*. `Units.ext` over the ring form;
  the

  `unitsAppLE`/`collapseUnits`/`Units.map` coercions are all `rfl` on the underlying
  section

  (`coe_unitsAppLE`, and `collapseUnits` is `Units.mapEquiv` of `collapseRingEquiv`).'
file: AlgebraicJacobian/Tangent/EpsReductionSquare.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.unitsAppLE_dualNumberSectionsUnits
type: lean
updated: '2026-07-29T13:19:43'
---
theorem unitsAppLE_dualNumberSectionsUnits {W : C.left.Opens}
    (hW : IsCompact (W : Set C.left)) (hW' : IsQuasiSeparated (W : Set C.left))
    {V' : (relCurve C k).Opens}
    (e : V' ≤ relCurveMap C (DualNumber k) k ⁻¹ᵁ
        ((fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ W))
    (hle : V' ≤ (fst C (overSpec k k)).left ⁻¹ᵁ W)
    (u : (DualNumber Γ(C.left, W))ˣ) :
    (relCurveMap C (DualNumber k) k).unitsAppLE
        ((fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ W) V' e
        (Over.dualNumberSectionsUnits C hW hW' u)
      = Units.map ((relCurve C k).resHom hle).toMonoidHom
          (collapseUnits C W hW hW' (unitsFst u)) := by
  ext
  exact appLE_dualNumberSections C hW hW' e hle (u : DualNumber Γ(C.left, W))