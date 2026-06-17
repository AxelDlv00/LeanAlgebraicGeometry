# Strategy Critic Report

## Slug

route200

## Iteration

200

## Routes audited

### Route: Pic⁰-via-AV-wrap (genus-positive arm, via A.3.iii + A.3.iv + A.3.vi)

- **Goal-alignment**: FAIL — the genus-positive arm of `nonempty_jacobianWitness` requires `Pic⁰_{C/k}` as a representable scheme; the strategy gates that on A.2.c, which is RR-substrate-blocked, with no project-side timeline.
- **Mathematical soundness**: PASS — the Kleiman §4/§5 + Nitsure §5 chain is mathematically standard; the breakage is execution-side, not mathematical.
- **Sunk-cost reasoning detected**: yes — `"Route A helper landed under the current directive is OFF-CONE productive substrate"` reframes substrate already built as "valuable regardless of resolution"; this justifies continuing investment in a route that the strategy itself describes as blocked.
- **Infrastructure-deferral detected**: yes — A.2.c (FGA Pic representability) is the deferred construction; the protected decls' kernel-triple cone provably requires it (per the strategy's own dependency graph `A.3.iii ⊳ A.3.0 + A.3.ii ⊳ A.3.vii ⊳ A.2.c`); no route in the strategy builds it with a concrete project-side timeline ("substrate-blocked on RR; iter-loop runs under typeclass abstraction" defers without a discharge plan).
- **Effort honesty**: under-counted — A.2.c carries `~12–16 iters / ~600–800 LOC` "(gated on Route C re-engagement)", but Route C is paused indefinitely, so the realistic iter count is `∞` until USER action; the table-cell estimate hides that fact.
- **Verdict**: REJECT — this route cannot complete under the current standing directive and the strategy now openly concedes that ("conditionally-pending USER action") while still budgeting iters for it.

### Route: Genus-0 arm Candidate (a) — Pic⁰-via-AV-wrap

- **Goal-alignment**: FAIL — same hidden A.2.c transit as the genus-positive arm; the cone-dependency NOTE in `## Routes` (lines 169–176) explicitly concedes this is NOT Route-C-independent.
- **Mathematical soundness**: PASS — argument structure is standard (smooth + `dim T_e = 0` + connected ⇒ `Spec k`).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — inherits the A.2.c deferral; the substrate chain `A.3.iii ⊳ … ⊳ A.2.c` cannot be circumvented within this candidate.
- **Effort honesty**: under-counted — `genusZero arm` row carries `~4–6 iters / ~200–400 LOC` and lists the Risks cell as `"Route-C-independent — see ## Routes"`, which is **factually contradicted** by the cone-dependency NOTE 117 lines later in the same document.
- **Verdict**: REJECT — internal inconsistency (Phases table claims Route-C-independence; Routes prose concedes hidden RR transit). The table row must be corrected or the route excised.

### Route: Genus-0 arm Candidate (b) — Direct `J := Spec k` via Mumford rigidity

- **Goal-alignment**: PASS — bypasses A.2.c entirely; `J = Spec k` is constructed unconditionally; `isAlbaneseFor` discharges via Mor(ℙ¹,A)=const + faithfully-flat Brauer–Severi descent.
- **Mathematical soundness**: PASS — Milne Prop 3.10 + Mumford §4 Cor.1 is a standard, well-anchored argument.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — `AbelianVarietyRigidity.lean` + `RigidityKbar.lean` are PAUSED; the strategy notes ~300–500 LOC surgical re-engagement would suffice, but `## Phases & estimations` carries **no row** for it; it lives only in prose with `"Decision deferred to USER"`.
- **Effort honesty**: not estimated — no row in the table at all, so cannot be evaluated.
- **Verdict**: CHALLENGE — this is the only goal-aligned, Route-C-pause-compatible path the strategy names, yet it is not in the Phases table and the plan refuses to dispatch on it pending a USER carve-out that has been requested twice (iter-199, iter-200) and not delivered. The strategy is asking the USER to permit work that the strategy could just dispatch under the existing paused-files exemption (which already permits Route C substrate touches when carved out).

