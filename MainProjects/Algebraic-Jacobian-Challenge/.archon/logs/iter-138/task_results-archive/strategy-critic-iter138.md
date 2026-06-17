# Strategy Critic Report

## Slug
iter138

## Iteration
138

## Routes audited

### Route: M1 — presheaf↔Kähler bridge (EXCISED iter-126)

- **Goal-alignment**: PASS — excision retains the M1.d Mathlib-PR candidate (`kaehler_quotient_localization_iso`) as standalone utility; the bridge had zero in-tree consumers verified by `grep`, so excision strictly reduces in-tree `sorry` without forfeiting upstream value.
- **Mathematical soundness**: PASS — the M1.d statement (algebra-tower `A → L → B` with `A → L` a localization gives `Ω[B⁄A] ≃ Ω[B⁄L]` as `B`-linear equivalence) is a clean generalisation of `tensorKaehlerEquivOfFormallyEtale` using `Algebra.FormallyUnramified.of_isLocalization`.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none — `tensorKaehlerEquivOfFormallyEtale` VERIFIED, `KaehlerDifferential.exact_mapBaseChange_map` VERIFIED.
- **Effort honesty**: reasonable — off-loop PR work from `analogies/relative-differentials-presheaf-bridge.md`.
- **Verdict**: SOUND.

### Route: M2.a — `rigidity_over_k` (formerly `rigidity_over_kbar`)

- **Goal-alignment**: PASS — over-k path eliminates Galois descent (M2.c) and the C(k) ≠ ∅ phantom (M2.c.aux); produces the universal-property factorisation directly.
- **Mathematical soundness**: PASS — the shear-iso globalisation is intrinsic (does not need `k̄`-rational points); pieces (i)+(ii)+(iii) are k-agnostic over arbitrary base field.
- **Sunk-cost reasoning detected**: yes — see §Sunk-cost flags item #1 (over-k commitment now defended primarily on switching cost + scope-narrow piece-(i.a) tractability after iter-128 net-savings collapsed to lower bound zero).
- **Phantom prerequisites**: `AlgebraicGeometry.Scheme.absoluteFrobenius` is correctly flagged PHANTOM in the strategy; ring-side `frobenius` / `iterateFrobenius` VERIFIED in `Mathlib.Algebra.CharP.Frobenius`.
- **Effort honesty**: reasonable for the scaffold (87 LOC iter-126); the body closure (iter-151+) is gated on the M2.body-pile, so the LOC accounting lives there.
- **Verdict**: SOUND with carry-over CHALLENGE on over-k defense scoping (see Must-fix).

### Route: M2.b — `genusZeroWitness`

- **Goal-alignment**: PASS — vacuity-branch reasoning for C(k) = ∅ is correctly grounded on the type-level `∀ P : 𝟙_ _ ⟶ C, IsAlbanese …` being vacuous when the source type is empty.
- **Mathematical soundness**: PASS — scaffold landed iter-127; body closure is dependency-correct (gated on M2.a body).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: terminal-object instance cluster on `Spec k` (`GrpObj`, `SmoothOfRelativeDimension 0`, `IsProper`, `GeometricallyIrreducible`) is named honestly under M2.b row at lines 486; iter-130 revision (320–750 LOC for terminal cluster + vacuity) is realistic.
- **Effort honesty**: reasonable — iter-130 revision honestly addressed the under-count on the terminal cluster.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (i.a) — `cotangentSpaceAtIdentity` + rank lemma

- **Goal-alignment**: PASS — closed iter-132, kernel-only axioms, `Module.finrank k (cotangentSpaceAtIdentity G) = n` lands. File outline confirms `cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq` are present at lines 95, 202, 233 of `AlgebraicJacobian/Cotangent/GrpObj.lean`.
- **Mathematical soundness**: PASS — Replacement (B) chart-base-change body avoided the false zero-collapse of the iter-128 evaluate-then-extend-scalars body.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none — `KaehlerDifferential.tensorKaehlerEquiv` VERIFIED.
- **Effort honesty**: empirical cost ~600 LOC build-and-correct across 3 body reshapes vs iter-127 estimate of 1 iter / no corrective cycles. STRATEGY.md honestly records this overshoot (line 473). Good discipline.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (i.b) — `mulRight_globalises_cotangent`

