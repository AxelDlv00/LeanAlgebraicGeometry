# Progress Critic Report

## Slug
route198

## Iteration
198

## Routes audited

### Route: Lane WD-A4a — `WeilDivisor.lean` L249 (`rationalMap_order_finite_support` non-zero branch)

- **Sorry trajectory**: File-level 4 → 4 → 4 → 4 → 3 (iter-193 to iter-197). L249 specifically: unchanged at 1 sorry throughout (only the L249 non-zero branch; L538 and L1108 are Route C / off-limits and one adjacent sorry was closed in iter-197 by unrelated `hy_ne_bot` work).
- **Helper accumulation**: iter-195 added 1 generic Finsupp helper (not A.4.a). iter-196 performed an instance-demotion refactor (not A.4.a). No A.4.a-specific helper has been added at any iter.
- **Prover dispatch pattern**: Zero dispatches on the L249 non-zero branch across all 5 iters. This is the first iter with L249 on the objectives list.
- **Recurring blockers**: None cited specifically for L249. Prior prover work was routed to L538 and L1108 (Route C).
- **Avoidance patterns**: None — prior non-dispatch was correct (Route C framing had L249 assigned to Lane I / Route C; Route A framing is genuinely new this iter).
- **Prover status pattern**: N/A (no prior dispatch on this specific target).
- **Throughput**: ON_SCHEDULE — phase entered iter-198; strategy estimate ~3–6 iters; elapsed = 0 prior iters in Route A framing.
- **Verdict**: UNCLEAR — Fresh lane. No trajectory data on the L249 non-zero branch under Route A. The iter-192 f=0 branch closure confirms the file infrastructure is in place and the prover has worked in this declaration. The mathematical target (Stacks 02RV / Hartshorne II.6.1: finitely many height-1 primes divide a nonzero rational function on a Noetherian regular-in-codim-1 integral scheme) has a known Mathlib path via the `Noetherian.finiteMinimalPrimes` API. **Proceed and watch iter-198 outcome.**

---

### Route: Lane AB — `AuslanderBuchsbaum.lean` L1131 (`auslander_buchsbaum_formula_succ_pd` n=k+1)

- **Sorry trajectory**: 2 → 1 → 1 → 1 → 1 (iter-193 to iter-197). The single remaining sorry (L1131) has been unchanged for 4 iters (iter-194 through iter-197).
- **Helper accumulation**: iter-195 added structural carving (4-piece slice documentation in the docstring of `auslander_buchsbaum_formula_succ_pd`, named `auslander_buchsbaum_formula_succ_pd` itself carved as a typed-sorry substrate-gap helper). No actual sorry-closing helper was added in iters 195–197.
- **Prover dispatch pattern**: 0 dispatches in iters 195, 196, 197 — 3 consecutive iters with zero prover dispatches on this route. This exactly meets the CHURNING plan-phase-only meta-pattern threshold.
- **Recurring blockers**: "Off-critical-path" in iter-194 docstring + iter-196 non-dispatch + iter-197 non-dispatch. "Why OFF-CRITICAL-PATH" language persists in the file itself (L1106–L1114). The file comment explicitly says the AB formula is not gating A.4.a.
- **Avoidance patterns**: The route was reclassified "off-critical-path" in iter-194 and that status persisted through iter-197 (3 iters) with no re-engagement plan in the proposals for iters 195–197. The carving in iter-195 was a plan-only action (no prover dispatch followed).
- **Prover status pattern**: 0 dispatches iters 193–197 on the n=k+1 branch (iter-193 only dispatched the n=0 branch).
- **Throughput**: SLIPPING — Strategy estimate ~6–12 iters from iter-195 (phase entered). Elapsed prior to iter-198: 3 iters with no dispatch. The "iter-196 first slice (depth-drops-by-one)" documented in the re-engagement plan (L1088–1100) was never executed.
- **Verdict**: CHURNING — 3 consecutive iters of zero dispatch after the carving in iter-195, with "off-critical-path" avoidance persisting ≥2 iters. The planned 4-piece substrate work (depth-drops-by-one → minimal-resolution carving → snake lemma → "what is exact") has seen zero prover rounds since the plan was written.
- **Primary corrective**: Dispatch initiated — iter-198 plan correctly promotes this to priority-1 and assigns it as Objective #2 with a concrete 4-piece recipe. The CHURNING verdict is resolved **prospectively** by the iter-198 dispatch. However: flag that the 4-piece substrate (especially pieces (2) and (3)) is multi-iter. A single prover round is unlikely to close all of L1131. The sorry will likely still be present after iter-198; iter-199 should plan for the residual.

