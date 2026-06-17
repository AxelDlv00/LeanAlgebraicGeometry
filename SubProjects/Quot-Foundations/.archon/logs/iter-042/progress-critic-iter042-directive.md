# Progress-critic — iter-042 (Quot-Foundations)

Per-route convergence audit. Signals only; no strategy/blueprint context.

## Route: FBC `_legs_conj` / `gstar_transpose` (Cohomology/FlatBaseChange.lean)

- Phase entered current state: ~iter-037. STRATEGY `Iters left` for the conjugate
  discharge was 2–4 (now superseded by a pivot).
- Sorry counts (file, active non-protected): iter-037 4 → 038 4 → 039 4 → 040 4 →
  041 4. Flat at 4 for 5 iters.
- Helpers/decls added per iter: 037 inline assembly; 038 conj atoms; 039 conj-2b +
  conj-2d landed (2 decls); 040 NO prover (kill-criterion honored); 041 NO new
  decls, added a verified in-proof Γ-collapse stage.
- Prover statuses on `_legs_conj`: PARTIAL/INCOMPLETE every iter; never closed.
- Recurring blocker phrase: "multi-layer composite-adjunction recognition" / "bespoke
  Mathlib-absent construction" / "no syntactic `conjugateEquiv` value to apply
  `.injective` to" — unchanged across 037–041.
- iter-042 proposal for this route: **NO prover.** Pivot to a structurally different
  affine tilde-transport route (author blueprint this iter; scaffold + prove later).
  Is this pivot a genuine corrective, or route-churn dressed as a pivot?

## Route: QUOT gap1 + consumers (Picard/QuotScheme.lean)

- Phase: gap1 arc entered ~iter-027; CLOSED iter-041 (the keystone
  `isLocalizedModule_basicOpen_descent` + gap1 `isIso_fromTildeΓ_of_isQuasicoherent`
  + full `Hfr` producer chain landed axiom-clean). STRATEGY `Iters left` for gap1 was
  3–6 at iter-040; actual elapsed ~14 (OVER_BUDGET flagged 040/041).
- Sorry counts (active non-protected): flat at 0 (4 protected stubs only); the gap1
  work was all NEW decls, not sorry-fills. Decls added: 038 σ_V+semilinearity; 039
  3 feeders; 040 producer (a)+range; 041 7 decls closing the chain.
- Prover statuses: PARTIAL×~14 then COMPLETE iter-041 (gap1 closed).
- iter-042 proposal: build the now-unblocked consumers in the SAME file — G1-core
  `isLocalizedModule_basicOpen_of_isQuasicoherent` (2-line corollary of gap1), then
  gap2 `isLocalizedModule_basicOpen` (general scheme X via affine cover). [mathlib-build]
  Is this a fresh convergent lane, or am I re-opening the same churn?

## iter-042 `## Current Objectives` proposal (file count + basenames)

1 prover lane: `QuotScheme.lean` [mathlib-build] — G1-core + gap2 (consumers of the
now-closed gap1). FBC = no prover (pivot blueprint authored). Rest of the iter is
STRATEGY rewrite + FBC tilde-transport blueprint + QUOT coverage-debt reconciliation
+ the 3 mandatory critics.

## What I need

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR). In particular: is the
FBC pivot the right response to the STUCK conjugate route, and is the single QUOT
consumer lane a sound next step after the gap1 close?
