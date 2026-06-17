# Directive: progress-critic route192

You are the iter-192 plan-phase convergence critic. Assess per-route
progress over the last 3-5 iters and return a verdict per route:
CONVERGING / UNCLEAR / CHURNING / STUCK.

## Active routes — last-K-iters signals

### Lane G — `Albanese/AuslanderBuchsbaum.lean` (Stacks 00NQ)

- **Iters left (STRATEGY.md A.4.b)**: ~8–14; elapsed in phase: ~5 iters.
- Sorry trajectory by iter:
  - 188: 2 sorries
  - 189: 2 sorries (substrate narrowed; 3 helpers axiom-clean)
  - 190: 2 sorries (base + `x ∉ 𝔭` axiom-clean)
  - 191: 2 sorries (1 helper axiom-clean + 1 typed-sorry helper isolates Stacks 00NQ)
- Helpers added per iter: 188 (0), 189 (3), 190 (2), 191 (2)
- Status: PARTIAL each iter; no closures of the headline; substrate always narrowing.
- Recurring blocker: `x ∈ 𝔭 ↔ (x) ∈ minimalPrimes R` — needs Stacks 00NQ
  domain conclusion.
- iter-191 unlock: route (iii) (zero-divisor + Krull intersection) is
  now available via the `exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`
  helper.

### Lane E — `AbelianVarietyRigidity.lean` (`iotaGm_chart1` body)

- **Iters left (STRATEGY.md Genus-0 rigidity III.c)**: ~3–5; elapsed: ~5.
- Sorry trajectory: 188 (3) → 189 (3) → 190 (3) → 191 (2) [iter-190 closed `iotaGm_r_1_range_subset`].
- Helpers added per iter: 188 (3), 189 (1), 190 (2), 191 (1 — refactor only).
- Status: STUCK on Part 2 body close — same `Proj.appIso` residual 4 iters running.
- Recurring blocker: `IsOpenImmersion.lift_app` reachable after refactor
  via `unfold`, but `Proj.appIso` evaluation step on the chart-1
  basic open exceeds budget.
- iter-191: Part 1 refactor axiom-clean; Part 2 deferred at 80 LOC budget wall.

### Lane I — `RiemannRoch/RationalCurveIso.lean` (degree-1 iso)

- **Iters left (STRATEGY.md Genus-0 RR.4)**: ~5–9; elapsed: ~6.
- Sorry trajectory: 188 (3) → 189 (3) → 190 (3, integration RED) → 191 (1 post-refactor).
- iter-191 plan-phase refactor `lane-i-positivepart-clash-fix` reshaped
  the signature equation form. Body is now ready for iter-192 close.

### Lane F — `Picard/QuotScheme.lean`

- **Iters left (STRATEGY.md A.2.b)**: ~75–150; elapsed: ~10.
- Sorry trajectory: 188 (13) → 189 (13) → 190 (13) → 191 (13, DROPPED).
- iter-191 mathlib-analogist consult: PROCEED with aliasing-`let`
  workaround for HSMul resolution on `restrict_obj`.
- iter-192 dispatch SCHEDULED.

### Lane B-consumers — `Genus0BaseObjects/GmScaling.lean`

- **Iters left (STRATEGY.md Genus-0 rigidity)**: ~3–5; elapsed: ~3.
- Sorry trajectory: 188 (4) → 189 (4) → 190 (4) → 191 (2; −2 via Substrate 2 + bypass route).
- HARD BAR met iter-191. Lane B-consumers CONVERGING.

### Lane A — `RiemannRoch/OCofP.lean` (downstream of RR.2.H¹)

- **Iters left (STRATEGY.md RR.3)**: ~7–15; elapsed: ~4.
- Sorry trajectory: 188 (4) → 189 (3) → 190 (3) → 191 (3, no dispatch).
- 3 remaining sorries gated on RR.2.H¹ body (Lane H).

### Lane H — `RiemannRoch/H1Vanishing.lean` (NEW iter-191)

- **Iters left (STRATEGY.md RR.2.H¹)**: ~8–12; elapsed: 1 (NEW file).
- Sorry trajectory: 191 (3 from 7 file-skeleton, prover closed 4 in dispatch).
- iter-191 outcome: 4 axiom-clean closures via direct route bypassing
  decls (3) and (5). Headline #8 inherits sorryAx through #4.
- Status: CONVERGING (UNCLEAR — fresh route, 1 iter).

### Lane M↓ — `Albanese/CodimOneExtension.lean` (Stacks 00TT)

- **Iters left (STRATEGY.md Lane M↓)**: ~8–15; elapsed: 1.
- Sorry trajectory: 191 (3, first scaffold; Stages 1-2 axiom-clean re-exports).
- Status: UNCLEAR (fresh first dispatch).

### Lane A.3.i — `Picard/IdentityComponent.lean`

- **Iters left (STRATEGY.md A.3.i)**: ~3–6; elapsed: ~6.
- Sorry trajectory: 188 (5) → 189 (5) → 190 (5) → 191 (8, HALTED — analogist consult).
- iter-191 mathlib-analogist verdict: substrate OWNED in Mathlib at
  `Geometrically/Connected.lean:100`; ONLY project-side gap is
  `geometricallyConnected_of_connected_of_section` (Stacks 04KU,
  ~80-120 LOC) + `grpObjMkPullbackSnd` plumbing.
- iter-192 prover SCHEDULED.

## Iter-192 proposed objectives (the planner is considering)

The planner is preparing to dispatch ~7-10 prover lanes. User hint:
push HARD for ambitious progress — bottom-up mathlib build, use
`mathlib-build` and `fine-grained` modes more aggressively, encourage
provers to close beyond the HARD BAR.

Candidate list (subject to your route verdicts):

1. `H1Vanishing.lean` — close 1-2 of (`IsFlasque.constant_of_irreducible`, `HModule_flasque_eq_zero`, `skyscraperSheaf_eq_pushforward_const`) [fine-grained]
2. `WeilDivisor.lean` — close `degree_positivePart_principal_eq_finrank` body [prove]
3. `CodimOneExtension.lean` — Stages 3-4 (Stacks 00TT chain) [mathlib-build]
4. `QuotScheme.lean` — apply aliasing-let recipe + Step 3 close [prove]
5. `IdentityComponent.lean` — build `geometricallyConnected_of_connected_of_section` [mathlib-build]
6. `AuslanderBuchsbaum.lean` — route (iii) close [fine-grained]
7. `AbelianVarietyRigidity.lean` — Part 2 body close with chapter expansion [prove]
8. `GmScaling.lean` — `gmScalingP1_chart_agreement_cross01` close [prove]
9. `RationalCurveIso.lean` — close `degree_positivePart_principal_eq_finrank` consumer body [prove]
10. `RRFormula.lean` — close `H1_skyscraperSheaf_finrank_eq_zero` body [prove]

## Required output

Per-route verdict (CONVERGING / UNCLEAR / CHURNING / STUCK) with
corrective TYPE (blueprint expansion / Mathlib-idiom consult /
structural refactor / route pivot) when CHURNING or STUCK.

Dispatch-sanity check: is the proposed file-count too aggressive
given the user hint to push HARD on bottom-up Mathlib build? Any
file you would drop or re-mode?

Report to `task_results/progress-critic-route192.md`.
