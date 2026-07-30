---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Jacobian.baseChangeIso_comp
docstring: Cocycle coherence for a tower `k → L → M`.
file: AlgebraicJacobian/Challenge.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Jacobian.baseChangeIso_comp
type: lean
updated: '2026-07-30T15:45:59'
---
theorem baseChangeIso_comp (k L M : Type u) [Field k] [Field L] [Field M]
    [Algebra k L] [Algebra L M] [Algebra k M] [IsScalarTower k L M]
    (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    baseChangeIso k M C
        ≪≫ Jacobian.congr ((baseChange.compIso k L M).app C) =
      (Functor.mapGrpNatIso (baseChange.compIso k L M)).app _
        ≪≫ (Functor.mapGrpCompIso (F := baseChange k L) (G := baseChange L M)).app _
        ≪≫ (baseChange L M).mapGrp.mapIso (baseChangeIso k L C)
        ≪≫ baseChangeIso L M ((baseChange k L).obj C) :=
  sorry

/-! ## Compatibility with the Abel-Jacobi map -/

variable {L : Type u} [Field L] [Algebra k L]