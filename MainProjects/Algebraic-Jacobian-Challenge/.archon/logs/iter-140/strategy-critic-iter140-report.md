# Strategy Critic Report

## Slug
iter140

## Iteration
140

## Scope

Fresh-context re-render. Re-verifies the three iter-139 STRATEGY.md edits
named in the directive, refreshes standing verdicts on five longer-standing
routes, raises one new challenge.

---

## Routes audited

### Route: iter-138 §519 reframing "operationally defaulted, bounded revert cost preserved" + iter-139 §519 auto-flag execution

(Edit 1 from directive)

- **Goal-alignment**: PASS — the over-k commitment, if executed, lands `rigidity_over_k` against the protected signature, which is exactly what M2.a requires.
- **Mathematical soundness**: PASS — the over-k path's three pieces (cotangent triviality intrinsic, Differential.ContainConstants k-agnostic, absolute Frobenius `F_X` intrinsic to `X`) are mathematically defensible and the iter-127 analogist's OK_OVER_K verdict is technically sound.
- **Sunk-cost reasoning detected**: yes — but already self-flagged honestly. The strategy admits ground (i) was struck (iter-130), ground (iii) demoted (iter-136), and grounds (ii)+(iv) are "switching cost + single-piece route-validation." The text candidly says "the strategy does NOT claim over-k is sounder or cheaper than over-`k̄` in the abstract; it claims that **given the project's current state**, defaulting to over-k with explicit revert triggers is the lowest-friction path." That IS the operational definition of sunk-cost-with-revert-option, and the strategy names it as such.
- **Phantom prerequisites**: none under (B).
- **Effort honesty**: reasonable — the quantitative case is acknowledged as lower-bound zero; the framing no longer overclaims savings.
- **Verdict**: SOUND
  - The iter-140 binding criterion ("close ≥2 of 3 sub-sorries OR fire CHURNING-trigger") is concrete, falsifiable, mid-iter-dispatchable. That is what makes this not pure sunk-cost dressing: a measurable outcome forces a re-decision next iter. Of the three iter-139 edits, this one is the strongest.

**Caveat**: the standing risk is that the iter-140 trigger fires but the strategy then absorbs the absorption — i.e., "we closed 2 of 3, so the criterion fires" but the cumulative-LOC arm needs re-checking. The iter-140 plan agent must apply BOTH arms (sub-sorry count AND <1000 LOC cumulative); a partial-renormalisation pattern here would re-introduce exactly the failure mode the iter-138 renormalisation-discipline rule forbids.

---

### Route: § Soundness rules new bullet "analogist-overhead axis on M2.body-pile cost accounting" (5-consult threshold)

(Edit 2 from directive)

- **Goal-alignment**: PASS — a meta-rule on when route-pivots auto-fire; orthogonal to the protected goal.
- **Mathematical soundness**: n/a (procedural rule).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: n/a (no LOC claim).
- **Verdict**: CHALLENGE — the "5" is not defensible on principle. The iter-139 baseline is "piece (i.b) Step 2 carries 4 consults" and the threshold is set at 5; this is a "fires next iter" calibration, not a principled value. The accompanying "≥3 envelope-widening consults" arm IS principled (envelope-widening is a strong route-difficulty signal); the consult-count arm is not.

**Recommendation for absorption**:
- Either drop the consult-count arm and keep only the envelope-widening arm (cleaner, principled);
- OR keep the consult-count arm but explicitly mark it as "current-state calibration; revisit if it doesn't fire on any sub-piece by iter-150."
- The strategy already has a "moving-goalpost" guardrail in the iter-138 LOC renormalisation discipline (line 398–399); the consult-count threshold should obey the same discipline ("the threshold can renormalise ONLY when a new analogist consult justifies a new envelope").

This is a CHALLENGE, not a REJECT, because: (a) a procedural threshold of any value is better than none; (b) the threshold is bounded — even if iter-140 produces a 5th consult that doesn't fire the envelope arm, the route-pivot question being re-raised is itself low-cost.

