# Lean ↔ Blueprint Checker Directive

## Slug
jacobian-review129

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex

## Known issues

- This iter (iter-129) the file's top-level header block was rewritten by the refactor lane to enumerate the two `sorry`-bodied declarations (`genusZeroWitness` at L188 and `nonempty_jacobianWitness` at L208). Body and signatures of all declarations are unchanged from iter-127.
- The blueprint chapter was NOT edited this iter — the last substantive edit was iter-127's blueprint-writer-jacobian-iter127 dispatch which added `def:genusZeroWitness` block + § C.2 over-k commitment update.
- An iter-128 known soon-item: `Jacobian.tex` § C.2.a and § C.2 prologue retain over-`k̄` framing that drifts from the iter-127 over-k commitment. This is acknowledged as soon-not-must-fix (the relevant declaration `rigidity_over_kbar` is already k-agnostic). Re-flag only if your read of the chapter detects a *worse* drift than this acknowledged one.
- Protected declarations in this file are listed in `archon-protected.yaml` (`AlgebraicGeometry.Jacobian` + 4 instances). Do not flag those signatures.
- The three `sorry`-bodied declarations are intentional and tracked (see iter sidecar). Do not flag their existence — only flag stale prose / docstring mismatch / signature drift.

## Output

Report bidirectionally: Lean → blueprint AND blueprint → Lean. Sections per severity (must-fix-this-iter / major / minor / informational). Write to `task_results/lean-vs-blueprint-checker-jacobian-review129.md`.
