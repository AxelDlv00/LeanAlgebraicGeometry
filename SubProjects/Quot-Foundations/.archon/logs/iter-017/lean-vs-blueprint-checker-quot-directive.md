# Lean ↔ Blueprint Checker Directive

## Slug
quot

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

## Known issues
- This is the FIRST Route-2 (ambient subquotient induction) prover dispatch. ~13 new axiom-clean
  declarations landed in `namespace AlgebraicGeometry.GradedModule`, `section Subquotient`. Two have
  existing `\lean{}` pins: `subquotientHilb` (`def:graded_subquotientHilb`) and
  `subquotient_degreewise_diff` (`lem:graded_subquotient_degreewise_diff`). Verify those two match
  their blueprint blocks (signature + that the landed proof's mathematical content matches the
  chapter sketch).
- The remaining new declarations are auxiliary ambient-homogeneity-calculus helpers WITHOUT pins yet
  (`RaisesDegree`, `RaisesDegree.mem`, `decompose_raisesDegree`, `decompose_raisesDegree_zero`,
  `comap_isHomogeneous`, `map_isHomogeneous`, `inf_isHomogeneous`, `sup_isHomogeneous`,
  `map_inf_degree_eq`, `sup_inf_degree_eq`, `finrank_comap_subtype`). These are KNOWN coverage debt
  slated for the planner. Report them under coverage/adequacy but they are expected, not red flags.
- Note: `subquotientHilb` is realized as a function of the pair `(N, N')` only (the endo-family +
  Module.Finite datum from the blueprint definition is carried as induction-lemma hypotheses, not
  bundled into the def). Confirm this is consistent with the blueprint's `def:graded_subquotientHilb`
  prose or flag the divergence.
- The 4 pre-existing protected `sorry` stubs (lines ~123/161/198/225) are expected; not your concern.
- The P(r) induction (`subquotient_hilbertSeries_rational`) and `subquotient_finite_transfer` were
  NOT added this iter (blocked on the finiteness encoding); their blueprint blocks remain unpinned —
  expected, not a red flag.
