# Strategy Critic Report

## Slug
iter139

## Iteration
139

## Routes audited

### Route: M1 (presheaf↔algebra-Kähler bridge) — EXCISED iter-126

- **Goal-alignment**: PASS — the excise removed a parked sorry with zero in-tree consumers and preserved the M1.d Mathlib-PR candidate as a standalone utility. No protected declaration is downstream of M1.
- **Mathematical soundness**: PASS — kaehler_quotient_localization_iso is a standalone Kähler-side fact, properly typed; its preservation is independent of the deleted bridge.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — the iter-126 strategy-critic conversation set the excise on honest grounds.
- **Verdict**: SOUND.

### Route: M2.a — over-k rigidity (`rigidity_over_kbar`/`rigidity_over_k` body)

- **Goal-alignment**: PASS — the over-k argument is k-agnostic in signature; it composes with `genusZeroWitness` on both the C(k) ≠ ∅ (apply rigidity) and C(k) = ∅ (vacuity) branches.
- **Mathematical soundness**: PASS in principle — the shear-iso + functorial-globalisation + scheme-level df=0 + Frobenius-iteration argument is a recognised proof shape over any base field. The iter-127 over-k analogist verdict (`cotangent-vanishing-pile-over-k.md`) is independently checkable on the math.
- **Sunk-cost reasoning detected**: yes — see flag #1 below ("over-k operationally defaulted").
- **Phantom prerequisites**: `AlgebraicGeometry.Scheme.absoluteFrobenius` is genuinely absent from Mathlib `b80f227` (verified iter-128, re-verified iter-138 by the ℙ¹-hedge analogist). The strategy treats this as a project-internal build target rather than a phantom, which is the honest framing.
- **Effort honesty**: reasonable but at the upper end — the 1850–3600 LOC / 9–20 iter envelope for pieces (i)+(ii)+(iii) is plausible, but the cumulative analogist count on piece (i.b) alone (4 consults across 8 iters: iter-133 mulright-globalises, iter-135 phi-compatibility, iter-137 kaehler-tensorequiv, iter-140 IsIso closure scheduled) is a route-difficulty smoke signal that the envelope may still be under-counted.
- **Verdict**: CHALLENGE — the route itself is mathematically sound, but the iter-138 conditional ground-extension auto-flag has fired (PARTIAL on Step 2), and the iter-139 plan phase MUST conduct the explicit re-discussion the strategy promised. See must-fix below.

### Route: M2.b — `genusZeroWitness` body

- **Goal-alignment**: PASS — the construction returns a `JacobianWitness C` with underlying scheme `Spec k`. The vacuity-branch verification (§178–184) is sound on the protected signature; Lean's universally quantified `∀ P, IsAlbanese …` is vacuously true when `𝟙_ _ ⟶ C` is empty.
- **Mathematical soundness**: PASS — modulo the terminal-object instance cluster (iter-130 Q5 under-count revision is honest) and the dependency on M2.a closure.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: terminal-object instance cluster on `Spec k` (`GrpObj`, `SmoothOfRelativeDimension 0`, `IsProper`, `GeometricallyIrreducible`) is named honestly; some pieces will likely turn out to be Mathlib-derivable but the strategy doesn't gamble on it.
- **Effort honesty**: reasonable per the iter-130 revision.
- **Verdict**: SOUND.

### Route: M2.body-pile pieces (i.a)/(i.b)/(i.c)/(ii)/(iii) — the cotangent-vanishing pile

