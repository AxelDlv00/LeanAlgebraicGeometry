# Strategy Critic Report

## Slug
iter132

## Iteration
132

## Routes audited

### Route: M2 — Genus-0 witness via over-k rigidity (`genusZeroWitness` + `rigidity_over_kbar`)

- **Goal-alignment**: PASS — `genusZeroWitness C h` is the by_cases-true arm of the genus-stratified `nonempty_jacobianWitness` body restructure. The vacuity branch (`C(k) = ∅ ⇒ ∀ P, IsAlbanese …` trivially true on empty domain) is well-formed in Lean.
- **Mathematical soundness**: PASS — the argument is the standard Mumford rigidity argument adapted to characterise smooth proper geom-irr genus-0 curves over arbitrary `k` via the cotangent-vanishing pile + ℙ¹-fiber witness or vacuity. The piece (iii) char-p Frobenius iteration uses *absolute* Frobenius `F_X` (intrinsic), not relative; this is the correct choice for non-perfect `k`.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags below for two instances.
- **Phantom prerequisites**: none on the over-k *strategy* itself; the gating Mathlib references all check out (see Prerequisite verification).
- **Effort honesty**: under-counted on piece (iii) corrected iter-128 (now 800–1500 LOC over 4–7 iter; verified no scheme-level Frobenius in Mathlib); plausible on pieces (i.a/i.b/i.c/ii). The over-k LOC-savings arithmetic vs over-`k̄`+M2.c (the explicit "0–500 LOC, lower-bound zero" admission) honestly concedes the quantitative case is marginal.
- **Verdict**: CHALLENGE — the over-k commitment is defended primarily by qualitative grounds (blueprint cleanliness + auto-revert wiring + iter-131 corrective tractability) after the quantitative LOC defense collapsed to a 0-lower-bound; ground (iv) is being asserted before the iter-132 rank-lemma close validates it. The route is not REJECTED — it remains plausible and the revert triggers are wired — but the planner must accept that iter-132's rank-lemma close is **the** decisive validation event, not iter-131's body-shape refactor.

### Route: M2.body-pile — shared cotangent-vanishing pile (pieces (i)+(ii)+(iii); piece (iv) deferred)

- **Goal-alignment**: PASS — the pile is the precise infrastructure needed to close `rigidity_over_kbar` body; the piece (iv) deferral correctly tracks that Serre duality is only needed for the M2.d RR fallback (not active under over-k).
- **Mathematical soundness**: PARTIAL — piece (i.a)'s Replacement (B) chart-base-change body computes a chart-dependent `k`-module via `Classical.choose` chain; the existential acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` provides U, V, e, htop but NOT the freeness/rank data needed by the rank lemma. The rank-lemma proof must re-extract freeness from `Scheme.smooth_locally_free_omega` directly (definitionally matching the def's `Classical.choose` extractions). The strategy's Step-3→Step-5 chain (Q(c)) is plausible but adds ~20–50 LOC of `Classical.choose` definitional-equality wrangling that the analogist's "[verified]" claim glosses over.
- **Sunk-cost reasoning detected**: yes — ground (iv) circularity. See Sunk-cost flags.
- **Phantom prerequisites**: scheme-level absolute Frobenius `AlgebraicGeometry.Scheme.absoluteFrobenius` — verified MISSING from Mathlib `b80f227` (`lean_local_search "Frobenius"` returns only ring-side `Mathlib.Algebra.CharP.Frobenius` and `NumberTheory.FrobeniusNumber`). The strategy correctly diagnoses this and budgets 800–1500 LOC / 4–7 iter for the in-tree build. NOT a phantom; it's a budgeted gap.
- **Effort honesty**: piece (i.a) revised iter-131 to 5 iter / 250–500 LOC is honest given the empirical iter-128→iter-132 trace. Piece (iii) revised iter-128 to 800–1500 LOC / 4–7 iter is honest (Stacks 0CC4 sketch is the canonical reference, no Mathlib precedent). Piece (ii) at 250–500 LOC / 2–3 iter is plausible given `Differential.ContainConstants` (verified in Mathlib) does the ring-level half.
- **Verdict**: CHALLENGE — the pile decomposition is sound, but the strategy understates that the rank lemma's closure path is NOT just `simp only [cotangentSpaceAtIdentity_eq_extendScalars]`; it requires a parallel `obtain` from `smooth_locally_free_omega` with definitional matching of the `Classical.choose` chain. This is not in itself a blocker, but the iter-132 plan should anticipate it.

