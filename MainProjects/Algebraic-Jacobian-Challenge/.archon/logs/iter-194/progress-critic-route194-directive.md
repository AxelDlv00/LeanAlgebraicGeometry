# Progress critic directive — route194

You are dispatched for the iter-194 plan-phase per-route convergence
audit. You see ONLY the signals named below — no STRATEGY.md, no
blueprint chapters, no full iter-sidecar text.

## Active routes — last K = 4 iters' signals

K = 4 (iter-190 → iter-193). Project-wide sorry counts per iter:
- iter-190 end: 79
- iter-191 end: 80
- iter-192 end: 77 (−3)
- iter-193 end: 87 (+10, of which +5 is the new Pic0AbelianVariety
  file-skeleton, +5 sanctioned typed sorries on substrate)
- iter-194 plan-phase: 87 (entering)

### Route I — `RR/WeilDivisor.lean`

Phase: Genus-0 RR.1 Weil divisors (Hartshorne II.6.9).
STRATEGY.md `Iters left` (last estimate iter-193 plan-phase): ~3–7.
Entered current phase: iter-187.

Sorry trajectory (file-local):
- iter-190: 4
- iter-191: 4
- iter-192: 3 (−1; `rationalMap_order_finite_support` `f=0` branch closed)
- iter-193: 3 (helpers landed; body unchanged; **CRITICAL signature finding**)

Helpers per iter:
- iter-190: 1 (`positivePart` def + pin)
- iter-191: 0 (Lane I clash fix + body sorry intact)
- iter-192: 1 (`degree_positivePart_eq_sum_max`)
- iter-193: 8 (`principal_apply`, `positivePart_single`, `degree_single`,
  `one_le_degree_positivePart_principal_of_order_one`, `degree_zero`,
  `degree_add`, `Scheme.RationalMap.order_one`, `principal_one`)

Prover statuses: iter-190 PARTIAL → iter-191 PARTIAL → iter-192 PARTIAL
(structural advance) → iter-193 PARTIAL (HARD BAR MET, CRITICAL FINDING:
signature still false).

Recurring blocker phrases: "signature mathematically false" (iter-192
first surfaced, iter-193 second counter-witness surfaced); "Hartshorne
II.6.9 substrate gap" (genuine).

### Route H — `RR/H1Vanishing.lean`

Phase: Genus-0 RR.2 H¹ skyscraper-flasque vanishing (Hartshorne III.2.5).
STRATEGY.md `Iters left`: ~6–10. Entered: iter-190 (new file).

Sorry trajectory:
- iter-190: 0 (NEW file iter-191)
- iter-191: 4 (new-file landing: 4 of 8 decls direct-route closures)
- iter-192: 3 (−1; body chain via 4 axiom-clean substrate helpers)
- iter-193: 4 (+1 sanctioned; 2 new substrate helpers + body chained;
  HARD BAR EXCEEDED ×2 + PUSH-BEYOND MET)

Helpers per iter:
- iter-191: 4 (file-skeleton)
- iter-192: 4 (`HModule_injective_finrank_eq_zero`, `injectiveSES` def,
  `injectiveSES_shortExact`, `ext_one_eq_zero_of_hom_surjective_of_injective`)
- iter-193: 2 (`ext_succ_eq_zero_of_injective_of_lower_zero`,
  `IsFlasque.cokernel_of_shortExact_flasque_flasque`)

Prover statuses: iter-191 COMPLETE (file-skeleton; 4 closures) →
iter-192 PARTIAL (structural advance) → iter-193 PARTIAL (HARD BAR
exceeded ×2 + PUSH-BEYOND met).

Blocker phrases: "Hartshorne II Ex 1.16(b)" + "Hartshorne III Lemma 2.4"
(genuine substrate gaps; iter-194 prover phase will continue).

### Route M↓ — `Albanese/CodimOneExtension.lean`

Phase: Stacks 00TT smooth-stalk regular.
STRATEGY.md `Iters left`: ~6–12. Entered: iter-191 (first scaffold).

