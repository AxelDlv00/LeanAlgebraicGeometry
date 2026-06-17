# Lean ↔ Blueprint Checker Directive

## Slug

chartalgebra-iter150

## Target Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

## Target blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex`

This chapter contains the canonical statements for the chart-algebra
piece (ii) — chiefly:

- `lem:chart_algebra_isPushout_of_affine_product`
- `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
- `lem:constants_integral_over_base_field`
- `lem:Scheme_Over_ext_of_diff_zero`
- (BR.1)–(BR.5) sub-step blocks under the KDM body
- (S3.\*) sub-claim labels (cross-referenced from the sister chapter
  `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`)

## Focus areas

- **KDM (BR.5) joint-kernel collapse**: this iteration the Lean file
  gained ~190 LOC of MvPolynomial helper machinery
  (`_finsupp_sub_single_eq_of_one_le`,
  `_mvPoly_coeff_pderiv_at_shifted`,
  `_mvPoly_mem_range_C_of_pderiv_eq_zero`,
  `_mvPoly_mem_range_C_of_D_eq_zero`) plus SubmersivePresentation
  extraction + lift to `bTilde`. Check the blueprint's (BR.5) sub-block
  against the Lean body's "MvPolynomial FREE-CASE → SubmersivePresentation
  lift → functoriality reduction" decomposition. The residual structured
  sorry concentrates on the "transfer" step
  (`α : P.Ring` with `algebraMap P.Ring B α = b` and `D_A α = 0`).
- **Constants substep 3 (hPI branch)**: the consolidated `⟨hPI, hSep⟩`
  sorry was split iter-149; hSep is project-internally closed; hPI is
  still structured `sorry` with a 5-step base-change chain documented
  inline. Verify the chapter's (S3.pi.\*) decomposition matches.
- **Signature shape**: KDM ships with `[CharZero k]` + `{n : ℕ}` +
  `[Algebra.IsStandardSmoothOfRelativeDimension n k B]`. The chapter
  documents this as the (p2) char-0 bridge. Check the `\lean{...}`
  hint and the chapter prose are aligned with the current binders.
- **Decorative typeclasses** flagged iter-148 on
  `df_zero_factors_through_constant_on_chart`: verify whether the
  iter-149 signature inflation + (n := n) propagation cleaned it up.

## Acceptance criteria

Per-direction findings (Lean → blueprint AND blueprint → Lean) with
severity tags. Must-fix-this-iter items should be explicit. If the
file is already aligned with the chapter, say so.
