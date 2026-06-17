# Progress Critic Report

## Slug
ts237

## Iteration
237

## Routes audited

### Route: Picard group-law critical path — `Vestigial.lean` (d.2 → whiskering wiring)

- **Sorry trajectory**: Vestigial.lean has had 1 sorry (line 299, `isLocallyInjective_whiskerLeft_of_W`) throughout iters 233–236. StalkTensor.lean maintained 0 sorries across all 4 infrastructure iters; `stalkTensorIso` is confirmed assembled and sorry-free at StalkTensor.lean:505–541. The absolute critical-path sorry count has been unchanged since iter-217, but this is BY DESIGN: the multi-iter StalkTensor build was zero-sorry infrastructure; the Vestigial sorry is the consumer that was waiting for d.2 to complete.
- **Helper accumulation**: 27 total axiom-clean decls across iters 233–236 (7 + 4 + 10 + 6), all in StalkTensor.lean. 0 helpers added in Vestigial.lean. All helpers are legitimate prerequisites: the progression stages (i)→(ii)→(iii)→(iv)→(v) are a natural bottom-up construction with each stage feeding the next. No helper fragmentation or padding detected.
- **Prover dispatch pattern**: 1 file dispatched each iter (StalkTensor), all COMPLETE.
- **Recurring blockers**: "carrier-duality wall (CommRingCat vs RingCat)" appeared in iter-234 and iter-236 reports, retired with a named recipe each time. It is NOT a stuck signal — it is a local resolution pattern: the approach surfaces the same carrier-level friction at different stages, names it, and applies the `germ_smul`/`erw`/`RingEquiv` recipe. The phrase appears in the RESOLUTION narrative, not as an ONGOING blocker.
- **Avoidance patterns**: None. The lane has had a prover every iter (233–236); no "off-critical-path" reclassifications; no deferral language on this sub-lane.
- **Prover status pattern**: COMPLETE, COMPLETE, COMPLETE, COMPLETE.
- **Throughput**: ON_SCHEDULE — STRATEGY.md: "Iters left ~4–7" for A.1.c.SubT; phase entered ~iter-232; elapsed ~5 iters (iters 232–236). The d.2 sub-phase completed within estimate.
- **Verdict**: **CONVERGING**

**Rationale for CONVERGING despite 20-iter frozen sorry count.** The directive flags that the critical-path sorry count has not dropped since iter-217. Under strict sorry-trajectory analysis this looks alarming. It is not: StalkTensor.lean was built without introducing any sorries (a zero-sorry infrastructure build), and the SOLE consumer sorry (`isLocallyInjective_whiskerLeft_of_W`, Vestigial.lean:299) has been waiting specifically for d.2 to complete. d.2 is now done. The next iter is the FIRST iter at which the consumer sorry is fireable; it is NOT the 20th iteration of failing to close it. The iter-237 work (d.1-bridge + wiring `stalkTensorIso` into the sorry) is a bounded two-component task:

1. **d.1-bridge** (`J.W g → ∀x, IsIso(stalk map)` on `Opens X`): Vestigial.lean:267–298 names the Mathlib pieces (`HasEnoughPoints`, `W_iff`, or `WEqualsLocallyBijective` + stalk criteria); the general-site decl is UNPROTECTED so specialisation to `Opens X` is free. This is ~20–50 LOC assembly, not novel infrastructure.
2. **Wiring `stalkTensorIso`**: the sorry comment at Vestigial.lean:299 gives the complete proof sketch (`stalkLinearMap_bijective_of_isIso` + `LinearEquiv.lTensor`); `stalkTensorIso` supplies the d.2 ingredient; this is ~30–50 LOC.

The transition from multi-iter zero-sorry infrastructure to sorry-consumer is a healthy, convergent continuation.

---

### Route: A.2.c engine — `FlatBaseChange.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 across iters 233–236. The 2 sorries are `affineBaseChange_pushforward_iso` (line 348) and `flatBaseChange_pushforward_isIso` (line 370); neither has changed.
- **Helper accumulation**: iter-234: 0 decls (STUCK); iter-235: 0 decls (structural-reset corrective executed, no prover output); iter-236: 3 axiom-clean decls (`globalSectionsIso_hom_comp_specMap_appTop`, `gammaPushforwardIso`, `gammaPushforwardTildeIso`) — the Γ-fragment wall resolved; iter-237: not yet run.
- **Prover dispatch pattern**: 1 file dispatched each iter since re-engagement. iter-234 STUCK (carrier-instance wall, 0 commits); iter-235 STUCK (structural-reset iter, 0 commits on prover; corrective = Mathlib-idiom consult + soundness fix); iter-236 RE-ENGAGED (3 axiom-clean decls, UNCLEAR/fresh verdict).
- **Recurring blockers**: "carrier wall / not synthesizable" appeared in iter-234 and iter-235 (2 iters). RESOLVED iter-236 via the element-free `restrictScalarsComp'App` + `eqToIso` route. Does NOT appear in iter-236 output. 2 iters, not ≥3 — the phrase does not reach the recurring-blocker threshold, and was resolved by a genuine structural fix (not cosmetic).
- **Avoidance patterns**: None. The route was dispatched every iter since seeding; the iter-235 "STUCK corrective" round was a structural-reset iter (soundness fix + proof-route overhaul), not avoidance.
- **Prover status pattern**: NOT_DISPATCHED (iter-233, seeding only), STUCK/0-commit (iter-234), STUCK/0-commit (iter-235), PARTIAL→RE-ENGAGED/3-decls (iter-236).
- **Throughput**: ON_SCHEDULE — STRATEGY.md: "Iters left ~30–60" for A.2.c-engine; phase seeded ~iter-233; elapsed ~4 iters. Well within estimate.

