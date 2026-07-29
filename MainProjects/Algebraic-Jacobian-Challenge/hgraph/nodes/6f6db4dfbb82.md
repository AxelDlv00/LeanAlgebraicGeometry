---
author: sync
content_type: theorem
created: '2026-07-29T20:27:13'
decl: AlgebraicGeometry.finrank_stabilisationAmbient_eq_h1
docstring: '**The stabilisation happens in a space of dimension `h¹`** — the measurement
  that says where

  the degree clause should be attacked.


  `n₀` is produced by `Submodule.eventually_eq_top_of_monotone_of_iSup_eq_top` applied
  to the

  fibre-lattice chain `Aₙ` inside the fixed ambient `N = 𝒪(D)(V₀ ⊓ V₁)`.  This records
  that the

  quotient it stabilises in is *exactly* the twisted `H¹`, so its dimension is `h¹(𝒪(D
  + n·F))` —

  and at `D = 0` that is `h¹(𝒪) = genus`, **the same number over every base field**

  (`Ledger/GenusFieldInvariance.genus_baseChangeField_curve`).


  So a bound `n₀ ≤ genus C` would close the degree clause of `UniformBaseDivisor`
  with

  `d := genus C · deg_κ F_κ`, uniformly in `κ`.


  **It does not follow from this, and the gap is precisely strictness.**  A monotone
  chain in a

  `g`-dimensional space can repeat a term without having reached `⊤`, so bounded dimension
  alone

  bounds nothing; one needs `Aₙ ⊊ Aₙ₊₁` while `Aₙ ≠ ⊤`.  Nothing in the tree proves
  that for the

  fibre lattice.  Stated as a `finrank` identity and nothing more, so that the reduction
  is visible

  without any part of it being asserted.'
file: AlgebraicJacobian/RiemannRoch/Ledger/BaseDivisorEveryField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finrank_stabilisationAmbient_eq_h1
type: lean
updated: '2026-07-29T20:27:13'
---
theorem finrank_stabilisationAmbient_eq_h1 (D : Y.CurveDivisor) (n : ℕ) :
    Module.finrank K
        (divisorSections K D (fiberChart₀ π ⊓ fiberChart₁ π) ⧸ fiberLatticeOverlap π D n)
      = Sheaf.h1 (Y.divisorSheaf K (D + n • fiberWeilDivisor π)) :=
  (LinearEquiv.finrank_eq (fiberLatticeH1Equiv π D n)).symm