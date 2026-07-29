---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.FinCoverData.toAffCoverData
docstring: '**The migration map.** An old chart-typed `FinCoverData` gives a widened

  `AffCoverData`: reindex `Fin m₀ ⊕ Fin m₁` through `finSumFinEquiv`, the pieces are
  affine as

  basic opens of the affine pinned charts, and the joint cover follows from the two
  chart-wise

  covers together with `relCover_sup`.


  The point of this lemma is that widening costs nothing landed: every existing construction
  of

  cover data still produces a legal widened datum.  The converse fails, and that is
  exactly the

  content of R2.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.toAffCoverData
type: lean
updated: '2026-07-29T15:31:43'
---
noncomputable def toAffCoverData : AffCoverData C R where
  m := D.m₀ + D.m₁
  pieces := fun j => D.pieces (finSumFinEquiv.symm j)
  isAffineOpen := fun j => by
    rcases finSumFinEquiv.symm j with i | i
    · rw [FinCoverData.pieces_inl]
      exact (relCover_isAffineOpen₀ C R (fiberTwoCover π)).basicOpen _
    · rw [FinCoverData.pieces_inr]
      exact (relCover_isAffineOpen₁ C R (fiberTwoCover π)).basicOpen _
  cover := by
    refine top_le_iff.mp fun z _ => ?_
    -- every point is in a pinned chart, and each chart is covered by its own pieces
    have hz : z ∈ (relCover C R (fiberTwoCover π)).V₀
        ⊔ (relCover C R (fiberTwoCover π)).V₁ := by
      rw [relCover_sup]; trivial
    have key : ∃ i : D.index, z ∈ D.pieces i := by
      rcases Opens.mem_sup.mp hz with h | h
      · obtain ⟨i, hi⟩ := Opens.mem_iSup.mp (D.cover₀ h)
        exact ⟨Sum.inl i, hi⟩
      · obtain ⟨i, hi⟩ := Opens.mem_iSup.mp (D.cover₁ h)
        exact ⟨Sum.inr i, hi⟩
    obtain ⟨i, hi⟩ := key
    exact Opens.mem_iSup.mpr ⟨finSumFinEquiv i, by
      simpa only [Equiv.symm_apply_apply] using hi⟩

@[simp]