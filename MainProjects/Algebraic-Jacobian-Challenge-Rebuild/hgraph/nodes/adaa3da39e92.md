---
author: sync
content_type: theorem
created: '2026-07-25T22:22:04'
decl: Module.Flat.quotient_span_singleton_one_sub_of_isIdempotentElem
docstring: '**The flat companion.** A retract of a flat module is flat, so an idempotent
  cut also

  inherits flatness.  This is the form that applies to the DD-R pieces: the piece
  section

  rings `Γ(relCurve C R, pieces j)` are known **flat** over `R` (localizations of
  the free

  pinned-chart rings, `FinCoverData.flat_sections_pieces`) rather than projective,
  so it is

  this version that discharges the (c1) input from a packet idempotent.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarLeak.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.Flat.quotient_span_singleton_one_sub_of_isIdempotentElem
type: lean
updated: '2026-07-30T15:28:02'
---
theorem Module.Flat.quotient_span_singleton_one_sub_of_isIdempotentElem
    [Module.Flat R B] (e : B) (he : IsIdempotentElem e) :
    Module.Flat R (B ⧸ (Ideal.span {1 - e}).restrictScalars R) := by
  set P := (Ideal.span {1 - e}).restrictScalars R with hP
  set s : (B ⧸ P) →ₗ[R] B :=
    P.liftQ (LinearMap.mulLeft R e) (by
      intro x hx
      have hx' : x ∈ Ideal.span {1 - e} := hx
      rw [Ideal.mem_span_singleton] at hx'
      obtain ⟨c, rfl⟩ := hx'
      change e * ((1 - e) * c) = 0
      rw [← mul_assoc, mul_sub, mul_one, he.eq, sub_self, zero_mul]) with hs
  exact Module.Flat.of_retract s P.mkQ (LinearMap.ext fun y => by
    obtain ⟨b, rfl⟩ := P.mkQ_surjective y
    change P.mkQ (e * b) = P.mkQ b
    rw [← sub_eq_zero, ← map_sub, Submodule.mkQ_apply, Submodule.Quotient.mk_eq_zero]
    change e * b - b ∈ Ideal.span {1 - e}
    rw [Ideal.mem_span_singleton]
    exact ⟨-b, by ring⟩)

end Idempotent

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

namespace Scheme.LocalEquations

variable {X : Scheme.{u}} {R : Type u} [CommRing R] (d : X.LocalEquations)