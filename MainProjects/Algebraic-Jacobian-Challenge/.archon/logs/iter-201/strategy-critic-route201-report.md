# Strategy Critic Report

## Slug

route201

## Iteration

201

## Routes audited

### Route: Pic representability (A.2.c) under Route C pause — option (c) honest framing

- **Goal-alignment**: PARTIAL — the `## Goal` section openly states the kernel-triple contract is "provisional" and "USER-action-conditional"; the strategy is honest that the unconditional theorem cannot be delivered without one of options (a)/(b)/(c). Option (c) is a goal weakening (carrying an explicit RR-substrate hypothesis on the protected decls) — the strategy admits this and asks the USER to confirm. From a goal-formalization standpoint, the project is *currently engaged in a holding pattern*; the actual challenge.lean.ref signatures are not on track to be discharged in their stated form without USER action.
- **Mathematical soundness**: PASS — the claim that A.2.c (FGA Pic_{C/k} representability) transits Riemann–Roch (via Quot or Sym^d / Kleiman §4 + Nitsure §5 / Milne III.4) is correct. The cone-blocking analysis appears sound: every path to the protected decls transits A.2.c, and A.2.c needs RR. No phantom math.
- **Sunk-cost reasoning detected**: no — the strategy does not justify continuing in terms of "we've invested in Route C and must finish"; it explicitly notes Route C is PAUSED and frames substrate work as RR-independent productive labour (A.4.a/b/c.0 + A.1.c.SubT).
- **Infrastructure-deferral detected**: yes — A.2.c (FGA Pic_{C/k} representability, ~600-800 LOC when re-engaged) is required by the goal and is explicitly deferred with NO project-side timeline. The strategy correctly escalates to USER. See infrastructure-deferral block below.
- **Phantom prerequisites**: none I could identify by inspection (the Mathlib names referenced — `IsRegular`, `IsWeaklyRegular`, `HasProjectiveDimensionLT`, `Scheme.Modules`, `Ring.ordFrac` — are plausible Mathlib infra or in-project constructions; LSP spot-check not run).
- **Effort honesty**: reasonable — internally consistent: A.4.a's `~4-6 · ~60/it` against `~150-250 LOC` matches arithmetically (250/60 ≈ 4.2); A.4.b's `~4-8 · ~40/it` against `~150-350 LOC` matches; A.4.c.0's `~3-6 · ~55/it` against `~200-350 LOC` matches. The 14-iter / 33-iter / 19-iter elapsed disclosures on A.4.a/b/c.0 against original 3-6 / 3-6 / 5-9 budgets are *honestly admitted*, which is the right behaviour, not a sunk-cost smell.
- **Parallelism under-exploited**: no — the `Bottom-up execution priority` subsection explicitly mandates parallel dispatch to ungated roots (A.4.a / A.4.b / A.4.c.0 / A.1.c.SubT are all priority-1 / priority-2.5 substrate roots dispatched concurrently). Dependency cone is clearly laid out.
- **Verdict**: CHALLENGE
  - The strategy is honest about A.2.c's USER-conditional status, but the planner must close the iter-200 REJECT loop explicitly: the strategy currently *describes* option (c) as "committed" while simultaneously listing options (a) and (b) as alternatives the USER may pick. This is ambiguous — is option (c) the operative end-state, or is the project still waiting for the USER to pick among (a)/(b)/(c)? Pick one. If (c) is the operative end-state, `## Goal` should state the explicit RR-substrate hypothesis the protected decls will carry; if the project is still waiting for USER selection, the document should not say "option (c) commit".

### Route: Genus-0 arm — Candidate (a) AV-wrap

- **Goal-alignment**: FAIL — the strategy explicitly notes Candidate (a) is "NOT Route-C-independent: transits A.3.0 + A.3.ii ⊳ A.3.vii ⊳ A.2.c". So Candidate (a) is *no* mitigation of the cone block — it shares the same hardest prerequisite as the genus-positive path.
- **Mathematical soundness**: PASS — the AV-wrap of `Pic⁰` via Hilbert-poly decomposition + tangent iso is the standard construction.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes (inherited from A.2.c — same construction).
- **Phantom prerequisites**: scheme-level Hilbert poly (`thm:Pphifin` decomposition) is noted in the A.3.ii row as "absent in Mathlib (~250–500 LOC substrate-build)". This is a real gap but properly flagged.
- **Effort honesty**: 0/it across A.3.0/ii/iii/iv/v/vi/vii is expected — these phases are pipeline-gated downstream of A.2.c which is USER-blocked. Not stagnant by inaction; correctly serialised.
- **Parallelism under-exploited**: no — these are genuinely sequentially dependent on A.2.c.
- **Verdict**: SOUND as a *route description*; provides no goal closure under the Route C pause and is therefore strategically inactive until USER acts.