---

### Route: Lane RPF — `RelPicFunctor.lean` (6 sorries: L235, L287, L328, L373, L433, L482)

- **Sorry trajectory**: 6 → 6 → 6 → 6 → 6 (iter-193 to iter-197). Unchanged for 5 consecutive iters and for all prior iters since iter-176 file creation.
- **Helper accumulation**: Zero helpers added across all 5 iters.
- **Prover dispatch pattern**: 0 dispatches across all 5 iters. This is 5 consecutive iters with zero prover dispatches — significantly above the CHURNING plan-phase-only meta-pattern threshold of ≥3.
- **Recurring blockers**: "gated on A.1.b `LineBundle.OnProduct` typed sorry" and "iter-177+ Block B" appear across all 5 iters. These are the stated reason for non-dispatch.

**Critical finding on the gate:**
The gate as stated in the RelPicFunctor.lean comments and planner rationale is stale. `LineBundlePullback.lean` has been **closed (0 code-level sorries) since iter-188** — confirmed by inspecting the file directly. `LineBundle.OnProduct` is now a concrete definition (`{ M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M }`, LineBundlePullback.lean L130), and `RelPicPresheaf.preimage_subgroup` is a concrete (non-sorry) definition at L349. Both gate conditions cited in RelPicFunctor.lean L228–235 are resolved.

The planner claims "A.1.a closed → gate gone" but the actual gate was A.1.b (LineBundlePullback), closed at iter-188. The planner has operated under stale gate assumptions for **10 iters** (iter-188 to iter-197).

**Secondary finding on L235 gate:**
The iter-198 plan correctly excludes L235 from scope ("DO NOT touch L235 `exact sorry`") but gives the wrong reason: "gated on `LineBundle.OnProduct` typed sorry (iter-199+)." The actual residual gate on L235 is the **tensor-product `AddCommGroup` structure** on `LineBundle.OnProduct`. LineBundlePullback.lean has no `AddCommGroup` instance, no tensor product defined (confirmed by inspecting the file; the comment at L344–346 explicitly notes Mathlib at b80f227 has no monoidal structure on `Scheme.Modules`). This is a genuine Mathlib upstream gap that remains open.

**Key insight:** The functor-builder sorries L287, L328, L373, L433, L482 can be filled axiom-cleanly-modulo-L235 by using the sorry `addCommGroup` instance (declared at L205–235) as a scaffold. This would reduce the file from 6 sorries to 1 (only L235 remains). The prover dispatches in iters 195–197 could have accomplished this; they were withheld based on a stale gate characterization.

- **Avoidance patterns**: Same deferral phrase ("gated; no dispatch") persisting across all 5 iters. Gate on A.1.b resolved at iter-188; non-dispatch in iters 189–197 (9 iters!) on functor-builder sorries that were in principle closeable using the sorry `addCommGroup` scaffold.
- **Prover status pattern**: N/A (no dispatches).
- **Throughput**: SLIPPING — Strategy estimate ~6–10 iters from iter-198 (first dispatch). But the functor-builder pieces (L287-L482) have been closeable for ~10 iters; only L235 requires the Mathlib tensor-product gap to close.
- **Verdict**: CHURNING — 5-iter (≥3) plan-phase-only meta-pattern. Gate was stale since iter-188. Functor-builder sorries (L287-L482) were closeable using the sorry `addCommGroup` scaffold for 10 iters but were never dispatched.
- **Primary corrective**: Dispatch initiated — iter-198 plan correctly targets L287-L482. But the planner should update the file comments: L235's gate is NOT "LineBundle.OnProduct typed sorry" (that sorry is gone) but the tensor-product `AddCommGroup` structure on `LineBundle.OnProduct`, which is a Mathlib-b80f227 gap. The prover dispatched to L287-L482 can close 5 of 6 sorries using the sorry `addCommGroup` instance; iter-199 should plan for L235 closure when tensor-product lands.

---

