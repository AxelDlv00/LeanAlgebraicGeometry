# Lean ↔ blueprint checker directive — iter-223

## The one Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Its blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What to check

Report bidirectionally for this file vs its chapter. In particular:

1. **`internalHomEval` (`lem:internal_hom_eval`).** The Lean declaration `internalHomEval`
   exists but its `naturality` field is a typed `sorry` (the proof is NOT closed). Confirm:
   - the blueprint block for `lem:internal_hom_eval` does NOT overclaim (it should acknowledge
     the open naturality obligation, e.g. via a `% NOTE:` and a per-object/assembly split);
   - the `\lean{...}` pin names the actually-built declaration;
   - the statement is faithful (no fake/weakened/placeholder statement on either side).
2. Whether the chapter is detailed enough to have guided this formalization, or whether the
   Lean clearly needed more blueprint detail than the chapter provides.
3. Any signature mismatch, renamed declaration, or `\lean{...}` hint that no longer resolves.

Write your report to `task_results/lean-vs-blueprint-checker-ts223.md`.
