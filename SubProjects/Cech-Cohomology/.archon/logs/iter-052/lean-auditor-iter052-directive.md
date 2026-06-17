# Lean Auditor Directive

## Slug
iter052

## Files to audit (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Focus areas
- Both files received new declarations this iter. In `AffineSerreVanishing.lean` the new
  decls are near the end of file: `affine_tildeVanishing` (private), `affine_cech_vanishing_qcoh`,
  `affine_serre_vanishing`. In `CechHigherDirectImage.lean` the new decls are a section at EOF
  (`CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W`, `…_of_W_isZero`,
  `…_of_isLocallyBijective`).
- Pay extra attention to: (a) whether any new declaration is a vacuous / hypothesis-weakened
  stand-in under a name that is supposed to carry real content; (b) the kernel-soundness trap
  where `ext`/`congr 1` auto-close subsingleton-morphism goals with an unsound rfl term the LSP
  accepts but the kernel rejects — check the new site lemmas and the discharge lemmas are not
  relying on it; (c) any excuse-comments ("temporary", "will fix", "stand-in"); (d) dead-end or
  trivially-true statements masquerading as the intended lemma.
- Note: `CechHigherDirectImage.lean:780` carries a pre-existing FROZEN `sorry`
  (`cech_computes_higherDirectImage`, protected P5b) — that is known and intentional; flag only
  if its surrounding comments are misleading, not the sorry itself.

## Output
Per-file checklist + flagged-issues block to task_results/.
