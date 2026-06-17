# Iter-230 (Archon canonical) — review

## Outcome at a glance

- **The "binding probe fails — the shared root does NOT serve the C-consumer; the
  multi-iter escalation tripwire fires" iter.** The funded Decision-1 sheaf internal-hom
  descent re-route for `exists_tensorObj_inverse` (committed iter-219). One prover (opus,
  mode `prove`), result **PROBE / DOES-NOT-CLOSE** — a decisive *negative* verdict that the
  iter-230 plan pre-committed as the tripwire-firing outcome.
- **The probe verdict is DOES NOT CLOSE.** Wiring the C-consumer `dual_restrict_iso`
  (residual `(PresheafOfModules.pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`)
  through the iter-229 shared bridge `overSliceSheafEquiv` does **not** typecheck (live
  `lean_goal` / `lean_multi_attempt`; `overSliceSheafEquiv` is literally "Unknown constant"
  at the residual site + type-incompatible). Decomposition in `informal/dual_restrict_iso.md`.
- **Root cause (verified, decisive — three independent reasons):**
  1. **Sheaf vs presheaf** — the root is `Sheaf … A ≌ Sheaf … A`; the residual is
     `PresheafOfModules`-level (Step 3 stripped the outer sheafification), and the root is
     defined later in the file (L2366), so it is not even in scope.
  2. **Fixed-value-cat vs varying-ring module** — the root is parametric in a *fixed* value
     category `A`; the residual is `ModuleCat` over the *varying* ring `𝒪_Y(V)`. The per-`V`
     `internalHomObjModule` action is exactly what a value-cat-fixed site equivalence does
     not transport for free.
  3. **Whole-`U` slice site vs per-open slices** — the dual's value uses `restr W =
     pushforward₀ (Over.forget W)` (a single-`W` slice), finer than the whole-`U` slice site.
  The iter-229 "both bridges reduce to this one root" thesis is therefore **half-falsified**:
  the A-engine `homOfLocalCompat` (value cat `Type`) IS the case the root cleanly serves, but
  the C-bridge is not — and `exists_tensorObj_inverse` needs C.
- **Sorry trajectory:** project **80 → 80** (canonical, `meta.json`; sum independently
  re-derived). TensorObjSubstrate.lean file-local **3 → 3** at **L659**
  (`isLocallyInjective_whiskerLeft_of_W`), **L2188** (`exists_tensorObj_inverse`), **L2253**
  (`addCommGroup_via_tensorObj`) — verified first-hand via `lake env lean` sorry warnings.
  No decl landed; no sorry pinned (FORBIDDEN constraint honoured). The substrate file grew
  with a `/-! … -/` diagnostic block (the probe scaffolding was added then folded into a
  comment) — the "4th cost-growth signal", but no committed declaration.
- **Build GREEN** (`lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate.lean` EXIT 0,
  re-run first-hand). **Blueprint-doctor CLEAN** (no orphans, no broken refs).
- **`sync_leanok` iter-230, sha `f36786be`, +0 / −0, chapters_touched: []** — no marker
  churn, consistent with a probe-only iter (no laundering possible).

## The defining tension — the escalation chain reached its terminal node

iter-227 wired a tripwire; iter-228 it fired once (genuine C hard-block at H2′); iter-229
the planner reframed to a *shared root* (`overSliceSheafEquiv`) on the thesis that A and C
both reduce to it, and funded that root axiom-clean. iter-230 is the **binding test of that
thesis** — and it is the cleanest possible refutation of the C half:

- The root is built correctly and intact (L2366, axiom-clean per iter-229). The failure is
  not a build regression — it is that the root, by its type, *cannot* close the C-consumer.
  The strategy-critic ts230 risk-localization ("the suspected 4th cost growth is entirely
  concentrated in C — value cat ModuleCat over the varying `𝒪_X(U)`") is now **confirmed as
  a hard block**, exactly as it predicted, and exactly the C-outcome-(ii) the plan asked the
  prover to report.
- This is the correct, pre-agreed outcome, not a prover or planner error. The iter-230 plan
  defined success as moving the counter 80→79 and pre-committed: "if 80→79 fails this iter,
  the planner must NOT plan iter-231 as another infra round — escalate the fork to the USER."
  The prover delivered the decisive negative datapoint with no stub; the escalation now binds.
- **The honest arc read:** 11 consecutive iters (217→230) of axiom-clean infrastructure with
  the project sorry counter flat at 80, and the convergence thesis the last three iters were
  built on is now empirically refuted for the C-consumer. The decision the USER owns: lift
  the RR-pause for the divisor `Pic⁰` route, vs. sanction the genuinely-needed varying-ring
  slice-internal-hom comparison sub-build (~150–300 LOC, with real `Over.map` coherence risk
  — strictly larger than the fixed-value-cat `overSliceSheafEquiv` already built).

This is not a knock on the prover (ran the decisive probe, diagnosed the mismatch precisely
with live datapoints, refused to stub, wrote the decomposition) nor on the iter-230 planner
(funding the shared root then binding-testing it C-first, per the strategy-critic's
risk-localization, was the correct way to either converge or surface the blocker
definitively). It is an honest read of the arc: the convergence bet did not pay out, and the
route has reached the USER-decision node it was heading toward since iter-227.

## Process correctness

- **Prover: textbook honest-negative.** Decisive `lean_goal` / `lean_multi_attempt` probe;
  precise three-part root-cause diagnosis; no stub, no pinned sorry; decomposition written to
  `informal/dual_restrict_iso.md`; build left green. Reported the C-outcome (ii) the plan
  required. One side-note: the prover tried the `archon-informal-agent` for a second opinion
  but the MOONSHOT/Kimi key returned 401 — the external-LLM consult is unavailable this
  session (not a blocker; noted for tooling).
- **Planner: pre-commitment honoured.** iter-230 was a single-prover binding probe with the
  escalation pre-wired on a failed 80→79. That condition is met; the escalation binds.
- **Caveat on the iter-229 framing (recorded for the next planner).** iter-229's KB/review
  recorded "both consumers reduce to this root" as load-bearing. iter-230 shows that holds
  for A (Type-valued) but is **false for C** (module-valued, varying ring). The iter-229
  bridge is still genuine, axiom-clean, upstream-PR-shaped infrastructure — simply
  *insufficient* for the inverse.

## Verification performed (first-hand)

- `lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate.lean` → EXIT 0 (GREEN); sorry
  warnings at L659, L2188, L2253 (file-local 3).
- `meta.json` sorry_total = **80** (canonical, unchanged).
- `overSliceSheafEquiv` present at L2366; the probe comment block at L2132/L2137/L2157
  correctly records "CANNOT be discharged by the shared root".
- `informal/dual_restrict_iso.md` present, verdict = DOES NOT CLOSE, three-part reason.
- blueprint-doctor iter-230: CLEAN. `sync_leanok-state.json`: iter 230, +0/−0.

## Subagent findings (both dispatched and returned this iter)

- **lean-auditor ts230** (6 must-fix, 10 major, 6 minor) — report:
  `task_results/lean-auditor-ts230-auditor.md`. **All 6 must-fix are PRE-EXISTING**, not
  introduced this iter: 3 load-bearing sorries in TensorObjSubstrate (L659/L2188/L2253);
  `RelPicFunctor.lean:235` `PicSharp` flagged as a weakened-wrong placeholder (constant
  functor at `PUnit`) — this is a *known long-standing scaffold*, not a regression, but the
  auditor (no strategic context) is right that it is a placeholder standing in for the real
  `Pic^♯` quotient; `IdentityComponent.lean` `Pic0Scheme` excuse-comment sorry. Major items:
  stale `tensorObj_assoc_iso` docstring (claims flat-whiskering; proof uses ROUTE (d)),
  the vestigial `FlatWhisker` section (off critical path), ~17 `Sheaf.val` deprecations,
  unused `hM/hN/hP`. → seeded into recommendations as a comment-hygiene / refactor pass,
  deferred until the USER route decision (no point polishing a possibly-abandoned substrate).
- **lean-vs-blueprint-checker ts230** (0 must-fix, 2 major) — report:
  `task_results/lean-vs-blueprint-checker-ts230-lvb.md`. Lean matches the blueprint for all
  landed decls; the probe scaffolding (a comment, no decl) is correctly unpinned. Two
  blueprint-writer items: (1) `lem:open_immersion_slice_sheaf_equiv` proof sketch still names
  `IsDenseSubsite.sheafEquiv` instead of the landed `Equivalence.sheafCongr` (carryover from
  iter-229, non-blocking); (2) the chapter prose still implies the consumers reduce cleanly
  to the shared root — **now falsified by the probe** — and should record the varying-ring
  slice-internal-hom gap. → recommendation #3.
