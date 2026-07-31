---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.exists_pieceComparisonUnit_eq_one
docstring: '**Flattening**: if the descended class of a trivialized piece is trivial,
  the piece

  carries a trivialization whose glued comparison unit is `1` on the nose.  The

  `picClass_eq_one_iff` cobounding unit, pulled back through the seams, twists the

  trivialization flat.'
file: AlgebraicJacobian/Picard/EffectivityOverlap.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.exists_pieceComparisonUnit_eq_one
type: lean
updated: '2026-07-31T20:14:51'
---
theorem exists_pieceComparisonUnit_eq_one [Module.FaithfullyFlat A B]
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    {𝒩 : (XB).PointedCover} {γ : (XB).unitsCocycle 𝒩}
    (W : NormalizedCechComparison k A B C σ 𝒩 γ) {V : (XA).Opens} (hV : IsAffineOpen V)
    (T : PieceTrivialization C 𝒩 γ V) (h1 : pieceDescentClass C σ W hV T = 1) :
    ∃ T' : PieceTrivialization C 𝒩 γ V, pieceComparisonUnit C σ W T' = 1 := by
  have hu := Module.isDescentCocycle_comparisonDescentUnit A Γ(XA, V) B
    (pieceComparisonTensorUnit_lmul C σ W hV T)
    (pieceComparisonTensorUnit_cocycle C σ W hV T)
  obtain ⟨β, hβ⟩ := hu.picClass_eq_one_iff.mp h1
  -- pull the cobounding unit back to a geometric unit of the cover piece
  set e : Γ(XB, (cg) ⁻¹ᵁ V)ˣ := Units.map (Over.pieceEquiv (A := A) (B := B) C
    hV).symm.toAlgHom.toRingHom.toMonoidHom β with he
  have heβ : Units.map (Over.pieceEquiv (A := A) (B := B) C
      hV).toAlgHom.toRingHom.toMonoidHom e = β := by
    refine Units.ext ?_
    exact (Over.pieceEquiv (A := A) (B := B) C hV).apply_symm_apply β.val
  -- the comparison unit of `T` is the geometric coboundary of `e`
  have hvT : pieceComparisonUnit C σ W T = geomCoboundary C e := by
    have h2 : pieceComparisonTensorUnit C σ W hV T
        = Units.map (Over.pieceEquiv (A := A) (B := B ⊗[A] B) C
            hV).toAlgHom.toRingHom.toMonoidHom (geomCoboundary C e) := by
      rw [map_pieceEquiv_geomCoboundary C hV e, heβ]
      -- both sides are the image of the descent coboundary under the identification
      have h3 := congrArg (Units.map (Algebra.TensorProduct.pieceDescentEquiv A
        Γ(XA, V) B).toAlgHom.toRingHom.toMonoidHom) hβ
      -- `pieceDescentEquiv ∘ comparisonDescentUnit = id`
      have h4 : ∀ v : (Γ(XA, V) ⊗[A] (B ⊗[A] B))ˣ,
          Units.map (Algebra.TensorProduct.pieceDescentEquiv A
            Γ(XA, V) B).toAlgHom.toRingHom.toMonoidHom
            (Module.comparisonDescentUnit A Γ(XA, V) B v) = v := fun v =>
        Units.ext (Module.pieceDescentEquiv_comparisonDescentUnit_val
          A Γ(XA, V) B v)
      rw [h4] at h3
      rw [h3]
      -- the coboundary seam, transported forward
      have h5 := congrArg (Units.map (Algebra.TensorProduct.pieceDescentEquiv A
        Γ(XA, V) B).toAlgHom.toRingHom.toMonoidHom)
        (Module.comparisonDescentUnit_coboundary A Γ(XA, V) B β)
      rw [h4] at h5
      rw [← h5]
    have h6 := congrArg (Units.map (Over.pieceEquiv (A := A) (B := B ⊗[A] B) C
      hV).symm.toAlgHom.toRingHom.toMonoidHom) h2
    have h7 : ∀ v : Γ(Xq, (cgq) ⁻¹ᵁ V)ˣ,
        Units.map (Over.pieceEquiv (A := A) (B := B ⊗[A] B) C
            hV).symm.toAlgHom.toRingHom.toMonoidHom
          (Units.map (Over.pieceEquiv (A := A) (B := B ⊗[A] B) C
            hV).toAlgHom.toRingHom.toMonoidHom v) = v := fun v =>
      Units.ext ((Over.pieceEquiv (A := A) (B := B ⊗[A] B) C hV).symm_apply_apply v.val)
    rw [pieceComparisonTensorUnit, h7, h7] at h6
    exact h6
  -- twist by `e⁻¹`
  refine ⟨T.twist C e⁻¹, ?_⟩
  rw [pieceComparisonUnit_eq_of_triv_eq C σ W T (T.twist C e⁻¹) e⁻¹ fun b => rfl,
    hvT, geomCoboundary_inv, mul_inv_cancel]

/-! ## Localize and flatten: flat pieces through every point of a trivialized piece -/