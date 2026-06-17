# Lean ↔ Blueprint Checker Directive

## Slug
linebundle-iter109

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundle.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_LineBundle.tex

## Known issues (do not re-report verbatim)

- The iter-109 (Archon canonical) prover round was a single-file lane that
  closed 3 of 4 sorries in `Picard/LineBundle.lean`:
  - `Pic.pullback` body (L108) — closed.
  - `Pic.pullback_id` body (L131) — closed.
  - `Pic.pullback_comp` body (L147) — closed.
  Both `SheafOfModules.pullback_tensorObj` (L82) and a NEW helper
  `SheafOfModules.pullback_oneIso` (L96) remain `sorry`-bodied as the
  named-deferred Mathlib gaps that together represent the `μIso` and `εIso`
  of the missing `Functor.Monoidal (Scheme.Modules.pullback f)` instance.
- The blueprint chapter prose at L62 (NOTE) and L81 still says the Lean bodies
  of `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` "remain `sorry`" —
  this is now stale; the bodies are closed (gated only on the two iso oracles).
- The new helper `SheafOfModules.pullback_oneIso` is not currently referenced
  by any `\lean{...}` block in the chapter. Whether this is a chapter
  inadequacy (should add a new `\thm:SheafOfModules_pullback_oneIso` block
  analogous to `\thm:SheafOfModules_pullback_tensorObj`) or acceptable
  (helper-only sister to the existing gap) is what we want you to opine on.
