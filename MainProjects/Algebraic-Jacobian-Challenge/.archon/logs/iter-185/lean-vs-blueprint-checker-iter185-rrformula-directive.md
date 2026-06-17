# Lean ↔ Blueprint Checker Directive

## Slug
iter185-rrformula

## Lean file
AlgebraicJacobian/RiemannRoch/RRFormula.lean

## Blueprint chapter
blueprint/src/chapters/RiemannRoch_RRFormula.tex

## Known issues
- iter-185 Lane H PARTIAL: `Scheme.finrank_H0_toModuleKSheaf_eq_one` (L231) closed Tier-1 axiom-clean via H⁰-bridge through `Cohomology/StructureSheafModuleK/Carriers.lean`. `Scheme.eulerCharacteristic_sheafOf_succ` (L258) consumer-side is sorry-free assembly via a NEW named typed-sorry helper `Scheme.eulerCharacteristic_of_shortExact_skyscraper` (L329). Sorries 2 → 1.
- Pre-existing build failure (iter-184) at L353/L373 was fixed by replacing `congr 1` with `congrArg (fun e => χ(sheafOf e)) hsplit` in the +ve / −ve inductive bridges.
- Iter-184 was NOT_DISPATCHED (rate-limit).
- The named helper `eulerCharacteristic_of_shortExact_skyscraper` is NOT chapter-pinned via `\lean{...}`; verify if the chapter should grow a corresponding lemma block or if it can be treated as a project-internal helper.
- Confirm `thm:riemannRoch_genus_zero` (L343) and `thm:euler_char_eq_deg_plus_one_minus_genus` chapter blocks remain accurate after the iter-185 changes (the prover claims they stay axiom-clean assembly mod transitive typed-sorries).