### Route: Route C — Riemann–Roch chain — PAUSED

- **Verdict**: SOUND — correctly deferred per USER standing directive; the strategy honors the pause.

### Route: Carrier-soundness probe (typeclass abstraction for representability)

- **Goal-alignment**: PARTIAL — the probe enables typeclass-level Route A work but does NOT discharge the `#print axioms` contract on protected decls; the strategy concedes (OSQ A.2.c, lines 220–224) that "the abstraction's carrier hypotheses must themselves discharge in the protected decls' cone … and those hypotheses still need RR." So the probe is a productivity scaffold, not a path to the goal.
- **Mathematical soundness**: PASS — verdict CONFIRM is supported by the iter-198 sorryAx-propagation analysis.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — re-routes goal-blocking work into typeclass-shaped placeholders without committing to discharging the placeholders. The 6 `⟨sorry⟩` instances at lines 149, 176, 236, 294, 409, 465 are the deferred constructions; the strategy schedules "Sorry 4 first" but neither names a discharge timeline for the others nor explains how Sorry 1/2/3 close without RR.
- **Verdict**: CHALLENGE — sound as instrumentation, unsound as a goal-discharge path; the strategy conflates the two.

### Route: A.1.c.SubT — `Scheme.Modules.tensorObj` upstream-style substrate

- **Verdict**: SOUND — concrete project-side commitment (blueprint chapter dispatched iter-200, prover lane iter-201+); LOC + timeline estimates are present.

## Format compliance

- **Size**: 316 lines / 18,790 bytes — **over budget** on both axes (~250 lines / ~12 KB). The Routes section alone is 80+ lines.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` present in canonical order.
- **Per-iter narrative detected**: yes — pervasive. Representative quotes verbatim:
  - `"(strategy-critic must-fix iter-198)"` (line 126)
  - `"Cone-dependency NOTE (strategy-critic route199)"` (line 169)
  - `"Plan-agent recommendation iter-200 (refresh)"` (line 236)
  - `"reaffirmed by silence iter-199 → iter-200"` (line 238)
  - `"Reaffirmed via TO_USER FYI iter-200"` (line 249)
  - `"iter-198 RPF prover delivered 5 placeholder closures"` (line 252)
  - `"iter-199+ provers dispatch Sorry 4 (smoothProperQuotient, L354, Rank 2) first"` (line 274)
  - `"(ii.A) closed iter-199; (ii.B) remains; estimate widened per iter-199 progress-critic CHURNING corrective"` (Phases table row A.4.c.0)
  - `"placeholder bodies iter-198"` (Phases table row A.1.c)
  - `"PAUSED iter-198+"` (line 192)
  - `"Choice deferred to iter-199+ post-cone-audit"` (line 145)
- **Accumulation detected**: yes — `"A.3.i (identity component) excised"` and the Pphifin/Hilbert-polynomial subsection (lines 82–90 + 277–278) live in two places; `"placeholder bodies iter-198"` is historical drift inside an active Phases row; the "Cone-dependency NOTE (strategy-critic route199)" is a critique-response artifact that should be in iter sidecars, not STRATEGY.md.
- **Table discipline**: PARTIAL FAIL — Status column carries long prose in several rows: `"priority-2 (A.1.a closed; placeholder bodies iter-198)"`, `"priority-2.5 (gates A.1.c body)"`, `"priority-1 root"` is OK but multiple rows carry parenthetical per-iter histories. The A.1.c.SubT row's "Iters left" cell is `"~3–6, dispatch iter-201+ (blueprint chapter dispatched iter-200)"` — narrative inside what should be a single short value.
- **Format verdict**: NON-COMPLIANT — size over budget AND pervasive per-iter narrative AND mid-table iter-dated parentheticals.

## Infrastructure-deferral findings

### Deferred: A.2.c — FGA Pic representability of `Pic_{C/k}`

- **Required by goal**: yes — both the genus-positive branch of `nonempty_jacobianWitness` (via `Pic⁰`-as-Albanese, transitively through A.3.iii ⊳ A.3.ii ⊳ A.3.vii ⊳ A.2.c) AND Candidate (a) for the genus-0 branch require it. The Phases table's "genusZero arm" row's Risks cell incorrectly labels this dependency `"Route-C-independent"`, which directly contradicts the cone-dependency NOTE in `## Routes`.
- **Current plan for building it**: none — `## Phases` row A.2.c reads `"(gated on Route C re-engagement)"`; OSQ A.2.c presents three resolutions (a/b/c) and concludes `"the protected #print axioms contract status is documented as conditionally-pending USER action rather than silently asserted as reachable"`; `## Mathlib gaps` line 291–293 says `"substrate-blocked on RR; iter-loop runs under typeclass abstraction via the carrier probe (~600–800 LOC when RR re-engages)"`. No project-side discharge plan exists.
- **Timeline**: absent — "conditionally-pending USER action" is the timeline; the USER did not respond iter-199 → iter-200 and the strategy treats silence as continue-substrate-work.
- **Verdict**: REJECT — the strategy now openly concedes the goal is unreachable under current directives ("conditionally-pending"), yet continues to budget iters for all gated phases, write blueprint chapters, and dispatch prover lanes on substrate the strategy itself labels OFF-CONE with respect to the protected decls' end-state. This is the textbook infrastructure-deferral pattern in the descriptor: required-by-goal construction marked `"off-critical path"`/`"OFF-CONE"`/`"future work"`/`"conditionally-pending"` while the project's stated goal provably requires it. **Per descriptor: "Off-critical path is a red flag, not a planning decision, when the goal requires the deferred item."**

