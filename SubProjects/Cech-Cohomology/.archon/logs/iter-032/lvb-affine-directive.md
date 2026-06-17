# Lean-vs-blueprint check (one file)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(This consolidated chapter covers AffineSerreVanishing.lean; the relevant blocks are
`lem:standard_cover_cofinal`, `lem:to_sheaf_preserves_epi`, `lem:affine_surj_of_vanishing`,
`def:affine_cover_system`, `lem:affine_faces_mem`, `lem:affine_injective_acyclic`.)

Report bidirectionally:
(a) Lean -> blueprint: do the landed Lean declarations (`standard_cover_cofinal`, and pre-existing
    `affine_faces_mem`, `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic`) match their blueprint
    statements? Is `standard_cover_cofinal`'s realized indexed-refinement signature faithfully described by
    `lem:standard_cover_cofinal` (the prose was originally written as an abstract "cofinal system")? Is the
    `\uses{def:standard_affine_cover, lem:scheme_isBasis_affineOpens}` accurate, given the proof actually uses
    `PrimeSpectrum.isTopologicalBasis_basic_opens` rather than `Scheme.isBasis_affineOpens`?
(b) blueprint -> Lean: is `lem:to_sheaf_preserves_epi`'s informal proof ("forgetful functor is exact ...")
    adequate / accurate, given the prover found it reduces to toSheaf right-exactness (PreservesFiniteColimits)
    which Mathlib does not package? Flag if the blueprint proof understates the difficulty.
