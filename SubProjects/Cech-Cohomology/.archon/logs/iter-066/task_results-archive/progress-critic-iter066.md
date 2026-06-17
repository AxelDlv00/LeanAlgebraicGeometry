# Progress Critic Report

## Slug
iter066

## Iteration
066

## Routes audited

### Route A — `CechSectionIdentification.lean` (P5a-resolution)

- **Sorry trajectory**: 5 → 5 → 4 → 4 → 2 across iter-061 to iter-065. Net: −3 over K=5. Last iter alone: −2 (both induction leaves closed, cascading Stubs 2 & 4 axiom-clean).
- **Helper accumulation**: Helpers were added each iter (notably +10 in iter-064 by deliberate decomposition), but each helper batch had a clear payoff: the iter-064 decompose closed one sorry and set up two leaf targets that iter-065 then closed. No helper-without-payoff churn.
- **Recurring blockers**: "erw vs rw projection matching" (iter-061 to 063) and "declined monolith near budget" (iter-061 to 063) — both resolved by the iter-064 mode-switch. No blocker phrase repeated across ≥3 iters after that.
- **Avoidance patterns**: None. Route has been actively dispatched each iter; no off-critical-path reclassification, no deferral language.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, PARTIAL. All 5 PARTIAL. However, the last two PARTIAL iters each closed multiple sorries (iter-064: 1 closed; iter-065: 2 closed + cascade). The PARTIAL designation in the final iters reflects "didn't finish the file", not "tried and stalled." This is the closing phase of a converging route, not churn.
- **Throughput**: OVER_BUDGET — STRATEGY.md estimate "~2–4 iters left" entered at iter-053; elapsed = 13 iters. The planner is already aware (route labelled ACTIVE OVER_BUDGET in directive). The route is actively closing, so this is a stale estimate, not a running churn signal.
- **Proposed iter-066 objective**: Close 2 remaining sorries — Stub 5 `cechSection_complex_iso` (1418) and Stub 6 `cechSection_contractible` (1477). Blueprint sketches are detailed (MEDIUM ratings, dependent engine infrastructure already in place). Both targets are direct applications of `HomologicalComplex.mkIso`/`isoOfComponents` (Stub 5) and `CombinatorialCech.depHomotopy`/`depHomotopy_spec` (Stub 6). Neither requires new infrastructure. The proposal is "finish what's started."
- **Churn risk on new targets**: Low. Stub 5 is a homeomorphism assembly with explicit component-wise iso structure; Stub 6 is a combinatorial engine invocation. No mathematical discovery required; the dependent engine is already present and the blueprint provides the instantiation recipe. No new blocker class is expected.
- **Verdict**: **CONVERGING**

---

### Route B — `OpenImmersionPushforward.lean` (P5a-consumer)

