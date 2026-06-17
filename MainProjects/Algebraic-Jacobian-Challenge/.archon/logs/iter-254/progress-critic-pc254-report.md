# Progress Critic Report

## Slug
pc254

## Iteration
254

## Routes audited

### Route 1 — Lane TS-cmp — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 1 → 3 → 3 → 3 across iters 250–253. Net: unchanged at 3 for three consecutive iters. (The 1→3 jump in iter-251 was structural—D1′ authored—but the layer has not closed since, so the net trajectory is flat for 3 iters.)
- **Helper accumulation**: +2 named closes (iter-251), +1 (iter-252), +2 partial (iter-253, including Square-1 of D1′ closed). Total ≈5 helpers added since D2′ close; 0 sorries eliminated in the window. STEP A (`sheafifyTensorUnitIso_hom_natural`) and STEP B (`pullbackTensorMap_natural`) both remain open.
- **Prover dispatch pattern**: 1 file per iter, every iter. No under-dispatch (DualInverse is the companion file and is dispatched in parallel).
- **Recurring blockers**:
  - "`restrictScalars (𝟙)`-over-sheafification `whnf` wall / two defeq monoidal `≫` instance spellings" appears verbatim or functionally identically in iter-250, 251, 252, 253 = **4 consecutive iters**. The surface manifestation evolved (whisker instance split → whisker disproved → element-level `TensorProduct.induction_on` → `erw`-triggered `whnf` timeout), but the root cause is the same ring-functor-spelling collision each time.
  - "`Sheaf.val`/`.obj` spelling merge failure" (STEP B, Square-2) appears in iter-253 as a distinct but same-family instance of the same structural issue.
- **Avoidance patterns**: none. Route dispatched every iter.
- **Prover status pattern**: COMPLETE (iter-250, D2′ close) → PARTIAL (251) → PARTIAL (252) → PARTIAL/BLOCKED (253). **PARTIAL×3** in the last three iters.
- **Throughput**: OVER_BUDGET. Phase A.1.c.sub entered ~iter-234. Elapsed = 20 iters as of iter-253 (21 with iter-254 in progress). Original phase estimate was 6–11 iters (per pc253b); the STRATEGY was revised upward in iter-253 and now shows 5–9 remaining, implying a total of ~25–29 iters—but even against the revised estimate, D1′ has been open for 3 iters without closing. D2′ (iter-250) is the sole sorry-closure across the entire phase.
- **Verdict**: **STUCK**. Two STUCK rules fire independently:
  1. *Recurring blocker ≥3 iters*: the `whnf`/monoidal-instance-spelling blocker has appeared in 4 consecutive iters (250–253).
  2. *Sorry count unchanged + prover statuses include PARTIAL/BLOCKED*: sorry 3→3→3 across iters 251–253 with no structural advance.
  PARTIAL×3 (the CHURNING rule) also fires, but STUCK dominates.
- **Primary corrective**: **Mathlib analogy consult** on `restrictScalars (𝟙)` ring-functor-spelling disambiguation and how to bridge the two `monoidalCategoryStruct` / `.toMonoidalCategoryStruct` instance spellings without `erw`. **STATUS: ALREADY DISPATCHED this iter** (`mathlib-analogist-tscmp254`). This is the correct corrective; the iter-254 plan has responded appropriately. The prover must be restricted to ONLY the analogist-prescribed normalization approach—the 3 disproven approaches (whisker `letI`, element-level `erw`, uniform-instance-helper extraction) are ruled out and must not be retried.
- **Secondary concern**: STEP B (`Sheaf.val`/`.obj` spelling merge) is the same structural family. If the analogist's normalization fixes the ring-functor-spelling root, Square-2 of STEP B should also become reachable in the same iter. The plan should make this explicit so the prover attempts BOTH STEP A and STEP B with the analogist's fix—not just STEP A.

---

### Route 2 — Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean`

