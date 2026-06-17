# Blueprint Reviewer Directive

## Slug
iter152

## Scope
Whole-blueprint audit (all chapters under `blueprint/src/chapters/`). Do NOT
limit scope — the cross-chapter view is the point.

## Context for this iter (architectural pivot)
The project just committed a route pivot: `[IsAlgClosed kbar]` is being added
to `rigidity_over_kbar`, which collapses `constants_integral_over_base_field`
(via `IsAlgClosed.algebraMap_bijective_of_isIntegral`) and DESCOPES the
(S3.sep.1/2)+(S3.pi.1/2) decomposition. A prior prover lane proved the KDM
lemma `mem_range_algebraMap_of_D_eq_zero` is FALSE as previously stated
(missing geometric hypothesis); the corrected signature adds `[IsAlgClosed k]`
+ `[IsDomain B]`.

Pay particular attention to:
- `RigidityKbar.tex` § "Chart-algebra piece (ii)" — the KDM lemma prose
  currently presents (C.d) as a closable Leibniz chase / Mathlib gap; the
  iter-151 review added a `% NOTE` flagging it false-as-stated. This chapter
  will be rewritten by a blueprint-writer THIS iter for the alg-closed setting;
  report what must change (corrected KDM hypotheses; collapsed constants proof;
  (S3.*) status as descoped/off-path).
- `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` — the (S3.*) sub-claims that
  are being descoped. Report whether they should be marked off-critical-path or
  removed.

Report your standard per-chapter completeness/correctness checklist + the
HARD-GATE status for the chapters feeding active prover work
(RigidityKbar.tex, ChartAlgebraS3.tex). Note any broken `\uses{}`/`\ref{}`
arising from the descoping.
