# Blueprint Writer Directive

## Slug
rigiditykbar-uses-cleanup-iter132

## Target chapter
`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context

This is a follow-up narrow cleanup pass after the iter-132 substantive
writer (`blueprint-writer-rigiditykbar-piecei-realign-iter132`) re-aligned
§ Piece (i) prose against the iter-131 Lean body shape. The iter-132
blueprint-reviewer flagged 3 narrow residual items that the substantive
writer did not absorb — all of them are `\uses{}` cleanup or a single
historical-narration sentence update.

Per the iter-131 strategy-critic Q4 trio→duo collapse (documented in
STRATEGY.md and in the rank-lemma proof footer at line 240 of the
current `RigidityKbar.tex`), under Replacement (B) the live closure path
is the **duo** (definition + rank lemma) and the bridge lemma
`lem:GrpObj_cotangent_bridge` is **vestigial on the live path**. The
substantive writer aligned the proof body but the `\uses{}` blocks on
the rank lemma's statement + proof still list the bridge as a
dependency.

## Required content

Apply **exactly four** narrow edits to `blueprint/src/chapters/RigidityKbar.tex`:

1. **Line 190** (statement-level `\uses{}` of `lem:GrpObj_lieAlgebra_finrank`):
   Change `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge}`
   to `\uses{lem:GrpObj_cotangentSpace, thm:smooth_locally_free_omega}`.
   Rationale: under Replacement (B) live closure, the rank-lemma statement
   depends on `thm:smooth_locally_free_omega` (consumed in Step 1 of the
   proof to extract the chart's `hfree`/`hrank` witnesses), NOT on the
   bridge lemma (which is `\notready` and currently vestigial — see line
   240 footer).

2. **Line 202** (proof-level `\uses{}` of `lem:GrpObj_lieAlgebra_finrank`):
   Change `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge, thm:smooth_locally_free_omega}`
   to `\uses{lem:GrpObj_cotangentSpace, thm:smooth_locally_free_omega}`.
   Rationale: same as item 1 — Step 1 of the proof now uses
   `thm:smooth_locally_free_omega` directly; the bridge is referenced in
   Step 3 as a *deferred* alternative route, not a live dependency. (If
   you prefer to keep `lem:GrpObj_cotangent_bridge` in the `\uses{}` to
   reflect that Step 3 mentions it, that's also acceptable; but the
   reviewer's recommendation is to drop it because the bridge is on the
   deferred path. Pick the cleaner option.)

3. **Line 88** (paragraph "Iter-128 / iter-129 prover lane re-scoping"):
   The current sentence "The bridge and rank lemmas are deferred to
   iter-130+." is stale (we are at iter-132 and the rank lemma is the
   active iter-132 prover-lane target). Replace it with:
   "The bridge lemma `\cref{lem:GrpObj_cotangent_bridge}` is vestigial
   on the live path under Replacement (B) (see § Q4 collapse footer at
   the rank-lemma proof's end) and remains deferred indefinitely; the
   rank lemma `\cref{lem:GrpObj_lieAlgebra_finrank}` is the iter-132
   prover-lane target (closure path: Step 1 chart-side Kähler rank from
   `\cref{thm:smooth_locally_free_omega}`'s existential + Step 2
   base-change to `k` via `Module.finrank_baseChange`, both detailed in
   that lemma's proof body)."

4. **Lines 297–299** (`rem:piece_i_first_target`):
   Drop `lem:GrpObj_cotangent_bridge` from the `\uses{}` block on line
   298 (change to `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_lieAlgebra_finrank}`).
   Update the remark body at line 299 to reflect the iter-131 Q4 trio→duo
   collapse — rewrite the remark to say something like:
   "Sub-step (i.a) — `\cref{lem:GrpObj_cotangentSpace}` (the definition)
   plus the rank lemma `\cref{lem:GrpObj_lieAlgebra_finrank}` — is the
   natural first target for the iter-128+ prover lane (closed
   iter-128 → iter-132 over a 5-iter span; see STRATEGY.md § Sequencing
   piece (i.a) row for the empirical cost trace). Under Replacement (B)
   the iter-131 strategy-critic Q4 trio→duo collapse demoted the bridge
   lemma `\cref{lem:GrpObj_cotangent_bridge}` to a vestigial-on-live-path
   deferred alternative (see rank-lemma proof Step 3 + footer at line
   240). Sub-steps (i.b) and (i.c) are staged on top of (i.a) and are
   scheduled for iter-133+ / iter-137+ respectively."

## Out of scope

- Do NOT touch any other prose. The substantive writer
  `blueprint-writer-rigiditykbar-piecei-realign-iter132` already
  re-aligned the rank-lemma proof body, the bridge-proof Step 1, the
  iter-131 body-shape paragraph, etc. Your job is the 4 narrow items
  above only.
- Do NOT touch any other blueprint chapter.
- Do NOT touch `lem:GrpObj_mulRight_globalises` / `lem:GrpObj_omega_free`
  / `lem:GrpObj_omega_rank_eq_dim` (piece (i.b)/(i.c) `\notready` lemmas).
- Do NOT touch the subsection header on `\subsection{Piece (i):
  sub-lemma decomposition for iter-128+ build}` — the iter-128+ tag is
  a soft mis-narration (reviewer flagged as informational, not
  must-fix); leave it for a future iter.
- Do NOT add `\leanok` markers (deterministically managed by
  `sync_leanok`).
- Do NOT introduce new labels.

## References

- `analogies/cotangent-body-shape.md`: iter-131 mathlib-analogist verdict
  on the body shape.
- The iter-131 strategy-critic Q4 collapse is documented in STRATEGY.md
  § Mathlib gap inventory (entry for "Gap (group-scheme cotangent
  triviality)") and in the rank-lemma proof's own footer at line 240.

## Expected outcome

After this writer pass, `RigidityKbar.tex` is `correct: true` per the
HARD GATE rule: all four must-fix-this-iter items from the iter-132
blueprint-reviewer report are addressed. The chapter then reads
coherently on the live closure path (Replacement (B), duo: definition
+ rank lemma), with the bridge lemma documented as a deferred
alternative consistently across the `\uses{}` blocks, the line 88
paragraph, and the `rem:piece_i_first_target` remark. The iter-133
mandatory blueprint-reviewer will flip the chapter to `correct: true`.
