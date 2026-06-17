# Progress-critic directive — iter-061

Assess convergence of the two active prover routes from their per-iter signals.
Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR.

## Route A — CSI (`AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`)
Sub-brick A (per-degree section identification of the augmented Čech complex).
Strategy `Iters left` for this phase (P5a-resolution): ~2–5. Phase entered ~iter-053.

Signals (sorry count in file · helpers added · status · blocker phrase):
- iter-056: sorry 5→5 · +6 geometric-backbone decls · PARTIAL · "Stub-1 backbone started; hard distributivity deferred"
- iter-057: sorry 5→5 · +6 decls · PARTIAL · "decomposed; coproduct_distrib_fibrePower deferred"
- iter-058: sorry 5→5 · +9 decls (4 distributivity leaves + Over-S helpers + prodFinSuccIso) · PARTIAL · "all bricks built; only assembly glue remains"
- iter-059: sorry 5→5 · +8 decls (overProd_coproduct_distrib + widePullback_coproduct_iso induction) · PARTIAL · "both distributivity build-targets proved; universe reduction remains"
- iter-060: sorry 5→4 · +3 decls · PARTIAL · "Stub 1 cechBackbone_left_sigma CLOSED axiom-clean via universe reduction"

Proposed iter-061 objective: build Stub 2 `pushPull_sigma_iso` (the single HARD disjoint-union
sheaf-decomposition new-infra leaf, ~200–400 LOC; standalone sub-lemma `pushPull_coprod_prod`
to be added to blueprint, then assembled). [prover-mode: mathlib-build]

## Route B — OpenImm (`AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`)
Need#1 open-immersion f_*-acyclicity leaf.
Strategy `Iters left` for this phase (P5a-consumer): ~2–4. Phase entered ~iter-054.

Signals:
- iter-057: sorry 3→3 · +4 decls (modulesIsoSpecExtTransport core) · PARTIAL · "Ext-transport core built"
- iter-059: sorry 3→3 (net, intentional factor +1 then) · +5 decls (homological half + ext_jShriekOU_eq_zero_of_specIso) · PARTIAL · "homological obstruction done; residual = hjt, hqc"
- iter-060: sorry 3→2 · +4 decls (jShriekOU_transport_along_iso) · PARTIAL · "hjt CLOSED; sole residual hqc = pushforward_iso_preserves_qcoh"

Proposed iter-061 objective: build `pushforward_commutes_restriction` (frontier-ready, blueprinted)
+ cover-transport helper + `pushforward_iso_preserves_qcoh`, close `hqc`. [prover-mode: mathlib-build]

Both routes' next nodes are decompose-first new-infra targets with precise handoffs already
blueprinted; neither is a re-throw of a monolith. Flag if you read either as CHURNING (helpers
accumulating without residual shrinking) given the just-closed keystones.
