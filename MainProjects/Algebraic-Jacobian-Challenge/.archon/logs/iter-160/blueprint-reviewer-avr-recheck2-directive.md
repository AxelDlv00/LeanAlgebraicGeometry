# Blueprint-reviewer directive — 2nd scoped fast-path re-review of AbelianVarietyRigidity.tex

## Context
Second same-iter fast-path re-review. The prior scoped review (slug `avr-recheck`) returned
`AbelianVarietyRigidity.tex` as `complete: true` / `correct: PARTIAL` with ONE must-fix: the chain's
`\uses` edges pointed backward (2-cycle `dense_open ⟷ saturated_open`) and `thm:rigidity_lemma` had
no `\uses` edge, so the headline still laundered (rendered fully-proven despite transitive `sorryAx`
via the chain's lone `sorry`, `rigidity_eqOn_saturated_open_to_affine`).

A blueprint-writer round (slug `avr-uses-fix`) then rebuilt the edges forward. The writer reports
the final edge set as:

| Node | Statement `\uses` | Proof `\uses` |
|---|---|---|
| `thm:rigidity_lemma` | — | `lem:rigidity_eqOn_dense_open` |
| `lem:rigidity_eqOn_dense_open` | — | `lem:rigidity_eqOn_saturated_open_to_affine` |
| `lem:rigidity_eqOn_saturated_open_to_affine` | — | — (leaf) |

claiming the 2-cycle is gone and the headline now transitively reaches the `sorry` leaf.

## What I need (verify the must-fix is CLOSED)
1. Confirm the `\uses` edges are now exactly as the table above: forward chain
   `rigidity_lemma → dense_open → saturated_open`, no backward edges, no 2-cycle.
2. Confirm `thm:rigidity_lemma`'s PROOF now carries `\uses{lem:rigidity_eqOn_dense_open}` so the
   headline no longer renders fully-proven (de-laundered).
3. Confirm the previously-confirmed-good content is intact: the new block
   `lem:rigidity_eqOn_saturated_open_to_affine` still has `\label` + `\lean{}`, signature still
   matches the Lean declaration, route-B proof prose intact, Stein still recorded as deliberately
   avoided; the decomposition remark still refreshed; citations clean.
4. Any NEW must-fix introduced by this round.

## Verdict needed
Does `AbelianVarietyRigidity.tex` now read `complete: true` AND `correct: true` with NO
must-fix-this-iter finding? This gates the `rigidity_eqOn_saturated_open_to_affine` prover lane on
`AlgebraicJacobian/AbelianVarietyRigidity.lean` THIS iter. Report the per-chapter checklist + a
one-line all-clear for the rest of the blueprint.