### Route: Lane COE — `CodimOneExtension.lean` (3 sorries: L526, L723, L798)

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 (iter-193 to iter-197). Unchanged for 5 consecutive iters.
- **Helper accumulation**: iter-193 added Stage 5a + 5b axiom-clean helpers (adjacent to Stage 6 but not closing it). Zero helpers added in iters 194–197.
- **Prover dispatch pattern**: 0 dispatches in iters 194, 195, 196, 197. The route was EXCISED from STRATEGY.md in iter-196 and remained excised through iter-197.
- **Recurring blockers**: "Stage 6 Stacks 00OE gap" appears across all post-iter-193 signals. "Lane M↓ EXCISED" appears in iter-196 and iter-197.
- **Avoidance patterns**:
  - "EXCISED" route status in iter-196 AND iter-197 — 2 consecutive iters with a stronger-than-off-critical-path reclassification (excision = complete removal from STRATEGY) with no re-engagement plan. This satisfies the STUCK "same deferral phrase persisting ≥2 consecutive iters" rule.
  - The excision in iter-196 was specifically triggered by the difficulty of Stage 6 Stacks 00OE. But Stage 5a/5b had been closed axiom-clean in iter-193, demonstrating the file infrastructure works.
- **Prover status pattern**: PARTIAL (iter-193, Stage 5a/5b) → no dispatch × 4 iters.
- **Throughput**: SLIPPING → OVER_BUDGET — Strategy estimate ~2–4 iters for Stage 6 close; phase entered iter-193 (or iter-187 for the wider route). Elapsed with no Stage 6 dispatch: 5 iters. Over budget by at least 1×.

**Was the iter-196 excision sound?**
No — it was a premature sunk-cost giveaway. The route had:
1. Clear mathematical structure (Stacks 00OE: `dim S_q = dim R_p + trdeg`, the smooth algebra dimension formula)
2. Working file infrastructure (Stage 5a/5b closed axiom-clean in iter-193)
3. A concrete recipe (standard-smooth-of-relative-dimension → stalk is regular local of dimension n)
4. Only one substantive gap: the Krull-dim formula for smooth stalks at the Mathlib pinned commit

The excision removed a route with a clear remaining gap and a working build. The USER directive's re-elevation is correct.

- **Verdict**: STUCK — "EXCISED" deferral persisting across ≥2 consecutive iters; sorry count unchanged across K iters; recurring blocker "Stage 6 Stacks 00OE gap" across ≥3 iters (iter-193, iter-194, iter-195).
- **Primary corrective**: Dispatch initiated — iter-198 plan correctly re-elevates to priority-2 and assigns Stage 6 as Objective #4. BUT: the docstring at L509–526 says this gap is "~300-500 LOC" and "Iter-200+ tracked". This is a multi-iter engagement. One prover round will not close it. A **blueprint expansion** is needed for Stage 6 to scope out the sub-gaps precisely (smooth-algebra Krull-dim formula API, cotangent-sequence-over-a-field bridges) before the prover is sent in.
- **Secondary corrective**: Blueprint expansion — expand the CodimOneExtension chapter's Stage 6 section to list sub-gaps and their Mathlib API status (exists/missing/needs-bridge) before iter-199's prover dispatch.

---

### Route: Lane FGA — `FGAPicRepresentability.lean` (7 sorries)

- **Sorry trajectory**: 7 → 7 → 7 → 7 → 7 (iter-193 to iter-197). Unchanged for 5 consecutive iters and since the file's creation.
- **Helper accumulation**: iter-196 performed a structural refactor (`carrier-soundness-fgapic` landing, isolating sorries to `⟨sorry⟩` instances). Zero sorry closures.
- **Prover dispatch pattern**: 0 dispatches across all 5 iters. The iter-196 refactor was a plan-phase structural action (no prover dispatch).
- **Recurring blockers**: "carrier-soundness probe", "`HasPicScheme C` + consumers" across iters 196–197. The probe has been running for 2 iters (iter-196 refactor + iter-197 smoke check scheduled).
- **Avoidance patterns**:
  - ≥3 consecutive iters with zero prover dispatches: iters 193–197 = 5 iters. CHURNING by plan-phase-only meta-pattern.
  - The "probe" (iter-196/197) is architectural validation without a sorry-closure target. This is a legitimate structural step IF followed by a concrete sorry-closure plan; without that, it is plan-phase iteration without prover engagement.