---

### Route: M3 Route A "Relative Spec functor off-loop PR lane (~700–1100 LOC)"

(Edit 3 from directive)

- **Goal-alignment**: PARTIAL — the lane is presented as "concretising the zero-sorry end-state commitment for M3," but as currently scoped it does NOT do that.
- **Mathematical soundness**: PASS — Relative Spec functor is canonical Mathlib infrastructure; the LOC envelope (~700–1100 LOC from the iter-123 audit) is plausible.
- **Sunk-cost reasoning detected**: yes — the iter-139 framing "zero-sorry-end-state defense: this off-loop lane concretises the project's 'zero-sorry end-state' commitment for M3 — it is not pure wait-and-see post-M2-closure" is rhetorical. The lane "runs independently of the iter-by-iter prover dispatch; no in-loop prover assignment until M2 closes." That IS pure wait-and-see-with-a-named-bin.
- **Phantom prerequisites**: none in the construction itself.
- **Effort honesty**: under-counted — the lane has zero in-loop iter-deliverables. Comparing to M1.d off-loop (which had a concrete in-tree declaration `kaehler_quotient_localization_iso` from iter-126 onward, only the upstream PR packaging happening off-loop), the M3 Relative Spec lane has NO in-tree declaration yet. The off-loop precedent doesn't transfer cleanly.
- **Verdict**: CHALLENGE

**Recommendation for absorption**: either
- (a) Add a concrete in-loop scaffold in some near iter (a sorry-bodied `RelativeSpec` declaration in-tree, structurally analogous to the iter-127 `genusZeroWitness` and iter-134 `positiveGenusWitness` scaffolds), which would genuinely concretise zero-sorry for that piece; OR
- (b) Drop the "concretises the zero-sorry commitment" claim; classify the lane honestly as "post-M2 planning hook + identification of the smallest PR-extractable piece for when M3 starts." Either is fine; the current framing is overclaiming.

The strategy's own iter-139 plan agent already named the alternative ("option (i)-full (in-loop iter-by-iter M3 plan alongside M2, doubles complexity)") and rejected it on cost. That rejection is defensible — but then the chosen option (i)-light should not be sold as "concretisation"; it is a scheduling placeholder.

---

### Route: Piece (i.b) Step 2 closure path (Route (b) inverse-direction-via-adjunction-transpose; 3 sub-sorries remain)

(Re-verification of standing verdict)

