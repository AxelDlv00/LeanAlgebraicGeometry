# Lean ↔ Blueprint Checker — iter-148

## Scope (one file pair)

- **Lean file**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- **Blueprint chapter**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex`
  (the chart-algebra piece (ii) first-class decomposition section
  contains the entries for the Lean declarations in this file).

## Why this pair

The iter-148 prover lane touched this Lean file only. Five
declarations: 3 sorry-free (algebra_isPushout_of_affine_product,
df_zero_factors_through_constant_on_chart, Scheme.Over.ext_of_diff_zero)
+ 2 sorry-using (KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero,
constants_integral_over_base_field).

The iter-148 prover lane:
- Refreshed the L137–168 KDM forward-inclusion docstring with the
  (BR.1)–(BR.5) char-0 bridge sub-gap inventory; the structured
  `sorry` at L168 is preserved.
- Reduced the constants substep (3) goal to the consolidated
  `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ` conjunction,
  with the substantive sorry now at L364–367; the surrounding flow
  (steps (a)/(b.1)/(b.2)) lands sorry-free.

Verify:
1. Per-declaration: does the Lean signature match the blueprint
   `\lean{...}` hint? Are the in-scope hypotheses (Smooth, IsProper,
   IsReduced, GeometricallyIrreducible, etc.) what the blueprint's
   informal statement assumes?
2. Per-declaration: does the Lean proof outline (in-source
   comment skeleton + the structured `sorry`) match the blueprint's
   informal proof recipe?
3. Bidirectional: does the blueprint contain enough detail to have
   guided the iter-148 reduction (smart-proof path (b) framework,
   `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`
   closer choice)?

Apply the checker's standard bidirectional report.
