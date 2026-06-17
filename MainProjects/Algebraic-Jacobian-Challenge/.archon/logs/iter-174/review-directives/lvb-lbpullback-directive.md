# Lean ↔ Blueprint Checker Directive

## Slug
lbpullback-iter174

## Lean file
AlgebraicJacobian/Picard/LineBundlePullback.lean

## Blueprint chapter
blueprint/src/chapters/Picard_LineBundlePullback.tex

## Known issues

- This is a NEW file landing iter-174 as a file-skeleton (5 pins, all sorry-bodied; all type signatures are non-tautological — see task_result for design rationale).
- Pin 1 `Scheme.LineBundle.OnProduct` is `Type (u+1) := sorry` mirroring iter-173 precedent for `QcohAlgebra` (Mathlib lacks an `IsInvertible` predicate on `Scheme.Modules`). This is honest scaffolding pending an upstream / project-side build.
- Pin 3 `pullback_pullback_eq` was carefully NOT a `True := trivial` / `X = X` tautology — type expresses the canonical base-change iso on `Scheme.Modules.pullback`.
- Pin 5 `functorial` is a `Quotient → Quotient` map (NOT yet the full `(Sch/S)^op ⥤ Set` packaging — that is iter-175+ work documented in the task result).
- Check whether the chapter's `\lean{...}` pins match the 5 declarations 1:1 and whether the chapter's proof sketches are detailed enough to body-fill these 5 sorries.
