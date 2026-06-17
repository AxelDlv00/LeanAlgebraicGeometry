# Lean ↔ Blueprint check — FlatBaseChange (iter-011)

Verify one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

This iter executed a route swap: `base_change_mate_regroupEquiv` was rebuilt `sorry`-free via a
pushout-cancellation (`cancelBaseChange`), and `base_change_mate_generator_trace_eq` was renamed
to `base_change_mate_section_identity` (statement reframed to the blueprint's section-identity
reading `Γ(θ) = lTensor R' η_M`). Three `sorry`s remain: the section-identity crux, the affine
reduction (`affineBaseChange_pushforward_iso`), and the out-of-scope FBC-B globalization.

Report:
1. **Lean → blueprint**: does `base_change_mate_section_identity` match `lem:base_change_mate_section_identity`?
   Does the rebuilt `base_change_mate_regroupEquiv` still match `lem:base_change_mate_regroupEquiv`?
   Are the `sorry`-bearing decls' docstrings honest about what remains (no overclaim)?
2. **Blueprint → Lean**: is the section-identity block detailed enough to guide closing the crux
   `sorry`, or is the blueprint too thin there? Confirm no blueprint block still pins the deleted
   `base_change_mate_generator_trace_eq` name.
3. Any must-fix-this-iter findings.