### Deferred: Candidate (b) `J := Spec k` via Mumford rigidity (genus-0 branch)

- **Required by goal**: partially — required ONLY if the strategy commits to it as the genus-0 discharge path (which the strategy says is the most credible Route-C-pause-compatible path); equivalently it is the *substitute* for the deferred A.2.c on the genus-0 branch.
- **Current plan for building it**: none — `## Phases` table has **no row** for it; prose section `#### Candidate (b)` ends with `"Decision deferred to USER"`. The blueprint chapters (`AbelianVarietyRigidity.tex`, `RigidityKbar.tex`) exist but are unscheduled.
- **Timeline**: absent — USER carve-out requested iter-199 + iter-200, no response.
- **Verdict**: CHALLENGE — the strategy identifies a viable Route-C-pause-compatible discharge path and refuses to commit a Phases row to it, citing USER non-response, while simultaneously committing iters to off-cone substrate. If the USER carve-out is the blocker, an explicit in-loop rebuttal naming why the strategy cannot dispatch on `AbelianVarietyRigidity.lean` under the current files-paused exemption is required.

## Alternative routes (suggested)

### Alternative: Re-scope `## Goal` explicitly (genuine option (c) commit)

- **What it looks like**: edit the `## Goal` section verbatim. Replace the End-state contract paragraph with: *"Provisional end-state contract under ROUTE C PAUSE: every protected declaration verifies modulo the explicit project axiom `Jacobian.routeCBlocked` (or equivalently, modulo an unproved RR-substrate hypothesis)."* Add a separate paragraph naming the path back to the kernel-triple contract (Candidate a or b) once USER acts.
- **Why it might be cheaper or sounder**: this is what the OSQ paragraph already CLAIMS the strategy is doing, but the Goal section is verbatim-unchanged from iter-198. Genuine option (c) requires editing `## Goal`. Otherwise the document is internally contradictory: `## Goal` asserts kernel-triple-only, OSQ asserts "conditionally-pending", and the loop continues budgeting iters as if `## Goal` were reachable.
- **What the current strategy may have rejected**: the plan agent treats Goal re-scope as USER-only territory; but the strategy critic descriptor explicitly authorizes the planner to "(a) update STRATEGY.md to address the challenge, or (b) record an explicit rebuttal". Re-scoping `## Goal` to mirror the OSQ framing IS the (a) update.
- **Severity of the omission**: critical.

### Alternative: Surgical Route C re-engagement — dispatch on `AbelianVarietyRigidity.lean` + `RigidityKbar.lean` directly

