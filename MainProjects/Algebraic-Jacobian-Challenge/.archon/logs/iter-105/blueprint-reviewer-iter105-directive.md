# Blueprint Reviewer Directive

## Slug
iter105

## Strategy snapshot

Phase A active target: close trailing `sorry` at L1179 of `cechCofaceMap_pi_smul` in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`. Iter-105 added wrapper helpers (`cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`) and iter-106 added Route 1 lemma signature (`cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`, body sorry). All these are project-local helpers without `\lean{...}` entries — they do not require chapter coverage.

The blueprint chapter `Cohomology_MayerVietoris.tex` covers the surrounding scaffolding (basic-open cover, Čech acyclicity for `toModuleKSheaf`) but iter-104 review identified missing prose for the `cechCofaceMap_*_family` engine. That fix is queued for iter-107+ after L1179 closure.

The lean-auditor-iter104 report identified a CRITICAL finding: `Picard/LineBundle.lean`'s `def LineBundle X := CommRing.Pic Γ(X, ⊤)` is admitted-wrong on non-affine schemes by its own docstring. Phase C1 plans to refactor this to `Invertible` of `X.Modules`. The blueprint chapter `Picard_LineBundle.tex` should reflect this status — please verify it does.

## Routes

Single primary route this iter (Phase A active closure on `cechCofaceMap_pi_smul`). Multi-route strategic alternatives exist for Phase C3 (FGA-Hilbert vs Sym^g/S_g) but are not in scope for prover work this iter.

## Specific concerns

1. Re-verify the iter-104 must-fix findings are still live or have been addressed (broken `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` in MayerVietoris.tex L779; broken `\uses{def:Scheme_HModule'}` in StructureSheafModuleK.tex L629).
2. Check whether `Cohomology_MayerVietoris.tex` § Čech acyclicity still lacks prose for the `cechCofaceMap_*_family` engine (iter-104 finding; iter-105/106 added more wrapper helpers).
3. Check `Picard_LineBundle.tex` for the C1 refactor status — does the chapter reflect that the current definition is admitted-wrong and that C1 plans a redefinition?
4. Spot-check the other 9 chapter status (the project has been compile-clean for 12 consecutive iters; most chapters should be stable).

## Files / paths

- Strategy: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
- Blueprint chapters: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/*.tex`
- `archon-protected.yaml`: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/archon-protected.yaml`
- Prior iter-104 report (for change-detection): `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/logs/iter-104/blueprint-reviewer-iter104-report.md`
- Lean sources: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/**/*.lean` (read for cross-checking `\lean{...}` hints only — no Lean editing).
