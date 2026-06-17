# Blueprint-reviewer directive — iter-017 whole-blueprint audit (HARD GATE)

Audit the WHOLE blueprint (all chapters under `blueprint/src/chapters/`). Produce your standard
per-chapter completeness + correctness checklist and the unstarted-phase proposals.

This iter the chapter `Cohomology_CechHigherDirectImage.tex` was edited by a blueprint-writer to:
1. reconcile `def:section_cech_complex` + `lem:cech_complex_hom_identification` target category from
   "O_X(U)-modules" to **abelian groups (Ab)** (matching the iter-016 Lean + the Stacks source quote);
2. add a new `def:cover_structure_presheaf` block for the augmentation object O_𝒰
   (`\lean{AlgebraicGeometry.coverStructurePresheaf}`), wired into `lem:cech_free_complex_quasi_iso`;
3. add `[Finite I]` + coproduct-notation prose to `def:cech_free_presheaf_complex`;
4. expand the L1 categorical→module bridge proof in `lem:cech_acyclic_affine` into a three-part
   formalizable decomposition;
5. bundle 19 helper Lean names into existing `\lean{...}` lists;
6. add a `% archon:covers ... CechBridge.lean` line.

## Gate focus (the three prover lanes this iter depend on these clearing complete + correct):
- `lem:cech_acyclic_affine` (+ `def:standard_affine_cover`) → file `CechAcyclic.lean`.
- `def:cech_free_presheaf_complex`, `def:cover_structure_presheaf`, `lem:cech_free_complex_quasi_iso`
  → file `FreePresheafComplex.lean`.
- `def:section_cech_complex`, `lem:cech_complex_hom_identification` → file `CechBridge.lean`
  (new; covered by the consolidated chapter).

Confirm specifically:
- the Ab reconciliation is internally consistent (statement, proof, and the bundled
  `freeYonedaHomAddEquiv` all agree on abelian groups);
- `def:cover_structure_presheaf` has a valid SOURCE/SOURCE QUOTE and the augmentation map is described
  precisely enough to formalize;
- the L1 expansion is mathematically sound and adequate to guide a mathlib-build prover;
- no must-fix-this-iter findings remain on any of the three lanes' blocks.

Report per-chapter `complete:` / `correct:` verdicts and any must-fix items. This is the HARD GATE for
the three prover lanes — they only dispatch if their blocks clear complete + correct with no must-fix.
