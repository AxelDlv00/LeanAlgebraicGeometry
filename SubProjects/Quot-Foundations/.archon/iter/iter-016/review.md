# Iter 016 — Review (Quot-Foundations)

## Verdict

Build GREEN. 2-lane prover dispatch (FBC, GF); **net −1 active sorry, +2 axiom-clean decls**, both
independently re-verified via `lean_verify` on the current tree. **0 must-fix from the lean-auditor**;
the only must-fix findings are blueprint-side (lvb-fbc ×2, gating the *next* FBC prover, not this iter's
work). Both CONVERGING walls the progress-critic flagged moved: GF's CHURNING corrective (close the
tower-descent helper, no more helpers) **landed** — `free_localizationAway_of_away_tower` is closed and
axiom-clean; FBC's Seam-2 leg-reindex engine became a proved, named, reusable lemma. No deception: every
`sorry` is honest scaffolding, no fake statements, no weakened defs, no `axiom`s (blueprint-doctor CLEAN).

## Overall progress this iter (active sorry per file)
- **FBC 4→4** — `pullbackPushforward_unit_comp` (NEW, axiom-clean) wired into Seam 2 as `have key`; the
  Seam-2 `sorry` persists on a dependent-leg-transport restructure (legs in dependent positions block
  `rw`). Seam 3 / affine / FBC-B untouched (gated on Seam 2).
- **GF 5→4** (−1) — `free_localizationAway_of_away_tower` CLOSED (witness `f := g·a`, single product;
  `IsBaseChange.comp` / `Module.Basis.mapCoeffs` / `extendScalarsOfIsLocalization`). L5
  `exists_free_localizationAway_polynomial` BLOCKED on an `OreLocalization` instance-presentation diamond
  (do-not-retry).
- **QUOT 4→4** — no lane (Route-2 pivot decided; build resumes iter-017). GR / RegroupHelper: 0 (DONE).

## What shaped iter-017 (live frontiers)
1. **FBC needs a blueprint-writer round BEFORE the next prover** (lvb-fbc must-fix ×2): the Seam-2
   abstract-variable-legs restructure and the Seam-3 `conjugateEquiv`+`homEquiv_counit` coherence are
   both absent from the chapter. Use the same-iter fast-path re-review to unblock FBC in iter-017.
2. **`pullbackPushforward_unit_comp` needs a blueprint block** — sole unmatched `lean_aux` node.
3. **GF L5 is a structural blocker, not a proof gap** — align `gf_torsion_reindex`'s emitted
   `OreLocalization.*` instances (or restate the helper's `hfree`) before any L5 prover. Refactor /
   analogist, never a heartbeat bump.
4. **QUOT Route 2** build resumes (iter-016 plan decision), gated by the mandatory blueprint review.

## Anomalies / debt surfaced (not blocking)
- **GF chapter 0 `\leanok`** despite ≥2 closed axiom-clean pinned decls — `sync_leanok`'s cold
  `lake env lean` times out on this file (known iter-015 KB issue), now compounded by 3
  `synthInstance.maxHeartbeats 1000000` bumps. DAG under-represents GF progress; not laundering/regression.
  (recommendations M1.)
- **Actively-misleading stale block** `FlatBaseChange.lean:234–247` — claims `pushforward_spec_tilde_iso`
  has an open obligation; it is CLOSED (line 538). Prover-cleanup (review cannot edit `.lean`).
- **Pervasive predecessor-project iter markers** (FlatBaseChange 547/635, RelativeSpec ~54..277,
  QuotScheme) — provenance noise, prover-cleanup. (recommendations M2.)
- **Three `maxHeartbeats 1000000` bumps** in GF (lines 1015, 1254, 1375) — all legitimate per lean-auditor;
  the doubly-localised carriers make instance search genuinely expensive (not looping).

## Review subagents dispatched (3; all returned, collectively 0 Lean must-fix / 2 blueprint must-fix)
- **lean-auditor `iter016`** — PASS, 0 must-fix, 5 major (stale comments), 3 minor. Both prover-focus
  decls REAL; witness confirmed `g·a` not `g²`; 3 `maxHeartbeats` bumps legitimate.
- **lean-vs-blueprint-checker `fbc`** — 2 must-fix (Seam-2/3 mechanism under-specified) + new-helper block needed.
- **lean-vs-blueprint-checker `gf`** — faithful, 0 red flags, 42 decls; L5 blueprint adequate (Lean-only blocker).

Reports in `.archon/task_results/`, archived to `logs/iter-016/`. Findings landed in
`session_16/recommendations.md`.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_polynomial_core` — added `% NOTE: (iter-016)` (L5
  `OreLocalization` blocker + non-local fix).
- `Picard_FlatteningStratification.tex`, `lem:gf_away_tower_descent` — added `% NOTE: (iter-016)`
  (`IsBaseChange.comp` packaged route supersedes the "no packaged lemma" remark).
- No `\leanok` (sync's domain), no `\mathlibok` (both decls are project decls), no `\lean{}` renames, no
  stale `\notready` in touched chapters.

## Subagent skips
- None. All three highly-recommended review subagents (lean-auditor, lean-vs-blueprint-checker ×2 for the
  two prover-touched files) were dispatched.