Sorry trajectory:
- iter-190: 3 (file pre-existing)
- iter-191: 3 (Stages 1-2 axiom-clean; substrate)
- iter-192: 3 (Stages 3-4 axiom-clean)
- iter-193: 3 (Stages 5a+5b axiom-clean; 0 headline-sorry closures)

Helpers per iter:
- iter-191: 2 (`Flat.stalkMap` + `Smooth.exists_isStandardSmooth` re-exports)
- iter-192: 2 (`exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`
  + `module_free_kaehlerDifferential_of_isStandardSmooth`)
- iter-193: 2 (`module_free_kaehlerDifferential_localization` +
  `rank_kaehlerDifferential_localization_eq_relativeDimension`)

Prover statuses: iter-191 PARTIAL (HARD BAR MET) → iter-192 PARTIAL →
iter-193 PARTIAL (HARD BAR PARTIAL, PUSH-BEYOND NOT MET).

Blocker phrases: "Stacks 00OE smooth-algebra dim formula" + "Stacks
02JK cotangent ↔ Kähler over a field" (both Mathlib gaps; genuine).

### Route E — `AbelianVarietyRigidity.lean`

Phase: Genus-0 chart-bridge III.c separated-locus.
STRATEGY.md `Iters left`: ~7–10 (iter-193 OVER_BUDGET re-est).
Entered: iter-178. Elapsed in phase: ~16 iters.

Sorry trajectory:
- iter-190: 2
- iter-191: 2 (Lane E refactor `proj-appiso-expand` blueprint-writer
  added paragraph)
- iter-192: 2 (Lane E Part 1 axiom-clean refactor; Part 2 deferred)
- iter-193: 3 (+1 sanctioned; `IsOpenImmersion.lift_uniq` route
  eliminates Proj.appIso STUCK; new residual targets cleaner)

Helpers per iter:
- iter-191: 0 (refactor)
- iter-192: 1 (`iotaGm_chart1_appIso_eval` blueprint-named hook)
- iter-193: 3 (`kbarChart1Ring` def, `iotaGm_r_1_eq_specMap` conditional,
  consumer refactor via `simp only`)

Prover statuses: iter-190 PARTIAL → iter-191 PARTIAL → iter-192 PARTIAL
→ iter-193 PARTIAL (HARD BAR MET; route pivot from Proj.appIso to
`IsOpenImmersion.lift_uniq` completed).

Blocker phrases: "Proj.appIso simp loop" (4-iter STUCK; ELIMINATED
iter-193 via route pivot). New blocker phrases (post-pivot):
"kbarChart1Ring_specMap_fac via `Proj.fromOfGlobalSections_morphismRestrict`"
+ "pullback collapse via `pullbackSpecIso`" — both Mathlib-clean.

### Route F — `Picard/QuotScheme.lean`

Phase: A.4.a / A.2.b helper supplies.
STRATEGY.md `Iters left`: ~unsubstantial (off-priority).
Entered: iter-185.

Sorry trajectory:
- iter-190: 13
- iter-191: 13
- iter-192: 12 (−1; `pullback_of_openImmersion_iso_restrict`
  axiom-clean closure)
- iter-193: 12 (sheaf-level 5-step iso chain landed; LinearEquiv
  extraction residual)

Helpers per iter:
- iter-191: 0
- iter-192: 1 (aliasing-let recipe applied)
- iter-193: 0 (substantive structural advance only; LinearEquiv
  extraction residual)

Prover statuses: iter-191 PARTIAL → iter-192 COMPLETE (HARD BAR met
via Lane F −1) → iter-193 PARTIAL (HARD BAR NOT MET; structural advance).

Blocker phrases: "LinearEquiv extraction" + "Beck-Chevalley intertwining"
(iter-193 surfaced; iter-194 follow-up).

### Route A.3.i — `Picard/IdentityComponent.lean`

Phase: GroupScheme.IdentityComponent + geometricallyConnected_of_connected_of_section.
STRATEGY.md `Iters left`: ~14–20 (iter-193 OVER_BUDGET re-est, was 3–6).
Entered: iter-180. Elapsed in phase: ~14 iters.