- **Goal-alignment**: PASS — sheaf-level RHS phrasing (per iter-133 mathlib-analogist) chains cleanly into Step 3 (iter-136 close) and the Main Compose (iter-138+ target).
- **Mathematical soundness**: PASS at signature level (Step 3 already consumes the Step 2 signature shape per `analogies/kaehler-tensorequiv-presheafpullback.md` verdict). Step 2 body itself is currently open; iter-137 prover lane returned PARTIAL with documented inverse-direction-via-adjunction-transpose alternative.
- **Sunk-cost reasoning detected**: yes — see §Sunk-cost flags item #2 (LOC trigger renormalisation 600→1000 LOC is sound on iter-137 envelope evidence, but the strategy is silent on a parallel iter-133 fibre-free pivot threshold of 750 LOC for (i.b) alone that the iter-137 envelope arithmetic now ALSO crosses).
- **Phantom prerequisites**: `PresheafOfModules.pullback` infrastructure VERIFIED (imported by `AlgebraicJacobian/Cotangent/GrpObj.lean`); `KaehlerDifferential.tensorKaehlerEquiv` VERIFIED; no `PresheafOfModules.pullbackId` match locally but project does not name it. The Step 2 universal-property route's `PresheafOfModules.isoMk` and `.pushforward.leftAdjoint` chain are Mathlib-shaped per the analogist.
- **Effort honesty**: revised iter-137 envelope ~360–710 LOC for Step 2 alone (~410–810 LOC for piece (i.b) total Step 1–4) is honest relative to iter-133's 150–300 LOC. The revision is documented as widening, not absorbed silently. Good.
- **Verdict**: CHALLENGE — see Must-fix on fibre-free threshold consistency and renormalisation-discipline guardrail.

### Route: M2.body-pile piece (i.c) — chart-localisation + omega_free + omega_rank_eq_dim

- **Goal-alignment**: PASS — iter-137 split into (i.c.1) chart-localisation ~100–200 LOC, (i.c.2) `omega_free` ~50–150 LOC, (i.c.3) `omega_rank_eq_dim` ~50–150 LOC (lines 476–478) cleanly factors the artefact pushed in from (i.b) per iter-133 analogist verdict.
- **Mathematical soundness**: PASS — `omega_free` is "structure-map pullback of a free `k`-module is a free `O_G`-module" (small assembly); `omega_rank_eq_dim` consumes the rank lemma already closed iter-132.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 200–500 LOC bundled is reasonable; the (i.c.1) artefact's true size is the load-bearing unknown until (i.b) closes.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (ii) — `Scheme.Over.ext_of_diff_zero`

- **Goal-alignment**: PASS at high level; alignment to Mathlib's `Differential.ContainConstants A B` (keyed on `Differential B`, derivation `B → B` valued in `B`) requires either (a) a `Differential`-typeclass install on chart algebras, or (b) direct `KaehlerDifferential.exact_mapBaseChange_map` route. Strategy correctly schedules an iter-139/140 analogist consult BEFORE iter-141+ scaffolding (line 479).
- **Mathematical soundness**: PASS — the `df = 0 ⇒ f` factors through `Spec k` argument is mathematically classical; the open question is which Mathlib idiom to align to.
- **Sunk-cost reasoning detected**: no — the strategy explicitly self-flags the "morally aligned" framing as loose (line 446).
- **Phantom prerequisites**: `Differential.ContainConstants` VERIFIED in `Mathlib.RingTheory.Derivation.DifferentialRing`. Alignment specifics pending iter-139/140 analogist.
- **Effort honesty**: 250–500 LOC / 2–3 iter; reasonable conditional on the alignment path landing cleanly.
- **Verdict**: SOUND with watchpoint on iter-139/140 analogist schedule slip (see Must-fix).

