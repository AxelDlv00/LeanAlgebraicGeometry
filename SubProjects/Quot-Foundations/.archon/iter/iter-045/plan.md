# Iter 045 — Plan (Quot-Foundations)

## TL;DR
2 import-independent prover lanes: **GF-G1** (`FlatteningStratification.lean`, build
`gf_qcoh_fintype_finite_sections` consuming the now-closed gap2; add the first cross-leaf import) and **FBC
keystone** (`FlatBaseChange.lean`, FINAL armed round — build `adjR`+`β`, close `_legs_conj`). gap2 CLOSED
iter-044 → GF unblocked. No blueprint edits (coverage debt + isolated-node findings were STALE; live
`dag-query unmatched`/`isolated` = 0). progress-critic: FBC STUCK (final round OK, no second reprieve),
GF-G1 UNCLEAR (proceed), dispatch OK.

## Decision made — 2 lanes; QUOT residue deferred 1 iter
- **Chosen:** GF-G1 + FBC keystone. NOT a 3rd QUOT lane (annihilator/P2).
- **Why defer QUOT:** annihilator/P2 live in QuotScheme.lean — the SAME file FlatteningStratification imports
  this iter (first cross-leaf import). A concurrent prover editing QuotScheme races the import-add. Bounded
  1-iter defer → iter-046. progress-critic confirmed: documented, not avoidance, dispatch OK.
- **FBC final-round vs park:** progress-critic STUCK but "one final round marginally defensible" (new factored
  recipe structurally differs from the exhausted approaches; iter-044 landed verified `adjL`/`hunitL`). Kill-
  criterion ARMED & endorsed: if no standalone `adjR` decl lands → park unconditionally, no second reprieve.

## Verification done (no stale-state action)
- Import cycle: QuotScheme does NOT import FlatteningStratification → safe to add import.
- `gf_qcoh_fintype_finite_sections` decl does NOT yet exist → build/scaffold objective (mathlib-build), not
  fill-sorry. Blueprint G1 block (Stacks 01PB) complete+correct (iter-044 full review ✓✓).
- HARD GATE: iter-044 full blueprint-review cleared FlatteningStratification ✓complete/✓correct AND FBC ✓✓;
  no chapter edited this iter → gate satisfied by carry-forward.

## Subagent skips
- blueprint-reviewer: iter-044 full review cleared BOTH active-lane chapters (FlatteningStratification
  ✓complete/✓correct — G1 block correct; FlatBaseChange ✓✓); no chapter edited this iter; sole flag was a
  stale `\leanok` on `thm:generic_flatness` (sync_leanok's domain, not the G1 block). All 3 skip conditions met.
  (A prior interrupted plan attempt dispatched it; that process died with no report — re-run unnecessary given
  the carry-forward verdict.)
- strategy-critic: STRATEGY.md unchanged this iter (GF-unblock + FBC-final-round were already in the iter-044
  STRATEGY; no route swap / reorder / >30% re-estimate); prior verdict SOUND, both CHALLENGEs addressed.
- blueprint-clean: no blueprint prose edits this iter (coverage debt already cleared; isolated-node finding stale).
