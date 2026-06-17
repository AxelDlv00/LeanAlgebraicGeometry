# Lean ↔ Blueprint Checker Directive

## Slug
jacobian-iter117

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex

## Known issues
- `nonempty_jacobianWitness` (L179) is the single remaining sorry-bodied existence hypothesis — intentionally kept as the foundational mathematical assumption. The blueprint chapter was rewritten this iter by `blueprint-writer-jacobian-iter117` to expand `thm:nonempty_jacobianWitness` proof-block to a detailed 3-route decomposition (Pic^0 / Sym^g / genus-0) with explicit Mathlib infrastructure required for each route. Verify the expanded proof block honestly discloses the deferral and lists the Mathlib gaps.
- The four protected instances (`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) are all honest projections from `(jacobianWitness C).<field>`. Verify their `\lean{...}` blocks match the witness-projection definition and the signatures are unchanged from `archon-protected.yaml`.
- `JacobianWitness` is a structure bundling the candidate Albanese object plus its universal-property data uniform over $k$-rational marked points. Verify the blueprint has a `\def{}` (or `\structure{}`) block describing this bundle and its `isAlbaneseFor` field's role.
- `IsAlbanese`, `IsAlbanese.ofCurve`, `IsAlbanese.comp_ofCurve`, `IsAlbanese.exists_unique_ofCurve_comp`, `IsAlbanese.unique`, `geometricallyIrreducible_id_Spec` — verify each non-trivial declaration in the Lean has a corresponding blueprint block.
