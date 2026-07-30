---
author: sync
content_type: theorem
created: '2026-07-29T07:37:19'
decl: AlgebraicGeometry.Over.pullbackOverlapQuot_dualNumberCechH1Equiv_mk
docstring: '**(T3-2): THE §6.24 LINK.** The geometric pullback of a thickened two-chart
  Čech

  `Ȟ¹`-of-units class along the `ε ↦ 0` map of relative curves is the algebraic restriction
  of the

  corresponding dual-number class.


  Read left to right: take `u : (Γ(C, U₀ ⊓ U₁)[ε])ˣ`, carry it to the thickened curve
  by the carrier

  translation `dualNumberSectionsUnits`, descend to the Čech `Ȟ¹` quotient

  (`dualNumberCechH1Equiv`), and pull back along `relCurveMap C k[ε] k` — the result
  is the class of

  `unitsAppLE` applied to the translated unit. That is the square worksheet §6.24
  isolated as the one

  thing standing between the truncated-exponential engine and the two-chart `CechPic`
  comparison.


  **It is `rfl`**, given `cechCoboundaryUnits_preimage_eq` and the target stated in
  the *pulled-back*

  opens. See the module docstring: an earlier phrasing in `relCurve C k`''s own

  `fst ⁻¹ᵁ (U₀ ⊓ U₁)` spelling does not typecheck, and the price the worksheet had
  set for this item

  was based on that phrasing.'
file: AlgebraicJacobian/Tangent/EpsArrowIdentification.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.pullbackOverlapQuot_dualNumberCechH1Equiv_mk
type: lean
updated: '2026-07-30T15:46:08'
---
theorem pullbackOverlapQuot_dualNumberCechH1Equiv_mk
    (hc : ∀ s, IsCompact ((U s : Set C.left))) (hq : ∀ s, IsQuasiSeparated ((U s : Set C.left)))
    (hci : IsCompact (((U false ⊓ U true : C.left.Opens) : Set C.left)))
    (hqi : IsQuasiSeparated (((U false ⊓ U true : C.left.Opens) : Set C.left)))
    (u : (DualNumber Γ(C.left, U false ⊓ U true))ˣ) :
    Scheme.pullbackOverlapQuot (V := fun s => (fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ U s)
        (relCurveMap C (DualNumber k) k)
        (Over.dualNumberCechH1Equiv C hc hq hci hqi (QuotientGroup.mk u))
      = QuotientGroup.mk
          (Scheme.Hom.unitsAppLE (relCurveMap C (DualNumber k) k)
            ((fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ (U false ⊓ U true))
            (relCurveMap C (DualNumber k) k ⁻¹ᵁ
                (fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ U false
              ⊓ relCurveMap C (DualNumber k) k ⁻¹ᵁ
                (fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ U true)
            (Over.epsOverlapLe C U)
            (Over.dualNumberSectionsUnits C hci hqi u)) :=
  rfl