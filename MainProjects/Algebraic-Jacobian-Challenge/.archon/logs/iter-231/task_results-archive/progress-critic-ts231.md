# Progress Critic Report

## Slug
ts231

## Iteration
231

## Routes audited

### Route: A.1.c.SubT — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 80 → 80 → 80 → 80 → 80 → 80 across iters 226–230 (unchanged). Total flat since iter-217: **14 consecutive iters**. Zero movement.
- **Helper accumulation**: 10 helpers added across iters 226–229; 0 in iter-230 (probe only). **0 sorries closed across the full 5-iter window.**
- **Prover dispatch pattern**: 1 file dispatched every iter (sole ungated lane; no under-dispatch finding from available-lane count, but the under-parallelism within the single file is a distinct signal — see below).
- **Recurring blockers**: Five different "real blocker" phrases across five iters, none resolved:
  - iter-226: "A+C bridges still remain"
  - iter-227: "real blocker = gluing engine build SIZE, not d.2"
  - iter-228: "C-bridge blocked at H2′: slice internal-hom vs sectionwise"
  - iter-229: "both bridges reduce to one shared root (sheaf-site equiv)"
  - iter-230: "shared root does NOT serve C-consumer; real blocker = presheaf internal-hom-restriction, varying-ring"
  
  The meta-pattern IS the blocker: **each iter re-localizes the blocker one sub-piece to the right**. The planner's own directive for ts231 names this pattern explicitly — then proposes to run the pattern again.
- **Avoidance patterns**: none of the formal avoidance types (no off-critical-path reclassification, no consecutive plan-only iters, no deferral language). The avoidance is structural: the planner keeps absorbing tripwire firings as data and dispatching "a new, correctly-scoped" infra target.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, PROBE/DOES-NOT-CLOSE. No COMPLETE in the window. PARTIAL × 4 alone triggers CHURNING; combined with the flat sorry count across K iters it triggers STUCK.
- **Throughput**: **OVER_BUDGET** — STRATEGY.md estimates ~3–5 iters for this sub-phase; elapsed = 12 iters since iter-219. Elapsed > 2× estimate.
- **HARD TRIPWIRE status**: The iter-230 directive explicitly set a HARD TRIPWIRE: "if 80→79 fails this iter, the autonomous loop has reached its limit on this lane — no further infra round." iter-230 hit OUTCOME (ii), 80→79 failed. The iter-231 planner proposal is an infra round. **The HARD TRIPWIRE is being ignored.**

---

### Pressure-test: is the iter-231 target DIFFERENT (planner's claim) or CHURNING?

The planner argues the prior 14-iter stall was caused by "building the WRONG target (a global sheaf-site equivalence) rather than this near-definitional presheaf restriction," and that the new iter-231 target — `j_*(ℋom_{𝒪_U}(L,𝒪_U)) ≅ ℋom_{𝒪_X}(j_* L, 𝒪_X)` built directly at the presheaf level — is genuinely different.

**Assessment: the target IS structurally different; the "near-definitional" claim is FALSE.**

The target is structurally different from `overSliceSheafEquiv` (which is sheaf-level, fixed value-cat). Dispatching iter-231 onto the direct presheaf approach would not literally repeat a prior prover round. That much is correct.

However, the `informal/dual_restrict_iso.md` file — written by the iter-230 prover after live goal extraction and confirmation — identifies this exact same ingredient and labels it:

> "Estimated ~150–300 LOC, with real `Over.map` pseudofunctor-coherence risk (unlike the sheaf root, where thinness of `Opens` trivialised it — here the slice presheaves carry the module structure that thinness does NOT kill)."

The planner describes it as "near-definitional" and claims "both sides are LITERALLY equal." The prover who inspected the actual Lean goal says ~150-300 LOC with real coherence risk. These descriptions are **directly contradictory**. The 5-iter pattern shows the planner has consistently described the upcoming target as "nearly trivial" or "correctly scoped this time" (iter-226: "C bridge with a shadow compose"; iter-227: "gluing engine, reasonable"; iter-228: "the shared root discharges it"; iter-229: "the root is built, now just compose"; iter-230: "first sorry-targeted move") and the prover has found a genuine gap each time. Iter-231 is the same pattern restated once more.

Mathematically, the claim that the two sides are "LITERALLY equal" on opens `V ⊆ U` is only correct for sections as sets — the `𝒪_Y(V)`-module action still requires the per-`V` slice-equivalence + ring-iso transport (described precisely in `informal/dual_restrict_iso.md`). This is not a `rfl`-close.

**Verdict: STUCK**

All three STUCK criteria are met:
1. Sorry count unchanged (80) across all K iters; prover statuses include PARTIAL × 4 (not INCOMPLETE, but recurring PARTIAL with flat sorry is the helpers-without-elimination rule); recurring blocker re-localization across ≥3 iters (5 iters).
2. 10 helpers added, 0 sorries eliminated across 5-iter window — "helpers added without any sorry-elimination."
3. The 14-iter flat sorry count and OVER_BUDGET (12 iters vs ~3–5 estimate) are structurally disqualifying regardless of the specific sorry-eliminated-vs-added rule applied.

