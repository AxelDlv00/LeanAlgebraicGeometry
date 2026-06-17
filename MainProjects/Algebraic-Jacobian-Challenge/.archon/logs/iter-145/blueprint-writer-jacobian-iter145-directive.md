# Blueprint-writer directive — Jacobian.tex, iter-145

## Iteration

145

## Slug

jacobian-iter145

## Target chapter

`blueprint/src/chapters/Jacobian.tex` (452 LOC currently).

## Strategic context

Iter-144 user-hint COMMITTED M3 to Route A — Picard scheme via FGA — and DROPPED Route B (Symⁿ + Stein) to historical alternative only. The iter-144 writer-jacobian dispatch landed 4 edits (Route A header COMMITTED, Route B header HISTORICAL, iter-135 paragraph status refresh, preamble refresh). The iter-145 blueprint-reviewer surfaced 2 residual must-fix items + 1 soon item:

1. **L370–L377 (Mathlib infrastructure summary)** still lists Route B as one of three independent route-unlocking infrastructures (`(α)`/`(β)`/`(γ)`?), even though Routes A and B were re-disposed iter-144. The chapter is internally inconsistent on the route-disposition framing.
2. **L425 `def:positiveGenusWitness` theorem statement** ends with "supplied by the chosen construction (Route A or Route B per `\cref{thm:nonempty_jacobianWitness}`)". The proof body at L433–441 commits Route A only. Statement and body should agree.
3. **L414 `def:genusZeroWitness` body-closure status note** says "Earliest realistic body-closure iteration: iter-138+". Under the iter-144 chart-algebra pivot, the genus-0 arm body closure is now gated on chart-algebra piece (ii); iter-138+ is stale.

## Required edits

### Edit 1 (MUST-FIX, L370–L377 Mathlib infrastructure summary route-disposition reconciliation)

Read L370–L377 of `Jacobian.tex`. Reconcile the three-way summary so that:
- Items corresponding to Route A (Hilbert / Quot / identity-component / FGA representability) are listed as **the committed M3 infrastructure**.
- Items corresponding to Route B (symmetric powers / Stein factorisation) are either dropped from the summary entirely, OR annotated explicitly as "documented historical route not pursued, see `\cref{thm:nonempty_jacobianWitness}` Route B for context".
- The wording should match the rest of the chapter (L286–287, L420, L437) which already names Route A as COMMITTED and Route B as historical.

### Edit 2 (MUST-FIX, L425 `def:positiveGenusWitness` theorem statement)

Read L425. Replace "supplied by the chosen construction (Route A or Route B per `\cref{thm:nonempty_jacobianWitness}`)" with "supplied by the Route A construction (per `\cref{thm:nonempty_jacobianWitness}` Route A; Route B is documented as a historical alternative not pursued)". The statement now matches the body's Route A-only commitment at L433–441.

### Edit 3 (SOON, L414 `def:genusZeroWitness` body-closure iter estimate refresh)

Replace "iter-138+" with the chart-algebra-pivot-revised estimate. Under iter-144 chart-algebra pivot + iter-145 Wave 2 chart-algebra envelope, the trajectory is: iter-146+ chart-algebra piece (ii) sub-piece prover lane; iter-149+ M2.a body closure (`rigidity_over_kbar`); iter-151+ M2.b body closure (`genusZeroWitness`). So replace "iter-138+" with "**iter-151+ (under iter-144 chart-algebra pivot)**" or "iter-151+ revised iter-145". The companion paragraph should be cross-consistent.

## Boundaries

- Do NOT edit `STRATEGY.md` (planner's domain).
- Do NOT edit any `.lean` file.
- Do NOT add or remove `\leanok` markers (deterministic-sync territory).
- Do NOT add or remove `\mathlibok` markers (review-agent territory).
- Edit ONLY `Jacobian.tex`; do NOT touch other chapters.

## Output

Writer's report at `task_results/blueprint-writer-jacobian-iter145.md`.