### Route: Genus-0 arm — Candidate (b) Mumford rigidity (`J := Spec k`)

- **Goal-alignment**: PASS — would close the genus-0 branch of the `by_cases h : genus C = 0` split cleanly, *independently* of Route C; mathematically the cheapest path to the genus-0 case.
- **Mathematical soundness**: PASS — `C_k̄ ≅ ℙ¹_k̄`, `Mor(ℙ¹_k̄, A) = const` via Milne Prop 3.10 / Mumford §4 Rigidity, descent via Brauer-Severi twist. Standard.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the AB-rigidity / RigidityKbar substrate is partially built but USER-paused. The strategy correctly notes this in `## Open strategic questions` and the genus-0 arm subsection.
- **Phantom prerequisites**: AbelianVarietyRigidity, RigidityKbar (in-project; USER-paused).
- **Effort honesty**: ~300-500 LOC project-side estimate matches typical descent-substrate scope. Plausible.
- **Parallelism under-exploited**: n/a — paused.
- **Verdict**: CHALLENGE
  - This is the *cheapest* USER-unblockable closure of the genus-0 arm. The strategy honors the USER pause-list verbatim (correct), but the `## Open strategic questions` section should *more sharply* present this as the recommended USER amendment: option (a) of the goal section. The strategy's iter-200 rebuttal to the prior critic was defensible, but the goal section should rank options (a)/(b)/(c) by recommended preference instead of listing them flatly, so the USER has clear guidance on which to pick. (a) is dramatically cheaper than (b) under the dependency graph; (c) is a goal weakening. The strategy should *recommend* (a).

### Route: A.4.a / A.4.b / A.4.c.0 — RR-independent substrate roots

- **Verdict**: SOUND
  - These three lanes are genuinely independent of the RR/Route C block. A.4.a (codim-1 + Weil-divisor substrate excluding the RR.1-specific L538/L1108 sections), A.4.b (Auslander–Buchsbaum), and A.4.c.0 (codim-≥2 conclusion via Stacks 00OE) are the correct off-cone work for the loop to run during the USER pause. Parallel dispatch is correctly mandated. Honest budget disclosures on over-elapsed iter counts.

### Route: A.1.c.SubT — `Scheme.Modules.tensorObj` upstream-style substrate

- **Verdict**: SOUND
  - Newly broken out as a separate phase, with a blueprint chapter (`Picard_TensorObjSubstrate.tex`) and a scheduled scaffold dispatch. Cleanly identifies that the `addCommGroup` body of `PicSharp` is the only honest residual sorry under the `⟨sorry⟩` instance discipline, and gates A.1.c body fill on its closure. Concrete plan with concrete LOC range (~200-400) and concrete next-iter dispatch is the *opposite* of deferral.

## Format compliance

- **Size**: 192 lines / 12,994 bytes — within line budget (≤250), **slightly over byte budget** (~13 KB vs ~12 KB target). Minor.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: **yes — severe.** 18 occurrences of `iter-NNN` references throughout the document. Representative phrases verbatim:
  - `"~4-6 (revised iter-201)"`, `"~4-8 (revised iter-201 — UNKNOWN-WAS-3-6)"`, `"~3-6 (revised iter-201 — was ~5-9)"` in the Phases table.
  - `"14 iters elapsed against original 3-6 estimate per iter-201 progress-critic"`, `"33 iters elapsed against original 3-6 estimate per iter-201 progress-critic (5.5× over budget)"`, `"19 iters elapsed (marginal over original 5-9); 3 sub-gaps discharged in 3 consecutive iters (Stage 6 (i)/(ii.A)/(ii.B)-partial); iter-201 dispatches witness + L1061 closure"` in the Risks cells.
  - `"placeholder bodies iter-198"`, `"blueprint chapter created iter-200; iter-202+ file-skeleton scaffold + prover dispatch"`, `"probe verdict iter-199: CONFIRM"`.
  - `"iter-200 strategy-critic suggestion"`, `"iter-200 blueprint-writer created"`, `"iter-200 Sub-build 1 ... MET; iter-201 Sub-build 2 ...; iter-202+ Sub-build 3"`, `"gap (3) snake-lemma OBVIATED iter-200; ... analogist ab-stacks00mf dispatched iter-201"` in `## Open strategic questions`.
  - `"WeilDivisor (+positivePart +open-immersion descent iter-200)"`, `"AuslanderBuchsbaum (HasProjectiveDimensionLT pivot iter-200)"`, `"TensorObjSubstrate (chapter iter-200; Lean scaffold iter-202+)"` in `## Mathlib gaps & new material`.
