# Progress-critic directive — slug `iter065`

Assess convergence per active route. Two routes are under consideration for this iter's prover dispatch.
For each, the last 5 iters' signals (sorry counts are file-local for the route's file; helpers = new
axiom-clean decls added that iter; status = prover lane outcome).

## Route A — CSI Sub-brick A (`CechSectionIdentification.lean`)
Strategy row: `P5a-resolution cechAugmented_exact`. STRATEGY `Iters left` = ~2–4. Entered current phase
(this file's active lane) around iter-054.

Signals (last 5 iters):
- iter-060: sorry ~5 (Stubs 2/4/5/6 region); +helpers; PARTIAL.
- iter-061: sorry 4; +2 helpers (`isIso_modules_of_toPresheaf` + prep); PARTIAL. (binary L2 blocked on instance trap)
- iter-062: sorry 4; +3 helpers (`isIso_coprodDecompMap`, `isIso_map_prodLift_of_isLimit`); PARTIAL. (L2 = full q_* assembly, not the leaf)
- iter-063: sorry 4; +3 helpers (`pushPull_binary_leg_coherence` ★, `pushPull_binary_coprod_prod`, `sigmaOptionIso`); PARTIAL. (arrived RED, recovered)
- iter-064: sorry 5→4 — **CLOSED the substantive `coprodToProd_isIso_option` Option-step** (reuses ★); +5 helpers; PARTIAL. Residual now = 2 named leaves: `pushPull_coprod_prod_empty` (`IsZero` over empty scheme, ~40–60 LOC) + `coprodToProd_isIso_of_equiv` (whiskerEquiv reindex, ~80 LOC). Both close Stub 2.

Recurring blocker phrases: "near budget — declined the monolith" (iters 062/063); "decomposed into N small
mechanical pieces"; iter-064 NEW = "Option step CLOSED" (first real closure in the chain after the iter-064
mode-switch mathlib-build→fine-grained).

This iter's proposed objective: `prove`-mode targeted dispatch closing the 2 named leaves (983, 999) →
Stub 2 (`pushPull_sigma_iso`) → Stub 4 (`pushPull_eval_prod_iso`). NOT another decompose pass.

## Route B — OpenImm `hqc`/`_comp` (`OpenImmersionPushforward.lean`)
Strategy row: `P5a-consumer higherDirectImage_openImmersion_comp`. STRATEGY `Iters left` = ~2–4. Entered
current phase around iter-054.

Signals (last 5 iters):
- iter-060: sorry 2 (`hqc`/`_comp`); +helpers; PARTIAL. (metavar wall on `[F.IsContinuous]`)
- iter-061: sorry 2; +2 helpers (`coversTop_preimage_of_iso`, `pushforward_iso_qcoh_of_slice_qcoh`); PARTIAL.
- iter-062: sorry 2; +6 helpers (ψ_r slice-structure-sheaf infra `sliceStructureSheafHom` + instances); PARTIAL.
- iter-063: sorry 2; +6 helpers (`sliceOversEquiv` + BOTH continuity instances — the 3-iter metavar wall CLEARED); PARTIAL. (found φ'' blueprint was a type-mismatch)
- iter-064: sorry 2→5 — **DECOMPOSED `case hqc` monolith into 4 typed leaves; CLOSED 2 sub-lemmas** (`pushforwardSliceTwoAdjunction`, `pushforward_iso_preserves_qcoh`) + `case hqc` body now sorry-free (transitively dep on leaves) + built the `leftAdjointUniq` half of `pushforwardSlicePullbackIso`; +10 decls; PARTIAL. Residual collapses to ONE keystone φ'' (`sliceReverseRingMap`) codomain-bridge part (b) object-relabel iso (~40–80 LOC); once φ'' concrete, H₁/H₂ (eqToHom squares) + pullbackIso section-id fall.

Recurring blocker phrases: "everything hinges on φ''"; "object-relabel iso ~40–80 LOC"; iter-064 NEW =
"upper chain compiles; residual isolated to 4 atomic leaves all downstream of φ''".

This iter's proposed objective: `prove`-mode targeted dispatch closing φ'' (607) → H₁/H₂/pullbackIso →
`_acyclic` closes → attempt `_comp` (934) + EnoughInjectives connector. NOT another decompose pass.

## What I need from you
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR). The prior iter (064) you returned CHURNING for
BOTH and prescribed the corrective "blueprint decomposition into atomic sub-lemmas + prover mode-switch
mathlib-build→fine-grained." That corrective was EXECUTED iter-064 and produced, for the first time in the
chain, REAL closures (CSI Option step; OpenImm 2 sub-lemmas + case hqc). I am proposing a targeted
single-leaf `prove` dispatch on each (NOT another decompose pass, NOT another mathlib-build pass). Tell me:
(1) did the decomposition corrective convert each route from CHURNING toward CONVERGING, and (2) is the
proposed targeted single-leaf `prove` dispatch the right next action, or do you see a still-live churn
signal that the raw flat-ish sorry counts might be masking. If CHURNING/STUCK persists for either, name the
corrective TYPE.
