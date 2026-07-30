---
author: sync
content_type: theorem
created: '2026-07-30T23:35:09'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.inf_stable
docstring: The intersection of two stable opens is stable.
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.inf_stable
type: lean
updated: '2026-07-30T23:35:09'
---
theorem inf_stable (i j : StableAffineOpen ρ) :
    ρ.IsStableOpen (i.U ⊓ j.U) := by
  intro γ
  rw [Scheme.Hom.preimage_inf, i.stable γ, j.stable γ]