- **Prover status pattern**: N/A (no dispatches in the K-iter window).
- **Throughput**: OVER_BUDGET — Strategy estimate ~12–16 iters from iter-196. Zero prover dispatches so far (elapsed = 2 iters on probe meta-work, 0 iters on sorries). The 12–16 iter estimate assumes prover rounds are being spent; currently none are.
- **Verdict**: CHURNING — 5 consecutive iters with zero prover dispatches. The carrier-soundness probe is structural meta-work; it does not count as a prover dispatch and produces no sorry closure.

**Is the abort criterion well-defined?**
Partially. The stated criterion is "`lean_verify` on `[HasPicScheme C]` consumers confirms carrier-soundness option A propagates correctly." This is a reasonable architectural gate for the `⟨sorry⟩` isolation approach, but it is NOT a sorry-closure criterion. After the probe confirms (or reverts), the sorry count will still be 7 (or possibly higher on revert). The probe has no sorry-closure payoff without a subsequent plan naming:
1. Which sorry closes first (the most likely candidate is L354 `representable` body)
2. What Mathlib infrastructure is required (QuotScheme representability? Grothendieck topology? Both?)
3. Whether any of the 6 `⟨sorry⟩` instances are closeable before L354

Without (1)–(3), the iter-198 "abort verdict" resolves architecture but leaves the CHURNING pattern intact.

- **Primary corrective**: Blueprint expansion — before any further probe meta-work, expand the FGA chapter to produce a sorry-by-sorry closure order (which sorry is first, what it requires). The architectural probe result should feed INTO that chapter expansion, not replace it. A 5-iter sorry stall on a 7-sorry file with no dispatch plan is not a "probe" — it is avoidance.

---

### Route: Lane T32 — `Thm32RationalMapExtension.lean` (L155 only; L294 gated)

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 2 (iter-193 to iter-197). Unchanged.
- **Helper accumulation**: Zero new helpers in the K-iter window (iter-196 named-sorry demotion was not a sorry closure).
- **Prover dispatch pattern**: 0 dispatches across all 5 iters ("standing deferral").
- **Recurring blockers**: L294 gated on CodimOneExtension Stacks 00TT (standing). L155 was never dispatched even though its gate (Stacks 034V) is independent of COE.
- **Avoidance patterns**: "Standing deferral" persisting across ≥5 iters. L155 (`isReduced_of_smooth_over_field`) has been actionable since iter-196 when it was carved as a named typed-sorry (Stacks 034V: smooth over reduced base is reduced; ~30-80 LOC estimate in the iter-198 plan).
- **Verdict**: CHURNING — 5 consecutive iters of "standing deferral" with zero prover dispatch on L155, which is independent of any open gate.
- **Primary corrective**: Dispatch initiated — iter-198 plan correctly includes L155 as Objective #5 (stretch goal; helper budget = 1). This is the right call. L155 is a self-contained single sorry with a clear Stacks reference. **Is this lane worth a lane?** Yes — 30–80 LOC to close `av_isIntegral_of_smooth_geomIrred` cascade axiom-cleanly is well within a single prover round. The cascade payoff (av_isIntegral closes axiom-clean once L155 closes) justifies the dispatch.

---

## PROGRESS.md dispatch sanity

- **File count**: 5 (WeilDivisor, AuslanderBuchsbaum, RelPicFunctor, CodimOneExtension, Thm32RationalMapExtension)
- **Cap**: ~10 (default)
- **Ready but not dispatched**: `FGAPicRepresentability.lean` (7 sorries, deferred pending carrier-soundness probe verdict — stated rationale exists). No other Route A ready files omitted without rationale.
- **Over the cap**: No (5 ≤ 10)
- **Under-dispatch finding**: FGA deferred for a stated architectural reason; gap = 1 file. Below the ≥3-file threshold for a must-fix finding. Acceptable this iter.
- **Iter-over-iter trend**: N/A (this is the first iter under Route A framing; no prior dispatch baseline to compare against).
- **Verdict**: OK — file count 5 within cap 10; FGA deferred for stated reason; no other ready files identified as absent.

**Note on RelPicFunctor dispatch scope:** The plan excludes L235 from scope while dispatching L287-L482. This is coherent: L235's gate (tensor product `AddCommGroup`) is a genuine Mathlib-b80f227 gap, and L287-L482 CAN be filled using the sorry `addCommGroup` scaffold. The scope fence is defensible; the gate-reason annotation in the plan is wrong (see Lane RPF findings above), but the dispatch itself is correct.

---

## Must-fix-this-iter

