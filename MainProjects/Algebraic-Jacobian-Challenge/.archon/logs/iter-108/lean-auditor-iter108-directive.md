# Lean Auditor Directive

## Slug
iter108

## Scope (files)
all .lean files under `AlgebraicJacobian/` (the project's main source tree).

## Focus areas (optional)
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — newly added `-- DEFERRED (budget)` annotation at L1846 (10 lines of comment + the `sorry` token). Verify the annotation is internally consistent (e.g. cited Mathlib names actually exist), and that no dead-end / orphan / stale "iter-XYZ" excuse-prose has accreted in the file. Also: 56 LOC of inline scaffolding at L1786-L1834 is preserved across iter-108 + iter-109 without being consumed by a closed proof — flag if it qualifies as a stale-scaffold red flag.
- General: surface any `-- TODO`, `-- DEFERRED`, `-- temporary`, `-- placeholder`, `-- iter-NNN`-style narrative comments that have become orphaned by source movement, and any excuse-comments concentrated in `Picard/Functor.lean` (off-limits `representable`) and `Modules/Monoidal.lean` (off-limits `instIsMonoidal_W`).

## Known issues
- Iter-107 lean-auditor flagged 4 carry-over critical findings (LineBundle wrong-def, Picard.Functor representable downstream, stale status header in Differentials.lean, instIsMonoidal_W deferral concentration). Re-report only if status has *changed*; otherwise note "carry-over unchanged" in one line.
- `BasicOpenCech.lean:L1064-L1119` is intentionally PAUSED partial-proof scaffold (iter-105/107) — flag only if it has visibly drifted from prior iters, not for being long.
- `BasicOpenCech.lean:L1786-L1834` (Steps 1a-1c inline scaffolding for the L1846 `h_loc_exact`) is intentionally preserved as inert infrastructure attached to the iter-108 budget-deferred L1846 `sorry`. Flag only if the scaffolding has un-noted contradictions, references to non-existent Mathlib names, or contradicts its own annotation comments.

## Absolute paths
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/
