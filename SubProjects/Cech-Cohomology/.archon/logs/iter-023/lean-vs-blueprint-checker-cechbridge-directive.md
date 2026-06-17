# Lean ↔ Blueprint check — CechBridge.lean (iter-023)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file

/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean

## Blueprint chapter

/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(Consolidated chapter declaring `% archon:covers ... CechBridge.lean ...`; relevant blocks include
`lem:ses_cech_h1` (\lean{AlgebraicGeometry.ses_cech_h1}), `lem:section_cech_homology_exact`,
`lem:injective_cech_acyclic`, `def:cech_complex`.)

## What to check

(a) Lean → blueprint: The two new decls this iter are
   `sectionCech_objD_exact_of_isZero_homology` and `sectionCech_one_coboundary_of_isZero_homology`.
   Both are `lean_aux` (no blueprint block). Are their Lean statements faithful (no
   fake/placeholder)? The second is claimed to be the `\uses{def:cech_complex}` Čech-algebra core
   of `lem:ses_cech_h1` (Ȟ¹=0 ⟹ every 1-cocycle is a coboundary, in section coordinates).
   Confirm. Note `ses_cech_h1` itself is `\lean`-named in the blueprint but is NOT built (the
   residual is pure sheaf theory) — confirm it is absent on the Lean side, not faked.
(b) Blueprint → Lean: Does the chapter need new blocks for these two helper lemmas? Is the
   `lem:ses_cech_h1` block's proof sketch detailed enough to guide the remaining sheaf-theoretic
   assembly (local-surjectivity extraction + Grothendieck-topology gluing), or is it too thin?

Report bidirectionally with must-fix-this-iter findings clearly marked.
