# Progress-critic directive — iter-060

Assess convergence of the two active prover routes. For each, the last K=4 iters of signals
(sorry counts, helpers added, prover statuses, recurring blocker phrases), the strategy's
current iters-left estimate, and the iter the route entered its current phase. Then the
planner's proposed objectives for iter-060.

## Route A — Sub-brick A Stub-1 consumer — `CechSectionIdentification.lean`
- Strategy phase: "P5a-resolution `cechAugmented_exact`". Current `Iters left` estimate: ~2–5.
  Entered current phase ~iter-053 (Sub-brick A decomposition began).
- Signals (last 4 iters):
  - iter-056: Stubs 5/6 PROVEN-FALSE→re-spec to augmented form; Stub 3 closed. sorry 6→5. Status PARTIAL.
  - iter-057: Stub-1 geometric backbone +6 axiom-clean decls. sorry 5→5. Status PARTIAL.
  - iter-058: Stub-1 brick set +9 axiom-clean decls (all 4 decomposed leaves + prodFinSuccIso + Over-S
    helpers). sorry 5→5. Status PARTIAL. "every categorical brick the induction needs now exists."
  - iter-059: +8 axiom-clean decls — the TWO blueprint-named build-targets
    (`overProd_coproduct_distrib`, `widePullback_coproduct_iso`) now PROVED. sorry 5→5. Status PARTIAL.
    Lone remaining: the consumer `cechBackbone_left_sigma` (universe reduction — reindex `𝒰.I₀≃Fin n`).
  - Recurring blocker phrase: "universe reduction / all bricks built, only the consumer remains."
- Planner's iter-060 proposal: ONE prover lane on this file — close `cechBackbone_left_sigma` via the
  universe-reduced consumer (the prover handed off a precise LHS/RHS `Fin n`-reindex transport recipe,
  ~80–150 LOC). NOT another helper round; the two hardest bricks landed iter-059.

## Route B — Need#1 open-immersion acyclicity — `OpenImmersionPushforward.lean`
- Strategy phase: "P5a-consumer `higherDirectImage_openImmersion_comp`". Current `Iters left`: ~2–4.
  Entered current phase ~iter-054.
- Signals (last 4 iters):
  - iter-056: Need#2 reduction tops (different file). OpenImm not a lane.
  - iter-057: Need#1 Ext-transport CORE `modulesIsoSpecExtTransport` +4 axiom-clean decls. Status PARTIAL.
  - iter-058: OpenImm decomposed-only (no prover; per prior progress-critic). 
  - iter-059: +5 axiom-clean decls — homological bridge DONE
    (`isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`, `ext_jShriekOU_eq_zero_of_specIso`,
    `subsingleton_ext_of_iso_fst`, EnoughInjectives connector). Leaf factored to TWO named geometric
    sub-lemmas `hjt`/`hqc` (sorry 2→3, intentional factoring). Status PARTIAL.
  - Recurring blocker phrase: "geometric transport isos (jShriekOU natural-iso + qcoh preservation),
    confirmed Mathlib gap, deep adjunction-mate construction."
- Planner's iter-060 proposal: ONE prover lane on this file — build the geometric transport
  sub-lemmas bottom-up (`pushforward_commutes_free`/`_sheafify`, `yoneda_transport_along_homeo` →
  `jShriekOU_transport_along_iso`=`hjt`; then `pushforward_iso_preserves_qcoh`=`hqc`), discharge the
  two leaf sorries. The blueprint for these sub-lemmas is being expanded this iter (writer round) with
  concrete Mathlib API guidance before dispatch.

## Question
Per route: CONVERGING / CHURNING / STUCK / UNCLEAR, and the corrective TYPE if not CONVERGING.
Note specifically: Route A has held sorry=5 for 4 iters while adding helpers — is this genuine
foundation-building converging on a now-closeable consumer, or churning?
