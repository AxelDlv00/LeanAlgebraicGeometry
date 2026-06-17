# Strategy Critic Report

## Slug
overbudget-recheck

## Iteration
162

## Routes audited

### Route: Route A — Picard/Quot/Hilbert FGA engine (positive-genus object)

- **Goal-alignment**: PASS — the positive-genus witness must be a real dim-`g` abelian variety even when `C(k)=∅`; `Pic⁰_{C/k}` is the right object and the Albanese UP delivers `isAlbaneseFor`.
- **Mathematical soundness**: PASS — FGA representability → `Pic⁰` → Albanese is the standard, correct construction.
- **Phantom prerequisites**: none — the strategy correctly flags Hilbert/Quot/Pic representability as *absent* from Mathlib (verified: no `AbelianVariety`, no general RR). It does not assume phantom infra; it commits to building it.
- **Effort honesty**: reasonable-to-optimistic — `~5100+ LOC` / `~40–70 iters` for the full FGA engine is a defensible order-of-magnitude, but the strategy itself admits "Albanese UP ... NOT yet itemised in ~5100 — true budget higher." Honest about its own incompleteness.
- **Verdict**: SOUND — mandatory and correctly characterized as the critical path.

### Route: Genus-0 rigidity, route (c) — char-free AV-rigidity lemma (the cube)

- **Goal-alignment**: PARTIAL — produces `ℙ¹→A constant` over `k̄`; the `k̄→k` descent of the morphism-equality (needed to land the UP over arbitrary `k`) is explicitly "direction unconfirmed," and the genus-0 `isAlbaneseFor` is the real content (terminal `J` does NOT make it automatic — the UP forces `f = const`, which IS the theorem). Acceptable but not yet closed end-to-end.
- **Mathematical soundness**: PARTIAL — the chain is sound, BUT the keystone justification "the base case `ℙ¹→A constant` rests **irreducibly** on the cube" is **overstated** (see below). There is a cube-free differential route for the concrete `ℙ¹`.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags.
- **Phantom prerequisites**: none asserted as existing; the cube, seesaw, cohomology base-change, semicontinuity, RR are all correctly flagged absent (verified).
- **Effort honesty**: under-counted — the cube line reads `~8–15` iters while the same row calls it "comparable to a chunk of representability," and the body lists its drag as *seesaw + flat/proper cohomology base-change + semicontinuity + line bundles on products*, **all zero-Mathlib**. Each of those is itself a major build. If representability is 40–70 iters, "a chunk" of it dragging four absent sub-theorems is plausibly ≥15, not 8. The genus-0 arm's true ceiling likely exceeds the stated 32.
- **Verdict**: CHALLENGE — the cube's *necessity* and the route's *ranking* against the alternatives are under-justified; the OVER_BUDGET re-estimate is precisely the trigger to re-open them. Must be addressed (STRATEGY.md edit or explicit plan.md rebuttal) this iter.

### Route: (b) genus-0 as byproduct of Route A

