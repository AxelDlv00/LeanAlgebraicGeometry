# Progress-critic directive — iter-193 route audit

You are auditing the planner's proposed iter-193 prover round against the
recent trajectory of each active route. Render CONVERGING / CHURNING /
STUCK / UNCLEAR per route with specific corrective recommendations.

## Iter-193 PROGRESS.md proposal — files + count

Proposed objectives this iter: **10** files (at the dispatch cap).
Basenames + per-file mode:

1. `RiemannRoch/WeilDivisor.lean` — `prove` mode (Lane I body after refactor)
2. `RiemannRoch/RationalCurveIso.lean` — `fine-grained` mode (Lane RCI)
3. `RiemannRoch/H1Vanishing.lean` — `mathlib-build` mode (Lane H II.1.16(b)/(c))
4. `Albanese/CodimOneExtension.lean` — `mathlib-build` mode (Lane M↓ Stage 5-6)
5. `Albanese/AuslanderBuchsbaum.lean` — `prove` mode, OFF-CRITICAL-PATH
6. `Picard/IdentityComponent.lean` — `mathlib-build` mode (Stacks 037Q substrate)
7. `Picard/QuotScheme.lean` — `prove` mode (Lane F additional residuals)
8. `Picard/Pic0AbelianVariety.lean` — `formalize` mode (NEW file-skeleton)
9. `Genus0BaseObjects/GmScaling.lean` — `prove` mode (Lane B chart_agreement)
10. `AbelianVarietyRigidity.lean` — `fine-grained` mode (Lane E
    `IsOpenImmersion.lift_uniq` route)

## Per-route trajectory signals (last K=4 iters: 189 → 192)

### Route A.3.i — `Picard/IdentityComponent.lean`
- STRATEGY.md row: "A.3.i — `GroupScheme.IdentityComponent`", Iters left
  `~3–6`, current phase entered iter-179.
- Sorry counts: iter-189 8 → iter-190 8 → iter-191 8 → iter-192 8.
- Helpers added: iter-189 +0 → iter-190 +0 → iter-191 +0 → iter-192 +2
  axiom-clean instances + 2-of-3 conjuncts of `baseChangeIso`.
- Prover statuses: iter-189 PARTIAL → iter-190 PARTIAL → iter-191 PARTIAL
  → iter-192 PARTIAL.
- Blocker phrases: "Stacks 04KU substrate genuinely missing", "Stacks
  037Q substrate not in Mathlib b80f227", "geometricallyConnected_of_connected_of_section
  NOT shipped (would worsen file metric)".

### Route Lane M↓ — `Albanese/CodimOneExtension.lean`
- STRATEGY.md row: "Lane M↓", Iters left `~6–12`, entered iter-190.
- Sorry counts: iter-189 3 → iter-190 3 → iter-191 3 → iter-192 3.
- Helpers added: iter-189 +0 → iter-190 +0 → iter-191 +2 (Stages 1-2)
  → iter-192 +2 (Stages 3-4) + in-body Stage 5 chain.
- Prover statuses: iter-189 — → iter-190 — → iter-191 PARTIAL → iter-192
  PARTIAL.
- Blocker phrases: "residual narrowed to 2-step Mathlib gap: cotangent
  ↔ Kähler over a field + smooth-algebra dim formula".

### Route Lane I — `RiemannRoch/WeilDivisor.lean` + `RationalCurveIso.lean`
- STRATEGY.md row: "Genus-0 RR.1 — Weil divisors", Iters left `~3–7`,
  entered iter-189.
- Sorry counts (WeilDivisor.lean): iter-189 3 → iter-190 3 (+1 from
  positivePart def) → iter-191 3 → iter-192 3.
- Sorry counts (RationalCurveIso.lean): iter-189 1 → iter-190 2 →
  iter-191 1 → iter-192 1.
- Helpers added (WeilDivisor): iter-190 +1 (positivePart def) →
  iter-191 +0 (plan-phase refactor) → iter-192 +1
  (`degree_positivePart_eq_sum_max`).
- Prover statuses: iter-189 PARTIAL → iter-190 PARTIAL → iter-191 — →
  iter-192 PARTIAL.
