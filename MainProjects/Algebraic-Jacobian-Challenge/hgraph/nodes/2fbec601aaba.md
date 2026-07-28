---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.Scheme.sectionsBaseChangeField_tmul_one
docstring: 'The base-change equivalence on `s ⊗ 1`: it is the pullback of `s` along
  the first

  projection `C_κ ⟶ C`.  The computation rule that makes §3 possible.'
file: AlgebraicJacobian/RiemannRoch/Ledger/SectionsFieldBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.sectionsBaseChangeField_tmul_one
type: lean
updated: '2026-07-29T06:43:23'
---
theorem sectionsBaseChangeField_tmul_one {V : C.left.Opens}
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left))
    (s : Γ(C.left, V)) :
    sectionsBaseChangeField κ hV hV' (s ⊗ₜ 1) =
      (baseChangeFieldFst C κ).appLE V (baseChangeFieldFst C κ ⁻¹ᵁ V) le_rfl s :=
  congr($((CommRingCat.isPushout_tensorProduct k Γ(C.left, V) κ).inl_isoIsPushout_hom _ _
    (isPushout_algebraMap_sections_baseChangeField κ hV hV')).hom s)