Sorry trajectory:
- iter-190: 8
- iter-191: 8
- iter-192: 8 (2 NEW axiom-clean instances; baseChangeIso 2 of 3 conjuncts)
- iter-193: 9 (+1 sanctioned; `geometricallyConnected_of_connected_of_section`
  + 3 axiom-clean section helpers + private instance derived)

Helpers per iter:
- iter-191: 0
- iter-192: 2 instances
- iter-193: 3 (section helpers + sorry-bodied lemma + private instance)

Prover statuses: iter-191 PARTIAL → iter-192 PARTIAL → iter-193 PARTIAL
(HARD BAR MET via second option — sanctioned sorry-body helper landed).

Blocker phrases: "Stacks 037Q substrate gap" (Mathlib gap; project-side
~30-50 LOC build sanctioned iter-193+) + "Stacks 04KU helper landing
gates downstream" (genuine).

### Route B — `Genus0BaseObjects/GmScaling.lean`

Phase: Genus-0 chart-bridge III.c.
STRATEGY.md `Iters left`: ~7–10. Entered: iter-188.

Sorry trajectory:
- iter-190: 2
- iter-191: 2
- iter-192: 2 (API socket error mid-session; no edit)
- iter-193: 2 (3+ axiom-clean structural pieces; HARD BAR MET; no
  headline closure)

Helpers per iter:
- iter-191: 0
- iter-192: 0 (session-error; no commit)
- iter-193: 3+ (QSS chain on PLB + pullback; QuasiCompact s_pair;
  cocycle-from-factorization)

Prover statuses: iter-191 PARTIAL → iter-192 ERROR (session-end API) →
iter-193 PARTIAL (HARD BAR MET).

Blocker phrases: "topological range containment via closed-points
density" (iter-193 surfaced; iter-194 prover).

### Route RCI — `RR/RationalCurveIso.lean`

Phase: Genus-0 RR.4 rational ⟹ ℙ¹ (Pin 3 Step 2).
STRATEGY.md `Iters left`: ~16–22 (iter-193 OVER_BUDGET re-est).
Entered: iter-178. Elapsed: ~16 iters.

Sorry trajectory:
- iter-190: 1
- iter-191: 1
- iter-192: 1 (`LocallyOfFiniteType φ.left` instance landed)
- iter-193: 3 (+2 sanctioned — Pin 3 Step 2 carving into helpers (a) +
  (c) + (d); helper (c) AXIOM CLEAN via Mathlib re-export; (a) + (d)
  typed sorrys)

Helpers per iter:
- iter-191: 0
- iter-192: 1 instance
- iter-193: 3 named helpers (1 axiom-clean, 2 typed-sorry)

Prover statuses: iter-191 PARTIAL → iter-192 PARTIAL → iter-193 PARTIAL
(HARD BAR MET via carving + 1 axiom-clean helper closure).

Blocker phrases: "Smooth-dim-1 morphism ⟹ fibre 0-dim" (helper a) +
"Smooth-curve normalisation iso" (helper d) — both Mathlib substrate
gaps, project-side helper budget = 3 in iter-194+.

### Route G — `Albanese/AuslanderBuchsbaum.lean`

Phase: A.4.b Auslander-Buchsbaum import. OFF-CRITICAL-PATH per iter-193
PROGRESS.md.
STRATEGY.md `Iters left`: ~6–12. Entered: iter-185.

Sorry trajectory:
- iter-190: 2
- iter-191: 2 (route iii unlocked, Krull-intersection sketch)
- iter-192: 1 (−1; prime-avoidance closure of
  `notMem_minimalPrimes_of_regularLocal_succ`)
- iter-193: 1→2 (raw tokens) (1 axiom-clean helper +
  `auslander_buchsbaum_formula` 2-branch case split with 7 substantive
  kernel-clean n=0 steps; residual = `depth(R^k) = depth(R)`)

Helpers per iter:
- iter-191: 1
- iter-192: 1 (prime-avoidance)
- iter-193: 1 (`Module.depth_eq_of_linearEquiv`, kernel-clean ~50 LOC)

