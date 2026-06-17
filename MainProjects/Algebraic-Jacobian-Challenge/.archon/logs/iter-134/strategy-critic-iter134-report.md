# Strategy Critic Report

## Slug
iter134

## Iteration
134

## Routes audited

### Route: M1 — Bridge (EXCISED iter-126)

- **Goal-alignment**: PASS — excision is sound; M1.d Mathlib-PR candidate preserved standalone and is independent of M1.b which had no in-tree consumer.
- **Mathematical soundness**: PASS — the off-loop M1.d `kaehler_quotient_localization_iso` rests on real Mathlib lemmas (`KaehlerDifferential.tensorKaehlerEquiv*`, `Algebra.FormallyUnramified.of_isLocalization`, both VERIFIED below).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none flagged.
- **Effort honesty**: reasonable — the excision saved 130–210 LOC of dead-weight filtered-colim work.
- **Verdict**: SOUND.

### Route: M2.a — `rigidity_over_k` (formerly `rigidity_over_kbar`)

- **Goal-alignment**: PASS — closes the rigidity arrow needed by `genusZeroWitness`'s `isAlbaneseFor` field on the `C(k) ≠ ∅` branch; the empty branch is vacuous on the protected signature.
- **Mathematical soundness**: PASS — the body gated on the over-k cotangent-vanishing pile pieces (i)+(ii)+(iii) is the right reduction; the differential-vanishing route is the canonical bypass of `C ≅ ℙ¹_k`.
- **Sunk-cost reasoning detected**: no (the iter-127 over-k commitment is documented as marginal-quantitative + qualitative-positive; honest framing).
- **Phantom prerequisites**: none load-bearing for M2.a itself; phantoms live downstream in the pile.
- **Effort honesty**: reasonable (87 LOC scaffold landed iter-126; body closure deferred to iter-151+ revised).
- **Verdict**: SOUND.

### Route: M2.b — `genusZeroWitness` + terminal-object instance cluster

- **Goal-alignment**: PASS — produces a `JacobianWitness C` with underlying scheme `Spec k`; matches the protected signature.
- **Mathematical soundness**: PASS — the vacuity-branch verification for `C(k) = ∅` is correct (`∀ P : 𝟙_ _ ⟶ C, …` is universally quantified and vacuous when the hom-set is empty); the iter-127 strategy-critic CHALLENGE on M2.b vacuity was absorbed properly.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none for the scaffold itself; the terminal-object instance cluster on `Spec k` (`GrpObj`, `SmoothOfRelativeDimension 0`, `IsProper`, `GeometricallyIrreducible`) needs Mathlib spot-checking before iter-153+ but is plausible (terminal objects are well-trodden Mathlib territory).
- **Effort honesty**: revised iter-130 from "1 iter / 100–200 LOC" to "2–4 iter / 320–750 LOC" to absorb the terminal-object cluster + vacuity-branch encoding — honest correction.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (i.a) — `cotangentSpaceAtIdentity` + `…_finrank_eq` (DONE iter-132)

- **Goal-alignment**: PASS — declarations land in `AlgebraicJacobian/Cotangent/GrpObj.lean` (verified via file outline); `cotangentSpaceAtIdentity_finrank_eq` verifies to `{propext, Classical.choice, Quot.sound}` (kernel-only).
- **Mathematical soundness**: PASS — Replacement (B) `Classical.choose`-chain body extracted from `smooth_locally_free_omega` is the right canonicalisation modulo chart-choice; the rank lemma chains `Module.finrank_baseChange` (VERIFIED) + `Module.finrank_eq_of_rank_eq` (VERIFIED) cleanly.
- **Sunk-cost reasoning detected**: see § CHALLENGE 3 below regarding the "DONE iter-132 / ~300 LOC empirical midpoint" framing in the sequencing table row.
- **Phantom prerequisites**: none. The verified body uses only Mathlib infrastructure that exists.
- **Effort honesty**: PARTIAL — the bottom-line "~300 LOC at midpoint" understates the actual cost; the parenthetical "~600 LOC counting iter-128/iter-130 body-shape iterations" walks it back but the headline reads on-budget. The iter-128→iter-132 path was 5 iter for a piece originally projected at 1 iter.
- **Verdict**: SOUND on the math/Lean state; CHALLENGE on the sequencing-table framing (see § CHALLENGE 3).