- **Sorry trajectory**: 2 → 2 → 2 → 5 → 4 across iter-061 to iter-065. The expansion to 5 in iter-064 was deliberate decomposition of 2 opaque sorries into 5 typed leaves; 1 was closed that iter. iter-065 closed the keystone φ'' + cascade, closing `_acyclic` fully. Net from the pre-decomposition baseline: effectively 2 → 4 typed leaves (the `_comp` sub-goals), having closed the acyclicity milestone en route.
- **Helper accumulation**: Helpers added iter-061, 062, 063, 064. The iter-061 to 063 helpers (ψ_r infra, continuity instances, slice equiv) did not close any sorry across 3 consecutive iters. The iter-064 decompose broke the stall and produced actual closures. Net: 3-iter helper-without-payoff period (iter-061 to 063) ended cleanly.
- **Recurring blockers**: "[F.IsContinuous] metavar wall" (iter-060 to 062, resolved iter-063); "φ'' object-relabel iso ~40–80 LOC wall" (iter-061 to 064, dissolved iter-065 — was definitional). No active recurring blocker. However, a new latent risk exists: see below.
- **Avoidance patterns**: None. Route dispatched each iter; no off-critical-path flags.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, PARTIAL — five consecutive PARTIAL statuses. **This triggers the CHURNING rule (PARTIAL ≥3 of last K iters).** The rule applies mechanically. Mitigating context: iter-064 and 065 were genuinely productive (acyclicity milestone closed), and the PARTIAL designation in those iters reflects "didn't finish `_comp`", not "tried and stalled on the same goal." The CHURNING verdict is a trailing indicator but is still the correct classification by the rules, because the 4 remaining `_comp` sorries are NEW goals that have not been attempted.
- **Throughput**: OVER_BUDGET — STRATEGY.md estimate "~1–3 iters left" entered at iter-056; elapsed = 10 iters.
- **New latent churn risk — `hacyc` route rewrite**: The dominant sorry (`hacyc`, line 974) has been identified by the planner as using a **flawed route** (Serre vanishing on U∩f⁻¹V, which is not affine). The replacement route (pushforward j preserves injectives as right adjoint of mono-preserving pullback → j_* Iⁿ injective → f_*-acyclic via `IsRightAcyclic.ofInjective`) has NOT yet been written into the code or blueprint. The in-file outer comment block (lines 960–964) **still describes the old flawed approach**. A prover dispatched without the updated blueprint will read that comment and attempt the flawed Serre-vanishing route, reproducing the iter-061 to 063 stall pattern on the new sorry. The proposed gate (blueprint-writer rewrite + fast-path re-review) is the correct safeguard and **must execute before prover dispatch** to prevent this.
- **Additional concern — `hexact`**: The in-file comment for `case hexact` (line 980–981) describes "j_*-acyclicity of each injective Iⁿ (_acyclic applied to Iⁿ)" as closing this case. The distinction between "j_*-acyclicity of Iⁿ" (higher direct images of injectives vanish) and "exactness of j_* I^• as a resolution of j_* H" is subtle — they differ unless j_* is exact (not just left-exact). The blueprint rewrite should confirm this logic is sound before the prover attempts it; if unsound, `hexact` becomes a second independent churn point.
- **Verdict**: **CHURNING** (PARTIAL×5 rule triggered; additionally: 3-iter sorry-stall iter-061 to 063 within the window; new `_comp` goals untested; flawed in-file route comment for `hacyc`)
- **Primary corrective**: **Blueprint expansion** — the `hacyc` route rewrite (new injectives-preservation argument) must be written into the blueprint chapter AND the in-file comment updated before prover dispatch. The planner has already proposed this gate; it is the correct and sufficient corrective. Do not dispatch the prover on `_comp` until the blueprint rewrite is in place and fast-path reviewed. `hexact` soundness should be explicitly confirmed in the same pass.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (CSI + OpenImm), cap: 10.
- **Ready but not dispatched**: None identified from the directive's scope (only Routes A and B provided). No under-dispatch finding within the stated scope.
- **Over the cap**: No.
- **Under-dispatch finding**: No — both active routes are dispatched. Note: the directive does not provide a "M ready files" denominator beyond these two; if other files have complete blueprint chapters and open sorries, the planner should surface them. This report cannot assess what was not provided.
- **Iter-over-iter trend**: Not increasing; 2 files per iter is consistent.
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch on stated scope.

---

## Must-fix-this-iter

- **Route B (OpenImm)**: CHURNING — primary corrective: **blueprint expansion** for `hacyc`. The in-file route comment (lines 960–964) still describes the flawed Serre-vanishing path; a prover dispatched without the updated blueprint will re-enter that wall. Run blueprint-writer rewrite + fast-path re-review before prover dispatch. Confirm `hexact` logic in the same pass.
- **Route B (OpenImm)**: OVER_BUDGET — STRATEGY.md estimates ~1–3 iters; elapsed 10. Revise the estimate in STRATEGY.md this iter to reflect the actual remaining scope (4 typed sub-goals, 3 of which are low-medium difficulty once `hacyc` is routed correctly).

---

## Informational

- **Route A (CSI)**: CONVERGING, OVER_BUDGET (estimate ~2–4 iters, elapsed 13). The estimate is stale; both remaining sorries (Stubs 5 & 6) are frontier-ready with adequate blueprints and enabling infrastructure in place. Revise the STRATEGY.md row to "~1–2 iters" after this iter if both close; if only one closes, revise to "~1." No must-fix action needed; informational only.
- **Route B (OpenImm)**: If the blueprint rewrite and re-review confirm the new `hacyc` route, `eRes` and `transport` are expected to be mechanical (left-exactness and pushforwardComp transport). The planner should treat `hexact` as a second gate, not a gimme: the exactness logic needs explicit blueprint confirmation that "acyclicity of Iⁿ for j_* implies exactness of j_* I^•."

---

## Overall verdict

One route is cleanly converging (CSI, 2 sorries left, detailed blueprints, enabling infrastructure complete) and should be dispatched to the prover this iter without further ceremony. The second route (OpenImm `_comp`) is formally CHURNING by the PARTIAL×5 rule and carries a concrete new churn risk: the planner has identified the dominant `hacyc` sorry as using a flawed in-file route (Serre vanishing on a non-affine U∩f⁻¹V), but the code still reflects that flawed route and no prover has yet attempted the new injectives-preservation path. The proposed safeguard — blueprint-writer rewrite + fast-path re-review before prover dispatch — is exactly the right corrective and must execute before the OpenImm prover is sent in. If that gate runs and validates the new route, the `_comp` block is likely to converge in one or two prover iters. The iter-066 plan is structurally sound; the must-fix item is execution of the gate, not a strategic pivot.
