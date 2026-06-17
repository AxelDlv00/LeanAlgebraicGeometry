# Audit directive

Audit the Lean code that was added this iteration. Read the file as Lean — judge correctness,
soundness, dead-ends, and bad practice on its own terms. No strategy framing is given on purpose.

## Files to read (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Focus areas
- The three declarations added this iter: `qcoh_section_equalizer` (theorem, ~line 588),
  `isLocalizedModule_powers_restrictScalars_of_algebraMap` (lemma, ~line 666), and the private helper
  `res_trans_apply` (~line 580). Confirm each is a genuine, non-vacuous proof with no spurious-`rfl`,
  no `sorry`/`admit`, and no kernel-soundness trap (e.g. a term the LSP accepts but `lake env lean`
  would reject).
- Pay attention to any use of `.2` / anonymous projections to access a `FullSubcategory.property`
  sheaf condition — confirm it is the real sheaf condition and not an unrelated component.
- Check the new import and any deprecation warnings.

## Output
Per-file checklist (outdated comments, suspect defs, dead-end proofs, bad practice) plus a flagged-issues
block with severity. Write your report to your task_results file.
