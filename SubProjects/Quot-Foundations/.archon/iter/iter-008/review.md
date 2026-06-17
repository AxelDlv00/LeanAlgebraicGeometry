# Iter 008 — Review (Quot-Foundations)

## Verdict: build GREEN; the mandated FBC+GF dispatch delivered real movement on both deep lanes; 0 must-fix; one assigned lane (GR-cells) produced nothing

iter-008 was the iter-007-committed "MANDATORY FBC + GF dispatch." Both deep lanes did faithful,
substantive work. `attempts_raw.jsonl`: 39 edits across exactly two files (FlatBaseChange +
FlatteningStratification), no `no_prover_lane` flag. No fake statements, no weakened defs, no
excuse-comments, no `axiom`s — every `sorry` is honest scaffolding with an in-code diagnosis. All
three highly-recommended review subagents returned **0 must-fix**.

## Overall progress this iter

- **Active sorry per tactic-site:** FBC 4 → 5, GF 4 → 5 (each net +1). The +1 is NOT regression:
  - FBC's `map_smul'` was split into 2 trivial `r' • 0 = 0` zero-branches *after* its substantive
    generator computation was **proven** (first real end-to-end execution of route (a)).
  - GF added 2 **axiom-clean** lemmas (`gf_generic_rank_ses`, `gf_clear_one_denominator`) and 1 new
    `sorry`-bodied `gf_torsion_reindex` (the deliberately-isolated Mathlib-absent residue).
- **2 declarations PROVED axiom-clean** (`#print axioms` = `[propext, Classical.choice, Quot.sound]`,
  re-verified by the review agent via `lean_verify`): `gf_generic_rank_ses`, `gf_clear_one_denominator`.
- **1 load-bearing structural advance:** GF L5 `exists_free_localizationAway_polynomial` now uses
  `Nat.strong_induction_on generalizing A N` — the IH quantifies over the **base domain `A`**, the
  named iter-006 root cause of the stall. SES extraction via `gf_generic_rank_ses` typechecks.
- **1 substantive partial:** FBC `map_smul'` — the `tmul`/`add` branches close via the `erw
  [ExtendScalars.smul_tmul]` unlock; only zero-bookkeeping remains.
- **Graph health:** `gaps` = 0, `unmatched` = 0, blueprint-doctor CLEAN.

## What shaped iter-009 (three findings)

1. **FBC `generator_trace_eq` is blocked on a blueprint gap, not proof difficulty.** The 3 mate-trace
   sub-lemmas have prose + `\lean{}` hints but no `% LEAN SIGNATURE` blocks; the prover correctly
   refused to guess their types. The plan agent must author the signatures (blueprint-writer → HARD
   gate → prover). I added a consolidated `% NOTE` over the three blocks.

2. **FBC `map_smul'` is one route-(b) refactor from done.** The substantive content is proven; the 2
   zero-branches are blocked by the *transparent-instance wall* (`SMulZeroClass ↑R'` won't synthesize
   through the opaque `_aux` `Module R'` instances). Fix = retype `g`'s domain/codomain at the genuine
   iso objects. The refuted one-liner must NOT return (the stale NOTE at `:851-853` advertising it
   should be deleted by the next file owner).

3. **GF is converging, not churning** — but its critical path is now the shared single-variable
   `MvPolynomial` elimination engine. `gf_torsion_reindex` (and L4 Step 2) both consume it; effort-break
   it once, reuse twice. iter-007's STUCK tripwire ("zero closures on GF-alg sub-lemmas → STUCK") is
   **cleared**: two sub-lemmas landed axiom-clean.

## Anomalies surfaced (not blocking, but the planner must see)

- **GR-cells lane produced no output.** Dispatched as a third lane (`gr_transition`), but committed
  zero edits and wrote no task_result; `GrassmannianCells.lean` is unchanged. Budget spent, nothing
  delivered. The planner must decide iter-009 disposition (re-dispatch the gate-cleared frontier node
  or de-scope).
- **GF chapter lost all `\leanok` (12 removed by sync) despite verifiably-clean lemmas.** A
  sync-timing artifact (sync ran on an intermediate non-green tree; sha `c97d3dd` is absent from
  `git log`). The current tree is green and the decls verify clean; a fresh `sync_leanok` run should
  restore the markers. Review agent cannot touch `\leanok` — flagged for the planner.

## Review subagents dispatched (all three highly-recommended; both prover-touched files verified)

- **lean-auditor `iter008`**: SOUND — 7 files, 0 critical / 3 major / 4 minor, 0 must-fix. Majors:
  22 deprecated `Sheaf.val` sites (FBC), stale `GrassmannianCells.lean:57-59` docstring, the
  refuted-one-liner NOTE at FBC:851-853. Confirmed the `map_smul'` chain, both GF lemmas, and the
  `Type u` universe change all sound.
- **lean-vs-blueprint-checker `fbc-iter008`**: faithful (27 decls); major = 3 mate-trace sub-lemmas
  need `% LEAN SIGNATURE`; precision gap on `affineBaseChange_pushforward_iso`.
- **lean-vs-blueprint-checker `gf-iter008`**: faithful (18 decls), 0 red flags; major = shared-universe
  `% NOTE` on `lem:gf_polynomial_core` (added); minor = `gf_clear_one_denominator` spec imprecision
  (added). Confirmed both new lemmas axiom-clean.

Reports under `.archon/task_results/` (archived to `logs/iter-008/`). Findings landed in
`recommendations.md`.

## Blueprint markers I changed (manual)
- `Picard_FlatteningStratification.tex` `lem:gf_polynomial_core`: `% NOTE` — shared-universe `(A N : Type u)`.
- `Picard_FlatteningStratification.tex` `lem:gf_clear_one_denominator`: `% NOTE` — `IsLocalization.map` encoding.
- `Cohomology_FlatBaseChange.tex` mate-trace section: `% NOTE` — 3 sub-lemmas need `% LEAN SIGNATURE`.
- No `\mathlibok`, no `\lean{}` renames, no `\notready` strips. No `\leanok` touched (sync's domain).

## Subagent skips
- (none — all three highly-recommended review subagents were dispatched, since both `.lean` files
  received substantive prover work.)
