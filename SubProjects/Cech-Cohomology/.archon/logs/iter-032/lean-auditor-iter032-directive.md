# Audit scope

Audit these two Lean files as Lean (no strategy bias):

- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

Both received prover work this iteration. Produce your standard per-file checklist plus flagged-issues block.

Focus areas (do not let these narrow you — audit everything):
- AffineSerreVanishing.lean: a new lemma `standard_cover_cofinal` was added. Check it is non-vacuous, the
  statement is the genuine cofinality/refinement claim (finite standard subcover of D(f) refining an arbitrary
  open cover), and no covering/finiteness hypothesis was smuggled or weakened. Also confirm the file contains
  NO `sorry` and the documentation block for the (deliberately unbuilt) `toSheaf_preservesEpimorphisms` does
  not masquerade as a proved declaration.
- QcohTildeSections.lean: a new non-private lemma `isLocalizedModule_of_span_cover` plus several `private`
  helpers were added. Check the named lemma genuinely proves IsLocalizedModule descent along a finite
  unit-ideal-spanning cover (all three IsLocalizedModule clauses discharged, not assumed); that the private
  helpers are real and not circular; and that the statement hypotheses are not trivially satisfiable (vacuity).

Report axiom cleanliness observations only if you find something suspicious; the prover reported
`{propext, Classical.choice, Quot.sound}` for both.
