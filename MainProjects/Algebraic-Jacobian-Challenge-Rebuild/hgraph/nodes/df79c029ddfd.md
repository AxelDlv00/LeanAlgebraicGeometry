---
author: sync
content_type: theorem
created: '2026-07-19T10:31:16'
decl: AlgebraicGeometry.window_embedding_windowA
docstring: '**The `H¹` window at the exponent `a`**: `H¹(𝒪(a·F)) = 0` — `windowBound_spec`
  at

  degree `a·δ ≥ b`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.window_embedding_windowA
type: lean
updated: '2026-07-19T10:31:16'
---
theorem window_embedding_windowA :
    Subsingleton (Sheaf.HModule
      (Y.divisorSheaf K (windowA_choice π hπ • fiberWeilDivisor π)) 1) := by
  refine windowBound_spec π hπ _ ?_
  rw [Scheme.CurveDivisor.deg_nsmul' K, deg_fiberWeilDivisor_windowδ]
  exact windowA_spec π hπ