- **Accumulation detected**: yes (minor) — `"A.3.i identity-component EXCISED from the critical path"` references a route that is no longer planned and is now historical. The `rationale in analogies/pic0-ker-deg-pivot.md` is the appropriate place; the inline mention can go.
- **Table discipline**: PASS — table has the canonical column set, with both remaining-LOC and per-iter velocity in the LOC cell. However, many cells carry per-iter narrative that should be moved out.
- **Format verdict**: **NON-COMPLIANT.**

Per the strategy-critic spec, format violations of this severity must be resolved this iter via an in-place restructure (using iter sidecars to hold history that currently lives inline). The substantive strategic content is largely sound — the issue is that the document has become an iter changelog, not a forward-looking strategy. A fresh mathematician reading it cannot immediately tell which lines are "the strategy" and which are "what happened recently".

## Infrastructure-deferral findings

### Deferred: A.2.c — FGA Pic_{C/k} representability (Route C / Riemann–Roch chain)

- **Required by goal**: yes — every path to the nine protected declarations transits A.2.c, which itself transits Riemann–Roch (via Quot / Nitsure §5 or Sym^d / Milne III.4). The strategy's own `Routes` and `Open strategic questions` sections concede this.
- **Current plan for building it**: none project-side — explicitly USER-action-conditional. Three options offered to the USER: (a) carve out AB-rigidity/RigidityKbar for the Mumford genus-0 discharge, (b) full re-engage Route C with a budget, (c) re-scope contract to carry an explicit RR hypothesis.
- **Timeline**: absent — depends entirely on USER selection.
- **Verdict**: CHALLENGE — the strategy is honest about the deferral and has correctly escalated to USER via the goal-section options. The CHALLENGE is not "this is hidden avoidance" but "the project cannot deliver the stated unconditional goal until USER acts, and the substrate work being done in the meantime does not, by itself, close the cone." The planner must either:
  1. **Sharpen the recommendation** to USER: present options (a)/(b)/(c) with explicit ranking and an estimated calendar-time impact for each, so the USER has actionable guidance instead of a flat menu. (a) is by far the cheapest and most surgical; (c) is a goal weakening.
  2. **Document the loop's holding-pattern budget**: state explicitly how many iters of off-cone substrate work the project will run before re-escalating to USER if no action arrives. A holding pattern with no termination condition is itself a deferral.

### Deferred: A.1.c.SubT — `Scheme.Modules.tensorObj` upstream-style substrate

- **Required by goal**: yes — gates A.1.c (RelPic functor), which gates A.2.c (FGA Pic).
- **Current plan for building it**: concrete — blueprint chapter exists; scaffold dispatch scheduled at iter-202; body fill at iter-203+. LOC range ~200-400 estimated.
- **Timeline**: concrete (next 2-3 iters).
- **Verdict**: not a deferral. This is a properly-decomposed phase with a concrete next-step dispatch. Listed here for completeness; no CHALLENGE.

## Alternative routes (suggested)

### Alternative: direct `J := Spec k` for genus-0 case without invoking AB-rigidity

- **What it looks like**: In the genus-0 branch of `by_cases h : genus C = 0`, define `J := Spec k` and the Albanese map `C → Spec k` as the unique morphism. To show `isAlbaneseFor`, observe that for any AV `A` and any morphism `C → A`, the composite is constant (because `C_k̄ ≅ ℙ¹_k̄` and `Mor(ℙ¹_k̄, A_k̄)` is constant by Milne Prop 3.10 / Mumford §4 — pure rigidity, no Serre duality). Descent from `k̄` to `k` via Galois invariance of constant maps. The Brauer-Severi twist is irrelevant when the *target* of the Albanese is `Spec k` because constant maps to `Spec k` descend trivially.
- **Why it might be cheaper or sounder**: This *appears to* avoid the `RigidityKbar` substrate (which is in the USER pause list) — the only ingredient needed is "constant morphism from `ℙ¹` to an AV", which is Milne Prop 3.10 with no k̄→k descent for AV-structure (since the target is `Spec k`, descent is trivial). If this is correct, the genus-0 branch could close *entirely* via Milne 3.10 + the (already in-project?) base-change to `k̄` for the source curve, without touching AB-rigidity or RigidityKbar.
- **What the current strategy may have rejected**: unclear — the strategy lists Candidate (b) as requiring `AbelianVarietyRigidity` + `RigidityKbar`, but the analysis above suggests RigidityKbar (descent of the rigidity *target*) may not be needed when the Albanese target is `Spec k`. The strategy may have conflated "descend rigidity of `Mor(C, A)`" (needed) with "descend the abelian variety structure" (not needed). Worth a fresh look.
- **Severity of the omission**: major — if this works, it dissolves the USER-amendment dependency for the genus-0 branch entirely.

### Alternative: IsEtale functor-of-points for `Pic⁰` directly (carry-over from prior critic)