- **Verdict**: SOUND as a fallback, but **under-weighted** given the new budget — see Alternatives. The strategy dismisses it as "couples to A.2 representability," yet never reconciles that with its own claim that the cube (route (c)'s dominant cost) is *also* required by Route A.

### Route: (a) differential route via Serre duality

- **Verdict**: SOUND as an off-path artifact, but the strategy's reason for demoting it (the char-`p` gap in `df=0 ⟹ const`) is the SAME gap whose patch (Frobenius descent) it never costs — see Alternatives / Sunk-cost.

## Format compliance

- **Size**: 165 lines / 13070 bytes — lines within budget; bytes ~13.1 KB, marginally **over** the ~12 KB target.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order. (The `## References index` / `## Blueprint summary` / `## Prior critique status` blocks in the directive are directive scaffolding, NOT in the file — confirmed by reading STRATEGY.md directly.)
- **Per-iter narrative detected**: yes — **pervasive**, the single biggest format problem. Representative: "Cube question RESOLVED iter-157 (NEGATIVE): the split is opposite the iter-156 hope", "(updated iter-162)", "re-est ~18–32 (was ~10–18; OVER_BUDGET confirmed iter-162)", "Architecture (decided iter-157)", "the prover-ready entry, iter-158", "CLOSING iter-162". Iter numbers belong in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: yes (mild) — the iter-156→157 cube-question litigation reads as preserved history, not forward strategy.
- **Table discipline**: PASS-with-drift — columns are correct, but the genus-0 row's Status and Risks cells are multi-clause paragraphs rather than one short line each.
- **Format verdict**: DRIFTED — core skeleton and headings are intact, but the pervasive `iter-NNN` narrative and prose-stuffed table cells bleed history into the plan agent's context every iteration. Clean up in place this iter (no full restructure needed): purge iter numbers, compress the genus-0 row cells, trim ~1 KB.

## Alternative routes (suggested)

### Alternative: differential + Frobenius-descent hybrid for `ℙ¹→A constant` (cube-free)

- **What it looks like**: Given `C_k̄ ≅ ℙ¹` (the RR bridge, which route (c) needs *anyway*), prove `ℙ¹→A constant` WITHOUT the cube: (1) `Ω_A ≅ O_A^g` (invariant differentials trivialize the cotangent bundle — `GrpObj.cotangentSpaceAtIdentity` is the design template, ~800–1500 LOC, already scoped); (2) `df : f*Ω_A = O_{ℙ¹}^g → Ω_{ℙ¹}=O(−2)` is zero because `Hom(O,O(−2))=H⁰(O(−2))=0` — **elementary on the concrete ℙ¹**, exactly as the strategy itself notes; (3) char-`0`: `df=0 ⟹ const` directly. char-`p`: `df=0 ⟹ f` factors through relative Frobenius `ℙ¹→ℙ¹⁽ᵖ⁾≅ℙ¹`; iterate `f=fₙ∘Fⁿ`, and `deg f = pⁿ·deg fₙ` forces `fₙ` constant — hence `f` constant. Reuses the **already-built, axiom-clean** chart-algebra envelope + GrpObj template.
- **Why it might be cheaper or sounder**: it avoids the theorem of the cube and its entire drag (seesaw, flat/proper cohomology base-change, semicontinuity, line bundles on products) — the strategy's own DOMINANT, "comparable-to-representability" cost. The only genus-0-specific new build is relative-Frobenius factorization for smooth curves, a far more contained piece than the cube apparatus, plus the `Ω_A` globalization that is already templated. The strategy demoted the differential route (a) citing "`df=0 ⟹ const` is FALSE in char `p`" — but it simultaneously names the patch ("Frobenius descent") and **never costs it**, so the dismissal is unquantified.
- **What the current strategy may have rejected**: the strategy treats the cube as "irreducible" (RESOLVED iter-157, NEGATIVE) and froze it ("No budget cut"). But "irreducible" is contingent on *refusing the differential approach*, not a theorem: the `df=0+Frobenius` path is a genuine cube-free route to the same base case. The strategy's "irreducible" claim conflates "no cube-free *non-differential* argument" with "no cube-free argument."
- **Severity of the omission**: major — it directly attacks the ~8–15-iter cost the OVER_BUDGET re-estimate is built on.

### Alternative: commit route (b) outright — genus-0 from `dim Pic⁰ = genus = 0`, no `C≅ℙ¹`

- **What it looks like**: Once Route A's `Pic⁰` exists, `dim Pic⁰ = genus C = h¹(O_C) = 0`, so `Pic⁰` is a 0-dimensional connected group scheme = trivial, hence `Alb(C)=0` and every pointed `f` is constant. This computes `Alb=0` from the *genus* directly and **never needs the `C_k̄≅ℙ¹` RR bridge** (the ~5–10-iter genus-0-specific cost), nor a separate cube-wiring, nor the rigidity-lemma chain.
- **Why it might be cheaper or sounder**: Route A is mandatory regardless. If the cube is genuinely shared with Route A's Albanese UP (the strategy's own claim), then route (b) costs essentially ZERO genus-0-specific iters beyond "a 0-dim'l connected group scheme over a field is trivial." Paying 18–32 iters to AVOID coupling to a phase that is being built anyway is a steep insurance premium.
- **What the current strategy may have rejected**: coupling to A.2 representability risk. But note the decoupling logic is **partially self-defeating**: route (c) *also* needs the cube, so if Route A stalls *at the cube*, (c) stalls too. (c)'s insurance only covers the *post-cube A.2-specific* failure mode — a narrower risk than advertised, for a large premium.
- **Severity of the omission**: major — the budget doubling is exactly the event that should re-open (b)-vs-(c), and the strategy declares "No budget cut" instead of re-deciding on merits.

## Sunk-cost flags

