# Progress-critic directive — slug `route196`

## Active routes to assess

I am planning iter-196. Last iter's prover dispatch fanned out 8 lanes;
6 returned `done`, 2 ERRORED on API 529 with no edits. Net sorry
delta: 88 → 86 (−2). Below are per-route signals over the last 4 iters
(K=4).

For each, return CONVERGING / CHURNING / STUCK / UNCLEAR + corrective
type if needed. The plan agent will act on must-fix.

---

### Route: Lane H — `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`

- iter-192: 4 → 4 (PARTIAL; structural).
- iter-193: 3 → 4 (PARTIAL; +1 sanctioned helper carve).
- iter-194: 4 → 4 (PARTIAL; structural; `SAb.Exact` typed surface).
- iter-195: 4 → 3 (CLOSURE; `shortExact_app_surjective` axiom-clean via
  `sheafCompose_preservesFiniteLimits` instance — LEFT-half limit
  preservation suffices, NOT full `PreservesHomology`).
- Helpers added per iter: 2 / 2 / 0 / 1.
- Prover status: PARTIAL / PARTIAL / PARTIAL / done (closure).
- Blockers: iter-192-194 "SAb.Exact resists"; iter-195 cleared via
  `Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono`.
- Strategy phase: `Genus-0 RR.2.H¹ — flasque vanishing`. STRATEGY says
  `Iters left: ~6-10`, entered current phase iter-184 (12 elapsed).
- Iter-196 candidate work: residual sorries are Tier-3 substrate
  (`IsFlasque.constant_of_irreducible` L138, `IsFlasque.injective_flasque`
  L572 needs `j_!` extension-by-zero ~100-150 LOC Mathlib gap,
  `skyscraperSheaf_eq_pushforward_const` L760).

---

### Route: Lane BareScheme — `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`

