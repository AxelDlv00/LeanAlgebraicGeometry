# lean-vs-blueprint-checker — AbelianVarietyRigidity.lean ↔ AbelianVarietyRigidity.tex

## Scope

Compare exactly one `.lean` file with its blueprint chapter,
bidirectionally.

- **Lean file**:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`
- **Blueprint chapter**:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Why this file in particular

Lane E `iotaGm_chart1_appIso_eval` was STUCK for 4 consecutive iters
(iter-188/189/190/191) on `Proj.appIso` evaluation simp loops. iter-193
prover landed a new `IsOpenImmersion.lift_uniq` route refactor:

- `kbarChart1Ring` (line ~198): axiom-clean def — chart-1 evaluation
  ring map `Away 𝒜 X_1 →+* k̄` at the `k̄`-point `[1:1] ∈ D₊(X_1)`.
- `iotaGm_r_1_eq_specMap` (line ~244): axiom-clean conditional on
  `kbarChart1Ring_specMap_fac`.
- `kbarChart1Ring_specMap_fac` (line ~222): NEW substantive typed
  sorry — the Spec-map factorisation claim.
- `iotaGm_chart1_appIso_eval` (line ~345): residual displaced from
  Proj.appIso (4-iter STUCK ELIMINATED) to a tensor-product collapse
  via `pullbackSpecIso`. Still typed sorry.

## What to check (bidirectional)

1. **Lean → blueprint**: are the new private helpers (`kbarChart1Ring`,
   `iotaGm_r_1_eq_specMap`, `kbarChart1Ring_specMap_fac`) — none of
   them blueprint-pinned — appropriate as private internal substrate,
   or should the chapter document them?
2. **Lean → blueprint**: does the chapter's recipe for
   `iotaGm_chart1_appIso_eval` accurately describe the
   `IsOpenImmersion.lift_uniq` strategy now in use? Or does it still
   describe the now-abandoned `Proj.appIso` approach?
3. **Blueprint → Lean**: chapter section on `iotaGm_chart1_composition`
   was iter-192-rewritten to mention the new blueprint-pinned hook
   `iotaGm_chart1_appIso_eval`. Verify this content is still
   accurate after the iter-193 refactor.
4. **Lean → blueprint**: the `genusZero_curve_iso_P1` sorry at
   ~line 795 (Riemann–Roch bridge) — is it blueprint-pinned with a
   `\lean{...}`? If yes, is the pin still correct?
5. **Blueprint → Lean**: any `\lean{...}` pins in the chapter that
   refer to symbols that don't exist in the current Lean source
   (rename / deletion)?

## Output

Write your report to
`.archon/task_results/lean-vs-blueprint-checker-avr-iter193.md`
per the wrapper's standard path.

## Strict context discipline

Read ONLY the two files named above + Mathlib references on demand.
Do NOT read `STRATEGY.md`, `PROGRESS.md`, other chapters, or session
journals.
