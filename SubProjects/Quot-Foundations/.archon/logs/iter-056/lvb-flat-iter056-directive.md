# lean-vs-blueprint-checker — FlatteningStratification iter-056

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

Verify bidirectionally. Pay attention to:
- New helpers `gf_flat_of_isEpi`, `gf_isEpi_restrict_of_affine_le` (axiom-clean) — are they blueprinted? (likely lean_aux, flag for coverage).
- `informal/gf_openImmersion_isBaseChange.md` was rewritten "ingredient RESOLVED not missing" — does any blueprint `\lean{}` pin still frame the base change as a dead/absent route?
- `genericFlatness` residual sorry: blueprint should reflect that the residue is now in-Mathlib localization algebra (flatV), not a missing base change.
