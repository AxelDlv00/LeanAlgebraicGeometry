---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.pieceRingEquiv_naturality
docstring: '**The restriction seam** (the E3 consumer): for affine opens `W ≤ V`,
  restricting the

  identified cover section is identifying the restricted base section.  The map on
  tensor

  products is `Algebra.TensorProduct.map` of the restriction `resAlgHomA` and the
  identity of

  `B`.  This is what lets the per-piece descent data of E2 be compared on overlaps.'
file: AlgebraicJacobian/Picard/EffectivityPieces.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.pieceRingEquiv_naturality
type: lean
updated: '2026-07-16T21:33:28'
---
theorem pieceRingEquiv_naturality {V W : (XA).Opens} (hV : IsAffineOpen V)
    (hW : IsAffineOpen W) (hWV : W ≤ V) (x : Γ(XA, V) ⊗[A] B) :
    (XB).presheaf.map
        (homOfLE (show (cg) ⁻¹ᵁ W ≤ (cg) ⁻¹ᵁ V from (cg).preimage_mono hWV)).op
        (pieceRingEquiv C hV x)
      = pieceRingEquiv C hW
          (Algebra.TensorProduct.map (resAlgHomA C hWV) (AlgHom.id A B) x) := by
  induction x with
  | zero => simp only [map_zero]
  | add x y hx hy => simp only [map_add, hx, hy]
  | tmul s b =>
    rw [Algebra.TensorProduct.map_tmul, AlgHom.coe_id, id_eq, resAlgHomA_apply,
      pieceRingEquiv_tmul, pieceRingEquiv_tmul, map_mul]
    congr 1
    · rw [← CommRingCat.comp_apply, Scheme.Hom.appLE_map, ← CommRingCat.comp_apply,
        Scheme.Hom.map_appLE]
    · rw [← CommRingCat.comp_apply, Category.assoc, Scheme.Hom.appLE_map]

/-! ## The affine basis packaging -/