### Route: M3 — Positive-genus witness (Route A Picard / Route B Sym^n+Stein)

- **Goal-alignment**: PASS — either route produces the `Jacobian` group object underlying the by_cases-false arm.
- **Mathematical soundness**: PASS for both routes; each is a standard construction.
- **Sunk-cost reasoning detected**: no — the strategy honestly flags M3 as not on the iter-by-iter critical path until M2 closes (multi-month away).
- **Phantom prerequisites**: many gating pieces (Hilbert/Quot representability, Sym^n of schemes, Stein factorisation, Brill–Noether) are correctly named as missing from Mathlib. No phantom *names*.
- **Effort honesty**: 6500–9000 LOC (iter-123 audit midpoints) is honest. The 5000-LOC hard-fallback threshold was triggered and the iter-126 user-hint absorbed the escalation in favor of "do the work". Honest.
- **Verdict**: SOUND — the route is off-critical-path until M2 closes; the strategy correctly defers route-pick details. No iter-132 action required on M3.

### Route: End-state — zero inline `sorry`

- **Goal-alignment**: PASS — the iter-121 pivot to "zero `sorry`" + "no new axioms" (reaffirmed iter-126 user hint) aligns with the protected-declarations frozen by the mathematician.
- **Mathematical soundness**: PASS — the genus-stratified body restructure is mathematically valid (genus is `ℕ`-valued, decidable, `by_cases h : genus C = 0` is well-formed).
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: No-Frobenius rigidity via higher Kähler `H¹(C, Ω_C^{⊗p})` vanishing

- **What it looks like**: replace piece (iii) (char-p Frobenius iteration) with a "no-Frobenius" formulation: in characteristic `p`, the obstruction handled by Frobenius iteration is that `df = 0` doesn't directly imply `f` factors through `Spec k` when `f` is given by `p`-th powers. An alternative is to bypass Frobenius entirely by appealing to the *vanishing* of the higher Kähler differentials `Ω_{C/k}^{⊗p^n}` on a smooth proper genus-0 curve (which reduces to `H¹(ℙ¹, O) = 0` on charts), giving a non-iterative cotangent-vanishing argument. The strategy's "shared cotangent-vanishing pile" framing suggests this alternative was considered; but piece (iii) is committed to Option A (Frobenius iteration), per the iter-126/iter-127 analogist verdicts.
- **Why it might be cheaper or sounder**: avoids the 800–1500 LOC scheme-level absolute-Frobenius build entirely; reduces piece (iii) to a ring-side cohomological vanishing already in Mathlib. Eliminates the longest gating bar in M2 piece (iii).
- **What the current strategy may have rejected**: unclear — the analogist verdict is recorded as "Option A: char-p Frobenius iteration" with no explicit weighing of an Option B "higher-Kähler vanishing". The user-hint discipline note added iter-128 is precisely the obligation to "justify on local LOC/iter trade-off vs alternatives, not by appeal to the user hint as a blanket".
- **Severity of the omission**: major — piece (iii) is the dominant cost in the M2.body-pile; an unexplored alternative that potentially eliminates it would re-cast the M2 budget materially. The planner should dispatch a one-iter mathlib-analogist on this Option B before committing further LOC to scheme-level Frobenius.

### Alternative: Fibre-free piece (i) unconditional (drop the trigger-on-rank-lemma-cheapness criterion)

