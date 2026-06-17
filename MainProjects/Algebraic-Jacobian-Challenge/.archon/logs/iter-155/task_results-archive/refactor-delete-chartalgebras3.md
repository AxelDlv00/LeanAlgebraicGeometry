# Refactor Report

## Slug
delete-chartalgebras3

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean` was fully orphaned dead
scaffolding holding 4 `sorry`-bodied lemmas (the descoped general-over-`k`
separability/inseparability route, S3.sep.1/2, S3.pi.1/2). The iter-152
`[IsAlgClosed]` pivot made `constants_integral_over_base_field` close over `k̄`
without any of these lemmas. The file was imported by `ChartAlgebra.lean` (L6)
and the root aggregator `AlgebraicJacobian.lean` (L7) but consumed by nothing.

### Changes Requested
- DELETE `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`.
- Remove its import from `ChartAlgebra.lean` (L6) and `AlgebraicJacobian.lean` (L7).
- Remove the `\input{...ChartAlgebraS3}` line from `blueprint/src/content.tex`.
- DELETE `blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`.
- Do NOT touch `RigidityKbar.tex`.

## Pre-flight verification

Final `grep -rn ChartAlgebraS3` across `*.lean`/`*.tex` (excluding `.archon/logs/`
historical snapshots) confirmed the directive's claims exactly. The only live
references were:
- `ChartAlgebra.lean:6` — import (removed)
- `AlgebraicJacobian.lean:7` — import (removed)
- `content.tex:19` — `\input` (removed)
- `ChartAlgebra.lean:58, 361` — prose comments ("no S3 lemma consumed")
- `RigidityKbar.tex:2132, 2190` — prose comments (left untouched per directive)

No `.lean` file other than the two imports consumed the file. No `\cref`/`\uses`/
`\ref` cascade. Nothing unexpected.

## Changes Made

### File: `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean` — DELETED
- **What:** Removed the entire file (4 sorry-bodied S3.* lemmas + scaffolding).
- **Why:** Off the critical path under the committed `[IsAlgClosed k̄]` pivot;
  no downstream consumer.
- **Cascading:** None — nothing imports its declarations.

### File: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- **What:** Removed `import AlgebraicJacobian.Cotangent.ChartAlgebraS3` (L6).
  Lightly reworded the two prose comments (L58, L361) that mention `ChartAlgebraS3`
  to note the file was removed iter-155; they already correctly stated no S3 lemma
  is consumed.
- **Why:** Import was dead; this file consumes nothing from S3.
- **Cascading:** None — compiles clean.

### File: `AlgebraicJacobian.lean` (root aggregator)
- **What:** Removed `import AlgebraicJacobian.Cotangent.ChartAlgebraS3` (L7).
- **Why:** Import existed only to include the dead file in the build.
- **Cascading:** None.

### File: `blueprint/src/content.tex`
- **What:** Removed `\input{chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3}` (L19).
- **Why:** Chapter file deleted.

### File: `blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` — DELETED
- **What:** Removed the entire chapter file.
- **Why:** Its labels (`chap:cotangent-chartalgebra-s3`,
  `sec:chartalgebras3-source-citations`) have zero inbound references. The four
  S3.* lemma labels are defined in `RigidityKbar.tex`, not here.

## New Sorries Introduced
- None. (The deletion *removes* 4 sorries.)

## Compilation Status
- `lake build`: **green** — "Build completed successfully (8331 jobs)."
- `ChartAlgebra.lean`: compiles (built in 10s, no errors).
- `AlgebraicJacobian.lean`: compiles (built in 3.7s, no errors).
- Remaining `sorry`-using declarations (per authoritative build warnings):
  `Jacobian.lean:193`, `Jacobian.lean:219`, `RigidityKbar.lean:75` → **3 total**,
  down from 7. Matches expected outcome exactly.
- No new axioms (no axiom warnings; build clean apart from pre-existing sorries
  and unrelated long-line style lints in Jacobian.lean/AbelJacobi.lean).

## Notes for Plan Agent
- Clean structural deletion; no complications. The directive's grep claims held
  exactly. `RigidityKbar.tex` left untouched as instructed (its two comment
  mentions of `ChartAlgebraS3.lean:Lxxx` line numbers are now stale prose
  pointers, but they are inside `% ...` comments and harmless — flagging in case
  a future blueprint pass wants to scrub them; I did NOT touch them per the
  constraint).
- blueprint-doctor should now find no orphan chapter and no broken
  `\input`/`\cref` for this file.
