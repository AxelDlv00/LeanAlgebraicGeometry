# lean-vs-blueprint-checker directive — iter-028 — FlatBaseChange

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Context for this check
This iter the prover closed `base_change_mate_inner_value_eq` by `exact
base_change_mate_fstar_reindex ψ φ M` (consolidating a previously-inline reproof). The Seam-2/3
chain is realised THROUGH the leg-parametrised `base_change_mate_fstar_reindex_legs`, whose
step-(iii) eCancel telescoping (blueprint target `lem:base_change_mate_inner_eCancel_assemble`)
is STILL an open `sorry` (≈ line 1445), blocked by an `X.Modules` instance diamond. Docstrings
on several downstream theorems were rewritten to say "sorry-free".

Check:
- Does the Lean proof structure match the chapter's Seam-A routing (which the planner rewrote
  this iter to go THROUGH `_legs`, not inline)? Any signature mismatch with `\lean{...}`?
- Is the chapter honest that `inner_eCancel_assemble`/`_legs` remains open, while the
  downstream theorems' bodies are closed-but-transitively-sorry-backed?
- Is the chapter detailed enough to guide the diamond-robust telescoping that remains, or is it
  too thin (blueprint-as-failure)?

Report Lean→blueprint and blueprint→Lean findings with severity.
