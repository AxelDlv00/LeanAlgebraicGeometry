---
author: sync
content_type: theorem
created: '2026-07-20T18:02:05'
decl: AlgebraicGeometry.test_rank_one_quotient_fibre
file: AlgebraicJacobian/Picard/ScratchRankOne.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.test_rank_one_quotient_fibre
type: lean
updated: '2026-07-20T18:32:00'
---
theorem test_rank_one_quotient_fibre
    {B K M : Type u} [CommRing B] [Field K] [Algebra B K]
    [AddCommGroup M] [Module B M]
    (s : M)
    (hfin : Module.finrank K (K ⊗[B] M) = 1)
    (hs : (1 : K) ⊗ₜ[B] s ≠ 0) :
    Subsingleton ((M ⧸ Submodule.span B ({s} : Set M)) ⊗[B] K) := by
  apply test_rank_one_surjective_fibre
    (Submodule.span B ({s} : Set M)).mkQ
    (Submodule.mkQ_surjective _) s hfin hs
  rw [Submodule.mkQ_apply, Submodule.Quotient.mk_eq_zero]
  exact Submodule.mem_span_singleton_self s