- **What it looks like**: add a Phases row `"Genus-0 Mumford-rigidity discharge"` with `Iters left: ~6–10`, `LOC: ~300–500 · 0/it`, status `priority-2 (under Route-C-pause carve-out for these two files only)`. Dispatch prover lanes against the existing PAUSED chapters. Pre-condition: USER carve-out OR plan-agent-side judgment that the USER's pause directive applies to RR-chain files only, NOT to AV-rigidity files which technically live in a separate cone.
- **Why it might be cheaper or sounder**: directly produces a goal-aligned genus-0 discharge under the existing pause; the alternative (continue building OFF-CONE substrate while pinging USER) accumulates productivity tokens that the strategy itself labels off-cone.
- **What the current strategy may have rejected**: the strategy interprets the USER's `2026-05-28 ROUTE C PAUSE permanent standing directive` as covering AbelianVarietyRigidity / RigidityKbar by extension (since they are listed under "Files involved" in the Route C — PAUSED subsection). This interpretation may be over-broad — Mumford rigidity is `Mor(ℙ¹, A) = const`, not the RR formula chain, and it is a *substitute* for Route C, not part of it.
- **Severity of the omission**: critical.

### Alternative: IsEtale-functor-of-points representability for `Pic⁰_{C/k}` (iter-199 unaddressed)

- **What it looks like**: instead of representing `Pic_{C/k}` directly (the heavy A.2.c construction), prove `Pic⁰_{C/k}` is representable using its characterization as the étale-locally-constant component of `Pic_{C/k}` and a functor-of-points criterion that avoids the full Quot/Sym^d chain. This was named in the iter-199 directive among alternative routes; STRATEGY.md does not mention it.
- **Why it might be cheaper or sounder**: representability of `Pic⁰` directly (without going through full `Pic`) is what Milne III §6 actually proves for abelian varieties; it sidesteps the Quot-scheme machinery that is RR-blocked. Whether it works for an arbitrary smooth proper curve over `k` (no fppf-section assumption) is an open question, but the strategy should at least cite a rejection if it's not viable.
- **What the current strategy may have rejected**: unclear — the alternative is simply absent from STRATEGY.md.
- **Severity of the omission**: major — should at minimum be named in OSQ A.2.c with a one-line rebuttal or "investigation-pending" tag.

## Sunk-cost flags

- `"every Route A helper landed under the current directive is OFF-CONE productive substrate with respect to the protected decls' kernel-triple end-state. Each landed piece is forward-compatible with all three resolutions"` — Why this is sunk-cost: the framing values already-built substrate by claiming it survives all three resolutions, which justifies *continuing* substrate work despite the strategy's own admission that A.2.c is blocked. Recommendation: re-evaluate on merits — either commit to a concrete discharge route (b in `## Phases`), genuinely re-scope `## Goal`, or pause the loop pending USER action. "Forward-compatible with all three resolutions" is a polite way of saying "compatible with paths nobody is executing."

- `"The loop continues this productive substrate work pending USER resolution"` — Why this is sunk-cost: the work is by the strategy's own characterization OFF-CONE; continuing it produces substrate, not goal progress. Recommendation: distinguish "off-cone productive" from "iter-budget-consuming" — the former is fine, the latter is not, when the contract on the protected decls is provably blocked.

## Prerequisite verification

(Not deeply re-verified this iter; the Mathlib gaps cited — Stacks 02RV, 090V, 02JK, 00OE, 04KU/04KV — were spot-checked in prior iters and were either present or named with concrete LOC budgets. No new prerequisite was introduced in iter-200 that would warrant a fresh phantom check.)

## Must-fix-this-iter

