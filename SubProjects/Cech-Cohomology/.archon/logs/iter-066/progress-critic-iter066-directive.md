# Progress-critic directive — iter-066

Assess convergence of the two active prover routes. For each: last 5 iters' signals
(sorry counts, helpers added, prover status), the STRATEGY `Iters left` / phase-entry,
and the planner's proposed iter-066 objective. Verdict per route (CONVERGING / CHURNING
/ STUCK / UNCLEAR) + corrective type if not converging.

## Route A — P5a-resolution (`CechSectionIdentification.lean`, → `CechAugmentedResolution.lean`)
STRATEGY row: "P5a-resolution `cechAugmented_exact`", Status ACTIVE (OVER_BUDGET),
Iters left ~2–4, entered phase ~iter-053.

Signals (last 5 iters), CSI file sorry count + helpers + status:
- iter-061: 5→5, +helpers, PARTIAL (0 closed)
- iter-062: 5→4 region churn, PARTIAL (binary L2 node), 0 leaf-sorry closed
- iter-063: 4→4, +3 helpers, PARTIAL (0 closed; declined monolith near budget)
- iter-064: decompose pass — CLOSED the Option-step `coprodToProd_isIso_option`; sorry
  region 5→4; +10 helpers (deliberate decomposition; raw project total 9→12 by design)
- iter-065: CLOSED both induction leaves (`pushPull_coprod_prod_empty`,
  `coprodToProd_isIso_of_equiv`) → Stubs 2 & 4 cascaded axiom-clean; CSI 4→2
Recurring blocker phrases (now resolved): "erw vs rw projection matching"; "declined
monolith near budget" (iters 061–063, BROKEN by the iter-064 decompose+mode-switch).
Proposed iter-066 objective: CSI — close the 2 remaining sorries Stub 5
`cechSection_complex_iso` (1418) + Stub 6 `cechSection_contractible` (1477); both
frontier-ready, blueprint rated adequate by the iter-065 lvb checker. Default `prove`.

## Route B — P5a-consumer (`OpenImmersionPushforward.lean`)
STRATEGY row: "P5a-consumer `higherDirectImage_openImmersion_comp`", Status ACTIVE
(OVER_BUDGET), Iters left ~1–3, entered phase ~iter-056.

Signals (last 5 iters), OpenImm file sorry count + helpers + status:
- iter-061: 2→2, +helpers, PARTIAL (0 closed; ψ_r infra)
- iter-062: 2→2, +helpers, PARTIAL (0 closed; metavar wall on `[F.IsContinuous]`)
- iter-063: 2→2, +6 helpers, PARTIAL (slice equiv + continuity instances; 0 closed)
- iter-064: decompose pass — DECOMPOSED `case hqc` into 4 typed leaves, CLOSED 2 sub-lemmas
  + leftAdjointUniq half; sorry 2→5 by design
- iter-065: CLOSED the keystone φ'' (was a defeq, not the billed ~40–80 LOC wall) + H1/H2/
  pullbackIso cascade → `higherDirectImage_openImmersion_acyclic` FULLY sorry-free,
  axiom-clean (the project's sole open-immersion-acyclicity milestone, DONE); OpenImm 5→4.
  The 4 remaining sorries are all in the STRETCH `_comp` (hacyc/eRes/hexact/transport).
Recurring blocker phrases (now resolved): "[F.IsContinuous] metavar wall" (iters 060–062,
BROKEN iter-063); "φ'' object-relabel iso ~40–80 LOC wall" (iters 061–064, dissolved
iter-065 — it was definitional).
Proposed iter-066 objective: OpenImm — close `_comp`'s 4 sub-sorries
(hacyc/eRes/hexact/transport, 974/979/982/985). The planner has REWRITTEN the route for
the dominant `hacyc`: the in-file/blueprint "Serre vanishing on the affine U∩f⁻¹V" path
is flawed (U∩f⁻¹V not affine; restriction-of-injectives wall); replaced by "pushforward j
preserves injectives (right adjoint of mono-preserving pullback j) ⟹ j_* Iⁿ injective ⟹
f_*-acyclic via the existing IsRightAcyclic.ofInjective instance". hexact = `_acyclic` on H;
eRes = left-exact augmentation; transport mechanical. Default `prove`, gated behind a
blueprint-writer rewrite + fast-path re-review THIS iter.

## Question
Is each route CONVERGING after the iter-064/065 breakthroughs? Is the proposed iter-066
dispatch the right move, or is there a churn risk on the NEW sub-goals (CSI Stubs 5/6;
OpenImm `_comp`)? Flag if either proposed lane looks like it will re-churn.