- **Goal-alignment**: PASS — the pile gates M2.a body; M2.a gates M2.b body via `rigidity_over_k`; M2.b feeds the genus-0 arm of the eventual `nonempty_jacobianWitness` body restructure.
- **Mathematical soundness**: PASS for pieces (i.a)+(i.b)+(i.c) (iter-132/iter-133/iter-137 analogist verifications are detailed); PASS for piece (ii) given the iter-138 `containConstants-iter138` PIN-path-(b) verdict; PROVISIONAL for piece (iii) since the in-tree build of scheme-level absolute Frobenius is a genuinely large infrastructure piece with no prior Mathlib precedent.
- **Sunk-cost reasoning detected**: yes — see flag #2 below (fibre-free 4-axis re-eval gate underuses the iter-138 PARTIAL signal).
- **Phantom prerequisites**: `AlgebraicGeometry.Scheme.absoluteFrobenius` (still phantom, in-tree build budget 800–1500 LOC).
- **Effort honesty**: under-counted on cumulative analogist overhead — 4 consults on piece (i.b) Step 2 over iter-133→iter-140 indicates the route's design-cost is significant beyond the 360–710 LOC envelope. The strategy should be honest that "analogist overhead" is a non-trivial axis of cost.
- **Verdict**: CHALLENGE — the iter-139 plan ("close d_app + d_map in one prover lane; dispatch a mathlib-analogist on Route (a) vs Route (b'2) for IsIso closure in iter-140") is locally sound, BUT the strategy must explicitly reconcile the iter-138 PARTIAL with the §519 auto-flag obligation (see must-fix).

### Route: M2.body-pile piece (iii) PR-extraction lane (iter-138 decision)

- **Goal-alignment**: PASS — scheme-level absolute Frobenius is canonical Mathlib infrastructure (Stacks 0CC4); PR-extraction mirrors the M1.d precedent.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: yes — see flag #3 below.
- **Phantom prerequisites**: none beyond the build itself.
- **Effort honesty**: the PR-extraction lane itself is small (off-loop work). The framing "PR lane opens iter-144+ alongside the in-tree build (no further deferral)" presupposes the in-tree build proceeds; the strategy elides whether an upstream-first PR strategy (draft PR, wait, then consume) would be more efficient than in-tree-first.
- **Verdict**: SOUND on the PR lane question itself. The decision that's actually in question is "in-tree build of piece (iii) at 800–1500 LOC", not the PR extraction.

### Route: M3 — `positiveGenusWitness` (Route A Picard vs Route B Sym^n+Stein)

