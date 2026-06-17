# Lean Auditor Directive

## Slug
iter196

## Scope (files)
all

## Focus areas
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E supplements + Proj.awayι recipe)
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` (new MvPolynomial Submersive substrate + projectiveLineBar_smooth_chart_aux)
- `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` (IsFlasque.constant_of_irreducible empty-branch closure + skyscraperSheaf outer step)
- `AlgebraicJacobian/RiemannRoch/OCofP.lean` (new private helpers `toFunctionField_injective` + `functionField_const_of_complete_curve_of_orderZero`; body of `exists_nonconstant_rational_from_dim_eq_two`)
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (helper (a) reformulation `phi_left_locallyQuasiFinite_of_finrank_one`)
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Route 2 PID-transfer body in `isRegularInCodimOneProjectiveLineBar`)
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (plan-phase carrier-soundness refactor: 6 carriers refactored to `HasPicSharp`/`HasPicScheme`/etc. typeclass + `Classical.choice` extraction pattern + `⟨sorry⟩` instances)

## Known issues
- iter-195 lean-auditor (logs/iter-195/lean-auditor-iter195-report.md) flagged 3 must-fix items: `WeilDivisor.lean:746` instance-with-sorry-body propagation, `Thm32RationalMapExtension.lean:194` in-proof `haveI := sorry`, `AlbaneseUP.lean:183` `:= sorry` def. **Two of these were addressed in the iter-196 plan-phase** via `refactor-must-fix-demotions` (instance → theorem demotion in WeilDivisor.lean; consumer-binder threading in RationalCurveIso.lean) and the plan-phase `refactor-carrier-soundness-fgapic` (typeclass-gated carriers in FGAPicRepresentability.lean). Please verify these refactors landed cleanly and do not re-flag the same items; instead flag any NEW silent-sorryAx-propagation patterns introduced by the refactors.
- The `Thm32RationalMapExtension.lean:194` in-proof sorry was NOT addressed this iter — re-flag if still present.
- `FGAPicRepresentability.lean` now has 7 typed sorries (was 6 + 1 new from `instHasPicScheme` co-dependency); they are all inside `⟨sorry⟩` instance bodies. Audit whether this co-dependency chain `HasPicScheme → HasPicSharp` is auditable (lean_verify-traceable) or still represents silent propagation.

## Absolute paths
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/
