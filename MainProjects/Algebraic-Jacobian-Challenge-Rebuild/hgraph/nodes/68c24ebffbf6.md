---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: IsLocalization.Away.tensorAwayEquiv
docstring: "The canonical `B₁ ⊗[A] B₂`-algebra equivalence from `Si ⊗[A] Sj` (with\
  \ the\n`tensorAwayAlgebra` structure) to any other model `Tij` of the localization\
  \ of\n`B₁ ⊗[A] B₂` away from `(r ⊗ₜ 1) * (1 ⊗ₜ s)`. \n\n\n * Provenance: CUSTOM."
file: AlgebraicJacobian/Algebra/TensorAway.lean
generated: lean
lean_status: lean_ok
title: IsLocalization.Away.tensorAwayEquiv
type: lean
updated: '2026-08-14T19:11:11'
---
noncomputable def tensorAwayEquiv
    [IsLocalization.Away r Si] [IsLocalization.Away s Sj]
    [IsLocalization.Away ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s) : B₁ ⊗[A] B₂) Tij] :
    letI := tensorAwayAlgebra A B₁ B₂ Si Sj
    Si ⊗[A] Sj ≃ₐ[B₁ ⊗[A] B₂] Tij :=
  letI := tensorAwayAlgebra A B₁ B₂ Si Sj
  haveI := isLocalization_away_tensor A B₁ B₂ r s Si Sj
  IsLocalization.algEquiv (Submonoid.powers ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s))) (Si ⊗[A] Sj) Tij