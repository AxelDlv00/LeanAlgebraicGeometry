# Lean Auditor Directive

## Slug
iter174

## Scope (files)
all

## Focus areas

- `AlgebraicJacobian/Genus0BaseObjects.lean` — Lane A continuation; helper landed at L555 (`homogeneousLocalizationAwayIso_algebraMap`) + L991 (`gmScalingP1_chart_PLB_eq`); `over_coherence` (L1158) closed structurally; `chart_agreement` (L1120) partial closure (diagonals + cross sorries).
- `AlgebraicJacobian/Picard/LineBundlePullback.lean` — NEW FILE this iter (5 sorries, scaffold).
- `AlgebraicJacobian/Picard/RelativeSpec.lean` — `QcohAlgebra` (L117) carrier replaced with substantive `structure` (Encoding I — `sheaf` + `unit` fields).
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean` — NEW FILE this iter (3 sorries + 1 helper `sheafOf` typed-`sorry`).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — `ofClosedPoint` body closed (L170/L184) with a junk-defined off-regime branch.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK*` — file split refactor landed plan-phase this iter (verify the re-export shape is clean).
- Cross-cutting: flag any `True := trivial`, `Iso.refl`-tautology, `Classical.choice`-around-witness, or `proof_wanted` patterns introduced this iter on declarations with substantive type-level claims.

## Known issues

- The 4 chapter-coverage gaps reported by blueprint-doctor (e.g. `Albanese_AlbaneseUP.tex` covers `AlgebraicJacobian/Albanese/AlbaneseUP.lean` which does not exist) are intentional — chapters landed plan-phase iter-174; their Lean files are iter-175+ work. Do NOT report these as audit findings.
- The `gmScalingP1_chart_agreement` cross-case sorries (`(0,1)`, `(1,0)`) and `gmScalingP1_chart_PLB_eq` Step C sorries are intentionally deferred per the analogist recipe — flag them ONLY if their type signatures are anti-pattern (e.g. weakened to a tautology) or the documentation comments are excuse-comment shaped.