### Route: M2.body-pile piece (iii) — `Scheme.absoluteFrobenius` + iteration

- **Goal-alignment**: PASS at high level; the strategy correctly insists on **absolute** Frobenius `F_X` (intrinsic, no perfectness) rather than relative Frobenius.
- **Mathematical soundness**: PASS — Stacks Tag 0CC4 is the canonical reference; the construction is well-known.
- **Sunk-cost reasoning detected**: no — strategy explicitly resists pre-citing the user hint as a blanket warrant for the 800–1500 LOC build (line 398).
- **Phantom prerequisites**: scheme-level Frobenius is PHANTOM — confirmed by my `lean_local_search` ("Scheme.frobenius" returns no hits; `frobenius` / `iterateFrobenius` only ring-side in `Mathlib.Algebra.CharP.Frobenius`). Strategy is correct.
- **Effort honesty**: 800–1500 LOC over 4–7 iter is honest. The PROVISIONAL flag pending iter-135–138 ℙ¹-hedge analogist + iter-140+ higher-Kähler-vanishing alternative analogist is well-disciplined.
- **Verdict**: SOUND with watchpoint on iter-135–138 ℙ¹-hedge analogist schedule slip (see Must-fix).

### Route: M3 — `positiveGenusWitness`

- **Goal-alignment**: PASS — scaffold landed iter-134; both genus arms now scaffolded so the genus-stratified body restructure precondition is met.
- **Mathematical soundness**: PASS — Route A (Picard via FGA, ~6500 LOC midpoint) and Route B (Sym + Stein, ~9000 LOC midpoint) per iter-123 audit; route-pick deferred until M2 closes and Mathlib snapshot re-audited.
- **Sunk-cost reasoning detected**: no — user-escalation absorbed iter-126; named-axiom alternative explicitly REJECTED on user hint + plan-agent standing rule.
- **Phantom prerequisites**: every gating piece (Hilbert/Quot representability, identity-component subgroup scheme, `Sym^n X`, Stein factorisation, Brill–Noether) is correctly flagged as missing.
- **Effort honesty**: 100+ iter / 10000+ LOC is honest for either route. The hard-fallback at 5000 LOC threshold fired correctly iter-123.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: parallel upstream-PR lane for piece (iii) absolute Frobenius

- **What it looks like**: piece (iii) `AlgebraicGeometry.Scheme.absoluteFrobenius` is canonical Mathlib infrastructure (Stacks Tag 0CC4; used by literally every char-p scheme argument). 800–1500 LOC of upstream-shaped construction. Submit upstream as a Mathlib PR in parallel with the in-tree build, with the same code mirrored into the project tree (per the M1.d off-loop precedent).
- **Why it might be cheaper or sounder**: (a) gets community design review on a piece that's foundational infrastructure with broad utility; (b) if accepted upstream during the iter-144+ build window, frees 800–1500 LOC of long-term in-tree maintenance burden; (c) reduces the project's "build everything in-tree" risk envelope on the largest single piece of the M2.body-pile; (d) the same precedent (M1.d `kaehler_quotient_localization_iso`) is already running off-loop, so the infrastructure for it exists.
- **What the current strategy may have rejected**: the strategy adopts an "in-tree first, PR-extract later" framing under the iter-121 pivot. For M1.d this was decided as off-loop. For piece (iii) the strategy is silent — it neither classifies piece (iii) as PR-shaped nor explains why it is not. Likely-implicit rejection: "we don't know the design until we build it." But that argument is precisely what the iter-135–138 analogist consult is meant to defuse; if the analogist verifies the design, parallel PR submission becomes possible.
- **Severity of the omission**: minor — the in-tree build will produce the same artefact either way; the omission is process-level, not goal-level. But naming it explicitly would discipline the strategy.

