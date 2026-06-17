# lean-auditor directive — iter-237

Audit the Lean code as Lean. No strategy context is provided intentionally.

## Files to read (absolute paths)

- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean (consumer — read to confirm the consumer of the changed whisker lemmas still typechecks idiomatically)

## Focus areas

1. **Vestigial.lean** received 6 new declarations this iter closing a long-open `sorry`
   (`isLocallyInjective_whiskerLeft_of_W`). Three lemmas (`isLocallyInjective_whiskerLeft_of_W`,
   `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`) were **specialized** from a general site `C` to the
   topological site `{X : TopCat} {R : X.Presheaf CommRingCat}` and **relocated** to the end of the file.
   Check: are the new decls genuine non-vacuous constructions (not `trivial`/`True.intro`/vacuous-hypothesis
   shortcuts)? Is the specialization sound, or did it silently narrow a lemma the consumer needs more
   generally? Are there leftover stale comments referencing the old general-site form or the prior `sorry`?
2. **FlatBaseChange.lean** received 3 new axiom-clean decls plus retains 2 documented `sorry`s
   (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`). Confirm the new decls are real;
   confirm the 2 remaining sorries are honestly documented (not silently widened) and flag any dead-end or
   circular helper.
3. Any bad Lean practice: `erw` overuse that is fragile, `set`/`clear_value` hacks left in, unused
   hypotheses (e.g. is the associator consumer now carrying unused `hM/hN/hP`?), or comments that no longer
   match the code.

## Output

Per-file checklist (outdated comments / suspect defs / dead-end proofs / bad practices) plus a flagged-issues
block with severity. Write to your task_results report.
