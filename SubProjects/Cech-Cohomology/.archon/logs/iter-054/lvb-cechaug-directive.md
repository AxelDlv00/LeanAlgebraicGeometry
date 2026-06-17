# Lean-vs-blueprint check

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean

## Blueprint chapter (consolidated; declares `% archon:covers` for this file)
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

The chapter covers many files; focus on the blocks relevant to `CechAugmentedResolution.lean`,
chiefly `lem:cech_augmented_resolution` (\lean{AlgebraicGeometry.cechAugmented_exact}) and its
\uses helpers.

## What to check
- Does the Lean follow the blueprint? Any fake/placeholder statements, signature mismatches,
  vacuous reformulations?
- This iter the prover added `AlgebraicGeometry.isZero_homology_of_homotopy_id_zero`
  (`Homotopy (𝟙 D) 0 → IsZero (D.homology p)`) and wired it into `cechAugmented_exact`, sharpening
  the single residual sorry (line ~205) from `IsZero (…homology p)` to `Homotopy (𝟙 D) 0`. Confirm:
  (a) `cechAugmented_exact`'s signature still matches the blueprint statement;
  (b) the residual sorry corresponds to the SAME gap the blueprint names (the prepend-`i_fix`
  contracting-homotopy / section-complex identification), not a divergence;
  (c) `isZero_homology_of_homotopy_id_zero` is a faithful realization of the Step-3(d) mechanism
  the blueprint prose describes.
- Is the blueprint adequate to guide the remaining work, or too thin? Flag if the chapter
  understates the residual.
- Report any declaration present in Lean but missing a blueprint `\lean{}` block.

## Output
Bidirectional report (Lean→blueprint and blueprint→Lean) with must-fix-this-iter items called out.
