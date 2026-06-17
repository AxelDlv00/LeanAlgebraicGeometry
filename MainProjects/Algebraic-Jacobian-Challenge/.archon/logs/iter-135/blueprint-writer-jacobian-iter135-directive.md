# Blueprint Writer Directive — `Jacobian.tex` iter-135 add `\lean{positiveGenusWitness}`

## Slug

jacobian-iter135

## Target chapter

`blueprint/src/chapters/Jacobian.tex`

## Strategy context

The chapter cleanly documents the four protected Jacobian theorems
(`grpObj`, `proper`, `smooth_genus`, `geomIrred`), the uniformly-over-$P$
witness bundle `JacobianWitness`, the three-route existence analysis
($\alpha$ Hilbert/Quot, $\beta$ symmetric powers / Stein, $\gamma$
rigidity-over-$k$ for the genus-$0$ arm), and the genus-$0$ arm
construction `def:genusZeroWitness`. The iter-127 over-k commitment is
threaded throughout.

Iter-134 landed a new Lean scaffold `AlgebraicGeometry.positiveGenusWitness`
at `AlgebraicJacobian/Jacobian.lean:211-215` (the positive-genus arm of
the genus-stratified body of `nonempty_jacobianWitness`). The blueprint
currently has zero references to this declaration; only a parenthetical
mention exists in an iter-134 NOTE comment at `RigidityKbar.tex:334`.

The iter-135 plan-agent decision is to:
1. Add a `\lean{positiveGenusWitness}` block to `Jacobian.tex` covering
   the new iter-134 scaffold.
2. (In parallel, via the iter-135 refactor lane) restructure
   `nonempty_jacobianWitness`'s body to use `by_cases h : genus C = 0`,
   delegating to `genusZeroWitness` (genus-$0$ arm) and
   `positiveGenusWitness` (positive-genus arm). This restructure
   converts the inline `sorry` on `nonempty_jacobianWitness` into honest
   delegation to the two scaffolds.

Your job is item 1: add the missing blueprint block, and reflect the
iter-135 body restructure in the chapter's prose where appropriate.

## Required content / changes

### Change A — add a `\lean{AlgebraicGeometry.positiveGenusWitness}` block

ADD a new sub-section parallel to the existing
`\subsection{The genus-$0$ arm of the witness existence}`
(label `sec:genusZeroWitness`, lines ~378–411) immediately AFTER that
sub-section. Name it
`\subsection{The positive-genus arm of the witness existence}`
with label `\label{sec:positiveGenusWitness}`. Inside, ADD a
`\begin{theorem}[Positive-genus Albanese witness]` block with:

- `\label{def:positiveGenusWitness}`
- `\lean{AlgebraicGeometry.positiveGenusWitness}`
- `\uses{def:JacobianWitness, def:genus}` (and any others that fit the
  positive-genus arm's mathematical content — see below)
- `\notready` (the Lean body is `sorry`)
- The informal statement: "Let $C \in \mathrm{Over}\,(\Spec k)$ be a
  smooth proper geometrically irreducible curve over $k$ with
  $\genus(C) \ge 1$. Then there exists a $\mathtt{JacobianWitness}\,C$
  whose underlying scheme is the Albanese variety of $C$ (classically
  the identity component of the Picard scheme $\mathrm{Pic}^0_{C/k}$,
  or equivalently the Stein factorisation of the Abel--Jacobi morphism
  on $\mathrm{Sym}^g(C)$). The full $\mathtt{JacobianWitness}$ data
  (group-object structure, smoothness of relative dimension $g$,
  properness, geometric irreducibility, and Albanese universal
  property uniformly over $k$-rational marked points) is supplied by
  the chosen construction (Route A or Route B per
  \cref{sec:nonempty_jacobianWitness_routes})."

Then ADD a `\begin{proof}` block. Mark it as a proof sketch (NOT
`\leanok`) recording:

- This is the M3 arm of the witness existence; both Mathlib-prerequisite
  routes ($\alpha$ Hilbert/Quot for Route A; $\beta$ symmetric powers
  + Stein for Route B) require significant Mathlib infrastructure not
  currently available.
- Per the iter-123 M3 route audit (`analogies/m3-route-audit.md`),
  midpoint estimates are ~6500 LOC (Route A) and ~9000 LOC (Route B).
- Status: scaffold landed iter-134; body closure is M3 work, currently
  OFF-CRITICAL-PATH per STRATEGY.md § M3 (user-escalation-pending on
  the M3 prioritisation; iter-126 user hint endorsed "do the work, no
  axioms; ~6500–9000 LOC may not be that much for an AI").
- The scaffold is load-bearing iter-135 onward for the genus-stratified
  body restructure of `nonempty_jacobianWitness` (iter-135 refactor
  Change 2.1; the `by_cases h : genus C = 0` decomposition delegates
  to `positiveGenusWitness` on the `¬(genus C = 0)` arm via
  `Nat.pos_of_ne_zero`).

### Change B — update the prose at line 372 (item ($\gamma$))

Item ($\gamma$) (around line 372 of the chapter) currently ends with:

> "Independently of ($\alpha$) and ($\beta$), establishing ($\gamma$)
> lets the genus-$0$ part of the witness be discharged unconditionally;
> the higher-genus part of the witness then remains under ($\alpha$)
> or ($\beta$)."

UPDATE this sentence to reflect the iter-134 + iter-135 status:

> "Independently of ($\alpha$) and ($\beta$), establishing ($\gamma$)
> lets the genus-$0$ part of the witness be discharged unconditionally
> via \cref{def:genusZeroWitness}; the higher-genus part is packaged
> as \cref{def:positiveGenusWitness} (\texttt{AlgebraicGeometry.positiveGenusWitness},
> iter-134 scaffold) whose body closure remains gated on Route A
> ($\alpha$) or Route B ($\beta$). Per the iter-135 body restructure of
> \cref{thm:nonempty_jacobianWitness}, the witness existence is now a
> case-split $\mathtt{by\_cases}\ h : \genus\,C = 0$ delegating to
> \cref{def:genusZeroWitness} and \cref{def:positiveGenusWitness}
> respectively, converting the formerly inline \texttt{sorry} into
> honest delegation to the two named scaffolds."

### Change C — update the prose at line 388 (the `\begin{theorem}` for `genusZeroWitness`)

The existing block for `def:genusZeroWitness` (line 384) is fine; no
content changes needed. But the proof block at line 410 ("Body closure
status") cites `AlgebraicJacobian/Jacobian.lean:174--178` — the actual
line numbers post-iter-127 are ~188–192 (per the iter-134 lean-auditor
spot check) and will shift again after the iter-135 refactor
Change 2.4. **De-pin the line citation**: replace
`\texttt{AlgebraicJacobian/Jacobian.lean:174}--\texttt{178}` with
just `\texttt{AlgebraicJacobian/Jacobian.lean}` (or
`the Lean body of \texttt{AlgebraicGeometry.genusZeroWitness}`) to
prevent future drift.

### Change D — update the prose around `thm:nonempty_jacobianWitness`

The `\begin{theorem}` block for `thm:nonempty_jacobianWitness` and its
`\begin{proof}` (probably around lines 350–376, before the
sub-sections) should reflect the iter-135 body restructure. ADD a
paragraph at the end of the proof block (just before `\end{proof}`)
or a short prose insertion:

> "\paragraph{Iter-135 body restructure.} The Lean body of
> \texttt{thm:nonempty\_jacobianWitness} is, per iter-135 refactor, a
> case-split $\mathtt{by\_cases}\ h : \genus\,C = 0$ delegating to
> \cref{def:genusZeroWitness} (genus-$0$ arm, \texttt{sorry} body
> closing iter-138+) and \cref{def:positiveGenusWitness} (positive-genus
> arm, \texttt{sorry} body closing M3 — currently off-critical-path).
> The restructure converts the inline \texttt{sorry} on the witness-
> existence theorem itself into honest delegation to two named scaffolds;
> the witness existence is therefore conditionally established whenever
> both arms' bodies close (no Mathlib gap directly on the witness-
> existence theorem itself, only on each arm)."

(Find the exact insertion point — search for the `\end{proof}` of the
`thm:nonempty_jacobianWitness` block; you may also paraphrase or
relocate this content if it fits better elsewhere in the section.)

## Out of scope

- Do NOT touch any `.lean` file. The body restructure is the iter-135
  refactor lane's job (in flight in parallel).
- Do NOT touch any other blueprint chapter.
- Do NOT touch the iter-127 over-k commitment text in the chapter
  (the chapter's section structure is fine as-is).
- Do NOT decide between Route A and Route B for the M3 body closure;
  the chapter already documents both as live routes with their cost
  estimates.
- Do NOT remove the existing `def:genusZeroWitness` block or its proof
  sketch (only the small Change C line-citation update).
- Do NOT add `\leanok` markers; `sync_leanok` handles them.

## References

- `analogies/m3-route-audit.md` — the iter-123 route audit naming
  Route A / Route B midpoint LOC estimates.
- `task_results/blueprint-reviewer-iter135.md` § "blueprint/src/chapters/Jacobian.tex"
  (the iter-135 blueprint-reviewer's finding for this chapter).
- The Lean declaration `AlgebraicGeometry.positiveGenusWitness` lives at
  `AlgebraicJacobian/Jacobian.lean:211-215` (do not cite the line in
  the blueprint; the declaration name is stable, the line will shift).

## Expected outcome

- New `\subsection{The positive-genus arm of the witness existence}`
  + new `\begin{theorem}` / `\begin{proof}` block for
  `def:positiveGenusWitness` / `\lean{AlgebraicGeometry.positiveGenusWitness}`.
- Updated prose at line 372 (item $\gamma$) reflecting the iter-135
  body restructure.
- Updated prose at the `thm:nonempty_jacobianWitness` block reflecting
  the iter-135 body restructure.
- Updated prose at line 410 (de-pin `genusZeroWitness` line citation).
- Chapter compiles via `leanblueprint` (sanity check that no `\ref{}`
  or `\cref{}` is broken after your edits).
- LOC delta: roughly +30 to +50 LOC for the new sub-section and prose
  updates.

Save your report to `.archon/task_results/blueprint-writer-jacobian-iter135.md`.
