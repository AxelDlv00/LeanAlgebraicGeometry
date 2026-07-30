---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.IsAffineOpen.primeIdealOf_ne_bot
docstring: '**Nonzero prime at a closed point.** On an integral scheme, the prime
  of `Γ(X, V)` cut

  out by a non-generic point of the affine open `V` is not `⊥`.  (Public form of the

  re-derivations in `StalksDVR`/`ResidueDegree`.)'
file: AlgebraicJacobian/RiemannRoch/ChartPoints.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsAffineOpen.primeIdealOf_ne_bot
type: lean
updated: '2026-07-30T15:46:07'
---
theorem IsAffineOpen.primeIdealOf_ne_bot {x : X} (hx : x ∈ V) (hxg : x ≠ genericPoint X) :
    (hV.primeIdealOf ⟨x, hx⟩).asIdeal ≠ ⊥ := by
  haveI : Nonempty V := ⟨⟨x, hx⟩⟩
  intro h
  apply hxg
  have h1 : hV.fromSpec.base (hV.primeIdealOf ⟨x, hx⟩) = x := hV.fromSpec_primeIdealOf ⟨x, hx⟩
  have hgen : (genericPoint (Spec Γ(X, V)) : Spec Γ(X, V)) = hV.primeIdealOf ⟨x, hx⟩ := by
    rw [genericPoint_eq_bot_of_affine]
    exact (PrimeSpectrum.ext h).symm
  rw [← h1, ← hgen, genericPoint_eq_of_isOpenImmersion hV.fromSpec]

omit [IsIntegral X] in