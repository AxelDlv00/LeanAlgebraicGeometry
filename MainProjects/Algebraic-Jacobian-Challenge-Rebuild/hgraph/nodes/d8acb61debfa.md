---
author: sync
content_type: theorem
created: '2026-07-30T21:44:01'
decl: AlgebraicGeometry.AffAdaptation.intrinsicThetaGluedToPiece_overlap
docstring: The piece projections from the intrinsic theta equalizer agree on every
  overlap.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCech.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.intrinsicThetaGluedToPiece_overlap
type: lean
updated: '2026-07-31T20:14:51'
---
theorem intrinsicThetaGluedToPiece_overlap (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    A.thetaToOverlapLeftGlued (π := π) a i j ∘ₗ
        A.intrinsicThetaGluedToPiece (π := π) a i =
      A.thetaToOverlapRightGlued (π := π) a i j ∘ₗ
        A.intrinsicThetaGluedToPiece (π := π) a j := by
  apply LinearMap.ext
  intro x
  exact (A.mem_intrinsicThetaGluedSubmodule_iff (π := π) a _).mp x.2 (i, j)

section Universal

variable (A : AffAdaptation D d)
variable {M : Type u} [AddCommGroup M]
  [Module ↥(gluedSubalgebra A) M]

set_option synthInstance.maxHeartbeats 200000 in
-- The nested dependent-product module action exceeds the default instance-search budget.