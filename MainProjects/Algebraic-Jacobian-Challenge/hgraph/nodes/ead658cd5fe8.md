---
author: sync
content_type: theorem
created: '2026-07-31T02:29:39'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.overlapTransition'_fac
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.overlapTransition'_fac
type: lean
updated: '2026-07-31T02:29:39'
---
theorem overlapTransition'_fac [FiniteDimensional K L] [IsGalois K L]
    (i j k : StableAffineOpen ρ) :
    overlapTransition' ρ i j k ≫
        pullback.snd (quotientOverlapι ρ j k) (quotientOverlapι ρ j i) =
      pullback.fst (quotientOverlapι ρ i j) (quotientOverlapι ρ i k) ≫
        (overlapIso ρ i j).hom := by
  simp only [overlapTransition', Category.assoc]
  rw [pullbackOverlapIsoTriple_inv_snd]
  rw [← tripleToOverlapLeft_overlapIso]
  rw [← Category.assoc, pullbackOverlapIsoTriple_hom_fst]