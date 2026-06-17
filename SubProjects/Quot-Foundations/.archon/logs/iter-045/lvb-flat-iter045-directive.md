# Lean vs Blueprint — FlatteningStratification.lean

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Context for this check
This iter added two new non-private decls with NO blueprint block yet:
`finite_localizedModule_of_isLocalizedModule` (~L2173) and
`gf_finite_sections_of_basicOpen_finite_cover` (~L2231) — the locality-reduction half of
G1 (`lem:gf_qcoh_fintype_finite_sections`, Stacks 01PB). The G1 full form is NOT added
(blocked on finite-type base case). `genericFlatness` @2371 still `sorry`. Report (a)
Lean-follows-chapter and (b) chapter adequacy; flag the 2 unmatched new defs as needing
blueprint blocks and whether G1 should be split into "locality reduction" (done) + "base case".
