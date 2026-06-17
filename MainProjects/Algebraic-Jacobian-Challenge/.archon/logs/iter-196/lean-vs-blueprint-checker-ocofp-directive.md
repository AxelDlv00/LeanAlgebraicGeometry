# Lean ↔ Blueprint Checker Directive

## Slug
ocofp

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/OCofP.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_OCofP.tex

## Focus areas
- iter-196 added two private helpers:
  - `toFunctionField_injective` (~L1287) — axiom-clean injectivity of the
    section-to-functionField map, decomposed via `homEquiv_unit`.
  - `functionField_const_of_complete_curve_of_orderZero` (~L1390) — typed sorry
    capturing Stacks 02P0 / Hartshorne I.3.4 gap (Γ(C, 𝒪_C) = k̄ on proper
    geom-irred curve over alg-closed k̄).
  Verify the blueprint mentions / motivates these helpers.
- Sub-claims (a)+(b) of `exists_nonconstant_rational_from_dim_eq_two` (~L1441) are
  now RESOLVED (axiom-clean modulo the one named substrate sorry); sub-claim (c)
  is gated on the named substrate helper. Verify blueprint coverage of the
  multi-step contrapositive argument.
- L1147 `h1_vanishing_genusZero` and L1209 `h0_sub_h1_lineBundleAtClosedPoint_eq_two`
  remain off-critical-path sorries (substrate-gated on OcOfD + RRFormula).
- Blueprint doctor flagged a broken `\uses{...def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}` reference in this chapter — verify whether the referenced label exists or needs renaming.

## Out of scope
- OcOfD.lean and RRFormula.lean substrate lanes (independent files).
