# Blueprint Reviewer Directive

## Slug
iter020

## Scope
Whole-blueprint audit as usual (per-chapter completeness + correctness checklist). Do NOT
scope-limit — the cross-chapter view is the point. Two chapters changed THIS iter and need explicit
HARD-GATE confirmation; treat them as the focus of your verdict while still auditing everything:

### Gate-critical: `blueprint/src/chapters/Picard_QuotScheme.tex`
A prover dispatches against `AlgebraicJacobian/Picard/QuotScheme.lean` this iter to close the SINGLE
remaining open leaf of the SNAP-S2 keystone `gradedModule_hilbertSeries_rational`: the `iSupIndep`
(degreewise-image independence) hole inside
`lem:graded_subquotient_base_eventuallyZero` (newly written this iter). Confirm specifically:
- Is the base-case block `lem:graded_subquotient_base_eventuallyZero` complete + correct, with a
  concrete, formalizable argument for the degreewise-image independence (the dfinsupp /
  degree-`n`-component route, kept inside `Q₀`'s κ-structure)?
- Do the `\uses{}` of that block and of `lem:graded_subquotient_isRatHilb` resolve and reflect the
  real dependencies (base case, ker/coker constructors, `IsRatHilb` toolkit)?
- Are the new "Finiteness-transfer infrastructure" and "Subquotient constructors" subsubsections,
  the re-stated `lem:graded_subquotient_finite_transfer`, and the six `\mathlibok` anchors
  internally consistent and correctly cross-referenced?
Report this chapter as `complete: true/false`, `correct: true/false`, with any must-fix-this-iter.

### Confirmation: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
This chapter was reconciled this iter to a **route swap**: the section-level base-change mate now
derives from `lem:base_change_mate_domain_read` + `lem:base_change_mate_codomain_read` +
`lem:base_change_mate_gstar_transpose`, and the old Seam-2 `fstar`-reindex apparatus
(`lem:base_change_mate_fstar_reindex`, `..._legs`, `..._unitExpand`, `..._gammaDistribute`,
`..._codomain_read_legs`) is marked **superseded / dead code pending removal**. Three phantom blocks
(`..._eCancel`, `..._affineUnit`, `..._innerMatch`) that pinned non-existent Lean decls were
deleted. NO prover runs on FBC this iter. Confirm only:
- No broken `\uses{}` remain (the deleted phantom labels are not referenced anywhere).
- The live route prose (`section_identity` via domain/codomain read + `gstar_transpose`) is
  mathematically coherent, and `lem:base_change_mate_gstar_transpose` reads as the live remaining
  crux (the next FBC prover target).
- Any residual Lean-leakage or supersession-prose that should be cleaned (FYI only — handled next
  iter; not gating).

## Notes
- `task_results/**` is your write-domain for the report.
- Do not add or remove any markers; you are read-only on `.tex` except your report.
