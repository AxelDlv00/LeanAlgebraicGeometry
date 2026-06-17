# Blueprint Writer Directive

## Slug
orphan-chapters-iter129

## Chapters (4 total)

`blueprint/src/chapters/Modules_Monoidal.tex`
`blueprint/src/chapters/Picard_LineBundle.tex`
`blueprint/src/chapters/Picard_Functor.tex`
`blueprint/src/chapters/Picard_FunctorAb.tex`

## Strategy context

These 4 chapters document a strategic route the project retired in iter-126/127:

- **Pre-iter-126**: the project planned to build the M3 (positive-genus) witness via the Picard scheme `Pic` + LineBundle infrastructure + Modules monoidal structure (Route A of M3 per STRATEGY.md). The corresponding Lean files lived under `AlgebraicJacobian/Modules/Monoidal.lean` and `AlgebraicJacobian/Picard/{LineBundle,Functor,FunctorAb}.lean`.

- **Iter-126/127**: under the user-hint absorption ("do the work, no axioms") and the over-k commitment, the project pivoted to a *direct* Albanese-witness route via `JacobianWitness`, `rigidity_over_kbar`, and the shared cotangent-vanishing pile. The Lean files under `Modules/` and `Picard/` were excised (verified by the iter-129 blueprint-reviewer: those files do not exist in the current Lean tree).

- **Iter-129**: the four chapters above remain in `blueprint/src/chapters/` but reference excised Lean files via `\lean{...}` hints. The blueprint-reviewer flagged these as MUST-FIX-this-iter orphans because the stale `\lean{...}` hints and `\leanok` markers pollute the dependency graph and `sync_leanok` output.

## Decision

**Delete all four chapters.**

Rationale (per blueprint-reviewer's recommendation): option (a) deletion is the cleaner long-term solution over option (b) "strip Lean refs and mark as historical". The pre-iter-126 narrative is documented in git history (commits up to and including iter-125); future readers wanting the historical arc can read those commits. Keeping orphan chapters as "historical" prose adds maintenance burden (every future blueprint-reviewer dispatch will flag the orphan-chapter cluster) without serving any downstream consumer.

The STRATEGY.md "M3" section already documents Route A as a multi-month route off the iter-by-iter critical path; the prose there is sufficient for the historical record.

## What to do

1. **Delete the four chapter files** from `blueprint/src/chapters/`:
   - `Modules_Monoidal.tex`
   - `Picard_LineBundle.tex`
   - `Picard_Functor.tex`
   - `Picard_FunctorAb.tex`

2. **Update `blueprint/src/content.tex`** to remove the corresponding `\input{chapters/<slug>.tex}` lines. There should be 4 such lines.

3. **Verify the dependency graph still resolves** under `leanblueprint` (no other chapter references labels from the deleted chapters). Use `grep` on `blueprint/src/chapters/*.tex` for any `\cref{thm:Pic_*}`, `\cref{def:LineBundle}`, `\cref{lem:Modules_*}`, `\uses{...Picard...}`, etc. — fix or remove any dangling references in retained chapters.

4. **Do NOT delete macros** in `blueprint/src/macros/common.tex` even if some are now unused. Macro cleanup is low-priority and out of scope.

## Constraints

- Do NOT touch any retained chapter beyond removing dangling cross-references (and only if `grep` finds them).
- Do NOT touch `\leanok` markers in retained chapters.
- Do NOT modify `STRATEGY.md` or `PROGRESS.md`.
- Do NOT touch `archon-protected.yaml`.

## Output (in your task_results report)

- List of deleted files (with size in lines, for the record).
- Diff of `blueprint/src/content.tex` (the 4 removed `\input{...}` lines).
- List of dangling `\cref{...}` / `\uses{...}` references discovered in retained chapters and the fixes you applied (if any).
- Confirmation that `leanblueprint` (or at minimum `grep`-based consistency) leaves no broken references.

## Validation

If you can run `leanblueprint checkdecls`, do so. Expect zero broken Lean references after the deletion. If you cannot run it, use `grep` to verify no retained chapter references any label/Lean target from the deleted chapters.
