# Directive — progress-critic `route195`

## Active routes & extracted signals (K=4 iters: 191–194)

### Lane H — `RiemannRoch/H1Vanishing.lean`

Phase row: **Genus-0 RR.2.H¹ — skyscraper-flasque vanishing**.
STRATEGY.md `Iters left` = `~6–10`. Phase entered iter-191.
Elapsed iters: ~4.

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 3 | 4 | COMPLETE | iter-191 burst (4 of 8 decls axiom-clean) |
| 192 | 3 | 2 | PARTIAL | Hartshorne III.2.5 body push |
| 193 | 3 → 4 | 2 substrate | PARTIAL | substrate decomposition (4 axiom-clean substrate helpers) |
| 194 | 4 | 3 | PARTIAL | `forget₂` bridge; `Mono`+`Epi` axiom-clean inline; **single `SAb.Exact` residual** |

iter-195 plan agent proposing dispatch (this iter): YES — close
`SAb.Exact` direct attack [mathlib-build]. Highest-leverage closure
target.

### Lane I — `RiemannRoch/WeilDivisor.lean`

Phase row: **Genus-0 RR.1 — Weil divisors**.
STRATEGY.md `Iters left` = `~3–7`. Phase entered iter-192.
Elapsed iters: ~3.

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 3 | (positivePart substrate) | COMPLETE | substrate landing |
| 192 | 3 | 1 substrate `degree_positivePart_eq_sum_max` | PARTIAL | f = 0 branch close |
| 193 | 3 | 8 substrate helpers (signature-soundness regression flagged) | PARTIAL | signature corrective owed |
| 194 | 5 → 4 | 1 instance close + Y₀ destructure | PARTIAL | I.6.12 Hom.ofFunctionFieldEmbedding Mathlib gap |

iter-195 plan agent proposing dispatch (this iter): YES — substrate
cleanup contingent on lane #2 BareScheme close.

### Lane E — `AbelianVarietyRigidity.lean`

Phase row: **Genus-0 rigidity — chart-bridge (III.c separated-locus)**.
STRATEGY.md `Iters left` = `~5–8`. Phase entered iter-178.
Elapsed iters: ~16. **OVER_BUDGET flagged iter-194.**

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 4 | 1 helper | PARTIAL | iter-188-191 STUCK on Proj.appIso |
| 192 | 2 | 2 helpers | PARTIAL | iter-192 hook landed |
| 193 | 2 → 3 | route pivot to `IsOpenImmersion.lift_uniq` | PARTIAL | Mathlib-clean residuals |
| 194 | 3 | 0 new helpers; outer reasoning narrowing | INCOMPLETE (HARD BAR NOT MET) | same `Proj.appIso ⊤ .inv` evaluation residual remains |

iter-195 plan agent proposing dispatch (this iter): YES — build the
chart-1 `Proj.awayι.appIso ⊤ .inv` evaluation helper project-side
(~30-50 LOC) [mathlib-build]. Shares idiom blocker with Lane B.

### Lane F — `Picard/QuotScheme.lean`

Phase row: not a top-level STRATEGY.md phase; tracked under
**A.1.c — `RelPic functor`**. STRATEGY.md `Iters left` =
`~10–17`. Phase entered ~iter-185. Elapsed iters: ~10.

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 13 | 1 substrate | PARTIAL | aliasing-`let` recipe analogist landing |
| 192 | 13 → 12 | 1 close | COMPLETE | `pullback_of_openImmersion_iso_restrict` axiom-clean |
| 193 | 12 | 5-step sheaf-level iso chain | PARTIAL | LinearEquiv extraction residual |
| 194 | 12 | LinearEquiv steps a-c axiom-clean | INCOMPLETE (HARD BAR NOT MET) | step1/step2 opaque bodies block Beck-Chevalley |

iter-195 plan agent proposing dispatch (this iter): YES — Lane F
plan-phase refactor dispatched (Σ-pair reshape of step1/step2);
prover dispatched to consume the new identity for Beck-Chevalley.

### Lane B — `Genus0BaseObjects/GmScaling.lean`

Phase row: **Genus-0 rigidity — chart-bridge** (same as Lane E).
Elapsed iters: ~6.

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 4 | 4 helpers | PARTIAL | signature corrective [IsAlgClosed kbar] |
| 192 | 4 → 2 | session-end API error mid-search | INCOMPLETE | (no edit committed) |
| 193 | 2 | 3+ structural pieces axiom-clean | COMPLETE | closed-points reduction |
| 194 | 2 | 9 helpers (closed-points reduction full chain) | PARTIAL (HARD BAR MET; no closure) | per-closed-point `hCP_check` shares Lane E idiom |

iter-195 plan agent proposing dispatch (this iter): YES — cascade
close contingent on lane #3 chart-1 idiom helper.

### Lane RCI — `RiemannRoch/RationalCurveIso.lean`

Phase row: **Genus-0 RR.4 — rational ⟹ `≅ ℙ¹`**.
STRATEGY.md `Iters left` = `~20–26`. Phase entered iter-178.
Elapsed iters: ~16. **OVER_BUDGET flagged iter-194.**

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 1 | 1 instance | PARTIAL | LocallyOfFiniteType wiring |
| 192 | 1 | (skipped lane) | — | — |
| 193 | 1 → 3 | Pin 3 Step 2 substrate carving | PARTIAL | helpers (a)+(d) typed sorrys; (c) axiom-clean |
| 194 | 3 | 2 axiom-clean substrate helpers | PARTIAL (HARD BAR MET; no closure) | per-fibre LQF gap + IsNormalScheme gap |

iter-195 plan agent proposing dispatch (this iter): YES — close
`?hLPUnif` (L521); helper (a) per-fibre LQF push-beyond contingent
on BareScheme #2 closure.

