# lean-auditor directive (iter-004)

## Files to audit (absolute paths)

- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

## Focus areas

- The file received prover work this iteration in `mathlib-build` mode (new sorry-free
  declarations added to a zero-sorry file). Audit the **5 new declarations** added near
  lines 108–195:
  - `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic`
  - `shortExact_of_degreewise_splitting`
  - `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`
  - `Functor.rightDerivedShiftIsoOfSplitResolutionSES`
  - `mono_biprod_lift_factorThru_of_exact`
- Are any of these mathematically vacuous, trivially-discharged, or stated with hypotheses so
  strong the conclusion is empty? Check `rightDerivedShiftIsoOfSplitResolutionSES` in particular:
  does it actually consume its `[IsRightAcyclic J]` and split hypotheses, or is it provable
  without them?
- Pay attention to the large `/-! ... -/` strategy/status comment block (lines ~197–347). It
  contains a literal `def InjectiveResolution.ofShortExact { ... }` signature inside a code
  fence. Report whether any literal `def`/`lemma`/`theorem` signature appears inside a comment
  in a way that could be mistaken for a real declaration. Are the comments accurate about what
  is and is not actually formalized in this file?
- Outdated comments, dead-end proof fragments, bad Lean practices, suspicious definitions.

## Output

Per-file checklist plus a flagged-issues block with severities. Write your report to your
`task_results` file.
