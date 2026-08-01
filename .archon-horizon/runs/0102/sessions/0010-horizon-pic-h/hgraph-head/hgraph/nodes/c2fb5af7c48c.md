---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: TwoLatticePair.range_diff_eq
docstring: The range of the Čech differential is the image lattice.
file: AlgebraicJacobian/Cohomology/RigidEngineLattice.lean
generated: lean
lean_status: lean_ok
title: TwoLatticePair.range_diff_eq
type: lean
updated: '2026-08-01T09:44:10'
---
theorem range_diff_eq : LinearMap.range P.diff = P.imageLattice := by
  refine le_antisymm ?_ (sup_le ?_ ?_)
  · rintro n ⟨z, rfl⟩
    rw [diff_apply]
    exact Submodule.sub_mem _ (Submodule.mem_sup_left ⟨z.1, rfl⟩)
      (Submodule.mem_sup_right ⟨z.2, rfl⟩)
  · rintro n ⟨x, rfl⟩
    exact ⟨(x, 0), by simp⟩
  · rintro n ⟨y, rfl⟩
    exact ⟨(0, -y), by simp⟩