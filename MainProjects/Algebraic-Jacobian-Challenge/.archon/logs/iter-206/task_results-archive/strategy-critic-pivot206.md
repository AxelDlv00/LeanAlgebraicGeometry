# Strategy Critic Report

## Slug
pivot206

## Iteration
206

## Routes audited

### Route: A — `J := Pic⁰_{C/k}` (FGA Picard, critical path SubT → RelPic → A.2.c → A.3 → A.4)

- **Goal-alignment**: PARTIAL — Route A produces an Albanese/Jacobian AV unconditionally (Pic⁰ exists with no `C(k)≠∅`; pointing enters only `isAlbaneseFor`), which matches the goal. The gap is that the witness's RR-freeness is *claimed* but contingent (see soundness).
- **Mathematical soundness**: PARTIAL — the representability half is sound and RR-free; the headline "RR dependency narrowed, A.2.c no longer transits RR" overstates what is settled. The *current* witness `Pic⁰ := PicScheme.degComp C 0` is RR-dependent by the strategy's own admission (Open questions, line 89–90: "needs RR (Milne p.88)"). RR-freeness of the witness `J` requires switching to `Pic⁰ := Pic^z`, a decision the strategy explicitly defers. So the Goal section banks a benefit (RR-free) that the Open-questions section says has not been purchased.
- **Sunk-cost reasoning detected**: no — the MonoidalCategory route is cleanly ABANDONED ("over-building"); the A.1.c RE-ENGAGE GATE honestly flags placeholder bodies to replace. Good discipline. (But see Alternative routes for a *latent* sunk-cost risk in the Thm-3.2 cone.)
- **Infrastructure-deferral detected**: yes — two: (1) the `Pic^z` identity-component / clopen-descent infra (~350 LOC, "excised iter-197"), required only if the RR-free witness route is taken; (2) the Stacks 02JK conormal iso (A.4.c.0), stuck 27 iters. See Infrastructure-deferral findings.
- **Phantom prerequisites**: none — `CommRing.Pic`/`instCommGroupPic`, `Module.Invertible`, and `Module.Flat.lTensor_preserves_injective_linearMap` all VERIFIED; `IsLocallyTrivial` is a real project decl.
- **Effort honesty**: mostly reasonable, one soft spot — A.1.c.SubT (150/40≈3.75 vs "~3–5") is internally consistent. A.3.0/ii/vii (~1100–2100 LOC, "absent in Mathlib": scheme tangent space + Hilbert poly + Pic⁰ AV-structure) over 26–45 iters is the likely under-count; building scheme tangent spaces and Hilbert polynomials from scratch routinely balloons. The wide range honestly signals the uncertainty, so this is a flag, not a falsification.
- **Parallelism under-exploited**: no (materially) — the SubT → RelPic → A.2.c chain is genuinely sequential; the single-lane posture is USER-imposed (bottom-up directive, A.3-after-A.2.c gate, RR pause), not a planning failure. Minor note in Alternatives.
- **Verdict**: CHALLENGE

### Route: C — Riemann–Roch (PAUSED, USER directive)

- **Verdict**: SOUND — correctly scoped: files stay imported carrying inline sorries under option (c), and the iter-206 audit's narrowing of RR to three downstream nodes (genus formula, autoduality, `Sym^d` surjectivity) is mathematically credible (Kleiman §4 existence via Quot/Nitsure §5 uses flatness/coherence, not RR; RR enters at cohomology-dimension computations). Leaving it paused is defensible.

### Route: Genus-0 arm

- **Goal-alignment**: PASS — correctly anticipates the hard part of "no `C(k)≠∅`": a genus-0 curve without a rational point is a nontrivial conic, and the strategy routes its Pic⁰ through the general construction + étale sheafification (A.1.c "ét-sheafify on Over S") rather than assuming `C ≅ ℙ¹`. Arm (b) `J := Spec k` via Mumford rigidity (descend from `C_{k̄} ≅ ℙ¹`) is the right shape for the trivial-Jacobian case.
- **Mathematical soundness**: PASS.
- **Verdict**: SOUND (arm (b) is USER-paused, which is acknowledged).

## Format compliance

