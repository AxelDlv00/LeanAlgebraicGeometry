---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: isRegular_cons_of_quotient_ring
docstring: '**Step A1 bridge (iter-203).** Ring-quotient cons rule for regular

  sequences: given `IsSMulRegular A r` and a regular sequence over the ring

  quotient `A ⧸ span{r}` on the images of `rs`, the list `r :: rs` is a regular

  sequence over `A`. This is the ergonomic ring-quotient form of Mathlib''s

  `RingTheory.Sequence.IsRegular.cons''` (whose tail lives over the module quotient

  `QuotSMulTop r A`), transported across `quotSMulTop_quotientRing_linearEquiv` via

  `LinearEquiv.isRegular_congr`. Axiom-clean.'
file: AlgebraicJacobian/Albanese/CodimOneMatsumura.lean
generated: lean
lean_status: lean_ok
title: isRegular_cons_of_quotient_ring
type: lean
updated: '2026-07-17T10:19:49'
---
private theorem isRegular_cons_of_quotient_ring
    {A : Type u} [CommRing A] {r : A} {rs : List A}
    (h1 : IsSMulRegular A r)
    (h2 : RingTheory.Sequence.IsRegular (A ⧸ Ideal.span {r})
            (rs.map (Ideal.Quotient.mk (Ideal.span {r})))) :
    RingTheory.Sequence.IsRegular A (r :: rs) := by
  apply RingTheory.Sequence.IsRegular.cons' h1
  exact ((quotSMulTop_quotientRing_linearEquiv r).symm.isRegular_congr _).mp h2

set_option maxHeartbeats 1600000 in
-- The cotangent-map kernel computation + the hand-rolled `linearIndependent_iff`
-- argument are heartbeat-heavy; the default budget is insufficient.