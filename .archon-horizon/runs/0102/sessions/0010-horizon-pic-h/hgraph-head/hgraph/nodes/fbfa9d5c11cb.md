---
author: sync
content_type: theorem
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.divUniversalHighWindowSuccessorQuotientMap_mk
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitions.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divUniversalHighWindowSuccessorQuotientMap_mk
type: lean
updated: '2026-07-22T02:02:05'
---
theorem divUniversalHighWindowSuccessorQuotientMap_mk
    (K : (q : Nat) → Submodule RZ (G q)) (side : Bool) (n : Nat)
    (hK : Submodule.map
        (divUniversalHighWindowTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j side n)
        (K n) ≤ K (n + 1)) (x : G n) :
    divUniversalHighWindowSuccessorQuotientMap
        (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j K side n hK
      (Submodule.Quotient.mk x) =
      Submodule.Quotient.mk
        (divUniversalHighWindowTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j side n x) := by
  rw [divUniversalHighWindowSuccessorQuotientMap, Submodule.mapQ_apply]

end HighWindowTransition

namespace HighWindowTransitionKit

section IteratedSuccessor

variable {R : Type u} [Semiring R]
variable (G : Nat → Type u) [∀ n, AddCommMonoid (G n)]
  [∀ n, Module R (G n)]
variable (step : ∀ n, G n →ₗ[R] G (n + 1))
variable {B : Type u}