# lean-vs-blueprint-checker — FlatBaseChange (iter-035)

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Report:
(a) Lean -> blueprint: any fake/placeholder statement, signature mismatch with a \lean{} pin,
    or new declaration with no blueprint block (1-to-1 coverage debt). The iter-035 additions to
    this file are new and may be uncovered.
(b) blueprint -> Lean: any \lean{} pin pointing at a non-existent / renamed declaration, any block
    whose informal proof is too thin to have guided the formalization, broken \uses{}.

Specifics for this file:
- New decls: conjPullbackFactor(+_eq_pullbackComp), base_change_mate_codomain_read_legs_param(+_eq_param), base_change_mate_codomain_read_legs_conj(+_conj_eq), base_change_mate_reindex_conj_pushforwardCollapse. base_change_mate_fstar_reindex_legs_conj still carries sorry. Check whether the chapter's conj-chain blocks match the landed names and whether the helper defs need blocks.