- **Size**: 124 lines / ~7 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. Representative: `"RR dependency narrowed (iter-206, strategy-auditor validated)"` (line 23); `"**flat-pivot iter-206**"` (table, line 36); `"(flat-pivot, iter-206)"` (line 58); `"the reason it was excised iter-197"` (line 94); `"ABANDONED as over-building (analogies/ts-design206.md)"` (line 69); `"was wrongly thought RR-blocked"` (line 40). iter-NNN and "validated by strategy-auditor" provenance are exactly the iter-by-iter history the skeleton forbids in STRATEGY.md.
- **Accumulation detected**: yes (mild) — A.4.a row reads "substrate DONE" yet still occupies a phase row; inline history-tracking phrases ("was wrongly thought RR-blocked", "the reason it was excised iter-197") are retained rationale that belongs in iter sidecars.
- **Table discipline**: PASS (one minor gap) — columns correct, LOC cells mostly carry both figures; A.4.c.0's LOC cell is `~0/it` only (missing the remaining-LOC figure).
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: Stacks 02JK conormal iso (A.4.c.0, codim-≥2 conclusion)

- **Required by goal**: partially — it is required by the Milne-Thm-3.2 rational-map-extension *route* to the Albanese UP; it is NOT obviously required if the Kleiman `rmk:Alb` Picard-functorial UP route is taken (see Alternatives). The goal needs *an* Albanese UP, not specifically the Thm-3.2 one.
- **Current plan for building it**: none on the project side — STUCK + PAUSED, "27 iters flat", "'one more input' receded 4×". Three disposition options surfaced to USER (02JK Lean path / 02JK-free pivot / axiom-guard the 3 pinned decls).
- **Timeline**: absent (USER-gated).
- **Verdict**: CHALLENGE — a 27-iter-stuck node with a receding "one more input" is the textbook stagnation-by-inaction pattern. The planner must not let it sit: confirm whether the now-surfaced RR-free Albanese route (Kleiman `rmk:Alb`) bypasses the entire codim-≥2 / Thm-3.2 cone, which would let 02JK be *excised* rather than indefinitely paused.

### Deferred: `Pic^z` identity-component / clopen-descent infra (~350 LOC, "excised iter-197")

- **Required by goal**: yes, conditionally — required iff the witness is to be RR-free (`Pic⁰ := Pic^z`). The goal requires `Pic⁰` defined *somehow*; both `degComp` (RR) and `Pic^z` (this infra) reach it, so this is a route-selection deferral, not an abandonment.
- **Current plan for building it**: none yet — "Pick when A.2.c nears; not actionable now."
- **Timeline**: vague (tied to "when A.2.c nears", ~12–16 iters out).
- **Verdict**: CHALLENGE — deferring the *decision* is defensible (genuinely downstream and gated, and the choice may hinge on whether USER lifts the RR pause). What is NOT defensible is simultaneously advertising "A.2.c no longer transits RR / RR-free" in the Goal headline while the chosen-by-default witness (`degComp`) still transits RR and the RR-free alternative requires un-excising 350 LOC. Reconcile the framing (see Must-fix).

## Alternative routes (suggested)

### Alternative: Albanese UP directly from the Picard functor (Kleiman `rmk:Alb`), bypassing the Milne-Thm-3.2 rational-map-extension cone

- **What it looks like**: The strategy itself notes (line 28–30) "the Albanese UP itself has an RR-free route (Kleiman `rmk:Alb`, output `J^∨`)." Kleiman derives the Albanese/Jacobian universal property from the representing property of the relative Picard functor — i.e. the UP falls out of A.2.c's representability + the functor's definition, not from extending the Abel–Jacobi rational map across the curve. If that holds, the entire chain A.4.a (codim-1) + A.4.c.0 (codim-≥2 / 02JK, STUCK) + A.4.c.1/A.4.d (Thm 3.2 assembly) + the AuslanderBuchsbaum / CoheightBridge / CodimOneExtension substrate is a *dead route* for the UP.
- **Why it might be cheaper or sounder**: it deletes the single most-stuck node in the project (02JK, 27 iters flat) and a multi-hundred-LOC rational-map-extension apparatus, replacing them with a property that is "free" once representability lands. It also removes the RR touch-point at the Albanese step.
- **What the current strategy may have rejected**: unclear — the strategy *records* the existence of this route but does not draw the consequence that it may obsolete the Thm-3.2 cone. The project has substantial sunk investment (AuslanderBuchsbaum, CodimOneExtension, CoheightBridge, Thm32RationalMapExtension) in the Milne route; keeping that route alive after discovering a UP route that may bypass it is the project's principal latent sunk-cost risk.
- **Severity of the omission**: major.