- **Sorry trajectory**: 3 → 2 → 2 → 2 across iters 251–253. Net: 1 sorry eliminated (iter-251), then flat at 2 for two iters. `homOfLocalCompat` (sub-step (a)) and `dual_restrict_iso` Step-4 are the two residuals.
- **Helper accumulation**: +4 named closes (iter-251), +1 `homLocalSection` close incl. hard naturality (iter-252), +2 `topSectionToHom` closes + sub-step (b) closed (iter-253). Total ≈7 helpers + sub-step (b) across K=3, 1 sorry eliminated. Genuine internal progress each iter, but the SORRY count stalled at 2.
- **Prover dispatch pattern**: 1 file per iter for 3 iters. Companion TS-cmp is dispatched in parallel. No under-dispatch.
- **Recurring blockers**:
  - "`hf: HEq` between pullback-images unsatisfiable (objects only isomorphic, not propositionally equal)" appears first in iter-253. **Only 1 consecutive occurrence**—does not yet satisfy the ≥3 STUCK rule. However, it is self-imposed (see verdict).
  - **Compile-dependency hazard**: iter-253 prover was blocked from integration-testing its edits because the sibling TensorObjSubstrate.lean was mid-edit and non-compiling. This is a structural parallelism risk that recurs whenever TS-cmp is edited simultaneously.
- **Avoidance patterns**: none (3 iters of active dispatch).
- **Prover status pattern**: PARTIAL (251) → PARTIAL (252) → PARTIAL/BLOCKED (253). **PARTIAL×3**—the CHURNING rule fires.
- **Throughput**: ON_SCHEDULE (route opened iter-251; 3 iters elapsed; phase estimate 5–9 remaining). However, if `homOfLocalCompat` does not close in iter-254, the route will have spent 4 of ~9 estimated remaining iters on this single declaration.
- **Verdict**: **CHURNING** (PARTIAL×3). Mitigating context: each iter delivered genuine load-bearing closures (not mere wrappers), and the sorry-count stall at 2 reflects that `homOfLocalCompat` was blocked on a SELF-IMPOSED signature freeze, not a mathematical gap. The iter-253 prover correctly diagnosed the fix (`hf` re-signed to sectionwise form) but incorrectly believed the signature was protected. It is not: `homOfLocalCompat` is absent from `archon-protected.yaml` and has no compiling callers.
- **Primary corrective**: **Structural refactor** — re-sign `homOfLocalCompat`'s `hf` parameter from the unsatisfiable `HEq` form to the honest sectionwise form (for all `i j` and open `V ≤ Uᵢ ⊓ Uⱼ`, the section maps agree in the fixed `Ab` hom-type `M.val(V) ⟶ N.val(V)`). **STATUS: BLUEPRINT ALREADY UPDATED via bw254** (the iter-254 blueprint writer replaced the HEq prose with the honest sectionwise hypothesis and confirmed the bridge to `IsCompatible` is then direct). The prover must now re-sign the Lean signature accordingly—this is a prover-executable action (no protected-signature constraint applies).

**Soundness assessment of "re-sign hf then close"**: The iter-253 prover report documents that the goal after `simp only [homLocalSection]` reduces to the EXACT sectionwise equation (`M.map(eqToHom) ≫ (f i).val.app … = M.map(eqToHom) ≫ (f j).val.app …`), which is the honest form of `hf`. After re-signing, `hf_sectionwise i j V hVi hVj` will close sub-step (a) directly or near-directly. Sub-step (b) is already scaffolded (`topSectionToHom` helpers closed). Sub-step (c) (linearity) is explicitly unblocked once (a) supplies `hcompat`. The close is **sound**—no residual mathematical gap identified.

**One remaining risk for Route 2**: `dual_restrict_iso` Step-4 (sorry ~L256) has been untouched for 3 iters (251, 252, 253)—in iters 252 and 253 due to the compile-dependency hazard. Leg (A) `sliceDualTransport` is a genuinely novel build (~multi-lemma); there is no guarantee it closes in one iter. The plan's "attempt Step-4" is correctly framed as a bar (attempt, not guarantee). If leg (A) resists, the prover should switch to the inverse-uniqueness shortcut from CLOSED `tensorObj_restrict_iso` (per the plan's stated fallback) and leave a concrete handoff—not a blank sorry.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10)
- **Over the cap**: no
- **Under-dispatch finding**: no. The engine lane (`IsLocallyTrivial ⟹ IsFinitePresentation`) is the only third candidate, and it is **currently un-blueprinted**—it cannot be dispatched as a prover target without a blueprint chapter. No other file with a complete blueprint chapter and open sorries is identified as available but unassigned.
- **Iter-over-iter trend**: 2 → 2 → 2 (iters 252–254); stable at 2. Appropriate while both routes are active and the 3rd lane lacks a blueprint.
- **Verdict**: **OK** — file count 2 within cap 10, no under-dispatch against ready files.

