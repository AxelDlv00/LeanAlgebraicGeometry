# Iter-005 objectives

## Prover lane (1) — P4 horseshoe sub-goals + assembly

**File:** `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
**Mode:** `mathlib-build` (build/scaffold — the 4 sub-goals do not yet exist as Lean decls)
**Blueprint:** `chapters/Cohomology_AcyclicResolution.tex`, §"The horseshoe construction, step by step"
**Gate:** PASSED (whole blueprint-reviewer `iter005`: complete+correct, anchors faithful)

Build bottom-up, axiom-clean, no sorry:
1. `InjectiveResolution.ofShortExact_twist` (`lem:horseshoe_twist`) — recursion kernel (τ + β + cocycle).
2. `InjectiveResolution.ofShortExact_dComp` (`lem:horseshoe_dComp`) — matrix differential squares to 0.
3. `InjectiveResolution.ofShortExact_chainMap` (`lem:horseshoe_chainMap`) — inl/snd are chain maps.
4. `InjectiveResolution.ofShortExact_resolvesMiddle` (`lem:horseshoe_resolvesMiddle`) — I_B resolves B (LES).
5. Assemble `InjectiveResolution.ofShortExact` (`lem:injective_resolution_of_ses`).
6. Finish P4: `rightDerivedShiftIsoOfAcyclic` (`lem:acyclic_dimension_shift`) →
   `rightDerivedIsoOfAcyclicResolution` (`lem:acyclic_resolution_computes_derived`, staircase).

## Subagents dispatched this iter
- progress-critic/p4 → UNCLEAR (proceed; decompose-then-build correct)
- refactor/fence-fix → COMPLETE (DAG poisoning fixed; file compiles)
- effort-breaker/horseshoe → COMPLETE (7-link chain; 4 new sub-goals)
- blueprint-clean/horseshoe → COMPLETE (Lean/process leakage stripped)
- blueprint-reviewer/iter005 → P4 chapter PASSES HARD GATE

## Expected next-iter (iter-006) seeds
- If twist stalls: re-dispatch effort-breaker on `lem:horseshoe_twist` (3-way split).
- P3: refactor to narrow `CechAcyclic.affine` to a standard-cover type (decided, downstream-safe).
- Coverage debt: add `\lean{}` blocks for the 4 iter-004 helper decls.
