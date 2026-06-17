# Lean ↔ blueprint check — FlatBaseChange (iter-035)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Report:
(a) Lean → blueprint: any Lean declaration that is fake/placeholder/vacuous relative to
    what its blueprint block claims; any `\lean{...}` pin pointing at a non-existent or
    renamed decl; any signature mismatch.
(b) Blueprint → Lean: blocks too thin to have guided the formalization; the conjugate
    chain blocks (conj-1a `lem:base_change_mate_codomain_read_legs_conj`, conj-1b `_eq`,
    conj-2c `lem:base_change_mate_reindex_conj_pushforwardCollapse`, conj-2a
    `lem:base_change_mate_fstar_reindex_legs_conj`, the wrapper
    `lem:base_change_mate_fstar_reindex_legs`).

Key facts to check against: conj-2a (`base_change_mate_fstar_reindex_legs_conj`) is the
SINGLE residual FBC sorry; the wrapper `base_change_mate_fstar_reindex_legs` has a
sorry-free body that reduces to conj-2a. Helper defs `conjPullbackFactor`,
`conjPullbackFactor_eq_pullbackComp`, `base_change_mate_codomain_read_legs_param`,
`base_change_mate_codomain_read_legs_eq_param` have NO blueprint block yet (coverage debt).
Also: conj-2b (`lem:base_change_mate_reindex_conj_pullbackLeg`) and conj-2d
(`lem:base_change_mate_reindex_conj_crossLayer`) are blueprint blocks whose Lean decls do
NOT exist (gated on conj-2a's normal form) — flag whether their `\uses` wiring is honest.

Mark each finding must-fix-this-iter / major / minor. Write to your task_results file.
