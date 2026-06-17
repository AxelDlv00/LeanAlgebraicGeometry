# Directive — blueprint-reviewer

Whole-blueprint audit (your standard per-chapter completeness + correctness checklist). Read the entire
blueprint under `blueprint/src/chapters/`.

## Focus for the HARD GATE this iter
Two prover lanes are queued for iter-052, both gated on the consolidated chapter
`Cohomology_CechHigherDirectImage.tex` (its `% archon:covers` list includes both target files):

1. **`AffineSerreVanishing.lean`** — build the unconditional 02KG tops `affine_cech_vanishing_qcoh`
   and `affine_serre_vanishing` by discharging the `htilde` hypothesis of the existing
   `_of_tildeVanishing` forms with the now-proved `sectionCech_homology_exact_of_localizationAway`
   (`lem:affine_cech_vanishing_tilde_subcover`). Blueprint blocks `lem:affine_cech_vanishing_qcoh` and
   `lem:affine_serre_vanishing` are the targets.
2. **`CechHigherDirectImage.lean`** — build `cechAugmented_exact` (`lem:cech_augmented_resolution`) via
   the **sections/sheafification route** the proof sketch was just rewritten to (NOT stalk-at-prime).

This chapter was just edited (blueprint-writer + blueprint-clean iter-052): added route-B helper blocks
(`lem:isLocalizedModule_comp_away`, `lem:section_cech_module_exact_of_localizationAway`), the
augmented-complex object layer (5 def/lemma blocks), fixed two hint-precision defects, and rewrote the
`lem:cech_augmented_resolution` proof to the sections/sheafification route.

## Verify specifically
- Is `lem:cech_augmented_resolution`'s rewritten proof sketch **complete and correct** for the
  sections/sheafification route — i.e. does it give a prover enough to formalize (reflect via faithful
  `toSheaf`; homology sheaf = sheafification of presheaf homology via `homologyIsoSheafify`; presheaf
  homology locally zero on the affine basis from `sectionCech_affine_vanishing`; `LocallyBijective`
  W-equivalence kills it; augmentation node at degree 0)? Are the `\uses{}` accurate and resolvable?
- Are the new coverage-debt blocks well-formed (statement + `\lean{}` + `\uses` + one-line proof), and
  do their `\lean{}` pins name real declarations?
- Do the 02KG top blocks (`lem:affine_cech_vanishing_qcoh`, `lem:affine_serre_vanishing`) still
  correctly describe the discharge, and is `lem:affine_cech_vanishing_tilde_subcover` now adequately
  detailed for the change-of-ring step?

Report your standard per-chapter `complete:`/`correct:` verdicts and any must-fix-this-iter items. Also
include your `## Unstarted-phase blueprint proposals` section if any strategy phase lacks coverage.
