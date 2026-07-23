---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.exists_pointRank_le
docstring: '**The point rank is bounded on a noetherian scheme**: finitely many

  presentation charts cover `S` by quasi-compactness, and each caps the rank

  by its generator count.'
file: AlgebraicJacobian/Picard/FlatteningStratificationUniversal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.exists_pointRank_le
type: lean
updated: '2026-07-16T21:14:26'
---
theorem exists_pointRank_le [IsNoetherian S] (F : S.Modules)
    [F.IsFinitePresentation] : ∃ N : ℕ, ∀ s : S, pointRank S F s ≤ N := by
  classical
  choose Vc hVc hchart using exists_presentationChart_mem (S := S) F
  have hcov : (Set.univ : Set S) ⊆ ⋃ s : S, ((Vc s).1 : Set S) := fun x _ =>
    Set.mem_iUnion.mpr ⟨x, hVc x⟩
  obtain ⟨t, ht⟩ := isCompact_univ.elim_finite_subcover
    (fun s : S => ((Vc s).1 : Set S)) (fun s => (Vc s).1.isOpen) hcov
  refine ⟨t.sup fun s => pointRank S F s, fun x => ?_⟩
  obtain ⟨s, hst, hxs⟩ := Set.mem_iUnion₂.mp (ht (Set.mem_univ x))
  calc pointRank S F x ≤ pointRank S F s := by
        obtain ⟨mm, ⟨P⟩⟩ := hchart s
        rw [pointRank_eq_chartFiberRank F (V := Vc s) x hxs]
        exact P.fiberRank_le _
    _ ≤ t.sup (fun s => pointRank S F s) := Finset.le_sup hst

set_option maxHeartbeats 800000 in