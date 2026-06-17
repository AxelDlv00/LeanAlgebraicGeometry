# Lean ↔ Blueprint Checker Directive

## Slug
gf

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- This iter closed exactly one target: `gf_torsion_reindex` (`lem:gf_torsion_reindex`), now
  `sorry`-free and axiom-clean (`{propext, Classical.choice, Quot.sound}`). Verify the landed
  proof's mathematical content matches the chapter's reindex sketch (L5b decomposition).
- FIVE new helper declarations in namespace `AlgebraicGeometry.GenericFreeness` were added this
  iter and currently have NO blueprint `\lean{...}` block (they are unmatched `lean_aux` nodes):
  `pullbackModuleAddEquiv`, `finite_of_pullbackModuleAddEquiv`, `pullback_isScalarTower`,
  `finite_of_quotientRingEquiv`, `isLocalizedModule_restrictScalars`. These are already known
  coverage debt to be blueprinted by the planner next iter — report them under "Unreferenced
  declarations / Blueprint adequacy" but they are tracked; no need to escalate each to must-fix.
- Four open `sorry`s remain (L4 line ~486, L5 `exists_free_localizationAway_polynomial` ~1267,
  `genericFlatnessAlgebraic` ~1374, `genericFlatness` ~1436) — honest downstream scaffolding.
  Flag only signature-vs-prose mismatches or chapter blocks too thin to have guided the reindex
  proof.
