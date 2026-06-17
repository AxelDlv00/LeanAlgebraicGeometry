# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- 4 active `sorry` are known-open targets: `base_change_mate_fstar_reindex_legs` (~1446, root
  crux blocked by the `X.Modules` instance diamond), `base_change_mate_gstar_transpose` (~1818,
  gated on `_legs`), affine (~1999), FBC-B (~2021). Do not re-report these as incomplete; only
  flag if the blueprint blocks for them are inadequate.
- This iter the prover de-privatized 3 atoms (`gammaMap_pushforwardComp_hom_eq_id`,
  `_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) so blueprint `\lean{}` pins resolve — confirm
  the pins now resolve.
- Two docstrings (~1838, ~1911) were corrected from "sorry-free" to "transitively sorry-backed
  through base_change_mate_gstar_transpose" — confirm accuracy, not laundering.
