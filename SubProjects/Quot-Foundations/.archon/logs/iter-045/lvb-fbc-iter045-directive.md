# Lean vs Blueprint — FlatBaseChange.lean

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Context for this check
This iter added two new non-private defs with NO blueprint block yet:
`keystoneAdjR` (~L1755) and `keystoneBeta` (~L1772) — the right-adjunction + comparison
nat-iso of the keystone conjugate pair feeding `base_change_mate_fstar_reindex_legs_conj`
(still `sorry` @1949). Report (a) whether the Lean follows the chapter (signature/`\lean{}`
match, no fake statements) and (b) whether the chapter is detailed enough to have guided
the `_legs_conj` formalization. Flag the 2 unmatched new defs as needing blueprint blocks.