- **Goal-alignment**: PASS — base-change-of-differentials `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` is what the shear-iso globalisation consumes.
- **Mathematical soundness**: PASS — universal-property-at-presheaf-level via `PresheafOfModules.isoMk` is the correct route given `relativeDifferentialsPresheaf` is a presheaf, not a sheaf; the chart-affine-cover-and-glue alternative is foreclosed by `PresheafOfModules.pullback`'s `.obj`/`.map` opacity.
- **Sunk-cost reasoning detected**: no on the route itself; the strategy explicitly preserves trigger (a') and renormalised the LOC arm 600 → 1000 LOC with documented arithmetic.
- **Phantom prerequisites**: per the iter-137 analogist, `PresheafOfModules.pullback` exists but is opaque; helpers `Algebra.IsPushout`-from-affine-product and a pullback-unfolding helper are gap-fill (~110–210 LOC factorable). These are gap-fill, not phantoms.
- **Effort honesty**: reasonable — the iter-137 envelope (~360–710 LOC for Step 2 alone, with helpers factored) replaced the iter-133 150–300 LOC envelope; that revision is the only envelope widening on the four consults and is correctly named as such.
- **Verdict**: SOUND, with a watchpoint

**Watchpoint**: the build is now 5 sub-pieces (Step 1 DONE, Step 2 d_add + d_mul DONE, Step 2 d_app + d_map + IsIso REMAINING, Step 3 DONE iter-136, Main iter-138+). That's 3 substantive sub-sorries in Step 2 alone, plus an assembly step ahead. The iter-140 binding criterion ("close ≥2 of 3 sub-sorries OR CHURNING") is appropriate; do not absorb a "1 of 3 + the assembly step" outcome as success without re-running the trigger.

---

### Route: M3 user-escalation framing (still off-critical-path)

(Re-verification of standing verdict)

- **Goal-alignment**: PASS — the user-hint absorption ("do the work, no axioms") settled the iter-124 escalation in favor of option 1; M3 will land in-tree against the protected signature, not via axiom.
- **Mathematical soundness**: PASS — Route A (Picard via FGA) is the canonical mathematician's-instinct route; Route B (Sym^n + Stein + Brill–Noether–RR) is the canonical alternative; both ship the same `nonempty_jacobianWitness` body on the `genus C ≥ 1` arm.
- **Sunk-cost reasoning detected**: no on the M3 framing itself.
- **Phantom prerequisites**: yes — the iter-123 audit names every Route A and Route B top-3 piece as Mathlib-absent; that's accurate; the strategy treats them as roadmap items, not phantoms.
- **Effort honesty**: at the iter-123 audit level (6500–9000 LOC) this is honest, BUT see "Overall verdict" below for an honest **wall-clock** challenge.
- **Verdict**: SOUND for the sequencing decision (M2 first, M3 after), but see the OVERALL VERDICT challenge on end-state framing.

---

### Route: 5-piece pile (i)+(ii)+(iii)+(M2.a body)+(M2.b body + terminal-object cluster) under iter-127 over-k commitment

(Re-verification of standing verdict; 1850–3600 LOC / 9–20 iter for the pile alone)

- **Goal-alignment**: PASS — the pile closes M2.a body which closes M2.b which closes the genus-0 arm of `nonempty_jacobianWitness`.
- **Mathematical soundness**: PASS on (i)+(ii); CHALLENGE on (iii) — see "Effort honesty" below.
- **Sunk-cost reasoning detected**: no on the pile-shape itself; the strategy preserves the named-gap-sorry alternative for piece (iii) as ACTIVE.
- **Phantom prerequisites**: `AlgebraicGeometry.Scheme.absoluteFrobenius` is named PHANTOM; the strategy correctly acknowledges Mathlib `b80f227` has nothing scheme-level; Stacks Tag 0CC4 is the canonical reference. The PHANTOM is honestly named.
- **Effort honesty**: CHALLENGE — Piece (iii) at 800–1500 LOC for scheme-level absolute Frobenius is plausibly UNDER-counted. Stacks Tag 0CC4 → Lean is not a 1:1 LOC transfer; Mathlib idiom alignment for a new scheme-level functor typically inflates 2–3× over the Stacks prose. A more honest estimate is 1200–3000 LOC. The strategy's own iter-128 revision (300–600 → 800–1500) acknowledged this kind of revision is needed; another revision is plausibly due.
- **Verdict**: CHALLENGE

**Recommendation**: schedule an iter-141+ piece-(iii) **scoping analogist** (in addition to the already-scheduled "no-Frobenius / higher-Kähler-vanishing alternative" analogist) to render an honest LOC estimate for scheme-level `absoluteFrobenius`, with explicit idiom-alignment cost included. If the revised estimate exceeds 2000 LOC, the named-gap-sorry alternative ("recorded as an active alternative" per Edit 4 of iter-139) should be elevated from active-alternative to preferred-default.

---

### Route: Piece (iii) named-gap-sorry as ACTIVE alternative (iter-139 in-line clarification)

(Re-verification of iter-139 standing verdict)

- **Goal-alignment**: PARTIAL — this is the ONLY route where the protected `nonempty_jacobianWitness` chain would fail the zero-sorry end-state. The strategy treats this as compatible with the zero-sorry commitment; it isn't.
- **Mathematical soundness**: PASS — naming a gap-sorry with blueprint documentation is mathematically honest and downstream-consumer-trackable.
- **Sunk-cost reasoning detected**: no — the iter-139 honest-acknowledgement language ("the in-tree-build commitment is switching-cost + zero-sorry-end-state-commitment-driven, NOT a 'in-tree is cheaper' decision") is candid.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable for the alternative itself (~0 LOC + 0 iter).
- **Verdict**: SOUND as honest hedging, NOT rhetorical escape hatch. The gating criterion ("if iter-141 piece (i.c) closure + iter-143 piece (ii) closure return PARTIAL across 2+ iters, the iter-144+ plan agent MUST re-open this decision") is concrete, falsifiable, and pre-committed. This is the right shape.

**Internal contradiction flag**: the strategy holds simultaneously
- End-state: "zero inline `sorry` in the project" (line 32)
- Active alternative: "named-gap sorry IS the cheaper escape hatch... recorded as an active alternative, not a stall fallback" (line 449)

These are not compatible without qualification. If the named-gap alternative actually fires, the end-state changes from "zero-sorry" to "zero-sorry-except-one-named-gap." The strategy should EITHER:
- (a) state plainly that the zero-sorry end-state is *provisional on piece (iii) closing in-tree*; OR
- (b) downgrade the named-gap alternative to a hard fallback that requires user re-escalation (mirroring the iter-122 named-axiom rejection precedent).

Currently the strategy reads both as compatible by tone. They are not. The fresh-reader test fails here.

---

## Alternative routes (suggested)

### Alternative: scoping analogist on scheme-level absolute Frobenius (piece (iii))

- **What it looks like**: dispatch a mathlib-analogist explicitly to scope `AlgebraicGeometry.Scheme.absoluteFrobenius` against Mathlib `b80f227` BEFORE the iter-144+ in-tree commitment. Inputs: Stacks Tag 0CC4 prose, Mathlib's `Mathlib.Algebra.CharP.Frobenius` ring-side baseline, and the existing scheme-side functoriality conventions in `Mathlib.AlgebraicGeometry.Scheme.Functor`. Output: a per-sub-piece LOC estimate with idiom-alignment cost broken out.
- **Why it might be cheaper or sounder**: the strategy currently has a flat 800–1500 LOC estimate with no sub-piece breakdown for piece (iii). Compared to piece (i.b) — which the project has scoped through TWO analogist consults (iter-133, iter-137) yielding a 4× envelope revision — piece (iii) is scoped at half a sentence in the analogy. The iter-127 analogist's analysis was about base-agnosticism, not LOC. A dedicated scoping analogist would either (a) confirm 800–1500 is honest (validates the in-tree commitment); or (b) revise upward, triggering the named-gap alternative earlier. Either outcome is strictly informative.
- **What the current strategy may have rejected**: the strategy line 449 schedules iter-135–138 dispatches for a "no-Frobenius / higher-Kähler-vanishing alternative" and a "ℙ¹-specific rigidity hedge"; the ℙ¹ hedge returned NOT-VIABLE iter-138. The higher-Kähler-vanishing analogist appears to have NOT YET been scheduled into iter-140's plan (the line says "iter-140+" but does not name a slot). It should be scheduled this iter.
- **Severity of the omission**: major — under-scoped piece (iii) is the largest LOC risk on the M2 critical path.

---

### Alternative: explicit fail-fast escape on the entire zero-sorry end-state

- **What it looks like**: re-frame the project's stated end-state from "zero inline `sorry`" to "zero inline `sorry` modulo at most one named-gap on a Mathlib-canonical piece (e.g. scheme-level absolute Frobenius, Serre duality, or Brill–Noether–RR) whose upstream-PR work is concurrently in progress." This is what the M1.d precedent ALREADY does for the project (the bridge declaration was excised; the PR work continues off-loop), and what the iter-139 piece-(iii) alternative ALREADY contemplates without renaming the end-state.
- **Why it might be cheaper or sounder**: the strategy currently risks an end-of-project state where 9–20 months of iter-by-iter loop work cannot conclude because the last piece is a 1500–3000 LOC scheme-level Frobenius construction that doesn't close. The named-gap escape is cheaper. The honest end-state should match the honest available exits.
- **What the current strategy may have rejected**: per line 386–397, the named-axiom alternative is rejected by the iter-122 standing rule + the iter-126 user hint. **The user hint cites specifically the M3 case, NOT every piece.** A named-gap sorry on piece (iii) is materially different from a named-axiom on `nonempty_jacobianWitness`: the former leaves the project's protected chain depending on one project-internal scheme-level Frobenius declaration that documents a Mathlib gap; the latter axiomatises the witness. The strategy's iter-138 "user-hint citation discipline" rule (line 398) literally says the hint applies "on its actual scope (M3 disposition + the no-axiom rule generally)." Named-gap sorry on piece (iii) is in the gray zone the discipline rule was written to govern; the strategy should apply that rule to itself here.
- **Severity of the omission**: major — the gap between stated end-state and available exits is a clean fresh-context find.

---

### Alternative: in-loop scaffold of Relative Spec functor

- **What it looks like**: in iter-141 or iter-142 (in parallel with continued piece (i.b) Step 2 work), dispatch a refactor lane that scaffolds `Mathlib.AlgebraicGeometry.RelativeSpec` in a new file `AlgebraicJacobian/RelativeSpec.lean` with one sorry-bodied declaration. This makes the Edit-3 "off-loop PR lane" concretely on-loop, mirroring the iter-127 `genusZeroWitness` + iter-134 `positiveGenusWitness` precedents.
- **Why it might be cheaper or sounder**: addresses the Edit-3 CHALLENGE directly. The cost is 1 iter of refactor work for a +1 project sorry (~20 LOC scaffold). The scaffold UNLOCKS in-loop work on Relative Spec functor whenever any prover lane in the wait-window has spare capacity. The current "off-loop only" framing forecloses this option.
- **What the current strategy may have rejected**: per line 570, option (i)-full was rejected on "doubles complexity." Option (i)-light scaffold-only (no further dispatch until M2 closes) is intermediate; the rejection note doesn't reach it.
- **Severity of the omission**: minor — alone, this is a scope decision more than a strategic one; in combination with the Edit-3 CHALLENGE it becomes material.

---

## Sunk-cost flags

- `"the strategy adopts the iter-137 REBUTTED-WITH-SCOPE-NOTE alternative #3 substantively (not just at the language level): the over-k path is the **operational default** — not because we have a strong positive case for it, but because we have been building there, the switching cost back to over-`k̄` is concrete (~1 iter), and the revert wiring is in place." (line 520)`
  - Why this is sunk-cost: the explicit basis for continuation is "we have been building there" + "switching cost." That IS sunk-cost in the textbook sense.
  - Recommendation: **already partially absorbed** — the strategy names it as such and binds a falsifiable iter-140 trigger. The right additional step is to ensure the iter-140 plan agent applies the trigger arms fully on the iter-140 prover result; if iter-140 returns 1-of-3 closed AND >900 LOC cumulative, both arms point to CHURNING and the plan agent must re-open the over-k vs over-`k̄` question, NOT absorb-and-extend.

- `"this off-loop lane concretises the project's 'zero-sorry end-state' commitment for M3 — it is not pure wait-and-see post-M2-closure." (line 570)`
  - Why this is sunk-cost: the off-loop lane has no concrete iter-deliverables, no in-tree declaration, no scaffold; the "concretisation" claim is rhetorical relative to the lane's actual contents. Reads as zero-sorry-end-state-commitment-driven framing (we need to show progress on M3 to defend the zero-sorry commitment, so we name a lane).
  - Recommendation: drop the "concretises" framing OR add a concrete in-loop scaffold (per Alternative #3 above).

- `"M3 (positive-genus witness): ... ~6500–9000 LOC may not be that much for an AI." (lines 571–580, restating iter-126 user hint as still-binding)`
  - Why this is potentially sunk-cost-adjacent: the user-hint citation discipline rule (line 398) says the hint applies "on its actual scope (M3 disposition + the no-axiom rule generally)" and that "each in-tree expensive build (e.g. scheme-level absolute Frobenius for piece (iii)) must justify itself **on the merits of the local LOC/iter trade-off** vs alternatives, not by appeal to the user hint as a blanket." Applied honestly to piece (iii)'s 800–1500 LOC (possibly 1500–3000 LOC), the local LOC/iter trade-off vs named-gap (~0 LOC + 0 iter) does NOT favor in-tree on its own merits — the in-tree commitment is then explicitly the "zero-sorry-end-state-commitment-driven" + "switching cost" decision the strategy admits.
  - Recommendation: the strategy's iter-139 piece-(iii) clarification already does this work for piece (iii); apply the same honesty to the end-state framing as a whole (per Alternative #2).

---

## Prerequisite verification

I deliberately did not run LSP queries this iter — the strategy already chains through iter-129 (`IsLocalRing.CotangentSpace` verified, `IsRegularLocalRing.cotangentSpace` named PHANTOM and corrected), iter-133 (`mulRight_globalises_cotangent` template `CategoryTheory.GrpObj.mulRight` verified), iter-137 (`PresheafOfModules.pullback` opacity verified), iter-138 (`Algebra.FormallyUnramified.of_isLocalization`, `KaehlerDifferential.exact_mapBaseChange_map`, `Differential.ContainConstants` instance-scope verified). The Mathlib infrastructure named in STRATEGY.md is in good shape; the only PHANTOM still flagged is `AlgebraicGeometry.Scheme.absoluteFrobenius`, which the strategy correctly names as PHANTOM-to-be-built.

- `IsLocalRing.CotangentSpace`: VERIFIED (per iter-129).
- `IsRegularLocalRing.cotangentSpace`: PHANTOM, correctly corrected to the above.
- `KaehlerDifferential.tensorKaehlerEquiv`: VERIFIED (per iter-137).
- `KaehlerDifferential.exact_mapBaseChange_map`: VERIFIED (per iter-126, iter-138).
- `KaehlerDifferential.map_surjective`: VERIFIED.
- `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED.
- `PresheafOfModules.pullback`: VERIFIED (exists; `.obj`/`.map` opaque, needs unfolding helper).
- `PresheafOfModules.isoMk`: VERIFIED.
- `Differential.ContainConstants`: VERIFIED (typeclass exists; the project's iter-138 analogist correctly identified that the only registered instance scope is differential-field-extension, not commutative-algebra-general — path (a) was scoped-rejected for this reason; path (b) `KaehlerDifferential.D` chosen).
- `Mathlib.Algebra.CharP.Frobenius`: VERIFIED.
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: **PHANTOM** (correctly named; Mathlib `b80f227` has nothing scheme-level for Frobenius; Stacks Tag 0CC4 is the construction reference).
- `Mathlib.AlgebraicGeometry.RelativeSpec`: PHANTOM (Edit-3 names it correctly; ~700–1100 LOC PR-extraction target).
- `Mathlib.AlgebraicGeometry.Hilbert.Representability`: PHANTOM (M3 Route A piece 1).
- `Mathlib.AlgebraicGeometry.SymmetricPower`: PHANTOM (M3 Route B piece 1).

---

## Must-fix-this-iter

- **Route Edit-2 (5-consult threshold)**: CHALLENGE — the strategy should either drop the consult-count arm in favor of envelope-widening alone, OR explicitly mark the consult-count threshold as "current-state calibration, revisit-if-not-fired-by-iter-150." Apply the iter-138 renormalisation-discipline rule (line 398–399) to this new rule too.

- **Route Edit-3 (M3 Route A Relative Spec off-loop PR lane)**: CHALLENGE — the lane as currently scoped does not "concretise the zero-sorry commitment." Either drop that framing OR scaffold the declaration in-tree (Alternative #3 above; ~1 iter / +1 project sorry / ~20 LOC).

- **Route 5-piece pile, piece (iii)**: CHALLENGE — schedule a dedicated piece-(iii) scoping analogist (Alternative #1 above) into iter-141 or iter-142 to render an honest LOC estimate for scheme-level `absoluteFrobenius`; if revised estimate exceeds 2000 LOC, elevate the named-gap-sorry alternative from active-to-preferred-default.

- **Piece (iii) named-gap-sorry / zero-sorry end-state contradiction**: CHALLENGE — the strategy holds "zero-sorry end-state" + "named-gap is an active alternative" as compatible. They are not without qualification. Add explicit end-state-qualification language (Alternative #2 above): either name the zero-sorry as provisional on piece (iii) closing in-tree, OR re-classify named-gap as a hard fallback requiring user re-escalation.

- **Sunk-cost flag on Edit-3 framing**: must-fix as part of the Edit-3 CHALLENGE absorption (same edit, two angles).

- **Watchpoint on Edit-1 (iter-140 trigger application)**: not a must-fix on STRATEGY.md but a must-apply for the iter-140 plan agent — apply BOTH arms of the iter-140 binding criterion (sub-sorry count AND cumulative LOC under 1000), and treat 1-of-3-closed + cumulative-LOC-overrun as CHURNING-trigger fire, not as an absorbable partial. The risk is the sub-sorry-count arm closing favorably while the LOC arm fires — partial-renormalisation here would resurrect the failure mode the iter-138 discipline rule was written for.

---

## Overall verdict

The strategy is internally coherent, well-versed in its own sunk-cost flags, and has the right shape of falsifiable per-iter triggers. The iter-138 reframing of over-k as "operational default with bounded revert" is the most honest framing the strategy has carried; the iter-139 §519 auto-flag execution is well-shaped; the iter-139 piece-(iii) named-gap honest-acknowledgement is candid. These are all improvements.

**Three material concerns a fresh mathematician would raise:**

1. **The zero-sorry end-state vs named-gap escape contradiction.** The project claims zero-sorry while simultaneously naming a "cheaper escape hatch" (named-gap on piece (iii)). The two are presented as compatible but cannot be without qualification. Either zero-sorry is provisional or the named-gap is a hard fallback; the strategy must pick one. Currently it has it both ways.

2. **The wall-clock honesty problem.** The strategy says "multi-month away" for M2 closure (line 586). Doing the arithmetic: piece (i.b) iter-134→iter-138 (slipping); piece (i.c) iter-137+; piece (ii) iter-141+; piece (iii) iter-144+ (4–7 iter or revised); M2.a body iter-151+; M2.b body iter-153–156; M2 closure iter-157+. That's 17+ iters from iter-140 to M2 closure. Then M3 starts at 6500–9000 LOC at typical 50–100 LOC/iter sustained — that's 65–180 more iters. Total: 82–197 iters to zero-sorry, **under no-slippage assumptions**. At sustainable pace that's 9–24 months wall-clock. The "multi-month" framing under-states by 5–10×. A fresh reader who picked up the project today and was promised "multi-month" would be misled. **The honest end-state framing is multi-year.**

3. **Edit-3 framing.** The "off-loop PR lane concretises the zero-sorry commitment" claim is the most sunk-cost-shaped sentence in the iter-139 edits; the lane has no in-tree deliverable; the framing is rhetorical. This is the cleanest fix among the three iter-139 edits.

Beyond those three: piece (iii)'s LOC estimate is plausibly under-counted; a scoping analogist would resolve it cheaply. The 5-consult threshold is a procedural fix that needs minor sharpening. The Edit-1 §519 reframing is the strongest of the iter-139 edits and needs no fix beyond the iter-140 application discipline.

**Net**: SOUND on Edits 1 with watchpoint, CHALLENGE on Edits 2 + 3, plus two carry-forward CHALLENGES on piece (iii) and on end-state framing. Routes audited: 7 (3 iter-139 edits + 4 standing). CHALLENGE/REJECT verdicts: 4 CHALLENGEs, 0 REJECTs.

A fresh mathematician would approve the strategy as a multi-year roadmap with honest provisional language and concrete falsifiable triggers — once the four CHALLENGEs above are absorbed.
