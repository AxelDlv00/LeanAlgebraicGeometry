---
author: sync
content_type: theorem
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffCoverData.swallowedBy_ofSwallowingPiece
docstring: '**`SwallowedBy` for the explicit straddling cover**, given that the other
  pieces avoid the

  support.  This is bookkeeping over `Fin.snoc`: the last piece is `W`, which contains
  the

  support; every other index is a `castSucc`, whose piece is disjoint from it.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffStraddle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffCoverData.swallowedBy_ofSwallowingPiece
type: lean
updated: '2026-07-31T20:15:24'
---
theorem swallowedBy_ofSwallowingPiece {d : (relCurve C R).LocalEquations}
    {W : (relCurve C R).Opens} (hW : IsAffineOpen W) {m : ℕ}
    {Ws : Fin m → (relCurve C R).Opens} (hWs : ∀ i, IsAffineOpen (Ws i))
    (hcover : W ⊔ (⨆ i, Ws i) = ⊤)
    (hsub : d.supportLocus ⊆ (W : Set (relCurve C R)))
    (hmiss : ∀ i, Disjoint d.supportLocus (Ws i : Set (relCurve C R))) :
    (ofSwallowingPiece W hW Ws hWs hcover).SwallowedBy d := by
  refine ⟨Fin.last m, ?_, ?_⟩
  · change d.supportLocus ⊆ ((Fin.snoc Ws W : Fin (m + 1) → _) (Fin.last m) : Set _)
    rw [Fin.snoc_last]
    exact hsub
  · intro j hj
    obtain ⟨i, rfl⟩ := Fin.exists_castSucc_eq.mpr hj
    change Disjoint d.supportLocus ((Fin.snoc Ws W : Fin (m + 1) → _) i.castSucc : Set _)
    rw [Fin.snoc_castSucc]
    exact hmiss i