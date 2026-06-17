# Session 230 — recommendations for the next plan agent

## 0. PRIMARY: the route is escalated to the USER — do not silently continue it

The iter-227/228/229/230 pre-committed tripwire **fired** this iter (binding probe
DOES-NOT-CLOSE; project sorry stayed 80→80). The next plan phase must **surface the RR-pause
fork to the USER** (it is already on TO_USER as a planner decision), not auto-assign another
prover round on the tensorObj substrate. The two options:

1. **Divisor `Pic⁰` route** — requires lifting the RR-pause (numbered ~2000–4000 LOC: Serre
   duality + H¹-vanishing + RR formula, Mathlib-absent). Sidesteps `exists_tensorObj_inverse`.
2. **Sanction the varying-ring slice-internal-hom comparison sub-build** (~150–300 LOC, real
   `Over.map` coherence risk) PLUS the A-engine `homOfLocalCompat`. Only both close the inverse.

Frame honestly: 11 iters (217→230), project sorry flat at 80, and the iter-229 convergence
thesis is refuted for the C-consumer.

## 1. Do NOT re-bet on `overSliceSheafEquiv` for the C-bridge

It is sheaf-level and fixed-value-category; `dual_restrict_iso` is presheaf-level and
varying-ring-module. Confirmed un-closable this iter (live `lean_multi_attempt`: "Unknown
constant" + type-incompat). Recorded as a Known Blocker. Any plan routing C through it repeats
iter-230.

## 2. Do NOT build the A-engine `homOfLocalCompat` in isolation

A (value cat `Type`) IS served by the shared root, but `exists_tensorObj_inverse` needs BOTH A
and C. Building A alone closes nothing route-relevant.

## 3. Blueprint-writer pass needed (lvb ts230 — 2 major, both prose)

`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`:
- The chapter prose still implies the consumers reduce cleanly to
  `lem:open_immersion_slice_sheaf_equiv` — **now falsified by the probe**. Record the
  varying-ring slice-internal-hom gap (per `informal/dual_restrict_iso.md`).
- The `lem:open_immersion_slice_sheaf_equiv` proof sketch still names
  `IsDenseSubsite.sheafEquiv`; the landed proof uses `Equivalence.sheafCongr` on
  `Opens.overEquivalence` (carryover from iter-229 lvb). Correct the sketch.
Do this before any further prover work on this file (if the USER sanctions option 2).

## 4. Lean comment-hygiene / refactor pass overdue (lean-auditor ts230 — 6 must-fix)

All 6 must-fix are **pre-existing**, none introduced this iter — so they do not block the
escalation, but they should be cleared once the route decision is made:
- `RelPicFunctor.lean:235` `PicSharp` = constant functor at `PUnit` (known scaffold, but a
  genuine weakened-wrong placeholder for the real `Pic^♯` quotient). The highest-value item if
  the substrate route continues.
- `IdentityComponent.lean` `Pic0Scheme` excuse-comment sorry.
- 3 load-bearing sorries in TensorObjSubstrate (L659/L2188/L2253) — open by design.
- Major: stale `tensorObj_assoc_iso` docstring (claims flat-whiskering; proof uses ROUTE (d));
  vestigial `FlatWhisker` section (off critical path — candidate for deletion); ~17 `Sheaf.val`
  deprecations; unused `hM/hN/hP`.
Recommend a `refactor` pass — but **defer until the USER route decision** (no point polishing a
possibly-abandoned substrate).

## 5. Tooling: external-LLM consult unavailable

`archon-informal-agent.py` returned HTTP 401 (MOONSHOT/Kimi key) when the prover tried a second
opinion. If the next iter needs an external sketch, the API key must be refreshed first.

## 6. progress-critic status

Route remains **STUCK + OVER_BUDGET** (11 iters flat since iter-217; the 4th cost-growth signal
is now confirmed as a hard block, not friction). This is no longer a grace-window question — the
pre-committed escalation has bound. The corrective is the USER decision in item 0, not another
helper round. Do NOT re-assign the C-bridge or the A-engine without a route decision.
