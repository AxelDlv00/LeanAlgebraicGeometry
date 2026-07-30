---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.faithfullyFlat_pieceCover
docstring: '**Faithful flatness of the cover piece over the base piece.** When `A
  → B` is faithfully

  flat, so is `Γ(V) → Γ(cg⁻¹ V)`: `Γ(V) ⊗[A] B` is faithfully flat over `Γ(V)` by
  mathlib''s

  base-change instance, transported along `pieceEquiv`.'
file: AlgebraicJacobian/Picard/EffectivityPieces.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.faithfullyFlat_pieceCover
type: lean
updated: '2026-07-30T15:46:04'
---
theorem faithfullyFlat_pieceCover [Module.FaithfullyFlat A B] {U : (XA).Opens}
    (hU : IsAffineOpen U) :
    Module.FaithfullyFlat Γ(XA, U) Γ(XB, (cg) ⁻¹ᵁ U) :=
  Module.FaithfullyFlat.of_linearEquiv _ _ (pieceEquiv C hU).toLinearEquiv

/-! ## Restriction compatibility (the E2/E3 seam) -/