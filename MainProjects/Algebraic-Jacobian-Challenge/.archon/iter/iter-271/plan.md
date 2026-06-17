# iter-271 plan

First prover-stage plan phase since iter-265 (iters 266–270 were DAG-only blueprint
graph cleanup; the blueprint was declared COMPLETE at iter-270). The iter-265 prover
results (DualInverse, TensorObjSubstrate, CechHigherDirectImage task_results) were
still unprocessed; this phase consumed them and re-dispatched the three active lanes
with correctives for the two flagged routes.

## Inputs processed
- iter-265 prover task_results (3 lanes) — all PARTIAL, net-zero sorry close (the 5th
  such on the Picard critical path).
- iter-270 dag.md + blueprint-reviewer-iter270 (whole-blueprint audit) + dag-walker
  reports — blueprint COMPLETE; 8 pins already repinned by the picard-substrate walker.

## Subagents dispatched
| Subagent | Slug | Verdict / outcome |
|---|---|---|
| progress-critic | pc271 | DUAL=**CHURNING** (corrective: refactor — extract `sliceDualTransportInv` top-level def before ≃ₗ packaging). D3′=**STUCK** (corrective: mathlib-analogy consult MUST complete + feed recipe before prover dispatch). ENGINE=**UNCLEAR/on-track** (option-b cancellation lemma; escalate to def refactor if it persists). Both A.1.c.sub poles OVER_BUDGET (31 elapsed vs 6–11 orig; ~5 of the gap are the DAG-only iters). |
| mathlib-analogist (cross-domain) | d3-mate271 | **ANALOGUE_FOUND** — `conjugateEquiv_whiskerLeft` (Mathlib `Adjunction/Mates.lean:525`) is the precise device giving the stuck factor `(pullback h).map ((sheafCompPb f).hom.app P)` a conjugate/homEquiv head that `leftAdjointUniqUnitEta_app` consumes; non-circular fallback = the `leftAdjointCompNatTrans_assoc` surjective/injective reduction Mathlib uses for the sibling `SheafOfModules.pullback_assoc`. Recipe persisted in `analogies/d3-mate271.md`. |
| blueprint-writer | repin271 | **Premise correction**: the iter-270 reviewer's "stale rename" diagnosis was WRONG. Grep of the whole Lean tree shows the 9 `unmatched_lean` pins are *expected unformalized forward references* (several intentionally abandoned: general-pullback route + route-(e)), not renames — pins already match intended names. Added in-source `% NOTE`s. No `\lean{}` change. |
| blueprint-reviewer (fast-path) | fastpath-tos271 | D3′ lane gate **SATISFIED** (Sq1-tail a–e prose sound). DUAL lane gate **blocked on ONE pre-existing prose error** (invFun ε-direction, L5914–5919) — the 9 forward-ref pins correctly reclassified as NOT a defect. |

## Gate adjudication (HARD GATE, per-file)
- **TensorObjSubstrate.lean (D3′)** — chapter `Picard_TensorObjSubstrate.tex`; re-review SATISFIED for this lane. ADMITTED.
- **DualInverse.lean** — same chapter; re-review blocked solely on the invFun ε-direction prose error. I corrected it directly (plan-agent prose + `\lean{}` hint domain) — verbatim per the re-review's own must-fix instruction (the corrected text describes `dualUnitRingSwapHom = inv(ε(restrictScalars (f.appIso W'').hom.hom))`, which is already Lean-verified axiom-clean), and added the two requested `\lean{}` pins. Gate now satisfied. ADMITTED.
- **CechHigherDirectImage.lean** — chapter `Cohomology_CechHigherDirectImage.tex`: correct=true (the complete=partial is the by-design conditional-theorem posture of the ~85-iter engine; the target `lem:push_pull_functor` is correct + well-specified). ADMITTED for the `pushPullMap_comp` infrastructure work.

The 9 `unmatched_lean` forward-ref pins are documented as expected-unformalized (writer + re-review concur); not a gate blocker.

## Correctives EXECUTED this phase (not deferred to provers)
- **D3′ STUCK** → cross-domain analogist completed BEFORE dispatch (pc271 hard requirement); its `conjugateEquiv_whiskerLeft` recipe is cited in the objective. NOT a blind 5th re-dispatch.
- **DUAL CHURNING** → the objective makes the `sliceDualTransportInv` top-level extraction a PREREQUISITE (pc271's named refactor corrective), not an optional optimization.
- **OVER_BUDGET** → STRATEGY.md A.1.c.sub row re-estimated 12–20 → 18–30 with DAG-pause accounting; engine row updated to record the `pushPullMap_comp` definitional kernel blocker.

## Decision made — ENGINE option (b) vs (a)
- **Chosen**: option (b), a *generalized* kernel-cheap eqToHom-transport cancellation lemma (free equality variable, `subst`-then-`rfl`, applied by `rw`/`simp`) — DISTINCT from the iter-265 prover's failed concrete `exact`-instantiated subst-helper (which forced the kernel to recheck the eqToHom defeq at concrete types). Keeps the hard-won `pushPullMap_id` intact.
- **Why not (a) now**: refactoring `pushPullMap`'s definition transport-light is higher-risk (breaks `pushPullMap_id`, re-prove needed) and pc271 says (b) is the sensible single-iter next step.
- **Reverse signal**: if (b) also hits the kernel whnf wall (the blow-up is in the *definition*), escalate to option (a) via the refactor subagent next iter.

## Subagent skips
- strategy-critic: STRATEGY.md edits this iter are confined to the pc271-mandated OVER_BUDGET re-estimate + the engine-blocker status line — no route swap, decomposition change, or new Mathlib gap. Prior verdict (sc264) SOUND with no live challenge; routes unchanged. Skip per descriptor condition.
- lean-auditor / lean-vs-blueprint-checker: review-phase subagents, not plan-phase.
