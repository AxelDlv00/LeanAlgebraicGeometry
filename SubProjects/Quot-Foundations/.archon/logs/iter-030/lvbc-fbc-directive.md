# Lean vs Blueprint checker — FlatBaseChange (iter-030)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## This iter's prover work
- Added lemma `base_change_mate_fstar_reindex_legs_link_distributeCollapse` (~L1333): states LHS+RHS in single composite-functor form `(pushforward (Spec φ) ⋙ moduleSpecΓFunctor).map (...)`, fuses the blueprint step-(iii) "links 1+3" (gammaDistribute + factor-3 collapse). Compiles, axiom-clean.
- Spliced it term-mode into the still-`sorry` `base_change_mate_fstar_reindex_legs` (~L1461); the distribution wall is passed but the eCancel telescoping residual remains `sorry`.

Report: (a) does the Lean follow the blueprint (no fake/placeholder statements, signatures match `\lean{...}` hints, the new helper is reflected or is honest coverage debt); (b) is the chapter detailed enough to have guided this formalization (does the effort-broken link decomposition match what the prover actually built)? Flag any blueprint `\lean{}` pin that points at a renamed/absent decl. Severity-tag findings.
