# Blueprint Writer Directive

## Slug
mv-fix

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Strategy context

Phase A active target is `cechCofaceMap_pi_smul` closure in `BasicOpenCech.lean`. The Mayer–Vietoris chapter is the blueprint for Čech acyclicity infrastructure (basic-open cover, augmented complex contraction, comparison-isomorphism transport). The chapter is `correct: partial` per blueprint-reviewer-iter105 due to ONE broken `\uses{}` cross-reference at L779 — a dependency-graph corruption that must be fixed before downstream Čech-acyclicity work proceeds.

## Required content

### Change 1 — Fix broken cross-reference at L779

The theorem at L775–L788, `\thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top`, has a `\uses{}` block that includes the label `def:Scheme_HModule_eq_HModule_prime_linearEquiv`. This label does NOT exist anywhere in the blueprint (verified by Grep across `blueprint/src/chapters/*.tex`).

The intended target is almost certainly `def:Scheme_HModule_prime_eq_HModule_linearEquiv` (the **reverse-direction** label), defined at L644 of the same chapter. The directionality reversal matters for the dependency graph because the proof transport runs left-to-right on the type.

**Fix**: replace `def:Scheme_HModule_eq_HModule_prime_linearEquiv` in the `\uses{}` block at L779 with `def:Scheme_HModule_prime_eq_HModule_linearEquiv`.

Iter-104 blueprint-reviewer already flagged this; iter-105 reviewer re-confirmed. This is a mechanical typo fix.

### Out of scope this round

- **Do NOT** add new prose for the `cechCofaceMap_*_family` engine — that's queued for after iter-107's L1147 closure.
- **Do NOT** rewrite the proof sketches that the reviewer flagged as "vague" (Step 3 contraction, Step 4 globalization, `\thm:cechCohomology_subsingleton_of_cechCochain_exactAt`). Those are "soon" items, not must-fix this iter.
- **Do NOT** add missing `\uses{}` blocks to `\thm:cechCohomology_subsingleton_of_cechCochain_exactAt` and `\def:splitEpi_pi_lift_of_injective` (reviewer flagged as "soon", not must-fix).
- **Do NOT** modify any other `\lean{...}` hint or `\leanok` marker.

## References

None — this is a mechanical cross-reference correction. No external sources needed.

## Expected outcome

After this edit:
- `Cohomology_MayerVietoris.tex` L779 `\uses{}` block points at the existing reverse-direction label `def:Scheme_HModule_prime_eq_HModule_linearEquiv`.
- The blueprint dependency graph regenerates cleanly (no broken cross-references in this chapter).
- The chapter goes from `correct: partial` to `correct: true` on the broken-cross-ref axis (the "missing engine prose" finding is queued for a later iter, not addressed here).

## Verification

After your edit, search the chapter for any remaining `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` references. Confirm:
- The bad label appears 0 times in `Cohomology_MayerVietoris.tex` post-edit.
- The good label `def:Scheme_HModule_prime_eq_HModule_linearEquiv` appears in the L779 `\uses{}` block.
- No other chapters reference the bad label (the reviewer's Cross-chapter notes confirmed this label doesn't exist elsewhere).
