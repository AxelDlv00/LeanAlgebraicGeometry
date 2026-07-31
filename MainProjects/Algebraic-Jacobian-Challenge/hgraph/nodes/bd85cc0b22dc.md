---
author: sync
content_type: lemma
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.overlapInverseCoordinate_baseChangeField
docstring: 'The overlap inverse coordinate pulls back to the overlap inverse coordinate
  after field

  extension.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.overlapInverseCoordinate_baseChangeField
type: lean
updated: '2026-07-31T17:19:39'
---
lemma overlapInverseCoordinate_baseChangeField :
    (D.baseChangeField κ).overlapInverseCoordinate =
      sectionsBaseChangeFieldₗ κ
        D.toAffineCoverMVSquare.isAffineOpen_inf.isCompact
        D.toAffineCoverMVSquare.isAffineOpen_inf.isQuasiSeparated
        (1 ⊗ₜ D.overlapInverseCoordinate) := by
  rw [sectionsBaseChangeFieldₗ_one_tmul]
  let f := baseChangeFieldFst C κ
  have h :
      ((Scheme.baseChangeField C κ).left.presheaf.map
        (homOfLE (inf_le_right :
          (f ⁻¹ᵁ D.V₀) ⊓ (f ⁻¹ᵁ D.V₁) ≤ f ⁻¹ᵁ D.V₁)).op).hom
          ((f.app D.V₁).hom D.y) =
        (f.app (D.V₀ ⊓ D.V₁)).hom
          ((C.left.presheaf.map
            (homOfLE (inf_le_right : D.V₀ ⊓ D.V₁ ≤ D.V₁)).op).hom D.y) := by
    have hnat := congrArg
      (fun g : Γ(C.left, D.V₁) ⟶
        Γ((Scheme.baseChangeField C κ).left, f ⁻¹ᵁ (D.V₀ ⊓ D.V₁)) => g.hom D.y)
      (f.naturality (homOfLE (inf_le_right : D.V₀ ⊓ D.V₁ ≤ D.V₁)).op)
    exact hnat.symm
  simpa only [overlapInverseCoordinate, baseChangeField_y, baseChangeField_V₀,
    baseChangeField_V₁, toAffineCoverMVSquare, Scheme.Hom.appLE_eq_app] using h