- **What it looks like**: bypass the full Quot / Sym^d representability chain and represent `Pic⁰` as an étale functor-of-points using a deformation-theoretic criterion (formally smooth + formally étale + finite-type ⟹ representable by an étale scheme, then take the connected component of the identity).
- **Why it might be cheaper or sounder**: avoids the heavy RR-dependent Sym^d / Quot machinery.
- **What the current strategy may have rejected**: requires Mathlib infrastructure for representability-by-étale-criterion that may not exist for arbitrary smooth proper curves over a field.
- **Severity of the omission**: minor — already noted in `## Open strategic questions`; flagged here only to confirm it remains a live alternative worth a Mathlib audit.

## Sunk-cost flags

No sunk-cost reasoning detected. The strategy's over-budget disclosures (A.4.a 14 iters / A.4.b 33 iters / A.4.c.0 19 iters elapsed against original estimates) are *honestly admitted* with explicit pivot/escalation responses, which is the correct pattern.

## Prerequisite verification

Did not run LSP spot-checks this iter. Plausible but unverified Mathlib references:

- `IsRegular` / `IsWeaklyRegular` (Mathlib regular-sequence API).
- `HasProjectiveDimensionLT` (Mathlib homological-algebra).
- `Scheme.Modules` monoidal structure (likely partial in Mathlib).
- `Ring.ordFrac` (valuation API, plausible).
- `SubmersivePresentation` (Mathlib smooth-presentation API).

Recommend the planner spot-check via `lean_local_search` before committing to any iter-202 dispatch that names these.

## Must-fix-this-iter

- **Format: NON-COMPLIANT** — strip all 18 `iter-NNN` references from STRATEGY.md; move per-iter narrative to `iter/iter-NNN/plan.md`. The "Risks" cells on A.4.a/b/c.0 should carry a stable risk description, not an iter-elapsed log. The `## Open strategic questions` items should describe the *current* question, not the iter history of how it evolved. The `## Mathlib gaps & new material` section's parenthetical iter timestamps must go. This is the highest-priority correction.
- **Route A.2.c (option-(c) framing): CHALLENGE** — disambiguate `## Goal` so the document says one of: (i) "option (c) is the operative end-state, and the protected decls carry this hypothesis: ⟨explicit statement⟩"; or (ii) "the project is in a holding pattern pending USER selection among (a)/(b)/(c)". Right now it says both.
- **Route Candidate (b) genus-0 arm: CHALLENGE** — rank the goal-section options (a)/(b)/(c) by recommended preference instead of listing flatly. (a) Mumford-rigidity carve-out is by far the cheapest closure under the dependency graph; (c) is a goal weakening; (b) is a budget escalation. The strategy should *recommend* (a) to the USER.
- **Infrastructure-deferral A.2.c: CHALLENGE** — add an explicit holding-pattern termination condition. State the iter count after which the project will re-escalate to USER if no action arrives, or state that the loop will run indefinite off-cone substrate until USER acts. A deferral with no termination is itself a strategic gap.
- **Alternative: direct `J := Spec k` for genus-0 without RigidityKbar** — major potential omission. The planner should audit whether the genus-0 Candidate (b) actually requires `RigidityKbar`, or whether `Mor(ℙ¹, A) = const` from Milne 3.10 alone suffices when the Albanese target is `Spec k`. If yes, the entire USER-amendment dependency for the genus-0 branch dissolves and the strategy should pivot the genus-0 arm immediately. This is the most important alternative to audit this iter.

## Overall verdict

The strategy is **substantively sound but format-NON-COMPLIANT**: the analysis of the Route C pause, the substrate-cone block on A.2.c, the parallel substrate work on A.4.a/b/c.0 + A.1.c.SubT, and the USER-escalation framing are all correct, and the over-budget disclosures are honestly admitted rather than hidden. The strategy defers A.2.c (FGA Pic representability), which is required for the stated goal, with no project-side timeline — but the deferral is correctly escalated to USER under options (a)/(b)/(c), so it is not silent avoidance.

The iter-200 REJECT on A.2.c reachability is partially answered: the strategy has committed to option (c) honest framing in prose, but the `## Goal` section is still internally ambiguous about whether (c) is the operative end-state or whether the project is awaiting USER selection. **The verdict shifts from REJECT to CHALLENGE** — pick one framing and commit.

The new finding from this fresh-context audit is the **format violation severity**: 18 `iter-NNN` references saturate the table, the open-questions section, and the gaps section, making the strategy read as a changelog rather than a forward-looking document. This must be restructured in-place this iter. Additionally, the genus-0 Candidate (b) should be audited for whether `RigidityKbar` is actually load-bearing or whether Milne Prop 3.10 alone suffices when the Albanese target is `Spec k` — a positive answer would dissolve the USER-amendment dependency for the entire genus-0 branch and is the highest-leverage alternative to investigate.
