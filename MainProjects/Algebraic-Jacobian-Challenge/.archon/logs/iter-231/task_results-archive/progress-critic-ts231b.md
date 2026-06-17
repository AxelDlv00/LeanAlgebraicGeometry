# Progress Critic Report

## Slug
ts231b

## Iteration
231

## Routes audited

### Route: A.1.c.SubT — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 80 → 80 → 80 → 80 → 80 → 80 across iters 226–230; flat since iter-217, **14 consecutive iters without movement**. Zero sorries closed across the full 5-iter audit window.
- **Helper accumulation**: 10 helpers added across iters 226–229; 0 in iter-230 (probe only). **0 sorries eliminated across the 5-iter window.** Satisfies the STUCK rule verbatim: "helpers added without any sorry-elimination across K iters."
- **Prover dispatch pattern**: 1 file per iter (sole ungated lane; no under-dispatch finding at the lane level). The intra-file parallelism failure — dispatching A-bridge and C-bridge as a merged objective — is the structural source of the monolithic stall, noted separately below.
- **Recurring blockers**: Five consecutive iters, each reporting a *different* phrase for the *same* fundamental gap — the C-bridge cannot close in the same iter as the infra step preceding it:
  - iter-226: "A+C bridges still remain"
  - iter-227: "real blocker = gluing engine build SIZE, not d.2"
  - iter-228: "C-bridge blocked at H2′: slice internal-hom vs sectionwise"
  - iter-229: "both bridges reduce to one shared root (sheaf-site equiv)"
  - iter-230: "shared root does NOT serve C-consumer; real blocker = presheaf internal-hom-restriction, varying-ring"

  The planner's own ts231 directive explicitly names this meta-pattern ("each iter re-localizes the blocker one sub-piece to the right") — then proposes to run the pattern again. Five distinct localizations of the same structural gap across ≥3 iters satisfies the STUCK rule: "recurring blocker phrase across ≥3 iters."

- **Avoidance patterns**: No formal avoidance types (no off-critical-path reclassification, no consecutive plan-only iters, no deferral language). The avoidance is structural: each iter the planner absorbs a tripwire or probe as data and dispatches a "correctly-scoped re-targeting."

- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, PROBE/DOES-NOT-CLOSE. PARTIAL × 4 alone triggers CHURNING; combined with zero sorry elimination and recurring blocker ≥3 iters, it triggers STUCK (worse verdict; multiple rules match).

