# Lean ↔ Blueprint Checker Directive

## Slug
rrformula-iter174

## Lean file
AlgebraicJacobian/RiemannRoch/RRFormula.lean

## Blueprint chapter
blueprint/src/chapters/RiemannRoch_RRFormula.tex

## Known issues

- This is a NEW file landing iter-174 as a file-skeleton (4 chapter pins + 1 unpinned helper `sheafOf`).
- Pin 1 `eulerCharacteristic` is concrete (one-liner `finrank H⁰ − finrank H¹`).
- Pin 2 `WeilDivisor.l` is concrete (uses `sheafOf` placeholder).
- Pin 3 + Pin 4 are `sorry`-bodied per iter-175+ deferral.
- The helper `sheafOf` (L168) is typed-`sorry` — its substantive type `WeilDivisor → Sheaf … (ModuleCat k̄)` is non-tautological per task_result.
- Confirm that pin 4's signature `l_eq_degree_plus_one_of_genus_zero` threads the `_hH1` hypothesis explicitly per the chapter's "Lean signature scope" paragraph (a deliberate departure from the informal statement).
- Pay attention to whether the chapter has detailed-enough proof sketches for pin 3 (Hartshorne IV.1.3 induction) and pin 4 (specialisation to `g = 0`).
