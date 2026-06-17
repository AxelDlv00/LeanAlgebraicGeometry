# Lean audit — iter-030 prover-touched files

Audit the following two Lean files as Lean (no strategy bias). Read them in full.

## Files
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

## Focus areas
1. **FreePresheafComplex.lean** gained ~50 new `…Fam` declarations this iter inside a
   `section FamilyParameterized` block (re-parameterizing an existing `X.OpenCover`-indexed
   chain to a raw finite family `{ι : Type u} [Finite ι] (U : ι → Opens ↥X)`). Check:
   - Are the new `…Fam` statements genuine and non-vacuous — in particular is the headline
     `cechFreeComplex_quasiIsoFam` a real `QuasiIso` claim over an arbitrary finite family with
     **no covering hypothesis** smuggled in (no `⊤`/`iSup`/covering side-condition)?
   - Any `set_option linter.unusedSectionVars false` or `omit` usage that hides a real problem
     (e.g. a `[Finite ι]` that is silently unused where it should be load-bearing)?
   - Any decl that is a trivial restatement / definitionally-`True` / proof that discharges by
     an over-broad `simp`/`sorry`-adjacent escape.
2. **QcohTildeSections.lean** gained 3 decls (`free_isQuasicoherent`,
   `isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`). Check they are
   genuine (real content, not vacuous repackaging that hides an unproven hypothesis), and that the
   docstrings' "single remaining blocker = 01I8 step 1 affine global generation" claim is honest
   (the file does not silently assume the blocked fact anywhere).

Report the usual per-file checklist (outdated comments, suspect defs, dead-end proofs, bad
practices) plus a flagged-issues block with severities. Verify axiom-cleanliness where doubtful.
