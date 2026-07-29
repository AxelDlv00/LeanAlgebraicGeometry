---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: IsLocalization.Away.tensorAwayEquiv
docstring: 'The canonical `B₁ ⊗[A] B₂`-algebra equivalence from `Si ⊗[A] Sj` (with
  the

  `tensorAwayAlgebra` structure) to any other model `Tij` of the localization of

  `B₁ ⊗[A] B₂` away from `(r ⊗ₜ 1) * (1 ⊗ₜ s)`.'
file: AlgebraicJacobian/Algebra/TensorAway.lean
generated: lean
lean_status: lean_ok
title: IsLocalization.Away.tensorAwayEquiv
type: lean
updated: '2026-07-29T15:31:34'
---
noncomputable def tensorAwayEquiv
    [IsLocalization.Away r Si] [IsLocalization.Away s Sj]
    [IsLocalization.Away ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s) : B₁ ⊗[A] B₂) Tij] :
    letI := tensorAwayAlgebra A B₁ B₂ Si Sj
    Si ⊗[A] Sj ≃ₐ[B₁ ⊗[A] B₂] Tij :=
  letI := tensorAwayAlgebra A B₁ B₂ Si Sj
  haveI := isLocalization_away_tensor A B₁ B₂ r s Si Sj
  IsLocalization.algEquiv (Submonoid.powers ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s))) (Si ⊗[A] Sj) Tij