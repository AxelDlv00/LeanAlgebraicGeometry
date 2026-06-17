# Progress-critic directive — iter-035 (Quot-Foundations)

Assess convergence per active route. K = 4 iters of signals. Fresh-context read: are these
routes closing, or churning (helpers added each iter, residual unchanged)?

## Route 1 — FBC-A (`Cohomology/FlatBaseChange.lean`, `_legs` crux = `base_change_mate_fstar_reindex_legs`)
The central project blocker. Target: close `_legs` (+ cascade `gstar_transpose`).
- iter-031: term-mode work on the locked goal; sorry 4→4; status PARTIAL.
- iter-032: term-mode `congrArg` collapse of trailing factor landed (green); sorry 4→4; PARTIAL.
- iter-033: direct-on-sections route RULED OUT (HARD-COMMIT abandon); residual = "cross-layer mate
  coherence with no term-mode form" under the "X.Modules instance diamond"; sorry 4→4; PARTIAL.
- iter-034: PIVOT to conjugate route; conj-0 foundation landed = 2 axiom-clean lemmas
  (`pullbackComp_eq_leftAdjointCompIso{_inv}`); confirmed pinned Mathlib has the full `CompositionIso`
  calculus; `_legs` did NOT close; sorry 4→4; PARTIAL.
- Helpers added per iter: ~1–2. Recurring blocker phrase: "X.Modules diamond", "cross-layer naturality
  of gammaPushforwardIso". Residual `_legs` sorry unchanged for ~5 iters.
- Strategy `Iters left` for FBC-A: 2–4. Route entered its CURRENT (conjugate) phase at iter-034.
  Prior iter-034 verdict: STUCK (primary corrective = route pivot, which was taken = conjugate route).
- iter-035 proposed: ONE more round on the conjugate route (conj-1 = re-cut codomain read as a NEW
  `leftAdjointCompIso`-native def; conj-2 = discharge `_legs` via `conjugateEquiv.injective`), paired
  with a STRUCTURAL corrective (effort-breaker atomizing conj-1/conj-2 into a `\uses`-linked sub-lemma
  chain). NOTE: the standing user directive FORBIDS escalating to the user — so the iter-036 fallback if
  this fails is a structural REFACTOR of the comparison-object encoding, not user escalation.

## Route 2 — QUOT (`Picard/QuotScheme.lean`, gap1 chain)
- iter-033: +4 axiom-clean slice-transport infra; P1 keystone deferred (budget); PARTIAL.
- iter-034: +7 axiom-clean; P1 keystone `isIso_fromTildeΓ_restrict_basicOpen` COMPLETE +
  general `isIso_fromTildeΓ_presentationPullback` landed; protected stubs 4→4; PARTIAL-but-keystone-landed.
- Strategy `Iters left`: 3–7. Phase entered iter ~030. Prior verdict: UNCLEAR (positive first signals).
- iter-035 proposed: build gap1 keystone D `isLocalizedModule_basicOpen_descent` (blueprint ready,
  source-verified Stacks `lemma-invert-f-sections`; recipe = finite sheaf equalizer + localization flat).

## Route 3 — GR (`Picard/GrassmannianCells.lean`)
- iter-033: +6 axiom-clean ring heart (`diagonalRingMap_surjective`); isSeparated deferred; PARTIAL.
- iter-034: +7 axiom-clean; isSeparated keystone `lem:gr_separated` COMPLETE; lane closed; 0→0 sorry.
- Strategy `Iters left`: 1–2 (sep done). Prior verdict: UNCLEAR→CONVERGING.
- iter-035 proposed: NEW fresh sub-phase `lem:gr_proper` (valuative criterion of properness, Nitsure §1;
  blueprint complete + source-verified). Build `Grassmannian.isProper`. This is a deep fresh target.

## Route 4 — FBC-B (`Cohomology/FlatBaseChangeGlobal.lean`) — context only, NOT dispatched this iter
- iter-033: NEW file +3 axiom-clean. iter-034: +13–15 axiom-clean; ModuleCat-over-A eqLocus sub-lane +
  `baseChangeGammaEquiv` payoff DONE. Chain assembly GATED on FBC-A's affine sorry. Not dispatched iter-035.

## This iter's `## Current Objectives` proposal (file count + basenames)
3 prover lanes: (1) `FlatBaseChange.lean` [FBC-A, fine-grained], (2) `QuotScheme.lean` [QUOT-D,
mathlib-build], (3) `GrassmannianCells.lean` [GR-proper, mathlib-build/scaffold]. FBC-B not dispatched
(gated). GF not dispatched (gated on gap1).

## What I need from you
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the corrective TYPE for any
CHURNING/STUCK. Special focus on FBC-A: is conj-0→conj-1 a genuine advancing pivot or reworded churn?
Is pairing the round with an effort-breaker (structural) an adequate STUCK corrective, or is a deeper
refactor/route-abandon warranted now rather than iter-036? Dispatch-sanity check on the 3-lane proposal.
