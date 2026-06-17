# Blueprint Reviewer Directive — iter-150

Audit the **whole** blueprint at `blueprint/src/chapters/*.tex` (do not scope-limit). Render the standard per-chapter checklist + HARD GATE verdict for each chapter currently feeding a live prover lane.

## Active prover lanes this iter

- `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean` → chapter `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition" (no dedicated chapter; pointer chapter `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` redirects to `RigidityKbar.tex`).
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` → chapter `RigidityKbar.tex` (same section).

## User-flagged rendering issues to verify

The user reports the following rendering failures in `Cohomology_MayerVietoris.tex` and similar issues in `RigidityKbar.tex`:

1. **Undefined macros used in prose** — `\HasCechToHModuleIso`, `\IsAffineHModuleVanishing`, `\HasAffineCechAcyclicCover`. They appear inline as `$\HasCechToHModuleIso$` etc. in `Cohomology_MayerVietoris.tex` but are NOT defined in `blueprint/src/macros/common.tex`. Confirm and recommend fix (add `\newcommand{...}` blocks).
2. **Invalid `\thm{...}` syntax** at `RigidityKbar.tex:10` — `\thm{thm:nonempty_jacobianWitness}` is not a valid LaTeX cross-reference macro. Should be `\cref{thm:nonempty_jacobianWitness}` or `\ref{...}`. Audit for other occurrences.
3. **`\Abelian` macro** used at `Genus.tex:65` (and possibly elsewhere). Confirm whether this is defined.
4. **`\app`, `\pr` macros** used in `RigidityKbar.tex` (lines 1549, 1552, 1562 and within `%`-comment blocks earlier). Confirm whether these need `\newcommand` definitions.
5. **Unknown `tikzcd` environment** — the user claims `tikzcd` doesn't render. The blueprint uses it at `Cohomology_MayerVietoris.tex:66–69` and elsewhere. Confirm whether KaTeX (used by leanblueprint web) supports tikzcd; if not, recommend image-based substitutes or remove the unrendered environments.
6. **`??` placeholder definitions** — search every chapter for unresolved `??` placeholders.

For each issue: report file:line, severity (must-fix-this-iter / soon / cosmetic), and the recommended fix.

## User-hint reference-integration directive

The user wants every definition and theorem to cite source material with content excerpts as `% NOTE:` comments preceding each block. Audit: which chapters have inadequate citation of source material? Don't list trivial / project-internal lemmas. Focus on the substantive mathematical declarations.

## What to deliver

Standard blueprint-reviewer output:

- Per-chapter `complete: <true|partial|false>`, `correct: <true|partial|false>`.
- Must-fix-this-iter findings (severity blocking iter-150 prover lanes).
- Soon-severity findings (iter-151+ writer work).
- HARD GATE verdict on the chapters backing the iter-150 prover lanes (`RigidityKbar.tex` + `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`).
- Citation-adequacy assessment per chapter (one short line; non-blocking).

Write report to `.archon/task_results/blueprint-reviewer-iter150.md`.
