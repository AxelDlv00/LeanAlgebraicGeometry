---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.range_moduleDiff_le_ker_moduleDelta
docstring: "If the degree-one cohomology of both pieces vanishes, the connecting map\
  \ is\nsurjective. -/\ntheorem moduleDelta_surjective [Subsingleton (Sheaf.HModule'\
  \ F S.X₂ 1)]\n    [Subsingleton (Sheaf.HModule' F S.X₃ 1)] :\n    Function.Surjective\
  \ (S.moduleDelta F) := fun y ↦\n  S.exists_moduleDelta_eq F y (Subsingleton.elim\
  \ _ _) (Subsingleton.elim _ _)\n\nend Connecting\n\nsection Cokernel\n\n/-! ###\
  \ The two-cover cokernel computation"
file: AlgebraicJacobian/RiemannRoch/Ledger/MayerVietoris.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.range_moduleDiff_le_ker_moduleDelta
type: lean
updated: '2026-07-28T18:12:20'
---
theorem range_moduleDiff_le_ker_moduleDelta :
    LinearMap.range (S.moduleDiff F) ≤ LinearMap.ker (S.moduleDelta F) := by
  rintro - ⟨t, rfl⟩
  exact S.moduleDelta_moduleDiff F t

variable (S) in