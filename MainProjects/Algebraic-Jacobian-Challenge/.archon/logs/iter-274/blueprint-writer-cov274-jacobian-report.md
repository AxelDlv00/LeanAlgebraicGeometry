# Blueprint Writer Report

## Slug
cov274-jacobian

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made
- **Added definition** `\begin{definition}` / `\label{def:jacobianWitness}` / `\lean{AlgebraicGeometry.jacobianWitness}` — the chosen Albanese witness for `C`, extracted from `nonempty_jacobianWitness` via `Classical.choice`; its fields define `Jac(C)` and the four protected instances. Placed in a new subsection "The chosen Albanese witness", immediately after the `thm:nonempty_jacobianWitness` proof (forward dependency order). Statement-level `\uses{def:JacobianWitness, thm:nonempty_jacobianWitness}` (it depends on both). `\begin{proof}` body: "Proved directly in Lean."
- **Added lemma** `\begin{lemma}` / `\label{lem:geometricallyIrreducible_id_Spec}` / `\lean{AlgebraicGeometry.geometricallyIrreducible_id_Spec}` — for a field `k`, the identity `id_{Spec k}` is geometrically irreducible (every geometric fibre is irreducible). Placed immediately before `def:genusZeroWitness`, its consumer. `\begin{proof}` body: "Proved directly in Lean." plus a one-line faithful note (geometric fibre's second projection is an iso; transport irreducibility) matching the actual Lean proof.
- **Hoisted `\uses{}`** into `def:genusZeroWitness` (its consumer, per WIRING) — added `lem:geometricallyIrreducible_id_Spec` to the existing statement-level `\uses{}`. This is the mathematically real edge: the genus-0 witness's geometric-irreducibility field is supplied by this helper (already named in the genusZeroWitness prose at the trivial-witness step).

Both new blocks are additive. No external source exists for these internal helpers, so per directive NO `% SOURCE` / `% SOURCE QUOTE` / `\textit{Source}` citation blocks were added. No `\leanok` added (owned by sync_leanok). No protected block edited (`def:Jacobian` and the four `Jacobian.inst*` blocks untouched; jacobianWitness wires only to the already-covered `nonempty_jacobianWitness`, not by editing the protected consumers).

## Cross-references introduced
- `def:jacobianWitness` `\uses{def:JacobianWitness, thm:nonempty_jacobianWitness}` — both exist in this chapter (lines for JacobianWitness and nonempty_jacobianWitness). Verified matched in DAG.
- `lem:geometricallyIrreducible_id_Spec` — incoming edge from `def:genusZeroWitness` (verified present in `.leandag/dag.json`); its own outgoing `\uses{}` is empty (it is a leaf helper depending on nothing covered), which is correct — the incoming edge prevents isolation.

## Verification (leandag)
- `leandag build --json`: `unknown_uses` count = 0; neither new `\lean{}` pin appears in `unmatched_lean`.
- Both nodes present in `.leandag/dag.json` matched to exact Lean names:
  - `def:jacobianWitness` → `AlgebraicGeometry.jacobianWitness`
  - `lem:geometricallyIrreducible_id_Spec` → `AlgebraicGeometry.geometricallyIrreducible_id_Spec`
- `leandag query --isolated --chapter Jacobian`: 0 results (neither new block is isolated).
- LaTeX environment balance in chapter: proof 10/10, lemma 3/3, definition 5/5, theorem 9/9.
- Uncovered lean-aux count for `AlgebraicJacobian/Jacobian.lean` now zero (both previously-unpinned helpers now carry `\lean{}`-pinned blocks).

## References consulted
None — both declarations are internal project helpers with no external mathematical source (directive instructed to omit all citation blocks). Statements were read directly from the Lean signatures and docstrings in `AlgebraicJacobian/Jacobian.lean` (`geometricallyIrreducible_id_Spec` line 134; `jacobianWitness` line 310).

## Macros needed (if any)
None. Only existing macros (`\Spec`, `\Jac`, `\genus`, `\cref`) used.

## Notes for Plan Agent
- `def:jacobianWitness` is consumed in Lean by the protected `def:Jacobian` and the four protected `Jacobian.inst*` blocks. Those protected blocks were not edited (directive forbids), so the new node carries only its outgoing edges to `def:JacobianWitness`/`thm:nonempty_jacobianWitness` and no incoming edge from its protected consumers. It is non-isolated regardless. If a future (non-protected) pass wants the edge to render, `def:Jacobian`'s `\uses{}` could add `def:jacobianWitness`, but that requires touching a protected block.

## Strategy-modifying findings
None.
