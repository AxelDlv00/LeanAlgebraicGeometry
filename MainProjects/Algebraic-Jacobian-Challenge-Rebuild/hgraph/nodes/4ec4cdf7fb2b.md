---
author: sync
content_type: lemma
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.span_twistGermSet_le_stalkIdeal
docstring: '**The easy inclusion**: germs of vanishing sections lie in the stalk ideal
  — the

  membership clauses of `vanishingSubmodule` verbatim.'
file: AlgebraicJacobian/Picard/DivSchemeMonoBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.span_twistGermSet_le_stalkIdeal
type: lean
updated: '2026-07-29T15:31:41'
---
lemma span_twistGermSet_le_stalkIdeal (d : X.LocalEquations)
    {T : Set ↥(twistSubmodule A V₀ V₁ gc ⊤)}
    (hT : T ⊆ ↑(d.vanishingSubmodule A V₀ V₁ gc)) (z : X) :
    Ideal.span (Scheme.twistGermSet T z) ≤ d.stalkIdeal z := by
  rw [Ideal.span_le]
  rintro a (⟨x, hx, hz₀, rfl⟩ | ⟨x, hx, hz₁, rfl⟩)
  · exact ((Scheme.LocalEquations.mem_vanishingSubmodule_iff A).mp (hT hx)).1 z hz₀
  · exact ((Scheme.LocalEquations.mem_vanishingSubmodule_iff A).mp (hT hx)).2 z hz₁

end GermSet

/-! ## §2 The local upgrade: cancelling a flat-colength regular element -/

section LocalBridge

variable {R B : Type u} [CommRing R] [CommRing B] [Algebra R B]