**Verdict assessment — borderline STUCK vs. UNCLEAR.** The strict STUCK sub-rule "helpers added without any sorry-elimination across K iters" technically fires: in the K=4 window (iters 233–236), iter-236 added 3 helpers and no sorry was eliminated. However, applying this rule mechanically here produces a misleading verdict for two reasons:

1. The iter-235 structural reset was a GENUINE approach change, not cosmetic churn. The iter-234/235 STUCK pattern used a completely different proof route (element-level `LinearEquiv.toModuleIso` with carrier manipulations); iter-236 adopted the element-free route (b) and executed it axiom-clean. This is not the "same wall re-approached N times" pattern; it is approach A (iter-234/235, genuinely stuck) → structural reset (iter-235 corrective) → approach B (iter-236, first successful step).

2. The new approach (route (b)) has < K iters of data: only iter-236 (1 iter). The UNCLEAR condition — "route is fresh (< K iters of data) OR signals are ambiguous" — applies to the post-reset approach. Calling it STUCK when the new approach has had exactly 1 successful iter would conflate a failed route with its replacement.

- **Verdict**: **UNCLEAR** (with a STRICT-STUCK notation below and a WATCH mandate)

**STRICT-STUCK notation**: Under a mechanical application of the "helpers added without sorry-elimination across K=4 iters" rule, this route is STUCK. I am calling UNCLEAR rather than STUCK because the < K iters of post-reset data condition takes precedence — the approach genuinely reset in iter-235, making the K-iter sorry window span two materially different proof strategies. If the sorry count does not decrease in iter-237 (i.e., `affineBaseChange_pushforward_iso` remains sorry), the STUCK signal re-fires at full strength and must be acted on.

**WATCH mandate**: iter-237 is the last chance before STUCK re-fires definitively. The iter-236 Γ-fragment (3 decls) was the FINAL helper; the iter-237 task should close at minimum `pushforward_spec_tilde_iso` AND `affineBaseChange_pushforward_iso`. A zero-sorry-closure round in iter-237 re-triggers STUCK regardless of the new-approach argument.

**The path to sorry closure is clear**: `pushforward_spec_tilde_iso` via `isIso_of_isIso_app_of_isBasis` + `IsLocalizedModule` (route (iii), described in FlatBaseChange.lean:231–243); then `affineBaseChange_pushforward_iso` via `isIso_of_isIso_app_of_isBasis` + `cancelBaseChange` + the Γ-fragment isos (FlatBaseChange.lean:329–347 gives the full sketch). Both Mathlib ingredients are available; the blueprint chapter is written. There is no KNOWN blocker remaining.

---

## PROGRESS.md dispatch sanity

Verdict: **OK** — file count 2, within cap 10; no under-dispatch finding (remaining lanes are HELD or gated on A.1.c.SubT completion or on `def:higher_direct_image`; no additional files with both complete blueprint chapters and open sorries exist outside the dispatch cap).

---

## Must-fix-this-iter

**None required for Route 1 (CONVERGING).**

For Route 2 (UNCLEAR with STRICT-STUCK notation):

> **Route FlatBaseChange — WATCH / STRICT-STUCK**: sorry count 2→2→2→2 across 4 iters; strict STUCK rule ("helpers added without sorry-elimination across K iters") fires mechanically; UNCLEAR verdict granted only because < K iters of data exist for the post-reset approach. **The planner must treat iter-237 as a hard sorry-closure commitment.** If `affineBaseChange_pushforward_iso` is not closed in iter-237, STUCK re-fires with no further UNCLEAR reprieve, and the primary corrective becomes **User escalation** (no new Mathlib consult or blueprint expansion is available — both were executed iter-235/236; the remaining block would be unknown infrastructure). The prover should NOT add more Γ-fragment helpers; all prerequisites are in place; the sole task is assembling the sorry-clean brick and closing the theorem.

---

## Informational

**Route 1 — note on the "20-iter frozen sorry count" framing.** The directive explicitly asks whether the absolute critical-path sorry counter not dropping since iter-217 is a churn signal. It is not. The StalkTensor build was a zero-sorry infrastructure task (each of its 27 decls is a non-sorry-pinned proof); the CONSUMER sorry (`isLocallyInjective_whiskerLeft_of_W`) has been in Vestigial.lean throughout, waiting for the d.2 ingredient. iter-236 completed the ingredient. iter-237 is the first iter at which the consumer can fire. A sorry count frozen during a zero-sorry prerequisite build and now ready to drop is CONVERGING, not CHURNING.

---

## Overall verdict

**1 CONVERGING route, 1 UNCLEAR route (strict STUCK rule noted), 0 avoidance findings, dispatch OK.**

Route 1 (Vestigial.lean) is in clean convergent shape: the 4-iter d.2 infrastructure build completed on schedule, `stalkTensorIso` is assembled and sorry-free, and the sole consumer sorry has its two wiring components (d.1-bridge ~30–50 LOC; stalkTensorIso application ~30–50 LOC) both well-specified. The iter-237 prover should close it in one round.

Route 2 (FlatBaseChange.lean) cleared its structural blocker in iter-236 (3 axiom-clean Γ-fragment decls, carrier wall resolved). The iter-237 prover has a clear path: `pushforward_spec_tilde_iso` via `isIso_of_isIso_app_of_isBasis` + `IsLocalizedModule`, then `affineBaseChange_pushforward_iso` via `cancelBaseChange`. The planner should treat iter-237 as a hard commitment to sorry-closure on this lane; failing to close `affineBaseChange_pushforward_iso` this iter re-triggers STUCK with no further UNCLEAR reprieve available. No corrective dispatches are needed in plan-phase — both blueprint and Mathlib consults are already done.