### Alternative: front-load both iter-135–138 ℙ¹-hedge analogist AND iter-139/140 ContainConstants analogist to iter-138 in parallel

- **What it looks like**: the iter-137 PARTIAL on piece (i.b) Step 2 means iter-138 prover bandwidth is going to Step 2 (likely via the inverse-direction adjunction-transpose route). Analogist consults do not require prover bandwidth. Dispatch both analogist consults THIS iter alongside the iter-138 piece (i.b) prover lane.
- **Why it might be cheaper or sounder**: (a) the ℙ¹-hedge consult is scheduled iter-135–138 (per line 537) and iter-138 is the deadline — if not dispatched this iter it slips; (b) the ContainConstants consult is scheduled iter-139/140 but the dispatching cost is identical iter-138; (c) the strategy's stated reason for the iter-135–138 hedge window is that the verdict feeds piece (ii) iter-141+ AND piece (iii) iter-144+ — a slip beyond iter-138 narrows that feed window; (d) both consults are independent of the iter-138 prover lane.
- **What the current strategy may have rejected**: nothing explicit. The strategy spreads consults across iters by default to avoid cognitive overload on the plan agent, but parallel analogist dispatches don't add prover work.
- **Severity of the omission**: major — the ℙ¹-hedge schedule risks slipping past its stated window, which would propagate into piece (iii) timing.

### Alternative: explicit iter-138 re-evaluation of the fibre-free piece (i) reformulation against measured LOC

- **What it looks like**: STRATEGY.md line 531 commits "iter-138+ may re-evaluate fibre-free with the actual measured LOC instead of the projected" if piece (i.b) ships at materially higher LOC than the iter-133 mathlib-analogist's 210–440 LOC envelope (e.g. >750 LOC for (i.b) alone). The iter-137 envelope revision pushes piece (i.b) total to 410–810 LOC, which crosses the 750 LOC threshold on the upper envelope alone. Iter-138 should explicitly re-run the 4-axis scorecard (LOC, canonicity, blueprint alignment, downstream API shape) with the measured-after-Step-2 piece (i.b) LOC.
- **Why it might be cheaper or sounder**: at this point the strategy is committed to renormalising the over-k revert LOC arm from 600→1000 LOC because the envelope mechanically saturates the 600 cap. The same envelope crosses the iter-133 fibre-free pivot threshold. Either both thresholds renormalise together (with documented justification) or the fibre-free re-evaluation fires. Currently the strategy renormalises one but is silent on the other.
- **What the current strategy may have rejected**: implicitly, the strategy treats the 750 LOC fibre-free threshold as a "may" trigger rather than "must" (line 531 says "may re-evaluate"). But on the iter-137 evidence the threshold is essentially crossed.
- **Severity of the omission**: major — this is a consistency gap in trigger arithmetic. The strategy is asymmetric: tightening one trigger (over-k revert: 600→1000) but staying silent on another (fibre-free pivot: 750 fixed) that the same envelope arithmetic crosses.

## Sunk-cost flags