- **What it looks like**: prove `Ω_{G/k}` globally free of rank `n` directly via the shear iso applied to the *sheaf* of relative differentials, without ever naming a single "cotangent at identity" object. The strategy elevates fibre-free as an iter-132 evaluation criterion contingent on the rank-lemma closing in ≤ 100 LOC.
- **Why it might be cheaper or sounder**: avoids the entire (B)-vs-(A)-vs-(B′) chart-canonicity rabbit hole that has consumed iter-128 through iter-131. The iter-131 (B′) analogist verdict (REJECTED, shares the regular-local bridge with (A)) is itself evidence that named-cotangent presentations are structurally costly under (B).
- **What the current strategy may have rejected**: the strategy elevates fibre-free as a contingent iter-132 evaluation but does not commit to evaluating it unconditionally. The trigger criterion "if rank lemma closes ≤ 100 LOC" is logically inverted: cheap rank-lemma close validates (B), which is the OPPOSITE of evidence to pivot. The criterion should fire unconditionally at iter-132 close, evaluating projected (i.b)+(i.c) LOC under (B) vs projected fibre-free cost — regardless of rank-lemma LOC.
- **Severity of the omission**: major — the inverted-feeling trigger means fibre-free likely won't fire and the project stays on (B) for piece (i.b)/(i.c) by default, even if fibre-free were materially cheaper. Planner must re-state the trigger as unconditional evaluation at iter-132 close.

### Alternative: Scaffold `positiveGenusWitness` now (parallel to M2.body-pile build)

- **What it looks like**: introduce a stub `positiveGenusWitness C (hg : 0 < genus C)` declaration in `Jacobian.lean` with a `sorry` body, parallel to the iter-127 `genusZeroWitness` scaffold. This would unblock the genus-stratified body restructure of `nonempty_jacobianWitness` immediately (both arms scaffolded), reducing project sorry count by 1 (the `nonempty_jacobianWitness:194` site disappears, replaced by two sub-sorries).
- **Why it might be cheaper or sounder**: the strategy says the body restructure happens "once `genusZeroWitness` AND `positiveGenusWitness` are at least scaffolded". Local search confirms `positiveGenusWitness` is NOT scaffolded. Scaffolding it costs ~20–30 LOC and unlocks the restructure — a free strategic win that is currently parked.
- **What the current strategy may have rejected**: unclear — the strategy mentions the prerequisite in passing but doesn't schedule the scaffold. The sequencing table puts "M2 closure (genus-stratified body restructure)" at iter-157+ gated on M2.b body closure AND M3 scaffolding; an iter-133+ M3-scaffold lane would land it before iter-157.
- **Severity of the omission**: minor — the scaffold is cheap and would tidy up sorry-bookkeeping; the strategic gain is small but the cost is nearly zero.

### Alternative: ℙ¹-specific rigidity hedge on `C(k) ≠ ∅` branch — elevate from hedge to active path

- **What it looks like**: the strategy documents this as a hedge "not on the iter-129+ active build path; available if the over-k pile (i)+(ii)+(iii) blows past 2000 LOC at iter-145+". Cost: ~500–1000 LOC. Trigger: pile exceeds budget.
- **Why it might be cheaper or sounder**: the trigger condition is set at 2000 LOC, but the pile's current honest midpoint is 1850–3600 LOC (iter-128 revised) — i.e., the upper half of the pile estimate range already exceeds the hedge trigger. The hedge should be re-evaluated now, not parked.
- **What the current strategy may have rejected**: the hedge avoids building piece (iii) scheme-level absolute Frobenius entirely (since on a ℙ¹-specific path, pieces (ii) and (iii) collapse to ring-side `k[t]`/`k[1/t]` instances). The hedge requires a "weak ℙ¹ identification" (smooth proper geom-irr genus-0 with a rational point ⇒ `C ≅ ℙ¹_k`), claimed by the strategy to need only elementary projective-embedding + low-order-pole-existence (NOT full Serre duality). If true, this is a materially cheaper M2.a path.
- **Severity of the omission**: major — the strategy parks the hedge but the pile's upper-bound LOC (3600) already exceeds the hedge trigger threshold (2000). The planner should activate the hedge evaluation now (one mathlib-analogist consult on the "weak ℙ¹ identification" claim) rather than wait until iter-145+ failure.

