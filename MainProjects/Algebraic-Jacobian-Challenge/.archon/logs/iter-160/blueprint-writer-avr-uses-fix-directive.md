# Blueprint-writer directive — AbelianVarietyRigidity.tex: fix `\uses` edge directions (de-launder)

## Chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (the ONLY file you edit).

## Why
A scoped blueprint-review found that the chain's `\uses` edges point the WRONG direction, creating
a dependency 2-cycle and leaving `thm:rigidity_lemma` with NO `\uses` edge at all — so the headline
Rigidity Lemma still renders fully-proven (`\leanok`) even though its Lean body transitively depends
on the chain's lone `sorry` (`rigidity_eqOn_saturated_open_to_affine`). The true Lean dependency
order is forward:

```
rigidity_lemma  →  rigidity_eqOn_dense_open  →  rigidity_eqOn_saturated_open_to_affine (sorry leaf)
```

The blueprint `\uses` edges must mirror this forward order so the not-proven status of the `sorry`
leaf propagates up to both `lem:rigidity_eqOn_dense_open` AND `thm:rigidity_lemma`.

## The fix (exactly these four edits — nothing else)

### Edit A — add the missing forward edge on `thm:rigidity_lemma`'s PROOF
In the `\begin{proof}` block of `thm:rigidity_lemma` (starts at line 84; it currently has `\leanok`
and a `% NOTE` comment but NO `\uses`), add:
```
\uses{lem:rigidity_eqOn_dense_open}
```
Place it adjacent to the `\leanok` near the top of that proof block. This makes the headline depend
(in the graph) on the dense-open lemma, which in turn depends on the `sorry` leaf — de-laundering
the headline.

### Edit B — drop the backward statement edge on `lem:rigidity_eqOn_dense_open`
In the `\begin{lemma}` block of `lem:rigidity_eqOn_dense_open` (around line 180), the STATEMENT
currently carries `\uses{thm:rigidity_lemma}`. This is the wrong direction (a sub-lemma does not
depend on the headline it helps prove) and is half of the 2-cycle. **Remove this `\uses` line**
from the statement. (Do NOT touch this lemma's PROOF `\uses` — see Edit D.)

### Edit C — make `lem:rigidity_eqOn_saturated_open_to_affine` a leaf
In the new block `lem:rigidity_eqOn_saturated_open_to_affine` (around lines 307–337), it currently
has a `\uses{lem:rigidity_eqOn_dense_open}` edge (it may appear on the statement and/or in its
proof). This is backward (the bottom helper does not depend on its parent) and is the other half of
the 2-cycle. **Remove every `\uses{lem:rigidity_eqOn_dense_open}` from this block** (both statement
and proof if present), leaving it as a leaf with no downward `\uses`. (It may keep any `\uses` to
genuine upstream prerequisites if such exist — but it must NOT point back at `dense_open`.)

### Edit D — confirm/keep the forward proof edge on `lem:rigidity_eqOn_dense_open`
In the `\begin{proof}` of `lem:rigidity_eqOn_dense_open` (around line 238), the proof `\uses`
should list `lem:rigidity_eqOn_saturated_open_to_affine` (this was added last round and is the
CORRECT forward edge). Keep it. If it currently also lists `thm:rigidity_lemma` there, drop the
`thm:rigidity_lemma` token from the proof `\uses` (the dense-open proof does not use the headline);
the proof `\uses` should be exactly `\uses{lem:rigidity_eqOn_saturated_open_to_affine}`.

### Edit E (informational cleanup) — refresh the half-stale TODO comment
The `% TODO (plan agent / blueprint-writer)` comment (around lines 101–107) still asserts BOTH
`thm:rigidity_lemma` and `lem:rigidity_eqOn_dense_open` launder. After Edits A–D this is resolved.
Update the comment to a `% NOTE (iter-160):` recording that the forward `\uses` chain
(`rigidity_lemma → dense_open → saturated_open`) now de-launders both upstream nodes, and the lone
`sorry` is the leaf `rigidity_eqOn_saturated_open_to_affine`. (This is a `%`-comment; no graph
impact — just keep the prose honest.)

## Net result the graph must show
- `thm:rigidity_lemma` proof `\uses{lem:rigidity_eqOn_dense_open}`
- `lem:rigidity_eqOn_dense_open` statement: NO `\uses`; proof `\uses{lem:rigidity_eqOn_saturated_open_to_affine}`
- `lem:rigidity_eqOn_saturated_open_to_affine`: leaf, no `\uses` back to `dense_open`
- No 2-cycle anywhere in the chain.

## Out of scope
- Do NOT add or remove any `\leanok` / `\mathlibok` marker. Markers are owned by the deterministic
  `sync_leanok` phase and the review agent.
- Do NOT change any statement or proof PROSE (other than the TODO-comment refresh, Edit E).
- Do NOT touch the cube section or the deferred-scaffold blocks.
- Do NOT edit any other chapter.

## Verification
Report the final `\uses` edge set of all three chain nodes (statement vs proof) so the directionality
is auditable, and confirm no node `\uses` a node downstream of it (no cycle).
