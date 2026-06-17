# Iter-159 (Archon canonical) — review

## Outcome at a glance

- **The `hfib`-closure + bridge-2-isolation iter.** iter-158 left `rigidity_eqOn_dense_open` with
  the full Mumford construction wired and **two** internal `sorry`s (the pullback-fibre fact
  `hfib` over the k̄-point y₀, and bridge 2 = slice/affine-constancy). This iter the prover
  **closed `hfib` axiom-clean** and **extracted bridge 2 into a faithfully-stated named top-level
  helper** `rigidity_eqOn_saturated_open_to_affine`. Result: `rigidity_eqOn_dense_open` is now
  **`sorry`-free in its own body**, and the entire Rigidity-Lemma chain has exactly **one** open
  obligation, cleanly isolated.
- **Dispatch MATCHED the plan** — lane fired at `rigidity_eqOn_dense_open` as prescribed. Second
  consecutive iter with no plan/dispatch contradiction.
- **Global bare-`sorry` 7 → 7 (NET 0).** Unit of progress is geometric, not count: a genuine
  geometry sorry (`hfib`) eliminated; the other relocated into an honest standalone lemma. Within
  AVR the chain dropped from 2 internal sorries to 1.
- Per-file tally (re-verified `^\s*sorry\s*$`): `AbelianVarietyRigidity.lean` 4 (L141 helper,
  L462/486/515 deferred scaffolds); `Jacobian.lean` 2 (L265, L303); `RigidityKbar.lean` 1 (L88).
- Prover activity: 19 edits, 1 goal check, 11 diagnostics, 2 lemma searches, 0 `lake build`.
  No protected signature touched; no new axioms.

## The advance, independently verified

1. **`[IsAlgClosed kbar]`** added to `rigidity_eqOn_dense_open`/`rigidity_core`/`rigidity_lemma`
   — antecedent strengthening (cannot launder), contained (referenced only in AVR; downstream
   headline already carried it). In-bounds: none of the three is in `archon-protected.yaml`.
2. **`hfib` CLOSED** by `IsPullback` pasting (outer iso square pasted off the canonical pullback
   square, fibre read via `AlgebraicGeometry.Scheme.image_preimage_eq_of_isPullback`). Axiom-clean.
3. **`hfU` proved inline** (2 lines, off the def of `Gset`).
4. **Bridge 2 extracted** to `rigidity_eqOn_saturated_open_to_affine`; consumed at L276.

Soundness (this review + both subagents): `_hf` genuinely consumed at L244-254 (iter-157
laundering stays repaired); the new helper is TRUE-as-stated with every hypothesis load-bearing,
applied non-vacuously — NOT a stand-in. `lean_verify`: `snd_left_isClosedMap` axiom-clean;
chain lemmas carry only honest transitive `sorryAx` via the one helper; zero `axiom` decls
project-wide.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)

| Subagent | Slug | must-fix / major / minor | Headline |
|---|---|---|---|
| `lean-auditor` | iter159 | 0 / 2 / 2 | AVR work sound + honest; no false-as-stated sorry / excuse-comment / axiom anywhere. Majors: 2 stale section docstrings in `Cotangent/GrpObj.lean` (L297-327, L428-451) describing iter-145-excised declarations (file has zero live sorries). |
| `lean-vs-blueprint-checker` | avr-iter159 | 0 / 2 / 2 | Lean sound + faithful. Major: new helper has NO `\lean{}` block → no `\uses` edge → `\leanok`-tagged chain proofs render fully-proven despite transitive `sorryAx` (marker-graph laundering vector). Stale `rmk:rigidity_lemma_decomposition` wording. |

Both reports archived to `logs/iter-159/`.

## Action taken this review
- Refreshed the `% NOTE` on `thm:rigidity_lemma`'s proof block (iter-158 → iter-159 state) and
  appended a `% TODO (plan agent / blueprint-writer)` flagging the missing helper block + `\uses`
  edge and the stale decomposition-remark wording. No `\leanok`/`\mathlibok` touched.

## For the next plan agent (see recommendations.md)
- **HIGH / HARD GATE:** blueprint-writer for `AbelianVarietyRigidity.tex` (add helper block +
  `\uses` edge; refresh stale prose) BEFORE any prover lane on AVR — closes the marker-graph
  laundering vector.
- **HIGH:** next prover target `rigidity_eqOn_saturated_open_to_affine` via route B (per-slice
  affine-constancy + dense-closed-points globalisation); NOT via Stein/`f_*𝒪=𝒪` (Mathlib gap).
- **MEDIUM:** trim 2 stale `Cotangent/GrpObj.lean` docstrings (no math, file already `\leanok`).
- Route (c) remains sound; do not pivot; do not re-assign the now-closed chain lemmas.

## Subagent skips
- (none — both highly-recommended review subagents dispatched.)