---

## Must-fix-this-iter

- **Route 1 (TensorObjSubstrate.lean): STUCK** — primary corrective: **Mathlib analogy consult** (DISPATCHED as `mathlib-analogist-tscmp254`). Planner must arm the prover with the analogist's ring-functor-spelling normalization prescription and hold the prover strictly to that approach. Any relapse into whisker, `erw`, or uniform-instance-helper extraction is a reversing signal and must trigger an immediate stop—not a 4th approach pivot.
- **Route 2 (DualInverse.lean): CHURNING** — primary corrective: **Structural refactor** of `hf` signature (BLUEPRINT done via bw254). Prover must re-sign in Lean this iter. If `homOfLocalCompat` does not close after the re-signing (i.e., the goal does not reduce as diagnosed in iter-253), that is a new diagnosis signal and must be reported immediately rather than proceeding to Step-4.
- **Route 1: OVER_BUDGET** — phase A.1.c.sub now 21+ iters elapsed; original estimate 6–11, revised estimate 5–9 remaining. The STRATEGY estimate has already been refreshed (iter-253). If D1′ (`pullbackTensorMap_natural`) does not close this iter, the plan agent should revise the remaining estimate downward again and assess whether D3′ and D4′ remain reachable under the new timeline, or whether a route pivot to completing the dual chain (DualInverse) first is preferable.

---

## Informational

**On the 3rd lane (`IsLocallyTrivial ⟹ IsFinitePresentation`).** Deferring the blueprint for this lane to iter-255 is **acceptable this iter** given the existing corrective load (analogist + re-sign + 2 provers). However, this lane has been in "candidate, deferred" status since iter-252 (3 consecutive iters). The PROGRESS.md engine252 scoping is done; the only missing piece is the blueprint chapter. If iter-255 does not dispatch a blueprint writer for this lane, the avoidance-pattern clock triggers (≥4 consecutive iters with "deferred, not throttled" without a re-engagement action). The plan agent should schedule a blueprint expansion for this lane explicitly in iter-255.

**On the parallel-dispatch compile-hazard.** The iter-253 DualInverse prover was unable to integration-test any edits because TensorObjSubstrate.lean was mid-edit and non-compiling at session start. The plan's "keep TensorObjSubstrate.lean COMPILABLE at every checkpoint" instruction addresses this, but it relies on execution discipline. If TS-cmp is dispatched in parallel with DualInverse again, the plan agent should make compilability at every checkpoint an explicit **stopping condition** for the TS-cmp prover (not just a coordination note)—i.e., if the file is non-compiling when the TS-inv prover would be expected to run, the TS-cmp prover must restore a compiling state before stopping, even if that means leaving STEP A's sorry in place temporarily.

**On Route 1's STEP B and STEP A sharing the same root fix.** The analogist's ring-functor-spelling normalization is expected to unblock both STEP A (monoidal instance collision) and STEP B (Sheaf.val/.obj merge failure). The plan should instruct the prover to attempt BOTH with the normalization fix in the same session, not stop at STEP A. If STEP A requires the full budget, the prover should leave STEP B scaffolded with a concrete one-line handoff identifying which spelling normalization step would be next.

---

## Overall verdict

Two routes active: Route 1 (TensorObjSubstrate.lean) is **STUCK** and Route 2 (DualInverse.lean) is **CHURNING**. In both cases the iter-254 plan has identified and executed the correct corrective before reaching me: a Mathlib analogy consult for Route 1 (blocking root now being diagnosed by `tscmp254`), and a blueprint structural refactor for Route 2 (bw254 has updated the `hf` hypothesis to the honest sectionwise form). Neither route is being re-dispatched against a shape that already failed—the spelling-normalization pivot for Route 1 is genuinely new, and the `hf` re-signing for Route 2 removes the self-imposed freeze rather than retrying the same `HEq`-elimination. The M=2 dispatch is correct; no 3rd file is blueprint-ready. The plan agent's iter-254 response to the STUCK and CHURNING signals is sound. The remaining execution risks are: (1) whether the analogist's normalization device actually eliminates the `whnf` hazard in-context—if not, escalate to user rather than a 4th pivot; (2) whether `dual_restrict_iso` Step-4 closes or requires another iter; (3) the parallel-compile hazard if both provers run simultaneously.
