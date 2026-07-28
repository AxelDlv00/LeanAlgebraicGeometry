---
author: sync
content_type: theorem
created: '2026-07-28T22:30:24'
decl: AlgebraicGeometry.h1_eq_zero_of_h1_sub_point_eq_zero
docstring: '**`h¹` version of the peel**: `h¹(𝒪(D − x)) = 0` forces `h¹(𝒪(D)) = 0`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/SectionDrop.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.h1_eq_zero_of_h1_sub_point_eq_zero
type: lean
updated: '2026-07-28T22:30:24'
---
theorem h1_eq_zero_of_h1_sub_point_eq_zero {x : X} (hx : x ≠ genericPoint X)
    (D : X.CurveDivisor)
    (h : Sheaf.h1 (X.divisorSheaf K (D - CurveDivisor.single hx 1)) = 0) :
    Sheaf.h1 (X.divisorSheaf K D) = 0 := by
  have hmono := h1_le_h1_sub_point K hx D
  omega

end Peel

/-! ## Upward closure of `H¹` vanishing on the cone above a divisor

The single-step peel iterates.  The induction is `CurveDivisor.induction_devissage` applied
to the *difference* `D - D₀`, whose effectivity is what "above `D₀`" means; the predicate is
"vanishing at `D₀ + E` for the effective part of `E`". -/

section Cone

omit [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)] in