- **Throughput**: **OVER_BUDGET** — STRATEGY.md `Iters left` (verbatim from the current row, after the planner's own update): `~2–4 (C-bridge 1 · A-engine 1 · assembly 1)`. Phase started at iter-219 (12 iters elapsed). Even with the *updated* optimistic estimate of ~2-4, the phase total would be 12+2 = 14 to 12+4 = 16 iters; the original pre-descent-reroute estimate was ~3–5. Elapsed is ≥2× the original estimate and already past the midpoint of the updated estimate, making progress against even the revised number impossible without changing approach.

- **Verdict**: **STUCK**

  All three STUCK rules are simultaneously satisfied:
  1. "Sorry count unchanged across K iters AND recurring blocker phrase across ≥3 iters" — YES (sorry flat 14 iters; 5 distinct blocker phrases, same structural gap).
  2. "Helpers added without any sorry-elimination across K iters" — YES (10 helpers, 0 sorries).
  3. "PARTIAL prover status ≥3 of last K iters" — YES (PARTIAL × 4, PROBE/DOES-NOT-CLOSE × 1; worst per multiple-rule precedence: STUCK).

---

### Pressure-test: is the iter-231 target DIFFERENT, or is it CHURNING restated?

The planner claims: "the prior 14-iter stall was caused by building the WRONG target; the new target (presheaf-of-modules internal-hom-commutes-with-restriction, `j_*(ℋom_{𝒪_U}(L,𝒪_U)) ≅ ℋom_{𝒪_X}(j_*L, 𝒪_X)`) is near-definitional — both sides are LITERALLY equal on opens `V ⊆ U`."

**The mathlib-analogist ts231ih directly refutes this claim at high severity.**

ts231ih Decision C: **UNDERESTIMATE (high)**. Verbatim finding: "The ~150–300 LOC estimate stands." The residual `(pushforward β).obj (dual M) ≅ dual ((pushforward β).obj M)` is a *genuine natural iso, not `rfl`*, for two irreducible reasons: (1) the LHS value at `V` is computed over `Over_U (jV)` and the RHS over `Over_X V` — equivalent, not equal; (2) the module action requires per-`V` slice-equiv + ring-iso transport. Thinness of `Opens` does NOT trivialise it here because the slice presheaves carry the `𝒪(V)`-module structure (unlike the Type-valued sheaf root, where thinness killed coherence). This is iso-base-change for an open immersion — a real natural iso that must be assembled, not a near-definitional close.

**STRATEGY.md inconsistency (planning failure):** STRATEGY.md line 88 states: "Re-scope (analogist ts231ih): build the MINIMAL objectwise … near-definitional (identity-on-values + `𝒪(V)`-linearity; thin-poset coherence), SHORT, NOT the 150–300 LOC global slice-site equivalence." This directly contradicts ts231ih's actual Decision C finding. The planner updated STRATEGY.md to say ts231ih CONFIRMS the near-definitional claim, when ts231ih REFUTES it. This is a material planning error that has propagated into STRATEGY.md and will continue to mis-scope future dispatches if not corrected.

**Hard tripwire from ts230 ignored.** The ts230 progress-critic report set an explicit directive: "Hard tripwire for iter-230: if the sorry counter does not move from 80 to 79, the planner must NOT assign a further helper round." Iter-230 was PROBE/DOES-NOT-CLOSE (80→80, 0 helpers). The iter-231 planner proposal is another infra round. The tripwire is being ignored without an explicit rebuttal.

**The "different target" claim is true but insufficient.** The presheaf-level objectwise approach IS structurally different from `overSliceSheafEquiv` (different category level, different scope). This is not a literal repetition of a prior round. However, the meta-pattern holds: each iter the planner describes the upcoming target as "SHORT / near-definitional / correctly scoped this time," and the prover has found a genuine gap every time. The ts231 target description matches exactly what the iter-230 prover identified as the remaining ~150-300 LOC build. Structural difference in target ≠ convergence.

**STRATEGY.md's own pre-committed FAIL corrective.** The STRATEGY.md Open Strategic Questions block explicitly encodes: "Pre-committed FAIL correctives (no further re-scope). (1) Pivot the inverse off the dual: build `Linv` by object-level gluing from the trivialising cover (cocycle `g_{ij}⁻¹`), per `informal/exists_tensorObj_inverse.md` route (II) — sidesteps internal-hom-restriction entirely. (2) File-split `TensorObjSubstrate.lean`." The iter-230 gate (PROBE/DOES-NOT-CLOSE, 80→80) satisfies the FAIL condition of the HARD OUTCOME GATE. The pre-committed corrective should now be activated, not deferred by yet another re-scope.

- **Primary corrective**: **Route pivot** — Activate STRATEGY.md pre-committed FAIL corrective (1): build `Linv` via object-level gluing from the trivialising cover (route II, `informal/exists_tensorObj_inverse.md`), bypassing internal-hom-restriction entirely. The route-II inverse sidesteps `dual_restrict_iso` and `homOfLocalCompat` altogether; the inverse is built directly from the cocycle `g_{ij}⁻¹` without requiring an internal-hom commutation lemma. This is the STRATEGY.md's own committed corrective and is consistent with the 5-iter empirical record showing internal-hom-restriction is a ~150-300 LOC build, not a SHORT near-definitional close.

- **Secondary corrective**: **Refactor (file-splitting)** — Activate STRATEGY.md pre-committed FAIL corrective (2): file-split `TensorObjSubstrate.lean` to quarantine the vestigial whiskering/stalk apparatus and the dead slice-site root, isolate the live dual+inverse surface, and enable parallel lanes for the A-engine (`homOfLocalCompat`) and the route-II inverse. The A-engine lane (Type-valued, served cleanly by `overSliceSheafEquiv`) can be dispatched independently this iter. The route-II inverse is a separate standalone build. Both can proceed in parallel once the file is split.

- **STRATEGY.md correction required**: Correct the ts231ih misrepresentation. The line "near-definitional (identity-on-values + `𝒪(V)`-linearity; thin-poset coherence), SHORT, NOT the 150–300 LOC global slice-site equivalence" is not confirmed by ts231ih and contradicts it. Replace with: "ts231ih Decision C: UNDERESTIMATE (high) — residual is a real natural iso (iso-base-change), ~150-300 LOC; route-II pivot is the correct corrective."

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: 10)
- **Ready but not dispatched**: All other lanes are user-paused, gated, or held. No under-dispatch finding at the lane level.
- **Over the cap**: no
- **Under-dispatch finding**: no (sole ungated lane; N=M=1)
- **Iter-over-iter trend**: 1 → 1 → 1 → 1 → 1 (five consecutive single-file dispatches; structural, not avoidance)
- **Verdict**: OK — file count 1 within cap 10, no under-dispatch given sole-lane constraint. Note: once the Refactor (file-splitting) corrective is applied, the lane count will increase and the dispatch cap can be used to run A-engine and route-II inverse in parallel.