### Lane G — `Albanese/AuslanderBuchsbaum.lean`

Phase row: **A.4.b — Auslander–Buchsbaum import**.
STRATEGY.md `Iters left` = `~6–12`. Phase entered iter-189.
Elapsed iters: ~5.

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 2 | 1 substrate close + 1 helper | PARTIAL | OFF-CRITICAL-PATH framing |
| 192 | 2 → 1 | route iii close | COMPLETE | `notMem_minimalPrimes_of_regularLocal_succ` axiom-clean |
| 193 | 1 → 2 (carving) | depth bridge + structural | PARTIAL | n=0 close gated on `depth(Fin k → R)` |
| 194 | 2 → 1 | 4 helpers + `Module.depth_pi_const_eq_depth_of_nonempty` | COMPLETE (n=0 closure) | n=k+1 multi-iter substrate work |

iter-195 plan agent proposing dispatch (this iter): NO — OFF-
CRITICAL-PATH; n=k+1 deferred.

### Lane A.3.i — `Picard/IdentityComponent.lean`

Phase row: **A.3.i — `GroupScheme.IdentityComponent`**.
STRATEGY.md `Iters left` = `~20–28`. Phase entered iter-180.
Elapsed iters: ~14. **OVER_BUDGET flagged iter-194; total proj
28-34 iters.**

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 5 | 1 instance | PARTIAL | A.3.i NEW LANE iter-191 |
| 192 | 7 | 2 helpers | PARTIAL | helpers without closure |
| 193 | 7 → 8 | 3 helpers + signature corrective | PARTIAL | 037Q gap |
| 194 | 8 → 9 (was 9 at exit) | instance demotion + body restructure | PARTIAL (HARD BAR MET; no closure) | Stacks 04KV + field-tensor-product Mathlib gaps |

iter-195 plan agent proposing dispatch (this iter): NO body close;
DO NOT redispatch.

### Lane M↓ — `Albanese/CodimOneExtension.lean`

Phase row: **Lane M↓ — `isRegularLocalRing_stalk_of_smooth`**.
STRATEGY.md `Iters left` = `~6–12`. Phase entered iter-185.
Elapsed iters: ~9. **STUCK protocol active iter-194.**

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 3 | (skipped) | — | Mathlib gap surface |
| 192 | 3 | 2 helpers Stage 5a/5b | PARTIAL | cotangent ↔ Kähler 2-step gap |
| 193 | 3 | 2 helpers | PARTIAL | Stages 5a/5b axiom-clean |
| 194 | 3 | 0 helpers (STUCK protocol respected) | PARTIAL (HARD BAR via precise gap surface) | Stacks 00OE + 02JK + 0AVF gaps |

iter-195 plan agent proposing dispatch (this iter): NO — STUCK;
iter-200 mathlib-analogist sweep covers.

### Lane A OCofP — `RiemannRoch/OCofP.lean`

Phase row: **Genus-0 RR.3 — `O_C(P)` global sections**.
STRATEGY.md `Iters left` = `~5–12`. Phase entered iter-184.
Elapsed iters: ~10.

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 191 | 3 | (skipped) | — | — |
| 192 | 3 | (skipped) | — | — |
| 193 | 3 | (skipped) | — | — |
| 194 | 3 | 2 substrate helpers (consumer body close) | PARTIAL | h1_vanishing_genusZero gated on Lane H |

iter-195 plan agent proposing dispatch (this iter): YES —
`h1_vanishing_genusZero` cascade contingent on lane #1 Lane H closure.

### Lane Pic0AV — `Picard/Pic0AbelianVariety.lean`

Phase row: **A.3.iii-vi Pic⁰ AV wrap**. NEW FILE iter-193.

| iter | sorries (file) | helpers added (file) | prover status | blocker phrases |
|---|---|---|---|---|
| 193 | 5 (NEW FILE) | file-skeleton | COMPLETE | carrier-soundness gated |
| 194 | 5 | (skipped per gating) | — | DEFERRED gated on carrier-soundness refactor |

iter-195 plan agent proposing dispatch (this iter): YES (cautious
re-engagement; explore-and-commit-partial).

## Iter-195 plan agent's `## Current Objectives` proposal

10 lanes (file basenames):

1. H1Vanishing.lean — Lane H SAb.Exact [mathlib-build] (CLOSURE)
2. BareScheme.lean — NEW LANE; smoothOfRelDim scaffold [mathlib-build] (CLOSURE)
3. AbelianVarietyRigidity.lean — Lane E chart-1 idiom [mathlib-build] (CLOSURE)
4. WeilDivisor.lean — Lane I substrate cleanup [prove]
5. GmScaling.lean — Lane B collapse-at-zero + idiom propagation [prove]
6. QuotScheme.lean — Lane F Beck-Chevalley intertwining [prove]
7. OCofP.lean — Lane A `h1_vanishing_genusZero` cascade [prove]
8. RationalCurveIso.lean — Lane RCI `?hLPUnif` close [prove]
9. Pic0AbelianVariety.lean — exploratory body close [prove]
10. RRFormula.lean — 1 residual cleanup [prove]

## Your job

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) plus
must-fix-this-iter findings if any. Pay particular attention to:

- Whether the iter-195 close-focused dispatch is correctly diagnosed
  as the corrective for the iter-194 "lazy" failure mode (structural
  narrowing without sorry-elimination).
- Whether the Lane Pic0AV cautious re-engagement is sound given the
  carrier-soundness commitment to iter-200.
- Whether 10 lanes is the right dispatch breadth — Lane I + Lane B +
  Lane A OCofP + Lane RCI all carry "contingent on another lane"
  framing. Is this a coupling risk?
