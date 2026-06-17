# Lean audit — iter-161

Read-only audit of the Lean code edited this iteration. Audit the Lean *as Lean* — do not
assume any strategy claim is true.

## Files to read (absolute paths)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`

This is the only `.lean` file that received prover edits this iter. You may also skim its
direct imports if a signature is unclear, but the audit target is this file.

## Focus areas

1. **Soundness of the new top-level helper `eq_comp_of_isAffine_of_properIntegral`** (around
   L153). Is the statement TRUE as written (no dropped/vacuous hypotheses)? Is every hypothesis
   load-bearing? Is the proof honest (no `sorry`, no laundering through an unsatisfiable
   premise)?
2. **The reduced Step-1 lemma `rigidity_eqAt_closedPoint_of_proper_into_affine`** (decl ~L204,
   body `sorry` ~L263). Is the *statement* TRUE-as-stated and faithful (collapse hypothesis,
   saturation `_hUV`, affine-containment `_hfU` all present and load-bearing)? Is the residual
   `sorry` honestly disclosed (no false "clean" claim, no excuse comment papering a false
   statement)? Confirm it is NOT the iter-157-style laundering (a true headline propped on a
   false/unsatisfiable sorry).
3. **The in-body reduction** (the `cancel_epi` + `suffices` block, the `pointOfClosedPoint`
   machinery, `hqsec`): is the reduction sound, i.e. does closing the residual `sorry` actually
   suffice to prove the stated goal?
4. **Docstring / comment hygiene**: the prover refreshed several docstrings (header L21–31 and
   the docstrings of `rigidity_eqOn_dense_open`/`rigidity_core`/`rigidity_lemma`) to say "bridge
   2 decomposed + assembled". Flag any docstring/comment now STALE or OVERSTATING what is
   proven.
5. **Axiom hygiene**: any new `axiom` declaration? (none expected.)

## Output

Per-decl checklist + a flagged-issues block with severity (must-fix / major / minor). Write your
report to `task_results/lean-auditor-iter161.md`.
