# lean-auditor directive — iter-178 touched files

## Mode

Whole-project audit, with extra attention to the 7 files that received
prover work in iter-178 plus the iter-177 carry-over items.

## Iter-178 touched files (READ these in priority order)

1. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
   — Lane 7: `Module.projectiveDimension` body filled (one-liner via
   `CategoryTheory.projectiveDimension`).
2. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/CodimOneExtension.lean`
   — Lane 4: `extend_iff_order_nonneg` body filled axiom-clean; new
   private helper `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`
   introduced with sorry body (Mathlib gap); `localRing_dvr_of_codim_one`
   main body landed delegating to that helper.
3. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`
   — Lane 2: `iotaGm_isDominant` flipped to `by` block; still `sorry`;
   structural documentation block added (planner-intended PARTIAL).
4. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuotScheme.lean`
   — Lane 6: `canonicalBaseChangeMap_isIso` body now structural via
   `Hom.isIso_iff_isIso_app`; new helper
   `canonicalBaseChangeMap_app_app_isIso` carries Stacks 02KH(ii) sorry.
5. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/OCofP.lean`
   — Lane 1: PRIMARY MUST-FIX; threaded
   `[Scheme.IsRegularInCodimensionOne C.left]` into namespace variable
   block (restored `lake build` to green).
6. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
   — Lane 5 (SIGNATURE-MUTATING): Part A `iso_of_degree_one` signature
   hypothesis changed from `≅` (Type-iso) to `≃+*` (ring iso); Part B
   `morphismToP1OfGlobalSections` body partial (concrete
   `Over.homMk (Proj.fromOfGlobalSections …)` body, residual sorry on
   section-condition closure — undischargeable from current signature).
7. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
   — Lane 3: `principal_degree_zero` constant branch closed axiom-clean;
   non-constant branch sorry remains (gated on Lane 5 closing).

## Carry-over from iter-177 audit (do NOT reopen — track only)

- 2 named TEMP project axioms (`gmScalingP1_chart_data_temp`,
  `gmScalingP1_collapse_at_zero_temp`) in
  `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — flagged CRITICAL
  by iter-177 lean-auditor. iter-181 RETIRE-OR-ESCALATE trigger live in
  STRATEGY.md.
- `Picard/RelativeSpec.lean` placeholder bodies (`RelativeSpec _𝒜 := X`,
  `structureMorphism _ := 𝟙 X`) — flagged CRITICAL iter-176; iter-178
  mathlib-analogist consult #2 produced a 4-encoding option report.

## What to audit

- Verify the 7 iter-178 file edits are non-laundering (real-bodies, not
  placeholders) where the task_result claims "RESOLVED" / kernel-clean.
- Verify the new sorry helpers in Lane 4 + Lane 6 are non-tautological
  in their TYPE (substantive Mathlib-gap content, not placeholder
  bodies).
- Audit Lane 5 Part B's "residual sorry" claim: the task_result says
  the section condition is "mathematically undischargeable from the
  current signature" — verify this claim matches what is on file.
- The `morphismToP1OfGlobalSections` body must show concrete
  `Over.homMk (Proj.fromOfGlobalSections …)` form, NOT a bare sorry or
  `Iso.refl` placeholder.
- Pay extra attention to namespace `variable` block changes in
  Lane 1 OCofP: confirm the new `[Scheme.IsRegularInCodimensionOne]`
  binder does not leak to unrelated declarations.

Report findings in your task_results file per the standard format.
