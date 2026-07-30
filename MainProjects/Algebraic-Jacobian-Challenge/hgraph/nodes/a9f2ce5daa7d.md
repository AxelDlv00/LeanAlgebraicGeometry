---
author: sync
content_type: theorem
created: '2026-07-29T18:18:38'
decl: control_mem_fixedAway_iff
docstring: 'Control: the same statement as `mem_fixedAway_iff_exists_invariant_num`,
  by `sorry`.'
file: scripts/albanese-awayequiv-axioms.lean
generated: lean
lean_status: sorry
stale: true
title: control_mem_fixedAway_iff
type: lean
updated: '2026-07-31T02:29:53'
---
theorem control_mem_fixedAway_iff [Finite G] (b : A) (hb : ∀ g : G, g • b = b)
    (x : Localization.Away b) :
    x ∈ AlgebraicGeometry.fixedAway b hb ↔
      ∃ (a : A) (n : ℕ), (∀ g : G, g • a = a) ∧
        x * algebraMap A (Localization.Away b) (b ^ n)
          = algebraMap A (Localization.Away b) a :=
  sorry

#print axioms control_algebraMap_mem
#print axioms control_mem_fixedAway_iff