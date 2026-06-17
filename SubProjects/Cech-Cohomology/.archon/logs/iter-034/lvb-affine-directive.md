# Lean ↔ blueprint check — AffineSerreVanishing.lean (iter-034)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; declares `% archon:covers ... AffineSerreVanishing.lean ...`)

This iter the prover added 4 declarations completing the 02KG cover-system chain:
- `toSheaf_preservesFiniteColimits` (blueprint `lem:toSheaf_preservesFiniteColimits`)
- `toSheaf_preservesEpimorphisms` (blueprint `lem:to_sheaf_preserves_epi`)
- `affine_surj_of_vanishing` (blueprint `lem:affine_surj_of_vanishing`)
- `affineCoverSystem` (blueprint `def:affine_cover_system`)

Verify bidirectionally:
- Lean → blueprint: do the 4 Lean statements match their blueprint statements? Any fake/placeholder
  statement, signature mismatch, or vacuity? In particular `affineCoverSystem.Cov` is ALL finite
  basic-open families (covering condition established inside `affine_surj_of_vanishing`, not in `Cov`) —
  the prover flagged this as broader than the blueprint's "standard open covers" prose. Is the blueprint
  prose now misaligned and in need of a writer fix?
- Blueprint → Lean: is the chapter detailed enough to have guided these proofs? Any block that should
  be `\leanok` now but reads as unformalized?

Report must-fix-this-iter findings explicitly if any.