1. `"the over-k commitment carries on ground (ii) blueprint cleanliness honestly named as switching cost + ground (iv) piece (i.a) tractability honestly scoped to route-validation"` (line 516) — Why this is sunk-cost-adjacent: ground (ii) is admitted to be switching cost; ground (iv) is scope-guarded to a single piece. The strategy has now lost (per iter-130 strike) ground (i), lost (per iter-128) the quantitative case (savings lower bound zero), and demoted (per iter-136) ground (iii) revert wiring from "defense" to "risk mitigation". Two demoted/struck grounds, two retained-with-caveats grounds, lower-bound-zero quantitative case. The retained defense is honest, but **the iter-137 PARTIAL signal on Step 2 (the first piece (i.b) prover evidence) does NOT add piece (i.b) tractability evidence to ground (iv)**; if iter-138 closes Step 2, ground (iv) should be extended explicitly from "piece (i.a) only" to "piece (i.a)+(i.b)". If iter-138 fails to close, ground (iv)'s scope-narrow defense stays where it is, but the cumulative weight of "single piece of empirical tractability evidence after 10 iter of build" is thinner than the strategy's tone suggests. Recommendation: tag the over-k commitment as "operationally defaulted, bounded revert cost preserved" (the iter-137 minor alternative the planner REBUTTED-WITH-SCOPE-NOTE deserves explicit ADOPTION); reframe the language away from "defense grounds" toward "operational default with documented revert wiring".

