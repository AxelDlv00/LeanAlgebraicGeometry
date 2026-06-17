# Iter 020 — Review (Quot-Foundations)

## Verdict

Build GREEN (both edited modules `lake build` EXIT 0 — FlatteningStratification + QuotScheme, 8317
jobs each; only expected `sorry` + linter warnings; blueprint-doctor 0 findings; `sync_leanok` ran on
this tree at sha `f714500`, +10 `\leanok`, chapters_touched = Picard_QuotScheme.tex). **2-lane prover
dispatch (QUOT prove, GF prove); FBC no-prover by design. Net −1 active sorry, +2 axiom-clean
declarations.** lean-auditor + 2 lean-vs-blueprint-checkers: **0 must-fix across all three** — every
`sorry` is honest scaffolding, no excuse-comments, no axioms, all new decls `{propext,
Classical.choice, Quot.sound}`. **The headline result is structural: the SNAP-S2 keystone
`gradedModule_hilbertSeries_rational` is now fully proved end-to-end and axiom-clean** — the last live
mathematical leaf in the QUOT lane closed.

## Overall progress this iter (active sorry per file)

- **QuotScheme (QUOT) 5→4 (−1, +1 axiom-clean helper)** — `subquotient_base_eventuallyZero`'s
  `iSupIndep` base-case leaf CLOSED via ROUTE (b) (ambient degree-`i` homogeneous-component membership;
  route (a)'s `liftQ` detector hard-prohibited and never attempted). New ring-agnostic helper
  `iSupIndep_map_of_mem_ker_sup`. HARD ENTRY CONSTRAINT honored: no `DirectSum.Decomposition` on any
  quotient/subtype carrier, no `isDefEq`/`whnf` recurrence, no heartbeat bumps. The 4 residual sorries
  are deliberate downstream file-skeleton stubs (@126/165/201/228) — no live math leaf remains. Keystone
  chain (`subquotient_base_eventuallyZero` → `subquotient_hilbertSeries_rational` →
  `gradedModule_hilbertSeries_rational`) all sorry-free + axiom-clean (`lean_verify` confirmed).
- **FlatteningStratification (GF) 3→3 (net 0, but `genericFlatnessAlgebraic` advanced)** —
  `genericFlatnessAlgebraic` dévissage motive (`Module.compHom` restricted-A-action) + 2 of 3
  obligations CLOSED (subsingleton via `_of_torsion`; short-exact via `_of_shortExact`). Quotient
  (B/𝔭) obligation stays `sorry` (bottoms out at L4 + L5). **L4 finiteness leaf @754 UNCHANGED** — a
  deliberate, well-reasoned scope call: the current `hfin` has a generically-FALSE local type, an honest
  close needs the witness refinement `g0 → g0·g1` and a ~150–250-LOC assembly rebuild, deferred for
  budget. Prover surfaced the collapsing tool: `IsIntegral.exists_multiple_integral_of_isLocalization`.
- **FlatBaseChange (FBC) 4→4 (untouched)** — no prover this iter (planner decision: the iter-019
  `decouple-legs` refactor swapped the route, making the 6-iter-stuck `fstar_reindex` crux dead code;
  `gstar_transpose` is the new live crux for iter-021 after a dead-code-removal pass).
- **GrassmannianCells / RegroupHelper 0/0** — DONE, untouched.

## What shaped iter-021 (live frontiers)

1. **GF L4 finiteness is the single highest-leverage proving target.** Concrete path: blueprint-writer
   pins the `g0→g0·g1` witness refinement + `IsIntegral.exists_multiple_integral_of_isLocalization`
   denominator-clearing recipe (HARD GATE), then a `prove` pass (assembly transfers verbatim with
   `g0→g`). Closing it cascades to the `genericFlatnessAlgebraic` quotient obligation.
2. **FBC is a refactor-then-prove lane**: dead-code removal of the orphaned `fstar_reindex` apparatus,
   then a `gstar_transpose` (Seam 3) prover. Do NOT re-dispatch `fstar_reindex` (dead code).
3. **QUOT pivots from proving to hygiene**: no live math leaf; next work is a file-split /
   de-privatization (the IsRatHilb + GradedModule helper toolkit) and blueprinting 2 unmatched nodes.
4. **Recurring `sync_leanok` debt**: 11 GF Nagata helpers are `private` with public `\lean{}` pins →
   `\leanok` tracking silently broken (flagged iters 018/019/020). A `refactor` de-`private` pass.

## Anomalies / debt surfaced (not blocking)

- **Stale `.lean` comment `QuotScheme.lean:1510–1519`** — describes the now-closed leaf as an open
  `sorry` with a route-(a) "OBSTRUCTION". **major** by both lean-auditor and the QUOT checker. Review
  agent cannot edit `.lean`; flagged for the next prover (recommendations item 4).
- **Stale chapter `% NOTE` fixed this review**: `Picard_QuotScheme.tex` `lem:gradedHilbertSerre_rational`
  (lines 406–409) said the keystone "is not yet a Lean declaration" — it landed closed this iter;
  updated to record the closed axiom-clean status.
- **`uncommitted working tree`**: this iter's prover edits + the iter-019 FBC route swap are uncommitted
  (repo has only the initial commit). `git diff HEAD~1` is empty by consequence; assessment is grounded
  in the working-tree files + `attempts_raw.jsonl`, not a commit delta.

## Subagent skips
- (none — all review-phase recommended subagents dispatched: lean-auditor `iter020`,
  lean-vs-blueprint-checker `quot`, lean-vs-blueprint-checker `gf`.)