- Blocker phrases: iter-187+ "false-as-stated signature" (`poleDivisor`,
  resolved iter-190); iter-192 "the iter-191 equation-form signature is
  MATHEMATICALLY FALSE for arbitrary `t : K`" (Lane I main pin); iter-193
  plan-phase has dispatched a refactor adding the explicit local-parameter
  hypothesis (Option 1 / `Ring.ordFrac` shape) to make the body close-able.

### Route Lane RCI — `RiemannRoch/RationalCurveIso.lean`
- STRATEGY.md row: "Genus-0 RR.4", Iters left `~3–7`, entered iter-177
  for Pin 3 Step 2.
- Sorry counts: iter-189 1 → iter-190 2 (Lane I clash) → iter-191 1 →
  iter-192 1.
- Helpers added: iter-189 +1 (function-field iso Step 1) → iter-190 +0
  → iter-191 +0 → iter-192 +1 (`LocallyOfFiniteType φ.left` instance).
- Prover statuses: iter-189 PARTIAL → iter-190 PARTIAL → iter-191 — →
  iter-192 PARTIAL.
- Blocker phrases: "Pin 3 Step 2 sub-tasks (a)/(c)/(d) gated on Mathlib
  infrastructure", "helper budget = 1 prevented carving sub-task (a)",
  "iter-193 raise helper budget to 3".

### Route Lane H — `RiemannRoch/H1Vanishing.lean`
- STRATEGY.md row: "Genus-0 RR.2.H¹", Iters left `~6–10`, entered iter-191
  as a NEW file with 4-of-8 axiom-clean.