### Route: M2.body-pile piece (i.b) — `mulRight_globalises_cotangent` (iter-134+)

- **Goal-alignment**: PASS — globalises the cotangent triviality from the identity to all of `G` via the shear iso; this is the correct mathematical content for the Albanese-rigidity argument.
- **Mathematical soundness**: PASS on the recommended sheaf-level RHS phrasing (verified via `analogies/mulright-globalises-cotangent.md` iter-133, which I cross-read for this audit). The chart-localisation identification (~100–200 LOC pushed into piece (i.c)) is structurally distinct from the iter-130 strategy-critic Q2's stalk-cotangent worry (~300–600 LOC); the analogist explicitly refutes the worry.
- **Sunk-cost reasoning detected**: see § CHALLENGE 1 below regarding the 4-axis fibre-free scorecard (axes 3 + 4).
- **Phantom prerequisites**: load-bearing sheaf-level pullback compatibility (`Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}`) does NOT exist in Mathlib — the project's `relativeDifferentialsPresheaf` is the home-grown ground. This is FLAGGED as a NEEDS_MATHLIB_GAP_FILL (~150–300 LOC) and matches the strategy's `Mathlib gap inventory` § (gap at line 443).
- **Effort honesty**: 210–440 LOC for piece (i.b) per iter-133 mathlib-analogist envelope is testable; the sub-piece breakdown (~30–60 LOC shear iso, ~150–300 LOC base-change-of-Ω, ~30–80 LOC restriction step) is well-decomposed.
- **Verdict**: SOUND on math/scoping. The trigger (a') refinement is testable. See § CHALLENGE 2 on watchpoint LOC trigger.

### Route: M2.body-pile piece (i.c) — `omega_free` + `omega_rank_eq_dim`

- **Goal-alignment**: PASS — closes piece (i) by chaining (i.a) rank lemma + (i.b) shear-iso globalisation + chart-localisation identification.
- **Mathematical soundness**: PASS — the chart-localisation identification pushed in from (i.b) is the right artefact (composes `relativeDifferentialsPresheaf_obj_kaehler` + `cotangentSpaceAtIdentity_eq_extendScalars`).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: same as (i.b) — depends on the home-grown `relativeDifferentialsPresheaf` machinery.
- **Effort honesty**: 200–500 LOC envelope (revised iter-133 from 100–300 LOC to absorb the chart-localisation identification) is honest.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (ii) — `Scheme.Over.ext_of_diff_zero`

- **Goal-alignment**: PASS — produces the "df=0 ⇒ factors through Spec k" reduction needed by M2.a body closure.
- **Mathematical soundness**: PASS — the over-k variant chains the project's `Scheme.Over.ext_of_eqOnOpen` (closed iter-125) with the Mathlib ring-side `Differential.ContainConstants` (VERIFIED).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none new. `Differential.ContainConstants` VERIFIED.
- **Effort honesty**: 250–500 LOC over 2–3 iter is plausible given the iter-125 `Scheme.Over.ext_of_eqOnOpen` precedent.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (iii) — char-p Frobenius iteration (committed Option A)

- **Goal-alignment**: PASS conditional on piece (iii) building scheme-level absolute Frobenius `F_X`.
- **Mathematical soundness**: PASS in principle — absolute Frobenius is intrinsic to `X` (no perfectness needed); Stacks Tag 0CC4 is the canonical reference.
- **Sunk-cost reasoning detected**: the user-hint-citation discipline § (line 398) explicitly defends against using the iter-126 user hint as a blanket warrant for "do the expensive in-tree work" on piece (iii). Honest correction; absorbed from iter-128 strategy-critic.
- **Phantom prerequisites**: `AlgebraicGeometry.Scheme.absoluteFrobenius` does NOT exist in Mathlib `b80f227` (verified: `lean_local_search "Frobenius"` returns only `WittVector.*`, `frobenius` (ring-level in `Mathlib.Algebra.CharP.Lemmas`), and `NumberTheory.FrobeniusNumber`). The strategy is honest about this gap; the 800–1500 LOC PROVISIONAL estimate is appropriately flagged.
- **Effort honesty**: 800–1500 LOC over 4–7 iter is honest; the iter-135–138 higher-Kähler-vanishing analogist consult is a sound hedge that could compress this estimate if a no-Frobenius alternative is viable.
- **Verdict**: SOUND with the PROVISIONAL flag and the iter-135–138 hedge consult correctly sequenced.

### Route: M2 closure — genus-stratified body of `nonempty_jacobianWitness`

- **Goal-alignment**: PASS — the `by_cases h : genus C = 0` decomposition is well-formed (decidable equality of `ℕ`).
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: gated on M3 scaffold + M2.b body close; multi-iter at the tail.
- **Verdict**: SOUND.

### Route: M3 — `positiveGenusWitness` (Route A vs Route B, off-critical-path until M2 closes)

- **Goal-alignment**: PASS conditional on either route closing.
- **Mathematical soundness**: PASS in principle; both routes are well-known math.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: massively many (Hilbert scheme rep'ability, Quot scheme, identity-component subgroup scheme for Route A; symmetric powers + Stein factorisation + RR/Brill–Noether for Route B). The strategy honestly catalogues these and the iter-123 audit triggered user-escalation; the iter-126 user hint resolved escalation as "do the work".
- **Effort honesty**: 6500/9000 LOC midpoints per route, 100+ iter. Honestly catalogued.
- **Verdict**: SOUND. The scaffold-`positiveGenusWitness` iter-133+ minor-recommendation is correctly tracked and not yet executed; see § Alternative below regarding scaffold delay.

## Alternative routes (suggested)

### Alternative: Scaffold `positiveGenusWitness` IMMEDIATELY (iter-134)

- **What it looks like**: introduce a `positiveGenusWitness C (hg : 0 < genus C)` stub with single `sorry` body in `Jacobian.lean`, parallel to the iter-127 `genusZeroWitness` scaffold. Cost ~20–30 LOC.
- **Why it might be cheaper or sounder**: the strategy (line 213) names this as SCHEDULED iter-133+ but iter-133 didn't land it; iter-134 is the natural slot. It unblocks the genus-stratified body restructure precondition AND removes a strategic loose end. The cost is trivial.
- **What the current strategy may have rejected**: nothing — the strategy explicitly says it's a scheduled minor item. The risk is silent slippage iter-by-iter.
- **Severity of the omission**: minor (but trivial to remediate).

### Alternative: Pivot to fibre-free piece (i) NOW (rather than iter-138+ contingent)

- **What it looks like**: drop the named `cotangentSpaceAtIdentity G` object entirely; prove `Ω_{G/k}` globally free of rank `n` directly via the shear iso applied to the differential sheaf.
- **Why it might be cheaper or sounder**: the 4-axis scorecard (line 511-520) shows fibre-free wins on canonicity and is within ~15% on LOC. Axes (3) and (4) — "blueprint alignment" and "downstream API shape" — heavily reflect past investment in (i.a) rather than forward merit (see § CHALLENGE 1 below).
- **What the current strategy may have rejected**: the strategy explicitly considered this and chose to STAY ON (B) at iter-133, weighing blueprint alignment and downstream API shape. The pivot trigger is preserved (iter-138+ re-evaluation if (i.b)/(i.c) actuals exceed envelope).
- **Severity of the omission**: minor — the strategy considered it and rejected, with a testable re-evaluation trigger. Not a fresh CHALLENGE; flagged for transparency.

### Alternative: Front-load the ℙ¹-hedge analogist BEFORE iter-134 piece (i.b) dispatch

- **What it looks like**: dispatch the ℙ¹-specific rigidity hedge analogist (currently scheduled iter-135–138) at iter-134 BEFORE the piece (i.b) prover lane commits LOC to the over-k shear-iso path.
- **Why it might be cheaper or sounder**: if the ℙ¹-specific path on the `C(k) ≠ ∅` branch turns out to be materially cheaper than (i.b)+(i.c)+(ii)+(iii), the project could collapse the entire pile (iii) commitment and re-scope (i.b). Front-loading this verdict before paying piece (i.b) LOC is a value-of-information argument.
- **What the current strategy may have rejected**: implicit — the strategy schedules iter-135–138 so the verdict feeds (ii)+(iii) but accepts that (i.b) iter-134+ commits before the hedge fires. The strategy notes a "same-iter-133 advance trigger: if iter-134 piece (i.b) prover lane returns slower than envelope, advance hedge to iter-135".
- **Severity of the omission**: minor — the strategy has a partial advance trigger but does NOT front-load value-of-information. A fresh mathematician might argue this is the right move; the strategy implicitly bets piece (i.b) will close within envelope and the hedge will be informational rather than route-redirecting.

## Sunk-cost flags

- `"axis (4) Downstream API shape: The named `cotangentSpaceAtIdentity G` object is consumable by downstream code that needs the cotangent at identity as a first-class `k`-module (e.g. Lie-algebra dual, future `Module.Free k` / `Module.Finite k` companion lemmas, any rigidity argument re-framing)"` (line 518) — Why this is sunk-cost: it names speculative downstream consumers (Lie-algebra dual; "any rigidity argument re-framing") that are NOT on the protected-declaration list and NOT downstream of any committed M2/M3 target the strategy actually plans. Recommendation: Re-frame axis (4) as "named-object utility for the specific protected-declaration consumers" and acknowledge that the speculative consumers are nice-to-have, not load-bearing for the strategy's scope.

- `"axis (3) Blueprint alignment: High: RigidityKbar.tex § Piece (i) decomposition is built around the (i.a)/(i.b)/(i.c) trio with the named cotangent-at-identity object; iter-132 plan-phase writers already aligned the chapter to the (B) closure path"` (line 517) — Why this is sunk-cost: "blueprint already aligned" is a description of past investment, not forward merit; the ~150–300 LOC of blueprint edits needed to pivot to fibre-free is a real switching cost but is itself a measure of how much (B)-shaped work has been committed. Recommendation: Acknowledge the axis as "switching cost driven by past investment", and weight it accordingly when comparing to forward axes.

(The strategy's own iter-133 sunk-cost watchpoint on ground (ii) blueprint cleanliness (line 505) already self-flags this pattern. The 4-axis scorecard repeats the pattern in axes (3) and (4) without the same self-flagging.)

## Prerequisite verification

Mathlib infrastructure named in the strategy:

- `KaehlerDifferential.tensorKaehlerEquiv`: VERIFIED (`Mathlib.RingTheory.Kaehler.TensorProduct`).
- `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`: VERIFIED (`Mathlib.RingTheory.Etale.Kaehler`).
- `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED via `lean_loogle` (`Mathlib.RingTheory.Unramified.Basic`).
- `Ideal.IsLocalRing.CotangentSpace`: VERIFIED (`Mathlib.RingTheory.Ideal.Cotangent`).
- `Module.finrank_baseChange`: VERIFIED (`Mathlib.LinearAlgebra.Dimension.Constructions`).
- `Module.finrank_eq_of_rank_eq`: VERIFIED (`Mathlib.LinearAlgebra.Dimension.Finrank`).
- `Differential.ContainConstants`: VERIFIED (`Mathlib.RingTheory.Derivation.DifferentialRing`).
- `Algebra.IsStandardSmoothOfRelativeDimension`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmooth`).
- `CategoryTheory.GrpObj.mulRight`: VERIFIED (`Mathlib.CategoryTheory.Monoidal.Grp_`).
- `Mathlib.Algebra.CharP.Frobenius` (ring-side): VERIFIED (file exists; `frobenius` def in `Mathlib.Algebra.CharP.Lemmas`).
- `AlgebraicGeometry.Scheme.absoluteFrobenius` (scheme-level): MISSING (confirmed; only `NumberTheory.FrobeniusNumber` and `Mathlib.Algebra.CharP.*` exist). The strategy correctly flags this as a Mathlib gap subsuming piece (iii) and provisionally estimates 800–1500 LOC.
- `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq`: VERIFIED kernel-clean (`{propext, Classical.choice, Quot.sound}`) via `lean_verify`.
- Sheaf-level relative cotangent base change `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}`: MISSING in Mathlib; strategy correctly catalogues as NEEDS_MATHLIB_GAP_FILL load-bearing for piece (i.b).

No phantom prerequisites detected beyond those the strategy already flags.

## Must-fix-this-iter

- **Route piece (i.b) watchpoint — CHALLENGE 1 (watchpoint LOC trigger)**: line 496 watchpoint is "if iter-134+ piece (i.b) shows > 2 iter slip beyond the 2–4 iter / 210–440 LOC envelope without converging, trigger (a')/(c) must fire". This fires on iter-count slip but NOT on LOC overrun. The fibre-free pivot trigger (line 520) has an explicit "> 750 LOC for (i.b) alone" LOC trigger but this is for a different mechanism (re-evaluating fibre-free, not firing (a')/(c)). Recommend: amend the watchpoint to "if iter-134+ piece (i.b) shows > 2 iter slip OR > 600 LOC built without converging, trigger (a')/(c) must fire" — so LOC overrun fires the auto-revert path regardless of iter count. Without this, a piece (i.b) lane that ships 600 LOC in 3 iter (within envelope on iters, above envelope on LOC) would silently absorb LOC overrun.

- **Fibre-free scorecard — CHALLENGE 2 (sunk-cost in axes 3+4)**: lines 511-520 4-axis scorecard contains two sunk-cost-flavored axes (axis (3) blueprint alignment, axis (4) downstream API shape with speculative consumers). Recommend: STRATEGY.md add a paragraph immediately after the scorecard explicitly weighting forward-merit axes (LOC + canonicity) vs switching-cost axes (blueprint alignment + downstream API), so the iter-138+ re-evaluation can re-run the scorecard with measured (i.b)+(i.c) LOC and weight forward-merit axes more heavily. The strategy already self-flags this pattern for ground (ii) blueprint cleanliness (line 505); apply the same discipline here.

- **Sequencing table piece (i.a) row — CHALLENGE 3 (framing under-reports corrective overhead)**: line 473 row reads "DONE — Empirical 5-iter cost / ~300 LOC at midpoint (~600 LOC counting the iter-128/iter-130 body-shape iterations that were subsequently corrected). Final tree state: AlgebraicJacobian/Cotangent/GrpObj.lean 284 LOC, all three declarations land, no sorry." The bottom-line "~300 LOC at midpoint" partially conceals that this required 3 body-shape reshapes across 5 iters (iter-128 → iter-130 → iter-131) to converge — the corrective cost is the visible-to-future-reader signal that "definition + rank lemma" is harder than the iter-127 estimate. Recommend: revise the row's bottom-line to lead with "Total cost iter-128→iter-132 across 3 body reshapes: ~600 LOC of build-and-correct; final tree state 284 LOC" so a fresh reader sees the corrective overhead at first glance.

## Overall verdict

The strategy is SOUND with 3 CHALLENGES that the planner should address in STRATEGY.md edits before iter-134 prover dispatch. The iter-133 plan agent absorbed the 5 iter-133 strategy-critic edits substantively and the 4-axis scorecard / scope-narrow ground (iv) / iter-135–138 hedge schedule advance / piece (i.a) DONE reporting / iter-134+ watchpoint are all materially present. Mathlib prerequisites all verify (modulo the strategy's already-flagged gaps for scheme-level absolute Frobenius and sheaf-level relative cotangent base change). The over-k commitment defense is honestly framed as marginal-quantitative-plus-procedural-hedging; the project's auto-revert wiring (triggers a'/b/c) is appropriate defense-in-depth. A fresh mathematician would approve the strategy as a sound multi-month roadmap with two specific edits: (a) add an explicit LOC trigger to the iter-134+ piece (i.b) watchpoint so LOC overrun doesn't silently absorb beyond envelope, and (b) acknowledge the sunk-cost flavor in axes (3)+(4) of the fibre-free scorecard so iter-138+ re-evaluation weights forward-merit axes appropriately. The piece (i.a) "DONE" framing is minor and editorial.
