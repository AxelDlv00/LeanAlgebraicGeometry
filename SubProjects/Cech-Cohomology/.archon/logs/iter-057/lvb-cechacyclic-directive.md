# Lean ↔ blueprint check — CechAcyclic.lean

Verify bidirectionally one Lean file against its blueprint chapter.

Lean file:
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean

Blueprint chapter:
- /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
  (this is the consolidated chapter; the relevant block is `lem:affine_cech_vanishing_general_seed`
  with `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen}`, plus the route-B1 / change-
  of-base section).

This iter the prover added 6 axiom-clean declarations forming the general-affine-open Čech vanishing
seed (Need #2's `htilde`): `isLocalizedModule_baseChange_away`,
`SectionCechModule.dDiff_exact_of_affineCover`, `sectionCechAbExact_affine` (private),
`sectionCech_homology_exact_of_affineCover`, `basicOpen_algMap_section` (private),
`sectionCech_homology_exact_of_affineOpen`.

Report:
(a) Lean → blueprint: do the added declarations' statements match the blueprint block
    `lem:affine_cech_vanishing_general_seed` and the route-B1 narrative? Any fake/placeholder/vacuous
    statement, signature mismatch with `\lean{...}`, or proof divergence?
(b) blueprint → Lean: is the chapter detailed enough to have guided this formalization (the change-of-
    base M⊗_R S route, per-σ base-change localization, the geometric `Algebra Γ(V) Γ(D a)` instance trap)?
    Or is it too thin / missing the detail the Lean clearly needed?
Note the lone remaining `sorry` at line 110 is the pre-existing DEAD `affine` stub (out of scope).
