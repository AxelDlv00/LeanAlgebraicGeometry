# blueprint-reviewer directive — iter-140

You are the iter-140 blueprint-reviewer. Read the **whole** blueprint
(every chapter under `blueprint/src/chapters/`) plus
`blueprint/src/content.tex` for the chapter ordering. Produce the
standard per-chapter checklist + flagged-issues block.

## Hard-gate question this iter

The iter-139 plan-agent deferred the iter-139 prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean` because YOUR iter-139
verdict marked both `RigidityKbar.tex` and
`AlgebraicJacobian_Cotangent_GrpObj.tex` as `complete: partial`
(d_app + d_map closure recipes lived only in the Lean docstring; the
two iter-138 helpers `basechange_along_proj_two_inv_derivation` +
`basechange_along_proj_two_inv` had no `\lean{...}` blocks).

A blueprint-writer ran iter-139 (`blueprint-writer-rigiditykbar-iter139`)
and landed 6 directive edits in `RigidityKbar.tex`:
1. Iter-138 closure-shape NOTE block.
2. d_app closure recipe NOTE block.
3. d_map closure recipe NOTE block.
4. Route (b'2) IsIso sub-paragraph in IsIso NOTE block.
5. Two new `\lean{...}` lemma blocks for
   `basechange_along_proj_two_inv_derivation` and
   `basechange_along_proj_two_inv`.
6. `% NOTE iter-139:` flag on `\leanok` mis-mark concern at L491–L504.

The plan agent also updated `AlgebraicJacobian_Cotangent_GrpObj.tex`
directly with a 2-bullet addition naming the two iter-138 helpers.

Chapter `RigidityKbar.tex` grew from 754 → 1224 LOC.
Chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` is 82 LOC.

**Render your iter-140 verdict on whether the HARD GATE now CLEARS for
the iter-140 prover lane targeting**:
- `AlgebraicJacobian/Cotangent/GrpObj.lean` (iter-140 prover target;
  3 sub-sorries: L581 d_app + L585 d_map + L624 IsIso, inside iter-138
  helpers `basechange_along_proj_two_inv_derivation` + main body of
  `relativeDifferentialsPresheaf_basechange_along_proj_two`).

Mapping reminder:
- `AlgebraicJacobian/Cotangent/GrpObj.lean` → `AlgebraicJacobian_Cotangent_GrpObj.tex` (pointer chapter) AND
  the substantive content lives in `RigidityKbar.tex` (§ Piece (i.b)).
  The lookups span BOTH chapters.

For each chapter you audit, report `complete: true|partial|false`,
`correct: true|partial|false`, plus must-fix-this-iter findings.

## Out-of-scope this iter

- Lean code review (that's lean-auditor's job in review phase).
- Strategy critique (strategy-critic).
- Iter-by-iter narrative.

## Output

Write a self-contained report to `task_results/<your-name>-<slug>.md`.
The plan agent reads it on return and uses its checklist to decide
whether the prover lane on `Cotangent/GrpObj.lean` proceeds this iter.