- **Primary corrective**: **Refactor** (file-splitting parallelism — USER explicitly authorized this)

  The route's single file `TensorObjSubstrate.lean` is trying to close `exists_tensorObj_inverse` as a single assembly target that requires BOTH the A-bridge (`homOfLocalCompat`) AND the C-bridge (`dual_restrict_iso`). The iter-230 prover confirmed:
  
  - **A-bridge `homOfLocalCompat`** (value cat `Type`, no varying-ring transport): `overSliceSheafEquiv` cleanly serves it. Independently buildable. Does NOT need the C-bridge.
  - **C-bridge `dual_restrict_iso`**: `overSliceSheafEquiv` does NOT serve it. Requires the presheaf+module slice comparison — ~150-300 LOC, `Over.map` coherence risk. This is its own multi-iter sub-build.
  
  The corrective: **decompose the file target into two parallel independent dispatches this iter**:
  1. Dispatch the A-bridge (`homOfLocalCompat`) as a standalone prover objective — it is clearly scoped, its route through `overSliceSheafEquiv` is confirmed clean, it builds a useful axiom-clean lemma that reduces the residual.
  2. Dispatch `dual_restrict_iso` as a SEPARATE standalone prover objective, with `informal/dual_restrict_iso.md` as its blueprint (already precise: per-`V` slice equivalence + ring-iso transport, ~150-300 LOC), explicit "do not reach for `overSliceSheafEquV`" warning, and realistic iter-count expectation.
  3. Do NOT include `exists_tensorObj_inverse` as a target until BOTH bridges are built.
  
  This is the USER-authorized file-splitting parallelism. It converts the monolithic stall into two independently-trackable lanes whose sorry-trajectories are separately verifiable.

- **Secondary corrective**: **Blueprint expansion** — STRATEGY.md A.1.c.SubT is now stale: it still says "the site equivalence is value-category-parametric, so it serves both bridges." iter-230 EMPIRICALLY DISPROVED this for the C-bridge. Update STRATEGY.md to reflect that (a) `overSliceSheafEquiv` serves the A-bridge only, (b) the C-bridge requires the presheaf+module slice comparison as a standalone sub-phase, and (c) adjust the `Iters left` estimate to ~5-8 (A-bridge 1-2 · C-bridge 2-3 · assembly 1-2) before dispatching the next prover. Without this update, the planner will again describe the C-bridge target in terms of the sheaf-root infrastructure.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: 10)
- **Ready but not dispatched**: All other lanes are formally HELD (RPF, FGA, WD, RCI) or gated (A.2.c, A.3, Route-2 Albanese). No under-dispatch finding against the available-lane count.
- **Over the cap**: no
- **Under-dispatch finding**: N/A at the lane level. However, the **intra-file parallelism** finding is relevant: the A-bridge and C-bridge are independently buildable sub-targets, and dispatching them as one merged "close `exists_tensorObj_inverse`" objective has been the structural source of the monolithic stall. User authorization for file-splitting is in force.
- **Iter-over-iter trend**: 1 → 1 → 1 → 1 → 1 (five consecutive single-file dispatches). Unavoidable given the sole-ungated-lane constraint, not an avoidance pattern by itself.
- **Verdict**: OK by the cap and lane-count checks. The under-parallelism within the single dispatched file is a corrective finding, not a dispatch-sanity violation.

---

## Must-fix-this-iter

- **Route A.1.c.SubT**: STUCK — primary corrective: **Refactor (file-splitting)**. The A-bridge and C-bridge are independently buildable and must be dispatched as separate prover objectives this iter, each with a realistic LOC estimate and explicit scope. Treating them as one "assemble `exists_tensorObj_inverse`" target has produced the monolithic stall.

- **Route A.1.c.SubT**: OVER_BUDGET — STRATEGY.md estimates ~3–5 iters for this sub-phase; elapsed = 12 iters (>2×). Revise the phase estimate to ~5–8 iters remaining (before the phase can close) AND update the STRATEGY.md A.1.c.SubT description to reflect the empirically confirmed finding that `overSliceSheafEquiv` does NOT serve the C-bridge.

- **Route A.1.c.SubT**: HARD TRIPWIRE ignored — the iter-230 directive set an explicit "do NOT plan iter-231 as another infra round" tripwire. The iter-231 planner proposal IS another infra round. The planner must either explicitly rebut the tripwire (naming why the new target breaks the churn cycle) or apply the Refactor corrective above. Silence is not acceptable.

---

## Informational

The planner's "LITERALLY equal" claim (that the new target is near-definitional) should be verified by reading `informal/dual_restrict_iso.md` §"Precise missing ingredient" before dispatch — this file was written by the iter-230 prover after live Lean goal extraction and explicitly labels the same ingredient "~150–300 LOC, real `Over.map` pseudofunctor-coherence risk." The five-iter pattern of planner-optimism vs prover-reality on LOC estimates is the strongest convergence signal in the dataset.

---

## Overall verdict

One route audited, one STUCK verdict, one OVER_BUDGET finding. The route has been flat at 80 project sorries for 14 iters despite 10 helpers added, a HARD TRIPWIRE being triggered in iter-230, and five consecutive PARTIAL/PROBE prover statuses. The iter-231 planner proposal — another infra round dressed as a "correctly-scoped" re-targeting — continues the meta-pattern the directive itself named: each iter re-localizes the blocker one sub-piece to the right. The planner is ignoring the iter-230 HARD TRIPWIRE. The corrective is not another single-file dispatch at `TensorObjSubstrate.lean`: it is decomposing the stalled file target into two parallel independent dispatches (A-bridge and C-bridge separately), updating STRATEGY.md to reflect the empirically confirmed finding that the shared root does not serve the C-bridge, and acknowledging that the C-bridge is a standalone ~150-300 LOC sub-build — not a near-definitional compose. The USER has explicitly authorized file-splitting parallelism; this iter should use it.
