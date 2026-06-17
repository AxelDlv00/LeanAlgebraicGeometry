# Progress-critic directive — iter-045

Assess convergence per active route from the signals below. K=4 iters.

## Route: FBC keystone — `Cohomology/FlatBaseChange.lean`
Target: close `base_change_mate_fstar_reindex_legs_conj` (keystone `_legs_conj`).
- iter-041: conjugate `gstar_transpose` route declared EXHAUSTED in-loop (5-iter, 037–041).
- iter-042: no prover lane (blueprint pivot to "affine tilde-transport").
- iter-043: REVERSAL — tilde-transport bypass illusory; 0 decls; sorry 4→4. Both routes funnel to `_legs_conj`.
- iter-044: PARTIAL — 0 standalone decls; verified `adjL`/`hunitL` baked into the keystone proof (depth-2 correction). sorry 4→4.
- Recurring blocker phrases: "adjR/β remain", "guessing adjR blind risks wasted type-checks", "no LLM API key", "8-iter wall (037–044)".
- STRATEGY `Iters left`=1; phase entered ~iter 037 (elapsed ~8).

## Route: GF-geo (G1) — `Picard/FlatteningStratification.lean`
Target: build `gf_qcoh_fintype_finite_sections` (G1), consuming the now-closed gap2.
- iter-022: algebraic core `genericFlatnessAlgebraic` DONE. Since then GF was gap1/gap2-BLOCKED (no prover work).
- iter-044: gap2 closed in QuotScheme.lean → GF-G1 newly UNBLOCKED. First dispatch is iter-045 (fresh lane).
- STRATEGY `Iters left`=2–4; phase re-activated iter-045.

## Route: QUOT-defs — `Picard/QuotScheme.lean` (context only; NOT a lane this iter)
- iter-042: +5 axiom-clean (G1-core + gap2-core + crux); sorry 4→4.
- iter-043: +1 axiom-clean (Piece B bridge); sorry 4→4.
- iter-044: +11 axiom-clean (Piece A L1–L6 + gap2 close) — **gap2 CLOSED**, ~16-iter arc done; sorry 4→4.
- Remaining (deferred to iter-046): annihilator characterization + P2. NOT dispatched iter-045 to avoid the
  import-and-edit race (FlatteningStratification imports QuotScheme this iter).

## Planner's proposed iter-045 objectives (2 files)
1. `Picard/FlatteningStratification.lean` — GF-G1 build [mathlib-build].
2. `Cohomology/FlatBaseChange.lean` — FBC keystone adjR/β, FINAL in-loop round (kill-criterion armed).

Question for you: is FBC genuinely STUCK (and is the iter-045 "one final round then park" the right call, vs
park now)? Is GF-G1 a sound fresh dispatch? Is 2 lanes (deferring QUOT) right, or under-dispatch?
