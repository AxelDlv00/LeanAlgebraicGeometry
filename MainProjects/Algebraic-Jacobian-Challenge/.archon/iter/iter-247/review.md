# Iter-247 (Archon canonical) — review

## Outcome at a glance

- **The "architecture-first refactor pays off: RPF's +3 regression is reversed and its bridges collapse to
  upstream citations, while Lane TS reduces D2' one further level but again does not close it" iter.** Two
  prover lanes, both `partial`/`opus`; one plan-side `refactor` that broke the
  `TensorObjSubstrate ↔ RelPicFunctor` import cycle.
  - **Lane RPF** (`Picard/RelPicFunctor.lean`, prove): **local sorry 4 → 0.** The 4 iter-246 stopgap
    typed-`sorry` bridges and 5 local pure-Mathlib substrate copies were eliminated; ~10 use sites retargeted
    to upstream `Modules.*`. `isLocallyTrivial_unit` closed with a **real axiom-FREE proof**
    (`restrictFunctorIsoPullback ≪≫ pullbackUnitIso`, side-stepping the iter-246 `Final`-instance quirk).
    `PicSharp.addCommGroup` is now a real `AddCommGroup` whose only `sorryAx` is the upstream
    `exists_tensorObj_inverse`. **Net project sorry −3** — the iter-246 parallel-lane regression is undone.
  - **Lane TS** (`Picard/TensorObjSubstrate.lean`, mathlib-build, critical path): **2 axiom-clean decls
    LANDED** — `presheafUnit_comp_map_eta` (the genuinely-new presheaf-side mate driver) and
    `isIso_sheafifyEta_of_unitSquare` (IsIso plumbing). The η-bridge now reduces to a single morphism equation
    `hsq`; the square itself was transposed to the concrete identity (**) with a paper-complete 7-step
    telescope captured, but **NOT closed** — left unpinned (no sorry). File sorry **1 → 1**.
- **Canonical critical-path counter: flat — NINTH consecutive iter (239–247).** The two pre-existing Picard
  sorries (`exists_tensorObj_inverse`, and the RPF functor-layer placeholders) are untouched. BUT the raw
  project sorry count fell −3 (RPF stopgap retirement), and Lane TS reduced its residual one level.
- **Build GREEN** both files. `sync_leanok` ran at sha `1dbd1b97`, **+21 / −1**. Axioms re-verified first-hand
  (see summary). The `lean_verify` "opaque" flag at L465 is the word in a prose comment — not laundering.
- **Blueprint-doctor: 4 broken cross-refs — all 4 target labels actually EXIST**; the breakage is a stray
  `\leanok` lodged inside `\uses{}` braces (persistent since iter-246, grown 1 → 4).

## The defining tension — RPF converged locally, Lane TS reduced-but-did-not-close again

The architecture-first call the iter-246 review prescribed was executed cleanly: the cycle was broken by
moving 2 *dead* decls and flipping one import (far cheaper than the prover's suggested "Core.lean split"),
and Lane RPF then did exactly the keepable work it could not do last iter — retire the fragile local
duplication and cite the real upstream substrate. The +3 regression is gone; `addCommGroup` is real modulo
exactly one upstream bridge. That is a genuine, verified win and the correct sequencing.

Lane TS is the honest other half. For the *third* iter running (245 reduction brick → 246 δ-wrapping → 247
η-bridge helpers) the critical-path content has been "reduce the residual one more level, land axiom-clean
helpers, do not close the goal." This iter's two decls are real and the residual is now a single morphism
equation with every lemma in hand — but D2' did not close, and the iter-247 plan's own armed reversing signal
("another named-residual PARTIAL with no goal closure ⇒ iter-248 STUCK + user escalation") is now exactly
met. The next Lane TS dispatch is the last bounded attempt before the route must be classified STUCK.

**Honest framing for iter-248:** (1) Lane TS gets ONE bounded attempt at `hsq` via the documented telescope;
if it returns yet another named-residual PARTIAL, run progress-critic and escalate to the user — do not pivot
or dispatch a 5th helper round. (2) The `\leanok`-in-`\uses` bug is in actor-deadlock and has persisted two
iters; the plan agent must resolve it explicitly (writer reflow + delete, or user-side sync fix) — it cannot
keep being "flagged for next iter." (3) RPF has no reachable local work until Lane TS D4' lands; keep it on
hold and schedule only a prover comment-fix for its now-stale docstrings.

## Reversing signals — read against outcomes

- **Lane TS armed signal (iter-247 plan):** *"if the η-bridge returns ANOTHER named concrete residual PARTIAL
  (no goal closure, no D3' brick), the sorry-stasis exemption is EXHAUSTED → iter-248 classify STUCK and
  escalate."* **TRIGGERED in spirit this iter** (named-residual PARTIAL, no closure). Carried into iter-248 as
  a hard gate: one more such PARTIAL = STUCK. Correctly framed; do not soften it.
- **Lane RPF monitoring (iter-247 plan):** "sorry returns to ≤1." **MET** (local 0, 1 upstream cone). The
  architecture-first corrective was the right call; the +3 regression is reversed. Signal satisfied.
- **Old Lane TS signal (carried from 245):** "if D3' proves harder than its unit analog, decompose — do NOT
  revive the general Lan build." Not triggered (D3' not reached). Still live, still correct.

## Subagent results

- **lean-auditor (iter247):** both files compile error-free; the 2 new TS decls are genuine, correctly typed,
  sorry-free. **2 must-fix** on RPF — the module-header state claim (L32–34, now factually wrong post-landing)
  and the `PicSharp` excuse-comment "placeholder" on a load-bearing weakened-wrong body (L477). 3 major
  (stale gate descriptions), minors (`Sheaf.val` deprecations ×43, long lines, stale "D2' sole residual"
  comment). All `.lean`-prose — prover-domain fixes scheduled (recommendations H3).
- **lean-vs-blueprint-checker (rpf):** 4 must-fix placeholders (PicSharp/functorial/presheaf/etSheaf — all
  PRE-EXISTING, gated on D4'), 1 major `\leanok`-in-`\uses`, 1 major proof-sketch Step 2–4 divergence. The
  `addCommGroup` construction itself is genuinely real and matches the lemma.
- **lean-vs-blueprint-checker (ts):** **NO must-fix.** Chapter is honest — D2'/D3'/D4' correctly unmarked,
  the 2 new supplements implement exactly what the D2' sketch describes. Minors: 3 `\uses{\leanok}` bugs,
  missing `\leanok` on `lem:tensorobj_unit_iso` (sync miss).

Full reports: `task_results/{lean-auditor-iter247, lean-vs-blueprint-checker-rpf-iter247,
lean-vs-blueprint-checker-ts-iter247}.md`.

## Blueprint markers (manual) — none this iter
No `\mathlibok` applicable (the new decls are project proofs, not Mathlib re-exports); no `\lean{...}` renames
(the moved `tensorObjOnProduct` kept its qualified name); no `\notready` in the touched chapters. The
`\leanok`-in-`\uses` bugs are sync-owned — NOT touched by review (constraint + iter-246 precedent), escalated
to the plan agent instead.
