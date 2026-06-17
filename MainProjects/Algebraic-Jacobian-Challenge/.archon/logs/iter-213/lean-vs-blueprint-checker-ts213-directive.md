# lean-vs-blueprint-checker directive — iter-213

## The one file and its blueprint chapter

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Report bidirectionally (Lean → blueprint AND blueprint → Lean).

## Context for what changed this iter

The prover rewrote `tensorObj_assoc_iso` (the associator) from a scaffolded typed `sorry`
into a complete 3-step composite, and introduced three new lemmas in a `WhiskerOfW`
section: `isLocallyInjective_whiskerLeft_of_W` (the single remaining `sorry`),
`W_whiskerLeft_of_W`, `W_whiskerRight_of_W` (both closed).

Two specific things to check carefully:

1. **Route mismatch.** The blueprint chapter's prose for `lem:tensorobj_assoc_iso` is
   believed to describe a *flatness* / *local-triviality* route (ROUTE c), whereas the Lean
   body now uses a flatness-free **stalkwise** route (ROUTE d) in which the
   `IsLocallyTrivial` hypotheses are NOT consumed. Confirm whether the chapter prose and the
   Lean implementation now describe the same mathematics. If they diverge, say which side is
   the source of truth and what a blueprint-writer should change.

2. **Unpinned new lemmas.** The three new `WhiskerOfW` lemmas may not yet have `\lean{...}`
   pins in the chapter. Report whether the chapter declares them and whether their informal
   statements (if present) match the Lean signatures. The single residual
   `isLocallyInjective_whiskerLeft_of_W` in particular should be visible in the blueprint as
   the load-bearing open obligation, not hidden.

3. Standard checks: signature mismatches, fake/placeholder statements, blueprint sections too
   thin to have guided the Lean that was actually written.

## Output

The standard per-file bidirectional report, with any must-fix-this-iter findings called out.
