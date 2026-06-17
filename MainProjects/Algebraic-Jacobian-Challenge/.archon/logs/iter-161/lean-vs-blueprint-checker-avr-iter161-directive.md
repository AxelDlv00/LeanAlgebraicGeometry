# Lean ↔ blueprint check — AbelianVarietyRigidity, iter-161

Bidirectional per-file verification of exactly one Lean file against its blueprint chapter.

## The pair

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

## What changed this iter (prover)

- New proven top-level helper `eq_comp_of_isAffine_of_properIntegral` (the deep algebraic heart of
  Step 1 — "proper integral k̄-scheme into affine is constant on k̄-points"). Axiom-clean.
- `rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1) reduced from a monolithic body to a
  clean k̄-point statement with one residual geometric `sorry`.
- The in-body `JacobsonSpace U` sorry in `rigidity_eqOn_saturated_open_to_affine` was closed
  (lane a), so that lemma is now sorry-free in its own body (delegates only to Step 1).

## Checks (report bidirectionally)

1. **Lean → blueprint**: Does the chapter cover the new helper `eq_comp_of_isAffine_of_properIntegral`?
   It is a newly-proven reusable declaration with no obvious `\lean{}` block / `\uses` edge yet —
   flag if missing (marker-graph laundering vector: if the chain's `\leanok`-tagged proofs render
   proven while this newly-introduced step has no node).
2. **Signature faithfulness**: For every chapter `\lean{...}`-tagged declaration that exists in the
   Lean file, confirm the Lean signature matches the blueprint statement (hypotheses, conclusion).
   Pay attention to `rigidity_eqAt_closedPoint_of_proper_into_affine` and
   `rigidity_eqOn_saturated_open_to_affine`.
3. **`\uses` graph honesty**: After this iter, the chain's lone residual `sorry` is Step 1's
   geometric assembly. Does the blueprint dependency graph correctly route the not-proven status
   up (no backward cycle, headline not laundered)? Note iter-160 fixed forward-acyclic edges; check
   they still hold and that any new node (the helper, Step 1, Step 2) is wired forward.
4. **Blueprint → Lean**: Is the chapter detailed enough to have guided this formalization, or did
   the Lean clearly need detail the chapter lacks? Flag thin spots.
5. **Stale prose**: the iter-160 `% NOTE` recorded a signature gap (`[LocallyOfFiniteType]`) that
   iter-161 closed by threading the instance. Is any prose/NOTE now stale?

## Output

Bidirectional findings with severity (must-fix / major / minor). Write your report to
`task_results/lean-vs-blueprint-checker-avr-iter161.md`.
