# Lean ↔ blueprint check — CechAugmentedResolution.lean

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`
- Blueprint chapter: `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (this consolidated chapter carries `% archon:covers .../CechAugmentedResolution.lean`; the relevant
  block is `lem:cech_augmented_resolution`, whose Lean target is `AlgebraicGeometry.cechAugmented_exact`).

Report:
(a) **Lean → blueprint** — does the Lean follow the blueprint? Is `cechAugmented_exact`'s
    signature faithful to `lem:cech_augmented_resolution`? The proof is built end-to-end EXCEPT one
    residual `sorry` (~line 180, the section-complex homology vanishing). Is the residual sorry the
    SAME mathematical gap the blueprint's Step 3/4 names (the cover-agnostic prepend-`i_fix`
    contracting homotopy), or has the proof diverged onto a different route? Are the two new helpers
    (`isZero_of_faithful_preservesZeroMorphisms`, `isZero_presheafToSheaf_of_locally_isZero`) faithful
    supporting lemmas or do they smuggle in unproven assumptions?
(b) **blueprint → Lean** — is the chapter detailed enough to have guided this formalization? Does it
    name the two new helper declarations in any `\lean{...}` block, or are they uncovered (the prover
    flagged both as needing blueprint entries)? Is the Step 3/4 discharger sketch (prepend-homotopy)
    precise enough for a prover to close the residual next iter?

Flag any must-fix-this-iter findings. Absolute paths above; read them directly.
