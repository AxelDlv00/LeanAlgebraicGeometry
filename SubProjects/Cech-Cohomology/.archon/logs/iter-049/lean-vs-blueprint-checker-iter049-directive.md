# Lean ↔ blueprint check — iter-049

Verify exactly one Lean file against its blueprint chapter:

- Lean file: `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint chapter: `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (this chapter declares `% archon:covers AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`)

Relevant blueprint labels: `lem:affine_serre_vanishing`, `lem:affine_cech_vanishing_qcoh`,
`def:affine_cover_system`.

This iter the prover added four NEW Lean declarations that are NOT yet blueprinted:
- `affine_cover_span_localizationAway`
- `cechCohomology_isZero_of_iso`
- `affine_cech_vanishing_qcoh_of_tildeVanishing`  (a REDUCTION of `lem:affine_cech_vanishing_qcoh`
   to an explicit `htilde` hypothesis — the blueprint-named target `affine_serre_vanishing` /
   `affine_cech_vanishing_qcoh` are NOT yet formalized)
- `affine_serre_vanishing_of_tildeVanishing`  (a REDUCTION of `lem:affine_serre_vanishing`)

Report bidirectionally:
- Lean → blueprint: are the four new decls faithful scaffolding, or do any misrepresent /
  placeholder the blueprint statements? Is the blueprint's `\lean{AlgebraicGeometry.affine_serre_vanishing}`
  pin pointing at a declaration that does NOT yet exist in Lean (the prover built only the
  `_of_tildeVanishing` reduced form)?
- Blueprint → Lean: is the chapter detailed enough to guide the residual `htilde` leaf
  (the change-of-base-to-`R_f` tilde Čech vanishing)? Or is the blueprint too thin where the
  Lean clearly needs more structure?

Read only the two files named above. Report must-fix items explicitly.
