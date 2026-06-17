# Lean ↔ Blueprint Checker Directive

## Slug
fbc-iter024

## Lean file
AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- `base_change_mate_inner_value_eq` (Seam A) still carries a `sorry` (literal-form-lock blocker after
  the step-(ii) Γ-collapse) — known PARTIAL; do not re-report the bare sorry, but DO assess whether the
  chapter block `lem:base_change_mate_inner_value_eq` is detailed enough to guide the remaining
  telescoping, and whether the three `lem:base_change_mate_inner_eCancel_*` atom blocks (now formalized
  axiom-clean this iter) match their Lean decls.
- `base_change_mate_gstar_transpose` still carries a `sorry`, gated on inner_value_eq — known.
- `base_change_mate_fstar_reindex_legs` (~1421) is dead code with a sorry — known, out of scope.
- `affineBaseChange_pushforward_iso` / `flatBaseChange_pushforward_isIso` carry sorry — known, out of scope.

Focus your assessment on: (1) the 3 new `inner_eCancel` atom blocks (signature + proof-sketch fidelity
to the landed Lean atoms), (2) whether `lem:base_change_mate_gstar_generator_close` (now closed by
`rfl` in Lean) is faithfully described by its chapter block, and (3) blueprint adequacy of
`lem:base_change_mate_inner_value_eq` for the remaining work.
