---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.ThetaGeneratorSeed.res_eqn_mem_nonZeroDivisors
docstring: '**Section-level regularity on basic sub-opens of the piece**: the restriction
  of the

  equation to any basic open `D(f) ⊆ D(h z)` is a nonzerodivisor — the slicing criterion

  `Module.Flat.mem_nonZeroDivisors_of_forall_tmul_residueField` over the Noetherian
  test

  ring, fed by the seed''s fibrewise regularity.'
file: AlgebraicJacobian/Picard/DivSchemeFamily.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.res_eqn_mem_nonZeroDivisors
type: lean
updated: '2026-08-01T09:44:11'
---
theorem res_eqn_mem_nonZeroDivisors [IsNoetherianRing R] (hD : D.IsGenerator)
    (z : relCurve C R) (f : Γ(relCurve C R, D.piece z)) :
    (relCurve C R).resHom ((relCurve C R).basicOpen_le f) (D.eqn z)
      ∈ nonZeroDivisors Γ(relCurve C R, (relCurve C R).basicOpen f) := by
  haveI : Module.Flat R Γ(relCurve C R, (relCurve C R).basicOpen f) :=
    flat_sections_basicOpen R (D.isAffineOpen_piece z) (D.flat_sections_piece z) f
  exact Module.Flat.mem_nonZeroDivisors_of_forall_tmul_residueField
    (fun p => hD.fibre_regular z p f)