# Iter-010 objectives

## Dispatched
- No prover lane (mechanical gate — see plan.md D2).
- Read-only/consult: blueprint-reviewer `iter010`, strategy-critic `iter010`,
  mathlib-analogist `p3-localisation`.
- Write: blueprint-writer `cech-bridge`, blueprint-clean `cech-bridge`.

## Outcome
- Circular `lem:cech_to_cohomology_on_basis` repaired via the minimal torsor-free Čech↔derived
  bridge (`lem:injective_cech_acyclic`, `lem:ses_cech_h1`, 01EO dimension-shift). DAG acyclic
  (`unknown_uses: []`, `conflicts: []`). Blueprint nodes 43→46; `with_sorry` unchanged at 2.
- STRATEGY.md: +P3b phase, corrected acyclicity-bridge subsection, format DRIFT stripped.
- P3 design locked: `affineOpenCoverOfSpanRangeEqTop` + `exact_of_isLocalized_span`
  (`def:standard_affine_cover` `\mathlibok` anchor added).

## Carried to iter-011 (ordered in PROGRESS.md "Next iter plan")
1. blueprint-reviewer re-confirms the repaired chapter (gate).
2. effort-break `lem:injective_cech_acyclic` + the presheaf-Čech δ-functor machinery.
3. file-split scaffold (`CechAcyclic.lean` / bridge file / `HigherDirectImagePresheaf.lean`).
4. parallel prover lanes: P3 (`mathlib-build`), the P3/P3b-independent 01XJ presheaf leaf, bridge pieces.
