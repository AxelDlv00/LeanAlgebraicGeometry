# lean-vs-blueprint-checker directive — iter-238

## The one Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Its blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What to verify (bidirectional)

This iter the prover added the by-hand Picard commutative group law (§5 in the Lean file,
~lines 730–863). Check that each of the following Lean declarations faithfully matches its
blueprint statement (signature, hypotheses, conclusion) — and conversely that the blueprint
prose is detailed enough and not over/under-claiming:

| blueprint label | Lean decl |
|---|---|
| `lem:tensorobj_assoc_iso` | `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` (now UNCONDITIONAL — hyps dropped this iter) |
| `lem:tensorobj_assoc_iso_invertible` | `...tensorObj_assoc_iso_invertible` |
| `lem:isinvertible_tensor` | `...IsInvertible.tensorObj` |
| `lem:isinvertible_unit` | `...isInvertible_unit` |
| `lem:isinvertible_inverse_welldef` | `...IsInvertible.inverse_unique` |
| `def:pic_carrier` | `...PicGroup` |
| `thm:pic_commgroup` | `...picCommGroup` |

Specifically check:
- Does the blueprint frame `lem:tensorobj_assoc_iso` as unconditional? The Lean signature is
  now `{M N P : X.Modules}` with no local-triviality / invertibility hypotheses. Flag any
  mismatch (e.g. blueprint still stating hypotheses the Lean dropped).
- Is `thm:pic_commgroup` a genuine `CommGroup` matching the blueprint's claimed group structure
  (mul = tensor, one = O_X, inv = membership witness)?
- Are there any fake/placeholder statements, or `\lean{...}` pins naming a decl that does not
  exist or has a different signature?
- Report bidirectionally: Lean→blueprint AND blueprint→Lean (the blueprint can be the failure
  if too thin to have guided this formalization).

Report must-fix items separately from minor items.