- **Lane AB (AuslanderBuchsbaum L1131)**: CHURNING — 3 consecutive no-dispatch iters after iter-195 carving. Primary corrective: **dispatch initiated** (iter-198 Objective #2 correct). Residual: the 4-piece substrate (depth-drops-by-one, minimal-resolution, snake lemma, "what is exact") is multi-iter; plan iter-199 for the residual regardless of iter-198 outcome.

- **Lane RPF (RelPicFunctor)**: CHURNING — 5-iter plan-phase-only meta-pattern. Gate was stale since iter-188 (LineBundlePullback closed 10 iters ago). Primary corrective: **dispatch initiated** (iter-198 Objective #3 correct for L287-L482). Required action this iter: update the gate annotation in RelPicFunctor.lean L228–235 and in the objectives document — the L235 gate is the **tensor-product `AddCommGroup` gap**, not `LineBundle.OnProduct` (which is no longer sorry).

- **Lane COE (CodimOneExtension L526)**: STUCK — "EXCISED" deferral ≥2 iters; sorry count unchanged 5 iters; recurring blocker ≥3 iters. Primary corrective: **dispatch initiated** (iter-198 Objective #4 correct). Required action this iter: **blueprint expansion** for Stage 6 sub-gaps (smooth-algebra Krull-dim API + cotangent-sequence bridges) to scope the multi-iter commitment before the prover arrives. Without this, the prover will encounter the ~300-500 LOC gap cold.

- **Lane FGA (FGAPicRepresentability)**: CHURNING — 5-iter zero-dispatch meta-pattern. Primary corrective: **blueprint expansion**. The iter-198 probe verdict (confirm/revert carrier-soundness) is a necessary but insufficient step. The plan for iter-199 must include a sorry-by-sorry closure order (which sorry first, what it requires), not just an architectural verdict. If no sorry in the file is closeable without major Mathlib upstream work, **user escalation** is warranted to decide whether FGA stays in scope or is explicitly deferred out-of-scope.

- **Lane COE: OVER_BUDGET** — STRATEGY.md estimates ~2–4 iters for Stage 6 close; elapsed (no Stage 6 dispatch) = 5+ iters. Revise the estimate in STRATEGY.md to ~4–8 iters for Stage 6, reflecting the sub-gap complexity documented in the file.

---

## Informational

- **Lane WD-A4a**: UNCLEAR with positive signal. The f=0 branch (iter-192) closes axiom-clean from the same declaration, confirming the mathematical environment is in place. The `Noetherian.finiteMinimalPrimes` route (or the `Finset.toSet_finite`-based height-1-prime finiteness path) is the natural Mathlib-build target. No special concern; observe iter-198 outcome.

- **Lane T32 (L155)**: CHURNING resolved by iter-198 dispatch. L155 is the right priority-3 stretch: it's bounded, has a clear Stacks reference, and the cascade payoff (`av_isIntegral_of_smooth_geomIrred` recovers axiom-cleanliness) is meaningful. Note L294 remains gated on COE Stage 6 close; do not plan L294 until iter-198 Lane COE outcome is known.

- **Gate-annotation hygiene (RPF/LineBundlePullback)**: The RelPicFunctor.lean file contains multiple comments asserting `LineBundle.OnProduct` is "a typed sorry in A.1.b" (e.g., L88, L201, L228). These are all stale. A plan-phase cleanup of these comments (without touching proof bodies) would prevent future prover confusion about the gate state.

---

## Overall verdict

3 of 6 routes (Lane AB, Lane RPF, Lane T32) are CHURNING; 1 (Lane COE) is STUCK; 1 (Lane FGA) is CHURNING with no iter-198 dispatch resolution; 1 (Lane WD-A4a) is UNCLEAR (fresh lane). The iter-198 plan's 5-lane dispatch addresses AB, RPF, COE, and T32 correctly, resolving their CHURNING/STUCK verdicts prospectively. The critical residual is **Lane FGA**: after 5 iters with zero sorry closure, the carrier-soundness probe result alone does not constitute a progress plan. Iter-199 must arrive with a concrete sorry-by-sorry closure order for FGA or an explicit user-directed out-of-scope decision. The planner has also been operating under a stale gate characterization for Lane RPF for 10 iters — the L235 gate annotation must be corrected to name the actual blocker (tensor-product `AddCommGroup` on `LineBundle.OnProduct`), not the now-resolved `LineBundle.OnProduct` typed sorry.
