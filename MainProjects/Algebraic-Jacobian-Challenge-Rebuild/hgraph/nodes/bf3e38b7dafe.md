---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.primeIdealOf_ne_bot
docstring: 'A nonzero-prime witness at a closed point of an affine Dedekind chart:
  on an integral scheme

  with a domain section ring, the prime of `Γ(X, V)` cut out by a non-generic point
  of an affine open

  is not `⊥`. (Re-derivation of the ne-bot fact used in `IsAffineOpen.isDiscreteValuationRing_stalk`.)'
file: AlgebraicJacobian/RiemannRoch/ResidueDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.primeIdealOf_ne_bot
type: lean
updated: '2026-07-16T21:33:29'
---
private theorem primeIdealOf_ne_bot {X : Scheme.{u}} [IsIntegral X] {V : X.Opens}
    (hV : IsAffineOpen V) [IsDomain Γ(X, V)] {x : X} (hx : x ∈ V) (hxg : x ≠ genericPoint X) :
    (hV.primeIdealOf ⟨x, hx⟩).asIdeal ≠ ⊥ := by
  intro h
  apply hxg
  have h1 : hV.fromSpec.base (hV.primeIdealOf ⟨x, hx⟩) = x := hV.fromSpec_primeIdealOf ⟨x, hx⟩
  have hgen : (genericPoint (Spec Γ(X, V)) : Spec Γ(X, V)) = hV.primeIdealOf ⟨x, hx⟩ := by
    rw [genericPoint_eq_bot_of_affine]
    exact (PrimeSpectrum.ext h).symm
  rw [← h1, ← hgen, genericPoint_eq_of_isOpenImmersion hV.fromSpec]

variable {K : Type u} [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]