## Sunk-cost flags

- `"the iter-131 corrective dispatch (mathlib-analogist + refactor) is positive evidence that piece (i.a) is tractable under (B). Added iter-131 per strategy-critic-iter131 reframing"` — Why this is sunk-cost: iter-131 was itself a corrective iter for iter-130's opacity defect. Citing iter-131 as "positive tractability evidence" before the iter-132 rank-lemma close validates it is bootstrapping: the only iter-131 deliverable was the body-shape `_eq_extendScalars` `rfl` close, which is a structural alignment, not a content-bearing closure. The iter-128 close was struck (correctly, iter-130) as evidence; iter-131 is in the same evidence class — a corrective iter whose value can only be confirmed by what it enables downstream. Recommendation: strike ground (iv) until iter-132 closes the rank lemma; until then the over-k commitment rests on grounds (ii) cleanliness + (iii) revert wiring, which are honest but qualitative only.

- `"the over-k commitment is now defended on cleanliness (ii) + active revert option (iii) + iter-131 corrective tractability (iv) + the LOC arithmetic (which yields 0–500 LOC savings, lower-bound zero). The quantitative case is marginal; the qualitative case … carries the decision."` — Why this is sunk-cost: the strategy candidly acknowledges quantitative LOC parity (lower-bound zero savings) but lets qualitative grounds carry the day after the quantitative defense was eroded across iter-128 → iter-130 → iter-131. This is the pattern: each iter shaves a bit off the over-k case, the strategy adapts by introducing a new qualitative ground, and the *decision* never re-opens. Recommendation: at iter-132 close, if rank lemma closes but the cumulative empirical piece (i.a) cost (5 iter / 250–500 LOC) is more than 3× the iter-129-analogist's "50–100 LOC / 1–2 iter" anchor (already struck iter-131), formally re-open the over-k vs over-`k̄` decision rather than continuing to absorb adjustments.

- `"the iter-126 user hint 'do the work, no axioms; ~6500–9000 LOC may not be that much for an AI' was issued in the specific context of the M3 user-escalation TO_USER banner … it is NOT a generic blanket warrant for all expensive in-tree paths."` — Why this is itself a sunk-cost-flag from iter-128 (the strategy is self-aware here, good). But the discipline note has NOT been applied to piece (iii) scheme-level absolute Frobenius, which is a 800–1500 LOC commitment that is *not* defended on local trade-off vs alternatives (the no-Frobenius / higher-Kähler-vanishing alternative is not weighed in the prose). Recommendation: dispatch a one-iter mathlib-analogist on piece (iii) Option B (no-Frobenius alternative) before iter-143+ committing further LOC to scheme-level Frobenius.

## Prerequisite verification

- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: VERIFIED (`Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean`).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED (instance, same file).
- `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED (`Mathlib/RingTheory/Unramified/Basic.lean`).
- `Module.finrank_baseChange`: VERIFIED (`Mathlib/LinearAlgebra/Dimension/Constructions.lean`).
- `KaehlerDifferential.subsingleton_of_surjective`: VERIFIED (`Mathlib/RingTheory/Kaehler/Basic.lean`).
- `Differential.ContainConstants`: VERIFIED as `class` (`Mathlib/RingTheory/Derivation/DifferentialRing.lean`).
- `Ideal.IsLocalRing.CotangentSpace`: VERIFIED as `abbrev` (`Mathlib/RingTheory/Ideal/Cotangent.lean`); replaces earlier phantom `IsRegularLocalRing.cotangentSpace`.
- `Algebra.FormallyUnramified` (typeclass): VERIFIED.
- `ModuleCat.extendScalars`: VERIFIED (`Mathlib/Algebra/Category/ModuleCat/ChangeOfRings.lean`).
- `AlgebraicGeometry.Scheme.absoluteFrobenius` (scheme-level absolute Frobenius): MISSING. `lean_local_search "Frobenius"` returns only `NumberTheory.FrobeniusNumber`; `lean_local_search "absoluteFrobenius"` returns nothing. The strategy correctly diagnoses this as a 800–1500 LOC in-tree build candidate. NOT a phantom — it is a budgeted gap.
- `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim`: project-internal phantom (piece (i.c) target). Correctly marked as PHANTOM in the strategy's gap inventory.
- `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`: project-internal phantom (piece (ii) target). Correctly marked.
- `cotangentSpaceAtIdentity` + `cotangentSpaceAtIdentity_eq_extendScalars`: VERIFIED present at `AlgebraicJacobian/Cotangent/GrpObj.lean` (iter-131 refactor). The `_eq_extendScalars` proof closes via `refine ⟨h.choose, …, rfl⟩` — the `rfl` is meaningful evidence that the iter-131 `let`-chain body delta-reduces cleanly to the explicit `extendScalars`/`ModuleCat.of` shape.
- `positiveGenusWitness`: MISSING from the project (not scaffolded). The strategy's "M2 closure gated on `positiveGenusWitness` scaffold" prerequisite is unstated as a separate scheduled item.

## Directive questions (Q(a), Q(b), Q(c))

**Q(a) — Does the 5-iter piece-(i.a) empirical cost still constitute net-positive over-k commitment vs over-`k̄`?**

PARTIAL. The strategy honestly admits LOC savings 0–500 (lower-bound zero) vs over-`k̄`+M2.c, with the qualitative case (single-chapter blueprint + revert wiring + iter-131 corrective tractability) carrying the decision. The iter-131 ground (iv) is the weakest link: iter-131 was itself corrective on iter-130's defect, so citing it as positive tractability evidence is bootstrapping. The actual decisive validation event is the iter-132 rank-lemma close. RECOMMENDATION: strike ground (iv) from the over-k defense until iter-132 closes. The over-k commitment then rests on quantitative parity (lower-bound zero) + qualitative cleanliness (ii) + revert wiring (iii). At iter-132 close, if the rank lemma closes, ground (iv) can be reinstated as iter-132 (NOT iter-131) tractability evidence — but the empirical 5-iter piece-(i.a) cost should be benchmarked against a counterfactual over-`k̄`-baseline 3-iter / ~400 LOC budget. If the over-k path's piece (i.a) ran more than 50% above counterfactual over-`k̄`, formally re-open the decision.

**Q(b) — Is the iter-132 rank-lemma-close fibre-free evaluation criterion sound, or should it fire unconditionally?**

The current criterion "if rank lemma closes ≤ 100 LOC at iter-132, evaluate fibre-free for (i.b)+(i.c)" is logically inverted: cheap rank-lemma close is *validation* of (B), not evidence to pivot. The fibre-free elevation should fire UNCONDITIONALLY at iter-132 close, comparing projected (i.b)+(i.c) LOC under (B) (200–500 + 100–300 = 300–800 LOC, per the sequencing table) vs projected fibre-free cost (~400–800 LOC bundled for (i.b)+(i.c)). Under the current strategy's own estimates, fibre-free is at the upper end of (B)'s bundled cost — i.e., approximately equal, NOT obviously cheaper — so the unconditional evaluation may well *return* "stay on (B)". But the evaluation should happen on the merits, not behind a trigger that fires when (B) succeeds. RECOMMENDATION: re-state the criterion as "evaluate fibre-free at iter-132 close regardless of rank-lemma LOC; pivot if projected (i.b)+(i.c) under (B) is materially larger than projected fibre-free cost, where 'materially' = >20% LOC differential".

**Q(c) — Does Step 3 (`cotangentSpaceAtIdentity_eq_extendScalars`) cleanly unblock Step 5 (`Module.finrank_baseChange`) for the rank lemma?**

PARTIAL. The chain is feasible but the analogist's "[verified]" gloss understates one wrinkle:

- `_eq_extendScalars` provides `∃ U V e htop, cotangentSpaceAtIdentity G = (extendScalars …).obj (of … Ω[…])`. The witnesses U, V are bound by the existential; the freeness / rank data of `Ω[Γ(G.left, V) ⁄ Γ(Spec k, U)]` is NOT carried by this lemma.
- The rank lemma `cotangentSpaceAtIdentity_finrank_eq` must therefore re-extract freeness via a parallel call to `Scheme.smooth_locally_free_omega (n := n) G.hom x₀`. Because this is the *same* function call as the def's `let h := …` (and as `_eq_extendScalars`'s internal `let h := …`), the `Classical.choose` chains are *definitionally* equal — so the rank lemma can `obtain ⟨U, V, e, htop, h_body⟩ := _eq_extendScalars` and *also* `let h := smooth_locally_free_omega …` and extract the standard-smooth + base-change witness from `h.choose_spec.choose_spec.choose_spec.2.2`, with the two extractions matching by definitional reduction. This is the ~20–50 LOC of `Classical.choose` wrangling that the analogist's chain doesn't surface.
- Then `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (verified) gives `Module.finrank Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec k, U)] = n`, and `Module.finrank_baseChange` (verified) pushes this through `extendScalars`.

