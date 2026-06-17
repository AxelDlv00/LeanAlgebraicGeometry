# Blueprint Writer Report

## Slug
rigiditykbar-uses-cleanup-iter132

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

All four directive items applied as narrow surgical edits, with no
prose touched outside the four indicated spots.

- **Revised** `\uses{}` on statement of `lem:GrpObj_lieAlgebra_finrank`
  (line 190) — changed
  `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge}` to
  `\uses{lem:GrpObj_cotangentSpace, thm:smooth_locally_free_omega}`.
  Rationale: under Replacement (B) live closure, the rank-lemma
  statement depends on `thm:smooth_locally_free_omega` (consumed in
  Step 1 to extract `hfree`/`hrank`), NOT on the bridge (now
  vestigial-on-live-path per the iter-131 strategy-critic Q4 footer).

- **Revised** `\uses{}` on proof of `lem:GrpObj_lieAlgebra_finrank`
  (line 202) — changed
  `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge, thm:smooth_locally_free_omega}`
  to `\uses{lem:GrpObj_cotangentSpace, thm:smooth_locally_free_omega}`.
  Adopted the reviewer's recommended cleaner option (drop the bridge;
  it appears in Step 3 only as a deferred alternative, not as a live
  dependency).

- **Revised** the historical-narration sentence in the "Iter-128 /
  iter-129 prover lane re-scoping" paragraph (line 88) — replaced the
  stale "The bridge and rank lemmas are deferred to iter-130+." with
  the directive's two-clause sentence that (a) marks the bridge as
  vestigial-on-live-path under Replacement (B) and deferred
  indefinitely, and (b) identifies the rank lemma as the iter-132
  prover-lane target with its Step 1 + Step 2 closure path (chart-side
  Kähler rank from `thm:smooth_locally_free_omega`'s existential +
  base-change via `Module.finrank_baseChange`). All cross-references
  use `\cref{...}` and `\texttt{...}` per chapter conventions.

- **Revised** `rem:piece_i_first_target` (lines 296–300) — dropped
  `lem:GrpObj_cotangent_bridge` from the `\uses{}` block (line 298,
  now `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_lieAlgebra_finrank}`),
  and rewrote the remark body (line 299) to reflect the iter-131 Q4
  trio→duo collapse. The remark now says sub-step (i.a) is the
  definition + rank-lemma duo (closed iter-128 → iter-132 over a
  5-iter span; pointer to STRATEGY.md § Sequencing for the cost
  trace), notes the Q4 collapse demoted the bridge to a deferred
  alternative (pointer to rank-lemma proof Step 3 + footer), and
  schedules sub-steps (i.b)/(i.c) for iter-133+ / iter-137+
  respectively.

## Cross-references introduced
- `\cref{thm:smooth_locally_free_omega}` newly appears in the
  `\uses{}` block at line 190 (statement of
  `lem:GrpObj_lieAlgebra_finrank`); this label is the project's
  forward-Jacobian-criterion theorem (`thm:smooth_locally_free_omega`
  in `Differentials.tex`), already pre-existing and consumed
  elsewhere in this chapter (e.g.\ line 202's `\uses{}`, line 115's
  body of `lem:GrpObj_cotangentSpace`). No new label introduced.
- `\cref{lem:GrpObj_cotangent_bridge}` and
  `\cref{lem:GrpObj_lieAlgebra_finrank}` newly appear inline in the
  line-88 paragraph; both labels are defined later in the same
  chapter (lines 124 and 180–182 respectively), so the forward
  references are well-formed.
- `\cref{thm:smooth_locally_free_omega}` newly appears inline in the
  line-88 paragraph; same pre-existing label, well-formed.
- No `\uses{}` entries added that point at non-existent labels.

## Macros needed (if any)
None. All `\texttt{...}`, `\cref{...}`, `\Spec`, `\finrank`, `\Over`,
`\genus`, `\thm{...}`, `\mathfrak`, etc. macros are pre-existing in
the chapter and were already used by the spots I touched.

## Reference-retriever dispatches (if any)
None. The four edits are pure structural/narration cleanup; no fresh
source material was needed.

## Notes for Plan Agent

- **LaTeX validity check**: The chapter still balances
  `\begin{...}/\end{...}` pairs and braces in the four touched spots
  (verified by re-reading lines 85–95, 186–205, 295–305). No
  syntax-level concern.
- **Subsection header "Piece (i): sub-lemma decomposition for
  iter-128+ build"** (line 81): left untouched per directive (the
  iter-128+ tag is a soft mis-narration the reviewer flagged as
  informational, not must-fix). Flagged here for a possible future
  blueprint pass to retitle to e.g. "Piece (i): sub-lemma
  decomposition (iter-128 → iter-132 build)" once piece (i.a)
  closes.
- **`rem:piece_i_first_target`** (lines 296–300): the rewritten body
  now contains a forward pointer
  "(see rank-lemma proof Step 3 + footer at
  `\cref{lem:GrpObj_lieAlgebra_finrank}`)" — `\cref` to a
  `\begin{lemma}...\end{lemma}` block, not to a separate proof or
  footer label, but the chapter does not have a separate `\label`
  inside the proof. This is the same referencing style used elsewhere
  in the chapter (e.g.\ line 121's "see § Q4 collapse footer at the
  rank-lemma proof's end" without a label), so consistent. If a
  finer-grained label is desired in a future iter (e.g.\ a `\label`
  inside the rank lemma's proof Step 3), it can be added then; not
  required for the iter-133 reviewer flip.

## Strategy-modifying findings

None. The edits are pure follow-up cleanup to absorb the iter-132
substantive writer's residual items; the underlying Replacement (B)
trio→duo strategy was already decided iter-131 and is correctly
reflected by these edits.
