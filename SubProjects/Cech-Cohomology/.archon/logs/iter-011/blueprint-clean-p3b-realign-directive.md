# Blueprint Clean Directive — p3b-realign

## Target
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer just realigned the §"Presheaf-level Čech machinery" subsection +
`lem:injective_cech_acyclic` to the analogist's design (`analogies/p3b-presheafcech.md`):
- `def:cech_free_presheaf_complex` rewritten to use `free(yoneda U)` (no bespoke `j_!`);
- NEW `def:section_cech_complex` (section Čech complex, distinct from relative `CechComplex`);
- `lem:cech_complex_hom_identification` restated against the section complex;
- `lem:cech_free_complex_quasi_iso` proof prose updated;
- `lem:injective_cech_acyclic` proof rewritten via `injective_of_adjoint` + sheafification
  adjunction (drops enough-injectives + δ-functor);
- two NEW `\mathlibok` anchors `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`;
- REMOVED four off-path blocks (`lem:presheaf_modules_enough_injectives`,
  `lem:cech_delta_functor_presheaves`, `lem:grothendieck_enough_injectives`,
  `lem:module_cat_grothendieck`).

## Tasks
1. **Strip Lean leakage / process / project-history phrasing** from the edited/new blocks
   (e.g. "the scaffolder should build…", "not yet built", "to-be-formalized", prover-facing
   notes). Rewrite as timeless mathematics. Do NOT alter the math.
2. **Validate source quotes verbatim** against `references/stacks-cohomology.tex` for the
   edited/new blocks: `def:cech_free_presheaf_complex` (`lemma-cech-map-into`),
   `def:section_cech_complex` (the `\check{\mathcal C}^\bullet` definition, writer cited L879–910 —
   confirm), `lem:cech_complex_hom_identification` (`lemma-cech-map-into`),
   `lem:cech_free_complex_quasi_iso` (`lemma-homology-complex`), `lem:injective_cech_acyclic`
   (`lemma-injective-trivial-cech`). If any `% SOURCE QUOTE` is not verbatim, fix it from the
   source file. If a cited line range is wrong, correct the pointer.
3. **Confirm the two `\mathlibok` anchors carry no `% SOURCE` block** (correct — the `\lean{}`
   target IS the citation).
4. **Confirm `\uses{}`/`\label{}` well-formed and acyclic** for the new/edited blocks; report.

## Preserve (do NOT touch)
- `\leanok` markers (deterministic sync owns them).
- The two new `\mathlibok` anchors.
- All out-of-scope blocks (P3 `lem:cech_acyclic_affine`, P5 blocks, P1/P2 blocks).
- The mathematics.

## Report
What you stripped, source-quote validation results (per block), and acyclicity confirmation.
