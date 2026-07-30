---
author: sync
content_type: theorem
created: '2026-07-29T20:27:13'
decl: AlgebraicGeometry.finrank_stabilisationAmbient_eq_h1
docstring: '**The stabilization quotient is exactly twisted `H¹`.** The former open
  strictness step is

  now closed by `fiberLattice_stable` and

  `Submodule.eq_top_at_finrank_quotient_of_monotone_of_iSup_eq_top_of_stable`, yielding
  the theorem

  `subsingleton_hModule_divisorSheaf_one_at_h1_of_isDominant_toP1`. This identity
  remains useful for

  reading every quotient dimension as the corresponding `h¹`.


  At `D = 0`, the explicit index is `h¹(𝒪) = genus`, uniformly over field extensions.
  The remaining

  uniform-degree issue is therefore not stabilization: it is controlling `deg F_π`
  while choosing

  the maps `π` compatibly across extensions.'
file: AlgebraicJacobian/RiemannRoch/Ledger/BaseDivisorEveryField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finrank_stabilisationAmbient_eq_h1
type: lean
updated: '2026-07-31T06:25:53'
---
theorem finrank_stabilisationAmbient_eq_h1 (D : Y.CurveDivisor) (n : ℕ) :
    Module.finrank K
        (divisorSections K D (fiberChart₀ π ⊓ fiberChart₁ π) ⧸ fiberLatticeOverlap π D n)
      = Sheaf.h1 (Y.divisorSheaf K (D + n • fiberWeilDivisor π)) :=
  (LinearEquiv.finrank_eq (fiberLatticeH1Equiv π D n)).symm