## Sunk-cost flags

- (latent, not yet realized) The retention of the full Milne-Thm-3.2 / `CodimOneExtension` / `AuslanderBuchsbaum` / `CoheightBridge` cone after surfacing the Kleiman `rmk:Alb` Picard-functorial UP route — Why this is sunk-cost: substantial substrate has been built for the Thm-3.2 route, and the strategy keeps it on the roadmap (A.4.c.1/A.4.d) without testing whether the cheaper UP route makes it unnecessary. Recommendation: before the next A.4 dispatch, decide on merits whether `rmk:Alb` supplies the UP directly; if yes, excise the cone (and 02JK with it).

## Prerequisite verification

- `CommRing.Pic` / `instCommGroupPic` (`Mathlib.RingTheory.PicardGroup`): VERIFIED — confirms the `CommGroup`-from-iso-classes analogue the SubT pivot mirrors.
- `Module.Invertible` (used by `CommRing.Pic.mk`): VERIFIED.
- `Module.Flat.lTensor_preserves_injective_linearMap` (`Mathlib.RingTheory.Flat.Basic`): VERIFIED — the flat-exactness ingredient behind `tensorObj_restrict_iso`.
- `IsLocallyTrivial` (Prop carrier): VERIFIED as a project-internal decl (TensorObjSubstrate / RelPicFunctor / LineBundlePullback).

## Must-fix-this-iter

- Route A: CHALLENGE — reconcile the RR-free framing. Either (a) commit to `Pic⁰ := Pic^z` and put the ~350 LOC identity-component infra on the roadmap with an iter estimate, legitimately earning "RR-free"; or (b) state in the Goal/headline that the *current* witness (`degComp`) is RR-dependent and RR-freeness is contingent on the deferred `Pic^z` choice. Do not bank the benefit while deferring the decision that produces it.
- Infrastructure-deferral (02JK / A.4.c.0): CHALLENGE — a 27-iter-stuck, USER-gated node. The planner must record whether the Kleiman `rmk:Alb` UP route bypasses the codim-≥2 cone (which would excise 02JK), or produce a concrete disposition, rather than leaving it to recede a fifth time.
- Alternative (Kleiman `rmk:Alb` UP bypass): major omission — assess whether it obsoletes the Milne-Thm-3.2 cone before any further A.4 substrate spend.
- Format: DRIFTED — strip the pervasive per-iter narrative (iter-206 ×3, iter-197, "strategy-auditor validated", `analogies/ts-design206.md` provenance) and restate as timeless facts; move retained rationale ("excised iter-197", "wrongly thought RR-blocked") to an iter sidecar. Restructure in place this iter.

## Overall verdict

The iter-206 flat/line-bundle pivot (Focus 1) is genuinely sound and is NOT infrastructure-deferral: the hardest prerequisite changed from the verified-absent `MonoidalClosed (PresheafOfModules R₀)` to the verified-present `Module.Flat.lTensor_preserves_injective_linearMap` + the `CommRing.Pic`-style iso-class group — the hard wall was bypassed by real Mathlib, not renamed. The lighter route plausibly delivers the `AddCommGroup` the RelPic functor needs (group of iso-classes under tensor, exactly Mathlib's `Pic` shape), with functoriality/sheafification correctly kept as the separate A.1.c obligation. On Focus 2, the RR-free-representability audit is credible and deferring the `Pic⁰ := degComp` vs `Pic^z` *decision* is defensible because it is downstream and gated — BUT the strategy defers `Pic^z`, which is required for the RR-free witness it advertises, so it must stop banking "RR-free" in the headline while the default witness still transits RR. Two live concerns dominate: (1) **the strategy keeps the Milne-Thm-3.2 / 02JK cone alive even though it has surfaced a Kleiman `rmk:Alb` Picard-functorial Albanese-UP route that may obsolete it** — this is the project's main latent sunk-cost and the way to kill the 27-iter-stuck 02JK node; and (2) the per-iter narrative pervading STRATEGY.md must be stripped. Routes audited: 3 (Route A CHALLENGE, Route C SOUND, Genus-0 SOUND); format DRIFTED.
