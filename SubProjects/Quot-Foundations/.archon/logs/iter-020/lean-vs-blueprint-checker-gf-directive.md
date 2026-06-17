# Lean ↔ Blueprint Checker Directive

## Slug
gf

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- The L4 finiteness leaf (`exists_localizationAway_finite_mvPolynomial`, `hfin` `sorry`) and
  `genericFlatness` (GF-geo) are known-open honest residuals — do not flag the `sorry` itself as
  must-fix; only flag if the blueprint prose CLAIMS them closed or the Lean comments are dishonest.
- Focus the verification on `genericFlatnessAlgebraic` (`thm:generic_flatness_algebraic`): this
  iter closed the subsingleton + short-exact-sequence dévissage obligations via
  `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` with a `Module.compHom` restricted
  `A`-action; only the quotient (`N ≅ B/𝔭`) obligation remains `sorry`. Confirm the chapter's
  dévissage proof sketch matches this landed structure and is detailed enough.
