# Progress-critic directive — iter-059

Assess convergence of the two active prover routes the planner is considering for this
iteration's dispatch. Verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR).

## Route A — `CechSectionIdentification.lean` (Sub-brick A, Stub-1 geometric backbone)

Strategy phase: P5a-resolution. STRATEGY `Iters left` estimate: ~3–6. Route entered current
phase (Sub-brick A monolith → decomposed) around iter-055.

Last-5-iters signals (sorry count in file / decls added / prover status / blocker phrases):
- iter-055: sorry 6 / stubs shipped (RED, fixed in planner phase) / PARTIAL / "stubs non-compiling, churning"
- iter-056: sorry 6→5 / closed Stub 3, DISPROVED Stubs 5/6 (airtight counterexample) / PARTIAL / "non-aug complex not contractible; consumer needs augmented"
- iter-057: sorry 5→5 / +6 backbone decls (mem_iInf, widePullback_openImm_inter, cechBackbone_obj_widePullback, coverArrowOver* coproduct leaf) / PARTIAL / "hard coproduct_distrib_fibrePower DEFERRED not stubbed"
- iter-058: sorry 5→5 / +9 brick decls (4 blueprint-named decomposed leaves widePullback_overX_eq_prod / prod_coproduct_distrib / coproduct_fibrePower_reindex / widePullback_coproduct_iso_zero + prodFinSuccIso + 4 Over-S helpers) / PARTIAL / "EVERY categorical brick the inductive step needs now exists; only assembly glue (overProd_coproduct_distrib + induction) remains"

Note: the decomposition was applied iter-058 (effort-breaker split the monolith into 4 \uses-linked
leaves). iter-058 built all 4 leaves + the Fin-succ split. The remaining work is the inductive
assembly `widePullback_coproduct_iso` (= blueprint `lem:coproduct_distrib_fibrePower`, leandag
ready-to-prove) + the consumer `cechBackbone_left_sigma`. A newly-surfaced obstacle this iter: the
extensivity API `FinitaryPreExtensive.isIso_sigmaDesc_fst` is `Type 0`-only, while `𝒰.I₀ : Type v`
— so the induction must run at `Type 0` and reindex `𝒰.I₀ ≃ Fin n` (via `[Finite 𝒰.I₀]`) at the
consumer.

## Route B — `OpenImmersionPushforward.lean` (Need#1 jShriekOU scheme-iso transport)

Strategy phase: P5a-consumer. STRATEGY `Iters left` estimate: ~2–4. Route entered current phase
(Need#1 transport) around iter-056.

Last-5-iters signals:
- iter-054: sorry 2 / `_acyclic` reduction wired to clean Serre leaf / PARTIAL / "geometry-free leaf reshaped"
- iter-056: sorry 2→2 / +5 corepresentability helpers / PARTIAL / "naive isoSpec transport = restriction-injectives WALL; adopt Need#1+Need#2 split"
- iter-057: sorry 2→2 / +4 Ext-transport core decls (modulesIsoSpecExtTransport via mapExt_bijective) / PARTIAL / "residual = jShriekOU scheme-iso transport"
- iter-058: sorry 2→2 / NO prover (decomposition-only per prior CHURNING corrective); blueprint decomposed the transport into 5 \uses-linked sub-lemmas (jshriek_transport_along_iso, pushforward_commutes_free, pushforward_commutes_sheafify, yoneda_transport_along_homeo, pushforward_iso_preserves_qcoh), all now leandag ready-to-prove.

Note: iter-058 deliberately gave Route B no prover (CHURNING corrective = decompose first). The 5
sub-lemmas are now decomposed and frontier-ready; Need#2 (the other half of the leaf discharge) is
CLOSED as of this iter. This iter is the FIRST prover dispatch on the decomposed Route B.

## Planner's proposed `## Current Objectives` for iter-059 (2 lanes)
1. `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` — build the inductive assembly
   `widePullback_coproduct_iso` (+ the `overProd_coproduct_distrib` bridge + `Type 0` / `Fin n`
   universe reduction) and the consumer `cechBackbone_left_sigma`. [mathlib-build]
2. `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` — build the 5 decomposed Need#1
   jShriekOU-transport sub-lemmas, then assemble toward `_acyclic`. [mathlib-build]

## Question
For each route: CONVERGING / CHURNING / STUCK / UNCLEAR, with the corrective TYPE if not CONVERGING.
Specifically: is Route A genuinely converging now that all bricks are built (post-decomposition), or
is the residual assembly+universe-reduction another churn risk? Is Route B's first post-decomposition
dispatch sound, or premature? Flag any dispatch-sanity issue with the 2-lane proposal.
