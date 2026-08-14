---
author: sync
content_type: theorem
created: '2026-08-14T14:17:15'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.inf_stable
docstring: The intersection of two stable opens is stable.
file: AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.inf_stable
type: lean
updated: '2026-08-14T14:17:15'
---
theorem inf_stable (i j : StableAffineOpen ρ) :
    ρ.IsStableOpen (i.U ⊓ j.U) := by
  intro γ
  rw [Scheme.Hom.preimage_inf, i.stable γ, j.stable γ]