---

## Must-fix-this-iter

- **Route A.1.c.SubT**: STUCK — primary corrective: **Route pivot** (STRATEGY.md pre-committed FAIL corrective). Do NOT dispatch another prover at the internal-hom-commutation target. Activate route II: build `Linv` from the trivialising cover by object-level gluing. Why: 14 iters flat, 10 helpers, 0 sorries, 5 distinct blocker phrases, ts231ih confirms the "SHORT" estimate is wrong, and STRATEGY.md's own pre-committed FAIL corrective is triggered by the iter-230 PROBE result.

- **Route A.1.c.SubT**: OVER_BUDGET — even with the planner's optimistic updated estimate (`~2-4` iters remaining), the phase has run 12 iters from iter-219 to iter-230. Without a structural change in approach (route pivot), there is no mechanism by which the remaining estimate will be met.

- **STRATEGY.md accuracy**: The planner updated STRATEGY.md to say "analogist ts231ih confirms minimal target is near-definitional, SHORT" — ts231ih's actual Decision C is UNDERESTIMATE (high), stating the opposite. Correct STRATEGY.md before the next planning iter, or subsequent dispatches will be mis-scoped in the same direction.

- **Hard tripwire violation**: The ts230 progress-critic explicitly set "the planner must NOT assign a further helper round" if iter-230 fails. Iter-230 failed (80→80). The iter-231 planner proposal is another infra round. The planner must either rebut the tripwire with an explicit argument for why the re-scoped target breaks the churn cycle, or activate the pre-committed FAIL correctives. Silence is not acceptable.

---

## Informational

The route-II pivot (`informal/exists_tensorObj_inverse.md`) was identified as a viable alternative at least as early as iter-226. The ts231ih analogist's mitigating lever note confirms the favorable structure: because the inverse target is `𝟙_ = 𝒪` and `β` is a ring iso, the iso EXISTS cleanly — but the assembly cost is ~150-300 LOC, not zero. Route II sidesteps this cost entirely by avoiding the internal-hom object and building the inverse directly from cover data. It is the lower-risk path given the empirical record.

The A-engine lane (`homOfLocalCompat`) through `overSliceSheafEquiv` is confirmed clean by the iter-230 prover and the ts231ih analogist (Decision A: `overSliceSheafEquiv` serves the Type-valued A-engine). Dispatching A-engine as a standalone objective this iter (after file-split) gives a sorry-trajectory improvement without waiting for the C-bridge or route-II inverse.

---

## Overall verdict

One route audited; verdict STUCK by all three mechanical rules simultaneously (sorry flat 14 iters, helpers without sorry-elimination, PARTIAL × 4 + PROBE/DOES-NOT-CLOSE, recurring blocker ≥3 iters). The route is also OVER_BUDGET. The mathlib-analogist ts231ih independently refutes the planner's "near-definitional, LITERALLY equal" claim at high severity — the same estimate (150-300 LOC) that has characterized the C-bridge gap for multiple iters. The iter-231 planner proposal — another prover dispatch at the internal-hom-commutation target — violates the ts230 hard tripwire and the STRATEGY.md pre-committed FAIL corrective. The correct iter-231 plan is: (1) activate STRATEGY.md route-II pivot (object-gluing from trivialising cover, bypasses internal-hom entirely); (2) apply file-split to create independent A-engine and route-II lanes; (3) dispatch A-engine as a standalone prover objective this iter (confirmed clean path); (4) correct STRATEGY.md to remove the erroneous "ts231ih confirms near-definitional, SHORT" claim.