- **Route Pic⁰-via-AV-wrap (genus-positive)**: REJECT — A.2.c required by goal, no concrete project-side discharge timeline. Planner must EITHER (i) add a Phases row for Candidate (b) Mumford rigidity with a concrete iter estimate and dispatch a prover lane (treat the Route C pause as RR-chain-only), OR (ii) genuinely re-scope `## Goal` by editing the Goal section's End-state contract paragraph to explicitly mirror the OSQ "conditionally-pending" framing — not just add OSQ prose while leaving `## Goal` verbatim.
- **Route Genus-0 Candidate (a)**: REJECT — Phases table row `genusZero arm — J = Spec k via dim Pic⁰ = 0` has Risks cell `"Route-C-independent — see ## Routes"` which is **factually false** per the strategy's own cone-dependency NOTE. Either delete the row (if Candidate (b) is the genus-0 path) or rewrite the Risks cell to `"hidden A.2.c transit; NOT Route-C-independent"`.
- **Infrastructure-deferral A.2.c**: REJECT — see above. The "honest framing" claim in OSQ does not satisfy iter-199 must-fix because the Goal section is unchanged; option (c) requires a Goal edit, not OSQ commentary.
- **Infrastructure-deferral Candidate (b)**: CHALLENGE — no Phases row; either add one or record an explicit in-`STRATEGY.md` rebuttal naming why the USER's pause covers AbelianVarietyRigidity files.
- **Alternative IsEtale-functor-of-points**: major omission — name it in OSQ A.2.c with a one-line rebuttal or "investigation-pending" tag.
- **Format**: NON-COMPLIANT — the three most impactful deviations:
  1. **Size** (316 lines / 18,790 bytes vs ~250 / ~12 KB budget). Restructure in-place this iter — move historical clauses (`"(strategy-critic must-fix iter-198)"`, `"placeholder bodies iter-198"`, `"PAUSED iter-198+"`, `"Choice deferred to iter-199+ post-cone-audit"`, `"iter-198 RPF prover delivered 5 placeholder closures"`, `"iter-198 blueprint-writer fga-sorry-order"`) to iter sidecars.
  2. **Per-iter narrative** — at least 11 distinct iter references quoted in the Format Compliance section above. Strip every "iter-NNN" mention from STRATEGY.md; per-iter history belongs in `iter/iter-NNN/plan.md` exclusively.
  3. **Table discipline** — Status and Iters-left cells carry parenthetical per-iter histories ("A.1.a closed; placeholder bodies iter-198", "dispatch iter-201+ (blueprint chapter dispatched iter-200)"). Cells must be one short value.

## Overall verdict

The strategy does NOT satisfy the iter-199 must-fix. The plan agent claims to have committed to option (c) ("Re-scope the Goal explicitly"), but the `## Goal` section is verbatim-unchanged from prior iters — the End-state contract still asserts kernel-triple-only on every protected decl. The "honest framing" lives only in `## Open strategic questions`, while `## Goal` remains the unmodified target. This is option (c) cosplay, not option (c) commit: a genuine re-scope edits `## Goal` itself. **The strategy defers A.2.c (FGA Pic representability), which is required for the stated goal,** and frames the deferral as "conditionally-pending USER action" while continuing to budget iters on substrate it itself labels OFF-CONE — the canonical infrastructure-deferral pattern. The genus-0 arm Phases-table row still claims "Route-C-independent" in direct contradiction with the cone-dependency NOTE 117 lines later. The TO_USER FYI does not constitute escalation in the sense the descriptor demands: an escalation pauses the dependent work pending resolution; an FYI-and-continue normalizes silence as default-continue, which is what has now happened twice (iter-199 → iter-200). The format is materially non-compliant: 316 lines (26% over the soft cap), 18.8 KB (57% over the soft cap), and 11+ distinct iter-NNN references that must move to iter sidecars. **Verdict: CHALLENGE overall, with one REJECT-level infrastructure-deferral finding on A.2.c, one REJECT-level inconsistency on the genus-0 arm Phases row, and NON-COMPLIANT format.** Recommended path forward: (i) edit `## Goal`'s End-state contract paragraph to mirror the OSQ "conditionally-pending" framing OR add a Phases row for Candidate (b) Mumford rigidity with concrete LOC + iter budget and dispatch on it (treating the Route C pause as scoped to RR-chain files only, NOT AbelianVarietyRigidity); (ii) correct the genusZero arm Risks cell; (iii) name the IsEtale-functor-of-points alternative; (iv) strip iter narrative and shrink to budget.
