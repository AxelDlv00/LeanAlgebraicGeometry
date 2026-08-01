---
author: sync
content_type: theorem
created: '2026-07-20T02:01:14'
decl: AlgebraicGeometry.ThetaGeneratorSeed.res_eqn_mem_nonZeroDivisors_of_fibre_regular
docstring: '**Section-level regularity from the fibre-regularity predicate**: the
  restriction of

  `eqn z` to any basic sub-open `D(f) ⊆ D(h z)` is a nonzerodivisor — the slicing
  criterion

  over the Noetherian test ring, fed by the seed''s `fibre_regular` predicate (supplied

  externally, breaking the `IsGenerator` circularity).'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivFacts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.res_eqn_mem_nonZeroDivisors_of_fibre_regular
type: lean
updated: '2026-08-01T09:44:12'
---
theorem res_eqn_mem_nonZeroDivisors_of_fibre_regular [IsNoetherianRing R]
    (hfr : ∀ (z : relCurve C R) (p : PrimeSpectrum R) (f : Γ(relCurve C R, D.piece z)),
      ((relCurve C R).resHom ((relCurve C R).basicOpen_le f) (D.eqn z) ⊗ₜ[R]
          (1 : p.asIdeal.ResidueField)) ∈
        nonZeroDivisors (Γ(relCurve C R, (relCurve C R).basicOpen f) ⊗[R]
          p.asIdeal.ResidueField))
    (z : relCurve C R) (f : Γ(relCurve C R, D.piece z)) :
    (relCurve C R).resHom ((relCurve C R).basicOpen_le f) (D.eqn z)
      ∈ nonZeroDivisors Γ(relCurve C R, (relCurve C R).basicOpen f) := by
  haveI : Module.Flat R Γ(relCurve C R, (relCurve C R).basicOpen f) :=
    flat_sections_basicOpen R (D.isAffineOpen_piece z) (D.flat_sections_piece z) f
  exact Module.Flat.mem_nonZeroDivisors_of_forall_tmul_residueField (fun p => hfr z p f)