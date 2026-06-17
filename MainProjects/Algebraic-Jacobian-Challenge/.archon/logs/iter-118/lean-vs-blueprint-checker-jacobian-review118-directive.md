# Lean ↔ Blueprint Checker Directive

## Slug
jacobian-review118

## Iteration
118

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex

## Known issues
- `Jacobian.lean:179` body is `sorry` — the project's single
  surviving foundational hypothesis `nonempty_jacobianWitness`.
  Flag in your report but do not classify as fake content.
- This iteration's blueprint-writer (Fix 1+2+3) tightened the
  `thm:IsAlbanese_unique` prose to match the Lean statement,
  added a new subsection "The Albanese witness bundle" with a
  `def:JacobianWitness` block (7 fields enumerated) and design-
  choice / smooth-redundancy remarks, and added a new subsection
  "Extracting the universal morphism" with `\lean{...}` references
  for `IsAlbanese.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}`.
  Audit whether the Lean and blueprint are now in mutual agreement
  for the Jacobian / IsAlbanese / JacobianWitness surface.
