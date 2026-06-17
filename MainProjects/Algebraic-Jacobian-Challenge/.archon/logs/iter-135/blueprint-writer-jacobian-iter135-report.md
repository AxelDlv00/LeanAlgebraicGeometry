# Blueprint Writer Report

## Slug
jacobian-iter135

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

- **Added subsection** `\subsection{The positive-genus arm of the witness existence}` with `\label{sec:positiveGenusWitness}`, placed immediately after the existing `\subsection{The genus-$0$ arm of the witness existence}` block — Change A.
  - Opens with a short paragraph framing the positive-genus arm as parallel to the genus-$0$ arm and cross-referencing the two Mathlib-prerequisite routes (Route A / Route B) of `\cref{thm:nonempty_jacobianWitness}`.

- **Added theorem block** `\begin{theorem}[Positive-genus Albanese witness]` with `\label{def:positiveGenusWitness}`, `\lean{AlgebraicGeometry.positiveGenusWitness}`, `\uses{def:JacobianWitness, def:genus, def:IsAlbanese}`, `\notready` — captures the informal statement: a $\mathtt{JacobianWitness}\,C$ exists in positive genus, with $J$ the Albanese variety of $C$ (Picard identity component or Stein factorisation of Abel–Jacobi on $\mathrm{Sym}^g(C)$), full witness data supplied by Route A or Route B.

- **Added proof sketch** for `def:positiveGenusWitness` (no `\leanok`, as the Lean body is `sorry`):
  - Bullets the two routes and points to the four-step / three-step decomposition already documented under `thm:nonempty_jacobianWitness`.
  - Records the iter-123 M3 route-audit midpoint LOC estimates (~6500 LOC Route A; ~9000 LOC Route B) with a citation of `analogies/m3-route-audit.md`.
  - Records iter-134 scaffold landing + OFF-CRITICAL-PATH M3 status per STRATEGY.md § M3 (user-escalation-pending) and quotes the iter-126 user hint endorsing the M3 work.
  - States that the scaffold is load-bearing iter-135 onward for the genus-stratified body restructure of `thm:nonempty_jacobianWitness`: `by_cases h : genus C = 0` delegating via `Nat.pos_of_ne_zero` on the `¬(genus C = 0)` arm.

- **Revised** item $(\gamma)$ closing sentence (formerly at line 372) — Change B. Replaced the old sentence with the new one citing `\cref{def:genusZeroWitness}` and the new `\cref{def:positiveGenusWitness}` explicitly, plus the iter-135 body restructure of `\cref{thm:nonempty_jacobianWitness}` as a `by_cases h : genus C = 0` case-split delegating to the two scaffolds, converting the formerly inline `sorry` into honest delegation.

- **Revised** body-closure paragraph of `def:genusZeroWitness` proof (formerly at line 410, now line 412) — Change C. De-pinned the line citation: replaced `\texttt{AlgebraicJacobian/Jacobian.lean:174}--\texttt{178}` with `in \texttt{AlgebraicJacobian/Jacobian.lean}` to prevent drift across iter-135 refactor and future restructures.

- **Revised** `thm:nonempty_jacobianWitness` proof block — Change D. Added `\paragraph{Iter-135 body restructure.}` immediately before `\end{proof}` recording the new case-split decomposition: delegation to `\cref{def:genusZeroWitness}` and `\cref{def:positiveGenusWitness}`, with the witness existence conditionally established whenever both arms' bodies close.

## Cross-references introduced

- `\cref{def:positiveGenusWitness}` — referenced in:
  - the revised item $(\gamma)$ closing sentence (Change B);
  - the new `\paragraph{Iter-135 body restructure.}` of the `thm:nonempty_jacobianWitness` proof (Change D);
  - the new positive-genus subsection's framing paragraph (Change A, indirectly via "genus-$0$ arm `\cref{def:genusZeroWitness}` vs. positive-genus arm").
  - **Defined** in the new theorem block of Change A, so the target exists.

- `\uses{def:JacobianWitness, def:genus, def:IsAlbanese}` in the new theorem block:
  - `def:JacobianWitness` exists in this chapter (line 203).
  - `def:genus` exists in the Genus chapter.
  - `def:IsAlbanese` exists in this chapter (line 27).

- `\uses{def:JacobianWitness, def:genus, def:IsAlbanese, thm:nonempty_jacobianWitness}` in the new proof block: all four labels exist (the first three as above; `thm:nonempty_jacobianWitness` exists in this chapter at line 241).

- `\cref{thm:nonempty_jacobianWitness}` (Route A / Route B references inside the new proof block) — exists in this chapter at line 241.

- `\cref{def:genusZeroWitness}` (in the framing paragraph of Change A and in Change D's paragraph) — exists in this chapter at line 386.

## Macros needed (if any)

None. The new content uses only macros already defined in the chapter (`\Spec`, `\Pic`, `\Sym`, `\genus`, `\Jac`, `\mathtt{...}`, etc.) and standard LaTeX environments.

## Reference-retriever dispatches (if any)

None — the directive named two existing project artefacts (`analogies/m3-route-audit.md`, `.archon/task_results/blueprint-reviewer-iter135.md`) plus the Lean declaration `AlgebraicGeometry.positiveGenusWitness` at `AlgebraicJacobian/Jacobian.lean:211-215`. No external source was needed.

## Notes for Plan Agent

- **Line citation `:120}--\texttt{126`** at line 400 (inside the `def:genusZeroWitness` proof's "Group-object structure, properness, smoothness, geometric irreducibility" paragraph) still points to specific line numbers for `geometricallyIrreducible_id_Spec`. The directive only asked to de-pin the citation on line 410 (Change C), but this sibling citation will drift the same way after future refactors. Consider de-pinning it in a future blueprint-writer pass.

- **No `\leanok` markers were added** anywhere by this writer (per the descriptor's rules). The `sync_leanok` phase will handle them.

- The new positive-genus subsection deliberately mirrors the genus-$0$ subsection's prose shape (framing paragraph + theorem + proof). This keeps the chapter symmetric in how the two arms of `thm:nonempty_jacobianWitness` are documented and should make blueprint-reviewer's iter-136 check easy.

- The proof block for `def:positiveGenusWitness` carries a `\uses{... thm:nonempty_jacobianWitness}` (because the proof body cites Route A / Route B of that theorem for the four-step / three-step decomposition). This creates a forward use of `thm:nonempty_jacobianWitness` from a block (`def:positiveGenusWitness`) that itself participates in the iter-135 body restructure of `thm:nonempty_jacobianWitness`. The dependency graph remains acyclic because `\uses` here is a content-citation pointer (proof-sketch text), not a Lean-level dependency: the Lean body of `nonempty_jacobianWitness` invokes `positiveGenusWitness`, not the other way around. If `leanblueprint`'s graph-cycle check flags this, the appropriate fix is to drop `thm:nonempty_jacobianWitness` from the `\uses` set of the new proof block (the cross-references inside the prose still survive via `\cref`).

## Strategy-modifying findings

None. The writer's edits track the iter-135 plan-agent decision precisely; no strategy-level issue was surfaced.
