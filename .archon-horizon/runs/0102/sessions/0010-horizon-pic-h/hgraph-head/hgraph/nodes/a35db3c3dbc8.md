---
author: sync
content_type: theorem
created: '2026-07-29T06:04:35'
decl: TruncExpCech.ker_fstRingHom_le_nilradical
docstring: '**The kernel of `ε ↦ 0` consists of nilpotents.** `ker fstRingHom = (ε)`
  (`ker_fstRingHom`) and

  `ε² = 0`, so the generator is nilpotent of order 2 and `Ideal.span_le` finishes.'
file: AlgebraicJacobian/Tangent/EpsZeroSurjective.lean
generated: lean
lean_status: lean_ok
title: TruncExpCech.ker_fstRingHom_le_nilradical
type: lean
updated: '2026-08-01T09:44:18'
---
theorem ker_fstRingHom_le_nilradical :
    RingHom.ker (fstRingHom (R := A)) ≤ nilradical (DualNumber A) := by
  rw [ker_fstRingHom, Ideal.span_le, Set.singleton_subset_iff]
  exact ⟨2, by simp⟩