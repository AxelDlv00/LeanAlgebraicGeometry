# lean-vs-blueprint-checker directive — AffineSerreVanishing (iter-029)

Bidirectionally verify ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(this consolidated chapter `% archon:covers` AffineSerreVanishing.lean; the relevant
blocks are `lem:affine_faces_mem`, `lem:cover_datum_bridge`, `lem:affine_injective_acyclic`,
`def:affine_cover_system`, and the still-unbuilt `lem:standard_cover_cofinal`,
`lem:affine_surj_of_vanishing`, `lem:affine_serre_vanishing`).

## What to check
- Lean → blueprint: do the 3 landed decls (`affine_faces_mem`,
  `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic`) match their pinned
  blocks? Note `coverOpen_affineOpenCoverOfSpan` is the open-level half of
  `lem:cover_datum_bridge` (pinned to nonexistent `coverDatum_bridge`); a review `% NOTE:`
  was added there. `affine_injective_acyclic` is the ⊤-cover case only — does the block
  prose match that scope or overclaim?
- Blueprint → Lean: is the chapter detailed enough to have guided the blocked sub-lemmas
  (`standard_cover_cofinal`, `affine_surj_of_vanishing`, `affineCoverSystem`), or is the
  prose too thin where the prover hit genuine geometry gaps?
- Report any signature mismatch, fake/placeholder statement, or blueprint inadequacy.
