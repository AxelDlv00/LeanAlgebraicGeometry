# Progress-critic directive — iter-034

Assess convergence per active route from the extracted signals below. K=4 iters (030–033).
Your verdict feeds the planner's stuck-protocol gate. Verdicts: CONVERGING / CHURNING / STUCK / UNCLEAR.

## Route: FBC-A (`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`, target `_legs`/`gstar_transpose`/affine)

- Strategy phase entered: FBC direct-on-sections active since ~iter-019; current "mate re-encoding" pivot is iter-034.
- Strategy `Iters left` (pre-pivot): 1–2 (consistently under-estimated).
- Signals (iters 030→033):
  - sorry count: 4 → 4 → 4 → 4 (unchanged 4 rounds; whole-file count incl. gated downstream).
  - helpers added per iter: iter-030 +1 (`link_distributeCollapse`); iter-031 +3 wrapper lemmas; iter-032 codomain-read unfold advance; iter-033 +0 (term-mode `congrArg` collapse of trailing factor, no new decl).
  - prover status: PARTIAL / PARTIAL / PARTIAL / PARTIAL (no sorry ever eliminated on `_legs`).
  - recurring blocker phrases: "`X.Modules` instance diamond"; "keyed `rw`/`simp`/`erw` dead"; "cross-layer mate coherence has no term-mode form"; "declaration-ordering (cancellers out of scope)".
  - prior verdicts: iter-032 progress-critic = **STUCK** (tripwire); iter-033 sanctioned HARD-COMMIT final round did NOT close `_legs`.
- Planner's iter-034 action on this route: **route pivot** — abandon direct-on-sections, re-encode via abstract mate calculus (`mateEquiv`/`conjugateEquiv`), no prover dispatch this iter; mathlib-analogist consult + blueprint rewrite + refactor next iter. Assess whether this corrective is responsive to the STUCK signal.

## Route: FBC-B (`AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`)

- Phase entered: iter-033 (NEW file). Strategy `Iters left`: 2–5.
- Signals: iter-033 = +3 axiom-clean decls (L1 finite affine cover, L2 sheaf-fork, consolidation), 0 sorry, status PARTIAL (lane advanced). Only 1 iter of data.
- Next-iter plan: build the independent ModuleCat-over-A `eqLocus` reformulation sub-lane (3 ingredients), then the affine-gated chain links wait on FBC-A.

## Route: GR-sep (`AlgebraicJacobian/Picard/GrassmannianCells.lean`, target `isSeparated`)

- Phase entered: GR-glue iter-032 (CLOSED, +8); GR-sep iter-033.
- Signals: iter-032 GR-glue CLOSED (+8 axiom-clean, `Grassmannian.scheme`); iter-033 GR-sep +6 axiom-clean (`diagonalRingMap` family incl. `_surjective` = Proj's hardest analogue, `pullbackιIso` = e₂), `isSeparated` keystone scaffolded then removed under no-sorry invariant; status PARTIAL but substantive advance. Route fully scouted (route (b): build π → IsSeparated π via Proj template → reconcile terminal).
- Next-iter plan: build `isSeparated` via route (b) — strong close candidate.

## Route: QUOT-P1 (`AlgebraicJacobian/Picard/QuotScheme.lean`, target `isIso_fromTildeΓ_restrict_basicOpen`)

- Phase entered: gap1 bridge-C iter-031 (CLOSED, +4); P1 iter-033. Strategy `Iters left`: 3–7.
- Signals: iter-031 bridge-C closed (+4); iter-033 P1 +4 infra decls (`overRestrictUnitIso`/`overRestrictPresentation`/`presentationPullbackιOfQuasicoherentData` + private helper), keystone deferred (budget on unit-iso elaboration); status PARTIAL, real advance. 5-step completion recipe concrete for next iter.
- Next-iter plan: build the keystone from the new infra via the 5-step recipe.

## Planner's iter-034 `## Current Objectives` proposal (file count + basenames)

3 prover lanes (FBC-A is a pivot/no-prover): `GrassmannianCells.lean` (GR-sep `isSeparated`),
`QuotScheme.lean` (QUOT-P1 keystone), `FlatBaseChangeGlobal.lean` (FBC-B eqLocus sub-lane).
Dispatch-sanity: are these 3 the right calls, is FBC-A correctly NOT dispatched-as-prover, any churn risk?