The chain is plausible. The chain is not 1-step `simp only [_eq_extendScalars]`; it requires careful `Classical.choose` matching. RECOMMENDATION: the iter-132 plan should explicitly anticipate the parallel-extraction proof shape rather than trusting `_eq_extendScalars` alone.

## Must-fix-this-iter

- Route M2 (over-k path): CHALLENGE — strike ground (iv) from the over-k defense until iter-132 rank-lemma close validates it. The over-k commitment currently rests on cleanliness + revert wiring + a circular tractability claim.
- Route M2.body-pile: CHALLENGE — clarify the rank-lemma closure path: `_eq_extendScalars` is necessary but not sufficient. Plan must anticipate `Classical.choose` parallel-extraction work.
- Alternative "No-Frobenius rigidity via higher Kähler vanishing": major — dispatch a one-iter mathlib-analogist on Option B before iter-143+ commits 800–1500 LOC to scheme-level absolute Frobenius. The strategy's own user-hint citation discipline (added iter-128) requires this.
- Alternative "Fibre-free unconditional evaluation": major — re-state the iter-132 fibre-free criterion as unconditional evaluation. The "if rank-lemma close ≤ 100 LOC" trigger is logically inverted (fires when (B) succeeds).
- Alternative "ℙ¹-specific rigidity hedge — elevate from hedge": major — the pile's honest upper-bound LOC (3600) already exceeds the 2000-LOC trigger that activates the hedge. The hedge should be evaluated now, not deferred to iter-145+.
- Alternative "Scaffold `positiveGenusWitness` now": minor — schedule the scaffold (≤30 LOC) to unlock the genus-stratified body restructure precondition.
- Phantom prerequisite: none confirmed missing that the strategy doesn't already track. `AlgebraicGeometry.Scheme.absoluteFrobenius` is correctly diagnosed as missing-and-budgeted.

## Overall verdict

A fresh mathematician would approve the strategy as *mathematically* sound — the over-k decomposition into (i)+(ii)+(iii) is correct; the Replacement (B) chart-base-change body is structurally accessible; the genus-stratified body restructure is well-formed; M3 is honestly framed as multi-month off-critical-path; the no-new-axiom + zero-sorry end-state is consistent with the protected signatures.

But a fresh mathematician would push back on the *strategic posture* in three places: (1) the over-k commitment is now defended by qualitative grounds after quantitative parity collapsed to lower-bound zero, with the iter-131 corrective tractability ground (iv) being bootstrapped before iter-132 validates it; (2) the fibre-free criterion is logically inverted — it triggers when (B) succeeds, which is bizarre for a "pivot away from (B)" criterion; and (3) the strategy commits 800–1500 LOC to scheme-level absolute Frobenius (piece (iii)) without weighing the no-Frobenius / higher-Kähler-vanishing alternative, violating the strategy's own iter-128 user-hint citation discipline.

None of these are REJECT-level. The route is workable. But the planner this iter should (a) strike ground (iv), (b) re-state the fibre-free criterion, and (c) schedule one mathlib-analogist consult on the no-Frobenius alternative before iter-143+ commits further LOC.