- Sorry counts: iter-191 3 (NEW file delta +3) → iter-192 3.
- Helpers added: iter-191 +4 (decls #1, #2, #6, #7) → iter-192 +4
  (`HModule_injective_finrank_eq_zero`, `injectiveSES` def +
  `injectiveSES_shortExact`, `ext_one_eq_zero_of_hom_surjective_of_injective`).
- Prover statuses: iter-191 PARTIAL (4-of-8 axiom-clean) → iter-192
  PARTIAL (4 substrate helpers axiom-clean; `HModule_flasque_eq_zero`
  body restructured around precise 2-case recipe).
- Blocker phrases: "the 2 named substrate helpers
  `Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque` (II.1.16(c)) +
  `Scheme.HModule_const_isSurj_of_shortExact_flasque_leftmost` (II.1.16(b))
  owed iter-193+".

### Route Lane F — `Picard/QuotScheme.lean`
- STRATEGY.md row: not a standalone phase (file is gated infrastructure).
- Sorry counts: iter-189 13 → iter-190 13 → iter-191 13 → iter-192 12 (−1).
- Helpers added: iter-189 +0 → iter-190 +0 → iter-191 +0 → iter-192 +0
  (closure under budget).
- Prover statuses: iter-189 PARTIAL → iter-190 PARTIAL → iter-191 — →
  iter-192 SUCCESS (HARD BAR MET via analogist recipe verbatim).

### Route Lane B — `Genus0BaseObjects/GmScaling.lean`
- STRATEGY.md row: "Genus-0 rigidity — chart-bridge", Iters left `~3–5`,
  entered iter-188.
- Sorry counts: iter-189 4 → iter-190 4 → iter-191 2 (−2) → iter-192 2.
- Helpers added: iter-189 +0 → iter-190 +0 → iter-191 +2 (consumer-side
  axiom-clean closures) → iter-192 +0 (API error — no edit landed).
- Prover statuses: iter-189 — → iter-190 — → iter-191 SUCCESS → iter-192
  ERROR (API socket closed mid-session, 29min in-session, 83 turns,
  ~12.9M cache-read tokens — no edit committed).
- Blocker phrases: "80-LOC budget wall has held 4+ iters", "long
  single-session prover dispatches not the right tactic", "split into
  GmS-A range-containment + GmS-B section-extraction sub-30-min sessions".

### Route Lane E — `AbelianVarietyRigidity.lean`
- STRATEGY.md row: "Genus-0 rigidity — chart-bridge", same as Lane B.
- Sorry counts: iter-189 2 → iter-190 2 → iter-191 1 (refactor) → iter-192 2.
- Helpers added: iter-189 +0 → iter-190 +1 (refactor Part 1) → iter-191 +0
  → iter-192 +1 (`iotaGm_chart1_appIso_eval` hook).
- Prover statuses: iter-189 PARTIAL → iter-190 SUCCESS Part 1 → iter-191
  PARTIAL → iter-192 PARTIAL.
- Blocker phrases: "same `Proj.appIso` residual STUCK iter-188/189/190/192",
  "simp loop on `Scheme.ΓSpecIso.eq_1` + `Scheme.SpecΓIdentity_app`
  interaction", "maximum recursion depth on constants-vs-generator split",
  "pursue `IsOpenImmersion.lift_uniq` route per iter-192 task report".

### Route Lane G — `Albanese/AuslanderBuchsbaum.lean`
- STRATEGY.md row: "A.4.b", Iters left `~6–12`, entered iter-184.
- Sorry counts: iter-189 4 → iter-190 3 → iter-191 2 → iter-192 1.
- Helpers added: iter-189 +2 → iter-190 +2 → iter-191 +1 → iter-192 +0
  (closure under budget via prime-avoidance; route iii Krull-intersection
  sketch empirically FALSIFIED in proof).
- Prover statuses: iter-189 PARTIAL → iter-190 PARTIAL → iter-191 PARTIAL
  → iter-192 SUCCESS (HARD BAR + PUSH-BEYOND).
- Blocker phrases (now stale; route nearly done): single residual is
  `auslander_buchsbaum_formula` (Stacks 090V, OFF-critical-path because
  `CohenMacaulay.of_regular` uses the direct regular-sequence path).

### Route Pic0AbelianVariety (NEW file iter-193)
- STRATEGY.md rows: A.3.iii / A.3.iv / A.3.v / A.3.vi / A.3.vii, all
  Iters left `~3–10`, all chapters landed iter-192 plan-phase ahead of
  Lean. iter-193 file-skeleton dispatch is FIRST prover assignment.
- Sorry counts: file does not exist; first iter assignment.
- Helpers / statuses: N/A (UNCLEAR by definition).

## Other context

- Project entered iter-193 prover phase at **77 sorries / 0 axioms**
  (12th consecutive zero-axiom build streak).
- The dispatch cap of 10 is fully used.
- Lane I + Lane RCI + Lane B trajectories are entangled: Lane I refactor
  adds +1 sorry to RationalCurveIso.lean (consumer typed-sorry for `?hlp`
  witness); Lane RCI (different sorry in the same file) still targets the
  Pin 3 Step 2 sub-tasks. Both can be dispatched in the same iter — the
  file has 1+1 = 2 sorries after the refactor lands.

## What you check

1. Per-route verdict per the rule (CONVERGING / CHURNING / STUCK / UNCLEAR).
2. For CHURNING / STUCK verdicts, name the corrective TYPE (blueprint
   expansion, Mathlib-idiom consult, structural refactor, route pivot).
3. The PROGRESS.md proposal's dispatch-sanity:
   - Are 10 lanes too many given the recent throughput?
   - Is any file proposed against a CHURNING/STUCK route without a
     corresponding corrective?
   - Are deep lanes (e.g. Lane I body close, Lane RCI Pin 3 Step 2) loaded
     with realistic substrate AND scope?
4. The mode choices:
   - Is `mathlib-build` correctly chosen for IdentityComponent (Stacks
     037Q substrate) and CodimOneExtension (Stage 5-6 substrate)?
   - Is `fine-grained` correctly chosen for RCI (sub-task carving) and
     Lane E (`IsOpenImmersion.lift_uniq` recipe is multi-step)?
   - Is `formalize` correctly chosen for Pic0AbelianVariety NEW file?

## Format

Per-route verdict block:

```
### <Route>
- Verdict: <CONVERGING / CHURNING / STUCK / UNCLEAR>
- Evidence: <one-line trajectory summary>
- Corrective (if CHURNING/STUCK): <one-line type + which catalog
  subagent>
```

Plus an overall dispatch-sanity block:

```
## Dispatch sanity
- Lane count: <10 — OK / TOO MANY / TOO FEW>
- Mode selection: <list any mismatches>
- Deep-lane scope: <list any under-scoped deep lanes>
```
