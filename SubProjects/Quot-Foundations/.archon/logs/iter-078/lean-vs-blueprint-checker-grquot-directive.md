# lean-vs-blueprint-checker — GrassmannianQuot

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Check
Bidirectional. This iter closed `isIso_pullback_isoLocus_map` and `chartLocus_isOpenCover`
(the Nitsure §1 covering, ~600 lines via affine epi-splitting: exists_section_of_epi_free_spec,
matrixEndRect_comp_rect/injective, exists_isUnit_submatrix, etc.). Also landed the overlap
matrix core (presentedMatrix, presentedMatrix_changeOfBasis = Nitsure M^I = M^I_J·M^J,
isUnit_of_isIso_matrixEndRect). Verify: (a) the chartLocus_isOpenCover Lean proof matches the
blueprint's covering statement (note: prover SUBSTITUTED an affine-splitting argument for the
blueprint's stalkwise-surjectivity sketch — flag if chapter prose now mismatches the Lean
route); (b) ~15 new matrix/covering helpers — blueprint coverage vs 1-to-1 debt; (c) chapter
adequacy for the 4 remaining sorries.