Prover statuses: iter-191 PARTIAL → iter-192 COMPLETE (route iii landed
via prime-avoidance) → iter-193 PARTIAL (HARD BAR MET, structural
advance).

Blocker phrases: "minimal finite free resolutions" + "Stacks 00MF
'what is exact'" + "snake lemma on resolutions" (substrate gaps;
multi-iter).

### Route Pic0AV — `Picard/Pic0AbelianVariety.lean`

Phase: A.3.iii–vii Pic⁰ abelian variety wrap.
STRATEGY.md `Iters left`: ~6–10 (sum over 5 decls).
Entered: iter-193 (NEW file).

Sorry trajectory:
- iter-190: N/A
- iter-191: N/A
- iter-192: N/A (chapter landed plan-phase; no Lean file)
- iter-193: 0 → 5 (NEW file-skeleton with 5 typed sorries)

Helpers per iter: N/A (new file).

Prover statuses: iter-193 COMPLETE (file-skeleton; HARD BAR MET).

Blocker phrases: gated on `Pic0Scheme := sorry` + `PicScheme := sorry`
(carrier soundness). Iter-194 dispatch DEFERRED (gating on
FGAPicRepresentability + IdentityComponent fixes upstream).

## PROGRESS.md proposed objectives for iter-194

The plan agent proposes 10 prover lanes for iter-194:

1. `RR/WeilDivisor.lean` — Lane I body close (post refactor v2)
   [fine-grained]
2. `RR/H1Vanishing.lean` — Lane H substrate (Hartshorne II.1.16(b) +
   III.2.4 helpers) [mathlib-build]
3. `Albanese/CodimOneExtension.lean` — Lane M↓ Stage 6 (Stacks 00OE +
   02JK) [mathlib-build]
4. `AbelianVarietyRigidity.lean` — Lane E final 2 closures
   (`kbarChart1Ring_specMap_fac` + `pullback collapse`) [prove]
5. `Picard/QuotScheme.lean` — Lane F LinearEquiv extraction [prove]
6. `Genus0BaseObjects/GmScaling.lean` — Lane B topological range
   containment [prove]
7. `Picard/IdentityComponent.lean` — Lane A.3.i Stacks 037Q project-side
   + instance demotion [mathlib-build]
8. `RR/RationalCurveIso.lean` — Lane RCI helper (a)
   `phi_left_locallyQuasiFinite_of_finrank_one` [mathlib-build]
9. `Albanese/AuslanderBuchsbaum.lean` — Lane G n=0 branch substrate
   (`depth(R^k) = depth(R)`) [prove]
10. `RR/OCofP.lean` — Lane A first body push [prove]

## What you check

For each active route above:
1. Render a verdict CONVERGING / CHURNING / STUCK / UNCLEAR + brief
   rationale.
2. If CHURNING or STUCK, name the corrective TYPE (blueprint expansion,
   Mathlib-idiom consult, structural refactor, route pivot,
   strategy-fork decision).
3. Cross-route check: are any two routes blocking each other? Is any
   route's progress secretly downstream of another's stuck state?
4. **Iter-by-iter throughput check.** Some routes carry STRATEGY.md
   `Iters left` estimates much smaller than elapsed-in-phase iters
   (E: 7–10 left, 16 elapsed; RCI: 16–22 left, 16 elapsed; A.3.i:
   14–20 left, 14 elapsed). Flag any that look fantasy.
5. **Dispatch-sanity** on the 10-lane proposal:
   - Are any lanes assigned to files that are likely to be blocked
     by the refactor's blast radius?
   - Are any lanes assigned to "stuck for ≥3 iters with cosmetic
     recipe variation" patterns?
   - Are any lanes assigned to files whose blueprint chapter is
     CHURNING with the lane (i.e. blueprint expansion needed first)?

## Outputs

Write your report to `.archon/task_results/progress-critic-route194.md`.

Render:
1. One verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR).
2. For each CHURNING or STUCK: corrective type + recommended subagent.
3. Cross-route findings.
4. Dispatch-sanity verdict on the 10-lane proposal: any lane to drop
   / re-mode / re-direct.
