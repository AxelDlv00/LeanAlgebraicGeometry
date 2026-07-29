---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: Algebra.TensorProduct.pieceDescentTripleEquiv_descentFace₂₃
docstring: '**`descentFace₂₃` compatibility**: the triple identification intertwines
  the coface

  `descentFace₂₃` of `M ⊗[S] M` with the base-changed coface `id_S ⊗ descentFace₂₃`.'
file: AlgebraicJacobian/Picard/EffectivityDescentDatum.lean
generated: lean
lean_status: lean_ok
stale: true
title: Algebra.TensorProduct.pieceDescentTripleEquiv_descentFace₂₃
type: lean
updated: '2026-07-29T15:26:19'
---
lemma pieceDescentTripleEquiv_descentFace₂₃ (y : (S ⊗[A] B) ⊗[S] (S ⊗[A] B)) :
    pieceDescentTripleEquiv A S B (Module.descentFace₂₃ S (S ⊗[A] B) y)
      = Algebra.TensorProduct.map (AlgHom.id S S) (Module.descentFace₂₃ A B)
          (pieceDescentEquiv A S B y) := by
  induction y with
  | tmul m₁ m₂ => induction m₁ with
    | tmul s₁ b₁ => induction m₂ with
      | tmul s₂ b₂ =>
        rw [pieceDescentEquiv_tmul, Module.descentFace₂₃_apply,
          Algebra.TensorProduct.one_def, pieceDescentTripleEquiv_tmul,
          Algebra.TensorProduct.map_tmul, AlgHom.id_apply, Module.descentFace₂₃_apply]
        ring_nf
      | add x y hx hy => simp only [TensorProduct.tmul_add, map_add, hx, hy]
      | zero => simp only [TensorProduct.tmul_zero, map_zero]
    | add x y hx hy => simp only [TensorProduct.add_tmul, map_add, hx, hy]
    | zero => simp only [TensorProduct.zero_tmul, map_zero]
  | add x y hx hy => simp only [map_add, hx, hy]
  | zero => simp only [map_zero]