# lean-vs-blueprint-checker — Jacobian (iter-156)

## Scope (exactly one file + its chapter)

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex`

## Context for this dispatch

This iter the blueprint chapter `Jacobian.tex` was rewritten (genus-0 reframe:
route (c) = Milne theorem-of-the-cube → rigidity lemma, decoupled from the
Picard/FGA engine). On the Lean side the only change was a comment expansion at
the `genusZeroWitness` keystone `key : f = toUnit C ≫ η[A]` (around lines
234–263) documenting three verified blockers. No proof landed; the `key` sorry
remains.

## What to check (bidirectional)

1. **Lean → blueprint.** Do `genusZeroWitness` (`AlgebraicGeometry.genusZeroWitness`)
   and `positiveGenusWitness` faithfully realize their blueprint blocks
   (`def:genusZeroWitness`, `def:positiveGenusWitness`)? Is the residual `key`
   sorry exactly the `thm:rigidity_over_kbar` / C.2 gap (not laundered or
   broadened)? Are the closed parts (6/7 structural fields + pointed condition +
   uniqueness via epi-cancellation of `toUnit C`) correctly mirrored by the
   chapter's prose?

2. **Blueprint → Lean — pay special attention to these two possible
   divergences the reviewer should adjudicate:**
   - **Import topology.** The Lean comment records (and this review independently
     verified) that `rigidity_over_kbar` lives in `RigidityKbar.lean`, whose
     import chain is `RigidityKbar → Rigidity → Jacobian`. Therefore
     `Jacobian.lean` CANNOT import `rigidity_over_kbar` to wire `key`. Does the
     blueprint's C.2.f / genusZeroWitness prose acknowledge this, or does it
     silently assume `genusZeroWitness` can consume `rigidity_over_kbar`? If the
     latter, flag the chapter as understating a real structural obstruction.
   - **Cost of the descent step.** The blueprint (C.2.f, C.2.g, the
     `def:genusZeroWitness` block) describes the k̄→k descent as a "short ~2-line
     consequence of `Flat.epi_of_flat_of_surjective` + base-change-square
     commutativity." The prover's task result claims that constructing the
     base-change functor `Over (Spec k) → Over (Spec k̄)` + transferring all 7
     instances (`SmoothOfRelativeDimension 1`, `IsProper`,
     `GeometricallyIrreducible`, `GrpObj`, …) + genus stability is a multi-iter
     sub-build, NOT 2 lines. Adjudicate: does the blueprint understate the
     descent's true Lean cost?

3. **Char-`p` hypothesis honesty.** `rigidity_over_kbar` carries
   `[IsAlgClosed kbar] [CharZero kbar]`; `genusZeroWitness` is over an arbitrary
   `[Field k]`. Does the chapter correctly disclose that the char-`p` arm stays
   unbacked until route (c) drops `[CharZero]`?

## Out of scope

Other chapters; the `RigidityKbar.tex` chapter body (only insofar as the
import/hypothesis facts about `rigidity_over_kbar` matter to Jacobian.tex).

## Output

Per-file bidirectional report with severity-tagged findings (must-fix / major /
minor). Write to your `task_results/` report file.
