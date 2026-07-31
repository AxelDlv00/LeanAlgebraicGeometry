---
author: sync
content_type: lemma
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.baseChangeField_V₁
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.baseChangeField_V₁
type: lean
updated: '2026-07-31T08:04:21'
---
@[simp] lemma baseChangeField_V₁ (D : FiberCoordinateData C.left) :
    (D.baseChangeField κ).V₁ = baseChangeFieldFst C κ ⁻¹ᵁ D.V₁ := rfl