- **Goal-alignment**: PARTIAL — the strategy treats M3 as "user-escalation-pending" with a 100+ iter / 10000+ LOC budget. The project's stated end-state is "zero inline `sorry` in the project"; the positive-genus arm of `nonempty_jacobianWitness` REQUIRES `positiveGenusWitness` to close, but the strategy has no iter-by-iter critical-path schedule for M3. The iter-126 user-hint "do the work" was absorbed in option-1-choice form, but no concrete iter-NNN+ commitment has been made.
- **Mathematical soundness**: PASS — Route A (FGA) and Route B (Sym^n) are both recognised constructions; the iter-123 audit was honest about LOC totals.
- **Sunk-cost reasoning detected**: no, but the absence of a credible iter-by-iter plan is a goal-alignment gap, not a sunk-cost issue.
- **Phantom prerequisites**: 6 of the 6 top-3-gating-pieces (Hilbert representability, Quot representability, identity-component construction; Sym^n schemes, Stein factorisation, RR+Brill-Noether). All named honestly.
- **Effort honesty**: reasonable in the LOC count; dishonest in the schedule (the strategy says "M3 stays off the iter-by-iter critical path until M2 has closed" but has no plan for what happens when M2 does close — M2 closure is iter-157+ per current schedule; then M3 wakes up needing a route pick, mountain of upstream-PR work, and the user-hint cited is itself bounded per the §398 citation-discipline rule).
- **Verdict**: CHALLENGE — the strategy treats M3 as a deferred user-escalation, but the protected `Jacobian` declarations chain through `nonempty_jacobianWitness`'s positive-genus arm. The strategy needs either (i) a credible iter-by-iter plan for at least Route A's smallest gating piece (relative Spec functor, 700–1100 LOC; the iter-123 audit's top extractable PR), or (ii) explicit acknowledgement that the project's zero-sorry end-state is unreachable on the autonomous loop and re-escalation to the user is the only path, NOT "wait for M2 to close, then escalate".

### Route: STRATEGY.md iter-138 edits — re-verification

#### Edit 1 (§399 LOC trigger arm renormalisation discipline)

- **Constrains the planner**: YES, weakly. The rule forbids LOC-cap renormalisation without a NEW analogist consult and forbids partial renormalisation. The discipline operated correctly iter-137→iter-138 (the (a')/(c) revert cap 600→1000 LOC and the fibre-free 750→1000 LOC pivot threshold renormalised together, anchored to the iter-137 `kaehler-tensorequiv-presheafpullback-iter137` consult).
- **Weakness**: the rule has no "documented arithmetic" format requirement and depends on the strategy-critic dispatch each iter to enforce it. A planner could renormalise by gesturing at an existing analogist's number without showing the calculation. Recommend a one-line arithmetic format: `<new cap> = <baseline LOC at trigger arm-write> + <envelope upper bound from analogist X> + <slack %>`.
- **Verdict**: SOUND but soft; a minor format addition would tighten enforcement.

#### Edit 2 (fibre-free pivot 750→1000 LOC + iter-138-close 4-axis MUST re-eval)

- **Trigger arithmetic reconciles**: YES on the renormalisation. The iter-138 measured cumulative ~408 LOC (~92 LOC body + ~50 LOC docstring + ~266 LOC iter-134→iter-137 baseline) is well below the new 1000 LOC cap AND below the old 750 LOC cap, so the renormalisation did not retroactively rescue a fire; both thresholds give "no pivot".
- **The 4-axis re-eval MUST fire iter-139**: YES per §534 ("iter-138-close 4-axis re-evaluation MUST per `strategy-critic-iter138` Alternative #3 elevation from 'may'"). The plan agent should run the scorecard with the MEASURED ~408 LOC cumulative (NOT projected). The conditional unconditional-fire trigger ("axis (1) LOC > 1000 LOC cap OR > 70% of 810 envelope upper bound") evaluates at 408 LOC < 567 (70% × 810) < 1000 — so the unconditional fibre-free re-evaluation does NOT fire; the 4-axis scorecard re-run is still required but is expected to confirm STAY ON (B).
- **Edge concern**: the iter-138 prover returned PARTIAL with 3 remaining sub-sorries (d_app, d_map, IsIso). The strategy's "MEASURED Step 2 body+helpers LOC" instruction is ambiguous on whether to count Step 2 against its CURRENT skeleton state (~92 LOC body) or against its eventual closed state (still ~300–500 LOC by projection). The plan agent should be explicit about which measurement is used; using the skeleton state gives a falsely-comfortable scorecard.
- **Verdict**: SOUND with the must-fix above.

#### Edit 3 (over-k reframing as "operationally defaulted, bounded revert cost preserved")

- **Auto-flag gate fires iter-139**: YES. §519 states "if iter-138 returns PARTIAL again, ground (iv) stays scope-narrow and the cumulative weight of 'single piece of empirical tractability evidence after 11 iter of build' warrants explicit re-discussion in iter-139 plan phase (not auto-revert, but auto-flag)."
- **What the re-discussion should produce** (this is the iter-139 obligation):
  1. Explicit acknowledgement that after 11 iters of over-k build (iter-128→iter-138), ground (iv) is still scope-narrow to piece (i.a) tractability — pieces (i.b), (i.c), (ii), (iii) tractability over k remains empirically untested.
  2. Explicit position on whether (a) to revert to over-`k̄` + restore M2.c (cost ~1 iter + restoration), or (b) to remain on over-k with explicit acknowledgement that the empirical evidence is still single-piece.
  3. A NAMED criterion for the next re-discussion (e.g., "if iter-141 piece (i.b) Step 2 closes substantively, ground (iv) extends to (i.a)+(i.b); if iter-141 returns PARTIAL again, the auto-flag fires again with stricter language").
- **Verdict**: SOUND framing; the iter-139 plan agent must execute the auto-flag obligation explicitly, not absorb it silently. This is the iter-139 must-fix.

#### Edit 4 (piece (iii) upstream-PR-extraction lane named, iter-138 ℙ¹-hedge analogist)

- **Sound given NOT-VIABLE verdict**: YES on the PR-lane question. The hedge being NOT-VIABLE confirms scheme-level absolute Frobenius must be built in-tree (no Mathlib compression route); the PR-extraction lane mirrors the M1.d precedent and is structurally clean.
- **What the strategy elides**: the iter-138 analogist's actual recommendation (line 211–218 of `p1-hedge-genus-zero-witness.md`) was "if the cotangent pile stalls on (iii) at iter-140+, the cheaper escape hatch is to keep `rigidity_over_kbar` as a named-gap sorry in the same family as `serre_duality_genus`." The strategy mentions this only as a stall fallback (§538), not as a strategic option to evaluate proactively. The PR lane is sound; what's NOT proactively addressed is whether 800–1500 LOC of in-tree absolute-Frobenius construction is within the project's autonomous-loop scope, given (a) the §398 user-hint citation-discipline bounds the "do the work" license to M3, and (b) the iter-138 analogist explicitly named the named-gap-sorry as the cheaper alternative.
- **Verdict**: SOUND on the PR lane question itself; CHALLENGE on the elision of the named-gap-sorry alternative for piece (iii) (see flag #3 below).

## Alternative routes (suggested)

### Alternative: Direct chart-algebra rigidity bypassing piece (i.b)/(i.c) global trivialisation

- **What it looks like**: instead of trivialising `Ω_{A/k}` globally via the shear-iso + functorial-globalisation pipeline (pieces (i.b)+(i.c)), prove rigidity directly at the chart-algebra level. Given `f : C → A` with `df = 0`, for each affine chart `Spec B → Spec A_loc` of `A`, restrict `f^#` to the chart, use `Algebra.IsStandardSmoothOfRelativeDimension n (Spec k) A_loc`'s Kähler-freeness, conclude `f^#` factors through `k` on the chart-algebra level, glue across charts via the project's existing `Scheme.Over.ext_of_eqOnOpen`. This bypasses the need for a global free-module isomorphism on `Ω_{A/k}`.
- **Why it might be cheaper or sounder**: piece (i.b)+(i.c) total ~810–1540 LOC; the direct chart-algebra route is plausibly ~300–600 LOC (the Kähler-freeness of standard-smooth algebras is already in Mathlib as `Algebra.IsStandardSmooth.free_kaehlerDifferential`). The savings come from not constructing the global free-module identification — only its chart-restricted consequence is used in the rigidity argument.
- **What the current strategy may have rejected**: the strategy frames the cotangent pile as "trivialise Ω_A → push to chart-algebra Kähler → df=0 → factor through k → glue" — a global-then-local pipeline. The alternative is a local-only pipeline. The strategy may have implicitly rejected this on grounds that the `Differential` framing wants a globally-trivial `Ω_A` for downstream consumers (Lie-algebra dual; speculative future consumers); but the iter-134 `strategy-critic-iter134` CHALLENGE 2 already flagged axis (4) "downstream API shape" as speculative-consumer-driven and recommended downgrading it. By that downgrade, the local-only alternative is competitive.
- **Severity of the omission**: major — the strategy commits to a 810–1540 LOC sub-route without comparison to a plausibly half-cost local-only alternative. An iter-139 mathlib-analogist consult on "can piece (i.b)+(i.c) be bypassed by direct chart-algebra rigidity?" would be cheap and could redirect substantial future LOC.

### Alternative: Named-gap sorry for piece (iii) (scheme-level absolute Frobenius), proactive evaluation

- **What it looks like**: instead of in-tree building scheme-level absolute Frobenius at 800–1500 LOC, accept `frobenius_iteration_descends_to_constants` (or whatever the eventual Lean name is) as a named gap with explicit blueprint documentation, in the same family as `analogies/serre-duality.md`'s recommended named-gap-deferral pattern. The `rigidity_over_kbar` body would then have one residual named gap for piece (iii), with M2.b composition gated on it.
- **Why it might be cheaper or sounder**: the iter-138 analogist explicitly recommended this as the cheaper escape hatch. The strategy's "zero inline `sorry` in the project" end-state would have to be relaxed for this route — but the §398 user-hint citation-discipline rule already bounds the "do the work" license to M3, not to piece (iii). A named-gap-sorry for piece (iii) is consistent with the §398 scope.
- **What the current strategy may have rejected**: the iter-121 pivot to "zero inline sorry" appears to forbid this option globally. But the strategy hasn't reconciled iter-121's zero-sorry pivot with iter-138's empirical finding that piece (iii)'s in-tree cost is 800–1500 LOC AND the alternative hedge is NOT-VIABLE. A fresh reader sees a tension: zero-sorry end-state vs. a piece whose only paths are 800–1500 LOC in-tree build or 1500–3000 LOC hedge — neither of which has a credible iter-by-iter schedule within the M2 iter-157 closure target.
- **Severity of the omission**: major — the strategy should explicitly weigh "in-tree 800–1500 LOC piece (iii) + zero-sorry end-state preserved" against "named-gap sorry for piece (iii) + relax end-state for this specific piece, document in blueprint", with the iter-138 analogist's recommendation as the explicit pro-named-gap evidence.

### Alternative: Upstream-first PR strategy for piece (iii), not in-tree-first

- **What it looks like**: draft an upstream Mathlib PR for `AlgebraicGeometry.Scheme.absoluteFrobenius` (Stacks 0CC4, canonical infrastructure) ahead of the in-tree build, work with Mathlib reviewers on the signature, and consume the merged result in-tree. The PR turnaround is unpredictable, but for canonical infrastructure the upstream review usually accelerates the design.
- **Why it might be cheaper or sounder**: the in-tree-build-then-PR-extract pattern (M1.d precedent) is appropriate for declarations whose in-tree-first design might diverge from canonical Mathlib idioms (which the M1.d off-loop work has been navigating since iter-126). For canonical infrastructure with Stacks-0CC4-level precedent, upstream-first avoids in-tree convention drift and gives the project a Mathlib-merged result to consume.
- **What the current strategy may have rejected**: PR turnaround unpredictability. The strategy explicitly assumes in-tree-first because the loop must make progress every iter. But the off-critical-path PR lane is already exempt from this constraint per the M1.d off-loop precedent.
- **Severity of the omission**: minor — the in-tree-first strategy is defensible, but the strategy doesn't articulate why M1.d's off-loop pattern doesn't extend to `absoluteFrobenius`. A one-paragraph explicit comparison would close this gap.

### Alternative: M3 Route A's smallest extractable PR piece (Relative Spec functor, 700–1100 LOC) as iter-139+ off-loop lane

- **What it looks like**: dispatch the iter-123 audit's top recommendation (Relative Spec functor) as an off-loop upstream-PR lane starting iter-139+, in parallel with M2 work. The strategy currently says M3 stays off the iter-by-iter critical path "until M2 has closed"; this could be relaxed to "off the iter-by-iter critical path of the PROVER, but on the off-loop PR lane parallel to M2".
- **Why it might be cheaper or sounder**: the 700–1100 LOC piece is the smallest extractable PR piece useful regardless of route, and the off-loop PR-extraction infrastructure (M1.d precedent) is in place. Starting it iter-139+ rather than iter-158+ buys 19 iters of upstream review turnaround.
- **What the current strategy may have rejected**: capacity ceiling on parallel off-loop lanes. The strategy doesn't explicitly cap parallel off-loop lanes; the M1.d lane is the only currently-active one.
- **Severity of the omission**: minor — but a clean upgrade to the M3 plan that addresses the credibility gap in the M3 verdict above.

## Sunk-cost flags

### Flag #1: Over-k "operationally defaulted, bounded revert cost preserved"

`Iter-138 reframing to "operationally defaulted, bounded revert cost preserved" (per `strategy-critic-iter138` Must-fix on over-k commitment language). … defaulting to over-k with explicit revert triggers is the lowest-friction path.` (§519)

- **Why this is sunk-cost**: the framing explicitly names the over-k commitment as switching-cost-driven ("ground (ii) honestly named as switching cost") and single-piece-tractability-driven ("ground (iv) … scope-narrow to piece (i.a)"). After 11 iters of build, the only positive evidence for over-k over over-`k̄` is "we've been building here". The §519 "auto-flag" gate is the correct meta-response, but the auto-flag itself relies on the iter-139 plan agent executing it — which the iter-139 critic is now asked to verify. If the iter-139 plan agent absorbs the PARTIAL silently, the auto-flag is dead-letter and the over-k commitment becomes pure sunk-cost.
- **Recommendation**: the iter-139 plan agent MUST execute the §519 auto-flag obligation: (i) explicit acknowledgement of single-piece tractability evidence after 11 iters; (ii) explicit position on revert vs continue with named criterion for the next re-discussion; (iii) the iter-139 plan agent's rebuttal — if the position is "continue with over-k" — must engage with the cumulative-evidence concern on its merits, not by appeal to switching cost.

### Flag #2: Cumulative analogist count on piece (i.b)

`Iter-133 mulright-globalises + iter-135 phi-compatibility + iter-137 kaehler-tensorequiv + iter-140 IsIso closure scheduled` (4 analogist consults across 8 iters on piece (i.b) Step 2 alone)

- **Why this is sunk-cost-adjacent (not flagrant sunk-cost)**: the strategy doesn't argue "we've already invested 4 analogists, so we must close piece (i.b)" — it argues that each analogist call addressed a distinct sub-question. That's not literal sunk-cost framing. But the cumulative analogist overhead is a route-difficulty smoke signal that should be weighed against alternatives (e.g., the direct chart-algebra rigidity alternative above). A strategy that requires N analogist consults per sub-piece × 5+ sub-pieces is paying a real overhead cost that should be explicit in the LOC envelope.
- **Recommendation**: the iter-139 plan should add an "analogist overhead" axis to the M2.body-pile cost accounting. If the cumulative analogist count crosses a threshold (say, 5 consults on a single sub-piece, or 3 consults that each widen the envelope), the route-pivot question should be re-raised with that as named evidence.

### Flag #3: Piece (iii) in-tree build commitment vs. iter-138 analogist's recommended named-gap-sorry alternative

`Piece (iii) WILL need to be built in-tree at 800–1500 LOC. The PR lane therefore opens iter-144+ alongside the in-tree build (no further deferral)` (line 448)

- **Why this is sunk-cost-adjacent**: the strategy elides the iter-138 analogist's explicit recommendation (line 211–218 of `analogies/p1-hedge-genus-zero-witness.md`) that the named-gap-sorry is the cheaper escape hatch. The strategy treats the in-tree build as the default and the named-gap-sorry as a "stall fallback", reversing the analogist's prioritisation. The framing "no further deferral" suggests the project is committing to the in-tree build because it has been building toward it, not because the in-tree build is the better strategic choice in isolation.
- **Recommendation**: the iter-139 plan should add an explicit subsection on piece (iii) routing: in-tree build (zero-sorry end-state preserved, 800–1500 LOC in-loop, multi-iter wait) vs. named-gap sorry (end-state relaxed for piece (iii) specifically, ~0 LOC, 0 iter, blueprint documents the gap). The iter-138 analogist's recommendation is the named pro-named-gap evidence; the §398 user-hint citation-discipline rule is the named-pro-in-tree evidence. The decision should be made on its merits, not by absorption.

## Prerequisite verification

- `KaehlerDifferential.tensorKaehlerEquiv` (Mathlib/RingTheory/Kaehler/TensorProduct.lean:249): VERIFIED — chart-level base-change-of-Ω equivalence under `Algebra.IsPushout`.
- `PresheafOfModules.isoMk` (Mathlib/Algebra/Category/ModuleCat/Presheaf.lean:118): VERIFIED — used by the iter-137 analogist's recommended 5-step recipe.
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED — Kähler-freeness on standard-smooth algebras, consumed by piece (i.c).
- `IsLocalRing.CotangentSpace`: VERIFIED — replaces the earlier phantom `IsRegularLocalRing.cotangentSpace`.
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: MISSING — confirmed iter-128 + iter-138; in-tree build target.
- `Differential.ContainConstants` (Mathlib/RingTheory/Derivation/DifferentialRing.lean:62): VERIFIED as Mathlib class, but only the trivial diagonal `ContainConstants A A` instance ships; non-trivial chart-algebra instances do NOT exist. The iter-138 `containConstants-iter138` analogist's PIN-path-(b) verdict correctly diverges from this typeclass.
- `Scheme.Hom.toRingCatSheafHom` (Mathlib/AlgebraicGeometry/Modules/Presheaf): VERIFIED — canonical φ for `PresheafOfModules.pullback` per the iter-135 phi-compatibility-morphisms analogist.

## Must-fix-this-iter

- **Route M2.body-pile pieces**: CHALLENGE — iter-139 plan MUST run the §534 4-axis re-evaluation explicitly with the MEASURED iter-138 Step 2 body+helpers LOC (state which measurement: skeleton ~92 LOC body vs. projected closure ~300–500 LOC; the strategy is ambiguous). The expected outcome is "STAY ON (B)" but the run must be visible in the iter-139 plan, not silent.
- **Route M2.a over-k re-discussion**: CHALLENGE — iter-139 plan MUST execute the §519 auto-flag obligation: (i) explicit single-piece-tractability acknowledgement, (ii) explicit position on revert vs continue, (iii) named criterion for the next re-discussion. Silent absorption of the PARTIAL fires sunk-cost flag #1.
- **Route M3 positive-genus**: CHALLENGE — the strategy needs either an iter-by-iter plan for M3's smallest gating piece (relative Spec functor) or explicit acknowledgement that zero-sorry end-state is unreachable on the autonomous loop. The current "wait for M2, then user-escalate" plan is incompatible with the iter-121 zero-sorry end-state commitment given the iter-123 6500-LOC midpoint estimate.
- **Alternative: Direct chart-algebra rigidity bypassing (i.b)/(i.c)**: major — strategy should commission an iter-139 mathlib-analogist consult on whether the local-only route can substitute for piece (i.b)+(i.c)'s 810–1540 LOC commitment. Cost: 1 iter, potentially saves multi-hundred LOC.
- **Alternative: Named-gap sorry for piece (iii)**: major — strategy should add an explicit subsection comparing in-tree-build vs named-gap-sorry for piece (iii) on its merits, not as stall fallback. The iter-138 analogist's recommendation must be addressed directly.
- **Sunk-cost flag #1 (over-k operationally defaulted)**: iter-139 plan agent must execute the §519 auto-flag explicitly. If the position is "continue with over-k", the rebuttal must engage with the cumulative-evidence concern on its merits, not by switching cost.
- **Sunk-cost flag #2 (analogist overhead)**: iter-139 plan should add an "analogist overhead" axis to M2.body-pile cost accounting.
- **Sunk-cost flag #3 (piece (iii) in-tree default)**: iter-139 plan must explicitly weigh in-tree vs named-gap-sorry on the merits per the iter-138 analogist's recommendation.

## Overall verdict

The strategy is operationally coherent and the iter-138 absorptions of the 4 strategy-critic challenges are well-formed; the local tactical pivots (Route (b) over Route (a) for piece (i.b) Step 2, the 4-axis re-eval gate, the LOC renormalisation discipline) are defensible. **But a fresh mathematician encountering this strategy would identify three structural concerns**: (i) the over-k commitment is operationally-defaulted on switching-cost + single-piece evidence, and the iter-139 plan phase MUST execute the §519 auto-flag re-discussion to avoid this becoming pure sunk-cost; (ii) piece (i.b)+(i.c)'s 810–1540 LOC commitment to global cotangent trivialisation has never been compared to a plausibly half-cost direct chart-algebra rigidity route; (iii) the project's zero-sorry end-state commitment vs piece (iii)'s 800–1500 LOC in-tree build (the iter-138 analogist's recommended cheaper alternative being a named-gap sorry) is an unaddressed tension that the strategy treats by burying the alternative as a "stall fallback". The M3 plan is the largest goal-alignment gap (no credible iter-by-iter schedule for ~10000 LOC of upstream-Mathlib work). The strategy should be approved with the seven must-fixes above and the M3 plan re-opened.
