# Lean↔Blueprint — GrassmannianQuot (iter-060)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean
## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Check
Bidirectional. This iter re-proved `bundleTransition_self` (`lem:gr_bundleCocycle_id`) leaner +
added helper `pullbackFreeIso_trans_symm_eqToIso`. Confirm: (a) `\lean{}` pins resolve to real
decls; (b) the new helper + recent matrix-infra helpers (scalarEnd_*, matrixEnd*, matrixToFreeIso,
bundleTransitionData) lacking blueprint entries — list each as coverage debt; (c) C2
`bundleTransition_cocycle` blueprint sketch detail sufficiency for the iter-061 prover. Report
must-fix vs minor.
