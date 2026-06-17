# Lean ↔ blueprint check — QcohRestrictBasicOpen.lean (iter-038)

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file (absolute path)
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`

## Blueprint chapter (absolute path)
- `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (the consolidated chapter; QcohRestrictBasicOpen.lean is listed in its `% archon:covers` header).
  The relevant blueprint node is `lem:restrict_over_compat` (Route B step B3) and its B3a/B3b/B3c
  decomposition near line ~4139–4520; the chapter was rewritten by a blueprint-writer this iter.

## What to check
1. **Lean → blueprint:** the 8 new Lean decls this iter — `overForgetIso`, `overForgetInvIso`,
   `overBasicOpenRingHom`, `overBasicOpenRingInvHom`, `modulesOverBasicOpenEquivalence`, the two
   `..._isContinuous_toScheme` instances, and private `specBasicOpen_ι_image_overEquivalence_functor`.
   Does the chapter's B3 material faithfully describe what was built? Is `modulesOverBasicOpenEquivalence`
   (the B3 *engine equivalence*) the thing the blueprint's `\lean{...}` on `lem:restrict_over_compat`
   actually points at, or does the blueprint name a different/not-yet-built decl
   (`overBasicOpenIsoRestrict`, the B3 *object iso*, which was NOT built this iter)?
2. **Blueprint → Lean:** is the chapter detailed enough to have guided this formalization? Are there
   fake/placeholder statements, signature mismatches, or `\uses{}` gaps?
3. Report any `\lean{...}` name that no longer matches a real Lean decl, and any new Lean decl with no
   blueprint block (coverage debt).

## Output
Bidirectional report with red-flags (must-fix) and adequacy gaps (major/minor). Write to your
task_results file. Do not read STRATEGY.md or PROGRESS.md.