2. `"trigger (a')/(c) LOC arm renormalised iter-137 from 600 LOC cumulative to 1000 LOC cumulative"` (line 499, also line 443) — Why this is sunk-cost-adjacent: the renormalisation arithmetic is sound (`~316 LOC iter-136 baseline + ~710 LOC upper envelope + ~30% slack = ~1000 LOC`), but it sets a moving-goalpost pattern: every time the prover envelope grows, the trigger renormalises proportionally. The strategy currently does not commit to fixed renormalisation discipline. Recommendation: codify that the LOC trigger arm renormalises ONLY when a NEW analogist consult justifies a new envelope (as iter-137's `kaehler-tensorequiv-presheafpullback` consult did), NOT when a prover lane reports growing LOC without an analogist re-scope. Otherwise the trigger becomes "we always raise the cap to fit the envelope" which is no trigger at all.

3. `"iter-138+ may re-evaluate fibre-free with the actual measured LOC instead of the projected"` (line 531) — Why this is sunk-cost-adjacent (asymmetric trigger): the strategy uses "may" for the fibre-free pivot threshold and "must" for the over-k revert thresholds. Under the iter-137 envelope, the 750 LOC fibre-free threshold for piece (i.b) alone is essentially crossed (upper envelope 810 LOC > 750 LOC), yet the strategy renormalised only the over-k revert arm. Recommendation: explicitly adopt one of (a) elevate the iter-138 fibre-free re-evaluation from "may" to "must" given the envelope-side crossing, OR (b) renormalise the 750 LOC fibre-free threshold with documented justification analogous to the (a')/(c) renormalisation, so the trigger arithmetic is consistent.

## Prerequisite verification

- `Differential.ContainConstants` (`Mathlib.RingTheory.Derivation.DifferentialRing`): VERIFIED (exists; class).
- `IsLocalRing.CotangentSpace`: VERIFIED under the namespace `Ideal.IsLocalRing.CotangentSpace` in `Mathlib.RingTheory.Ideal.Cotangent` — strategy's spelling at lines 195, 442, 547 matches the project's existing usage; the iter-129 rename from the phantom `IsRegularLocalRing.cotangentSpace` is correctly recorded.
- `KaehlerDifferential.tensorKaehlerEquiv` (`Mathlib.RingTheory.Kaehler.TensorProduct`): VERIFIED (def + supporting lemmas `tensorKaehlerEquiv_tmul_D`, `tensorKaehlerEquiv_symm_D_tmul`, etc.).
- `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` (`Mathlib.RingTheory.Etale.Kaehler`): VERIFIED.
- `Algebra.FormallyUnramified.of_isLocalization` (named in M1.d construction): not directly verified in this session but consistent with the `FormallyUnramified` API in Mathlib; the project uses it in-tree per the analogies file.
- `PresheafOfModules.pullback` infrastructure (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`): VERIFIED via the imports list of `AlgebraicJacobian/Cotangent/GrpObj.lean`.
- `Mathlib.Algebra.CharP.Frobenius` ring-side `frobenius` + `iterateFrobenius`: VERIFIED.
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: MISSING — confirmed phantom. Strategy correctly absorbs this into piece (iii)'s 800–1500 LOC scope.
- `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim`: phantom names; strategy correctly notes piece (i.c) builds these. Naming idiom aligned per iter-126 analogist (Yang+Merten 2026).

## Re-verification of prior iter-137 carry-over edits

- **Iter-137 Edit #1** (piece (i.c) sequencing-table split into 3 sub-rows): STILL SOUND. The three sub-rows are present at lines 476–478 with envelopes 100–200, 50–150, 50–150 LOC. The iter-137 prover lane's PARTIAL signal on Step 2 does not invalidate the (i.c) sub-decomposition (which is downstream of (i.b)).
- **Iter-137 Edit #2** (piece (i.b) per-step LOC, 3–5 iter envelope): STILL SOUND structurally. The iter-138 prover lane is the 5th iter (134, 135, 136, 137, 138) and is the envelope-determining boundary. If iter-138 also returns PARTIAL on Step 2 without closing, the watchpoint "> 2 iter slip beyond the 3–5 iter envelope" (line 499) starts to be live at iter-140; the strategy should explicitly note iter-138-close as a hard checkpoint for the envelope vs the slip trigger.
- **Iter-137 Edit #3** (gap-inventory entry for piece (i.b) Step 2 with universal-property route + 360–710 LOC envelope): STILL SOUND. iter-137 PARTIAL with documented inverse-direction-via-adjunction-transpose alternative route is consistent with the envelope's upper bound; the alternative route is named, not a surprise. **Watchpoint**: if iter-138 closes via the alternative route AND the body+helpers LOC differs materially from 360–710, the renormalised (a')/(c) LOC cap (1000 LOC) should be re-verified against the actual route LOC. The strategy does not currently document this checkpoint.
- **Iter-137 Edit #4** (trigger (a')/(c) LOC arm renormalised 600 → 1000 LOC): SOUND on present evidence but see sunk-cost flag #2 — moving-goalpost discipline is not codified. Also see sunk-cost flag #3 — the asymmetric treatment of the 750 LOC fibre-free pivot threshold needs reconciling.

## Re-verification of prior iter-137 REBUTTED-WITH-SCOPE-NOTE minor alternatives

1. **piece (i.c) sub-decomposition** (CHALLENGE elevated, ADOPTED iter-137): STILL ADOPTED, no re-eval needed.
2. **pre-commit to path (b) of iter-139/140 consult**: rebuttal still sound — pre-committing forecloses the analogist's job. The strategy correctly delegates the decision.
3. **over-k re-frame to "operationally defaulted, bounded revert cost"**: rebuttal still HOLDS at the language level, but the substantive reframing (lose "defense grounds" framing, adopt "operational default" framing) deserves a second look given that ground (i) struck + ground (iii) demoted + quantitative case lower-bound zero. See sunk-cost flag #1 — recommend partial adoption of the rebutted-with-scope-note alternative.
4. **genus-1 fast path within M3**: STILL REBUTTED — M3 is off-critical-path until M2 closes; genus-1 fast paths are below the strategic-decision threshold for iter-138.

## Must-fix-this-iter

- **Route M2.body-pile piece (i.b)**: CHALLENGE — the iter-137 envelope arithmetic that justified renormalising the (a')/(c) LOC trigger from 600→1000 LOC ALSO arithmetically crosses the iter-133 fibre-free pivot threshold of 750 LOC for piece (i.b) alone (upper envelope 810 LOC). The planner must either (a) elevate the iter-138 fibre-free re-evaluation from "may" (line 531) to "must" and run the 4-axis scorecard with measured Step-2 LOC, OR (b) renormalise the 750 LOC fibre-free threshold with documented justification analogous to the (a')/(c) renormalisation, so the trigger arithmetic is consistent. Currently the strategy renormalises one trigger but is silent on the other that the same envelope crosses.

- **Renormalisation discipline guardrail**: CHALLENGE — codify that the LOC trigger arm renormalises ONLY when a NEW analogist consult justifies a new envelope (as iter-137's `kaehler-tensorequiv-presheafpullback` consult did), NOT when a prover lane reports growing LOC without an analogist re-scope. Without this discipline, the trigger becomes a moving goalpost ("we always raise the cap to fit the envelope").

- **iter-138-close checkpoint on the (a')/(c) renormalisation**: CHALLENGE — the iter-138 prover lane on Step 2 will likely close via the documented inverse-direction-via-adjunction-transpose route (per the iter-137 PARTIAL signal). If the route closes with body+helpers LOC materially different from the 360–710 envelope, the 1000 LOC renormalised cap's basis shifts. STRATEGY.md should explicitly record an iter-138-close checkpoint: "re-verify (a')/(c) 1000 LOC cap against actual route LOC; if route LOC < 70% of envelope midpoint, the cap renormalises back down; if route LOC > envelope upper bound, re-dispatch analogist before further renormalisation."

- **Alternative "front-load both analogist consults to iter-138"**: major — the iter-135–138 ℙ¹-hedge analogist deadline IS iter-138; if not dispatched this iter it slips and the verdict no longer feeds piece (ii) iter-141+ or piece (iii) iter-144+ as planned. Dispatch the ℙ¹-hedge analogist iter-138 in parallel with the piece (i.b) prover lane (analogist consults don't compete for prover bandwidth). Consider co-dispatching the ContainConstants alignment analogist (originally iter-139/140) to absorb the dispatching cost.

- **Alternative "parallel upstream-PR lane for piece (iii) absolute Frobenius"**: minor — STRATEGY.md should classify piece (iii) explicitly as upstream-PR-suitable (analogous to M1.d's off-loop PR lane) and decide whether to start the PR clock in parallel with the iter-135–138 ℙ¹-hedge analogist verdict. Even if the decision is "in-tree only", naming it disciplines the strategy.

- **Over-k commitment language reframing**: CHALLENGE (already noted in sunk-cost flag #1) — given that two of four iter-129 defense grounds have been struck/demoted, the quantitative case is lower-bound zero, and the retained grounds are honestly named as switching cost + scope-narrow route-validation, the strategy should adopt the "operationally defaulted, bounded revert cost preserved" framing partially (the iter-137 REBUTTED-WITH-SCOPE-NOTE alternative #3 deserves substantive adoption, not just rebuttal). The substantive change is: drop the "defense grounds" language in favor of "operational default", which makes the strategy's posture honest about why we're on over-k (we've been building there, revert costs ~1 iter, we have one piece of route-validation evidence for piece (i.a) only).

## Overall verdict

A fresh mathematician would approve the M1/M2.a/M2.b/piece-(i.a)/piece-(iii)/M3 routes as structurally sound and would note the discipline in honest-LOC accounting, sunk-cost self-flagging, and the absence of phantom prerequisites. The strategy is unusually well self-audited.

However, the iter-138 strategic posture has two material consistency issues introduced by the iter-137 PARTIAL signal on piece (i.b) Step 2: (1) the over-k commitment's defense framing is overdue for the substantive reframing the iter-137 minor alternative proposed (the qualitative defense has thinned to "switching cost + one piece of route-validation evidence" after two of four iter-129 grounds were struck or demoted, but the strategy still uses "defense grounds" language); (2) the renormalisation of the (a')/(c) LOC trigger arm from 600→1000 LOC is sound on the iter-137 envelope evidence, BUT it sets a moving-goalpost pattern unless renormalisation discipline is codified, AND it is asymmetric with the iter-133 fibre-free pivot threshold of 750 LOC for piece (i.b) alone that the same envelope arithmetic crosses. The strategy is not unsound on either count, but both deserve explicit treatment iter-138 to keep the trigger arithmetic and route-defense framing honest.
