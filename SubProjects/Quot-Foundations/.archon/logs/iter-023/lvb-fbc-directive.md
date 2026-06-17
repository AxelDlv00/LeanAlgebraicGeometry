# lean-vs-blueprint-checker — FlatBaseChange (iter-023)

Verify one Lean file against its blueprint chapter, bidirectionally.

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Focus this iter: the gstar-chain decomposition (effort-breaker `fbc-gstar`). Three new theorems
were formalized — `base_change_mate_gstar_counit_transport` (closed, axiom-clean),
`base_change_mate_gstar_generator_close` (sorry), `base_change_mate_inner_value_eq` (sorry) — and
two intermediates (`inner_unitReduce`, `inner_eCancel`) named in the blueprint but NOT yet given
Lean declarations. Check:
- Do the three new Lean theorems' statements faithfully match their blueprint blocks
  (`lem:base_change_mate_gstar_counit_transport`, `..._generator_close`, `..._inner_value_eq`)?
- Are the two intermediate blueprint blocks (`..._inner_unitReduce`, `..._inner_eCancel`) adequate,
  or is the blueprint too thin to formalize them (the prover reported their prose types are
  elaborate four-factor composites it could not safely stub)?
- Any fake/placeholder statements, signature mismatches, or blocks where the blueprint is the
  failure (too thin to guide formalization).
