# Lean ↔ Blueprint Checker Directive

## Slug
h1v

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/H1Vanishing.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_H1Vanishing.tex

## Focus areas
- `IsFlasque.constant_of_irreducible` (L138) — empty branch now CLOSED axiom-clean
  via `TopCat.Sheaf.isTerminalOfEqEmpty` + `IsTerminal.isZero` +
  `ModuleCat.subsingleton_of_isZero`. Non-empty branch remains sorry pending
  the `constantSheaf` unit-iso-on-irreducible-spaces Mathlib gap. Verify the
  blueprint adequately describes the non-empty-branch closure strategy.
- `skyscraperSheaf_eq_pushforward_const` (L818) — outer iso lift CLOSED axiom-clean
  via `ObjectProperty.FullSubcategory.ext`. Inner iso (skyscraperSheaf PUnit
  ≅ constantSheaf on PUnit) remains sorry pending `constantSheaf` Full/Faithful
  instances on PUnit. Verify blueprint coverage.
- `IsFlasque.injective_flasque` (L613) — was explicitly out-of-scope per iter-196
  PROGRESS directive; bare sorry unchanged.

## Out of scope
- AddCommGrpCat short-exact-sequence machinery covered in iter-194/195.
