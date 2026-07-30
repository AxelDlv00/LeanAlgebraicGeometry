---
author: sync
content_type: theorem
created: '2026-07-17T16:57:11'
decl: RingTheory.CohenMacaulay.ringKrullDim_quotient_eq_of_isAssociatedPrime
docstring: '**CM unmixedness, quotient-dimension form**: `dim R/p = dim R` for every

  associated prime `p` of a Cohen–Macaulay local ring.'
file: AlgebraicJacobian/Albanese/Milne33CMEquidim.lean
generated: lean
lean_status: lean_ok
stale: true
title: RingTheory.CohenMacaulay.ringKrullDim_quotient_eq_of_isAssociatedPrime
type: lean
updated: '2026-07-30T15:28:04'
---
theorem ringKrullDim_quotient_eq_of_isAssociatedPrime [CohenMacaulay R]
    {p : Ideal R} (hp : IsAssociatedPrime p R) :
    ringKrullDim (R ⧸ p) = ringKrullDim R := by
  haveI := hp.isPrime
  rw [ringKrullDim_quotient_eq_coheight p]
  exact coheight_eq_ringKrullDim_of_isAssociatedPrime hp