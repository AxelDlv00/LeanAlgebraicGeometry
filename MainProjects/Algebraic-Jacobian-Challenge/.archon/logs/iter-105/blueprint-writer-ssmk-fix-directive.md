# Blueprint Writer Directive

## Slug
ssmk-fix

## Target chapter
blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex

## Strategy context

Phase A active target is `cechCofaceMap_pi_smul` closure in `BasicOpenCech.lean`. The StructureSheafModuleK chapter is the blueprint for `Scheme.HModule`, `HModule'`, and the comparison-isomorphism API that the Čech-acyclicity arc consumes. The chapter is `correct: partial` per blueprint-reviewer-iter105 due to ONE broken `\uses{}` cross-reference at L629 — a dependency-graph corruption that must be fixed.

## Required content

### Change 1 — Fix broken cross-reference at L629

The theorem at L625–L637, `\thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover`, has a `\uses{}` block that includes the label `def:Scheme_HModule'`. This label does NOT exist anywhere in the blueprint (verified by Grep across `blueprint/src/chapters/*.tex`).

The intended target is `def:Scheme_HModule_prime`, defined at L259 of this same chapter (`Cohomology_StructureSheafModuleK.tex`). This is a pure typo: the LaTeX label-style is `def:Scheme_HModule_prime`, NOT `def:Scheme_HModule'`.

**Fix**: replace `def:Scheme_HModule'` in the `\uses{}` block at L629 with `def:Scheme_HModule_prime`.

Iter-104 blueprint-reviewer already flagged this; iter-105 reviewer re-confirmed. This is a mechanical typo fix.

### Out of scope this round

- **Do NOT** rewrite the one-line proof sketch of `\thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover` (reviewer flagged it as "vague"/"soon" but the proof structure is delegated downstream — not must-fix this iter).
- **Do NOT** modify any other `\lean{...}` hint or `\leanok` marker in this chapter.
- **Do NOT** touch the 655 LOC of chapter content beyond the cross-reference fix.

## References

None — this is a mechanical cross-reference correction.

## Expected outcome

After this edit:
- `Cohomology_StructureSheafModuleK.tex` L629 `\uses{}` block points at the existing label `def:Scheme_HModule_prime`.
- The blueprint dependency graph regenerates cleanly (no broken cross-references in this chapter).
- The chapter goes from `correct: partial` to `correct: true` on the broken-cross-ref axis.

## Verification

After your edit, search the chapter for any remaining `\uses{def:Scheme_HModule'}` references. Confirm:
- The bad label appears 0 times in `Cohomology_StructureSheafModuleK.tex` post-edit.
- The good label `def:Scheme_HModule_prime` appears in the L629 `\uses{}` block.
- No other chapters reference `def:Scheme_HModule'` (the reviewer's Cross-chapter notes confirmed this label doesn't exist elsewhere).
