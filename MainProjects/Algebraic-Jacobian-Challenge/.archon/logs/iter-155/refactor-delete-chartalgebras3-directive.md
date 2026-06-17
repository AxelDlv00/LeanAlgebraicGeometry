# Refactor Directive

## Slug
delete-chartalgebras3

## Problem

`AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean` is **fully orphaned dead
scaffolding**. It holds 4 `sorry`-bodied lemmas (the descoped general-over-`k`
separability/inseparability route, "S3.sep.1/2", "S3.pi.1/2"). The iter-152
`[IsAlgClosed]` pivot made `constants_integral_over_base_field` close over `k̄`
WITHOUT any of these lemmas, and the iter-154 review + lean-auditor confirmed the
file is imported but **consumed by nothing**: `ChartAlgebra.lean` imports it
(line 6) but uses none of its declarations, and the root aggregator
`AlgebraicJacobian.lean` imports it (line 7) only to include it in the build.

Removing the file drops the global `sorry` count from 7 to 3 and deletes ~400
lines of dead code.

## Mathematical Justification

The (S3.*) lemmas were the general-over-arbitrary-`k` route to "constants of a
proper geometrically irreducible curve are integral over the base field", routed
through a base-change-to-`k̄` + separable/inseparable factorisation. Under the
committed `[IsAlgClosed k̄]` pivot (STRATEGY.md § Route C), the base is already
algebraically closed, so `constants_integral_over_base_field` closes directly via
`IsAlgClosed.algebraMap_bijective_of_isIntegral` (closed iter-153, axiom-clean) and
the (S3.*) detour is never invoked. The lemmas are mathematically valid but
permanently off the critical path; they are not Mathlib-PR-staged here and carry no
downstream consumer. Deleting them changes no proof obligation of any live
declaration.

## Changes Requested

- **File: `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`** — DELETE the entire file.

- **File: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`**
  - Old (line 6): `import AlgebraicJacobian.Cotangent.ChartAlgebraS3`
  - New: (remove this import line entirely)
  - The two stale comment mentions of `ChartAlgebraS3` (around L59 and L362) are
    prose only and refer to it as "not consumed" — leave them or lightly reword to
    past tense; do not let comment cleanup block the structural change.

- **File: `AlgebraicJacobian.lean`** (root aggregator)
  - Old (line 7): `import AlgebraicJacobian.Cotangent.ChartAlgebraS3`
  - New: (remove this import line entirely)

- **File: `blueprint/src/content.tex`**
  - Old: `\input{chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3}`
  - New: (remove this `\input` line entirely)

- **File: `blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`**
  — DELETE the entire chapter file. Confirmed safe: its only labels
  (`chap:cotangent-chartalgebra-s3`, `sec:chartalgebras3-source-citations`) have
  ZERO inbound `\cref`/`\uses`/`\ref` from any other chapter (iter-155
  blueprint-reviewer grep across all 12 chapters). The four (S3.*) lemma labels
  are DEFINED in `RigidityKbar.tex`, not in this chapter — do NOT touch
  `RigidityKbar.tex`.

## Affected Files

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (import removed; must still compile — it consumes nothing from S3)
- `AlgebraicJacobian.lean` (import removed)
- `blueprint/src/content.tex` (`\input` removed)
- No `.lean` file other than those two imports `ChartAlgebraS3`. No cref cascade.

## Constraints

- Do NOT modify `RigidityKbar.tex` or any other blueprint chapter.
- Do NOT touch any protected declaration (none are in `ChartAlgebraS3.lean`).
- Before deleting, do a final `grep -rn ChartAlgebraS3` across `*.lean` and
  `*.tex` to confirm no consumer beyond the two imports + the content.tex `\input`
  + in-file comments; report anything unexpected instead of forcing the delete.

## Expected Outcome

- `ChartAlgebraS3.lean` and its chapter gone; both imports + the `\input` removed.
- The project compiles end-to-end (`lake build` green). Verify with
  `lean_diagnostic_messages` on `ChartAlgebra.lean` and `AlgebraicJacobian.lean`
  (and run a `lake build` to confirm the aggregator + downstream load).
- Global `sorry` count drops from 7 to 3 (remaining: `Jacobian.lean` ×2,
  `RigidityKbar.lean` ×1).
- No new axioms. blueprint-doctor (loop-run) should be clean — no orphan chapter,
  no broken `\input`/`\cref`.
