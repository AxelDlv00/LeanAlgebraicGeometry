# Progress-critic directive — iter-044

Assess convergence per active route from the signals below (last 5 iters). Verdict per route:
CONVERGING / CHURNING / STUCK / UNCLEAR. CHURNING & STUCK are must-fix.

## Route QUOT — `Picard/QuotScheme.lean` (the convergent main arc)
STRATEGY est: Iters left 2–4; entered current consumer phase ~iter-039.
Note: targets are mathlib-build INFRASTRUCTURE (axiom-clean decls ADDED), not sorry-elimination — the
file's sorry count is a constant 4 (frozen protected stubs), so judge progress by decls-landed + the
gap2 residual shrinking, NOT by sorry delta.
- iter-039: +many decls (gap1-D descent + Hfr feeders). Status PARTIAL.
- iter-040: +2 (producer (a) `fromTildeΓ` iso + range-half). PARTIAL.
- iter-041: +7 (gap1 CLOSED + keystone + full Hfr producer chain). KEYSTONE close. COMPLETE for gap1.
- iter-042: +5 (G1-core CLOSED + gap2 core + section-coherence crux). PARTIAL (gap2 absent).
- iter-043: +1 (gap2 Piece B `isLocalizedModule_basicOpen_of_hP1`). Piece A attempted, blocked+flagged
  (precise 5-step decomposition handed off). gap2 now closed MODULO exactly Piece A.
- iter-044 proposal: 1 prover lane — build Piece A (`isQuasicoherent_pullback_fromSpec`, decomposed into a
  route-1 5-step chain this iter) + the 1-line gap2 final close.
Recurring blocker phrase: none persistent — each iter the residual shrank (gap1→G1-core→gap2 core/crux→
Piece B→Piece A). Piece A is a NEW Mathlib-absent slice-base-change sub-build, first surfaced iter-043.

## Route FBC — `Cohomology/FlatBaseChange.lean` (off critical path)
STRATEGY est: Iters left 4–8 (was 3–6); entered current phase iter-037.
- iter-037..041: conjugate route — per-layer legs landed axiom-clean, keystone `_legs_conj` never closed.
- iter-042: no prover (pivot blueprint authored).
- iter-043: tilde-transport prover — 0 decls, REVERSAL: route is illusory, collapses to the SAME keystone.
- iter-044 proposal: NO prover lane. One mathlib-analogist consult on the composite-adjunction mate
  recognition Mathlib idiom; route PARKED off critical path (blocks no other route).
Recurring blocker phrase: "keystone `_legs_conj` / composite-adjunction β-assembly unbuilt" (037–043).
Sorry count constant 4 throughout.

## Objectives proposal (this iter)
1 prover file: `Picard/QuotScheme.lean` (Piece A + gap2 close) [mathlib-build]. FBC = subagent-only
(analogist), no prover. Single ready lane (GF-G1 gap2-gated; QUOT P2/annihilator same file as Piece A;
GR-quot/repr need new-file scaffold).

## Specific questions
1. Is QUOT genuinely CONVERGING or is the gap2 endgame churning (Piece A is the 2nd iter the final gap2
   close has slipped — iter-043 deferred it, iter-044 retries via decomposition)? Is decomposing Piece A a
   real corrective or churn-by-renaming?
2. Is parking FBC (vs another prover lane) the correct response to its STUCK signal, given the iter-043
   reversal proved both routes wall on one keystone?
3. Is a single prover lane this iter under-dispatch, given the other candidates are genuinely blocked?
