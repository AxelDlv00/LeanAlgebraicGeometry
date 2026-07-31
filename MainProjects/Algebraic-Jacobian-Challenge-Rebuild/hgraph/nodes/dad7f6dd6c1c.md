---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.preimage_inf_eq_basicOpen_fiberCoord
docstring: '**The two-cover overlap is the basic open of `t₀`.** Public re-derivation
  of the

  `private` lemma `Cohomology.Finiteness.preimage_inf_eq_basicOpen_left`: the overlap
  of the

  pinned chart preimages equals `Y.basicOpen t₀`, obtained from `Scheme.preimage_basicOpen`

  together with the `ℙ¹`-side identification `P1.basicOpen_awayToSection_chartCoord`.'
file: AlgebraicJacobian/RiemannRoch/FiberTwist.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.preimage_inf_eq_basicOpen_fiberCoord
type: lean
updated: '2026-07-31T20:14:51'
---
theorem preimage_inf_eq_basicOpen_fiberCoord :
    fiberChart₀ π ⊓ fiberChart₁ π = Y.basicOpen (fiberCoord π) := by
  have h : π ⁻¹ᵁ ((P1 K).basicOpen
        ((Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord K 0 1)))
      = Y.basicOpen (fiberCoord π) :=
    Scheme.preimage_basicOpen π _
  rw [P1.basicOpen_awayToSection_chartCoord K 0 1, Scheme.Hom.preimage_inf] at h
  exact h

open Classical in