- iter-195: 2 → 2 (ERROR; API 529 mid-mathlib-scouting; NO edits).
- Helpers added: 0.
- Prover status: error (not a mathematical failure; API exhaustion).
- HARD GATE cleared iter-195 fastpath; recipe analogist-confirmed.
- Strategy phase: belongs under `Genus-0 RR.4 — rational ⟹ ≅ ℙ¹`
  (cascade unlocks Lane I instance #2 + Lane RCI helper (a)).
- Iter-196 dispatch is mandatory re-attempt.

---

### Route: Lane E — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

- iter-191: 3 → 3 (PARTIAL).
- iter-192: 3 → 3 (PARTIAL).
- iter-193: 3 → 3 (PIVOT to `IsOpenImmersion.lift_uniq`; PARTIAL).
- iter-194: 3 → 3 (PARTIAL).
- iter-195: 3 → 3 (ERROR; API 529 after 3.5 min; NO edits).
- Helpers added per iter: 2 / 2 / 3 / 2 / 0.
- Prover status: PARTIAL × 4 then error.
- Persistent recipe in `analogies/lane-e-proj-appiso-pivot.md` —
  3-helper, ~30-50 LOC port via `Proj.awayι_app_basicOpen` mirroring
  Mathlib's `IsAffineOpen.fromSpec_app_self`.
- Strategy phase: `Genus-0 rigidity — chart-bridge (III.c separated)`.
  STRATEGY says iter-195 ANALOGUE_FOUND; `Iters left: ~2-4`.

---

### Route: Lane I — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

- iter-192: 3 → 3 (PARTIAL).
- iter-193: 3 → 3 (PARTIAL; 8 substrate helpers).
- iter-194 plan: refactor v2 reshape 3 → 5 sanctioned (signature pin).
- iter-194: 5 → 4 (CLOSURE; one of two typeclass instances closed).
- iter-195: 4 → 4 (PARTIAL; +1 kernel-clean Finsupp helper; 3 axiom-
  clean body sub-steps on `degree_positivePart_principal_eq_finrank`;
  `instIsRegularInCodimOneProjectiveLineBar` body opened).
- Helpers added per iter: 8 / 2 (plan) / 0 / 1.
- Prover status: PARTIAL / PARTIAL / done (closure) / PARTIAL.
- **lean-auditor iter-195 must-fix**: L746 instance with `:= sorry`
  propagates sorryAx silently — demote to private theorem.
- Strategy phase: `Genus-0 RR.1 — Weil divisors`. STRATEGY says
  `Iters left: ~3-7`, realized ~10/it.

---

### Route: Lane A — `AlgebraicJacobian/RiemannRoch/OCofP.lean`

- iter-193: 3 → 3 (gated on Lane H).
- iter-194: 3 → 3 (PARTIAL; 2 new substrate helpers; consumer bodies
  sorry-free transitively).
- iter-195: 3 → 3 (PARTIAL; 6 axiom-clean substeps inside
  `exists_nonconstant_rational_from_dim_eq_two`; residual = 3 named
  sub-claims with concrete recipes).
- Helpers added per iter: 0 / 2 / 0.
- Prover status: PARTIAL × 3.
- Strategy phase: `Genus-0 RR.3 — O_C(P) sections`. STRATEGY says
  `Iters left: ~5-12`.

---

### Route: Lane F — `AlgebraicJacobian/Picard/QuotScheme.lean`

- iter-193: 12 → 12 (PARTIAL).
- iter-194: 12 → 12 (PARTIAL; LinearEquiv extraction Steps a-c
  inline).
- iter-195 plan: refactor `lane-f-step12-sigma-pair` LANDED (+0).
- iter-195: 12 → 12 (PARTIAL; Stage 1 of 6 Beck-Chevalley landed
  axiom-clean; (N1)-(N4) substrate gaps named).
- Helpers added per iter: 0 / 0 / 1 (refactor) / 0.
- Prover status: PARTIAL × 3.
- Plan-phase LOC estimate iter-195: "~10-30 LOC" vs actual ~100-150 LOC.
- Strategy phase: A.2.b (file-skeleton; stalled).

---

### Route: Lane RCI — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

- iter-193: 1 → 3 (+2 sanctioned helper carve).
- iter-194: 3 → 3 (PARTIAL).
- iter-195: 3 → 3 (1:1 inline → named-helper swap; HARD BAR NOT
  technically met — tactic-experiments dead per `Classical.arbitrary`/
  `tauto`/`exact?`).
- Helpers added per iter: 2 / 2 / 1.
- Prover status: PARTIAL × 3.
- Strategy phase: `Genus-0 RR.4 — rational ⟹ ≅ ℙ¹`. STRATEGY says
  OVER_BUDGET (16 elapsed); `Iters left: ~20-26`. Pin 3 carving.

---

### Route: Lane G — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

- iter-193: 1 → 2 (case split + new helper).
- iter-194: 2 → 1 (CLOSURE; n=0 branch axiom-clean via
  `Module.depth_pi_const_eq_depth_of_nonempty`).
- iter-195: 1 → 1 (PARTIAL; n=k+1 inductive step carved into
  `auslander_buchsbaum_formula_succ_pd` with 4-piece iter-196+ slice
  ordering).
- Helpers added per iter: 1 / 4 / 1.
- Prover status: PARTIAL / done / PARTIAL.
- Strategy phase: A.4.b OFF-CRITICAL-PATH; STRATEGY says
  `Iters left: ~6-12`.

---

## Proposed iter-196 prover objectives (≤10 files)

The planner proposes 8 lanes:

1. **`RiemannRoch/WeilDivisor.lean`** — Lane I Route 2 (affine-chart
   k̄[t] PID transfer ~50-80 LOC) for `isRegularInCodimOneProjectiveLineBar`
   POST-demotion.
2. **`Genus0BaseObjects/BareScheme.lean`** — re-dispatch Lane BareScheme
   (analogist-confirmed recipe; API-529-failed iter-195).
3. **`AbelianVarietyRigidity.lean`** — Lane E re-dispatch
   (analogist-confirmed recipe; API-529-failed iter-195).
4. **`Picard/QuotScheme.lean`** — Lane F (N1)-(N4) close POST-refactor.
5. **`RiemannRoch/OCofP.lean`** — Lane A toFunctionField injectivity
   chain (~30-50 LOC).
6. **`RiemannRoch/H1Vanishing.lean`** — Lane H Tier-3 substrate
   (no critical path; OFF-CRITICAL-PATH candidate).
7. **`RiemannRoch/RationalCurveIso.lean`** — Lane RCI helper (a) per-fibre
   LQF (gated on BareScheme cascade).
8. **`Picard/FGAPicRepresentability.lean`** — carrier-soundness refactor
   FIRST SLICE (Option A `Functor.IsRepresentable`).

Plus 3 instance-demotion refactors (not prover lanes; plan-phase tasks):
WeilDivisor.lean:746, Thm32RationalMapExtension.lean:194,
AlbaneseUP.lean:183.

## What I want from you

Per-route verdict (CONVERGING/CHURNING/STUCK/UNCLEAR) with a
sentence-length rationale and (when CHURNING or STUCK) the corrective
TYPE you recommend (blueprint expansion / mathlib idiom consult /
structural refactor / route pivot / scope reduction). Then sanity-check
the proposed 8 lanes: any obvious churn, any over-loading, any STUCK
escalation I am missing.
