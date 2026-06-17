# Blueprint-reviewer directive — finish-line whole-blueprint audit

Audit the whole blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter checklist.

## Context for this audit
The project is at its finish line: project-wide inline `sorry` count = 0; the capstone
`AlgebraicGeometry.cech_computes_higherDirectImage` (in `CechToHigherDirectImage.lean`, covered by the
consolidated chapter `Cohomology_CechHigherDirectImage.tex`) is proved.

This iter the comparison-lemma blueprint was RECONCILED: two near-duplicate blocks
(`lem:cech_computes_cohomology` pinned to the live `cech_computes_higherDirectImage`, and an orphaned
`lem:cech_computes_cohomology_affineCover` pinned to a now-deleted Lean name) were merged into the single
block `lem:cech_computes_cohomology` carrying the precise hypotheses (`[X.IsSeparated] [S.IsSeparated]`,
affine cover `h𝒰`, `hres` family) and a scope note with the ℙ¹/O(-2) counterexample. The orphaned block
was deleted.

## Focus
- Confirm the merged `lem:cech_computes_cohomology` statement now faithfully matches the live Lean
  signature and that its `\uses{}` is accurate (deps: cech_augmented_resolution, cech_term_pushforward_acyclic,
  acyclic_resolution_computes_derived, pushforward_mapHC_cechComplexOnX, cechAugmented_to_acyclicResolutionInput,
  def:cech_complex, def:higher_direct_image).
- Verify no chapter still references the deleted `lem:cech_computes_cohomology_affineCover` label.
- Standard whole-blueprint completeness/correctness pass; flag any block that is `partial`/`false`.

Output your usual per-chapter checklist + must-fix list.
