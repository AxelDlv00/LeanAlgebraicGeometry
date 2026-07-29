---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.isDescentCocycle_comparisonDescentUnit
docstring: '**The per-piece descent unit of a coherent comparison unit is a descent
  1-cocycle**

  ((C2) effectivity, brick E2).  The diagonal normalization is the `id_S ⊗ lmul''`

  hypothesis `hlmul` — the cochain source is `Over.normalizedComparison_diagonal_eq_one`

  restricted to the piece; the cocycle identity is the Amitsur identity through the
  three

  cofaces `hcoc` — the cochain source is `NormalizedCechComparison.coherent`.  Both
  are

  transported through the descent-cocycle ring identifications by the coprojection–face

  compatibility lemmas.'
file: AlgebraicJacobian/Picard/EffectivityDescentDatum.lean
generated: lean
lean_status: lean_ok
title: Module.isDescentCocycle_comparisonDescentUnit
type: lean
updated: '2026-07-29T15:31:46'
---
theorem isDescentCocycle_comparisonDescentUnit {v : (S ⊗[A] (B ⊗[A] B))ˣ}
    (hlmul : Algebra.TensorProduct.map (AlgHom.id S S) (Algebra.TensorProduct.lmul' A) v.val
      = 1)
    (hcoc : Algebra.TensorProduct.map (AlgHom.id S S) (Module.descentFace₂₃ A B) v.val
          * Algebra.TensorProduct.map (AlgHom.id S S) (Module.descentFace₁₂ A B) v.val
        = Algebra.TensorProduct.map (AlgHom.id S S) (Module.descentFace₁₃ A B) v.val) :
    Module.IsDescentCocycle (comparisonDescentUnit A S B v) where
  lmul'_eq_one := by
    change Algebra.TensorProduct.lmul' S (S := S ⊗[A] B)
      (comparisonDescentUnit A S B v).val = 1
    rw [pieceDescentEquiv_lmul', pieceDescentEquiv_comparisonDescentUnit_val, hlmul]
  cocycle := by
    apply (pieceDescentTripleEquiv A S B).injective
    rw [map_mul, pieceDescentTripleEquiv_descentFace₂₃,
      pieceDescentTripleEquiv_descentFace₁₂, pieceDescentTripleEquiv_descentFace₁₃,
      pieceDescentEquiv_comparisonDescentUnit_val, hcoc]

/-! ## The descended per-piece Picard class -/

variable [Module.FaithfullyFlat A B]