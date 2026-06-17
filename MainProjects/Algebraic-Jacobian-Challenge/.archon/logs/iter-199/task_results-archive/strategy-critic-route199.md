# Strategy Critic Report

## Slug
route199

## Iteration
199

## Routes audited

### Route: Pic representability — substrate dependency on Route C, mitigated by carrier-soundness probe

- **Goal-alignment**: FAIL — the protected decls require A.2.c to discharge with sorryAx-free typeclass instances; the strategy admits no project-side path that does so without Route C re-engagement.
- **Mathematical soundness**: PASS — the FGA Quot route and Sym^d alternative are mathematically standard.
- **Sunk-cost reasoning detected**: yes — "Carrier-soundness probe permits typeclass-level abstraction in the meantime" justifies the route in terms of the probe-investment already realized rather than charting a discharge path.
- **Infrastructure-deferral detected**: yes — deferred construction is **A.2.c (Pic_{C/k} representability)**; the goal requires it (the protected decls' dependency cone transitively touches A.2.c via the A.3 ladder); the strategy's two named paths forward are (i) "USER re-engages RR" (not a project-side plan) and (ii) "A.2.c lands a representability proof under the probe's `Functor.IsRepresentable` abstraction (which embeds RR as a hypothesis of the relevant carriers)" — option (ii) renames the gap one layer deeper because the carrier hypotheses still need discharge, and the protected signatures cannot acquire a new RR hypothesis (they are frozen by `archon-protected.yaml`).
- **Phantom prerequisites**: none — Quot/Sym^d named correctly, but the proof construction is blocked on RR which is paused.
- **Effort honesty**: reasonable for the substrate work cell (~600–800 LOC for FGA representability is in line with Nitsure §5 + Kleiman §4), but the row is gated on a precondition (Route C re-engagement) that has zero LOC budgeted anywhere in the table — the *total* cost to reach A.2.c is significantly under-counted.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE (borderline REJECT — the strategy's chosen "long-term" paths do not, as stated, lead to a kernel-triple discharge of the protected decls)

### Route: Pic⁰ definition — `Pic⁰_{C/k} := PicScheme.degComp C 0`

- **Verdict**: SOUND
  - Conditional on Route 1 / A.2.c actually landing; the Pphifin pivot itself is mathematically clean and the LOC widening to ~300–600 looks honest.

### Route: Bottom-up execution priority

- **Verdict**: SOUND
  - Procedural; matches the USER standing directive.

### Route: Reference-driven proofs

- **Verdict**: SOUND
  - Procedural.

### Route: Route C — Riemann–Roch chain — PAUSED

- **Goal-alignment**: FAIL — the "cone-scoping resolution" (lines 128–145) asserts that "as Route A's Pic⁰ AV-wrap lands (A.3.iii + A.3.iv + A.3.vi), the protected decls' transitive Lean dependencies will no longer route through Route C; the final witness body for nonempty_jacobianWitness will discharge the genus-0 branch via Pic⁰_{C/k} = Spec k." But A.3.iii ⊳ A.3.ii ⊳ A.3.vii ⊳ A.2.c (per the dependency graph at lines 92–98), and A.2.c is itself "substrate-blocked on RR". So the protected cone necessarily transits A.2.c, and any sorryAx in the A.2.c discharge route propagates to the protected decl. The cone-scoping mechanism only works if A.2.c itself is sorry-free — which the strategy has no project-side plan for.
- **Mathematical soundness**: PASS for the *math* (the underlying Kleiman/Milne/Mumford route is sound); FAIL for the *strategic claim* of cone-independence.
- **Sunk-cost reasoning detected**: no (the pause is per USER directive, which is a legitimate input).
- **Infrastructure-deferral detected**: yes — deferred construction is **Riemann–Roch (Route C)**; the goal requires it (transitively via A.2.c); the strategy's plan is "deferred to iter-199+ post-cone-audit … If iter-199 cone audit shows protected decls still transitively depend on Route C sorries, this strategy reverts: either USER re-engages Route C with a budget, or the Goal is re-scoped" — no project-side plan, no concrete iter for the cone audit, no rollback budget if it fails.
- **Effort honesty**: N/A (paused; not in budget).
- **Verdict**: CHALLENGE

### Route: Genus-0 arm — Route A zero-dim group-scheme argument

- **Goal-alignment**: PARTIAL — the 8-step chain is mathematically correct, but the strategy's terminal claim "This chain is **independent of RR / Route C**: uses only the H¹-definition of genus, the A.3 Pic⁰ AV-structure wrap, and the Mathlib étale-group-scheme triviality theorem" is **factually wrong**. The "A.3 Pic⁰ AV-structure wrap" (steps 2, 4, 6 invoke A.3.iii, A.3.iv, A.3.vi) transitively requires A.2.c (per the dependency graph at lines 92–98: A.3.iii ⊳ A.3.0 + A.3.ii ⊳ A.3.vii ⊳ A.2.c), and A.2.c is "substrate-blocked on RR" by the strategy's own admission.
- **Mathematical soundness**: PASS (the step-by-step math chain is correct).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — same A.2.c deferral re-surfacing via the genus-0 arm; the strategy presents the chain as a way to *avoid* Route C, but the dependency closure still pulls in A.2.c and therefore RR.
- **Effort honesty**: ~200–400 LOC for the chain *given* A.3.iii/iv/vi landing — reasonable for the steps that are actually new. But the row hides the upstream cost (A.2.c + A.3.* substrate) that is required before this chain can even start.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE — the "independent of Route C" assertion must be either retracted, or replaced by a concrete sub-strategy that constructs Pic⁰ via a path that genuinely sidesteps A.2.c/RR (e.g., a direct definition of `Pic⁰_{C/k}` for genus-0 curves as `Spec k` without going through `PicScheme.degComp`).

## Format compliance

- **Size**: 264 lines / 15,904 bytes — **over budget** (budget ~250 lines / ~12 KB).
- **Headings**: PASS (`## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in that order).
- **Per-iter narrative detected**: yes — extensive. Representative phrases:
  - "gap (4) closed iter-198; gaps (1)-(3) substrate-build" (table, A.4.b row)
  - "(placeholder-only iter-198)" (table, A.1.c row)
  - "(ii.A)+(ii.B) iter-discovered iter-198; Lane T32 reroutes through here; estimate widened iter-199 per progress-critic" (table, A.4.c.0 row)
  - "T32-L155 re-routed as Lane COE derivative" (table, A.4.c.1 row)
  - "(strategy-critic must-fix iter-198)" (Route C section)
  - "Choice deferred to iter-199+ post-cone-audit" (Route C section)
  - "If iter-199 cone audit shows protected decls still transitively depend on Route C sorries…" (Route C section)
  - "iter-198 RPF prover delivered 5 placeholder closures (PicSharp, functorial, presheaf, etSheaf, etSheaf_group_structure)" (A.1.c.SubT question)
  - "Tracked target for iter-200+ Lane RPF re-engagement" (A.1.c.SubT question)
  - "the iter-199 blueprint-writer `rpf-placeholder-note` annotations prevent sync_leanok from prematurely promoting the placeholder proof blocks" (A.1.c.SubT question)
  - "Carrier-soundness probe — verdict CONFIRM (per iter-198 review)" (carrier probe question)
  - "the iter-198 blueprint-writer `fga-sorry-order` produced a rank-1/2/3 closure-order partition; iter-199+ provers dispatch Sorry 4 (smoothProperQuotient, L354, Rank 2) first" (carrier probe question)
- **Accumulation detected**: yes — A.1.a "complete iter-185" is no longer in the table (good), but the "Open strategic questions" section retains iter-198 prover/review status notes that belong in iter sidecars, and the Route C section retains a multi-paragraph iter-198 audit-trail framing rather than the structural decision in canonical form.
- **Table discipline**: PASS — columns and LOC-cell formatting (`remaining · realized/it`) are correct.
- **Appendix sections**: none.
- **Format verdict**: NON-COMPLIANT — the per-iter narrative is the single largest distortion; it has grown since the iter-198 critique flagged DRIFTED and was supposedly "addressed" by stripping such references. The current document re-introduces them in every table row caveat and in three of the five Open-strategic-question bullets.

## Infrastructure-deferral findings

### Deferred: A.2.c — Pic_{C/k} representability (FGA construction)

- **Required by goal**: yes — A.3.vii ⊳ A.2.c ⇒ A.3.ii ⊳ A.3.vii ⇒ A.3.iii/v/vi ⊳ A.3.ii ⇒ the protected decls in the genus-0 *and* the genus-positive branches both transit A.2.c. Per the cone-scoping contract, sorryAx in A.2.c contaminates the protected decls' axioms.
- **Current plan for building it**: two options offered, **neither of which is a viable project-side plan**:
  - (i) "USER re-engages Route C with a budget" — this is a request to the USER, not a plan.
  - (ii) "A.2.c lands a representability proof under the probe's `Functor.IsRepresentable` abstraction (which embeds RR as a hypothesis of the relevant carriers)" — the carrier hypotheses still need discharge in the protected decls' cone, which still requires RR. The protected signatures are frozen and cannot carry an added RR hypothesis. So (ii) renames the gap one layer deeper without resolving it.
- **Timeline**: absent (priority-4, ~12–16 iters, gated on a precondition with no budget).
- **Verdict**: REJECT — the strategy lacks any project-side plan that discharges A.2.c without USER re-engagement of Route C. Per the report-format rules, infrastructure-deferral with no concrete timeline AND no project-side plan AND a goal-required construction is REJECT, not CHALLENGE.

### Deferred: Riemann–Roch / Route C

- **Required by goal**: yes (transitively via A.2.c).
- **Current plan for building it**: "PAUSED. Per USER standing directive." The strategy commits no LOC and no iters; the budget at line 54 ("Total Route A: ~140–250 iters / ~4500–8500 LOC") explicitly excludes Route C.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — Route C being paused is a USER-input fact, but the strategy must either (a) demonstrate a concrete A.2.c-discharging path that does NOT need RR (this likely requires reformulating `Pic⁰` for the genus-0 branch as a direct `Spec k` construction, bypassing `PicScheme.degComp`), or (b) escalate to the USER that Route C pause is goal-incompatible and request re-engagement. The current text papers over the gap with "USER re-engagement deferred to iter-199+ post-cone-audit" without doing the cone audit.

### Deferred: `Scheme.Modules.tensorObj` upstream-style substrate (A.1.c.SubT)

- **Required by goal**: partially — needed for the iter-198 RPF placeholder closures (`PicSharp`, `functorial`, `presheaf`, `etSheaf`, `etSheaf_group_structure`) to receive math-correct bodies; A.1.c is on the critical path.
- **Current plan for building it**: ~200–400 LOC project-side build "tracked for iter-200+ Lane RPF re-engagement". This is concrete, but vague iter assignment.
- **Timeline**: vague ("iter-200+").
- **Verdict**: CHALLENGE — the iter-198 placeholder closures are a fragile state. They will appear `\leanok`-promotable to a casual reader despite carrying non-mathematical proof bodies; the strategy relies on a single `% NOTE:` annotation to prevent premature promotion. If the planner forgets to revisit before sync_leanok churns, real correctness drift can occur. A concrete iter assignment (e.g. "Lane RPF body-swap dispatch at iter-NNN") would close this.

## Alternative routes (suggested)

### Alternative: Direct `J := Spec k` construction for genus-0, bypassing `Pic⁰` entirely

- **What it looks like**: In the genus-0 case, define `J := Spec k` directly. Prove `isAlbaneseFor (Spec k) P` by showing every `f : C → A` to an abelian variety `A` is constant. Char-general: base-change `C` to `k̄`, use that `C_{k̄}` is genus-0 + geom-irred ⇒ `C_{k̄} ≅ ℙ¹_{k̄}` (with k̄-point), apply Mumford rigidity (Mor(ℙ¹, A) constant), descend via Brauer-Severi twist faithfully-flat descent. The argument completely bypasses `Pic⁰_{C/k}` as a scheme.
- **Why it might be cheaper or sounder**: A.2.c is no longer required for the genus-0 branch. Only the genus-positive branch needs `Pic⁰`, and that branch has unequivocally non-trivial USER cost regardless — so isolating the genus-0 escape from A.2.c is strict progress. Mumford-rigidity / `Mor(ℙ¹, A) const` is already partially in scope via Route C's `AbelianVarietyRigidity.lean` / `RigidityKbar.lean` — those files are "paused" but the strategy could pivot to *finishing those specific lemmas* without the full RR chain.
- **What the current strategy may have rejected**: unclear — the strategy commits to `Pic⁰` for both branches uniformly. The Mumford direct route is not mentioned. Given the iter-198 critique flagged the same point, this is a recurring blind spot.
- **Severity of the omission**: critical — it directly addresses the A.2.c REJECT above.

### Alternative: Define `Pic⁰_{C/k}` for genus-0 as an `Algebra.IsEtale` substrate without `degComp`

- **What it looks like**: For genus-0 curves, skip the `PicScheme.degComp` pivot. Construct `Pic⁰` as the étale group scheme of dim 0 corresponding to the étale fundamental group of `C` (or directly as a sub-substrate of the Picard *functor*, without representing the full Pic). Then the `Pic⁰ = Spec k` conclusion needs only the étale-group-scheme triviality lemma + connectedness, not A.2.c (full representability of Pic).
- **Why it might be cheaper or sounder**: avoids the FGA construction entirely for genus 0. The Picard *functor* can be reasoned about as a set-valued functor at the level of `k`-points; for genus 0 it has exactly one `k`-point (the trivial line bundle), and that is enough to conclude `J = Spec k` via the Albanese UP for the trivial AV.
- **What the current strategy may have rejected**: the strategy treats representability as a precondition for any tangent-space / smoothness argument; this alternative argues the tangent / smoothness reasoning is unnecessary in genus 0.
- **Severity of the omission**: major.

### Alternative: Re-engage Route C with a narrow budget — Mumford rigidity only

- **What it looks like**: Don't reopen all of Route C. Open *only* the Mumford-rigidity / `Mor(ℙ¹, A) const` chain: `AbelianVarietyRigidity.lean` + `RigidityKbar.lean` + the descent step. Estimate ~300–500 LOC. The full RR chain (`H1Vanishing`, `RRFormula`, `OCofP`, `OcOfD`) stays paused.
- **Why it might be cheaper or sounder**: directly enables the genus-0 escape with a bounded budget. Doesn't require full RR.
- **What the current strategy may have rejected**: the strategy treats "Route C" monolithically; surgical re-engagement is not contemplated.
- **Severity of the omission**: major.

## Sunk-cost flags

- `"Carrier-soundness probe — verdict CONFIRM (per iter-198 review): the Functor.IsRepresentable-style abstraction is sound"` — Why this is sunk-cost: the CONFIRM verdict was rendered on the *instrumentation* question (does sorryAx propagate as expected) and is being silently re-purposed to license the *strategic* claim that A.2.c can be deferred under the abstraction. The probe never tested whether the protected decls can discharge under typeclass abstraction — only whether the abstraction layer leaks sorryAx predictably. Recommendation: separate the instrumentation verdict from the strategic deferral license; the strategic question (does A.2.c need discharge to satisfy the protected `#print axioms` contract?) has a clear YES answer that the probe does not change.
- `"Carrier-soundness probe permits typeclass-level abstraction in the meantime"` — Why this is sunk-cost: justifies continued downstream A.3.* work in terms of the probe-investment already realized, rather than confronting that A.3.* work under sorry-instances cannot discharge the protected decls. Recommendation: reframe — downstream work under typeclass abstraction is *off-cone scaffolding*, not progress against the protected decls.

## Prerequisite verification

- `Algebra.IsEtale + ConnectedSpace + GrpObj.IsTerminal` (genus-0 step 7) — partially verifiable: `Algebra.IsEtale` and `ConnectedSpace` exist in Mathlib; "Connected étale group scheme over a field of dim 0 = Spec k" as a single packaged lemma is not standardly named in Mathlib (the strategy itself flags it as ~50–100 LOC of new material at line 250). VERIFIED (as a buildable composite) but NOT a one-line Mathlib citation.
- `PicScheme.degComp` — not in Mathlib; project-side material. Project plans to introduce it via A.3.ii + Hilbert polynomial (~300–600 LOC). VERIFIED (as a plan), not a phantom assumption.
- Kleiman §5 Prop 5.19 / Milne III.6.3 (T_e Pic⁰ ≅ H¹) — real references; the formal Lean lemma is project-side material (A.3.iii).

No phantom Mathlib infrastructure detected at the named-lemma level; the issues are structural (deferral / cone closure), not citation.

## Must-fix-this-iter

- Route "Pic representability — substrate dependency on Route C": **infrastructure-deferral REJECT** — A.2.c required by goal, no project-side discharge path. STRATEGY.md must commit to ONE of: (a) a concrete A.2.c-discharging path that does not require RR (e.g., the Direct `J := Spec k` Alternative above), (b) a USER-escalation explicitly asking for Route C re-engagement with a project-budgeted RR sub-strategy, or (c) acknowledging the protected `#print axioms` contract is unreachable without USER action and re-scoping the Goal. The current "USER re-engages OR carrier abstraction with RR hypothesis" non-answer is not a plan.
- Route "Genus-0 arm — Route A zero-dim group-scheme argument": **CHALLENGE** — strike or retract the sentence at lines 175–177 ("This chain is **independent of RR / Route C**…") because A.3.iii / A.3.iv / A.3.vi transitively need A.2.c per the dependency graph at lines 92–98. Either supply an A.2.c-free construction of `Pic⁰` for the genus-0 branch, or honestly mark this branch as RR-gated.
- Route "Route C — Riemann–Roch chain — PAUSED": **CHALLENGE** — the cone-scoping "resolution" at lines 128–145 is structurally invalid because the genus-0 escape it relies on has the same A.2.c→RR dependency. Either commit to the cone audit this iter (the strategy promised "iter-199+ post-cone-audit"; do it now) or remove the resolution-committed framing.
- Infrastructure-deferral "Riemann–Roch / Route C": **CHALLENGE** — strategy must either name a surgical re-engagement (e.g., Mumford-rigidity only, ~300–500 LOC) or document that the protected decls are unreachable without USER intervention.
- Carrier-soundness probe abort criterion: **CHALLENGE** — the probe verdict CONFIRM is over-extended. The iter-198 PicSharp.functorial sorryAx leak DOES technically satisfy the literal abort criterion ("any consumer shows sorryAx"). The strategy's "expected instrumentation signal" interpretation is defensible only if STRATEGY.md explicitly rewrites the abort criterion to distinguish "expected propagation through explicit construction-site sorry" from "unexpected propagation through closed downstream consumers", and applies the rewritten criterion verbatim. The current text just asserts CONFIRM without showing the consumer-by-consumer audit.
- Format: **NON-COMPLIANT** — restructure STRATEGY.md in-place this iter to strip every iter-NNN reference (12+ instances enumerated above); move per-iter narrative to `iter/iter-199/plan.md`. Bring file under 250 lines / 12 KB.
- Alternative "Direct J := Spec k construction for genus-0, bypassing Pic⁰": **critical omission** — directly addresses the A.2.c REJECT and is not considered in STRATEGY.md.

## Overall verdict

The strategy defers A.2.c (Pic representability), which is required for the stated goal — the protected decls' dependency cone transits A.2.c via the A.3 ladder (per the dependency graph at lines 92–98 of STRATEGY.md), and the strategy's own admission is that A.2.c is "substrate-blocked on RR" with Route C paused. The two paths forward named in the strategy — "USER re-engages RR" and "A.2.c lands under typeclass abstraction with RR as a carrier hypothesis" — are both non-plans: the first is a request to the USER, the second renames the gap one layer deeper because the carrier hypothesis still needs discharge in the cone and the protected signatures cannot acquire an RR hypothesis (they are frozen). The "Genus-0 arm — independent of Route C" escape is factually wrong: A.3.iii ⊳ A.3.0 + A.3.ii ⊳ A.3.vii ⊳ A.2.c, so the chain has a hidden Route C dependency. **The strategy cannot reach the kernel-triple end-state contract under current Route C pause without either a Mumford-rigidity-style direct-`Spec k` construction for the genus-0 branch (suggested as an Alternative above), a surgical re-engagement of Route C lemmas (also suggested), or an explicit USER escalation.** Additionally, the document has regressed on format compliance — per-iter narrative now appears in 12+ places spanning table caveats and three Open-strategic-question bullets, and the file is over the 250-line / 12-KB budget. Verdict: **CHALLENGE** overall (with one embedded REJECT-level infrastructure-deferral finding on A.2.c). Plan agent must either edit STRATEGY.md to address the A.2.c discharge path and the genus-0 cone claim, or record an explicit rebuttal in `iter/iter-199/plan.md` naming why the dependency graph reading above does not apply.