- `"Cube avoidance (RESOLVED iter-157, NEGATIVE): ... The cube cannot be dodged for char-free genus-0 ... No budget cut."` — Why this is sunk-cost: a decision reached when the arm was estimated at ~10–18 iters is being held fixed ("No budget cut") even after the estimate doubled to ~18–32, without re-deriving it from current costs. Recommendation: re-decide the cube on its merits *now*, against the differential+Frobenius hybrid and route (b), at the new budget — not by appealing to the iter-157 resolution.
- `"the cube is the heavy keystone, SHARED with Route A's Albanese UP (not throwaway). (c) stays cheaper than (b)"` — Why this is sunk-cost-adjacent: the "not throwaway / shared" justification is doing ALL the load-bearing work for committing the cube now, yet the sharing claim ("Milne §III.6") is **asserted, not verified**. If the cube is NOT actually on Route A's mandatory path, route (c) pays the full ~8–15-iter cube cost as a pure genus-0 tax. Recommendation: before opening the cube prover lane, the planner must confirm the cube is genuinely required (and will be built) for Route A's Albanese UP. That single fact flips the whole ranking: shared ⟹ (c) reasonable; not shared ⟹ hybrid/(b) win.

## Prerequisite verification

- `AlgebraicGeometry` `AbelianVariety` (type/theory): MISSING — loogle returns no results; the strategy correctly states "no `AbelianVariety` theory" in Mathlib. Budget pessimism justified.
- general Riemann–Roch for curves: MISSING — leansearch surfaces only `WeierstrassCurve`/elliptic-curve degree machinery, no general RR. The strategy's "no Mathlib RR" and the genus-0⟹ℙ¹ bridge as "a real sub-build" are correct.
- theorem of the cube / seesaw / cohomology base-change for `R^i f_*`: not separately probed, but consistent with the absent `AbelianVariety` theory; the strategy treats them as absent, which is the safe assumption.

## Must-fix-this-iter

- Route Genus-0 (c): CHALLENGE — (1) verify and record whether the theorem of the cube is genuinely on Route A's mandatory path; the "SHARED, not throwaway" justification is asserted, not established, and it is the sole load-bearing reason to commit the cube now. (2) Re-decide the cube against the cube-free differential+Frobenius hybrid and against route (b) **at the new ~18–32 budget**, rather than citing the iter-157 resolution. (3) Either correct or defend the "rests irreducibly on the cube" claim — the `df=0`+Frobenius path is a cube-free route to `ℙ¹→A constant`. Resolve in STRATEGY.md or via an explicit rebuttal in `iter/iter-162/plan.md`.
- Alternative (differential+Frobenius hybrid): major — strategy dismissed the differential route on a char-`p` gap whose patch it never costs. Planner must cost the Frobenius-factorization patch before treating the cube as the only char-free option.
- Alternative (route (b) outright): major — the budget doubling is the trigger to re-open (b)-vs-(c); "No budget cut" is not a re-decision. Note (c)'s decoupling only insures against the *post-cube* A.2 risk, not the cube itself.
- Format: DRIFTED — purge pervasive `iter-NNN` narrative (move to `iter/iter-162/plan.md`), compress the genus-0 row's prose-heavy Status/Risks cells to one line each, and trim ~1 KB to clear the 12 KB target. In-place cleanup, no restructure.

## Overall verdict

A fresh mathematician would approve **Route A** without reservation — it is the correct, mandatory construction and honestly self-flagged as the critical path. The **genus-0 route (c)**, however, has a soft spot the OVER_BUDGET event exposes: the entire case for building the theorem of the cube *now, for the genus-0 arm* rests on two claims that are stated but not established — that the cube is "irreducible" for char-free `ℙ¹→A constant` (a cube-free differential+Frobenius route exists, reusing already-built assets), and that the cube is "shared with Route A" (asserted via a bare source pointer). If the cube is shared, route (c) is a reasonable free-rider; if it is not, route (c) pays an ~8–15-iter genus-0-specific tax that both the differential hybrid and route (b) avoid. The char-freeness requirement is real and load-bearing (the protected goal is arbitrary `[Field k]`) — but char-freeness argues against the *naive* `df=0` route, NOT against the differential+Frobenius hybrid, and NOT necessarily for the cube specifically. The doubling of the estimate is exactly the moment to re-derive the route choice from current costs rather than freeze it on the iter-157 verdict. This is a CHALLENGE, not a REJECT: route (c) may well survive the re-examination, but the planner must perform it (verify the sharing, cost the hybrid, re-weigh (b)) this iter rather than carry the decision forward unexamined. Format is DRIFTED on pervasive iter-narrative — clean in place.
