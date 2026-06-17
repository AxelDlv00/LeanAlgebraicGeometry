# Blueprint Writer Directive

## Slug
chartalgebras3-offpath

## Target chapter
blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex

## Strategy context (the slice that matters)
The project pivoted to proving rigidity over an algebraically closed base k̄.
Under `[IsAlgClosed k]`, `constants_integral_over_base_field` collapses to a
one-liner via `IsAlgClosed.algebraMap_bijective_of_isIntegral`, so the four
(S3.*) sub-claims (S3.sep.1, S3.sep.2, S3.pi.1, S3.pi.2) — which existed only to
prove `constants_integral_over_base_field` over a GENERAL field k — are no longer
on the M2.a critical path.

## Required edits to this chapter
- This is a STATUS-marking pass, NOT a removal. KEEP all four `lem:S3_*` labels
  and their statements (removing them would break `\cref`s here and the
  path-(b) `\uses` cascade elsewhere; they are also genuine, valid
  general-over-k lemmas worth preserving as upstream-Mathlib-PR fodder).
- Add an explicit status line to the chapter intro AND to each of the four
  (S3.*) lemma blocks: "DESCOPED under the alg-closed pivot — this sub-claim is
  the general-over-k formulation and is NO LONGER on the M2.a critical path
  (constants_integral_over_base_field now closes over k̄ via
  IsAlgClosed.algebraMap_bijective_of_isIntegral); retained as an
  auditable / upstream-Mathlib-PR record."
- Update/replace the now-stale "Body status (iter-149 prover lane)" and
  "iter-150 HYBRID" prose that presents the four sub-claims as ACTIVE BUILD
  TARGETS; reframe them as off-path. Keep the Stacks `% SOURCE QUOTE:` citation
  blocks verbatim and intact.

## Out of scope
- Do NOT remove any label or statement. Do NOT edit other chapters.
- Do NOT add `\leanok`/`\mathlibok`. Do NOT write Lean tactics.
