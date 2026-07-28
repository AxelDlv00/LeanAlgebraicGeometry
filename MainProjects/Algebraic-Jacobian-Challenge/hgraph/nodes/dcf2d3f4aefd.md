---
author: sync
content_type: definition
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.Scheme.sectionsBaseChangeField
docstring: '**Base change of chart sections along a field extension, as a ring equivalence**:

  `Γ(C.left, V) ⊗[k] κ ≃+* Γ(C_κ, fst ⁻¹ᵁ V)`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/SectionsFieldBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.sectionsBaseChangeField
type: lean
updated: '2026-07-29T06:43:23'
---
noncomputable def sectionsBaseChangeField {V : C.left.Opens}
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left)) :
    Γ(C.left, V) ⊗[k] κ ≃+* Γ((baseChangeField C κ).left, baseChangeFieldFst C κ ⁻¹ᵁ V) :=
  ((CommRingCat.isPushout_tensorProduct k Γ(C.left, V) κ).isoIsPushout _ _
    (isPushout_algebraMap_sections_baseChangeField κ hV hV')).commRingCatIsoToRingEquiv